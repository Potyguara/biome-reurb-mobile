import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';
import '../../../data/local/app_database.dart';
import '../../../data/local/database_provider.dart';

final sealSyncRepositoryProvider = Provider<SealSyncRepository>((ref) {
  return SealSyncRepository(
    dio: ref.watch(dioProvider),
    database: ref.watch(appDatabaseProvider),
  );
});

class SealSyncRepository {
  SealSyncRepository({
    required Dio dio,
    required AppDatabase database,
  })  : _dio = dio,
        _database = database;

  final Dio _dio;
  final AppDatabase _database;

  Future<SealSyncResult> synchronize({
    required String projectId,
    int limit = 100,
  }) async {
    await _database.restaurarFilaPresaEmSincronizacao();

    final queueRows = await _database.listarFilaPendente(
      entityType: 'seal',
      limit: limit,
    );

    final projectRows = queueRows
        .where((row) => row['project_id']?.toString() == projectId)
        .toList();

    if (projectRows.isEmpty) {
      return const SealSyncResult.empty();
    }

    final records = <Map<String, dynamic>>[];
    final localIds = <String>[];
    final queueIds = <String>[];

    for (final queueRow in projectRows) {
      final localId = queueRow['entity_id']?.toString();
      if (localId == null || localId.isEmpty) continue;

      final seal = await _database.buscarSelagemPorId(localId);
      if (seal == null) continue;

      records.add(_serializeSeal(seal));
      localIds.add(localId);
      queueIds.add(queueRow['id']?.toString() ?? 'seal:$localId');
    }

    if (records.isEmpty) {
      return const SealSyncResult.empty();
    }

    await _database.marcarFilaComoSincronizando(queueIds);

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/mobile/sync/seals',
        data: {
          'project_id': projectId,
          'batch_id': const Uuid().v4(),
          'records': records,
        },
      );

      final data = response.data;
      if (data == null) {
        throw const ApiException(
          'O servidor retornou uma resposta de sincronização inválida.',
        );
      }

      final accepted = _listOfMaps(data['accepted']);
      final rejected = _listOfMaps(data['rejected']);
      final conflicts = _listOfMaps(data['conflicts']);
      final processed = <String>{};

      for (final item in accepted) {
        final localId = item['source_local_id']?.toString();
        final serverId = item['server_id']?.toString();
        if (localId == null || serverId == null) continue;

        processed.add(localId);

        await _database.marcarSelagemComoSincronizada(
          localId: localId,
          serverId: serverId,
          syncVersion: _asInt(item['sync_version']),
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

        await _database.marcarSelagemComoFalha(
          localId: localId,
          message:
              item['reason']?.toString() ?? 'O servidor rejeitou a selagem.',
        );
      }

      for (final item in conflicts) {
        final localId = item['source_local_id']?.toString();
        if (localId == null) continue;

        processed.add(localId);

        await _database.marcarSelagemComoConflito(
          localId: localId,
          message: item['reason']?.toString() ??
              'A selagem possui alterações conflitantes no servidor.',
        );
      }

      for (final localId in localIds.where((id) => !processed.contains(id))) {
        await _database.marcarSelagemComoFalha(
          localId: localId,
          message: 'O servidor não confirmou o processamento da selagem.',
        );
      }

      return SealSyncResult(
        attempted: records.length,
        accepted: accepted.length,
        rejected: rejected.length,
        conflicts: conflicts.length,
        offline: false,
      );
    } on DioException catch (error) {
      final message = _dioMessage(error);

      for (final localId in localIds) {
        await _database.marcarSelagemComoFalha(
          localId: localId,
          message: message,
        );
      }

      return SealSyncResult(
        attempted: records.length,
        accepted: 0,
        rejected: records.length,
        conflicts: 0,
        offline: _isConnectionFailure(error),
        message: message,
      );
    } on ApiException catch (error) {
      for (final localId in localIds) {
        await _database.marcarSelagemComoFalha(
          localId: localId,
          message: error.message,
        );
      }

      return SealSyncResult(
        attempted: records.length,
        accepted: 0,
        rejected: records.length,
        conflicts: 0,
        offline: false,
        message: error.message,
      );
    } catch (error) {
      final message = 'Falha inesperada ao sincronizar: $error';

      for (final localId in localIds) {
        await _database.marcarSelagemComoFalha(
          localId: localId,
          message: message,
        );
      }

      return SealSyncResult(
        attempted: records.length,
        accepted: 0,
        rejected: records.length,
        conflicts: 0,
        offline: false,
        message: message,
      );
    }
  }

  Map<String, dynamic> _serializeSeal(Map<String, Object?> row) {
    final serverId = _text(row['server_id']);

    return {
      'source_local_id': row['id'].toString(),
      'source_device_id': row['source_device_id'].toString(),
      'seal_code': row['codigo_selo'].toString(),
      'lot_id': null,
      'lot_code': _text(row['codigo_lote_preliminar']),
      'situation': row['situacao']?.toString() ?? 'ocupado',
      'resident_present': _asBoolOrNull(row['morador_presente']),
      'dwelling_occupied': _asBoolOrNull(row['moradia_ocupada']),
      'service_status': _text(row['situacao_atendimento']),
      'unit_type': _text(row['tipo_unidade']),
      'property_use': _text(row['uso_imovel']),
      'informant_name': _text(row['nome_informante']),
      'informant_phone': _text(row['telefone_informante']),
      'informant_relationship': _text(row['relacao_informante']),
      'revisit_required': _asBool(row['revisita_necessaria']),
      'facade_photo_path': _text(row['foto_fachada_path']),
      'notes': _text(row['observacoes']),
      'geo_link_status':
          row['status_vinculo_geografico']?.toString() ?? 'nao_validado',
      'needs_rtk_validation': _asBool(row['necessita_validacao_rtk']),
      'geospatial_note': _text(row['observacao_geoespacial']),
      'latitude': _asDouble(row['latitude']),
      'longitude': _asDouble(row['longitude']),
      'gps_accuracy': _asDouble(row['precisao_gps']),
      'client_created_at': _dateTimeIso(row['created_at']),
      'client_updated_at': _dateTimeIso(row['local_updated_at']),
      'expected_sync_version':
          serverId == null ? null : _asInt(row['sync_version']),
      'deleted': _asBool(row['deleted_locally']),
    };
  }

  List<Map<String, dynamic>> _listOfMaps(dynamic value) {
    if (value is! List) return const <Map<String, dynamic>>[];

    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  String? _text(Object? value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  bool _asBool(Object? value) {
    if (value is bool) return value;
    if (value is num) return value != 0;

    final normalized = value?.toString().toLowerCase();
    return normalized == 'true' || normalized == '1';
  }

  bool? _asBoolOrNull(Object? value) {
    if (value == null) return null;
    return _asBool(value);
  }

  double? _asDouble(Object? value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString().replaceAll(',', '.'));
  }

  int _asInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 1;
  }

  String? _dateTimeIso(Object? value) {
    if (value == null) return null;

    if (value is DateTime) {
      return value.toUtc().toIso8601String();
    }

    if (value is int) {
      final milliseconds = value.abs() < 100000000000 ? value * 1000 : value;

      return DateTime.fromMillisecondsSinceEpoch(
        milliseconds,
        isUtc: true,
      ).toIso8601String();
    }

    return DateTime.tryParse(value.toString())?.toUtc().toIso8601String();
  }

  String _dioMessage(DioException error) {
    final data = error.response?.data;

    if (data is Map && data['detail'] != null) {
      return data['detail'].toString();
    }

    if (_isConnectionFailure(error)) {
      return 'Sem conexão com o servidor. O registro permanece salvo '
          'e será reenviado posteriormente.';
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

    return 'Não foi possível concluir a sincronização.';
  }

  bool _isConnectionFailure(DioException error) {
    return error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout;
  }
}

class SealSyncResult {
  const SealSyncResult({
    required this.attempted,
    required this.accepted,
    required this.rejected,
    required this.conflicts,
    required this.offline,
    this.message,
  });

  const SealSyncResult.empty()
      : attempted = 0,
        accepted = 0,
        rejected = 0,
        conflicts = 0,
        offline = false,
        message = null;

  final int attempted;
  final int accepted;
  final int rejected;
  final int conflicts;
  final bool offline;
  final String? message;

  bool get allAccepted =>
      attempted > 0 && accepted == attempted && rejected == 0 && conflicts == 0;
}
