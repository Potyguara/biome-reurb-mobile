import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/secure_session_storage.dart';

final deviceIdentityProvider = FutureProvider<String>((ref) async {
  final storage = ref.watch(secureSessionStorageProvider);
  return storage.getOrCreateDeviceId();
});
