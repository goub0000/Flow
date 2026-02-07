// lib/core/services/cookie_service.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/cookie_data.dart';
import '../constants/cookie_constants.dart';
import 'consent_service.dart';

class CookieService {
  final SharedPreferences _prefs;
  final ConsentService _consentService;

  CookieService(this._prefs, this._consentService);

  /// Store cookie data if consent allows
  Future<bool> storeCookieData(CookieData data) async {
    // Check consent
    final canCollect = await _consentService.canCollectData(
      data.userId,
      data.type,
    );

    if (!canCollect && data.type.category != CookieCategory.essential) {
      return false;
    }

    try {
      // Get existing data
      final existing = await _getAllCookieData(data.userId);

      // Add new data
      existing.add(data);

      // Prune old data
      final pruned = _pruneOldData(existing);

      // Save
      final json = jsonEncode(pruned.map((e) => e.toJson()).toList());
      return await _prefs.setString(
        '${CookieConstants.localCookieDataKey}_${data.userId}',
        json,
      );
    } catch (e) {
      return false;
    }
  }

  /// Get all cookie data for a user
  Future<List<CookieData>> getCookieData(
    String userId, {
    CookieCategory? category,
    CookieDataType? type,
    DateTime? since,
  }) async {
    final all = await _getAllCookieData(userId);

    return all.where((data) {
      if (category != null && data.category != category) return false;
      if (type != null && data.type != type) return false;
      if (since != null && data.timestamp.isBefore(since)) return false;
      return true;
    }).toList();
  }

  Future<List<CookieData>> _getAllCookieData(String userId) async {
    final json = _prefs.getString(
      '${CookieConstants.localCookieDataKey}_$userId',
    );

    if (json == null) return [];

    try {
      final List<dynamic> list = jsonDecode(json);
      return list.map((e) => CookieData.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Delete all cookie data for a user
  Future<bool> deleteUserCookieData(String userId) async {
    try {
      return await _prefs.remove(
        '${CookieConstants.localCookieDataKey}_$userId',
      );
    } catch (e) {
      return false;
    }
  }

  /// Delete cookie data by category
  Future<bool> deleteCategoryData(
    String userId,
    CookieCategory category,
  ) async {
    try {
      final all = await _getAllCookieData(userId);
      final filtered = all.where((data) => data.category != category).toList();

      final json = jsonEncode(filtered.map((e) => e.toJson()).toList());
      return await _prefs.setString(
        '${CookieConstants.localCookieDataKey}_$userId',
        json,
      );
    } catch (e) {
      return false;
    }
  }

  /// Anonymize all cookie data for a user
  Future<bool> anonymizeUserData(String userId) async {
    try {
      final all = await _getAllCookieData(userId);
      final anonymized = all.map((data) => data.anonymize()).toList();

      final json = jsonEncode(anonymized.map((e) => e.toJson()).toList());
      return await _prefs.setString(
        '${CookieConstants.localCookieDataKey}_$userId',
        json,
      );
    } catch (e) {
      return false;
    }
  }

  /// Prune data older than max age
  List<CookieData> _pruneOldData(List<CookieData> data) {
    final cutoff = DateTime.now().subtract(
      Duration(days: CookieConstants.maxCookieDataAge),
    );

    return data.where((d) => d.timestamp.isAfter(cutoff)).toList();
  }

  /// Export user data (GDPR requirement)
  Future<Map<String, dynamic>> exportUserData(String userId) async {
    final consent = await _consentService.getUserConsent(userId);
    final cookieData = await getCookieData(userId);

    return {
      'userId': userId,
      'exportDate': DateTime.now().toIso8601String(),
      'consent': consent?.toJson(),
      'cookieData': cookieData.map((e) => e.toJson()).toList(),
      'dataCount': cookieData.length,
    };
  }

  /// Get storage size for user
  Future<int> getUserDataSize(String userId) async {
    final data = await _getAllCookieData(userId);
    final json = jsonEncode(data.map((e) => e.toJson()).toList());
    return json.length; // Size in bytes
  }
}
