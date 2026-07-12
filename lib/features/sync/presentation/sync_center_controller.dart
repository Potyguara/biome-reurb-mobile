import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/app_database.dart';
import '../../../data/local/database_provider.dart';
import '../../selagem/data/seal_sync_repository.dart';

final syncCenterControllerProvider =
    StateNotifierProvider<SyncCenterController, SyncCenterState>((ref) {
  return SyncCenterController(
    database: ref.watch(appDatabaseProvider),
    sealRepository: ref.watch(sealSyncRepositoryProvider),
  );
});

class SyncCenterController extends StateNotifier<SyncCenterState> {
  SyncCenterController({
    required AppDatabase database,
    required SealSyncRepository sealRepository,
  })  : _database = database,
        _sealRepository = sealRepository,
        super(const SyncCenterState.initial());

  final AppDatabase _database;
  final SealSyncRepository _sealRepository;

  Future<void> load() async {
    final summary = await _database.resumoSincronizacaoSelagens();
    final failures =
        await _database.listarFalhasSincronizacaoSelagens(limit: 30);

    state = state.copyWith(
      summary: summary,
      failures: failures,
      loading: false,
    );
  }

  Future<SealSyncResult> synchronizeNow({
    required String projectId,
    bool forceRetry = true,
  }) async {
    if (state.syncing) {
      return const SealSyncResult.empty();
    }

    state = state.copyWith(syncing: true, message: null);

    if (forceRetry) {
      await _database.liberarFilaParaTentativa(
        entityType: 'seal',
        projectId: projectId,
      );
    }

    final result = await _sealRepository.synchronize(
      projectId: projectId,
      limit: 500,
    );

    final summary = await _database.resumoSincronizacaoSelagens();
    final failures =
        await _database.listarFalhasSincronizacaoSelagens(limit: 30);

    state = state.copyWith(
      syncing: false,
      summary: summary,
      failures: failures,
      lastSyncAt: DateTime.now(),
      lastResult: result,
      message: result.message,
    );

    return result;
  }

  Future<void> refresh() => load();
}

class SyncCenterState {
  const SyncCenterState({
    required this.loading,
    required this.syncing,
    required this.summary,
    required this.failures,
    this.lastSyncAt,
    this.lastResult,
    this.message,
  });

  const SyncCenterState.initial()
      : loading = true,
        syncing = false,
        summary = const {
          'pending': 0,
          'syncing': 0,
          'synced': 0,
          'failed': 0,
          'conflict': 0,
        },
        failures = const [],
        lastSyncAt = null,
        lastResult = null,
        message = null;

  final bool loading;
  final bool syncing;
  final Map<String, int> summary;
  final List<Map<String, Object?>> failures;
  final DateTime? lastSyncAt;
  final SealSyncResult? lastResult;
  final String? message;

  int get pending =>
      (summary['pending'] ?? 0) +
      (summary['syncing'] ?? 0) +
      (summary['failed'] ?? 0);

  int get synced => summary['synced'] ?? 0;
  int get failed => summary['failed'] ?? 0;
  int get conflicts => summary['conflict'] ?? 0;

  SyncCenterState copyWith({
    bool? loading,
    bool? syncing,
    Map<String, int>? summary,
    List<Map<String, Object?>>? failures,
    DateTime? lastSyncAt,
    SealSyncResult? lastResult,
    String? message,
  }) {
    return SyncCenterState(
      loading: loading ?? this.loading,
      syncing: syncing ?? this.syncing,
      summary: summary ?? this.summary,
      failures: failures ?? this.failures,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      lastResult: lastResult ?? this.lastResult,
      message: message,
    );
  }
}
