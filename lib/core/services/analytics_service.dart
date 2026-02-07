// lib/core/services/analytics_service.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import '../models/cookie_data.dart';
import '../constants/cookie_constants.dart';
import 'cookie_service.dart';
import 'consent_service.dart';

class AnalyticsService {
  final SharedPreferences _prefs;
  final CookieService _cookieService;
  final ConsentService _consentService;
  final _uuid = const Uuid();

  String? _currentSessionId;
  SessionAnalytics? _currentSession;

  AnalyticsService(this._prefs, this._cookieService, this._consentService);

  /// Start tracking session
  Future<void> startSession(
    String userId, {
    String? deviceType,
    String? browser,
    String? referrer,
  }) async {
    final canTrack = await _consentService.canCollectData(
      userId,
      CookieDataType.pageView,
    );

    if (!canTrack) {
      return;
    }

    _currentSessionId = _uuid.v4();
    _currentSession = SessionAnalytics(
      sessionId: _currentSessionId!,
      userId: userId,
      startTime: DateTime.now(),
      deviceType: deviceType,
      browser: browser,
      referrer: referrer,
    );

    await _saveSession();
  }

  /// Track page view
  Future<void> trackPageView(String userId, String pageName) async {
    final canTrack = await _consentService.canCollectData(
      userId,
      CookieDataType.pageView,
    );

    if (!canTrack) return;

    // Store as cookie data
    final data = CookieData(
      id: _uuid.v4(),
      userId: userId,
      type: CookieDataType.pageView,
      timestamp: DateTime.now(),
      sessionId: _currentSessionId,
      data: {
        'page': pageName,
        'sessionId': _currentSessionId,
      },
    );

    await _cookieService.storeCookieData(data);

    // Update session
    if (_currentSession != null) {
      _currentSession = _currentSession!.addPageVisit(pageName);
      await _saveSession();
    }
  }

  /// Track click event
  Future<void> trackClick(
    String userId,
    String elementType,
    String elementId,
  ) async {
    final canTrack = await _consentService.canCollectData(
      userId,
      CookieDataType.clickEvent,
    );

    if (!canTrack) return;

    final data = CookieData(
      id: _uuid.v4(),
      userId: userId,
      type: CookieDataType.clickEvent,
      timestamp: DateTime.now(),
      sessionId: _currentSessionId,
      data: {
        'elementType': elementType,
        'elementId': elementId,
        'page': 'current_page', // Should be passed from context
      },
    );

    await _cookieService.storeCookieData(data);

    // Update session
    if (_currentSession != null) {
      _currentSession = _currentSession!.recordInteraction(elementType);
      await _saveSession();
    }
  }

  /// Track search
  Future<void> trackSearch(String userId, String query) async {
    final canTrack = await _consentService.canCollectData(
      userId,
      CookieDataType.searchQuery,
    );

    if (!canTrack) return;

    final data = CookieData(
      id: _uuid.v4(),
      userId: userId,
      type: CookieDataType.searchQuery,
      timestamp: DateTime.now(),
      sessionId: _currentSessionId,
      data: {
        'query': query,
        'resultsCount': 0, // Should be passed
      },
    );

    await _cookieService.storeCookieData(data);
  }

  /// Track performance metric
  Future<void> trackPerformance(
    String userId,
    String metricName,
    double value,
  ) async {
    final canTrack = await _consentService.canCollectData(
      userId,
      CookieDataType.performanceMetric,
    );

    if (!canTrack) return;

    final data = CookieData(
      id: _uuid.v4(),
      userId: userId,
      type: CookieDataType.performanceMetric,
      timestamp: DateTime.now(),
      sessionId: _currentSessionId,
      data: {
        'metric': metricName,
        'value': value,
        'unit': 'ms',
      },
    );

    await _cookieService.storeCookieData(data);
  }

  /// End session
  Future<void> endSession() async {
    if (_currentSession == null) return;

    _currentSession = _currentSession!.endSession();
    await _saveSession();

    _currentSessionId = null;
    _currentSession = null;
  }

  /// Get current session
  SessionAnalytics? getCurrentSession() => _currentSession;

  /// Get user sessions
  Future<List<SessionAnalytics>> getUserSessions(String userId) async {
    final json = _prefs.getString('${CookieConstants.sessionDataKey}_$userId');
    if (json == null) return [];

    try {
      final List<dynamic> list = jsonDecode(json);
      return list.map((e) => SessionAnalytics.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> _saveSession() async {
    if (_currentSession == null) return;

    try {
      final existing = await getUserSessions(_currentSession!.userId);

      // Update or add current session
      final index = existing.indexWhere(
        (s) => s.sessionId == _currentSession!.sessionId,
      );

      if (index >= 0) {
        existing[index] = _currentSession!;
      } else {
        existing.add(_currentSession!);
      }

      final json = jsonEncode(existing.map((e) => e.toJson()).toList());
      await _prefs.setString(
        '${CookieConstants.sessionDataKey}_${_currentSession!.userId}',
        json,
      );
    } catch (e) {
      // Error saving session
    }
  }

  /// Track CTA (Call to Action) click - simplified for public/unauthenticated users
  Future<void> trackCTAClick(
    String ctaName, {
    String? location,
    String? userId,
    Map<String, dynamic>? additionalData,
  }) async {
    // For public pages, we can track without full consent if it's anonymized
    final effectiveUserId = userId ?? 'anonymous';

    final data = CookieData(
      id: _uuid.v4(),
      userId: effectiveUserId,
      type: CookieDataType.clickEvent,
      timestamp: DateTime.now(),
      sessionId: _currentSessionId,
      data: {
        'elementType': 'cta',
        'elementId': ctaName,
        'location': location ?? 'unknown',
        ...?additionalData,
      },
    );

    await _cookieService.storeCookieData(data);

    if (_currentSession != null) {
      _currentSession = _currentSession!.recordInteraction('cta_$ctaName');
      await _saveSession();
    }
  }

  /// Track video interaction
  Future<void> trackVideoEvent(
    String action,
    String videoId, {
    String? userId,
  }) async {
    final effectiveUserId = userId ?? 'anonymous';

    final data = CookieData(
      id: _uuid.v4(),
      userId: effectiveUserId,
      type: CookieDataType.clickEvent,
      timestamp: DateTime.now(),
      sessionId: _currentSessionId,
      data: {
        'elementType': 'video',
        'action': action,
        'videoId': videoId,
      },
    );

    await _cookieService.storeCookieData(data);
  }

  /// Get analytics summary for user
  Future<Map<String, dynamic>> getUserAnalyticsSummary(String userId) async {
    final sessions = await getUserSessions(userId);
    final cookieData = await _cookieService.getCookieData(
      userId,
      category: CookieCategory.analytics,
    );

    final pageViews = cookieData
        .where((d) => d.type == CookieDataType.pageView)
        .length;

    final clicks = cookieData
        .where((d) => d.type == CookieDataType.clickEvent)
        .length;

    final totalDuration = sessions.fold<int>(
      0,
      (sum, s) => sum + s.durationSeconds,
    );

    return {
      'totalSessions': sessions.length,
      'totalPageViews': pageViews,
      'totalClicks': clicks,
      'totalDurationSeconds': totalDuration,
      'averageSessionDuration': sessions.isEmpty
          ? 0
          : totalDuration / sessions.length,
    };
  }
}
