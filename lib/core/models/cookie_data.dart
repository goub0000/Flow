// lib/core/models/cookie_data.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../constants/cookie_constants.dart';

part 'cookie_data.freezed.dart';
part 'cookie_data.g.dart';

@freezed
class CookieData with _$CookieData {
  const factory CookieData({
    required String id,
    required String userId,
    required CookieDataType type,
    required DateTime timestamp,
    required Map<String, dynamic> data,
    @Default(false) bool isAnonymized,
    DateTime? expiresAt,
    String? sessionId,
  }) = _CookieData;

  factory CookieData.fromJson(Map<String, dynamic> json) =>
      _$CookieDataFromJson(json);

  const CookieData._();
}

extension CookieDataX on CookieData {
  /// Check if data has expired
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// Get category for this data type
  CookieCategory get category => type.category;

  /// Anonymize sensitive data
  CookieData anonymize() {
    if (isAnonymized) return this;

    final anonymizedData = Map<String, dynamic>.from(data);

    // Remove or hash sensitive fields
    anonymizedData.remove('email');
    anonymizedData.remove('name');
    anonymizedData.remove('ipAddress');
    anonymizedData.remove('exactLocation');

    // Hash user ID if present
    if (anonymizedData.containsKey('userId')) {
      anonymizedData['userId'] = _hashString(anonymizedData['userId']);
    }

    return copyWith(
      data: anonymizedData,
      isAnonymized: true,
    );
  }

  String _hashString(String input) {
    // Simple hash for demo - use crypto package in production
    return input.hashCode.toRadixString(16);
  }
}

@freezed
class SessionAnalytics with _$SessionAnalytics {
  const factory SessionAnalytics({
    required String sessionId,
    required String userId,
    required DateTime startTime,
    DateTime? endTime,
    @Default([]) List<String> pagesVisited,
    @Default({}) Map<String, int> interactions,
    String? deviceType,
    String? browser,
    String? referrer,
    @Default(0) int totalDuration, // in seconds
  }) = _SessionAnalytics;

  factory SessionAnalytics.fromJson(Map<String, dynamic> json) =>
      _$SessionAnalyticsFromJson(json);

  const SessionAnalytics._();
}

extension SessionAnalyticsX on SessionAnalytics {
  /// Calculate session duration
  int get durationSeconds {
    if (endTime == null) {
      return DateTime.now().difference(startTime).inSeconds;
    }
    return endTime!.difference(startTime).inSeconds;
  }

  /// Check if session is active
  bool get isActive {
    if (endTime != null) return false;

    final lastActivity = DateTime.now().difference(startTime);
    return lastActivity.inMinutes <= CookieConstants.sessionTimeout;
  }

  /// Add page visit
  SessionAnalytics addPageVisit(String page) {
    return copyWith(
      pagesVisited: [...pagesVisited, page],
    );
  }

  /// Record interaction
  SessionAnalytics recordInteraction(String interactionType) {
    final newInteractions = Map<String, int>.from(interactions);
    newInteractions[interactionType] =
        (newInteractions[interactionType] ?? 0) + 1;

    return copyWith(interactions: newInteractions);
  }

  /// End session
  SessionAnalytics endSession() {
    return copyWith(
      endTime: DateTime.now(),
      totalDuration: durationSeconds,
    );
  }
}
