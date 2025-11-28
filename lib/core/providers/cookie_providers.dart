// lib/core/providers/cookie_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/consent_service.dart';
import '../services/cookie_service.dart';
import '../services/analytics_service.dart';
import '../models/user_consent.dart';
import '../../features/authentication/providers/auth_provider.dart';

/// Tracks whether cookie banner has been handled in this session
/// This prevents the banner from showing multiple times during a session
class CookieBannerState extends StateNotifier<bool> {
  CookieBannerState() : super(false);

  void markAsHandled() => state = true;
  void reset() => state = false;
}

/// Provider to track if cookie banner was already shown/handled this session
final cookieBannerHandledProvider =
    StateNotifierProvider<CookieBannerState, bool>((ref) {
  return CookieBannerState();
});

/// SharedPreferences provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main.dart');
});

/// ConsentService provider
final consentServiceProvider = Provider<ConsentService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ConsentService(prefs);
});

/// CookieService provider
final cookieServiceProvider = Provider<CookieService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final consentService = ref.watch(consentServiceProvider);
  return CookieService(prefs, consentService);
});

/// AnalyticsService provider
final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final cookieService = ref.watch(cookieServiceProvider);
  final consentService = ref.watch(consentServiceProvider);
  return AnalyticsService(prefs, cookieService, consentService);
});

/// Current user consent provider
final userConsentProvider =
    FutureProvider.family<UserConsent?, String>((ref, userId) async {
  final service = ref.watch(consentServiceProvider);
  return await service.getUserConsent(userId);
});

/// Consent needed check provider
final consentNeededProvider =
    FutureProvider.family<bool, String>((ref, userId) async {
  final service = ref.watch(consentServiceProvider);
  return await service.needsConsent(userId);
});

/// Consent statistics provider (for admin dashboard)
final consentStatisticsProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  final service = ref.watch(consentServiceProvider);
  return await service.getConsentStatistics();
});

/// User analytics summary provider
final userAnalyticsSummaryProvider =
    FutureProvider.family<Map<String, dynamic>, String>(
  (ref, userId) async {
    final service = ref.watch(analyticsServiceProvider);
    return await service.getUserAnalyticsSummary(userId);
  },
);

/// Current user ID provider (from auth)
final currentUserIdProvider = Provider<String?>((ref) {
  final authState = ref.watch(authProvider);
  return authState.user?.id;
});
