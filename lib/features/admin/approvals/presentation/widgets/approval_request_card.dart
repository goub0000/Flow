import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/approval_models.dart';

/// Card widget for displaying an approval request in a list
class ApprovalRequestCard extends StatelessWidget {
  final ApprovalRequest request;
  final VoidCallback? onTap;

  const ApprovalRequestCard({
    super.key,
    required this.request,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM d, yyyy h:mm a');

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  // Request number
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      request.requestNumber,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildPriorityBadge(request.priority),
                  const Spacer(),
                  _buildStatusBadge(request.status),
                ],
              ),

              const SizedBox(height: 12),

              // Action type
              Text(
                _getActionDisplayName(request.actionType),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 4),

              // Target resource
              Row(
                children: [
                  Icon(
                    _getResourceIcon(request.targetResourceType),
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${request.targetResourceType.replaceAll('_', ' ')}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Justification preview
              Text(
                request.justification,
                style: theme.textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const Divider(height: 24),

              // Footer row
              Row(
                children: [
                  // Initiator
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: theme.colorScheme.primary,
                    child: Text(
                      (request.initiatorName ?? request.initiatedByRole)[0]
                          .toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.initiatorName ?? 'Unknown',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          request.initiatedByRole.replaceAll('_', ' '),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Approval level indicator
                  _buildApprovalLevelIndicator(
                    request.currentApprovalLevel,
                    request.requiredApprovalLevel,
                  ),

                  const SizedBox(width: 16),

                  // Date
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        dateFormat.format(request.createdAt),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.grey.shade500,
                        ),
                      ),
                      if (request.expiresAt != null)
                        Text(
                          _getExpiryText(request.expiresAt!),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: _isExpiringSoon(request.expiresAt!)
                                ? Colors.red
                                : Colors.grey.shade500,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(String priority) {
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
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.5)),
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

  Widget _buildStatusBadge(String status) {
    Color color;
    String displayStatus;
    IconData? icon;

    switch (status.toLowerCase()) {
      case 'draft':
        color = Colors.grey;
        displayStatus = 'Draft';
        icon = Icons.edit;
        break;
      case 'pending_review':
        color = Colors.orange;
        displayStatus = 'Pending';
        icon = Icons.pending;
        break;
      case 'under_review':
        color = Colors.blue;
        displayStatus = 'Under Review';
        icon = Icons.rate_review;
        break;
      case 'awaiting_info':
        color = Colors.amber;
        displayStatus = 'Info Needed';
        icon = Icons.info;
        break;
      case 'escalated':
        color = Colors.purple;
        displayStatus = 'Escalated';
        icon = Icons.arrow_upward;
        break;
      case 'approved':
        color = Colors.green;
        displayStatus = 'Approved';
        icon = Icons.check_circle;
        break;
      case 'denied':
        color = Colors.red;
        displayStatus = 'Denied';
        icon = Icons.cancel;
        break;
      case 'withdrawn':
        color = Colors.grey;
        displayStatus = 'Withdrawn';
        icon = Icons.undo;
        break;
      case 'expired':
        color = Colors.grey;
        displayStatus = 'Expired';
        icon = Icons.timer_off;
        break;
      case 'executed':
        color = Colors.teal;
        displayStatus = 'Executed';
        icon = Icons.done_all;
        break;
      case 'failed':
        color = Colors.red;
        displayStatus = 'Failed';
        icon = Icons.error;
        break;
      default:
        color = Colors.grey;
        displayStatus = status;
        icon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            displayStatus,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApprovalLevelIndicator(int current, int required) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        final level = index + 1;
        final isActive = level <= current;
        final isRequired = level <= required;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? Colors.green
                : isRequired
                    ? Colors.grey.shade300
                    : Colors.transparent,
            border: Border.all(
              color: isRequired ? Colors.grey.shade400 : Colors.transparent,
            ),
          ),
        );
      }),
    );
  }

  String _getActionDisplayName(String actionType) {
    return actionType
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  IconData _getResourceIcon(String resourceType) {
    switch (resourceType.toLowerCase()) {
      case 'user':
        return Icons.person;
      case 'content':
        return Icons.article;
      case 'program':
        return Icons.school;
      case 'institution':
        return Icons.business;
      case 'transaction':
        return Icons.payment;
      case 'notification':
        return Icons.notifications;
      case 'data':
        return Icons.storage;
      case 'system':
        return Icons.settings;
      default:
        return Icons.folder;
    }
  }

  String _getExpiryText(DateTime expiresAt) {
    final now = DateTime.now();
    final diff = expiresAt.difference(now);

    if (diff.isNegative) {
      return 'Expired';
    } else if (diff.inDays > 0) {
      return 'Expires in ${diff.inDays}d';
    } else if (diff.inHours > 0) {
      return 'Expires in ${diff.inHours}h';
    } else {
      return 'Expires in ${diff.inMinutes}m';
    }
  }

  bool _isExpiringSoon(DateTime expiresAt) {
    final now = DateTime.now();
    final diff = expiresAt.difference(now);
    return diff.inHours < 24;
  }
}
