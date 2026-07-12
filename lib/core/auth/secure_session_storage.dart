import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

import '../../features/auth/domain/authenticated_user.dart';
import '../../features/mobile/domain/mobile_session.dart';

final secureSessionStorageProvider = Provider<SecureSessionStorage>((ref) {
  return SecureSessionStorage();
});

class SecureSessionStorage {
  SecureSessionStorage({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            );

  static const String _tokenKey = 'biome_reurb_access_token';
  static const String _userKey = 'biome_reurb_authenticated_user';
  static const String _lastEmailKey = 'biome_reurb_last_email';
  static const String _mobileSessionKey = 'biome_reurb_mobile_session';
  static const String _activeProjectKey = 'biome_reurb_active_project_id';
  static const String _deviceIdKey = 'biome_reurb_device_id';

  final FlutterSecureStorage _storage;

  Future<void> saveSession({
    required String accessToken,
    required AuthenticatedUser user,
  }) async {
    await Future.wait([
      _storage.write(key: _tokenKey, value: accessToken),
      _storage.write(key: _userKey, value: jsonEncode(user.toJson())),
      _storage.write(key: _lastEmailKey, value: user.email),
    ]);
  }

  Future<String?> readAccessToken() => _storage.read(key: _tokenKey);

  Future<AuthenticatedUser?> readCachedUser() async {
    final raw = await _storage.read(key: _userKey);
    if (raw == null || raw.trim().isEmpty) return null;

    try {
      return AuthenticatedUser.fromJson(
        Map<String, dynamic>.from(jsonDecode(raw) as Map),
      );
    } catch (_) {
      return null;
    }
  }

  Future<String?> readLastEmail() => _storage.read(key: _lastEmailKey);


  Future<void> saveMobileSession(MobileSession session) {
    return _storage.write(
      key: _mobileSessionKey,
      value: jsonEncode(session.toJson()),
    );
  }

  Future<MobileSession?> readCachedMobileSession() async {
    final raw = await _storage.read(key: _mobileSessionKey);
    if (raw == null || raw.trim().isEmpty) return null;

    try {
      return MobileSession.fromJson(
        Map<String, dynamic>.from(jsonDecode(raw) as Map),
        isOffline: true,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> saveActiveProjectId(String projectId) {
    return _storage.write(
      key: _activeProjectKey,
      value: projectId,
    );
  }

  Future<String?> readActiveProjectId() {
    return _storage.read(key: _activeProjectKey);
  }

  Future<void> clearActiveProject() {
    return _storage.delete(key: _activeProjectKey);
  }


  Future<String> getOrCreateDeviceId() async {
    final existing = await _storage.read(key: _deviceIdKey);

    if (existing != null && existing.trim().isNotEmpty) {
      return existing;
    }

    final generated = const Uuid().v4();

    await _storage.write(
      key: _deviceIdKey,
      value: generated,
    );

    return generated;
  }

  Future<void> clearSession() async {
    await Future.wait([
      _storage.delete(key: _tokenKey),
      _storage.delete(key: _userKey),
      _storage.delete(key: _mobileSessionKey),
      _storage.delete(key: _activeProjectKey),
    ]);
  }
}
