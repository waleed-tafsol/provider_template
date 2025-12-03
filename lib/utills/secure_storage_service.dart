import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  static const String _authTokenKey = 'auth_token';

  String? _cachedToken; // <--- in-memory cache

  /// Load token once at app startup
  Future<void> init() async {
    _cachedToken = await _storage.read(key: _authTokenKey);
  }

  /// Get token from cache (fast, no decryption)
  String? get cachedAuthToken => _cachedToken;

  /// Save token to storage + update cache
  Future<void> saveAuthToken(String token) async {
    await _storage.write(key: _authTokenKey, value: token);
    _cachedToken = token;
  }

  /// Remove token from storage + cache
  Future<void> deleteAuthToken() async {
    await _storage.delete(key: _authTokenKey);
    _cachedToken = null;
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
    _cachedToken = null;
  }
}
