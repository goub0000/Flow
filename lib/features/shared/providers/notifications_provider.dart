import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/notification_model.dart';

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
  NotificationsNotifier() : super(const NotificationsState()) {
    fetchNotifications();
  }

  /// Fetch all notifications for current user
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<void> fetchNotifications() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Replace with actual Firebase query
      // Example: FirebaseFirestore.instance
      //   .collection('notifications')
      //   .where('userId', isEqualTo: currentUserId)
      //   .orderBy('createdAt', descending: true)
      //   .get()

      await Future.delayed(const Duration(seconds: 1));

      // Mock data for development
      final mockNotifications = List<NotificationModel>.generate(
        20,
        (index) => NotificationModel.mockNotification(index),
      );

      state = state.copyWith(
        notifications: mockNotifications,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch notifications: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Mark notification as read
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<void> markAsRead(String notificationId) async {
    try {
      // TODO: Update in Firebase

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

  /// Mark all notifications as read
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<void> markAllAsRead() async {
    try {
      // TODO: Batch update in Firebase

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

  /// Delete notification
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<void> deleteNotification(String notificationId) async {
    try {
      // TODO: Delete from Firebase

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

  /// Clear all notifications
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<void> clearAll() async {
    try {
      // TODO: Delete all from Firebase

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
  return NotificationsNotifier();
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
