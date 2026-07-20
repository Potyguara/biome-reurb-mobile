import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/app_database.dart';
import '../../../data/local/database_provider.dart';
import '../../documentos/data/document_sync_database.dart';
import '../../documentos/data/document_sync_repository.dart';
import '../../mapa/data/lot_geometry_sync_database.dart';
import '../../mapa/data/lot_geometry_sync_repository.dart';
import '../../selagem/data/seal_sync_repository.dart';
import '../data/field_record_sync_database.dart';
import '../data/field_record_sync_repository.dart';

final syncCenterControllerProvider =
    StateNotifierProvider<SyncCenterController, SyncCenterState>((ref) {
  return SyncCenterController(
    database: ref.watch(appDatabaseProvider),
    sealRepository: ref.watch(sealSyncRepositoryProvider),
    fieldRepository: ref.watch(fieldRecordSyncRepositoryProvider),
    geometryRepository: ref.watch(lotGeometrySyncRepositoryProvider),
    documentRepository: ref.watch(documentSyncRepositoryProvider),
  );
});

class SyncCenterController extends StateNotifier<SyncCenterState> {
  SyncCenterController({
    required AppDatabase database,
    required SealSyncRepository sealRepository,
    required FieldRecordSyncRepository fieldRepository,
    required LotGeometrySyncRepository geometryRepository,
    required DocumentSyncRepository documentRepository,
  })  : _database = database,
        _sealRepository = sealRepository,
        _fieldRepository = fieldRepository,
        _geometryRepository = geometryRepository,
        _documentRepository = documentRepository,
        super(const SyncCenterState.initial());

  final AppDatabase _database;
  final SealSyncRepository _sealRepository;
  final FieldRecordSyncRepository _fieldRepository;
  final LotGeometrySyncRepository _geometryRepository;
  final DocumentSyncRepository _documentRepository;

  Future<void> load() async {
    await _database.ensureLotGeometrySyncInfrastructure();

    final sealSummary = await _database.resumoSincronizacaoSelagens();
    final fieldSummary = await _database.resumoSincronizacaoCadastros();
    final geometrySummary = await _database.resumoSincronizacaoGeometrias();
    final documentSummary = await _database.resumoSincronizacaoDocumentos();

    final sealFailures = await _database.listarFalhasSincronizacaoSelagens(
      limit: 20,
    );

    final fieldFailures = await _database.listarFalhasCadastros(
      limit: 20,
    );

    final geometryFailures = await _database.listarFalhasGeometrias(
      limit: 20,
    );

    final documentFailures = await _database.listarFalhasDocumentos(
      limit: 20,
    );

    state = state.copyWith(
      summary: _mergeSummary(
        sealSummary,
        fieldSummary,
        geometrySummary,
        documentSummary,
      ),
      failures: [
        ...sealFailures.map(
          (item) => {
            ...item,
            'entity_type': 'seal',
          },
        ),
        ...fieldFailures,
        ...geometryFailures.map(
          (item) => {
            ...item,
            'entity_type': 'lot_geometry',
          },
        ),
        ...documentFailures.map(
          (item) => {
            ...item,
            'entity_type': 'document',
          },
        ),
      ],
      loading: false,
    );
  }

  Future<SyncBatchResult> synchronizeNow({
    required String projectId,
    bool forceRetry = true,
  }) async {
    if (state.syncing) {
      return const SyncBatchResult.empty();
    }

    state = state.copyWith(
      syncing: true,
      message: null,
    );

    if (forceRetry) {
      await _database.liberarFilaParaTentativa(
        entityType: 'seal',
        projectId: projectId,
      );

      await _database.liberarCadastrosParaNovaTentativa(
        projectId,
      );

      await _database.liberarGeometriasParaNovaTentativa(
        projectId,
      );

      await _database.liberarDocumentosParaNovaTentativa(
        projectId,
      );
    }

    final sealResult = await _sealRepository.synchronize(
      projectId: projectId,
      limit: 500,
    );

    final fieldResult = await _fieldRepository.synchronize(
      projectId: projectId,
      limit: 500,
    );

    final geometryResult = await _geometryRepository.synchronize(
      projectId: projectId,
      limit: 500,
      pullAfterPush: true,
    );

    final documentResult = await _documentRepository.synchronize(
      projectId: projectId,
      limit: 500,
      pullAfterPush: true,
    );

    final result = SyncBatchResult(
      attempted: sealResult.attempted +
          fieldResult.attempted +
          geometryResult.attempted +
          documentResult.attempted,
      accepted: sealResult.accepted +
          fieldResult.accepted +
          geometryResult.accepted +
          documentResult.accepted,
      rejected: sealResult.rejected +
          fieldResult.rejected +
          geometryResult.rejected +
          documentResult.rejected,
      conflicts: sealResult.conflicts +
          geometryResult.conflicts +
          documentResult.conflicts,
      pulled: geometryResult.pulled + documentResult.pulled,
      offline: sealResult.offline ||
          fieldResult.offline ||
          geometryResult.offline ||
          documentResult.offline,
      message: documentResult.message ??
          geometryResult.message ??
          fieldResult.message ??
          sealResult.message,
    );

    await load();

    state = state.copyWith(
      syncing: false,
      lastSyncAt: DateTime.now(),
      lastResult: result,
      message: result.message,
    );

    return result;
  }

  Future<void> refresh() => load();

  Map<String, int> _mergeSummary(
    Map<String, int> seals,
    Map<String, int> fields,
    Map<String, int> geometries,
    Map<String, int> documents,
  ) {
    return {
      'pending': (seals['pending'] ?? 0) +
          (fields['pending'] ?? 0) +
          (geometries['pending'] ?? 0) +
          (documents['pending'] ?? 0),
      'syncing': (seals['syncing'] ?? 0) +
          (fields['syncing'] ?? 0) +
          (geometries['syncing'] ?? 0) +
          (documents['syncing'] ?? 0),
      'synced': (seals['synced'] ?? 0) +
          (fields['synced'] ?? 0) +
          (geometries['synced'] ?? 0) +
          (documents['synced'] ?? 0),
      'failed': (seals['failed'] ?? 0) +
          (fields['failed'] ?? 0) +
          (geometries['failed'] ?? 0) +
          (documents['failed'] ?? 0),
      'conflict': (seals['conflict'] ?? 0) +
          (fields['conflict'] ?? 0) +
          (geometries['conflict'] ?? 0) +
          (documents['conflict'] ?? 0),
    };
  }
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
  final SyncBatchResult? lastResult;
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
    SyncBatchResult? lastResult,
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

class SyncBatchResult {
  const SyncBatchResult({
    required this.attempted,
    required this.accepted,
    required this.rejected,
    required this.conflicts,
    required this.pulled,
    required this.offline,
    this.message,
  });

  const SyncBatchResult.empty()
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
