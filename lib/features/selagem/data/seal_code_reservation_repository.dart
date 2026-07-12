import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/auth/secure_session_storage.dart';
import '../../../data/local/database_provider.dart';

final sealCodeReservationRepositoryProvider =
    Provider<SealCodeReservationRepository>((ref) {
  return SealCodeReservationRepository(
    dio: ref.watch(dioProvider),
    storage: ref.watch(secureSessionStorageProvider),
    database: ref.watch(appDatabaseProvider),
  );
});

class SealCodeReservationRepository {
  SealCodeReservationRepository({
    required Dio dio,
    required SecureSessionStorage storage,
    required dynamic database,
  })  : _dio = dio,
        _storage = storage,
        _database = database;

  final Dio _dio;
  final SecureSessionStorage _storage;
  final dynamic _database;

  Future<String> nextCode({
    required String projectId,
    int reservationQuantity = 50,
  }) async {
    final deviceId = await _storage.getOrCreateDeviceId();

    final cached = await _database.consumirProximoCodigoReservado(
      projectId: projectId,
      deviceId: deviceId,
    );

    if (cached != null) return cached;

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/mobile/projects/$projectId/seal-reservations',
        data: {
          'device_id': deviceId,
          'quantity': reservationQuantity,
        },
      );

      final data = response.data;
      if (data == null) {
        throw const ApiException(
          'O servidor retornou uma reserva de códigos inválida.',
        );
      }

      await _database.salvarReservaCodigosSelagem(
        id: data['reservation_id'].toString(),
        projectId: data['project_id'].toString(),
        deviceId: data['device_id'].toString(),
        prefix: data['prefix'].toString(),
        startNumber: data['start_number'] as int,
        endNumber: data['end_number'] as int,
        nextNumber: data['next_number'] as int,
        quantity: data['quantity'] as int,
      );

      final code = await _database.consumirProximoCodigoReservado(
        projectId: projectId,
        deviceId: deviceId,
      );

      if (code == null) {
        throw const ApiException(
          'Não foi possível consumir o código reservado.',
        );
      }

      return code;
    } on DioException catch (error) {
      final detail = error.response?.data is Map
          ? (error.response?.data as Map)['detail']?.toString()
          : null;

      throw ApiException(
        detail ??
            'Não há códigos reservados neste aparelho e não foi possível '
                'solicitar uma nova reserva. Conecte-se à internet e tente novamente.',
        statusCode: error.response?.statusCode,
      );
    }
  }
}
