import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n_extension.dart';
// AdminShell is now provided by ShellRoute in admin_routes.dart
import '../models/notification_model.dart';

/// Notifications Center Screen - Central hub for admin notifications
class NotificationsCenterScreen extends ConsumerStatefulWidget {
  const NotificationsCenterScreen({super.key});

  @override
  ConsumerState<NotificationsCenterScreen> createState() =>
      _NotificationsCenterScreenState();
}

class _NotificationsCenterScreenState
    extends ConsumerState<NotificationsCenterScreen> {
  NotificationType? _selectedType;
  NotificationPriority? _selectedPriority;
  bool _showUnreadOnly = false;

  @override
  Widget build(BuildContext context) {
    // Content is wrapped by AdminShell via ShellRoute
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notifications Center',
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Stay updated with system events and user activities',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _buildUnreadCounter(),
                        const SizedBox(width: 16),
                        OutlinedButton.icon(
                          onPressed: _handleMarkAllAsRead,
                          icon: const Icon(Icons.done_all, size: 20),
                          label: const Text('Mark All as Read'),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: _handleClearAll,
                          icon: const Icon(Icons.clear_all, size: 20),
                          label: const Text('Clear All'),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildFilters(),
              ],
            ),
          ),

          // Notifications List
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sidebar with notification types
                  _buildSidebar(),
                  const SizedBox(width: 24),

                  // Main notifications list
                  Expanded(
                    child: _buildNotificationsList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
    );
  }

  Widget _buildUnreadCounter() {
    final unreadCount = _getFilteredNotifications()
        .where((n) => !n.isRead)
        .length;

    if (unreadCount == 0) return const SizedBox();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$unreadCount unread',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Priority Filter
          _buildDropdownFilter(
            label: 'Priority',
            value: _selectedPriority,
            items: [
              const DropdownMenuItem(
                value: null,
                child: Text('All Priorities'),
              ),
              ...NotificationPriority.values.map(
                (priority) => DropdownMenuItem(
                  value: priority,
                  child: Text(priority.label),
                ),
              ),
            ],
            onChanged: (value) {
              setState(() => _selectedPriority = value);
            },
          ),
          const SizedBox(width: 16),

          // Show Unread Only Toggle
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: _showUnreadOnly,
                  onChanged: (value) {
                    setState(() => _showUnreadOnly = value ?? false);
                  },
                ),
                Text(
                  'Unread only',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownFilter<T>({
    required String label,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButton<T>(
            value: value,
            underline: const SizedBox(),
            items: items,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Notification Types',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Divider(height: 1, color: AppColors.border),
          _buildTypeOption(null, 'All Notifications', Icons.notifications),
          ...NotificationType.values.map((type) {
            final count = _getMockNotifications()
                .where((n) => n.type == type)
                .length;
            return _buildTypeOption(
              type,
              type.label,
              _getMockNotifications().firstWhere((n) => n.type == type).icon,
              count: count,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTypeOption(
    NotificationType? type,
    String label,
    IconData icon, {
    int? count,
  }) {
    final isSelected = _selectedType == type;

    return InkWell(
      onTap: () {
        setState(() => _selectedType = type);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.05)
              : Colors.transparent,
          border: Border(
            left: BorderSide(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            if (count != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : AppColors.textSecondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsList() {
    final notifications = _getFilteredNotifications();

    if (notifications.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: ListView.separated(
        itemCount: notifications.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: AppColors.border,
        ),
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return _buildNotificationItem(notification);
        },
      ),
    );
  }

  Widget _buildNotificationItem(AdminNotification notification) {
    return InkWell(
      onTap: () => _handleNotificationTap(notification),
      child: Container(
        padding: const EdgeInsets.all(20),
        color: notification.isRead
            ? Colors.transparent
            : AppColors.primary.withValues(alpha: 0.02),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: notification.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                notification.icon,
                color: notification.color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),

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
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      _buildPriorityBadge(notification.priority),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notification.message,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatTimestamp(notification.timestamp),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      _buildTypeBadge(notification.type),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // Actions
            Column(
              children: [
                if (!notification.isRead)
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                const SizedBox(height: 8),
                PopupMenuButton(
                  icon: Icon(
                    Icons.more_vert,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: () => _handleMarkAsRead(notification),
                      child: Row(
                        children: [
                          Icon(
                            notification.isRead
                                ? Icons.mark_email_unread
                                : Icons.mark_email_read,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            notification.isRead
                                ? 'Mark as Unread'
                                : 'Mark as Read',
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, size: 18),
                          SizedBox(width: 8),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(NotificationPriority priority) {
    if (priority == NotificationPriority.normal) {
      return const SizedBox();
    }

    Color color;
    switch (priority) {
      case NotificationPriority.critical:
        color = AppColors.error;
        break;
      case NotificationPriority.high:
        color = Colors.orange;
        break;
      default:
        color = AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        priority.label.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildTypeBadge(NotificationType type) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.textSecondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        type.label,
        style: TextStyle(
          fontSize: 11,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 80,
              color: AppColors.textSecondary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 24),
            Text(
              'No notifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You\'re all caught up!',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary.withValues(alpha: 0.7),
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

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, yyyy').format(timestamp);
    }
  }

  List<AdminNotification> _getFilteredNotifications() {
    var notifications = _getMockNotifications();

    // Filter by type
    if (_selectedType != null) {
      notifications = notifications
          .where((n) => n.type == _selectedType)
          .toList();
    }

    // Filter by priority
    if (_selectedPriority != null) {
      notifications = notifications
          .where((n) => n.priority == _selectedPriority)
          .toList();
    }

    // Filter by read status
    if (_showUnreadOnly) {
      notifications = notifications.where((n) => !n.isRead).toList();
    }

    // Sort by timestamp (newest first)
    notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return notifications;
  }

  void _handleNotificationTap(AdminNotification notification) {
    // Mark as read when tapped
    _handleMarkAsRead(notification);

    // Navigate to action URL if provided
    if (notification.actionUrl != null) {
      // TODO: Navigate to action URL
    }
  }

  void _handleMarkAsRead(AdminNotification notification) {
    setState(() {
      // In a real app, this would update the notification in the backend
    });
  }

  void _handleMarkAllAsRead() {
    setState(() {
      // In a real app, this would mark all as read in the backend
    });
  }

  void _handleClearAll() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Notifications'),
        content: const Text(
          'Are you sure you want to clear all notifications? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                // In a real app, this would clear all notifications
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  List<AdminNotification> _getMockNotifications() {
    return [
      AdminNotification(
        id: '1',
        title: 'New Student Registration',
        message:
            'John Doe has registered as a new student and requires verification.',
        type: NotificationType.userActivity,
        priority: NotificationPriority.normal,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isRead: false,
        actionUrl: '/admin/users/students/new',
      ),
      AdminNotification(
        id: '2',
        title: 'Security Alert',
        message:
            'Multiple failed login attempts detected from IP 192.168.1.100.',
        type: NotificationType.security,
        priority: NotificationPriority.critical,
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        isRead: false,
      ),
      AdminNotification(
        id: '3',
        title: 'Payment Received',
        message: 'Payment of \$500 received from Harvard University.',
        type: NotificationType.payment,
        priority: NotificationPriority.high,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: true,
      ),
      AdminNotification(
        id: '4',
        title: 'System Maintenance Scheduled',
        message:
            'System maintenance is scheduled for tomorrow at 2:00 AM EST.',
        type: NotificationType.systemAlert,
        priority: NotificationPriority.high,
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        isRead: false,
      ),
      AdminNotification(
        id: '5',
        title: 'New Support Ticket',
        message: 'User Sarah Connor has submitted a support ticket #12345.',
        type: NotificationType.support,
        priority: NotificationPriority.normal,
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        isRead: true,
      ),
      AdminNotification(
        id: '6',
        title: 'Content Report',
        message:
            'A course content has been flagged for review by multiple users.',
        type: NotificationType.content,
        priority: NotificationPriority.high,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: false,
      ),
      AdminNotification(
        id: '7',
        title: 'Institution Verification Pending',
        message: 'Stanford University requires verification approval.',
        type: NotificationType.userActivity,
        priority: NotificationPriority.normal,
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
        isRead: true,
      ),
      AdminNotification(
        id: '8',
        title: 'Backup Completed',
        message: 'Daily database backup completed successfully.',
        type: NotificationType.systemAlert,
        priority: NotificationPriority.low,
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        isRead: true,
      ),
      AdminNotification(
        id: '9',
        title: 'Unusual Activity Detected',
        message:
            'Unusual login pattern detected for admin account "admin@flow.com".',
        type: NotificationType.security,
        priority: NotificationPriority.critical,
        timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 5)),
        isRead: false,
      ),
      AdminNotification(
        id: '10',
        title: 'Monthly Report Available',
        message: 'Your monthly analytics report is ready for download.',
        type: NotificationType.general,
        priority: NotificationPriority.low,
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        isRead: true,
      ),
    ];
  }
}
