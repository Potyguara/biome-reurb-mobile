import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/seal_sync_repository.dart';

final sealSyncControllerProvider =
    StateNotifierProvider<SealSyncController, SealSyncState>((ref) {
  return SealSyncController(
    ref.watch(sealSyncRepositoryProvider),
  );
});

class SealSyncController extends StateNotifier<SealSyncState> {
  SealSyncController(this._repository) : super(const SealSyncState.idle());

  final SealSyncRepository _repository;

  Future<SealSyncResult> synchronize({
    required String projectId,
  }) async {
    if (state.isSyncing) {
      return const SealSyncResult.empty();
    }

    state = const SealSyncState.syncing();

    final result = await _repository.synchronize(
      projectId: projectId,
    );

    state = SealSyncState.completed(result);
    return result;
  }

  void reset() {
    state = const SealSyncState.idle();
  }
}

class SealSyncState {
  const SealSyncState({
    required this.isSyncing,
    this.lastResult,
  });

  const SealSyncState.idle() : this(isSyncing: false);

  const SealSyncState.syncing() : this(isSyncing: true);

  const SealSyncState.completed(SealSyncResult result)
      : this(
          isSyncing: false,
          lastResult: result,
        );

  final bool isSyncing;
  final SealSyncResult? lastResult;
}
