import 'package:drift/drift.dart';

import '../../../data/local/app_database.dart';

extension FieldRecordSyncDatabase on AppDatabase {
  Future<void> prepararCadastrosPendentes({
    required String projectId,
  }) async {
    await _enfileirarTabelaPendente(
      tableName: 'cadastros_sociais',
      entityType: 'social_registration',
      projectId: projectId,
    );

    await _enfileirarTabelaPendente(
      tableName: 'cadastros_fisicos',
      entityType: 'physical_registration',
      projectId: projectId,
    );
  }

  Future<void> _enfileirarTabelaPendente({
    required String tableName,
    required String entityType,
    required String projectId,
  }) async {
    final rows = await customSelect(
      '''
      SELECT id
      FROM $tableName
      WHERE projeto_id = ?
        AND synced = 0
      ''',
      variables: [Variable.withString(projectId)],
    ).get();

    for (final row in rows) {
      final id = row.data['id']?.toString();

      if (id == null || id.trim().isEmpty) continue;

      await enfileirarSincronizacao(
        entityType: entityType,
        entityId: id,
        projectId: projectId,
      );
    }
  }

  Future<List<Map<String, Object?>>> listarCadastrosPendentes({
    required String projectId,
    int limit = 500,
  }) async {
    final rows = await customSelect(
      '''
      SELECT
        q.id AS queue_id,
        q.entity_type,
        q.entity_id,
        q.project_id,
        q.attempts,
        q.last_error,
        q.created_at,
        q.updated_at
      FROM sync_queue q
      WHERE q.project_id = ?
        AND q.entity_type IN (
          'social_registration',
          'physical_registration'
        )
        AND q.status IN ('pending', 'failed')
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

  Future<Map<String, Object?>?> buscarCadastroPorId({
    required String entityType,
    required String id,
  }) async {
    final tableName = entityType == 'social_registration'
        ? 'cadastros_sociais'
        : 'cadastros_fisicos';

    final row = await customSelect(
      '''
      SELECT *
      FROM $tableName
      WHERE id = ?
      LIMIT 1
      ''',
      variables: [Variable.withString(id)],
    ).getSingleOrNull();

    return row?.data;
  }

  Map<String, dynamic> prepararPayloadCadastro(
    Map<String, Object?> row,
  ) {
    final payload = <String, dynamic>{};

    for (final entry in row.entries) {
      if (entry.key == 'synced') continue;

      final value = entry.value;

      if (value is DateTime) {
        payload[entry.key] = value.toUtc().toIso8601String();
      } else {
        payload[entry.key] = value;
      }
    }

    return payload;
  }

  Future<void> marcarCadastroComoSincronizado({
    required String entityType,
    required String localId,
  }) async {
    final tableName = entityType == 'social_registration'
        ? 'cadastros_sociais'
        : 'cadastros_fisicos';

    await transaction(() async {
      await customStatement(
        '''
        UPDATE $tableName
        SET synced = 1
        WHERE id = ?
        ''',
        [localId],
      );

      await customStatement(
        'DELETE FROM sync_queue WHERE id = ?',
        ['$entityType:$localId'],
      );
    });
  }

  Future<void> marcarCadastroComoFalha({
    required String entityType,
    required String localId,
    required String message,
  }) async {
    final now = DateTime.now();
    final nextAttempt = now.add(const Duration(minutes: 1));

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
        '$entityType:$localId',
      ],
    );
  }

  Future<void> liberarCadastrosParaNovaTentativa(
    String projectId,
  ) async {
    final now = DateTime.now().toIso8601String();

    await customStatement(
      '''
      UPDATE sync_queue
      SET
        status = 'pending',
        last_error = NULL,
        next_attempt_at = NULL,
        updated_at = ?
      WHERE project_id = ?
        AND entity_type IN (
          'social_registration',
          'physical_registration'
        )
        AND status = 'syncing'
      ''',
      [now, projectId],
    );
  }

  Future<void> aplicarCadastrosRemotos({
    required String projectId,
    required List<Map<String, dynamic>> socialRegistrations,
    required List<Map<String, dynamic>> physicalRegistrations,
  }) async {
    await transaction(() async {
      for (final record in socialRegistrations) {
        await _aplicarCadastroSocialRemoto(
          projectId: projectId,
          record: record,
        );
      }

      for (final record in physicalRegistrations) {
        await _aplicarCadastroFisicoRemoto(
          projectId: projectId,
          record: record,
        );
      }
    });
  }

  Future<void> _aplicarCadastroSocialRemoto({
    required String projectId,
    required Map<String, dynamic> record,
  }) async {
    final remoteId = _text(record['source_local_id'] ?? record['id']);
    final sealCode = _text(record['seal_code'] ?? record['codigo_selo']);

    if (remoteId == null || sealCode == null) return;

    final sealId = await _resolverSelagemLocal(
      projectId: projectId,
      sealServerId: _text(record['seal_id'] ?? record['selagem_id']),
      sealCode: sealCode,
    );

    final cpf = _text(
      record['responsible_cpf'] ?? record['cpf_responsavel'],
    );

    final existingId = await _buscarCadastroSocialExistente(
      projectId: projectId,
      remoteId: remoteId,
      sealCode: sealCode,
      cpf: cpf,
    );

    final localId = existingId ?? remoteId;
    final createdAt =
        _date(record['created_at']) ?? DateTime.now().toUtc().toIso8601String();

    await customStatement(
      '''
      INSERT INTO cadastros_sociais (
        id,
        projeto_id,
        selagem_id,
        codigo_selo,
        nome_responsavel,
        cpf_responsavel,
        rg_responsavel,
        orgao_emissor,
        estado_civil,
        profissao,
        telefone,
        quantidade_moradores,
        renda_familiar,
        recebe_programa_social,
        programa_social,
        tempo_ocupacao_anos,
        forma_ocupacao,
        documento_posse,
        possui_outro_imovel,
        possui_conflito,
        observacoes,
        synced,
        created_at
      ) VALUES (
        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1, ?
      )
      ON CONFLICT(id) DO UPDATE SET
        projeto_id = excluded.projeto_id,
        selagem_id = excluded.selagem_id,
        codigo_selo = excluded.codigo_selo,
        nome_responsavel = excluded.nome_responsavel,
        cpf_responsavel = excluded.cpf_responsavel,
        rg_responsavel = excluded.rg_responsavel,
        orgao_emissor = excluded.orgao_emissor,
        estado_civil = excluded.estado_civil,
        profissao = excluded.profissao,
        telefone = excluded.telefone,
        quantidade_moradores = excluded.quantidade_moradores,
        renda_familiar = excluded.renda_familiar,
        recebe_programa_social = excluded.recebe_programa_social,
        programa_social = excluded.programa_social,
        tempo_ocupacao_anos = excluded.tempo_ocupacao_anos,
        forma_ocupacao = excluded.forma_ocupacao,
        documento_posse = excluded.documento_posse,
        possui_outro_imovel = excluded.possui_outro_imovel,
        possui_conflito = excluded.possui_conflito,
        observacoes = excluded.observacoes,
        synced = 1
      ''',
      [
        localId,
        projectId,
        sealId,
        sealCode,
        _text(record['responsible_name'] ?? record['nome_responsavel']) ??
            'Não informado',
        cpf,
        _text(record['responsible_rg'] ?? record['rg_responsavel']),
        _text(record['issuing_agency'] ?? record['orgao_emissor']),
        _text(record['marital_status'] ?? record['estado_civil']),
        _text(record['profession'] ?? record['profissao']),
        _text(record['phone'] ?? record['telefone']),
        _int(record['household_members'] ?? record['quantidade_moradores']),
        _double(record['family_income'] ?? record['renda_familiar']),
        _bool(
              record['receives_social_program'] ??
                  record['recebe_programa_social'],
            )
            ? 1
            : 0,
        _text(record['social_program'] ?? record['programa_social']),
        _int(record['occupation_years'] ?? record['tempo_ocupacao_anos']),
        _text(record['occupation_type'] ?? record['forma_ocupacao']),
        _text(record['possession_document'] ?? record['documento_posse']),
        _bool(record['owns_other_property'] ?? record['possui_outro_imovel'])
            ? 1
            : 0,
        _bool(record['has_conflict'] ?? record['possui_conflito']) ? 1 : 0,
        _text(record['notes'] ?? record['observacoes']),
        createdAt,
      ],
    );

    await customStatement(
      '''
      DELETE FROM sync_queue
      WHERE entity_type = 'social_registration'
        AND entity_id = ?
      ''',
      [localId],
    );
  }

  Future<void> _aplicarCadastroFisicoRemoto({
    required String projectId,
    required Map<String, dynamic> record,
  }) async {
    final remoteId = _text(record['source_local_id'] ?? record['id']);
    final sealCode = _text(record['seal_code'] ?? record['codigo_selo']);

    if (remoteId == null || sealCode == null) return;

    final sealId = await _resolverSelagemLocal(
      projectId: projectId,
      sealServerId: _text(record['seal_id'] ?? record['selagem_id']),
      sealCode: sealCode,
    );

    final existingId = await _buscarCadastroFisicoExistente(
      projectId: projectId,
      remoteId: remoteId,
      sealCode: sealCode,
    );

    final localId = existingId ?? remoteId;
    final createdAt =
        _date(record['created_at']) ?? DateTime.now().toUtc().toIso8601String();

    await customStatement(
      '''
      INSERT INTO cadastros_fisicos (
        id,
        projeto_id,
        selagem_id,
        codigo_selo,
        tipo_imovel,
        uso_imovel,
        material_paredes,
        tipo_cobertura,
        tipo_piso,
        numero_pavimentos,
        numero_comodos,
        numero_banheiros,
        possui_energia,
        possui_agua,
        possui_esgoto,
        possui_banheiro,
        condicao_habitabilidade,
        area_risco,
        sujeito_inundacao,
        observacoes,
        synced,
        created_at
      ) VALUES (
        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1, ?
      )
      ON CONFLICT(id) DO UPDATE SET
        projeto_id = excluded.projeto_id,
        selagem_id = excluded.selagem_id,
        codigo_selo = excluded.codigo_selo,
        tipo_imovel = excluded.tipo_imovel,
        uso_imovel = excluded.uso_imovel,
        material_paredes = excluded.material_paredes,
        tipo_cobertura = excluded.tipo_cobertura,
        tipo_piso = excluded.tipo_piso,
        numero_pavimentos = excluded.numero_pavimentos,
        numero_comodos = excluded.numero_comodos,
        numero_banheiros = excluded.numero_banheiros,
        possui_energia = excluded.possui_energia,
        possui_agua = excluded.possui_agua,
        possui_esgoto = excluded.possui_esgoto,
        possui_banheiro = excluded.possui_banheiro,
        condicao_habitabilidade = excluded.condicao_habitabilidade,
        area_risco = excluded.area_risco,
        sujeito_inundacao = excluded.sujeito_inundacao,
        observacoes = excluded.observacoes,
        synced = 1
      ''',
      [
        localId,
        projectId,
        sealId,
        sealCode,
        _text(record['property_type'] ?? record['tipo_imovel']),
        _text(record['property_use'] ?? record['uso_imovel']),
        _text(record['wall_material'] ?? record['material_paredes']),
        _text(record['roof_type'] ?? record['tipo_cobertura']),
        _text(record['floor_type'] ?? record['tipo_piso']),
        _int(record['floors'] ?? record['numero_pavimentos']),
        _int(record['rooms'] ?? record['numero_comodos']),
        _int(record['bathrooms'] ?? record['numero_banheiros']),
        _bool(record['has_energy'] ?? record['possui_energia']) ? 1 : 0,
        _bool(record['has_water'] ?? record['possui_agua']) ? 1 : 0,
        _bool(record['has_sewage'] ?? record['possui_esgoto']) ? 1 : 0,
        _bool(record['has_bathroom'] ?? record['possui_banheiro']) ? 1 : 0,
        _text(
          record['habitability_condition'] ??
              record['condicao_habitabilidade'],
        ),
        _bool(record['risk_area'] ?? record['area_risco']) ? 1 : 0,
        _bool(record['flood_prone'] ?? record['sujeito_inundacao']) ? 1 : 0,
        _text(record['notes'] ?? record['observacoes']),
        createdAt,
      ],
    );

    await customStatement(
      '''
      DELETE FROM sync_queue
      WHERE entity_type = 'physical_registration'
        AND entity_id = ?
      ''',
      [localId],
    );
  }

  Future<String?> _resolverSelagemLocal({
    required String projectId,
    String? sealServerId,
    String? sealCode,
  }) async {
    if (sealServerId != null) {
      final byServer = await customSelect(
        '''
        SELECT id
        FROM selagens
        WHERE projeto_id = ?
          AND server_id = ?
          AND COALESCE(deleted_locally, 0) = 0
        LIMIT 1
        ''',
        variables: [
          Variable.withString(projectId),
          Variable.withString(sealServerId),
        ],
      ).getSingleOrNull();

      final id = byServer?.data['id']?.toString();
      if (id != null && id.isNotEmpty) return id;

      final byId = await customSelect(
        '''
        SELECT id
        FROM selagens
        WHERE projeto_id = ?
          AND id = ?
          AND COALESCE(deleted_locally, 0) = 0
        LIMIT 1
        ''',
        variables: [
          Variable.withString(projectId),
          Variable.withString(sealServerId),
        ],
      ).getSingleOrNull();

      final localId = byId?.data['id']?.toString();
      if (localId != null && localId.isNotEmpty) return localId;
    }

    if (sealCode != null) {
      final byCode = await customSelect(
        '''
        SELECT id
        FROM selagens
        WHERE projeto_id = ?
          AND codigo_selo = ?
          AND COALESCE(deleted_locally, 0) = 0
        ORDER BY
          CASE WHEN sync_status = 'synced' THEN 0 ELSE 1 END,
          created_at DESC
        LIMIT 1
        ''',
        variables: [
          Variable.withString(projectId),
          Variable.withString(sealCode),
        ],
      ).getSingleOrNull();

      return byCode?.data['id']?.toString();
    }

    return null;
  }

  Future<String?> _buscarCadastroSocialExistente({
    required String projectId,
    required String remoteId,
    required String sealCode,
    String? cpf,
  }) async {
    final byId = await customSelect(
      'SELECT id FROM cadastros_sociais WHERE id = ? LIMIT 1',
      variables: [Variable.withString(remoteId)],
    ).getSingleOrNull();

    final id = byId?.data['id']?.toString();
    if (id != null && id.isNotEmpty) return id;

    if (cpf != null) {
      final byCpf = await customSelect(
        '''
        SELECT id
        FROM cadastros_sociais
        WHERE projeto_id = ?
          AND codigo_selo = ?
          AND cpf_responsavel = ?
        LIMIT 1
        ''',
        variables: [
          Variable.withString(projectId),
          Variable.withString(sealCode),
          Variable.withString(cpf),
        ],
      ).getSingleOrNull();

      final cpfId = byCpf?.data['id']?.toString();
      if (cpfId != null && cpfId.isNotEmpty) return cpfId;
    }

    final bySeal = await customSelect(
      '''
      SELECT id
      FROM cadastros_sociais
      WHERE projeto_id = ?
        AND codigo_selo = ?
      ORDER BY created_at DESC
      LIMIT 1
      ''',
      variables: [
        Variable.withString(projectId),
        Variable.withString(sealCode),
      ],
    ).getSingleOrNull();

    return bySeal?.data['id']?.toString();
  }

  Future<String?> _buscarCadastroFisicoExistente({
    required String projectId,
    required String remoteId,
    required String sealCode,
  }) async {
    final byId = await customSelect(
      'SELECT id FROM cadastros_fisicos WHERE id = ? LIMIT 1',
      variables: [Variable.withString(remoteId)],
    ).getSingleOrNull();

    final id = byId?.data['id']?.toString();
    if (id != null && id.isNotEmpty) return id;

    final bySeal = await customSelect(
      '''
      SELECT id
      FROM cadastros_fisicos
      WHERE projeto_id = ?
        AND codigo_selo = ?
      ORDER BY created_at DESC
      LIMIT 1
      ''',
      variables: [
        Variable.withString(projectId),
        Variable.withString(sealCode),
      ],
    ).getSingleOrNull();

    return bySeal?.data['id']?.toString();
  }

  String? _text(Object? value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  int? _int(Object? value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  double? _double(Object? value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString().replaceAll(',', '.'));
  }

  bool _bool(Object? value) {
    if (value is bool) return value;
    if (value is num) return value != 0;

    final normalized = value?.toString().trim().toLowerCase();

    return normalized == 'true' ||
        normalized == '1' ||
        normalized == 'sim' ||
        normalized == 'yes';
  }

  String? _date(Object? value) {
    if (value == null) return null;

    if (value is DateTime) {
      return value.toUtc().toIso8601String();
    }

    if (value is int) {
      final milliseconds =
          value.abs() < 100000000000 ? value * 1000 : value;

      return DateTime.fromMillisecondsSinceEpoch(
        milliseconds,
        isUtc: true,
      ).toIso8601String();
    }

    return DateTime.tryParse(
      value.toString(),
    )?.toUtc().toIso8601String();
  }

  Future<Map<String, int>> resumoSincronizacaoCadastros() async {
    final queueRows = await customSelect(
      '''
      SELECT status, COUNT(*) AS total
      FROM sync_queue
      WHERE entity_type IN (
        'social_registration',
        'physical_registration'
      )
      GROUP BY status
      ''',
    ).get();

    final syncedRow = await customSelect(
      '''
      SELECT
        (
          SELECT COUNT(*)
          FROM cadastros_sociais
          WHERE synced = 1
        ) +
        (
          SELECT COUNT(*)
          FROM cadastros_fisicos
          WHERE synced = 1
        ) AS total
      ''',
    ).getSingle();

    final result = <String, int>{
      'pending': 0,
      'syncing': 0,
      'synced': (syncedRow.data['total'] as num?)?.toInt() ?? 0,
      'failed': 0,
      'conflict': 0,
    };

    for (final row in queueRows) {
      final status = row.data['status']?.toString() ?? 'pending';
      final total = (row.data['total'] as num?)?.toInt() ?? 0;
      result[status] = total;
    }

    return result;
  }

  Future<List<Map<String, Object?>>> listarFalhasCadastros({
    int limit = 20,
  }) async {
    final rows = await customSelect(
      '''
      SELECT
        entity_id AS id,
        entity_type,
        status AS sync_status,
        last_error AS sync_error,
        attempts AS sync_attempts,
        updated_at AS last_sync_attempt_at
      FROM sync_queue
      WHERE entity_type IN (
        'social_registration',
        'physical_registration'
      )
        AND status IN ('failed', 'conflict')
      ORDER BY updated_at DESC
      LIMIT ?
      ''',
      variables: [Variable.withInt(limit)],
    ).get();

    return rows.map((row) => row.data).toList();
  }
}
