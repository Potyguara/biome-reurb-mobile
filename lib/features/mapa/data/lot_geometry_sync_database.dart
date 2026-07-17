import 'package:drift/drift.dart';

import '../../../data/local/app_database.dart';

extension LotGeometrySyncDatabase on AppDatabase {
  Future<void> ensureLotGeometrySyncInfrastructure() async {
    await customStatement(
      '''
      CREATE TABLE IF NOT EXISTS lot_geometry_sync_state (
        local_id TEXT PRIMARY KEY,
        server_id TEXT,
        source_device_id TEXT,
        sync_status TEXT NOT NULL DEFAULT 'pending',
        sync_attempts INTEGER NOT NULL DEFAULT 0,
        sync_error TEXT,
        sync_version INTEGER NOT NULL DEFAULT 1,
        last_sync_attempt_at TEXT,
        synced_at TEXT,
        server_updated_at TEXT,
        deleted_locally INTEGER NOT NULL DEFAULT 0,
        updated_at TEXT NOT NULL
      )
      ''',
    );

    await customStatement(
      '''
      CREATE TABLE IF NOT EXISTS lot_geometry_remote_cache (
        server_id TEXT PRIMARY KEY,
        project_id TEXT NOT NULL,
        source_local_id TEXT NOT NULL,
        source_device_id TEXT NOT NULL,
        lot_id TEXT,
        seal_id TEXT,
        social_registration_id TEXT,
        origin TEXT NOT NULL,
        workflow_status TEXT NOT NULL,
        geometry_geojson TEXT,
        area_m2 REAL,
        perimeter_m REAL,
        geospatial_accuracy_m REAL,
        validation_note TEXT,
        validated_at TEXT,
        version INTEGER NOT NULL,
        is_current INTEGER NOT NULL DEFAULT 1,
        deleted INTEGER NOT NULL DEFAULT 0,
        server_updated_at TEXT NOT NULL
      )
      ''',
    );

    await customStatement(
      '''
      CREATE TABLE IF NOT EXISTS lot_geometry_sync_cursor (
        project_id TEXT PRIMARY KEY,
        cursor_value TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
      ''',
    );

    await customStatement(
      '''
      CREATE INDEX IF NOT EXISTS ix_geometry_sync_state_status
      ON lot_geometry_sync_state(sync_status)
      ''',
    );

    await customStatement(
      '''
      CREATE INDEX IF NOT EXISTS ix_geometry_remote_cache_project
      ON lot_geometry_remote_cache(project_id)
      ''',
    );

    await customStatement(
      '''
      CREATE INDEX IF NOT EXISTS ix_geometry_remote_cache_source
      ON lot_geometry_remote_cache(
        project_id,
        source_device_id,
        source_local_id
      )
      ''',
    );
  }

  Future<void> prepararVetorizacoesCidadaoParaSincronizacao({
    String? projectId,
  }) async {
    await ensureLotGeometrySyncInfrastructure();

    final now = DateTime.now().toIso8601String();

    // Remove vínculos locais com cadastros sociais que não existem mais.
    //
    // Isso evita o envio de um UUID órfão ao servidor depois que o cadastro
    // social foi excluído do banco local.
    await customStatement(
      '''
      UPDATE lotes_vetorizados_cidadao
      SET cadastro_social_id = NULL
      WHERE cadastro_social_id IS NOT NULL
        ${projectId == null ? '' : 'AND projeto_id = ?'}
        AND NOT EXISTS (
          SELECT 1
          FROM cadastros_sociais cs
          WHERE cs.id =
            lotes_vetorizados_cidadao.cadastro_social_id
            AND cs.projeto_id =
              lotes_vetorizados_cidadao.projeto_id
        )
      ''',
      projectId == null ? const [] : [projectId],
    );

    // Remove vínculos locais com selagens que não existem mais.
    //
    // O código da selagem é preservado. Somente o identificador local órfão
    // é removido.
    await customStatement(
      '''
      UPDATE lotes_vetorizados_cidadao
      SET selagem_id = NULL
      WHERE selagem_id IS NOT NULL
        ${projectId == null ? '' : 'AND projeto_id = ?'}
        AND NOT EXISTS (
          SELECT 1
          FROM selagens s
          WHERE s.id = lotes_vetorizados_cidadao.selagem_id
            AND s.projeto_id =
              lotes_vetorizados_cidadao.projeto_id
            AND COALESCE(s.deleted_locally, 0) = 0
        )
      ''',
      projectId == null ? const [] : [projectId],
    );

    final rows = await customSelect(
      '''
      SELECT
        lv.id,
        COALESCE(s.source_device_id, '') AS source_device_id
      FROM lotes_vetorizados_cidadao lv

      LEFT JOIN selagens s
        ON (
          s.id = lv.selagem_id
          OR (
            lv.codigo_selo IS NOT NULL
            AND s.codigo_selo = lv.codigo_selo
            AND s.projeto_id = lv.projeto_id
          )
        )
        AND COALESCE(s.deleted_locally, 0) = 0

      WHERE lv.synced = 0
        ${projectId == null ? '' : 'AND lv.projeto_id = ?'}
      ''',
      variables: projectId == null
          ? const []
          : [
              Variable.withString(projectId),
            ],
    ).get();

    for (final row in rows) {
      final localId = row.data['id']?.toString();
      final deviceId = row.data['source_device_id']?.toString();

      if (localId == null || localId.trim().isEmpty) {
        continue;
      }

      // Uma geometria criada sem selagem ainda não possui uma origem segura
      // de device_id. Nesse caso, não deve ser enviada até que sua identidade
      // de dispositivo seja definida.
      if (deviceId == null || deviceId.trim().isEmpty) {
        continue;
      }

      await customStatement(
        '''
        INSERT INTO lot_geometry_sync_state (
          local_id,
          source_device_id,
          sync_status,
          sync_attempts,
          sync_version,
          updated_at
        ) VALUES (?, ?, 'pending', 0, 1, ?)

        ON CONFLICT(local_id) DO UPDATE SET
          source_device_id = excluded.source_device_id,
          sync_status = CASE
            WHEN lot_geometry_sync_state.sync_status = 'synced'
              THEN 'pending'
            ELSE lot_geometry_sync_state.sync_status
          END,
          updated_at = excluded.updated_at
        ''',
        [
          localId,
          deviceId,
          now,
        ],
      );

      await customStatement(
        '''
        INSERT INTO sync_queue (
          id,
          entity_type,
          entity_id,
          operation,
          project_id,
          status,
          attempts,
          created_at,
          updated_at
        )
        SELECT
          ?,
          'lot_geometry',
          lv.id,
          'upsert',
          lv.projeto_id,
          'pending',
          0,
          ?,
          ?
        FROM lotes_vetorizados_cidadao lv
        WHERE lv.id = ?

        ON CONFLICT(id) DO UPDATE SET
          operation = excluded.operation,
          project_id = excluded.project_id,
          status = CASE
            WHEN sync_queue.status = 'conflict'
              THEN sync_queue.status
            ELSE 'pending'
          END,
          last_error = CASE
            WHEN sync_queue.status = 'conflict'
              THEN sync_queue.last_error
            ELSE NULL
          END,
          next_attempt_at = NULL,
          updated_at = excluded.updated_at
        ''',
        [
          'lot_geometry:$localId',
          now,
          now,
          localId,
        ],
      );
    }
  }

  Future<List<Map<String, Object?>>> listarGeometriasPendentes({
    required String projectId,
    int limit = 500,
  }) async {
    await prepararVetorizacoesCidadaoParaSincronizacao(
      projectId: projectId,
    );

    final rows = await customSelect(
      '''
      SELECT
        lv.id,
        lv.projeto_id,
        lv.selagem_id,
        lv.cadastro_social_id,
        lv.codigo_selo,
        lv.codigo_lote,
        lv.origem,
        lv.status,
        lv.geometria_geojson,
        lv.area_m2,
        lv.perimetro_m,
        lv.observacoes,
        lv.created_at,
        lv.updated_at,

        s.server_id AS seal_server_id,
        s.sync_status AS seal_sync_status,
        s.deleted_locally AS seal_deleted_locally,

        cs.id AS social_local_id,
        cs.synced AS social_synced,

        gs.server_id,
        gs.source_device_id,
        gs.sync_version,
        gs.deleted_locally,
        q.id AS queue_id

      FROM sync_queue q

      INNER JOIN lotes_vetorizados_cidadao lv
        ON lv.id = q.entity_id

      INNER JOIN lot_geometry_sync_state gs
        ON gs.local_id = lv.id

      LEFT JOIN selagens s
        ON (
          s.id = lv.selagem_id
          OR (
            lv.codigo_selo IS NOT NULL
            AND s.codigo_selo = lv.codigo_selo
            AND s.projeto_id = lv.projeto_id
          )
        )
        AND COALESCE(s.deleted_locally, 0) = 0

      LEFT JOIN cadastros_sociais cs
        ON cs.id = lv.cadastro_social_id
        AND cs.projeto_id = lv.projeto_id

      WHERE q.entity_type = 'lot_geometry'
        AND q.project_id = ?
        AND q.status IN ('pending', 'failed')

        AND COALESCE(gs.deleted_locally, 0) = 0

        AND (
          lv.selagem_id IS NULL
          OR (
            s.server_id IS NOT NULL
            AND s.sync_status = 'synced'
            AND COALESCE(s.deleted_locally, 0) = 0
          )
        )

        AND (
          lv.cadastro_social_id IS NULL
          OR (
            cs.id IS NOT NULL
            AND cs.synced = 1
          )
        )

        AND (
          q.next_attempt_at IS NULL
          OR q.next_attempt_at <= ?
        )

      ORDER BY q.created_at ASC
      LIMIT ?
      ''',
      variables: [
        Variable.withString(projectId),
        Variable.withDateTime(DateTime.now()),
        Variable.withInt(limit),
      ],
    ).get();

    return rows.map((row) => row.data).toList();
  }

  Future<void> marcarGeometriasComoSincronizando(
    List<String> queueIds,
  ) async {
    if (queueIds.isEmpty) {
      return;
    }

    final now = DateTime.now().toIso8601String();

    await transaction(() async {
      for (final queueId in queueIds) {
        await customStatement(
          '''
          UPDATE sync_queue
          SET
            status = 'syncing',
            attempts = attempts + 1,
            last_error = NULL,
            updated_at = ?
          WHERE id = ?
          ''',
          [
            now,
            queueId,
          ],
        );

        await customStatement(
          '''
          UPDATE lot_geometry_sync_state
          SET
            sync_status = 'syncing',
            sync_attempts = sync_attempts + 1,
            sync_error = NULL,
            last_sync_attempt_at = ?,
            updated_at = ?
          WHERE local_id = (
            SELECT entity_id
            FROM sync_queue
            WHERE id = ?
          )
          ''',
          [
            now,
            now,
            queueId,
          ],
        );
      }
    });
  }

  Future<void> marcarGeometriaComoSincronizada({
    required String localId,
    required String serverId,
    required int version,
    required DateTime serverUpdatedAt,
  }) async {
    final now = DateTime.now().toIso8601String();

    await transaction(() async {
      await customStatement(
        '''
        UPDATE lot_geometry_sync_state
        SET
          server_id = ?,
          sync_status = 'synced',
          sync_error = NULL,
          sync_version = ?,
          synced_at = ?,
          server_updated_at = ?,
          deleted_locally = 0,
          updated_at = ?
        WHERE local_id = ?
        ''',
        [
          serverId,
          version,
          now,
          serverUpdatedAt.toUtc().toIso8601String(),
          now,
          localId,
        ],
      );

      await customStatement(
        '''
        UPDATE lotes_vetorizados_cidadao
        SET
          synced = 1,
          updated_at = ?
        WHERE id = ?
        ''',
        [
          now,
          localId,
        ],
      );

      await customStatement(
        '''
        DELETE FROM sync_queue
        WHERE id = ?
        ''',
        [
          'lot_geometry:$localId',
        ],
      );
    });
  }

  Future<void> marcarGeometriaComoFalha({
    required String localId,
    required String message,
    Duration retryAfter = const Duration(minutes: 1),
  }) async {
    final now = DateTime.now();
    final nextAttempt = now.add(retryAfter);

    await transaction(() async {
      await customStatement(
        '''
        UPDATE lot_geometry_sync_state
        SET
          sync_status = 'failed',
          sync_error = ?,
          last_sync_attempt_at = ?,
          updated_at = ?
        WHERE local_id = ?
        ''',
        [
          message,
          now.toIso8601String(),
          now.toIso8601String(),
          localId,
        ],
      );

      await customStatement(
        '''
        UPDATE sync_queue
        SET
          status = 'failed',
          last_error = ?,
          next_attempt_at = ?,
          updated_at = ?
        WHERE id = ?
        ''',
        [
          message,
          nextAttempt.toIso8601String(),
          now.toIso8601String(),
          'lot_geometry:$localId',
        ],
      );
    });
  }

  Future<void> marcarGeometriaComoConflito({
    required String localId,
    required String message,
  }) async {
    final now = DateTime.now().toIso8601String();

    await transaction(() async {
      await customStatement(
        '''
        UPDATE lot_geometry_sync_state
        SET
          sync_status = 'conflict',
          sync_error = ?,
          last_sync_attempt_at = ?,
          updated_at = ?
        WHERE local_id = ?
        ''',
        [
          message,
          now,
          now,
          localId,
        ],
      );

      await customStatement(
        '''
        UPDATE sync_queue
        SET
          status = 'conflict',
          last_error = ?,
          updated_at = ?
        WHERE id = ?
        ''',
        [
          message,
          now,
          'lot_geometry:$localId',
        ],
      );
    });
  }

  Future<void> liberarGeometriasParaNovaTentativa(
    String projectId,
  ) async {
    final now = DateTime.now().toIso8601String();

    await transaction(() async {
      await customStatement(
        '''
        UPDATE sync_queue
        SET
          status = 'pending',
          next_attempt_at = NULL,
          updated_at = ?
        WHERE entity_type = 'lot_geometry'
          AND project_id = ?
          AND status = 'syncing'
        ''',
        [
          now,
          projectId,
        ],
      );

      await customStatement(
        '''
        UPDATE lot_geometry_sync_state
        SET
          sync_status = 'pending',
          updated_at = ?
        WHERE sync_status = 'syncing'
          AND local_id IN (
            SELECT entity_id
            FROM sync_queue
            WHERE entity_type = 'lot_geometry'
              AND project_id = ?
          )
        ''',
        [
          now,
          projectId,
        ],
      );
    });
  }

  Future<String?> obterCursorGeometrias(
    String projectId,
  ) async {
    await ensureLotGeometrySyncInfrastructure();

    final row = await customSelect(
      '''
      SELECT cursor_value
      FROM lot_geometry_sync_cursor
      WHERE project_id = ?
      LIMIT 1
      ''',
      variables: [
        Variable.withString(projectId),
      ],
    ).getSingleOrNull();

    return row?.data['cursor_value']?.toString();
  }

  Future<void> salvarCursorGeometrias({
    required String projectId,
    required String cursor,
  }) async {
    final now = DateTime.now().toIso8601String();

    await customStatement(
      '''
      INSERT INTO lot_geometry_sync_cursor (
        project_id,
        cursor_value,
        updated_at
      ) VALUES (?, ?, ?)

      ON CONFLICT(project_id) DO UPDATE SET
        cursor_value = excluded.cursor_value,
        updated_at = excluded.updated_at
      ''',
      [
        projectId,
        cursor,
        now,
      ],
    );
  }

  String _localGeometryStatus(
    String? remoteStatus,
  ) {
    return switch (remoteStatus) {
      'aguardando_validacao' => 'aguardando_validacao_tecnica',
      'validado' => 'validado_tecnico',
      'rejeitado' => 'rejeitado_tecnico',
      'substituido' => 'substituido',
      'arquivado' => 'arquivado',
      _ => remoteStatus ?? 'rascunho',
    };
  }

  String? _nullableText(
    Object? value,
  ) {
    if (value == null) {
      return null;
    }

    final text = value.toString().trim();

    return text.isEmpty || text.toLowerCase() == 'null' ? null : text;
  }

  bool _asBool(
    Object? value,
  ) {
    if (value is bool) {
      return value;
    }

    if (value is num) {
      return value != 0;
    }

    final normalized = value?.toString().trim().toLowerCase();

    return normalized == 'true' || normalized == '1';
  }

  Future<String?> _resolverSelagemLocalPorServidor({
    required String projectId,
    String? remoteSealId,
  }) async {
    if (remoteSealId == null || remoteSealId.trim().isEmpty) {
      return null;
    }

    final row = await customSelect(
      '''
      SELECT id
      FROM selagens
      WHERE projeto_id = ?
        AND (
          server_id = ?
          OR id = ?
        )
        AND COALESCE(deleted_locally, 0) = 0
      LIMIT 1
      ''',
      variables: [
        Variable.withString(projectId),
        Variable.withString(remoteSealId),
        Variable.withString(remoteSealId),
      ],
    ).getSingleOrNull();

    return row?.data['id']?.toString();
  }

  Future<String?> _resolverCadastroSocialLocal({
    required String projectId,
    String? remoteSocialRegistrationId,
  }) async {
    if (remoteSocialRegistrationId == null ||
        remoteSocialRegistrationId.trim().isEmpty) {
      return null;
    }

    final row = await customSelect(
      '''
      SELECT id
      FROM cadastros_sociais
      WHERE projeto_id = ?
        AND id = ?
      LIMIT 1
      ''',
      variables: [
        Variable.withString(projectId),
        Variable.withString(remoteSocialRegistrationId),
      ],
    ).getSingleOrNull();

    return row?.data['id']?.toString();
  }

  Future<void> aplicarGeometriaRemota(
    Map<String, dynamic> record,
  ) async {
    await ensureLotGeometrySyncInfrastructure();

    final serverId = _nullableText(record['id']);
    final projectId = _nullableText(record['project_id']);
    final sourceLocalId = _nullableText(record['source_local_id']);
    final sourceDeviceId = _nullableText(record['source_device_id']);

    if (serverId == null ||
        projectId == null ||
        sourceLocalId == null ||
        sourceDeviceId == null) {
      return;
    }

    final remoteSealId = _nullableText(record['seal_id']);
    final remoteSocialRegistrationId = _nullableText(
      record['social_registration_id'],
    );

    final localSealId = await _resolverSelagemLocalPorServidor(
      projectId: projectId,
      remoteSealId: remoteSealId,
    );

    final localSocialRegistrationId = await _resolverCadastroSocialLocal(
      projectId: projectId,
      remoteSocialRegistrationId: remoteSocialRegistrationId,
    );

    final geometryValue = record['geometry_geojson'];

    final geometryJson = geometryValue == null
        ? null
        : geometryValue is String
            ? geometryValue
            : geometryValue.toString();

    final deleted = _asBool(record['deleted']);
    final isCurrent = !_asBool(record['is_current']) ? false : true;

    final remoteWorkflowStatus = _nullableText(
      record['workflow_status'],
    );

    final localStatus =
        deleted ? 'arquivado' : _localGeometryStatus(remoteWorkflowStatus);

    final remoteUpdatedAt = _nullableText(record['updated_at']) ??
        DateTime.now().toUtc().toIso8601String();

    await customStatement(
      '''
      INSERT INTO lot_geometry_remote_cache (
        server_id,
        project_id,
        source_local_id,
        source_device_id,
        lot_id,
        seal_id,
        social_registration_id,
        origin,
        workflow_status,
        geometry_geojson,
        area_m2,
        perimeter_m,
        geospatial_accuracy_m,
        validation_note,
        validated_at,
        version,
        is_current,
        deleted,
        server_updated_at
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)

      ON CONFLICT(server_id) DO UPDATE SET
        project_id = excluded.project_id,
        source_local_id = excluded.source_local_id,
        source_device_id = excluded.source_device_id,
        lot_id = excluded.lot_id,
        seal_id = excluded.seal_id,
        social_registration_id =
          excluded.social_registration_id,
        origin = excluded.origin,
        workflow_status = excluded.workflow_status,
        geometry_geojson = excluded.geometry_geojson,
        area_m2 = excluded.area_m2,
        perimeter_m = excluded.perimeter_m,
        geospatial_accuracy_m =
          excluded.geospatial_accuracy_m,
        validation_note = excluded.validation_note,
        validated_at = excluded.validated_at,
        version = excluded.version,
        is_current = excluded.is_current,
        deleted = excluded.deleted,
        server_updated_at = excluded.server_updated_at
      ''',
      [
        serverId,
        projectId,
        sourceLocalId,
        sourceDeviceId,
        _nullableText(record['lot_id']),
        remoteSealId,
        remoteSocialRegistrationId,
        _nullableText(record['origin']) ?? 'painel_web',
        remoteWorkflowStatus ?? 'rascunho',
        geometryJson,
        record['area_m2'],
        record['perimeter_m'],
        record['geospatial_accuracy_m'],
        _nullableText(record['validation_note']),
        _nullableText(record['validated_at']),
        record['version'] ?? 1,
        isCurrent ? 1 : 0,
        deleted ? 1 : 0,
        remoteUpdatedAt,
      ],
    );

    final localExists = await customSelect(
      '''
      SELECT id
      FROM lotes_vetorizados_cidadao
      WHERE id = ?
      LIMIT 1
      ''',
      variables: [
        Variable.withString(sourceLocalId),
      ],
    ).getSingleOrNull();

    final now = DateTime.now().toIso8601String();

    if (localExists == null) {
      // Uma geometria sem GeoJSON não pode ser criada na tabela principal,
      // pois geometria_geojson é obrigatório nessa estrutura local.
      if (geometryJson == null || geometryJson.trim().isEmpty) {
        return;
      }

      await customStatement(
        '''
        INSERT INTO lotes_vetorizados_cidadao (
          id,
          projeto_id,
          selagem_id,
          cadastro_social_id,
          codigo_selo,
          codigo_lote,
          geometria_geojson,
          area_m2,
          perimetro_m,
          origem,
          status,
          observacoes,
          synced,
          created_at,
          updated_at
        ) VALUES (?, ?, ?, ?, NULL, NULL, ?, ?, ?, ?, ?, ?, 1, ?, ?)
        ''',
        [
          sourceLocalId,
          projectId,
          localSealId,
          localSocialRegistrationId,
          geometryJson,
          record['area_m2'],
          record['perimeter_m'],
          _nullableText(record['origin']) ?? 'painel_web',
          localStatus,
          _nullableText(record['validation_note']),
          now,
          now,
        ],
      );

      await customStatement(
        '''
        INSERT INTO lot_geometry_sync_state (
          local_id,
          server_id,
          source_device_id,
          sync_status,
          sync_attempts,
          sync_version,
          synced_at,
          server_updated_at,
          deleted_locally,
          updated_at
        ) VALUES (?, ?, ?, 'synced', 0, ?, ?, ?, 0, ?)

        ON CONFLICT(local_id) DO UPDATE SET
          server_id = excluded.server_id,
          source_device_id = excluded.source_device_id,
          sync_status = 'synced',
          sync_error = NULL,
          sync_version = excluded.sync_version,
          synced_at = excluded.synced_at,
          server_updated_at = excluded.server_updated_at,
          deleted_locally = 0,
          updated_at = excluded.updated_at
        ''',
        [
          sourceLocalId,
          serverId,
          sourceDeviceId,
          record['version'] ?? 1,
          now,
          remoteUpdatedAt,
          now,
        ],
      );

      return;
    }

    await transaction(() async {
      await customStatement(
        '''
        UPDATE lotes_vetorizados_cidadao
        SET
          projeto_id = ?,
          selagem_id = ?,
          cadastro_social_id = ?,
          origem = ?,
          status = ?,
          geometria_geojson =
            COALESCE(?, geometria_geojson),
          area_m2 = COALESCE(?, area_m2),
          perimetro_m = COALESCE(?, perimetro_m),
          observacoes =
            COALESCE(?, observacoes),
          synced = 1,
          updated_at = ?
        WHERE id = ?
        ''',
        [
          projectId,
          localSealId,
          localSocialRegistrationId,
          _nullableText(record['origin']) ?? 'painel_web',
          localStatus,
          geometryJson,
          record['area_m2'],
          record['perimeter_m'],
          _nullableText(record['validation_note']),
          now,
          sourceLocalId,
        ],
      );

      await customStatement(
        '''
        INSERT INTO lot_geometry_sync_state (
          local_id,
          server_id,
          source_device_id,
          sync_status,
          sync_attempts,
          sync_version,
          synced_at,
          server_updated_at,
          deleted_locally,
          updated_at
        ) VALUES (?, ?, ?, 'synced', 0, ?, ?, ?, 0, ?)

        ON CONFLICT(local_id) DO UPDATE SET
          server_id = excluded.server_id,
          source_device_id = excluded.source_device_id,
          sync_status = 'synced',
          sync_error = NULL,
          sync_version = excluded.sync_version,
          synced_at = excluded.synced_at,
          server_updated_at = excluded.server_updated_at,
          deleted_locally = 0,
          updated_at = excluded.updated_at
        ''',
        [
          sourceLocalId,
          serverId,
          sourceDeviceId,
          record['version'] ?? 1,
          now,
          remoteUpdatedAt,
          now,
        ],
      );

      await customStatement(
        '''
        DELETE FROM sync_queue
        WHERE id = ?
        ''',
        [
          'lot_geometry:$sourceLocalId',
        ],
      );
    });
  }

  Future<Map<String, int>> resumoSincronizacaoGeometrias() async {
    await ensureLotGeometrySyncInfrastructure();

    final rows = await customSelect(
      '''
      SELECT
        sync_status,
        COUNT(*) AS total
      FROM lot_geometry_sync_state
      GROUP BY sync_status
      ''',
    ).get();

    final result = <String, int>{
      'pending': 0,
      'syncing': 0,
      'synced': 0,
      'failed': 0,
      'conflict': 0,
    };

    for (final row in rows) {
      final status = row.data['sync_status']?.toString() ?? 'pending';

      result[status] = (row.data['total'] as num?)?.toInt() ?? 0;
    }

    return result;
  }

  Future<List<Map<String, Object?>>> listarFalhasGeometrias({
    int limit = 30,
  }) async {
    await ensureLotGeometrySyncInfrastructure();

    final rows = await customSelect(
      '''
      SELECT
        gs.local_id AS id,
        lv.codigo_lote,
        lv.codigo_selo,
        gs.sync_status,
        gs.sync_error,
        gs.sync_attempts,
        gs.last_sync_attempt_at
      FROM lot_geometry_sync_state gs

      LEFT JOIN lotes_vetorizados_cidadao lv
        ON lv.id = gs.local_id

      WHERE gs.sync_status IN ('failed', 'conflict')

      ORDER BY gs.last_sync_attempt_at DESC
      LIMIT ?
      ''',
      variables: [
        Variable.withInt(limit),
      ],
    ).get();

    return rows.map((row) => row.data).toList();
  }
}
