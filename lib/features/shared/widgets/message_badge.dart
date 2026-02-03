import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/l10n_extension.dart';
import '../providers/messaging_provider.dart';

/// Message icon with badge showing unread count
class MessageBadge extends ConsumerWidget {
  final Color? iconColor;
  final double iconSize;

  const MessageBadge({
    super.key,
    this.iconColor,
    this.iconSize = 24.0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCount = ref.watch(totalUnreadMessagesProvider);

    return IconButton(
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(
            Icons.message_outlined,
            color: iconColor ?? AppColors.textPrimary,
            size: iconSize,
          ),
          if (unreadCount > 0)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    width: 1.5,
                  ),
                ),
                constraints: const BoxConstraints(
                  minWidth: 18,
                  minHeight: 18,
                ),
                child: Center(
                  child: Text(
                    unreadCount > 99 ? '99+' : '$unreadCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
      onPressed: () {
        context.push('/messages');
      },
      tooltip: unreadCount > 0 ? context.l10n.messageBadgeUnread(unreadCount.toString()) : context.l10n.messageBadgeMessages,
    );
  }
}
