import 'package:drift/drift.dart';

import '../../../data/local/app_database.dart';

extension SealRemoteSyncDatabase on AppDatabase {
  Future<Map<String, Object?>?> _buscarSelagemRemotaLocal({
    required String serverId,
    String? sourceLocalId,
    String? sourceDeviceId,
    String? sealCode,
    required String projectId,
  }) async {
    final row = await customSelect(
      '''
      SELECT *
      FROM selagens
      WHERE
        server_id = ?
        OR (
          ? IS NOT NULL
          AND id = ?
          AND (
            ? IS NULL
            OR source_device_id = ?
          )
        )
        OR (
          ? IS NOT NULL
          AND codigo_selo = ?
          AND projeto_id = ?
        )
      LIMIT 1
      ''',
      variables: [
        Variable.withString(serverId),
        Variable.withString(sourceLocalId!),
        Variable.withString(sourceLocalId),
        Variable.withString(sourceDeviceId!),
        Variable.withString(sourceDeviceId),
        Variable.withString(sealCode!),
        Variable.withString(sealCode),
        Variable.withString(projectId),
      ],
    ).getSingleOrNull();

    return row?.data;
  }

  Future<void> aplicarSelagemRemota(
    Map<String, dynamic> record,
  ) async {
    final serverId = record['id']?.toString();
    final projectId = record['project_id']?.toString();
    final sourceLocalId = record['source_local_id']?.toString();
    final sourceDeviceId = record['source_device_id']?.toString();
    final sealCode = record['seal_code']?.toString();

    if (serverId == null ||
        serverId.isEmpty ||
        projectId == null ||
        projectId.isEmpty ||
        sealCode == null ||
        sealCode.isEmpty) {
      return;
    }

    final existing = await _buscarSelagemRemotaLocal(
      serverId: serverId,
      sourceLocalId: sourceLocalId,
      sourceDeviceId: sourceDeviceId,
      sealCode: sealCode,
      projectId: projectId,
    );

    final localId = existing?['id']?.toString() ??
        (sourceLocalId != null && sourceLocalId.isNotEmpty
            ? sourceLocalId
            : serverId);

    final deleted = _remoteBool(record['deleted']);

    if (deleted) {
      await _removerSelagemExcluidaRemotamente(
        localId: localId,
        sealCode: sealCode,
        projectId: projectId,
      );
      return;
    }

    final now = DateTime.now().toUtc().toIso8601String();
    final createdAt =
        _remoteDate(record['created_at']) ?? existing?['created_at'] ?? now;
    final serverUpdatedAt =
        _remoteDate(record['updated_at']) ?? _remoteDate(record['server_time']);

    await customStatement(
      '''
      INSERT INTO selagens (
        id,
        projeto_id,
        lote_id,
        lote_preliminar_id,
        codigo_lote_preliminar,
        status_vinculo_geografico,
        necessita_validacao_rtk,
        observacao_geoespacial,
        codigo_selo,
        situacao,
        morador_presente,
        moradia_ocupada,
        situacao_atendimento,
        tipo_unidade,
        uso_imovel,
        nome_informante,
        telefone_informante,
        relacao_informante,
        revisita_necessaria,
        latitude,
        longitude,
        precisao_gps,
        foto_fachada_path,
        observacoes,
        synced,
        server_id,
        source_device_id,
        sync_status,
        sync_attempts,
        sync_error,
        last_sync_attempt_at,
        synced_at,
        local_updated_at,
        server_updated_at,
        sync_version,
        deleted_locally,
        created_at
      ) VALUES (
        ?, ?, NULL, NULL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,
        ?, ?, ?, ?, ?, 1, ?, ?, 'synced', 0, NULL, NULL, ?, ?, ?, ?, 0, ?
      )
      ON CONFLICT(id) DO UPDATE SET
        projeto_id = excluded.projeto_id,
        codigo_lote_preliminar = excluded.codigo_lote_preliminar,
        status_vinculo_geografico = excluded.status_vinculo_geografico,
        necessita_validacao_rtk = excluded.necessita_validacao_rtk,
        observacao_geoespacial = excluded.observacao_geoespacial,
        codigo_selo = excluded.codigo_selo,
        situacao = excluded.situacao,
        morador_presente = excluded.morador_presente,
        moradia_ocupada = excluded.moradia_ocupada,
        situacao_atendimento = excluded.situacao_atendimento,
        tipo_unidade = excluded.tipo_unidade,
        uso_imovel = excluded.uso_imovel,
        nome_informante = excluded.nome_informante,
        telefone_informante = excluded.telefone_informante,
        relacao_informante = excluded.relacao_informante,
        revisita_necessaria = excluded.revisita_necessaria,
        latitude = excluded.latitude,
        longitude = excluded.longitude,
        precisao_gps = excluded.precisao_gps,
        foto_fachada_path = excluded.foto_fachada_path,
        observacoes = excluded.observacoes,
        synced = 1,
        server_id = excluded.server_id,
        source_device_id = excluded.source_device_id,
        sync_status = 'synced',
        sync_attempts = 0,
        sync_error = NULL,
        synced_at = excluded.synced_at,
        server_updated_at = excluded.server_updated_at,
        sync_version = excluded.sync_version,
        deleted_locally = 0
      ''',
      [
        localId,
        projectId,
        _remoteText(record['lot_code']),
        _remoteText(record['geo_link_status']) ?? 'nao_validado',
        _remoteBool(record['needs_rtk_validation']) ? 1 : 0,
        _remoteText(record['geospatial_note']),
        sealCode,
        _remoteText(record['situation']) ?? 'ocupado',
        _remoteNullableBool(record['resident_present']),
        _remoteNullableBool(record['dwelling_occupied']),
        _remoteText(record['service_status']),
        _remoteText(record['unit_type']),
        _remoteText(record['property_use']),
        _remoteText(record['informant_name']),
        _remoteText(record['informant_phone']),
        _remoteText(record['informant_relationship']),
        _remoteBool(record['revisit_required']) ? 1 : 0,
        _remoteDouble(record['latitude']),
        _remoteDouble(record['longitude']),
        _remoteDouble(record['gps_accuracy']),
        _remoteText(record['facade_photo_path']),
        _remoteText(record['notes']),
        serverId,
        sourceDeviceId,
        now,
        now,
        serverUpdatedAt,
        _remoteInt(record['sync_version'], fallback: 1),
        createdAt,
      ],
    );

    await customStatement(
      '''
      DELETE FROM sync_queue
      WHERE entity_type = 'seal'
        AND entity_id = ?
      ''',
      [localId],
    );
  }

  Future<void> _removerSelagemExcluidaRemotamente({
    required String localId,
    required String sealCode,
    required String projectId,
  }) async {
    await transaction(() async {
      await customStatement(
        '''
        DELETE FROM sync_queue
        WHERE entity_type = 'lot_geometry'
          AND entity_id IN (
            SELECT id
            FROM lotes_vetorizados_cidadao
            WHERE selagem_id = ?
               OR (
                 codigo_selo = ?
                 AND projeto_id = ?
               )
          )
        ''',
        [localId, sealCode, projectId],
      );

      await customStatement(
        '''
        DELETE FROM sync_queue
        WHERE entity_type = 'social_registration'
          AND entity_id IN (
            SELECT id
            FROM cadastros_sociais
            WHERE selagem_id = ?
               OR codigo_selo = ?
          )
        ''',
        [localId, sealCode],
      );

      await customStatement(
        '''
        DELETE FROM sync_queue
        WHERE entity_type = 'physical_registration'
          AND entity_id IN (
            SELECT id
            FROM cadastros_fisicos
            WHERE selagem_id = ?
               OR codigo_selo = ?
          )
        ''',
        [localId, sealCode],
      );

      await customStatement(
        '''
        DELETE FROM sync_queue
        WHERE entity_type = 'seal'
          AND entity_id = ?
        ''',
        [localId],
      );

      await customStatement(
        '''
        DELETE FROM lotes_vetorizados_cidadao
        WHERE selagem_id = ?
           OR (
             codigo_selo = ?
             AND projeto_id = ?
           )
        ''',
        [localId, sealCode, projectId],
      );

      await customStatement(
        '''
        DELETE FROM documentos_reurb
        WHERE selagem_id = ?
           OR codigo_selo = ?
        ''',
        [localId, sealCode],
      );

      await customStatement(
        '''
        DELETE FROM cadastros_sociais
        WHERE selagem_id = ?
           OR codigo_selo = ?
        ''',
        [localId, sealCode],
      );

      await customStatement(
        '''
        DELETE FROM cadastros_fisicos
        WHERE selagem_id = ?
           OR codigo_selo = ?
        ''',
        [localId, sealCode],
      );

      await customStatement(
        '''
        DELETE FROM selagens
        WHERE id = ?
           OR server_id = ?
           OR (
             codigo_selo = ?
             AND projeto_id = ?
           )
        ''',
        [localId, localId, sealCode, projectId],
      );
    });
  }

  String? _remoteText(Object? value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  bool _remoteBool(Object? value) {
    if (value is bool) return value;
    if (value is num) return value != 0;

    final normalized = value?.toString().toLowerCase().trim();
    return normalized == 'true' || normalized == '1';
  }

  int? _remoteNullableBool(Object? value) {
    if (value == null) return null;
    return _remoteBool(value) ? 1 : 0;
  }

  int _remoteInt(Object? value, {required int fallback}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  double? _remoteDouble(Object? value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString().replaceAll(',', '.'));
  }

  String? _remoteDate(Object? value) {
    if (value == null) return null;

    if (value is DateTime) {
      return value.toUtc().toIso8601String();
    }

    return DateTime.tryParse(value.toString())?.toUtc().toIso8601String();
  }
}
