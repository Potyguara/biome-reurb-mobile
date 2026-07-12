import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/auth/secure_session_storage.dart';
import '../domain/authenticated_user.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    dio: ref.watch(dioProvider),
    storage: ref.watch(secureSessionStorageProvider),
  );
});

class AuthRepository {
  AuthRepository({required Dio dio, required SecureSessionStorage storage})
      : _dio = dio,
        _storage = storage;

  final Dio _dio;
  final SecureSessionStorage _storage;

  Future<AuthenticatedUser> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: {
          'email': email.trim().toLowerCase(),
          'password': password,
        },
        options: Options(headers: {'Authorization': null}),
      );

      final data = response.data;
      final token = data?['access_token']?.toString();
      if (token == null || token.isEmpty) {
        throw const ApiException('A API não retornou o token de acesso.');
      }

      // Salva primeiro o token para que o interceptor autentique /auth/me.
      await _storage.saveSession(
        accessToken: token,
        user: AuthenticatedUser(
          id: '',
          name: '',
          email: email.trim().toLowerCase(),
          isGlobalAdmin: false,
          active: true,
          roleLabel: '',
        ),
      );

      final user = await fetchCurrentUser();
      await _storage.saveSession(accessToken: token, user: user);
      return user;
    } on ApiException {
      rethrow;
    } on DioException catch (error) {
      await _storage.clearSession();
      throw _mapDioException(error);
    } catch (_) {
      await _storage.clearSession();
      throw const ApiException('Não foi possível concluir o acesso.');
    }
  }

  Future<AuthenticatedUser> fetchCurrentUser() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/auth/me');
      final data = response.data;
      if (data == null) {
        throw const ApiException('Resposta de usuário inválida.');
      }
      return AuthenticatedUser.fromJson(data);
    } on ApiException {
      rethrow;
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<RestoredSession?> restoreSession() async {
    final token = await _storage.readAccessToken();
    if (token == null || token.isEmpty) return null;

    try {
      final user = await fetchCurrentUser();
      await _storage.saveSession(accessToken: token, user: user);
      return RestoredSession(user: user, isOffline: false);
    } on ApiException catch (error) {
      if (error.statusCode == 401 || error.statusCode == 403) {
        await _storage.clearSession();
        return null;
      }

      final cachedUser = await _storage.readCachedUser();
      if (cachedUser != null && cachedUser.active) {
        return RestoredSession(user: cachedUser, isOffline: true);
      }
      rethrow;
    }
  }

  Future<String?> readLastEmail() => _storage.readLastEmail();

  Future<void> logout() => _storage.clearSession();

  ApiException _mapDioException(DioException error) {
    final statusCode = error.response?.statusCode;
    final detail = _extractDetail(error.response?.data);

    if (statusCode == 401) {
      return ApiException(
        detail ?? 'E-mail ou senha inválidos.',
        statusCode: statusCode,
      );
    }
    if (statusCode == 403) {
      return ApiException(
        detail ?? 'Usuário sem autorização para acessar o sistema.',
        statusCode: statusCode,
      );
    }
    if (statusCode != null && statusCode >= 500) {
      return ApiException(
        'O servidor está temporariamente indisponível.',
        statusCode: statusCode,
      );
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException(
          'Tempo de conexão esgotado. Verifique sua internet e tente novamente.',
        );
      case DioExceptionType.connectionError:
        return const ApiException(
          'Sem conexão com o servidor. Verifique sua internet.',
        );
      default:
        return ApiException(
          detail ?? 'Não foi possível comunicar com o servidor.',
          statusCode: statusCode,
        );
    }
  }

  String? _extractDetail(dynamic data) {
    if (data is Map && data['detail'] != null) {
      return data['detail'].toString();
    }
    return null;
  }
}

class RestoredSession {
  const RestoredSession({required this.user, required this.isOffline});

  final AuthenticatedUser user;
  final bool isOffline;
}
