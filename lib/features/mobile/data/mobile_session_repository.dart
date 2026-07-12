import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/auth/secure_session_storage.dart';
import '../domain/mobile_session.dart';

final mobileSessionRepositoryProvider = Provider<MobileSessionRepository>((ref) {
  return MobileSessionRepository(
    dio: ref.watch(dioProvider),
    storage: ref.watch(secureSessionStorageProvider),
  );
});

class MobileSessionRepository {
  MobileSessionRepository({
    required Dio dio,
    required SecureSessionStorage storage,
  })  : _dio = dio,
        _storage = storage;

  final Dio _dio;
  final SecureSessionStorage _storage;

  Future<MobileSession> loadSession() async {
    try {
      final response =
          await _dio.get<Map<String, dynamic>>('/mobile/session');

      final data = response.data;
      if (data == null) {
        throw const ApiException('A API retornou uma sessão mobile inválida.');
      }

      final session = MobileSession.fromJson(data);
      await _storage.saveMobileSession(session);
      return session;
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;

      if (statusCode == 401 || statusCode == 403) {
        throw ApiException(
          _detail(error.response?.data) ??
              'Sua sessão não possui autorização para o aplicativo.',
          statusCode: statusCode,
        );
      }

      final cached = await _storage.readCachedMobileSession();
      if (cached != null) {
        return cached.copyWith(isOffline: true);
      }

      if (statusCode != null && statusCode >= 500) {
        throw ApiException(
          'O servidor está temporariamente indisponível.',
          statusCode: statusCode,
        );
      }

      throw const ApiException(
        'Não foi possível carregar a sessão de campo. Verifique sua conexão.',
      );
    } on ApiException {
      rethrow;
    } catch (_) {
      final cached = await _storage.readCachedMobileSession();
      if (cached != null) {
        return cached.copyWith(isOffline: true);
      }

      throw const ApiException(
        'Não foi possível preparar o ambiente de campo.',
      );
    }
  }

  String? _detail(dynamic data) {
    if (data is Map && data['detail'] != null) {
      return data['detail'].toString();
    }
    return null;
  }
}
