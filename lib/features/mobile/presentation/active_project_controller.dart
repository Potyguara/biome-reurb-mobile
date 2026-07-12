import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/secure_session_storage.dart';
import '../domain/mobile_project.dart';
import 'mobile_session_controller.dart';

final activeProjectControllerProvider =
    StateNotifierProvider<ActiveProjectController, MobileProject?>((ref) {
  final controller = ActiveProjectController(
    storage: ref.watch(secureSessionStorageProvider),
  );

  ref.listen<MobileSessionState>(
    mobileSessionControllerProvider,
    (previous, next) {
      final projects = next.session?.projects ?? const <MobileProject>[];
      controller.reconcile(projects);
    },
    fireImmediately: true,
  );

  return controller;
});

class ActiveProjectController extends StateNotifier<MobileProject?> {
  ActiveProjectController({
    required SecureSessionStorage storage,
  })  : _storage = storage,
        super(null);

  final SecureSessionStorage _storage;
  bool _restored = false;

  Future<void> reconcile(List<MobileProject> projects) async {
    if (projects.isEmpty) {
      state = null;
      await _storage.clearActiveProject();
      return;
    }

    if (!_restored) {
      _restored = true;
      final storedId = await _storage.readActiveProjectId();

      if (storedId != null) {
        for (final project in projects) {
          if (project.id == storedId) {
            state = project;
            return;
          }
        }
      }
    }

    final current = state;
    if (current != null) {
      for (final project in projects) {
        if (project.id == current.id) {
          state = project;
          return;
        }
      }
    }

    if (projects.length == 1) {
      await select(projects.first);
      return;
    }

    state = null;
  }

  Future<void> select(MobileProject project) async {
    state = project;
    await _storage.saveActiveProjectId(project.id);
  }

  Future<void> clear() async {
    state = null;
    await _storage.clearActiveProject();
  }
}
