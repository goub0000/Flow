import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_config.dart';
import '../../../core/providers/service_providers.dart';
import '../models/notification_preferences_model.dart';

/// State class for notification preferences
class NotificationPreferencesState {
  final NotificationPreferences? preferences;
  final bool isLoading;
  final String? error;

  const NotificationPreferencesState({
    this.preferences,
    this.isLoading = false,
    this.error,
  });

  NotificationPreferencesState copyWith({
    NotificationPreferences? preferences,
    bool? isLoading,
    String? error,
  }) {
    return NotificationPreferencesState(
      preferences: preferences ?? this.preferences,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier for managing notification preferences
class NotificationPreferencesNotifier extends StateNotifier<NotificationPreferencesState> {
  final ApiClient _apiClient;

  NotificationPreferencesNotifier(this._apiClient) : super(const NotificationPreferencesState()) {
    fetchPreferences();
  }

  /// Fetch notification preferences from backend API
  Future<void> fetchPreferences() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiClient.get(
        '${ApiConfig.notifications}/preferences/me',
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        final preferences = NotificationPreferences.fromJson(response.data!);
        state = state.copyWith(
          preferences: preferences,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to fetch preferences',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch preferences: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Update notification preferences
  Future<bool> updatePreferences(NotificationPreferencesUpdate update) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiClient.put(
        '${ApiConfig.notifications}/preferences/me',
        data: update.toJson(),
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        final preferences = NotificationPreferences.fromJson(response.data!);
        state = state.copyWith(
          preferences: preferences,
          isLoading: false,
        );
        return true;
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to update preferences',
          isLoading: false,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to update preferences: ${e.toString()}',
        isLoading: false,
      );
      return false;
    }
  }

  /// Toggle email notifications
  Future<bool> toggleEmail(bool enabled) async {
    return updatePreferences(NotificationPreferencesUpdate(emailEnabled: enabled));
  }

  /// Toggle push notifications
  Future<bool> togglePush(bool enabled) async {
    return updatePreferences(NotificationPreferencesUpdate(pushEnabled: enabled));
  }

  /// Toggle SMS notifications
  Future<bool> toggleSms(bool enabled) async {
    return updatePreferences(NotificationPreferencesUpdate(smsEnabled: enabled));
  }

  /// Toggle in-app notifications
  Future<bool> toggleInApp(bool enabled) async {
    return updatePreferences(NotificationPreferencesUpdate(inAppEnabled: enabled));
  }

  /// Update notification type preferences
  Future<bool> updateNotificationTypes(Map<String, bool> types) async {
    return updatePreferences(NotificationPreferencesUpdate(notificationTypes: types));
  }

  /// Toggle specific notification type
  Future<bool> toggleNotificationType(String type, bool enabled) async {
    final currentPrefs = state.preferences;
    if (currentPrefs == null) return false;

    final updatedTypes = Map<String, bool>.from(currentPrefs.notificationTypes);
    updatedTypes[type] = enabled;

    return updateNotificationTypes(updatedTypes);
  }

  /// Update quiet hours
  Future<bool> updateQuietHours(String? start, String? end) async {
    return updatePreferences(NotificationPreferencesUpdate(
      quietHoursStart: start,
      quietHoursEnd: end,
    ));
  }
}

/// Provider for notification preferences state
final notificationPreferencesProvider = StateNotifierProvider<NotificationPreferencesNotifier, NotificationPreferencesState>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return NotificationPreferencesNotifier(apiClient);
});

/// Provider for notification preferences
final notificationPreferencesDataProvider = Provider<NotificationPreferences?>((ref) {
  final preferencesState = ref.watch(notificationPreferencesProvider);
  return preferencesState.preferences;
});

/// Provider for preferences loading state
final notificationPreferencesLoadingProvider = Provider<bool>((ref) {
  final preferencesState = ref.watch(notificationPreferencesProvider);
  return preferencesState.isLoading;
});

/// Provider for preferences error
final notificationPreferencesErrorProvider = Provider<String?>((ref) {
  final preferencesState = ref.watch(notificationPreferencesProvider);
  return preferencesState.error;
});
