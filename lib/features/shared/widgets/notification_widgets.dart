import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Notification Widgets
///
/// Comprehensive notification UI components including:
/// - Notification cards with actions
/// - In-app notification banners
/// - Notification badges
/// - Empty states
///
/// Backend Integration TODO:
/// ```dart
/// // Option 1: Push notifications via backend API
/// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
///
/// class NotificationService {
///   Future<void> initialize() async {
///     // TODO: Implement push notification registration with Supabase Edge Functions
///     // or a dedicated push notification service
///   }
///
///   Future<void> sendTokenToBackend(String? token) async {
///     await dio.post('/api/notifications/register-device', data: {
///       'token': token,
///       'platform': Platform.isIOS ? 'ios' : 'android',
///     });
///   }
/// }
///
/// // Option 2: OneSignal (Third-party service)
/// import 'package:onesignal_flutter/onesignal_flutter.dart';
///
/// class NotificationService {
///   Future<void> initialize() async {
///     OneSignal.shared.setAppId("YOUR_ONESIGNAL_APP_ID");
///
///     // Handle notification opened
///     OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
///       // Navigate to relevant screen
///     });
///
///     // Handle in-app notifications
///     OneSignal.shared.setNotificationWillShowInForegroundHandler(
///       (OSNotificationReceivedEvent event) {
///         // Display notification
///         event.complete(event.notification);
///       },
///     );
///   }
/// }
///
/// // Option 3: Custom API with WebSocket for real-time
/// import 'package:socket_io_client/socket_io_client.dart' as IO;
///
/// class NotificationService {
///   late IO.Socket socket;
///
///   Future<void> connect() async {
///     socket = IO.io('https://api.example.com', <String, dynamic>{
///       'transports': ['websocket'],
///       'autoConnect': false,
///     });
///
///     socket.connect();
///
///     socket.on('notification', (data) {
///       final notification = NotificationModel.fromJson(data);
///       // Show in-app notification
///       showInAppNotification(notification);
///     });
///   }
///
///   void disconnect() {
///     socket.disconnect();
///   }
/// }
///
/// // Fetch notifications from API
/// import 'package:dio/dio.dart';
///
/// class NotificationRepository {
///   final Dio _dio;
///
///   Future<List<NotificationModel>> getNotifications({
///     bool? isRead,
///     String? type,
///     int page = 1,
///   }) async {
///     final response = await _dio.get('/api/notifications', queryParameters: {
///       'isRead': isRead,
///       'type': type,
///       'page': page,
///     });
///
///     return (response.data['notifications'] as List)
///         .map((json) => NotificationModel.fromJson(json))
///         .toList();
///   }
///
///   Future<void> markAsRead(String notificationId) async {
///     await _dio.post('/api/notifications/$notificationId/read');
///   }
///
///   Future<void> markAllAsRead() async {
///     await _dio.post('/api/notifications/read-all');
///   }
///
///   Future<void> deleteNotification(String notificationId) async {
///     await _dio.delete('/api/notifications/$notificationId');
///   }
/// }
/// ```

/// Notification Type Enum
enum NotificationType {
  general,
  course,
  application,
  payment,
  message,
  announcement,
  reminder,
  achievement,
}

/// Notification Model
class NotificationModel {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final String? imageUrl;
  final String? actionUrl;
  final Map<String, dynamic>? metadata;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.imageUrl,
    this.actionUrl,
    this.metadata,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      type: NotificationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => NotificationType.general,
      ),
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] ?? false,
      imageUrl: json['imageUrl'],
      actionUrl: json['actionUrl'],
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type.name,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'imageUrl': imageUrl,
      'actionUrl': actionUrl,
      'metadata': metadata,
    };
  }
}

/// Notification Card Widget
class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;
  final VoidCallback? onMarkAsRead;

  const NotificationCard({
    super.key,
    required this.notification,
    this.onTap,
    this.onDismiss,
    this.onMarkAsRead,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeAgo = _formatTimeAgo(notification.timestamp);

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppColors.error,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDismiss?.call(),
      child: Material(
        color: notification.isRead
            ? AppColors.surface
            : AppColors.primary.withValues(alpha: 0.05),
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.border, width: 1),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getTypeColor().withValues(alpha:0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getTypeIcon(),
                    color: _getTypeColor(),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: notification.isRead
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!notification.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(left: 8),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.message,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        timeAgo,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Actions
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, size: 20),
                  onSelected: (value) {
                    if (value == 'read') {
                      onMarkAsRead?.call();
                    } else if (value == 'delete') {
                      onDismiss?.call();
                    }
                  },
                  itemBuilder: (context) => [
                    if (!notification.isRead)
                      const PopupMenuItem(
                        value: 'read',
                        child: Row(
                          children: [
                            Icon(Icons.check, size: 20),
                            SizedBox(width: 12),
                            Text('Mark as read'),
                          ],
                        ),
                      ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 20, color: AppColors.error),
                          SizedBox(width: 12),
                          Text('Delete', style: TextStyle(color: AppColors.error)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }

  IconData _getTypeIcon() {
    switch (notification.type) {
      case NotificationType.course:
        return Icons.school;
      case NotificationType.application:
        return Icons.description;
      case NotificationType.payment:
        return Icons.payment;
      case NotificationType.message:
        return Icons.message;
      case NotificationType.announcement:
        return Icons.campaign;
      case NotificationType.reminder:
        return Icons.alarm;
      case NotificationType.achievement:
        return Icons.emoji_events;
      default:
        return Icons.notifications;
    }
  }

  Color _getTypeColor() {
    switch (notification.type) {
      case NotificationType.course:
        return AppColors.primary;
      case NotificationType.application:
        return AppColors.info;
      case NotificationType.payment:
        return AppColors.success;
      case NotificationType.message:
        return AppColors.primary;
      case NotificationType.announcement:
        return AppColors.warning;
      case NotificationType.reminder:
        return AppColors.error;
      case NotificationType.achievement:
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }
}

/// In-App Notification Banner
class InAppNotificationBanner extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const InAppNotificationBanner({
    super.key,
    required this.notification,
    this.onTap,
    this.onDismiss,
  });

  static void show({
    required BuildContext context,
    required NotificationModel notification,
    VoidCallback? onTap,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 8,
        left: 8,
        right: 8,
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 300),
            tween: Tween(begin: -100.0, end: 0.0),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, value),
                child: child,
              );
            },
            child: InAppNotificationBanner(
              notification: notification,
              onTap: () {
                entry.remove();
                onTap?.call();
              },
              onDismiss: () => entry.remove(),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);

    // Auto-dismiss after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (entry.mounted) {
        entry.remove();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getTypeColor().withValues(alpha:0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getTypeIcon(),
                color: _getTypeColor(),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    notification.message,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 20),
              onPressed: onDismiss,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTypeIcon() {
    switch (notification.type) {
      case NotificationType.course:
        return Icons.school;
      case NotificationType.application:
        return Icons.description;
      case NotificationType.payment:
        return Icons.payment;
      case NotificationType.message:
        return Icons.message;
      case NotificationType.announcement:
        return Icons.campaign;
      case NotificationType.reminder:
        return Icons.alarm;
      case NotificationType.achievement:
        return Icons.emoji_events;
      default:
        return Icons.notifications;
    }
  }

  Color _getTypeColor() {
    switch (notification.type) {
      case NotificationType.course:
        return AppColors.primary;
      case NotificationType.application:
        return AppColors.info;
      case NotificationType.payment:
        return AppColors.success;
      case NotificationType.message:
        return AppColors.primary;
      case NotificationType.announcement:
        return AppColors.warning;
      case NotificationType.reminder:
        return AppColors.error;
      case NotificationType.achievement:
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }
}

/// Notification Badge
class NotificationBadge extends StatelessWidget {
  final int count;
  final Widget child;
  final Color? badgeColor;

  const NotificationBadge({
    super.key,
    required this.count,
    required this.child,
    this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (count > 0)
          Positioned(
            right: -8,
            top: -8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: badgeColor ?? AppColors.error,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.background, width: 2),
              ),
              constraints: const BoxConstraints(
                minWidth: 20,
                minHeight: 20,
              ),
              child: Text(
                count > 99 ? '99+' : count.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

/// Empty Notifications State
class EmptyNotificationsState extends StatelessWidget {
  const EmptyNotificationsState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha:0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none,
                size: 60,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Notifications',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'You\'re all caught up! Check back later for new updates.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
