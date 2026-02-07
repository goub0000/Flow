import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/notification_provider.dart';
import '../../../core/models/notification_models.dart';
import '../../../core/l10n_extension.dart';

/// Notification bell icon with unread count badge
class NotificationBell extends ConsumerWidget {
  final VoidCallback? onPressed;
  final Color? color;
  final double? iconSize;

  const NotificationBell({
    super.key,
    this.onPressed,
    this.color,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCount = ref.watch(unreadNotificationCountProvider);
    final hasUnread = unreadCount > 0;

    return IconButton(
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(
            hasUnread ? Icons.notifications_active : Icons.notifications_outlined,
            color: color,
            size: iconSize,
          ),
          if (hasUnread)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(
                  minWidth: 18,
                  minHeight: 18,
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  unreadCount > 99 ? '99+' : unreadCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    height: 1.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
      onPressed: onPressed ?? () => _openNotificationCenter(context),
    );
  }

  void _openNotificationCenter(BuildContext context) {
    context.push('/notifications');
  }
}

/// Compact notification indicator (just the badge, no icon)
class NotificationBadge extends ConsumerWidget {
  const NotificationBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCount = ref.watch(unreadNotificationCountProvider);

    if (unreadCount == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        unreadCount > 99 ? '99+' : unreadCount.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Notification bell menu button (opens dropdown menu)
class NotificationBellMenu extends ConsumerWidget {
  const NotificationBellMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadNotifications = ref.watch(unreadNotificationsProvider);
    final hasUnread = unreadNotifications.isNotEmpty;

    return PopupMenuButton<String>(
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(
            hasUnread ? Icons.notifications_active : Icons.notifications_outlined,
          ),
          if (hasUnread)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    width: 1.5,
                  ),
                ),
              ),
            ),
        ],
      ),
      offset: const Offset(0, 50),
      itemBuilder: (context) {
        if (unreadNotifications.isEmpty) {
          return [
            PopupMenuItem<String>(
              enabled: false,
              child: SizedBox(
                width: 300,
                child: Column(
                  children: [
                    Icon(
                      Icons.notifications_none,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.swNotifBellNoNew,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            ),
            PopupMenuItem<String>(
              value: 'view_all',
              child: Center(child: Text(context.l10n.swNotifBellViewAll)),
            ),
          ];
        }

        final items = <PopupMenuEntry<String>>[
          // Header
          PopupMenuItem<String>(
            enabled: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.swNotifBellNotifications,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (unreadNotifications.length > 3)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${unreadNotifications.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const PopupMenuDivider(),
        ];

        // Show up to 5 unread notifications
        final displayNotifications = unreadNotifications.take(5).toList();

        for (final notification in displayNotifications) {
          items.add(
            PopupMenuItem<String>(
              value: 'notification_${notification.id}',
              child: SizedBox(
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.timeAgo,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        items.addAll([
          const PopupMenuDivider(),
          PopupMenuItem<String>(
            value: 'view_all',
            child: Center(
              child: Text(
                context.l10n.swNotifBellViewAll,
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ]);

        return items;
      },
      onSelected: (value) {
        if (value == 'view_all') {
          context.push('/notifications');
        } else if (value.startsWith('notification_')) {
          final notificationId = value.substring('notification_'.length);
          final notification = unreadNotifications.firstWhere(
            (n) => n.id == notificationId,
          );

          // Mark as read
          ref.read(notificationsProvider.notifier).markAsRead(notificationId);

          // Navigate if action URL is provided
          if (notification.actionUrl != null) {
            context.go(notification.actionUrl!);
          }
        }
      },
    );
  }
}

/// Floating notification snackbar (for new notifications)
class NotificationSnackbar extends ConsumerStatefulWidget {
  const NotificationSnackbar({super.key});

  @override
  ConsumerState<NotificationSnackbar> createState() =>
      _NotificationSnackbarState();
}

class _NotificationSnackbarState extends ConsumerState<NotificationSnackbar> {
  @override
  void initState() {
    super.initState();
    // TODO: Listen for new notifications and show snackbar
  }

  @override
  Widget build(BuildContext context) {
    // This is a placeholder - actual implementation would listen to real-time updates
    return const SizedBox.shrink();
  }
}
