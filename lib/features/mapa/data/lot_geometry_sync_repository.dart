import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/api/api_client.dart';
import '../../../data/local/app_database.dart';
import '../../../data/local/database_provider.dart';
import 'lot_geometry_sync_database.dart';

final lotGeometrySyncRepositoryProvider =
    Provider<LotGeometrySyncRepository>((ref) {
  return LotGeometrySyncRepository(
    dio: ref.watch(dioProvider),
    database: ref.watch(appDatabaseProvider),
  );
});

class LotGeometrySyncRepository {
  LotGeometrySyncRepository({
    required Dio dio,
    required AppDatabase database,
  })  : _dio = dio,
        _database = database;

  final Dio _dio;
  final AppDatabase _database;

  Future<LotGeometrySyncResult> synchronize({
    required String projectId,
    int limit = 500,
    bool pullAfterPush = true,
  }) async {
    final rows = await _database.listarGeometriasPendentes(
      projectId: projectId,
      limit: limit,
    );

    var acceptedCount = 0;
    var rejectedCount = 0;
    var conflictCount = 0;
    var offline = false;
    String? message;

    if (rows.isNotEmpty) {
      final queueIds = rows
          .map((row) => row['queue_id']?.toString())
          .whereType<String>()
          .toList();

      await _database.marcarGeometriasComoSincronizando(queueIds);

      try {
        final response = await _dio.post<Map<String, dynamic>>(
          '/mobile/sync/lot-geometries',
          data: {
            'project_id': projectId,
            'batch_id': const Uuid().v4(),
            'records': rows.map(_serialize).toList(),
          },
        );

        final data = response.data ?? const <String, dynamic>{};
        final accepted = _maps(data['accepted']);
        final rejected = _maps(data['rejected']);
        final conflicts = _maps(data['conflicts']);
        final processed = <String>{};

        acceptedCount = accepted.length;
        rejectedCount = rejected.length;
        conflictCount = conflicts.length;

        for (final item in accepted) {
          final localId = item['source_local_id']?.toString();
          final serverId = item['server_id']?.toString();

          if (localId == null || serverId == null) continue;
          processed.add(localId);

          await _database.marcarGeometriaComoSincronizada(
            localId: localId,
            serverId: serverId,
            version: _asInt(item['version']),
            serverUpdatedAt: DateTime.tryParse(
                  item['server_updated_at']?.toString() ?? '',
                ) ??
                DateTime.now(),
          );
        }

        for (final item in rejected) {
          final localId = item['source_local_id']?.toString();
          if (localId == null) continue;
          processed.add(localId);

          await _database.marcarGeometriaComoFalha(
            localId: localId,
            message: item['reason']?.toString() ??
                'O servidor rejeitou a geometria.',
          );
        }

        for (final item in conflicts) {
          final localId = item['source_local_id']?.toString();
          if (localId == null) continue;
          processed.add(localId);

          await _database.marcarGeometriaComoConflito(
            localId: localId,
            message: item['reason']?.toString() ??
                'A geometria possui conflito de versão.',
          );
        }

        for (final row in rows) {
          final localId = row['id']?.toString();
          if (localId == null || processed.contains(localId)) continue;

          await _database.marcarGeometriaComoFalha(
            localId: localId,
            message: 'O servidor não confirmou o processamento da geometria.',
          );
          rejectedCount++;
        }
      } on DioException catch (error) {
        offline = _isConnectionFailure(error);
        message = _message(error);
        rejectedCount = rows.length;

        for (final row in rows) {
          final localId = row['id']?.toString();
          if (localId == null) continue;

          await _database.marcarGeometriaComoFalha(
            localId: localId,
            message: message,
          );
        }
      } catch (error) {
        message = 'Falha inesperada na sincronização geoespacial: $error';
        rejectedCount = rows.length;

        for (final row in rows) {
          final localId = row['id']?.toString();
          if (localId == null) continue;

          await _database.marcarGeometriaComoFalha(
            localId: localId,
            message: message,
          );
        }
      }
    }

    var pulled = 0;

    if (pullAfterPush && !offline) {
      try {
        pulled = await pull(projectId: projectId);
      } on DioException catch (error) {
        if (rows.isEmpty) {
          offline = _isConnectionFailure(error);
          message = _message(error);
        }
      }
    }

    return LotGeometrySyncResult(
      attempted: rows.length,
      accepted: acceptedCount,
      rejected: rejectedCount,
      conflicts: conflictCount,
      pulled: pulled,
      offline: offline,
      message: message,
    );
  }

  Future<int> pull({
    required String projectId,
    int limit = 1000,
  }) async {
    final cursor = await _database.obterCursorGeometrias(projectId);

    final response = await _dio.get<Map<String, dynamic>>(
      '/mobile/sync/lot-geometries',
      queryParameters: {
        'project_id': projectId,
        'limit': limit,
        if (cursor != null && cursor.isNotEmpty) 'since': cursor,
      },
    );

    final data = response.data ?? const <String, dynamic>{};
    final records = _maps(data['records']);

    for (final record in records) {
      await _database.aplicarGeometriaRemota(record);
    }

    final nextCursor = data['next_cursor']?.toString();

    if (nextCursor != null && nextCursor.isNotEmpty) {
      await _database.salvarCursorGeometrias(
        projectId: projectId,
        cursor: nextCursor,
      );
    }

    return records.length;
  }

  Map<String, dynamic> _serialize(Map<String, Object?> row) {
    final geometryRaw = row['geometria_geojson']?.toString();
    final geometry = geometryRaw == null || geometryRaw.trim().isEmpty
        ? null
        : jsonDecode(geometryRaw);

    final status = row['status']?.toString();

    return {
      'source_local_id': row['id'].toString(),
      'source_device_id': row['source_device_id'].toString(),
      'lot_id': null,
      'seal_id': null,
      'social_registration_id': null,
      'origin': 'cidadao_vetorizado',
      'workflow_status': switch (status) {
        'aguardando_validacao_tecnica' => 'aguardando_validacao',
        'validado_tecnico' => 'validado',
        'rejeitado_tecnico' => 'rejeitado',
        'substituido' => 'substituido',
        _ => 'rascunho',
      },
      'geometry_geojson': geometry,
      'area_m2': row['area_m2'],
      'perimeter_m': row['perimetro_m'],
      'geospatial_accuracy_m': null,
      'notes': row['observacoes']?.toString(),
      'client_created_at': _dateIso(row['created_at']),
      'client_updated_at': _dateIso(row['updated_at']),
      'expected_version':
          row['server_id'] == null ? null : _asInt(row['sync_version']),
      'deleted': _asBool(row['deleted_locally']),
    };
  }

  List<Map<String, dynamic>> _maps(dynamic value) {
    if (value is! List) return const [];

    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  String? _dateIso(Object? value) {
    if (value == null) return null;
    if (value is DateTime) return value.toUtc().toIso8601String();

    if (value is int) {
      final milliseconds = value.abs() < 100000000000 ? value * 1000 : value;

      return DateTime.fromMillisecondsSinceEpoch(
        milliseconds,
        isUtc: true,
      ).toIso8601String();
    }

    return DateTime.tryParse(value.toString())?.toUtc().toIso8601String();
  }

  int _asInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 1;
  }

  bool _asBool(Object? value) {
    if (value is bool) return value;
    if (value is num) return value != 0;

    return value?.toString().toLowerCase() == 'true' ||
        value?.toString() == '1';
  }

  String _message(DioException error) {
    final data = error.response?.data;

    if (data is Map && data['detail'] != null) {
      return data['detail'].toString();
    }

    if (_isConnectionFailure(error)) {
      return 'Sem conexão com o servidor. As geometrias permanecem '
          'protegidas no aparelho.';
    }

    if (error.response?.statusCode == 401) {
      return 'A sessão expirou. Entre novamente no aplicativo.';
    }

    if (error.response?.statusCode == 403) {
      return 'O usuário não possui permissão para sincronizar este projeto.';
    }

    return 'Não foi possível sincronizar as geometrias.';
  }

  bool _isConnectionFailure(DioException error) {
    return error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout;
  }
}

class LotGeometrySyncResult {
  const LotGeometrySyncResult({
    required this.attempted,
    required this.accepted,
    required this.rejected,
    required this.conflicts,
    required this.pulled,
    required this.offline,
    this.message,
  });

  const LotGeometrySyncResult.empty()
      : attempted = 0,
        accepted = 0,
        rejected = 0,
        conflicts = 0,
        pulled = 0,
        offline = false,
        message = null;

  final int attempted;
  final int accepted;
  final int rejected;
  final int conflicts;
  final int pulled;
  final bool offline;
  final String? message;

  bool get allAccepted =>
      attempted > 0 && accepted == attempted && rejected == 0 && conflicts == 0;
}
