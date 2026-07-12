import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_exception.dart';
import '../data/auth_repository.dart';
import '../domain/authenticated_user.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref.watch(authRepositoryProvider));
});

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._repository) : super(const AuthState.initial());

  final AuthRepository _repository;

  Future<void> restoreSession() async {
    if (state.status == AuthStatus.loading) return;
    state = const AuthState.loading();

    try {
      final restored = await _repository.restoreSession();
      if (restored == null) {
        state = const AuthState.unauthenticated();
        return;
      }

      state = AuthState.authenticated(
        user: restored.user,
        isOffline: restored.isOffline,
      );
    } on ApiException catch (error) {
      state = AuthState.unauthenticated(message: error.message);
    } catch (_) {
      state = const AuthState.unauthenticated(
        message: 'Não foi possível restaurar a sessão.',
      );
    }
  }

  Future<bool> login({required String email, required String password}) async {
    if (state.status == AuthStatus.loading) return false;
    state = const AuthState.loading();

    try {
      final user = await _repository.login(email: email, password: password);
      state = AuthState.authenticated(user: user, isOffline: false);
      return true;
    } on ApiException catch (error) {
      state = AuthState.unauthenticated(message: error.message);
      return false;
    } catch (_) {
      state = const AuthState.unauthenticated(
        message: 'Não foi possível concluir o login.',
      );
      return false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState.unauthenticated();
  }

  void clearMessage() {
    if (state.message == null) return;
    state = state.copyWith(clearMessage: true);
  }
}

enum AuthStatus { initial, loading, authenticated, unauthenticated }

class AuthState {
  const AuthState({
    required this.status,
    this.user,
    this.isOffline = false,
    this.message,
  });

  const AuthState.initial() : this(status: AuthStatus.initial);
  const AuthState.loading() : this(status: AuthStatus.loading);
  const AuthState.unauthenticated({String? message})
      : this(status: AuthStatus.unauthenticated, message: message);
  const AuthState.authenticated({
    required AuthenticatedUser user,
    required bool isOffline,
  }) : this(
          status: AuthStatus.authenticated,
          user: user,
          isOffline: isOffline,
        );

  final AuthStatus status;
  final AuthenticatedUser? user;
  final bool isOffline;
  final String? message;

  AuthState copyWith({
    AuthStatus? status,
    AuthenticatedUser? user,
    bool? isOffline,
    String? message,
    bool clearMessage = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      isOffline: isOffline ?? this.isOffline,
      message: clearMessage ? null : (message ?? this.message),
    );
  }
}
