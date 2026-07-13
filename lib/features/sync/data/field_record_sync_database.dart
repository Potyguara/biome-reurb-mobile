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
      variables: [
        Variable.withString(projectId),
      ],
    ).get();

    for (final row in rows) {
      final id = row.data['id']?.toString();

      if (id == null || id.trim().isEmpty) {
        continue;
      }

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
      variables: [
        Variable.withString(id),
      ],
    ).getSingleOrNull();

    return row?.data;
  }

  Map<String, dynamic> prepararPayloadCadastro(
    Map<String, Object?> row,
  ) {
    final payload = <String, dynamic>{};

    for (final entry in row.entries) {
      if (entry.key == 'synced') {
        continue;
      }

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
        '''
        DELETE FROM sync_queue
        WHERE id = ?
        ''',
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
        AND status IN ('failed', 'syncing')
      ''',
      [
        now,
        projectId,
      ],
    );
  }

  Future<Map<String, int>> resumoSincronizacaoCadastros() async {
    final queueRows = await customSelect(
      '''
      SELECT
        status,
        COUNT(*) AS total
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
      variables: [
        Variable.withInt(limit),
      ],
    ).get();

    return rows.map((row) => row.data).toList();
  }
}
