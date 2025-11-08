import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/notification_model.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/notification_widgets.dart' as notif_widgets;
import '../providers/notifications_provider.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedType;

  final List<String> _notificationTypes = [
    'All',
    'Courses',
    'Applications',
    'Payments',
    'Messages',
    'Announcements',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<NotificationModel> _filterNotifications(List<NotificationModel> notifications) {
    if (_selectedType == null || _selectedType == 'All') {
      return notifications;
    }
    return notifications.where((n) =>
      n.type.toLowerCase() == _selectedType!.toLowerCase().replaceAll('s', '')
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(notificationsLoadingProvider);
    final notifications = ref.watch(notificationsListProvider);
    final unreadNotifications = ref.watch(unreadNotificationsProvider);
    final error = ref.watch(notificationsErrorProvider);

    if (error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Notifications')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(error, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(notificationsProvider.notifier).fetchNotifications();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (notifications.isNotEmpty)
            TextButton(
              onPressed: () {
                ref.read(notificationsProvider.notifier).markAllAsRead();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All notifications marked as read')),
                );
              },
              child: const Text('Mark all read'),
            ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.push('/settings/notifications');
            },
            tooltip: 'Notification settings',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'All (${notifications.length})'),
            Tab(text: 'Unread (${unreadNotifications.length})'),
          ],
        ),
      ),
      body: isLoading
          ? const LoadingIndicator(message: 'Loading notifications...')
          : Column(
              children: [
                // Filter Chips
                Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _notificationTypes.length,
                    itemBuilder: (context, index) {
                      final type = _notificationTypes[index];
                      final isSelected = _selectedType == type ||
                          (_selectedType == null && type == 'All');

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(type),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedType = selected ? type : 'All';
                            });
                          },
                          selectedColor: AppColors.primary.withValues(alpha: 0.2),
                          checkmarkColor: AppColors.primary,
                        ),
                      );
                    },
                  ),
                ),
                const Divider(height: 1),

                // Tab Content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildNotificationsList(_filterNotifications(notifications)),
                      _buildNotificationsList(_filterNotifications(unreadNotifications)),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildNotificationsList(List<NotificationModel> notifications) {
    if (notifications.isEmpty) {
      return const notif_widgets.EmptyNotificationsState();
    }

    // Group notifications by date
    final groupedNotifications = _groupNotificationsByDate(notifications);

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(notificationsProvider.notifier).fetchNotifications();
      },
      child: ListView.builder(
        itemCount: groupedNotifications.length,
        itemBuilder: (context, index) {
          final group = groupedNotifications[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  group['date'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              // Notifications for this date
              ...(group['notifications'] as List<NotificationModel>).map((notification) {
                // Convert to new notification model format
                final newNotification = notif_widgets.NotificationModel(
                  id: notification.id,
                  title: notification.title,
                  message: notification.body,
                  type: _getNotificationType(notification.type),
                  timestamp: notification.createdAt,
                  isRead: notification.isRead,
                );

                return notif_widgets.NotificationCard(
                  notification: newNotification,
                  onTap: () {
                    ref.read(notificationsProvider.notifier).markAsRead(notification.id);
                    // TODO: Navigate based on notification type
                  },
                  onDismiss: () {
                    ref.read(notificationsProvider.notifier).deleteNotification(notification.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Notification deleted')),
                    );
                  },
                  onMarkAsRead: () {
                    ref.read(notificationsProvider.notifier).markAsRead(notification.id);
                  },
                );
              }),
            ],
          );
        },
      ),
    );
  }

  List<Map<String, dynamic>> _groupNotificationsByDate(List<NotificationModel> notifications) {
    final groups = <String, List<NotificationModel>>{};

    for (final notification in notifications) {
      final date = _getDateLabel(notification.createdAt);
      if (!groups.containsKey(date)) {
        groups[date] = [];
      }
      groups[date]!.add(notification);
    }

    return groups.entries.map((entry) {
      return {
        'date': entry.key,
        'notifications': entry.value,
      };
    }).toList();
  }

  String _getDateLabel(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final notificationDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (notificationDate == today) {
      return 'TODAY';
    } else if (notificationDate == yesterday) {
      return 'YESTERDAY';
    } else if (now.difference(notificationDate).inDays < 7) {
      return 'THIS WEEK';
    } else {
      return 'OLDER';
    }
  }

  notif_widgets.NotificationType _getNotificationType(String type) {
    switch (type.toLowerCase()) {
      case 'course':
        return notif_widgets.NotificationType.course;
      case 'application':
        return notif_widgets.NotificationType.application;
      case 'payment':
        return notif_widgets.NotificationType.payment;
      case 'message':
        return notif_widgets.NotificationType.message;
      case 'announcement':
        return notif_widgets.NotificationType.announcement;
      case 'reminder':
        return notif_widgets.NotificationType.reminder;
      case 'achievement':
        return notif_widgets.NotificationType.achievement;
      default:
        return notif_widgets.NotificationType.general;
    }
  }
}
