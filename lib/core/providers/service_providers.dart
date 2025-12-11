/// Service Providers
/// Riverpod providers for all services

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../api/api_client.dart';
import '../services/auth_service.dart';
import '../services/secure_storage_service.dart';
import '../services/storage_service.dart';
import '../services/enrollments_service.dart';
import '../services/applications_service.dart';
import '../services/messaging_service.dart';
import '../services/notifications_service.dart';
import '../services/realtime_service.dart';
import '../services/enhanced_realtime_service.dart';
import '../models/user_model.dart';

/// Shared Preferences Provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be initialized in main()');
});

/// Secure Storage Service Provider
final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

/// Supabase Client Provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Storage Service Provider (for file uploads to Supabase Storage)
final storageServiceProvider = Provider<StorageService>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return StorageService(supabase);
});

/// API Client Provider
final apiClientProvider = Provider<ApiClient>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ApiClient(prefs);
});

/// Auth Service Provider
final authServiceProvider = Provider<AuthService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  final secureStorage = ref.watch(secureStorageServiceProvider);
  return AuthService(apiClient, prefs, secureStorage);
});

/// Enrollments Service Provider
final enrollmentsServiceProvider = Provider<EnrollmentsService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return EnrollmentsService(apiClient);
});

/// Applications Service Provider
final applicationsServiceProvider = Provider<ApplicationsService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ApplicationsService(apiClient);
});

/// Messaging Service Provider
final messagingServiceProvider = Provider<MessagingService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return MessagingService(apiClient);
});

/// Notifications Service Provider
final notificationsServiceProvider = Provider<NotificationsService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return NotificationsService(apiClient);
});

/// Current User Provider
final currentUserProvider = StateProvider<UserModel?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.currentUser;
});

/// Supabase Auth State Provider (watches real Supabase auth)
final supabaseAuthUserProvider = StreamProvider<User?>((ref) async* {
  final supabase = ref.watch(supabaseClientProvider);

  // Emit current user immediately
  yield supabase.auth.currentUser;

  // Then listen to auth state changes
  await for (final authState in supabase.auth.onAuthStateChange) {
    yield authState.session?.user;
  }
});

/// Authentication State Provider
final isAuthenticatedProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user != null;
});

/// Unread Messages Count Provider
final unreadMessagesCountProvider = FutureProvider<int>((ref) async {
  final messagingService = ref.watch(messagingServiceProvider);
  final response = await messagingService.getUnreadCount();

  if (response.success && response.data != null) {
    return response.data!['count'] ?? 0;
  }
  return 0;
});

/// Unread Notifications Count Provider
final unreadNotificationsCountProvider = FutureProvider<int>((ref) async {
  final notificationsService = ref.watch(notificationsServiceProvider);
  final response = await notificationsService.getUnreadCount();

  if (response.success && response.data != null) {
    return response.data!['count'] ?? 0;
  }
  return 0;
});

/// Realtime Service Provider
final realtimeServiceProvider = Provider<RealtimeService>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return RealtimeService(supabase);
});

/// Enhanced Realtime Service Provider
final enhancedRealtimeServiceProvider = Provider<EnhancedRealtimeService>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  final service = EnhancedRealtimeService(supabase);

  // Clean up on disposal
  ref.onDispose(() {
    service.dispose();
  });

  return service;
});

/// Connection Status Provider
final realtimeConnectionStatusProvider = StreamProvider<ConnectionStatus>((ref) {
  final service = ref.watch(enhancedRealtimeServiceProvider);
  return service.connectionStatus;
});
