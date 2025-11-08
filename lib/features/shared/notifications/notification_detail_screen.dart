import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/notification_widgets.dart' as notif_widgets;

/// Notification Detail Screen
///
/// Displays full details of a single notification including:
/// - Full message content
/// - Timestamp
/// - Associated metadata
/// - Related actions
///
/// Backend Integration TODO:
/// ```dart
/// // Fetch full notification details
/// import 'package:dio/dio.dart';
///
/// class NotificationDetailService {
///   final Dio _dio;
///
///   Future<NotificationDetailModel> getNotificationDetail(String id) async {
///     final response = await _dio.get('/api/notifications/$id');
///     return NotificationDetailModel.fromJson(response.data);
///   }
///
///   Future<void> performAction(String notificationId, String actionType) async {
///     await _dio.post('/api/notifications/$notificationId/action', data: {
///       'action': actionType,
///     });
///   }
///
///   // Track notification opened event
///   Future<void> trackOpened(String notificationId) async {
///     await _dio.post('/api/notifications/$notificationId/opened');
///   }
/// }
///
/// // Navigate based on notification type
/// void handleNotificationNavigation(BuildContext context, NotificationModel notification) {
///   switch (notification.type) {
///     case NotificationType.course:
///       if (notification.metadata?['courseId'] != null) {
///         context.push('/courses/${notification.metadata!['courseId']}');
///       }
///       break;
///     case NotificationType.application:
///       if (notification.metadata?['applicationId'] != null) {
///         context.push('/applications/${notification.metadata!['applicationId']}');
///       }
///       break;
///     case NotificationType.payment:
///       if (notification.metadata?['transactionId'] != null) {
///         context.push('/payments/${notification.metadata!['transactionId']}');
///       }
///       break;
///     case NotificationType.message:
///       if (notification.metadata?['conversationId'] != null) {
///         context.push('/messages/${notification.metadata!['conversationId']}');
///       }
///       break;
///     default:
///       // Show detail screen
///       break;
///   }
/// }
/// ```

class NotificationDetailScreen extends StatefulWidget {
  final notif_widgets.NotificationModel notification;

  const NotificationDetailScreen({
    super.key,
    required this.notification,
  });

  @override
  State<NotificationDetailScreen> createState() => _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> {
  late notif_widgets.NotificationModel _notification;

  @override
  void initState() {
    super.initState();
    _notification = widget.notification;
    _trackNotificationOpened();
  }

  Future<void> _trackNotificationOpened() async {
    // TODO: Track notification opened event in backend
    // await NotificationDetailService().trackOpened(_notification.id);
  }

  void _markAsRead() {
    if (!_notification.isRead) {
      setState(() {
        _notification = notif_widgets.NotificationModel(
          id: _notification.id,
          title: _notification.title,
          message: _notification.message,
          type: _notification.type,
          timestamp: _notification.timestamp,
          isRead: true,
          imageUrl: _notification.imageUrl,
          actionUrl: _notification.actionUrl,
          metadata: _notification.metadata,
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Marked as read'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _deleteNotification() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Notification'),
        content: const Text('Are you sure you want to delete this notification?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Delete notification from backend
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close detail screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notification deleted'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _performAction() {
    // TODO: Perform notification-specific action
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Action performed'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Details'),
        actions: [
          if (!_notification.isRead)
            IconButton(
              icon: const Icon(Icons.mark_email_read),
              tooltip: 'Mark as read',
              onPressed: _markAsRead,
            ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete',
            onPressed: _deleteNotification,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with type icon
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _getTypeColor().withValues(alpha: 0.1),
                border: Border(
                  bottom: BorderSide(color: AppColors.border),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: _getTypeColor().withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getTypeIcon(),
                      size: 40,
                      color: _getTypeColor(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _getTypeLabel(),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: _getTypeColor(),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          _notification.title,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (!_notification.isRead)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'NEW',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Timestamp
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatTimestamp(_notification.timestamp),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Message
                  Text(
                    _notification.message,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Image (if available)
                  if (_notification.imageUrl != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        _notification.imageUrl!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 200,
                            color: AppColors.surface,
                            child: const Center(
                              child: Icon(
                                Icons.broken_image,
                                size: 48,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Metadata (if available)
                  if (_notification.metadata != null &&
                      _notification.metadata!.isNotEmpty) ...[
                    const Divider(),
                    const SizedBox(height: 16),
                    Text(
                      'Additional Information',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._notification.metadata!.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 120,
                              child: Text(
                                '${_capitalizeFirst(entry.key)}:',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                entry.value.toString(),
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 24),
                  ],

                  // Action Button
                  if (_notification.actionUrl != null)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _performAction,
                        icon: const Icon(Icons.open_in_new),
                        label: Text(_getActionLabel()),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          backgroundColor: _getTypeColor(),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
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
    } else {
      // Show full date
      return '${timestamp.day}/${timestamp.month}/${timestamp.year} at ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  IconData _getTypeIcon() {
    switch (_notification.type) {
      case notif_widgets.NotificationType.course:
        return Icons.school;
      case notif_widgets.NotificationType.application:
        return Icons.description;
      case notif_widgets.NotificationType.payment:
        return Icons.payment;
      case notif_widgets.NotificationType.message:
        return Icons.message;
      case notif_widgets.NotificationType.announcement:
        return Icons.campaign;
      case notif_widgets.NotificationType.reminder:
        return Icons.alarm;
      case notif_widgets.NotificationType.achievement:
        return Icons.emoji_events;
      default:
        return Icons.notifications;
    }
  }

  Color _getTypeColor() {
    switch (_notification.type) {
      case notif_widgets.NotificationType.course:
        return AppColors.primary;
      case notif_widgets.NotificationType.application:
        return AppColors.info;
      case notif_widgets.NotificationType.payment:
        return AppColors.success;
      case notif_widgets.NotificationType.message:
        return AppColors.primary;
      case notif_widgets.NotificationType.announcement:
        return AppColors.warning;
      case notif_widgets.NotificationType.reminder:
        return AppColors.error;
      case notif_widgets.NotificationType.achievement:
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getTypeLabel() {
    switch (_notification.type) {
      case notif_widgets.NotificationType.course:
        return 'COURSE';
      case notif_widgets.NotificationType.application:
        return 'APPLICATION';
      case notif_widgets.NotificationType.payment:
        return 'PAYMENT';
      case notif_widgets.NotificationType.message:
        return 'MESSAGE';
      case notif_widgets.NotificationType.announcement:
        return 'ANNOUNCEMENT';
      case notif_widgets.NotificationType.reminder:
        return 'REMINDER';
      case notif_widgets.NotificationType.achievement:
        return 'ACHIEVEMENT';
      default:
        return 'NOTIFICATION';
    }
  }

  String _getActionLabel() {
    switch (_notification.type) {
      case notif_widgets.NotificationType.course:
        return 'View Course';
      case notif_widgets.NotificationType.application:
        return 'View Application';
      case notif_widgets.NotificationType.payment:
        return 'View Transaction';
      case notif_widgets.NotificationType.message:
        return 'Open Conversation';
      case notif_widgets.NotificationType.achievement:
        return 'View Achievement';
      default:
        return 'View Details';
    }
  }
}
