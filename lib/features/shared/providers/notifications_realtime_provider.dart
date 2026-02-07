/// Notifications Real-Time Provider
/// Manages real-time subscriptions for notification updates
library;

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/models/notification_model.dart';
import '../../../core/providers/service_providers.dart' hide currentUserProvider;
import '../../../core/services/enhanced_realtime_service.dart';
import '../../authentication/providers/auth_provider.dart';

/// State class for real-time notifications
class RealtimeNotificationsState {
  final List<NotificationModel> notifications;
  final int unreadCount;
  final bool isLoading;
  final bool isConnected;
  final String? error;
  final DateTime? lastUpdate;
  final bool hasNewNotification;
  final NotificationModel? latestNotification;

  const RealtimeNotificationsState({
    this.notifications = const [],
    this.unreadCount = 0,
    this.isLoading = false,
    this.isConnected = false,
    this.error,
    this.lastUpdate,
    this.hasNewNotification = false,
    this.latestNotification,
  });

  RealtimeNotificationsState copyWith({
    List<NotificationModel>? notifications,
    int? unreadCount,
    bool? isLoading,
    bool? isConnected,
    String? error,
    DateTime? lastUpdate,
    bool? hasNewNotification,
    NotificationModel? latestNotification,
  }) {
    return RealtimeNotificationsState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoading: isLoading ?? this.isLoading,
      isConnected: isConnected ?? this.isConnected,
      error: error,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      hasNewNotification: hasNewNotification ?? this.hasNewNotification,
      latestNotification: latestNotification ?? this.latestNotification,
    );
  }
}

/// StateNotifier for managing real-time notifications
class NotificationsRealtimeNotifier extends StateNotifier<RealtimeNotificationsState> {
  final Ref ref;
  final EnhancedRealtimeService _realtimeService;
  final SupabaseClient _supabase;

  StreamSubscription<ConnectionStatus>? _connectionSubscription;
  Timer? _refreshTimer;
  Timer? _newNotificationTimer;
  bool _disposed = false;

  NotificationsRealtimeNotifier(
    this.ref,
    this._realtimeService,
    this._supabase,
  ) : super(const RealtimeNotificationsState()) {
    _initialize();
  }

  void _initialize() {
    // Initial fetch
    _fetchNotifications();

    // Setup real-time subscription
    _setupRealtimeSubscription();

    // Monitor connection status
    _monitorConnectionStatus();

    // Setup periodic refresh as fallback
    _setupPeriodicRefresh();
  }

  /// Fetch notifications from database
  Future<void> _fetchNotifications() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = ref.read(currentUserProvider);
      if (user == null) {
        state = state.copyWith(
          error: null, // Don't show error - just waiting for auth
          isLoading: false,
        );
        // Retry after a short delay
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!_disposed) _fetchNotifications();
        });
        return;
      }

      // Fetch from Supabase
      final response = await _supabase
          .from('notifications')
          .select('*')
          .eq('user_id', user.id)
          .order('created_at', ascending: false)
          .limit(50); // Limit to most recent 50 notifications

      final notifications = (response as List<dynamic>)
          .map((json) => NotificationModel.fromJson(json))
          .toList();

      final unreadCount = notifications.where((n) => !n.isRead).length;

      state = state.copyWith(
        notifications: notifications,
        unreadCount: unreadCount,
        isLoading: false,
        lastUpdate: DateTime.now(),
      );

    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch notifications: $e',
        isLoading: false,
      );
    }
  }

  /// Setup real-time subscription for notification updates
  void _setupRealtimeSubscription() {
    final user = ref.read(currentUserProvider);
    if (user == null) {
      // Retry after auth is loaded
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!_disposed) _setupRealtimeSubscription();
      });
      return;
    }

    final channelName = 'user_notifications_${user.id}';

    _realtimeService.subscribeToUserRecords(
      table: 'notifications',
      channelName: channelName,
      userId: user.id,
      userColumn: 'user_id',
      onInsert: _handleInsert,
      onUpdate: _handleUpdate,
      onDelete: _handleDelete,
      onError: (error) {
        state = state.copyWith(error: error);
      },
    );
  }

  /// Handle INSERT event (new notification)
  void _handleInsert(Map<String, dynamic> payload) {
    try {
      final newNotification = NotificationModel.fromJson(payload);

      // Add to top of list
      final updatedNotifications = [newNotification, ...state.notifications];

      // Update unread count
      final unreadCount = updatedNotifications.where((n) => !n.isRead).length;

      state = state.copyWith(
        notifications: updatedNotifications,
        unreadCount: unreadCount,
        lastUpdate: DateTime.now(),
        hasNewNotification: true,
        latestNotification: newNotification,
      );

      // Auto-clear the new notification flag after 5 seconds
      _newNotificationTimer?.cancel();
      _newNotificationTimer = Timer(const Duration(seconds: 5), () {
        state = state.copyWith(hasNewNotification: false);
      });

      // Trigger system notification (if implemented)
      _showSystemNotification(newNotification);

    } catch (e) {
      // Handle error silently
    }
  }

  /// Handle UPDATE event (notification marked as read, etc.)
  void _handleUpdate(Map<String, dynamic> payload) {
    try {
      final updatedNotification = NotificationModel.fromJson(payload);

      // Update in list
      final updatedNotifications = state.notifications.map((notification) {
        if (notification.id == updatedNotification.id) {
          return updatedNotification;
        }
        return notification;
      }).toList();

      // Update unread count
      final unreadCount = updatedNotifications.where((n) => !n.isRead).length;

      state = state.copyWith(
        notifications: updatedNotifications,
        unreadCount: unreadCount,
        lastUpdate: DateTime.now(),
      );

    } catch (e) {
      // Handle error silently
    }
  }

  /// Handle DELETE event
  void _handleDelete(Map<String, dynamic> payload) {
    try {

      final deletedId = payload['id'] as String;

      // Remove from state
      final updatedNotifications = state.notifications
          .where((notification) => notification.id != deletedId)
          .toList();

      // Update unread count
      final unreadCount = updatedNotifications.where((n) => !n.isRead).length;

      state = state.copyWith(
        notifications: updatedNotifications,
        unreadCount: unreadCount,
        lastUpdate: DateTime.now(),
      );

    } catch (e) {
      // Handle error silently
    }
  }

  /// Monitor connection status
  void _monitorConnectionStatus() {
    _connectionSubscription = _realtimeService.connectionStatus.listen((status) {
      final isConnected = status == ConnectionStatus.connected;
      state = state.copyWith(isConnected: isConnected);

      if (status == ConnectionStatus.connected && state.lastUpdate == null) {
        // First connection - fetch data
        _fetchNotifications();
      }
    });
  }

  /// Setup periodic refresh as fallback
  void _setupPeriodicRefresh() {
    // Refresh every 60 seconds if not connected to real-time
    _refreshTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      if (!state.isConnected) {
        refresh();
      }
    });
  }

  /// Show system notification (platform-specific)
  void _showSystemNotification(NotificationModel notification) {
    // TODO: Implement platform-specific notification
    // For web: Use browser notification API
    // For mobile: Use flutter_local_notifications package
  }

  /// Manual refresh
  Future<void> refresh() async {
    await _fetchNotifications();
  }

  /// Mark notification as read
  Future<bool> markAsRead(String notificationId) async {
    // Find the notification
    final notificationIndex = state.notifications.indexWhere((n) => n.id == notificationId);
    if (notificationIndex == -1) return false;

    final notification = state.notifications[notificationIndex];
    if (notification.isRead) return true; // Already read

    // Optimistic update
    final optimisticNotification = notification.copyWith(
      isRead: true,
      readAt: DateTime.now(),
    );
    final optimisticNotifications = [...state.notifications];
    optimisticNotifications[notificationIndex] = optimisticNotification;

    state = state.copyWith(
      notifications: optimisticNotifications,
      unreadCount: state.unreadCount - 1,
    );

    try {
      // Update in backend
      await _supabase
          .from('notifications')
          .update({
            'is_read': true,
            'read_at': DateTime.now().toIso8601String(),
          })
          .eq('id', notificationId);

      // Real-time will confirm the update
      return true;
    } catch (e) {
      // Revert on error
      await refresh();
      return false;
    }
  }

  /// Mark all notifications as read
  Future<bool> markAllAsRead() async {
    if (state.unreadCount == 0) return true;

    // Optimistic update
    final optimisticNotifications = state.notifications.map((notification) {
      if (!notification.isRead) {
        return notification.copyWith(
          isRead: true,
          readAt: DateTime.now(),
        );
      }
      return notification;
    }).toList();

    state = state.copyWith(
      notifications: optimisticNotifications,
      unreadCount: 0,
    );

    try {
      final user = ref.read(currentUserProvider);
      if (user == null) return false;

      // Update all unread notifications in backend
      await _supabase
          .from('notifications')
          .update({
            'is_read': true,
            'read_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', user.id)
          .eq('is_read', false);

      return true;
    } catch (e) {
      // Revert on error
      await refresh();
      return false;
    }
  }

  /// Delete notification
  Future<bool> deleteNotification(String notificationId) async {
    // Optimistic update
    final optimisticNotifications = state.notifications
        .where((n) => n.id != notificationId)
        .toList();

    final deletedNotification = state.notifications.firstWhere((n) => n.id == notificationId);
    final newUnreadCount = deletedNotification.isRead
        ? state.unreadCount
        : state.unreadCount - 1;

    state = state.copyWith(
      notifications: optimisticNotifications,
      unreadCount: newUnreadCount,
    );

    try {
      // Delete from backend
      await _supabase
          .from('notifications')
          .delete()
          .eq('id', notificationId);

      return true;
    } catch (e) {
      // Revert on error
      await refresh();
      return false;
    }
  }

  /// Clear all notifications
  Future<bool> clearAll() async {
    // Optimistic update
    state = state.copyWith(
      notifications: [],
      unreadCount: 0,
    );

    try {
      final user = ref.read(currentUserProvider);
      if (user == null) return false;

      // Delete all notifications for user
      await _supabase
          .from('notifications')
          .delete()
          .eq('user_id', user.id);

      return true;
    } catch (e) {
      // Revert on error
      await refresh();
      return false;
    }
  }

  /// Get notifications by type
  List<NotificationModel> getNotificationsByType(String type) {
    return state.notifications.where((n) => n.type == type).toList();
  }

  /// Get unread notifications
  List<NotificationModel> getUnreadNotifications() {
    return state.notifications.where((n) => !n.isRead).toList();
  }

  /// Check if user has new important notifications
  bool hasImportantNotifications() {
    return state.notifications.any((n) =>
      !n.isRead &&
      (n.type == 'acceptance' ||
       n.type == 'rejection' ||
       n.type == 'urgent' ||
       n.type == 'deadline'));
  }

  @override
  void dispose() {
    _disposed = true;

    // Clean up subscriptions
    final user = ref.read(currentUserProvider);
    if (user != null) {
      _realtimeService.unsubscribe('user_notifications_${user.id}');
    }

    _connectionSubscription?.cancel();
    _refreshTimer?.cancel();
    _newNotificationTimer?.cancel();

    super.dispose();
  }
}

/// Provider for real-time notifications
final notificationsRealtimeProvider = StateNotifierProvider.autoDispose<
    NotificationsRealtimeNotifier, RealtimeNotificationsState>((ref) {
  final realtimeService = ref.watch(enhancedRealtimeServiceProvider);
  final supabase = ref.watch(supabaseClientProvider);

  return NotificationsRealtimeNotifier(ref, realtimeService, supabase);
});

/// Provider for notifications list
final realtimeNotificationsListProvider = Provider.autoDispose<List<NotificationModel>>((ref) {
  final state = ref.watch(notificationsRealtimeProvider);
  return state.notifications;
});

/// Provider for unread count
final realtimeUnreadNotificationsCountProvider = Provider.autoDispose<int>((ref) {
  final state = ref.watch(notificationsRealtimeProvider);
  return state.unreadCount;
});

/// Provider for connection status
final notificationsRealtimeConnectedProvider = Provider.autoDispose<bool>((ref) {
  final state = ref.watch(notificationsRealtimeProvider);
  return state.isConnected;
});

/// Provider for new notification flag
final hasNewNotificationProvider = Provider.autoDispose<bool>((ref) {
  final state = ref.watch(notificationsRealtimeProvider);
  return state.hasNewNotification;
});

/// Provider for latest notification
final latestNotificationProvider = Provider.autoDispose<NotificationModel?>((ref) {
  final state = ref.watch(notificationsRealtimeProvider);
  return state.latestNotification;
});

/// Provider for important notifications
final importantNotificationsProvider = Provider.autoDispose<List<NotificationModel>>((ref) {
  final notifications = ref.watch(realtimeNotificationsListProvider);
  return notifications.where((n) =>
    n.type == 'acceptance' ||
    n.type == 'rejection' ||
    n.type == 'urgent' ||
    n.type == 'deadline'
  ).toList();
});