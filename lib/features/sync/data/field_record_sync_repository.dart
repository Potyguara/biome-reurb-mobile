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
    await _database.liberarCadastrosParaNovaTentativa(projectId);
    await _database.prepararCadastrosPendentes(projectId: projectId);

    final queueRows = await _database.listarCadastrosPendentes(
      projectId: projectId,
      limit: limit,
    );

    var attempted = queueRows.length;
    var acceptedCount = 0;
    var rejectedCount = 0;

    try {
      if (queueRows.isNotEmpty) {
        final queueIds = queueRows
            .map((row) => row['queue_id']?.toString())
            .whereType<String>()
            .where((id) => id.isNotEmpty)
            .toList();

        await _database.marcarFilaComoSincronizando(queueIds);

        final sociais = <Map<String, dynamic>>[];
        final fisicos = <Map<String, dynamic>>[];

        for (final queueRow in queueRows) {
          final entityType = queueRow['entity_type']?.toString();
          final localId = queueRow['entity_id']?.toString();

          if (entityType == null || localId == null) continue;

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
            rejectedCount++;
            continue;
          }

          final record = <String, dynamic>{
            'source_local_id': localId,
            'payload': _database.prepararPayloadCadastro(cadastro),
          };

          if (entityType == 'social_registration') {
            sociais.add(record);
          } else if (entityType == 'physical_registration') {
            fisicos.add(record);
          }
        }

        if (sociais.isNotEmpty || fisicos.isNotEmpty) {
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
          final processed = <String>{};

          for (final item in accepted) {
            final entityType = item['entity_type']?.toString();
            final localId = item['source_local_id']?.toString();
            if (entityType == null || localId == null) continue;

            processed.add('$entityType:$localId');

            await _database.marcarCadastroComoSincronizado(
              entityType: entityType,
              localId: localId,
            );
          }

          for (final item in rejected) {
            final entityType = item['entity_type']?.toString();
            final localId = item['source_local_id']?.toString();
            if (entityType == null || localId == null) continue;

            processed.add('$entityType:$localId');

            await _database.marcarCadastroComoFalha(
              entityType: entityType,
              localId: localId,
              message: item['reason']?.toString() ??
                  'Cadastro rejeitado pelo servidor.',
            );
          }

          for (final queueRow in queueRows) {
            final entityType = queueRow['entity_type']?.toString();
            final localId = queueRow['entity_id']?.toString();
            if (entityType == null || localId == null) continue;
            if (processed.contains('$entityType:$localId')) continue;

            await _database.marcarCadastroComoFalha(
              entityType: entityType,
              localId: localId,
              message: 'O servidor não confirmou o processamento do cadastro.',
            );
          }

          acceptedCount = accepted.length;
          rejectedCount += rejected.length;
        }
      }

      await _pullRemoteRecords(projectId: projectId);

      return FieldRecordSyncResult(
        attempted: attempted,
        accepted: acceptedCount,
        rejected: rejectedCount,
        offline: false,
      );
    } on DioException catch (error) {
      final message = _errorMessage(error);

      for (final queueRow in queueRows) {
        final entityType = queueRow['entity_type']?.toString();
        final localId = queueRow['entity_id']?.toString();
        if (entityType == null || localId == null) continue;

        await _database.marcarCadastroComoFalha(
          entityType: entityType,
          localId: localId,
          message: message,
        );
      }

      return FieldRecordSyncResult(
        attempted: attempted,
        accepted: 0,
        rejected: queueRows.isEmpty ? 0 : queueRows.length,
        offline: _isOffline(error),
        message: message,
      );
    } catch (error) {
      final message = 'Falha inesperada ao sincronizar cadastros: $error';

      return FieldRecordSyncResult(
        attempted: attempted,
        accepted: 0,
        rejected: queueRows.isEmpty ? 0 : queueRows.length,
        offline: false,
        message: message,
      );
    }
  }

  Future<int> _pullRemoteRecords({
    required String projectId,
    int limit = 5000,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/mobile/sync/field-records',
      queryParameters: {
        'project_id': projectId,
        'limit': limit,
      },
    );

    final body = response.data ?? const <String, dynamic>{};
    final sociais = _listMaps(body['social_registrations']);
    final fisicos = _listMaps(body['physical_registrations']);

    await _database.aplicarCadastrosRemotos(
      projectId: projectId,
      socialRegistrations: sociais,
      physicalRegistrations: fisicos,
    );

    return sociais.length + fisicos.length;
  }

  List<Map<String, dynamic>> _listMaps(dynamic value) {
    if (value is! List) return const <Map<String, dynamic>>[];

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

    final statusCode = error.response?.statusCode;

    if (statusCode == 401) {
      return 'A sessão expirou. Entre novamente no aplicativo.';
    }

    if (statusCode == 403) {
      return 'O usuário não possui permissão para sincronizar este projeto.';
    }

    if (statusCode != null && statusCode >= 500) {
      return 'O servidor está temporariamente indisponível.';
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
