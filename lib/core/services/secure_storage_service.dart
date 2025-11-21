import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

/// Secure storage service for sensitive data like tokens
/// Uses platform-specific secure storage (Keychain/Keystore/IndexedDB)
class SecureStorageService {
  static final _logger = Logger('SecureStorageService');

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
    webOptions: WebOptions(
      dbName: 'FlowSecureStorage',
      publicKey: 'FlowEdTech',
    ),
  );

  // Token keys
  static const String _accessTokenKey = 'secure_access_token';
  static const String _refreshTokenKey = 'secure_refresh_token';

  /// Save access token securely
  Future<void> saveAccessToken(String token) async {
    try {
      await _storage.write(key: _accessTokenKey, value: token);
      _logger.info('Access token saved securely');
    } catch (e) {
      _logger.severe('Failed to save access token', e);
      rethrow;
    }
  }

  /// Get access token
  Future<String?> getAccessToken() async {
    try {
      return await _storage.read(key: _accessTokenKey);
    } catch (e) {
      _logger.severe('Failed to read access token', e);
      return null;
    }
  }

  /// Save refresh token securely
  Future<void> saveRefreshToken(String token) async {
    try {
      await _storage.write(key: _refreshTokenKey, value: token);
      _logger.info('Refresh token saved securely');
    } catch (e) {
      _logger.severe('Failed to save refresh token', e);
      rethrow;
    }
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: _refreshTokenKey);
    } catch (e) {
      _logger.severe('Failed to read refresh token', e);
      return null;
    }
  }

  /// Clear all secure tokens
  Future<void> clearTokens() async {
    try {
      await _storage.delete(key: _accessTokenKey);
      await _storage.delete(key: _refreshTokenKey);
      _logger.info('Tokens cleared from secure storage');
    } catch (e) {
      _logger.severe('Failed to clear tokens', e);
    }
  }

  /// Clear all secure storage
  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
      _logger.info('All secure storage cleared');
    } catch (e) {
      _logger.severe('Failed to clear secure storage', e);
    }
  }

  /// Check if access token exists
  Future<bool> hasAccessToken() async {
    try {
      final token = await getAccessToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// For web platform - additional security notes
  /// FlutterSecureStorage uses IndexedDB on web, which provides isolation
  /// but is still accessible via JavaScript (XSS vulnerability)
  /// Consider implementing HTTP-only cookies for production web deployment
  static bool get isWebPlatform => kIsWeb;

  static String get platformSecurityInfo {
    if (kIsWeb) {
      return 'IndexedDB (Better than localStorage, but still XSS-vulnerable)';
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return 'iOS Keychain (Highly secure)';
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return 'Android Keystore (Encrypted SharedPreferences)';
    } else {
      return 'Platform-specific secure storage';
    }
  }
}
