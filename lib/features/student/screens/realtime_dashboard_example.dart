/// Real-Time Dashboard Example
/// Shows how to integrate all real-time features in a student dashboard

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/student_applications_realtime_provider.dart';
import '../../shared/providers/notifications_realtime_provider.dart';
import '../../shared/widgets/connection_status_indicator.dart';
import '../../../core/models/application_model.dart';
import '../../../core/models/notification_model.dart';

/// Example dashboard screen with full real-time integration
class RealtimeDashboardExample extends ConsumerStatefulWidget {
  const RealtimeDashboardExample({Key? key}) : super(key: key);

  @override
  ConsumerState<RealtimeDashboardExample> createState() => _RealtimeDashboardExampleState();
}

class _RealtimeDashboardExampleState extends ConsumerState<RealtimeDashboardExample> {
  @override
  void initState() {
    super.initState();
    // Initialize real-time subscriptions on mount
    Future.microtask(() {
      ref.read(studentApplicationsRealtimeProvider.notifier);
      ref.read(notificationsRealtimeProvider.notifier);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Real-Time Dashboard'),
        actions: [
          // Connection status in app bar
          const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: ConnectionStatusIndicator(showInAppBar: true),
          ),
          // Notification bell with badge
          _NotificationBell(),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: CustomScrollView(
          slivers: [
            // Connection banner
            SliverToBoxAdapter(
              child: _ConnectionBanner(),
            ),
            // Statistics cards
            SliverToBoxAdapter(
              child: _StatisticsCards(),
            ),
            // Applications list with real-time updates
            SliverToBoxAdapter(
              child: _ApplicationsList(),
            ),
            // Recent notifications
            SliverToBoxAdapter(
              child: _RecentNotifications(),
            ),
          ],
        ),
      ),
      // Floating action button with connection dot
      floatingActionButton: Stack(
        alignment: Alignment.topRight,
        children: [
          FloatingActionButton(
            onPressed: _handleNewApplication,
            child: const Icon(Icons.add),
          ),
          const Positioned(
            top: 0,
            right: 0,
            child: ConnectionDotIndicator(size: 12),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRefresh() async {
    // Manual refresh both applications and notifications
    await Future.wait([
      ref.read(studentApplicationsRealtimeProvider.notifier).refresh(),
      ref.read(notificationsRealtimeProvider.notifier).refresh(),
    ]);
  }

  void _handleNewApplication() {
    // Navigate to new application screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to new application screen')),
    );
  }
}

/// Connection banner widget
class _ConnectionBanner extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(applicationsRealtimeConnectedProvider);
    final lastUpdate = ref.watch(applicationsLastUpdateProvider);

    if (isConnected) {
      return const SizedBox.shrink();
    }

    return Container(
      color: Colors.orange.withOpacity(0.1),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.orange, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Working offline',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                if (lastUpdate != null)
                  Text(
                    'Last updated: ${_formatTime(lastUpdate)}',
                    style: const TextStyle(fontSize: 12),
                  ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              ref.read(studentApplicationsRealtimeProvider.notifier).refresh();
            },
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    return '${diff.inDays} days ago';
  }
}

/// Statistics cards showing real-time counts
class _StatisticsCards extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statistics = ref.watch(applicationsRealtimeStatisticsProvider);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Application Statistics',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.5,
            children: [
              _StatCard(
                title: 'Total',
                count: statistics['total'] ?? 0,
                color: Colors.blue,
                icon: Icons.folder_outlined,
              ),
              _StatCard(
                title: 'Pending',
                count: statistics['pending'] ?? 0,
                color: Colors.orange,
                icon: Icons.schedule,
              ),
              _StatCard(
                title: 'Accepted',
                count: statistics['accepted'] ?? 0,
                color: Colors.green,
                icon: Icons.check_circle_outline,
              ),
              _StatCard(
                title: 'Under Review',
                count: statistics['under_review'] ?? 0,
                color: Colors.purple,
                icon: Icons.rate_review,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Individual statistics card
class _StatCard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.count,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    count.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
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
}

/// Applications list with real-time updates
class _ApplicationsList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicationsState = ref.watch(studentApplicationsRealtimeProvider);
    final applications = applicationsState.applications;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Applications',
                style: theme.textTheme.headlineSmall,
              ),
              if (applicationsState.isLoading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (applications.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Text('No applications yet'),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: applications.length,
              itemBuilder: (context, index) {
                final application = applications[index];
                return _ApplicationCard(application: application);
              },
            ),
        ],
      ),
    );
  }
}

/// Individual application card
class _ApplicationCard extends ConsumerWidget {
  final Application application;

  const _ApplicationCard({required this.application});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(application.status).withOpacity(0.1),
          child: Icon(
            _getStatusIcon(application.status),
            color: _getStatusColor(application.status),
          ),
        ),
        title: Text(application.institutionName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(application.programName),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getStatusColor(application.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    application.status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      color: _getStatusColor(application.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (application.lastUpdate != null)
                  Text(
                    'Updated ${_formatTime(application.lastUpdate!)}',
                    style: const TextStyle(fontSize: 11),
                  ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleApplicationAction(ref, value, application),
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'view', child: Text('View Details')),
            if (application.isPending)
              const PopupMenuItem(value: 'withdraw', child: Text('Withdraw')),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      case 'under_review':
        return Colors.blue;
      case 'withdrawn':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Icons.check_circle;
      case 'pending':
        return Icons.schedule;
      case 'rejected':
        return Icons.cancel;
      case 'under_review':
        return Icons.rate_review;
      case 'withdrawn':
        return Icons.remove_circle;
      default:
        return Icons.help_outline;
    }
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  void _handleApplicationAction(WidgetRef ref, String action, Application application) {
    // Handle application actions
    switch (action) {
      case 'view':
        // Navigate to details
        break;
      case 'withdraw':
        // Withdraw application with optimistic update
        ref.read(studentApplicationsRealtimeProvider.notifier)
            .updateApplicationStatus(application.id, 'withdrawn');
        break;
    }
  }
}

/// Recent notifications widget
class _RecentNotifications extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(realtimeNotificationsListProvider);
    final hasNew = ref.watch(hasNewNotificationProvider);
    final theme = Theme.of(context);

    final recentNotifications = notifications.take(5).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Notifications',
                style: theme.textTheme.headlineSmall,
              ),
              if (hasNew)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
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
          const SizedBox(height: 12),
          if (recentNotifications.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Text('No notifications'),
                ),
              ),
            )
          else
            ...recentNotifications.map((notification) =>
                _NotificationTile(notification: notification)),
        ],
      ),
    );
  }
}

/// Individual notification tile
class _NotificationTile extends ConsumerWidget {
  final NotificationModel notification;

  const _NotificationTile({required this.notification});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: notification.isRead ? null : Colors.blue.withOpacity(0.05),
      child: ListTile(
        leading: Icon(
          _getNotificationIcon(notification.type),
          color: _getNotificationColor(notification.type),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Text(notification.message),
        trailing: !notification.isRead
            ? IconButton(
                icon: const Icon(Icons.mark_email_read, size: 20),
                onPressed: () {
                  ref.read(notificationsRealtimeProvider.notifier)
                      .markAsRead(notification.id);
                },
              )
            : null,
        onTap: () {
          if (!notification.isRead) {
            ref.read(notificationsRealtimeProvider.notifier)
                .markAsRead(notification.id);
          }
          // Navigate to relevant screen based on notification type
        },
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'acceptance':
        return Icons.celebration;
      case 'rejection':
        return Icons.cancel;
      case 'status_update':
        return Icons.update;
      case 'deadline':
        return Icons.schedule;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'acceptance':
        return Colors.green;
      case 'rejection':
        return Colors.red;
      case 'status_update':
        return Colors.blue;
      case 'deadline':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

/// Notification bell with badge
class _NotificationBell extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCount = ref.watch(realtimeUnreadNotificationsCountProvider);

    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            // Navigate to notifications screen
          },
        ),
        if (unreadCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                unreadCount > 99 ? '99+' : unreadCount.toString(),
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