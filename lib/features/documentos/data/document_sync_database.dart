import 'package:drift/drift.dart';

import '../../../data/local/app_database.dart';

extension DocumentSyncDatabase on AppDatabase {
  /// Corrige documentos antigos que foram gravados com o próprio ID do
  /// documento no campo source_device_id.
  ///
  /// Também atribui a identidade do aparelho aos registros que ainda não
  /// possuem source_device_id.
  Future<void> prepararIdentidadeDocumentos({
    required String projectId,
    required String sourceDeviceId,
  }) async {
    final now = DateTime.now().toUtc().toIso8601String();

    await customStatement(
      '''
      UPDATE documentos_reurb
      SET
        source_device_id = ?,
        synced = 0,
        sync_status = 'pending',
        sync_error = NULL,
        local_updated_at = ?
      WHERE projeto_id = ?
        AND (
          source_device_id IS NULL
          OR TRIM(source_device_id) = ''
          OR source_device_id = id
        )
      ''',
      [
        sourceDeviceId,
        now,
        projectId,
      ],
    );
  }

  /// Garante que todos os documentos locais ainda não sincronizados estejam
  /// presentes na fila geral de sincronização.
  Future<void> prepararDocumentosPendentes({
    required String projectId,
  }) async {
    final rows = await customSelect(
      '''
      SELECT id
      FROM documentos_reurb
      WHERE projeto_id = ?
        AND (
          synced = 0
          OR sync_status IN ('pending', 'failed', 'conflict')
          OR deleted_locally = 1
        )
      ''',
      variables: [
        Variable.withString(projectId),
      ],
    ).get();

    for (final row in rows) {
      final documentId = row.data['id']?.toString().trim();

      if (documentId == null || documentId.isEmpty) {
        continue;
      }

      await enfileirarSincronizacao(
        entityType: 'document',
        entityId: documentId,
        projectId: projectId,
      );
    }
  }

  Future<List<Map<String, Object?>>> listarDocumentosPendentes({
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
        q.operation,
        q.status AS queue_status,
        q.attempts AS queue_attempts,
        q.last_error AS queue_last_error,
        q.created_at AS queue_created_at,
        q.updated_at AS queue_updated_at,

        d.id,
        d.projeto_id,
        d.selagem_id,
        d.cadastro_social_id,
        d.codigo_selo,
        d.tipo_documento,
        d.arquivo_path,
        d.observacoes,
        d.synced,
        d.source_device_id,
        d.sync_status,
        d.sync_attempts,
        d.sync_error,
        d.last_sync_attempt_at,
        d.synced_at,
        d.local_updated_at,
        d.server_updated_at,
        d.sync_version,
        d.deleted_locally,
        d.created_at
      FROM sync_queue q
      INNER JOIN documentos_reurb d
        ON d.id = q.entity_id
      WHERE q.project_id = ?
        AND q.entity_type = 'document'
        AND q.status IN ('pending', 'failed', 'conflict')
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

  Future<Map<String, Object?>?> buscarDocumentoParaSincronizacao({
    required String documentId,
  }) async {
    final row = await customSelect(
      '''
      SELECT
        id,
        projeto_id,
        selagem_id,
        cadastro_social_id,
        codigo_selo,
        tipo_documento,
        arquivo_path,
        observacoes,
        synced,
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
      FROM documentos_reurb
      WHERE id = ?
      LIMIT 1
      ''',
      variables: [
        Variable.withString(documentId),
      ],
    ).getSingleOrNull();

    return row?.data;
  }

  Future<void> marcarDocumentosComoSincronizando(
    List<String> queueIds,
  ) async {
    if (queueIds.isEmpty) {
      return;
    }

    final now = DateTime.now().toUtc().toIso8601String();

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

        final documentId = _documentIdFromQueueId(queueId);

        if (documentId == null) {
          continue;
        }

        await customStatement(
          '''
          UPDATE documentos_reurb
          SET
            sync_status = 'syncing',
            sync_attempts = sync_attempts + 1,
            sync_error = NULL,
            last_sync_attempt_at = ?
          WHERE id = ?
          ''',
          [
            now,
            documentId,
          ],
        );
      }
    });
  }

  Future<void> marcarDocumentoComoMetadadosAceitos({
    required String localId,
    required int syncVersion,
    required DateTime serverUpdatedAt,
  }) async {
    await customStatement(
      '''
      UPDATE documentos_reurb
      SET
        sync_version = ?,
        server_updated_at = ?,
        sync_status = 'metadata_synced',
        sync_error = NULL,
        last_sync_attempt_at = ?
      WHERE id = ?
      ''',
      [
        syncVersion,
        serverUpdatedAt.toUtc().toIso8601String(),
        DateTime.now().toUtc().toIso8601String(),
        localId,
      ],
    );
  }

  /// Deve ser chamado somente depois que:
  ///
  /// 1. os metadados foram aceitos; e
  /// 2. o arquivo físico foi enviado com sucesso;
  ///
  /// Para exclusões, pode ser chamado imediatamente após a aceitação dos
  /// metadados, pois não existe arquivo para enviar.
  Future<void> marcarDocumentoComoSincronizado({
    required String localId,
    required int syncVersion,
    required DateTime serverUpdatedAt,
  }) async {
    final now = DateTime.now().toUtc().toIso8601String();

    await transaction(() async {
      await customStatement(
        '''
        UPDATE documentos_reurb
        SET
          synced = 1,
          sync_status = 'synced',
          sync_attempts = 0,
          sync_error = NULL,
          last_sync_attempt_at = ?,
          synced_at = ?,
          server_updated_at = ?,
          sync_version = ?
        WHERE id = ?
        ''',
        [
          now,
          now,
          serverUpdatedAt.toUtc().toIso8601String(),
          syncVersion,
          localId,
        ],
      );

      await customStatement(
        '''
        DELETE FROM sync_queue
        WHERE id = ?
        ''',
        [
          'document:$localId',
        ],
      );
    });
  }

  Future<void> marcarDocumentoComoFalha({
    required String localId,
    required String message,
  }) async {
    final now = DateTime.now().toUtc();
    final nextAttempt = now.add(const Duration(minutes: 1));

    await transaction(() async {
      await customStatement(
        '''
        UPDATE documentos_reurb
        SET
          synced = 0,
          sync_status = 'failed',
          sync_error = ?,
          last_sync_attempt_at = ?
        WHERE id = ?
        ''',
        [
          message,
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
          'document:$localId',
        ],
      );
    });
  }

  Future<void> marcarDocumentoComoConflito({
    required String localId,
    required int currentSyncVersion,
    required String message,
  }) async {
    final now = DateTime.now().toUtc().toIso8601String();

    await transaction(() async {
      await customStatement(
        '''
        UPDATE documentos_reurb
        SET
          synced = 0,
          sync_status = 'conflict',
          sync_error = ?,
          sync_version = ?,
          last_sync_attempt_at = ?
        WHERE id = ?
        ''',
        [
          message,
          currentSyncVersion,
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
          next_attempt_at = NULL,
          updated_at = ?
        WHERE id = ?
        ''',
        [
          message,
          now,
          'document:$localId',
        ],
      );
    });
  }

  Future<void> liberarDocumentosParaNovaTentativa(
    String projectId,
  ) async {
    final now = DateTime.now().toUtc().toIso8601String();

    await transaction(() async {
      await customStatement(
        '''
        UPDATE sync_queue
        SET
          status = 'pending',
          last_error = NULL,
          next_attempt_at = NULL,
          updated_at = ?
        WHERE project_id = ?
          AND entity_type = 'document'
          AND status IN ('syncing', 'failed')
        ''',
        [
          now,
          projectId,
        ],
      );

      await customStatement(
        '''
        UPDATE documentos_reurb
        SET
          synced = 0,
          sync_status = 'pending',
          sync_error = NULL
        WHERE projeto_id = ?
          AND sync_status IN ('syncing', 'failed', 'metadata_synced')
        ''',
        [
          projectId,
        ],
      );
    });
  }

  Map<String, dynamic> prepararPayloadDocumento(
    Map<String, Object?> row,
  ) {
    final sourceLocalId = _requiredText(
      row['id'],
      fieldName: 'id',
    );

    final sourceDeviceId = _requiredText(
      row['source_device_id'],
      fieldName: 'source_device_id',
    );

    final sealCode = _requiredText(
      row['codigo_selo'],
      fieldName: 'codigo_selo',
    );

    final documentType = _requiredText(
      row['tipo_documento'],
      fieldName: 'tipo_documento',
    );

    final filePath = _nullableText(row['arquivo_path']);
    final deleted = _toBool(row['deleted_locally']);
    final syncVersion = _toInt(row['sync_version']);

    return <String, dynamic>{
      'source_local_id': sourceLocalId,
      'source_device_id': sourceDeviceId,

      // O backend aceita essas referências como opcionais.
      //
      // Os IDs locais só devem ser enviados quando correspondem aos UUIDs
      // reconhecidos pelo backend. Na estrutura atual do projeto, mantemos os
      // vínculos de selagem e cadastro social e o backend fará a validação.
      // Os IDs salvos no SQLite são identificadores locais e não podem ser
      // utilizados diretamente como chaves estrangeiras do PostgreSQL.
      //
      // O vínculo continuará disponível por projeto e código da selagem.
      // Posteriormente poderemos enviar os IDs remotos quando o banco local
      // armazenar explicitamente o server_id de cada entidade sincronizada.
      'lot_id': null,
      'seal_id': null,
      'social_registration_id': null,

      'seal_code': sealCode,
      'document_type': documentType,
      'original_filename': deleted ? null : _basenameFromPath(filePath),
      'stored_filename': null,
      'mime_type': deleted ? null : _mimeTypeFromPath(filePath),
      'file_size_bytes': null,
      'notes': _nullableText(row['observacoes']),
      'client_created_at': _isoDate(row['created_at']),
      'client_updated_at': _isoDate(row['local_updated_at']),
      'expected_sync_version':
          syncVersion != null && syncVersion > 0 ? syncVersion : null,
      'deleted': deleted,
    };
  }

  Future<void> aplicarDocumentosRemotos({
    required String projectId,
    required List<RemoteDocumentLocalFile> documents,
  }) async {
    await transaction(() async {
      for (final item in documents) {
        await _aplicarDocumentoRemoto(
          projectId: projectId,
          item: item,
        );
      }
    });
  }

  Future<void> _aplicarDocumentoRemoto({
    required String projectId,
    required RemoteDocumentLocalFile item,
  }) async {
    final record = item.record;

    final serverId = _nullableText(record['id']);
    final sourceLocalId = _nullableText(record['source_local_id']);
    final sourceDeviceId = _nullableText(record['source_device_id']);
    final deleted = _toBool(record['deleted']);

    final localId = sourceLocalId ?? serverId;

    if (localId == null || localId.isEmpty) {
      return;
    }

    final existing = await customSelect(
      '''
      SELECT
        id,
        sync_status,
        sync_version,
        local_updated_at,
        deleted_locally
      FROM documentos_reurb
      WHERE id = ?
      LIMIT 1
      ''',
      variables: [
        Variable.withString(localId),
      ],
    ).getSingleOrNull();

    final existingData = existing?.data;
    final localPending = existingData != null &&
        (existingData['sync_status']?.toString() == 'pending' ||
            existingData['sync_status']?.toString() == 'syncing' ||
            existingData['sync_status']?.toString() == 'failed' ||
            existingData['sync_status']?.toString() == 'conflict' ||
            !_toBool(existingData['deleted_locally']) &&
                _toInt(existingData['sync_version']) !=
                    _toInt(record['sync_version']));

    // Não sobrescreve silenciosamente uma edição local ainda pendente.
    if (localPending) {
      return;
    }

    if (deleted) {
      await customStatement(
        '''
        UPDATE documentos_reurb
        SET
          synced = 1,
          sync_status = 'synced',
          sync_error = NULL,
          deleted_locally = 1,
          sync_version = ?,
          server_updated_at = ?,
          synced_at = ?
        WHERE id = ?
        ''',
        [
          _toInt(record['sync_version']) ?? 1,
          _isoDate(record['updated_at']),
          DateTime.now().toUtc().toIso8601String(),
          localId,
        ],
      );

      await customStatement(
        '''
        DELETE FROM sync_queue
        WHERE id = ?
        ''',
        [
          'document:$localId',
        ],
      );

      return;
    }

    final filePath = _nullableText(item.localFilePath);

    // A tabela documentos_reurb exige arquivo_path não nulo. Portanto, um
    // documento remoto só é inserido depois que seu arquivo físico foi
    // baixado.
    if (filePath == null) {
      return;
    }

    final sealCode = _nullableText(record['seal_code']);
    final documentType = _nullableText(record['document_type']);

    if (sealCode == null || documentType == null) {
      return;
    }

    final createdAt = _isoDate(record['client_created_at']) ??
        _isoDate(record['created_at']) ??
        DateTime.now().toUtc().toIso8601String();

    final localUpdatedAt = _isoDate(record['client_updated_at']) ??
        _isoDate(record['updated_at']) ??
        DateTime.now().toUtc().toIso8601String();

    final serverUpdatedAt = _isoDate(record['updated_at']) ??
        DateTime.now().toUtc().toIso8601String();

    await customStatement(
      '''
      INSERT INTO documentos_reurb (
        id,
        projeto_id,
        selagem_id,
        cadastro_social_id,
        codigo_selo,
        tipo_documento,
        arquivo_path,
        observacoes,
        synced,
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
        ?, ?, ?, ?, ?, ?, ?, ?, 1, ?, 'synced', 0, NULL, NULL, ?, ?, ?, ?, 0, ?
      )
      ON CONFLICT(id) DO UPDATE SET
        projeto_id = excluded.projeto_id,
        selagem_id = excluded.selagem_id,
        cadastro_social_id = excluded.cadastro_social_id,
        codigo_selo = excluded.codigo_selo,
        tipo_documento = excluded.tipo_documento,
        arquivo_path = excluded.arquivo_path,
        observacoes = excluded.observacoes,
        synced = 1,
        source_device_id = excluded.source_device_id,
        sync_status = 'synced',
        sync_attempts = 0,
        sync_error = NULL,
        synced_at = excluded.synced_at,
        local_updated_at = excluded.local_updated_at,
        server_updated_at = excluded.server_updated_at,
        sync_version = excluded.sync_version,
        deleted_locally = 0
      ''',
      [
        localId,
        projectId,
        _nullableUuidText(record['seal_id']),
        _nullableUuidText(record['social_registration_id']),
        sealCode,
        documentType,
        filePath,
        _nullableText(record['notes']),
        sourceDeviceId,
        DateTime.now().toUtc().toIso8601String(),
        localUpdatedAt,
        serverUpdatedAt,
        _toInt(record['sync_version']) ?? 1,
        createdAt,
      ],
    );

    await customStatement(
      '''
      DELETE FROM sync_queue
      WHERE id = ?
      ''',
      [
        'document:$localId',
      ],
    );
  }

  Future<Map<String, int>> resumoSincronizacaoDocumentos() async {
    final row = await customSelect(
      '''
      SELECT
        SUM(
          CASE
            WHEN sync_status = 'pending' THEN 1
            ELSE 0
          END
        ) AS pending,
        SUM(
          CASE
            WHEN sync_status IN ('syncing', 'metadata_synced') THEN 1
            ELSE 0
          END
        ) AS syncing,
        SUM(
          CASE
            WHEN sync_status = 'synced' THEN 1
            ELSE 0
          END
        ) AS synced,
        SUM(
          CASE
            WHEN sync_status = 'failed' THEN 1
            ELSE 0
          END
        ) AS failed,
        SUM(
          CASE
            WHEN sync_status = 'conflict' THEN 1
            ELSE 0
          END
        ) AS conflict
      FROM documentos_reurb
      ''',
    ).getSingle();

    return {
      'pending': _toInt(row.data['pending']) ?? 0,
      'syncing': _toInt(row.data['syncing']) ?? 0,
      'synced': _toInt(row.data['synced']) ?? 0,
      'failed': _toInt(row.data['failed']) ?? 0,
      'conflict': _toInt(row.data['conflict']) ?? 0,
    };
  }

  Future<List<Map<String, Object?>>> listarFalhasDocumentos({
    int limit = 20,
  }) async {
    final rows = await customSelect(
      '''
      SELECT
        id AS entity_id,
        projeto_id AS project_id,
        codigo_selo,
        tipo_documento,
        sync_status AS status,
        sync_attempts AS attempts,
        sync_error AS last_error,
        last_sync_attempt_at AS updated_at
      FROM documentos_reurb
      WHERE sync_status IN ('failed', 'conflict')
      ORDER BY
        COALESCE(last_sync_attempt_at, local_updated_at) DESC
      LIMIT ?
      ''',
      variables: [
        Variable.withInt(limit),
      ],
    ).get();

    return rows.map((row) => row.data).toList();
  }

  String? _documentIdFromQueueId(String queueId) {
    const prefix = 'document:';

    if (!queueId.startsWith(prefix)) {
      return null;
    }

    final value = queueId.substring(prefix.length).trim();

    return value.isEmpty ? null : value;
  }

  String _requiredText(
    Object? value, {
    required String fieldName,
  }) {
    final result = _nullableText(value);

    if (result == null) {
      throw StateError(
        'O campo obrigatório "$fieldName" não foi preenchido.',
      );
    }

    return result;
  }

  String? _nullableText(Object? value) {
    if (value == null) {
      return null;
    }

    final text = value.toString().trim();

    return text.isEmpty ? null : text;
  }

  String? _nullableUuidText(Object? value) {
    final text = _nullableText(value);

    if (text == null) {
      return null;
    }

    final uuidPattern = RegExp(
      r'^[0-9a-fA-F]{8}-'
      r'[0-9a-fA-F]{4}-'
      r'[1-5][0-9a-fA-F]{3}-'
      r'[89abAB][0-9a-fA-F]{3}-'
      r'[0-9a-fA-F]{12}$',
    );

    return uuidPattern.hasMatch(text) ? text : null;
  }

  int? _toInt(Object? value) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    return int.tryParse(value.toString());
  }

  bool _toBool(Object? value) {
    if (value is bool) {
      return value;
    }

    if (value is int) {
      return value != 0;
    }

    final normalized = value?.toString().trim().toLowerCase();

    return normalized == '1' ||
        normalized == 'true' ||
        normalized == 'yes' ||
        normalized == 'sim';
  }

  String? _isoDate(Object? value) {
    if (value == null) {
      return null;
    }

    if (value is DateTime) {
      return value.toUtc().toIso8601String();
    }

    final parsed = DateTime.tryParse(value.toString());

    return parsed?.toUtc().toIso8601String();
  }

  String? _basenameFromPath(String? path) {
    if (path == null || path.isEmpty) {
      return null;
    }

    final normalized = path.replaceAll('\\', '/');
    final segments = normalized.split('/');

    return segments.isEmpty ? null : segments.last;
  }

  String? _mimeTypeFromPath(String? path) {
    final filename = _basenameFromPath(path)?.toLowerCase();

    if (filename == null) {
      return null;
    }

    if (filename.endsWith('.jpg') || filename.endsWith('.jpeg')) {
      return 'image/jpeg';
    }

    if (filename.endsWith('.png')) {
      return 'image/png';
    }

    if (filename.endsWith('.webp')) {
      return 'image/webp';
    }

    if (filename.endsWith('.pdf')) {
      return 'application/pdf';
    }

    if (filename.endsWith('.doc')) {
      return 'application/msword';
    }

    if (filename.endsWith('.docx')) {
      return 'application/vnd.openxmlformats-officedocument.'
          'wordprocessingml.document';
    }

    return 'application/octet-stream';
  }
}

class RemoteDocumentLocalFile {
  const RemoteDocumentLocalFile({
    required this.record,
    this.localFilePath,
  });

  final Map<String, dynamic> record;
  final String? localFilePath;
}
