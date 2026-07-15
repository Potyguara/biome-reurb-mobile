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
  }

  Future<void> prepararVetorizacoesCidadaoParaSincronizacao({
    String? projectId,
  }) async {
    await ensureLotGeometrySyncInfrastructure();
    final now = DateTime.now().toIso8601String();

    final rows = await customSelect(
      '''
      SELECT
        lv.id,
        COALESCE(s.source_device_id, '') AS source_device_id
      FROM lotes_vetorizados_cidadao lv
      LEFT JOIN selagens s
        ON s.id = lv.selagem_id
        OR (
          lv.codigo_selo IS NOT NULL
          AND s.codigo_selo = lv.codigo_selo
        )
      WHERE lv.synced = 0
        ${projectId == null ? '' : 'AND lv.projeto_id = ?'}
      ''',
      variables:
          projectId == null ? const [] : [Variable.withString(projectId)],
    ).get();

    for (final row in rows) {
      final localId = row.data['id']?.toString();
      final deviceId = row.data['source_device_id']?.toString();

      if (localId == null || localId.isEmpty) continue;
      if (deviceId == null || deviceId.isEmpty) continue;

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
        [localId, deviceId, now],
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
          status = CASE
            WHEN sync_queue.status = 'conflict'
              THEN sync_queue.status
            ELSE 'pending'
          END,
          next_attempt_at = NULL,
          updated_at = excluded.updated_at
        ''',
        ['lot_geometry:$localId', now, now, localId],
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
        ON s.id = lv.selagem_id
        OR (
          lv.codigo_selo IS NOT NULL
          AND s.codigo_selo = lv.codigo_selo
          AND s.projeto_id = lv.projeto_id
        )

      WHERE q.entity_type = 'lot_geometry'
        AND q.project_id = ?
        AND q.status IN ('pending', 'failed')

        AND (
          lv.selagem_id IS NULL
          OR (
            s.server_id IS NOT NULL
            AND s.sync_status = 'synced'
            AND COALESCE(s.deleted_locally, 0) = 0
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
    if (queueIds.isEmpty) return;
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
          [now, queueId],
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
          [now, now, queueId],
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
          updated_at = ?
        WHERE local_id = ?
        ''',
        [
          serverId,
          version,
          now,
          serverUpdatedAt.toIso8601String(),
          now,
          localId,
        ],
      );

      await customStatement(
        'UPDATE lotes_vetorizados_cidadao SET synced = 1 WHERE id = ?',
        [localId],
      );

      await customStatement(
        'DELETE FROM sync_queue WHERE id = ?',
        ['lot_geometry:$localId'],
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
        [message, now, now, localId],
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
        [message, now, 'lot_geometry:$localId'],
      );
    });
  }

  Future<void> liberarGeometriasParaNovaTentativa(
    String projectId,
  ) async {
    final now = DateTime.now().toIso8601String();

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
      [now, projectId],
    );
  }

  Future<String?> obterCursorGeometrias(String projectId) async {
    await ensureLotGeometrySyncInfrastructure();

    final row = await customSelect(
      '''
      SELECT cursor_value
      FROM lot_geometry_sync_cursor
      WHERE project_id = ?
      LIMIT 1
      ''',
      variables: [Variable.withString(projectId)],
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
      [projectId, cursor, now],
    );
  }

  String _localGeometryStatus(String? remoteStatus) {
    return switch (remoteStatus) {
      'aguardando_validacao' => 'aguardando_validacao_tecnica',
      'validado' => 'validado_tecnico',
      'rejeitado' => 'rejeitado_tecnico',
      'substituido' => 'substituido',
      'arquivado' => 'arquivado',
      _ => remoteStatus ?? 'rascunho',
    };
  }

  Future<void> aplicarGeometriaRemota(
    Map<String, dynamic> record,
  ) async {
    await ensureLotGeometrySyncInfrastructure();

    final serverId = record['id']?.toString();
    final projectId = record['project_id']?.toString();
    final sourceLocalId = record['source_local_id']?.toString();
    final sourceDeviceId = record['source_device_id']?.toString();

    if (serverId == null ||
        projectId == null ||
        sourceLocalId == null ||
        sourceDeviceId == null) {
      return;
    }

    final geometryJson = record['geometry_geojson']?.toString();

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
        workflow_status = excluded.workflow_status,
        geometry_geojson = excluded.geometry_geojson,
        area_m2 = excluded.area_m2,
        perimeter_m = excluded.perimeter_m,
        geospatial_accuracy_m = excluded.geospatial_accuracy_m,
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
        record['lot_id']?.toString(),
        record['seal_id']?.toString(),
        record['social_registration_id']?.toString(),
        record['origin']?.toString() ?? 'painel_web',
        record['workflow_status']?.toString() ?? 'rascunho',
        geometryJson,
        record['area_m2'],
        record['perimeter_m'],
        record['geospatial_accuracy_m'],
        record['validation_note']?.toString(),
        record['validated_at']?.toString(),
        record['version'] ?? 1,
        record['is_current'] == false ? 0 : 1,
        record['deleted'] == true ? 1 : 0,
        record['updated_at']?.toString() ?? DateTime.now().toIso8601String(),
      ],
    );

    final localExists = await customSelect(
      'SELECT id FROM lotes_vetorizados_cidadao WHERE id = ? LIMIT 1',
      variables: [Variable.withString(sourceLocalId)],
    ).getSingleOrNull();

    if (localExists == null) {
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
          record['seal_id']?.toString(),
          record['social_registration_id']?.toString(),
          geometryJson,
          record['area_m2'],
          record['perimeter_m'],
          record['origin']?.toString() ?? 'painel_web',
          _localGeometryStatus(
            record['workflow_status']?.toString(),
          ),
          record['validation_note']?.toString(),
          DateTime.now().toIso8601String(),
          DateTime.now().toIso8601String(),
        ],
      );

      return;
    }

    final localStatus = _localGeometryStatus(
      record['workflow_status']?.toString(),
    );

    await customStatement(
      '''
      UPDATE lotes_vetorizados_cidadao
      SET
        status = ?,
        geometria_geojson = COALESCE(?, geometria_geojson),
        area_m2 = COALESCE(?, area_m2),
        perimetro_m = COALESCE(?, perimetro_m),
        synced = 1,
        updated_at = ?
      WHERE id = ?
      ''',
      [
        localStatus,
        geometryJson,
        record['area_m2'],
        record['perimeter_m'],
        DateTime.now().toIso8601String(),
        sourceLocalId,
      ],
    );
  }

  Future<Map<String, int>> resumoSincronizacaoGeometrias() async {
    await ensureLotGeometrySyncInfrastructure();

    final rows = await customSelect(
      '''
      SELECT sync_status, COUNT(*) AS total
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
      variables: [Variable.withInt(limit)],
    ).get();

    return rows.map((row) => row.data).toList();
  }
}
