import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/l10n_extension.dart';
import '../../models/approval_models.dart';

/// Card widget for displaying pending approval items
class PendingApprovalsCard extends StatelessWidget {
  final String title;
  final List<PendingApprovalItem> items;
  final IconData icon;
  final Color color;
  final void Function(PendingApprovalItem) onTap;
  final int maxItems;

  const PendingApprovalsCard({
    super.key,
    required this.title,
    required this.items,
    required this.icon,
    required this.color,
    required this.onTap,
    this.maxItems = 5,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayItems = items.take(maxItems).toList();

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    items.length.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Items
          if (displayItems.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(context.l10n.adminApprovalNoItems),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: displayItems.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = displayItems[index];
                return _PendingItemTile(
                  item: item,
                  onTap: () => onTap(item),
                );
              },
            ),

          // View all link
          if (items.length > maxItems)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Center(
                child: TextButton(
                  onPressed: () {
                    // Navigate to filtered list
                  },
                  child: Text(context.l10n.adminApprovalViewAllItems(items.length)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PendingItemTile extends StatelessWidget {
  final PendingApprovalItem item;
  final VoidCallback onTap;

  const _PendingItemTile({
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM d, h:mm a');

    return ListTile(
      onTap: onTap,
      title: Row(
        children: [
          Text(
            item.requestNumber,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          _PriorityBadge(priority: item.priority),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            _getActionDisplayName(item.actionType),
            style: theme.textTheme.bodySmall,
          ),
          if (item.initiatorName != null)
            Text(
              context.l10n.adminApprovalByName(item.initiatorName!),
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          Text(
            dateFormat.format(item.createdAt),
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _StatusBadge(status: item.status),
          if (item.expiresAt != null) ...[
            const SizedBox(height: 4),
            Text(
              _getExpiryText(context, item.expiresAt!),
              style: theme.textTheme.labelSmall?.copyWith(
                color: _isExpiringSoon(item.expiresAt!)
                    ? Colors.red
                    : Colors.grey.shade500,
              ),
            ),
          ],
        ],
      ),
      isThreeLine: true,
    );
  }

  String _getActionDisplayName(String actionType) {
    return actionType
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String _getExpiryText(BuildContext context, DateTime expiresAt) {
    final now = DateTime.now();
    final diff = expiresAt.difference(now);

    if (diff.isNegative) {
      return context.l10n.adminApprovalExpired;
    } else if (diff.inDays > 0) {
      return context.l10n.adminApprovalExpiresInDays(diff.inDays);
    } else if (diff.inHours > 0) {
      return context.l10n.adminApprovalExpiresInHours(diff.inHours);
    } else {
      return context.l10n.adminApprovalExpiresInMinutes(diff.inMinutes);
    }
  }

  bool _isExpiringSoon(DateTime expiresAt) {
    final now = DateTime.now();
    final diff = expiresAt.difference(now);
    return diff.inHours < 24;
  }
}

class _PriorityBadge extends StatelessWidget {
  final String priority;

  const _PriorityBadge({required this.priority});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (priority.toLowerCase()) {
      case 'urgent':
        color = Colors.red;
        break;
      case 'high':
        color = Colors.orange;
        break;
      case 'low':
        color = Colors.grey;
        break;
      default:
        color = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        priority.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String displayStatus;

    switch (status.toLowerCase()) {
      case 'pending_review':
        color = Colors.orange;
        displayStatus = context.l10n.adminApprovalStatusPending;
        break;
      case 'under_review':
        color = Colors.blue;
        displayStatus = context.l10n.adminApprovalStatusReviewing;
        break;
      case 'awaiting_info':
        color = Colors.amber;
        displayStatus = context.l10n.adminApprovalStatusInfoNeeded;
        break;
      case 'escalated':
        color = Colors.purple;
        displayStatus = context.l10n.adminApprovalStatusEscalated;
        break;
      case 'approved':
        color = Colors.green;
        displayStatus = context.l10n.adminApprovalStatusApprovedLabel;
        break;
      case 'denied':
        color = Colors.red;
        displayStatus = context.l10n.adminApprovalStatusDeniedLabel;
        break;
      default:
        color = Colors.grey;
        displayStatus = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        displayStatus,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}
