import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/api/api_client.dart';
import '../../../data/local/app_database.dart';
import '../../../data/local/database_provider.dart';
import 'field_record_sync_database.dart';

final fieldRecordSyncRepositoryProvider =
    Provider<FieldRecordSyncRepository>((ref) {
  return FieldRecordSyncRepository(
    dio: ref.watch(dioProvider),
    database: ref.watch(appDatabaseProvider),
  );
});

class FieldRecordSyncRepository {
  FieldRecordSyncRepository({
    required Dio dio,
    required AppDatabase database,
  })  : _dio = dio,
        _database = database;

  final Dio _dio;
  final AppDatabase _database;

  Future<FieldRecordSyncResult> synchronize({
    required String projectId,
    int limit = 500,
  }) async {
    await _database.prepararCadastrosPendentes(
      projectId: projectId,
    );

    final queueRows = await _database.listarCadastrosPendentes(
      projectId: projectId,
      limit: limit,
    );

    if (queueRows.isEmpty) {
      return const FieldRecordSyncResult.empty();
    }

    final queueIds = queueRows
        .map((row) => row['queue_id']?.toString())
        .whereType<String>()
        .toList();

    await _database.marcarFilaComoSincronizando(queueIds);

    final sociais = <Map<String, dynamic>>[];
    final fisicos = <Map<String, dynamic>>[];

    for (final queueRow in queueRows) {
      final entityType = queueRow['entity_type']?.toString();
      final localId = queueRow['entity_id']?.toString();

      if (entityType == null || localId == null) {
        continue;
      }

      final cadastro = await _database.buscarCadastroPorId(
        entityType: entityType,
        id: localId,
      );

      if (cadastro == null) {
        await _database.marcarCadastroComoFalha(
          entityType: entityType,
          localId: localId,
          message: 'Cadastro local não encontrado.',
        );

        continue;
      }

      final record = <String, dynamic>{
        'source_local_id': localId,
        'payload': _database.prepararPayloadCadastro(cadastro),
      };

      if (entityType == 'social_registration') {
        sociais.add(record);
      } else {
        fisicos.add(record);
      }
    }

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/mobile/sync/field-records',
        data: {
          'project_id': projectId,
          'batch_id': const Uuid().v4(),
          'social_registrations': sociais,
          'physical_registrations': fisicos,
        },
      );

      final body = response.data ?? const <String, dynamic>{};

      final accepted = _listMaps(body['accepted']);
      final rejected = _listMaps(body['rejected']);

      for (final item in accepted) {
        final entityType = item['entity_type']?.toString();
        final localId = item['source_local_id']?.toString();

        if (entityType == null || localId == null) {
          continue;
        }

        await _database.marcarCadastroComoSincronizado(
          entityType: entityType,
          localId: localId,
        );
      }

      for (final item in rejected) {
        final entityType = item['entity_type']?.toString();
        final localId = item['source_local_id']?.toString();

        if (entityType == null || localId == null) {
          continue;
        }

        await _database.marcarCadastroComoFalha(
          entityType: entityType,
          localId: localId,
          message:
              item['reason']?.toString() ?? 'Cadastro rejeitado pelo servidor.',
        );
      }

      return FieldRecordSyncResult(
        attempted: queueRows.length,
        accepted: accepted.length,
        rejected: rejected.length,
        offline: false,
      );
    } on DioException catch (error) {
      final message = _errorMessage(error);

      for (final queueRow in queueRows) {
        final entityType = queueRow['entity_type']?.toString();
        final localId = queueRow['entity_id']?.toString();

        if (entityType == null || localId == null) {
          continue;
        }

        await _database.marcarCadastroComoFalha(
          entityType: entityType,
          localId: localId,
          message: message,
        );
      }

      return FieldRecordSyncResult(
        attempted: queueRows.length,
        accepted: 0,
        rejected: queueRows.length,
        offline: _isOffline(error),
        message: message,
      );
    }
  }

  List<Map<String, dynamic>> _listMaps(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  bool _isOffline(DioException error) {
    return error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout;
  }

  String _errorMessage(DioException error) {
    final data = error.response?.data;

    if (data is Map && data['detail'] != null) {
      return data['detail'].toString();
    }

    if (_isOffline(error)) {
      return 'Sem conexão com o servidor. Os cadastros permanecem '
          'salvos no aparelho.';
    }

    return 'Não foi possível sincronizar os cadastros social e físico.';
  }
}

class FieldRecordSyncResult {
  const FieldRecordSyncResult({
    required this.attempted,
    required this.accepted,
    required this.rejected,
    required this.offline,
    this.message,
  });

  const FieldRecordSyncResult.empty()
      : attempted = 0,
        accepted = 0,
        rejected = 0,
        offline = false,
        message = null;

  final int attempted;
  final int accepted;
  final int rejected;
  final bool offline;
  final String? message;
}
