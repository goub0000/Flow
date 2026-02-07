import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/l10n_extension.dart';
import '../../../core/models/notification_models.dart';
import '../../../core/providers/notification_provider.dart';

/// Notification center screen - displays list of notifications
class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      // Load more when scrolled to 90%
      ref.read(notificationsProvider.notifier).loadMore();
    }
  }

  Future<void> _onRefresh() async {
    await ref.read(notificationsProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationsProvider);
    final notificationsByDate = ref.watch(notificationsByDateProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.sharedNotificationsTitle),
        actions: [
          // Mark all as read
          if (state.unreadCount > 0)
            TextButton(
              onPressed: () {
                ref.read(notificationsProvider.notifier).markAllAsRead();
              },
              child: Text(context.l10n.sharedNotificationsMarkAllRead),
            ),

          // Settings button
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings/notifications'),
          ),

          // Filter button
          IconButton(
            icon: Icon(
              state.currentFilter != null
                  ? Icons.filter_alt
                  : Icons.filter_alt_outlined,
            ),
            onPressed: () => _showFilterSheet(context),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          // Error state
          if (state.error != null && state.notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${state.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _onRefresh,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Empty state
          if (!state.isLoading && state.notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 100,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No notifications yet',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We\'ll notify you when something happens',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }

          // Loading state
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Notifications list
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _getItemCount(notificationsByDate, state),
              itemBuilder: (context, index) {
                return _buildListItem(
                  context,
                  index,
                  notificationsByDate,
                  state,
                );
              },
            ),
          );
        },
      ),
    );
  }

  int _getItemCount(
    Map<String, List<AppNotification>> notificationsByDate,
    NotificationsState state,
  ) {
    // Count: headers + notifications + loading indicator
    int count = 0;
    for (final entry in notificationsByDate.entries) {
      count++; // Header
      count += entry.value.length; // Notifications
    }
    if (state.isLoadingMore) count++; // Loading indicator
    return count;
  }

  Widget _buildListItem(
    BuildContext context,
    int index,
    Map<String, List<AppNotification>> notificationsByDate,
    NotificationsState state,
  ) {
    int currentIndex = 0;

    // Build list with headers
    for (final entry in notificationsByDate.entries) {
      // Date header
      if (currentIndex == index) {
        return _DateHeader(date: entry.key);
      }
      currentIndex++;

      // Notifications under this date
      for (final notification in entry.value) {
        if (currentIndex == index) {
          return _NotificationTile(
            notification: notification,
            onTap: () => _onNotificationTap(context, notification),
            onMarkAsRead: () => _markAsRead(notification.id),
            onMarkAsUnread: () => _markAsUnread(notification.id),
            onArchive: () => _archive(notification.id),
            onDelete: () => _delete(context, notification.id),
          );
        }
        currentIndex++;
      }
    }

    // Loading indicator at the end
    if (state.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return const SizedBox.shrink();
  }

  void _onNotificationTap(BuildContext context, AppNotification notification) {
    // Mark as read
    if (notification.isUnread) {
      _markAsRead(notification.id);
    }

    // Navigate to action URL if available
    if (notification.actionUrl != null) {
      context.go(notification.actionUrl!);
    }
  }

  void _markAsRead(String id) {
    ref.read(notificationsProvider.notifier).markAsRead(id);
  }

  void _markAsUnread(String id) {
    ref.read(notificationsProvider.notifier).markAsUnread(id);
  }

  void _archive(String id) {
    ref.read(notificationsProvider.notifier).archiveNotification(id);
  }

  void _delete(BuildContext context, String id) {
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
              Navigator.pop(context);
              ref.read(notificationsProvider.notifier).deleteNotification(id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const _NotificationFilterSheet(),
    );
  }
}

/// Date header for grouping notifications
class _DateHeader extends StatelessWidget {
  final String date;

  const _DateHeader({required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      child: Text(
        date,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
    );
  }
}

/// Individual notification tile
class _NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback? onTap;
  final VoidCallback? onMarkAsRead;
  final VoidCallback? onMarkAsUnread;
  final VoidCallback? onArchive;
  final VoidCallback? onDelete;

  const _NotificationTile({
    required this.notification,
    this.onTap,
    this.onMarkAsRead,
    this.onMarkAsUnread,
    this.onArchive,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getColorFromName(notification.type.colorName);
    final icon = _getIconFromName(notification.type.iconName);

    return Dismissible(
      key: Key(notification.id),
      background: Container(
        color: Colors.green,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(Icons.check, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // Swipe right: mark as read/unread
          if (notification.isUnread) {
            onMarkAsRead?.call();
          } else {
            onMarkAsUnread?.call();
          }
          return false; // Don't dismiss
        } else {
          // Swipe left: archive
          onArchive?.call();
          return true; // Dismiss
        }
      },
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: notification.isUnread
                ? color.withValues(alpha: 0.05)
                : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor,
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
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
                            style:
                                Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: notification.isUnread
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                          ),
                        ),
                        if (notification.isUnread)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.timeAgo,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.6),
                          ),
                    ),
                  ],
                ),
              ),

              // Actions menu
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'mark_read':
                      onMarkAsRead?.call();
                      break;
                    case 'mark_unread':
                      onMarkAsUnread?.call();
                      break;
                    case 'archive':
                      onArchive?.call();
                      break;
                    case 'delete':
                      onDelete?.call();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  if (notification.isUnread)
                    const PopupMenuItem(
                      value: 'mark_read',
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_outline, size: 20),
                          SizedBox(width: 8),
                          Text('Mark as read'),
                        ],
                      ),
                    )
                  else
                    const PopupMenuItem(
                      value: 'mark_unread',
                      child: Row(
                        children: [
                          Icon(Icons.radio_button_unchecked, size: 20),
                          SizedBox(width: 8),
                          Text('Mark as unread'),
                        ],
                      ),
                    ),
                  const PopupMenuItem(
                    value: 'archive',
                    child: Row(
                      children: [
                        Icon(Icons.archive_outlined, size: 20),
                        SizedBox(width: 8),
                        Text('Archive'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 20, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getColorFromName(String colorName) {
    switch (colorName) {
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'purple':
        return Colors.purple;
      case 'orange':
        return Colors.orange;
      case 'amber':
        return Colors.amber;
      case 'red':
        return Colors.red;
      case 'teal':
        return Colors.teal;
      case 'indigo':
        return Colors.indigo;
      case 'pink':
        return Colors.pink;
      case 'cyan':
        return Colors.cyan;
      default:
        return Colors.grey;
    }
  }

  IconData _getIconFromName(String iconName) {
    switch (iconName) {
      case 'school':
        return Icons.school;
      case 'grade':
        return Icons.grade;
      case 'message':
        return Icons.message;
      case 'event':
        return Icons.event;
      case 'alarm':
        return Icons.alarm;
      case 'emoji_events':
        return Icons.emoji_events;
      case 'lightbulb':
        return Icons.lightbulb;
      case 'campaign':
        return Icons.campaign;
      case 'comment':
        return Icons.comment;
      case 'alternate_email':
        return Icons.alternate_email;
      case 'event_available':
        return Icons.event_available;
      default:
        return Icons.notifications;
    }
  }
}

/// Filter sheet for notifications
class _NotificationFilterSheet extends ConsumerStatefulWidget {
  const _NotificationFilterSheet();

  @override
  ConsumerState<_NotificationFilterSheet> createState() =>
      _NotificationFilterSheetState();
}

class _NotificationFilterSheetState
    extends ConsumerState<_NotificationFilterSheet> {
  bool? _filterIsRead;
  List<NotificationType> _selectedTypes = [];

  @override
  void initState() {
    super.initState();
    final currentFilter = ref.read(notificationFilterProvider);
    _filterIsRead = currentFilter?.isRead;
    _selectedTypes = currentFilter?.types ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter Notifications',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _filterIsRead = null;
                    _selectedTypes = [];
                  });
                },
                child: const Text('Clear'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Read status filter
          Text(
            'Status',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          SegmentedButton<bool?>(
            segments: const [
              ButtonSegment(value: null, label: Text('All')),
              ButtonSegment(value: false, label: Text('Unread')),
              ButtonSegment(value: true, label: Text('Read')),
            ],
            selected: {_filterIsRead},
            onSelectionChanged: (Set<bool?> selected) {
              setState(() {
                _filterIsRead = selected.first;
              });
            },
          ),

          const SizedBox(height: 24),

          // Apply button
          ElevatedButton(
            onPressed: () {
              final filter = NotificationFilter(
                isRead: _filterIsRead,
                types: _selectedTypes.isNotEmpty ? _selectedTypes : null,
              );
              ref.read(applyNotificationFilterProvider)(filter);
              Navigator.pop(context);
            },
            child: const Text('Apply Filter'),
          ),
        ],
      ),
    );
  }
}
