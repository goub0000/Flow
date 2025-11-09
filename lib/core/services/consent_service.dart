// lib/core/services/consent_service.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import '../models/user_consent.dart';
import '../constants/cookie_constants.dart';

class ConsentService {
  final SharedPreferences _prefs;
  final SupabaseClient _supabase;

  ConsentService(this._prefs) : _supabase = Supabase.instance.client;

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

  /// Save user consent (both locally and to Supabase)
  Future<bool> saveUserConsent(UserConsent consent) async {
    try {
      // Save to local storage for quick access
      final json = jsonEncode(consent.toJson());
      final localSaveSuccess = await _prefs.setString(
        '${CookieConstants.consentStatusKey}_${consent.userId}',
        json,
      );

      // Save to Supabase for admin tracking
      try {
        await _supabase.from('cookies').upsert({
          'user_id': consent.userId,
          'status': consent.status.toString().split('.').last,
          'essential': consent.categoryConsents[CookieCategory.essential] ?? true,
          'functional': consent.categoryConsents[CookieCategory.functional] ?? false,
          'analytics': consent.categoryConsents[CookieCategory.analytics] ?? false,
          'marketing': consent.categoryConsents[CookieCategory.marketing] ?? false,
          'version': consent.version,
          'updated_at': DateTime.now().toIso8601String(),
          'expires_at': consent.expiresAt?.toIso8601String(),
        }, onConflict: 'user_id');

        print('[ConsentService] Successfully saved consent to Supabase for user: ${consent.userId}');
      } catch (e) {
        print('[ConsentService] Failed to save consent to Supabase: $e');
        // Don't fail the entire operation if Supabase save fails
      }

      return localSaveSuccess;
    } catch (e) {
      print('[ConsentService] Error saving consent: $e');
      return false;
    }
  }

  /// Accept all cookies
  Future<bool> acceptAll(String userId) async {
    final consent = UserConsent.acceptAll(userId);
    return await saveUserConsent(consent);
  }

  /// Accept essential only
  Future<bool> acceptEssentialOnly(String userId) async {
    final consent = UserConsent.essentialOnly(userId);
    return await saveUserConsent(consent);
  }

  /// Update category consents
  Future<bool> updateConsent(
    String userId,
    Map<CookieCategory, bool> categories,
  ) async {
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
      return await saveUserConsent(consent);
    }

    final updated = current.updateCategories(categories);
    return await saveUserConsent(updated);
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

  /// Get consent statistics (for admin dashboard) - Queries Supabase for global data
  Future<Map<String, dynamic>> getConsentStatistics() async {
    try {
      // Query all cookie consents from Supabase
      final cookies = await _supabase.from('cookies').select('*') as List<dynamic>;

      int total = cookies.length;
      int accepted = 0;
      int customized = 0;
      int declined = 0;
      int expired = 0;

      Map<String, int> categoryStats = {
        'essential': 0,
        'functional': 0,
        'analytics': 0,
        'marketing': 0,
      };

      final now = DateTime.now();

      for (final cookie in cookies) {
        final status = cookie['status'] as String?;
        final expiresAt = cookie['expires_at'] != null
            ? DateTime.parse(cookie['expires_at'] as String)
            : null;

        // Check if expired
        if (expiresAt != null && expiresAt.isBefore(now)) {
          expired++;
        } else {
          // Count by status
          switch (status) {
            case 'accepted':
              accepted++;
              break;
            case 'customized':
              customized++;
              break;
            case 'declined':
              declined++;
              break;
          }
        }

        // Count category consents
        if (cookie['essential'] == true) categoryStats['essential'] = (categoryStats['essential'] ?? 0) + 1;
        if (cookie['functional'] == true) categoryStats['functional'] = (categoryStats['functional'] ?? 0) + 1;
        if (cookie['analytics'] == true) categoryStats['analytics'] = (categoryStats['analytics'] ?? 0) + 1;
        if (cookie['marketing'] == true) categoryStats['marketing'] = (categoryStats['marketing'] ?? 0) + 1;
      }

      return {
        'totalUsers': total,
        'totalConsented': accepted + customized,
        'acceptedAll': accepted,
        'customized': customized,
        'declined': declined,
        'expired': expired,
        'categoryStats': categoryStats,
      };
    } catch (e) {
      print('[ConsentService] Error fetching consent statistics from Supabase: $e');
      // Fallback to empty stats
      return {
        'totalUsers': 0,
        'totalConsented': 0,
        'acceptedAll': 0,
        'customized': 0,
        'declined': 0,
        'expired': 0,
        'categoryStats': {
          'essential': 0,
          'functional': 0,
          'analytics': 0,
          'marketing': 0,
        },
      };
    }
  }
}
