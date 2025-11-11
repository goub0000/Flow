import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/notification_model.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_config.dart';
import '../../../core/providers/service_providers.dart';

/// State class for managing notifications
class NotificationsState {
  final List<NotificationModel> notifications;
  final bool isLoading;
  final String? error;

  const NotificationsState({
    this.notifications = const [],
    this.isLoading = false,
    this.error,
  });

  NotificationsState copyWith({
    List<NotificationModel>? notifications,
    bool? isLoading,
    String? error,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier for managing notifications
class NotificationsNotifier extends StateNotifier<NotificationsState> {
  final ApiClient _apiClient;

  NotificationsNotifier(this._apiClient) : super(const NotificationsState()) {
    fetchNotifications();
  }

  /// Fetch all notifications for current user from backend API
  Future<void> fetchNotifications() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiClient.get(
        ApiConfig.notifications,
        fromJson: (data) {
          if (data is List) {
            return data.map((notifJson) => NotificationModel.fromJson(notifJson)).toList();
          }
          return <NotificationModel>[];
        },
      );

      if (response.success && response.data != null) {
        state = state.copyWith(
          notifications: response.data!,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to fetch notifications',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch notifications: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Mark notification as read via backend API
  Future<void> markAsRead(String notificationId) async {
    try {
      await _apiClient.post(
        '${ApiConfig.notifications}/read',
        data: {
          'notification_ids': [notificationId],
        },
      );

      final updatedNotifications = state.notifications.map((notif) {
        if (notif.id == notificationId) {
          return NotificationModel(
            id: notif.id,
            userId: notif.userId,
            type: notif.type,
            title: notif.title,
            body: notif.body,
            data: notif.data,
            isRead: true,
            createdAt: notif.createdAt,
          );
        }
        return notif;
      }).toList();

      state = state.copyWith(notifications: updatedNotifications);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to mark as read: ${e.toString()}',
      );
    }
  }

  /// Mark all notifications as read via backend API
  Future<void> markAllAsRead() async {
    try {
      await _apiClient.post('${ApiConfig.notifications}/read-all');

      final updatedNotifications = state.notifications.map((notif) {
        return NotificationModel(
          id: notif.id,
          userId: notif.userId,
          type: notif.type,
          title: notif.title,
          body: notif.body,
          data: notif.data,
          isRead: true,
          createdAt: notif.createdAt,
        );
      }).toList();

      state = state.copyWith(notifications: updatedNotifications);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to mark all as read: ${e.toString()}',
      );
    }
  }

  /// Delete notification via backend API
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _apiClient.delete('${ApiConfig.notifications}/$notificationId');

      final updatedNotifications = state.notifications
          .where((notif) => notif.id != notificationId)
          .toList();

      state = state.copyWith(notifications: updatedNotifications);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to delete notification: ${e.toString()}',
      );
    }
  }

  /// Clear all notifications (delete all)
  Future<void> clearAll() async {
    try {
      // Delete all notifications via backend
      final notificationIds = state.notifications.map((n) => n.id).toList();

      for (final id in notificationIds) {
        await _apiClient.delete('${ApiConfig.notifications}/$id');
      }

      state = state.copyWith(notifications: []);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to clear notifications: ${e.toString()}',
      );
    }
  }

  /// Filter notifications by type
  List<NotificationModel> filterByType(String type) {
    if (type == 'all') return state.notifications;

    return state.notifications.where((notif) => notif.type == type).toList();
  }

  /// Get unread notifications
  List<NotificationModel> getUnreadNotifications() {
    return state.notifications.where((notif) => !notif.isRead).toList();
  }

  /// Get unread count
  int getUnreadCount() {
    return state.notifications.where((notif) => !notif.isRead).length;
  }

  /// Get notifications by type count
  Map<String, int> getNotificationTypeCounts() {
    final Map<String, int> counts = {};

    for (final notif in state.notifications) {
      counts[notif.type] = (counts[notif.type] ?? 0) + 1;
    }

    return counts;
  }
}

/// Provider for notifications state
final notificationsProvider = StateNotifierProvider<NotificationsNotifier, NotificationsState>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return NotificationsNotifier(apiClient);
});

/// Provider for notifications list
final notificationsListProvider = Provider<List<NotificationModel>>((ref) {
  final notificationsState = ref.watch(notificationsProvider);
  return notificationsState.notifications;
});

/// Provider for unread notifications
final unreadNotificationsProvider = Provider<List<NotificationModel>>((ref) {
  final notifier = ref.watch(notificationsProvider.notifier);
  return notifier.getUnreadNotifications();
});

/// Provider for unread count
final unreadNotificationsCountProvider = Provider<int>((ref) {
  final notifier = ref.watch(notificationsProvider.notifier);
  return notifier.getUnreadCount();
});

/// Provider for notification type counts
final notificationTypeCountsProvider = Provider<Map<String, int>>((ref) {
  final notifier = ref.watch(notificationsProvider.notifier);
  return notifier.getNotificationTypeCounts();
});

/// Provider for checking if notifications are loading
final notificationsLoadingProvider = Provider<bool>((ref) {
  final notificationsState = ref.watch(notificationsProvider);
  return notificationsState.isLoading;
});

/// Provider for notifications error
final notificationsErrorProvider = Provider<String?>((ref) {
  final notificationsState = ref.watch(notificationsProvider);
  return notificationsState.error;
});
