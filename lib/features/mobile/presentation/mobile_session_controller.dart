import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_exception.dart';
import '../data/mobile_session_repository.dart';
import '../domain/mobile_session.dart';

final mobileSessionControllerProvider =
    StateNotifierProvider<MobileSessionController, MobileSessionState>((ref) {
  return MobileSessionController(
    ref.watch(mobileSessionRepositoryProvider),
  );
});

class MobileSessionController extends StateNotifier<MobileSessionState> {
  MobileSessionController(this._repository)
      : super(const MobileSessionState.initial());

  final MobileSessionRepository _repository;

  Future<void> load({bool force = false}) async {
    if (state.status == MobileSessionStatus.loading) return;

    if (!force &&
        state.status == MobileSessionStatus.ready &&
        state.session != null) {
      return;
    }

    state = MobileSessionState.loading(previous: state.session);

    try {
      final session = await _repository.loadSession();
      state = MobileSessionState.ready(session);
    } on ApiException catch (error) {
      state = MobileSessionState.failure(
        message: error.message,
        previous: state.session,
      );
    } catch (_) {
      state = MobileSessionState.failure(
        message: 'Não foi possível carregar a sessão de campo.',
        previous: state.session,
      );
    }
  }

  void clear() {
    state = const MobileSessionState.initial();
  }
}

enum MobileSessionStatus { initial, loading, ready, failure }

class MobileSessionState {
  const MobileSessionState({
    required this.status,
    this.session,
    this.message,
  });

  const MobileSessionState.initial()
      : this(status: MobileSessionStatus.initial);

  const MobileSessionState.loading({MobileSession? previous})
      : this(
          status: MobileSessionStatus.loading,
          session: previous,
        );

  const MobileSessionState.ready(MobileSession session)
      : this(
          status: MobileSessionStatus.ready,
          session: session,
        );

  const MobileSessionState.failure({
    required String message,
    MobileSession? previous,
  }) : this(
          status: MobileSessionStatus.failure,
          session: previous,
          message: message,
        );

  final MobileSessionStatus status;
  final MobileSession? session;
  final String? message;
}
