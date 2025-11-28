// lib/core/services/consent_service.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_consent.dart';
import '../constants/cookie_constants.dart';
import '../api/api_config.dart';

class ConsentService {
  final SharedPreferences _prefs;
  final http.Client _httpClient;

  ConsentService(this._prefs) : _httpClient = http.Client();

  /// Get current user consent
  Future<UserConsent?> getUserConsent(String userId) async {
    final json = _prefs.getString('${CookieConstants.consentStatusKey}_$userId');
    if (json == null) return null;

    try {
      return UserConsent.fromJson(jsonDecode(json));
    } catch (e) {
      print('Error parsing consent: $e');
      return null;
    }
  }

  /// Save user consent (both locally and to backend API)
  Future<bool> saveUserConsent(UserConsent consent, {String? accessToken}) async {
    try {
      // Save to local storage for quick access
      final json = jsonEncode(consent.toJson());
      final localSaveSuccess = await _prefs.setString(
        '${CookieConstants.consentStatusKey}_${consent.userId}',
        json,
      );

      // Save to backend API for server-side tracking
      if (accessToken != null && accessToken.isNotEmpty) {
        try {
          final consentData = {
            'necessary': consent.categoryConsents[CookieCategory.essential] ?? true,
            'preferences': consent.categoryConsents[CookieCategory.functional] ?? false,
            'analytics': consent.categoryConsents[CookieCategory.analytics] ?? false,
            'marketing': consent.categoryConsents[CookieCategory.marketing] ?? false,
            'ip_address': consent.ipAddress,
            'user_agent': consent.userAgent,
          };

          final response = await _httpClient.post(
            Uri.parse('${ApiConfig.apiBaseUrl}${ApiConfig.consent}'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $accessToken',
            },
            body: jsonEncode(consentData),
          );

          if (response.statusCode == 201 || response.statusCode == 200) {
            print('[ConsentService] Successfully saved consent to backend');
          } else {
            print('[ConsentService] Backend save failed: ${response.statusCode} - ${response.body}');
          }
        } catch (e) {
          print('[ConsentService] Failed to save consent to backend: $e');
          // Don't fail the entire operation if backend save fails
        }
      } else {
        print('[ConsentService] Skipping backend save - no access token');
      }

      return localSaveSuccess;
    } catch (e) {
      print('[ConsentService] Error saving consent: $e');
      return false;
    }
  }

  /// Accept all cookies
  Future<bool> acceptAll(String userId, {String? accessToken}) async {
    final consent = UserConsent.acceptAll(userId);
    return await saveUserConsent(consent, accessToken: accessToken);
  }

  /// Accept essential only
  Future<bool> acceptEssentialOnly(String userId, {String? accessToken}) async {
    final consent = UserConsent.essentialOnly(userId);
    return await saveUserConsent(consent, accessToken: accessToken);
  }

  /// Update category consents
  Future<bool> updateConsent(
    String userId,
    Map<CookieCategory, bool> categories, {
    String? accessToken,
  }) async {
    final current = await getUserConsent(userId);
    if (current == null) {
      // Create new consent with custom categories
      final consent = UserConsent(
        userId: userId,
        status: ConsentStatus.customized,
        timestamp: DateTime.now(),
        version: CookieConstants.currentConsentVersion,
        categoryConsents: {
          CookieCategory.essential: true,
          ...categories,
        },
        expiresAt: DateTime.now().add(
          Duration(days: CookieConstants.consentValidityDays),
        ),
      );
      return await saveUserConsent(consent, accessToken: accessToken);
    }

    final updated = current.updateCategories(categories);
    return await saveUserConsent(updated, accessToken: accessToken);
  }

  /// Check if consent is needed
  Future<bool> needsConsent(String userId) async {
    final consent = await getUserConsent(userId);

    if (consent == null) return true;
    if (consent.status == ConsentStatus.notAsked) return true;
    if (consent.isExpired) return true;
    if (consent.version != CookieConstants.currentConsentVersion) return true;

    return false;
  }

  /// Check if specific category is consented
  Future<bool> isCategoryConsented(
    String userId,
    CookieCategory category,
  ) async {
    final consent = await getUserConsent(userId);
    if (consent == null) return false;

    return consent.isCategoryConsented(category);
  }

  /// Check if specific data type can be collected
  Future<bool> canCollectData(
    String userId,
    CookieDataType dataType,
  ) async {
    final consent = await getUserConsent(userId);
    if (consent == null) return false;

    return consent.canCollectDataType(dataType);
  }

  /// Revoke all consents (for user deletion)
  Future<bool> revokeConsent(String userId) async {
    try {
      return await _prefs.remove(
        '${CookieConstants.consentStatusKey}_$userId',
      );
    } catch (e) {
      print('Error revoking consent: $e');
      return false;
    }
  }

  /// Get consent statistics (for admin dashboard)
  /// Note: Admin statistics should be fetched from a backend admin endpoint
  /// This method returns empty stats as a placeholder
  Future<Map<String, dynamic>> getConsentStatistics() async {
    // Admin statistics should be implemented via a backend admin endpoint
    // This is a placeholder that returns empty stats
    print('[ConsentService] getConsentStatistics: Use backend admin endpoint for statistics');
    return {
      'totalUsers': 0,
      'fullConsent': 0,
      'partialConsent': 0,
      'essentialOnly': 0,
      'categoryStats': {
        'necessary': 0,
        'preferences': 0,
        'analytics': 0,
        'marketing': 0,
      },
    };
  }

  /// Dispose resources
  void dispose() {
    _httpClient.close();
  }
}
