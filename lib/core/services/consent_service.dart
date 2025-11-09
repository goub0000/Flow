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

  /// Get consent statistics (for admin dashboard)
  Future<Map<String, dynamic>> getConsentStatistics() async {
    final keys = _prefs.getKeys();
    final consentKeys = keys.where(
      (k) => k.startsWith(CookieConstants.consentStatusKey),
    );

    int total = consentKeys.length;
    int accepted = 0;
    int customized = 0;
    int declined = 0;
    int expired = 0;

    Map<CookieCategory, int> categoryStats = {
      CookieCategory.essential: 0,
      CookieCategory.functional: 0,
      CookieCategory.analytics: 0,
      CookieCategory.marketing: 0,
    };

    for (final key in consentKeys) {
      final json = _prefs.getString(key);
      if (json == null) continue;

      try {
        final consent = UserConsent.fromJson(jsonDecode(json));

        if (consent.isExpired) {
          expired++;
        } else {
          switch (consent.status) {
            case ConsentStatus.accepted:
              accepted++;
              break;
            case ConsentStatus.customized:
              customized++;
              break;
            case ConsentStatus.declined:
              declined++;
              break;
            case ConsentStatus.notAsked:
              break;
          }
        }

        // Count category consents
        consent.categoryConsents.forEach((category, consented) {
          if (consented) {
            categoryStats[category] = (categoryStats[category] ?? 0) + 1;
          }
        });
      } catch (e) {
        print('Error parsing consent for stats: $e');
      }
    }

    return {
      'total': total,
      'accepted': accepted,
      'customized': customized,
      'declined': declined,
      'expired': expired,
      'categoryStats': categoryStats,
    };
  }
}
