import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/notification_models.dart';
import '../services/notification_service.dart';
import '../../features/authentication/providers/auth_provider.dart';

// ==================== SERVICE PROVIDERS ====================

/// Provider for NotificationService
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

// ==================== STATE CLASSES ====================

/// State for notifications list
class NotificationsState {
  final List<AppNotification> notifications;
  final int totalCount;
  final int unreadCount;
  final int currentPage;
  final int limit;
  final bool hasMore;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final NotificationFilter? currentFilter;

  const NotificationsState({
    this.notifications = const [],
    this.totalCount = 0,
    this.unreadCount = 0,
    this.currentPage = 1,
    this.limit = 20,
    this.hasMore = false,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.currentFilter,
  });

  NotificationsState copyWith({
    List<AppNotification>? notifications,
    int? totalCount,
    int? unreadCount,
    int? currentPage,
    int? limit,
    bool? hasMore,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    NotificationFilter? currentFilter,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      totalCount: totalCount ?? this.totalCount,
      unreadCount: unreadCount ?? this.unreadCount,
      currentPage: currentPage ?? this.currentPage,
      limit: limit ?? this.limit,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      currentFilter: currentFilter ?? this.currentFilter,
    );
  }
}

// ==================== NOTIFIERS ====================

/// Notifier for managing notifications
class NotificationsNotifier extends StateNotifier<NotificationsState> {
  final NotificationService _service;
  RealtimeChannel? _realtimeChannel;

  NotificationsNotifier(this._service) : super(const NotificationsState());

  /// Fetch notifications with optional filter
  Future<void> fetchNotifications({
    NotificationFilter? filter,
    bool append = false,
  }) async {
    if (append) {
      state = state.copyWith(isLoadingMore: true, error: null);
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final effectiveFilter = filter ??
          state.currentFilter ??
          const NotificationFilter(page: 1, limit: 20);

      final response = await _service.getNotifications(filter: effectiveFilter);

      if (append) {
        // Append to existing notifications
        final updatedNotifications = [
          ...state.notifications,
          ...response.notifications,
        ];
        state = state.copyWith(
          notifications: updatedNotifications,
          totalCount: response.totalCount,
          unreadCount: response.unreadCount,
          currentPage: response.page,
          limit: response.limit,
          hasMore: response.hasMore,
          isLoading: false,
          isLoadingMore: false,
          currentFilter: effectiveFilter,
        );
      } else {
        // Replace notifications
        state = state.copyWith(
          notifications: response.notifications,
          totalCount: response.totalCount,
          unreadCount: response.unreadCount,
          currentPage: response.page,
          limit: response.limit,
          hasMore: response.hasMore,
          isLoading: false,
          currentFilter: effectiveFilter,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }

  /// Load next page
  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore) return;

    final nextFilter = state.currentFilter?.copyWith(
          page: state.currentPage + 1,
        ) ??
        NotificationFilter(page: state.currentPage + 1, limit: state.limit);

    await fetchNotifications(filter: nextFilter, append: true);
  }

  /// Refresh notifications (pull to refresh)
  Future<void> refresh() async {
    final filter = state.currentFilter?.copyWith(page: 1) ??
        const NotificationFilter(page: 1, limit: 20);
    await fetchNotifications(filter: filter);
  }

  /// Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await _service.markAsRead(notificationId);

      // Optimistically update UI
      final updatedNotifications = state.notifications.map((n) {
        if (n.id == notificationId) {
          return n.copyWith(isRead: true, readAt: DateTime.now());
        }
        return n;
      }).toList();

      state = state.copyWith(
        notifications: updatedNotifications,
        unreadCount: state.unreadCount > 0 ? state.unreadCount - 1 : 0,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Mark notification as unread
  Future<void> markAsUnread(String notificationId) async {
    try {
      await _service.markAsUnread(notificationId);

      // Optimistically update UI
      final updatedNotifications = state.notifications.map((n) {
        if (n.id == notificationId) {
          return n.copyWith(isRead: false, readAt: null);
        }
        return n;
      }).toList();

      state = state.copyWith(
        notifications: updatedNotifications,
        unreadCount: state.unreadCount + 1,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Mark all as read
  Future<void> markAllAsRead() async {
    try {
      final count = await _service.markAllAsRead();

      // Update UI
      final updatedNotifications =
          state.notifications.map((n) => n.copyWith(isRead: true)).toList();

      state = state.copyWith(
        notifications: updatedNotifications,
        unreadCount: 0,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Archive notification
  Future<void> archiveNotification(String notificationId) async {
    try {
      await _service.archiveNotification(notificationId);

      // Remove from list
      final updatedNotifications =
          state.notifications.where((n) => n.id != notificationId).toList();

      state = state.copyWith(
        notifications: updatedNotifications,
        totalCount: state.totalCount > 0 ? state.totalCount - 1 : 0,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Delete notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _service.deleteNotification(notificationId);

      // Remove from list
      final updatedNotifications =
          state.notifications.where((n) => n.id != notificationId).toList();

      // Update unread count if it was unread
      final wasUnread = state.notifications
          .firstWhere((n) => n.id == notificationId)
          .isUnread;

      state = state.copyWith(
        notifications: updatedNotifications,
        totalCount: state.totalCount > 0 ? state.totalCount - 1 : 0,
        unreadCount: wasUnread && state.unreadCount > 0
            ? state.unreadCount - 1
            : state.unreadCount,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Apply filter
  Future<void> applyFilter(NotificationFilter filter) async {
    await fetchNotifications(filter: filter);
  }

  /// Clear filter
  Future<void> clearFilter() async {
    await fetchNotifications(filter: const NotificationFilter(page: 1, limit: 20));
  }

  /// Subscribe to real-time updates
  void subscribeToRealtime() {
    try {
      final channel = _service.subscribeToNotifications((notification) {
        // Add new notification to the top of the list
        final updatedNotifications = [notification, ...state.notifications];

        state = state.copyWith(
          notifications: updatedNotifications,
          totalCount: state.totalCount + 1,
          unreadCount: state.unreadCount + 1,
        );
      });

      if (channel == null) {
        // User not authenticated yet, retry after delay
        print('Notification subscription deferred - waiting for auth');
        Future.delayed(const Duration(milliseconds: 500), () {
          subscribeToRealtime();
        });
        return;
      }

      _realtimeChannel = channel;
    } catch (e) {
      print('Error subscribing to realtime updates: $e');
    }
  }

  /// Unsubscribe from real-time updates
  Future<void> unsubscribeFromRealtime() async {
    if (_realtimeChannel != null) {
      await _service.unsubscribe(_realtimeChannel!);
      _realtimeChannel = null;
    }
  }

  @override
  void dispose() {
    unsubscribeFromRealtime();
    super.dispose();
  }
}

// ==================== PROVIDERS ====================

/// Main notifications provider
final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, NotificationsState>((ref) {
  final service = ref.watch(notificationServiceProvider);
  final notifier = NotificationsNotifier(service);

  // Watch auth state and only fetch when authenticated
  final authState = ref.watch(authProvider);

  // Auto-fetch when authenticated
  if (authState.isAuthenticated) {
    Future.microtask(() {
      notifier.fetchNotifications();
      notifier.subscribeToRealtime(); // Subscribe to real-time updates
    });
  }

  // Cleanup on dispose
  ref.onDispose(() {
    notifier.unsubscribeFromRealtime();
  });

  return notifier;
});

/// Provider for unread notification count
final unreadNotificationCountProvider = Provider<int>((ref) {
  final state = ref.watch(notificationsProvider);
  return state.unreadCount;
});

/// Provider for checking if there are unread notifications
final hasUnreadNotificationsProvider = Provider<bool>((ref) {
  final count = ref.watch(unreadNotificationCountProvider);
  return count > 0;
});

/// Provider for unread notifications only
final unreadNotificationsProvider =
    Provider<List<AppNotification>>((ref) {
  final state = ref.watch(notificationsProvider);
  return state.notifications.where((n) => n.isUnread).toList();
});

/// Provider for notification preferences
final notificationPreferencesProvider =
    FutureProvider<List<NotificationPreference>>((ref) async {
  final service = ref.watch(notificationServiceProvider);
  return service.getPreferences();
});

/// Provider for a specific notification preference
final notificationPreferenceProvider = Provider.family<
    AsyncValue<NotificationPreference?>,
    NotificationType>((ref, type) {
  final preferencesAsync = ref.watch(notificationPreferencesProvider);

  return preferencesAsync.when(
    data: (preferences) {
      try {
        final preference = preferences.firstWhere(
          (p) => p.notificationType == type,
        );
        return AsyncValue.data(preference);
      } catch (e) {
        return const AsyncValue.data(null);
      }
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

/// Provider for updating notification preferences
final updateNotificationPreferenceProvider =
    Provider<Future<void> Function(UpdateNotificationPreferencesRequest)>(
        (ref) {
  final service = ref.watch(notificationServiceProvider);
  return (request) async {
    await service.updatePreference(request);
    // Refresh preferences after update
    ref.invalidate(notificationPreferencesProvider);
  };
});

/// Provider for creating default preferences
final createDefaultPreferencesProvider = Provider<Future<void> Function()>((ref) {
  final service = ref.watch(notificationServiceProvider);
  return () async {
    await service.createDefaultPreferences();
    ref.invalidate(notificationPreferencesProvider);
  };
});

// ==================== FILTER PROVIDERS ====================

/// Provider for notification filter state
final notificationFilterProvider =
    StateProvider<NotificationFilter?>((ref) => null);

/// Provider for applying filter
final applyNotificationFilterProvider =
    Provider<void Function(NotificationFilter?)>((ref) {
  return (filter) {
    ref.read(notificationFilterProvider.notifier).state = filter;
    if (filter != null) {
      ref.read(notificationsProvider.notifier).applyFilter(filter);
    } else {
      ref.read(notificationsProvider.notifier).clearFilter();
    }
  };
});

// ==================== DERIVED PROVIDERS ====================

/// Provider for notifications grouped by date
final notificationsByDateProvider =
    Provider<Map<String, List<AppNotification>>>((ref) {
  final state = ref.watch(notificationsProvider);
  final notifications = state.notifications;

  final grouped = <String, List<AppNotification>>{};

  for (final notification in notifications) {
    final now = DateTime.now();
    final difference = now.difference(notification.createdAt);

    String key;
    if (difference.inDays == 0) {
      key = 'Today';
    } else if (difference.inDays == 1) {
      key = 'Yesterday';
    } else if (difference.inDays < 7) {
      key = 'This Week';
    } else if (difference.inDays < 30) {
      key = 'This Month';
    } else {
      key = 'Older';
    }

    grouped.putIfAbsent(key, () => []);
    grouped[key]!.add(notification);
  }

  return grouped;
});

/// Provider for notifications by type
final notificationsByTypeProvider =
    Provider.family<List<AppNotification>, NotificationType>((ref, type) {
  final state = ref.watch(notificationsProvider);
  return state.notifications.where((n) => n.type == type).toList();
});
