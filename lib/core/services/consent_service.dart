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
        final consentData = {
          'user_id': consent.userId,
          'necessary': consent.categoryConsents[CookieCategory.essential] ?? true,
          'preferences': consent.categoryConsents[CookieCategory.functional] ?? false,
          'analytics': consent.categoryConsents[CookieCategory.analytics] ?? false,
          'marketing': consent.categoryConsents[CookieCategory.marketing] ?? false,
          'consent_date': consent.timestamp.toIso8601String(),
          'last_updated': DateTime.now().toIso8601String(),
          'ip_address': consent.ipAddress,
          'user_agent': consent.userAgent,
        };

        // Check if consent already exists for this user
        final existing = await _supabase
            .from('cookie_consents')
            .select('id')
            .eq('user_id', consent.userId)
            .maybeSingle();

        if (existing != null) {
          // Update existing consent
          await _supabase
              .from('cookie_consents')
              .update(consentData)
              .eq('user_id', consent.userId);
        } else {
          // Insert new consent
          await _supabase.from('cookie_consents').insert(consentData);
        }

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
      final consents = await _supabase.from('cookie_consents').select('*') as List<dynamic>;

      int total = consents.length;
      int fullConsent = 0; // Users who consented to all categories
      int partialConsent = 0; // Users who consented to some categories
      int essentialOnly = 0; // Users who only have essential (necessary) cookies

      Map<String, int> categoryStats = {
        'necessary': 0,
        'preferences': 0,
        'analytics': 0,
        'marketing': 0,
      };

      for (final consent in consents) {
        // Count category consents
        final necessary = consent['necessary'] == true;
        final preferences = consent['preferences'] == true;
        final analytics = consent['analytics'] == true;
        final marketing = consent['marketing'] == true;

        if (necessary) categoryStats['necessary'] = (categoryStats['necessary'] ?? 0) + 1;
        if (preferences) categoryStats['preferences'] = (categoryStats['preferences'] ?? 0) + 1;
        if (analytics) categoryStats['analytics'] = (categoryStats['analytics'] ?? 0) + 1;
        if (marketing) categoryStats['marketing'] = (categoryStats['marketing'] ?? 0) + 1;

        // Categorize user consent level
        if (necessary && preferences && analytics && marketing) {
          fullConsent++;
        } else if (preferences || analytics || marketing) {
          partialConsent++;
        } else {
          essentialOnly++;
        }
      }

      return {
        'totalUsers': total,
        'fullConsent': fullConsent,
        'partialConsent': partialConsent,
        'essentialOnly': essentialOnly,
        'categoryStats': categoryStats,
      };
    } catch (e) {
      print('[ConsentService] Error fetching consent statistics from Supabase: $e');
      // Fallback to empty stats
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
  }
}
