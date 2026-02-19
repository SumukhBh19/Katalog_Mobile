import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// ONDC-compliant secure token storage service.
/// Never stores tokens in plain SharedPreferences.
class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const _tokenKey = 'auth_token';
  static const _userEmailKey = 'user_email';
  static const _userDataKey = 'user_data';
  static const _isLoggedInKey = 'is_logged_in';

  // ── Token ──────────────────────────────────────────────
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // ── Session ────────────────────────────────────────────
  static Future<void> saveSession({
    required String token,
    required String email,
    required Map<String, dynamic> userData,
  }) async {
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _userEmailKey, value: email);
    await _storage.write(key: _userDataKey, value: jsonEncode(userData));
    await _storage.write(key: _isLoggedInKey, value: 'true');
  }

  static Future<bool> isLoggedIn() async {
    final val = await _storage.read(key: _isLoggedInKey);
    return val == 'true';
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    final raw = await _storage.read(key: _userDataKey);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
