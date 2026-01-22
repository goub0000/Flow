import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../models/approval_models.dart';
import '../../providers/approvals_provider.dart';

/// Screen displaying detailed view of an approval request
class ApprovalDetailScreen extends ConsumerStatefulWidget {
  final String requestId;

  const ApprovalDetailScreen({
    super.key,
    required this.requestId,
  });

  @override
  ConsumerState<ApprovalDetailScreen> createState() =>
      _ApprovalDetailScreenState();
}

class _ApprovalDetailScreenState extends ConsumerState<ApprovalDetailScreen> {
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(approvalDetailProvider.notifier).loadRequest(widget.requestId);
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(approvalDetailProvider);
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM d, yyyy h:mm a');

    return Scaffold(
      appBar: AppBar(
        title: Text(state.request?.requestNumber ?? 'Approval Request'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/admin/approvals'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref
                .read(approvalDetailProvider.notifier)
                .loadRequest(widget.requestId),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _buildBody(state, theme, dateFormat),
    );
  }

  Widget _buildBody(
      ApprovalDetailState state, ThemeData theme, DateFormat dateFormat) {
    if (state.isLoading && state.request == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.request == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text('Error: ${state.error}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref
                  .read(approvalDetailProvider.notifier)
                  .loadRequest(widget.requestId),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final request = state.request;
    if (request == null) {
      return const Center(child: Text('Request not found'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header card
          _buildHeaderCard(request, theme, dateFormat),
          const SizedBox(height: 16),

          // Details card
          _buildDetailsCard(request, theme, dateFormat),
          const SizedBox(height: 16),

          // Approval chain card
          _buildApprovalChainCard(request, theme),
          const SizedBox(height: 16),

          // Action buttons
          if (_canTakeAction(request)) _buildActionButtons(request, theme),
          const SizedBox(height: 16),

          // Comments section
          _buildCommentsSection(state, theme, dateFormat),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(
      ApprovalRequest request, ThemeData theme, DateFormat dateFormat) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
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
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _buildPriorityBadge(request.priority),
                const Spacer(),
                _buildStatusBadge(request.status),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _getActionDisplayName(request.actionType),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  _getResourceIcon(request.targetResourceType),
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 4),
                Text(
                  request.targetResourceType.replaceAll('_', ' '),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard(
      ApprovalRequest request, ThemeData theme, DateFormat dateFormat) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Details',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Initiated by',
                request.initiatorName ?? request.initiatedByRole),
            _buildDetailRow('Role', request.initiatedByRole.replaceAll('_', ' ')),
            _buildDetailRow(
                'Request Type', request.requestType.replaceAll('_', ' ')),
            _buildDetailRow('Created', dateFormat.format(request.createdAt)),
            if (request.expiresAt != null)
              _buildDetailRow('Expires', dateFormat.format(request.expiresAt!)),
            _buildDetailRow(
                'Approval Level', '${request.currentApprovalLevel} of ${request.requiredApprovalLevel}'),
            const Divider(height: 24),
            Text(
              'Justification',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(request.justification),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildApprovalChainCard(ApprovalRequest request, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Approval Chain',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(request.requiredApprovalLevel, (index) {
                final level = index + 1;
                final isCompleted = level < request.currentApprovalLevel;
                final isCurrent = level == request.currentApprovalLevel;

                return Row(
                  children: [
                    if (index > 0)
                      Container(
                        width: 40,
                        height: 2,
                        color: isCompleted ? Colors.green : Colors.grey.shade300,
                      ),
                    Column(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isCompleted
                                ? Colors.green
                                : isCurrent
                                    ? theme.colorScheme.primary
                                    : Colors.grey.shade300,
                          ),
                          child: Center(
                            child: isCompleted
                                ? const Icon(Icons.check,
                                    color: Colors.white, size: 20)
                                : Text(
                                    '$level',
                                    style: TextStyle(
                                      color: isCurrent
                                          ? Colors.white
                                          : Colors.grey.shade600,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getLevelName(level),
                          style: theme.textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(ApprovalRequest request, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actions',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                hintText: 'Add notes for your action...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: () => _handleApprove(request),
                  icon: const Icon(Icons.check),
                  label: const Text('Approve'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
                FilledButton.icon(
                  onPressed: () => _showDenyDialog(request),
                  icon: const Icon(Icons.close),
                  label: const Text('Deny'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => _showRequestInfoDialog(request),
                  icon: const Icon(Icons.info),
                  label: const Text('Request Info'),
                ),
                OutlinedButton.icon(
                  onPressed: () => _handleEscalate(request),
                  icon: const Icon(Icons.arrow_upward),
                  label: const Text('Escalate'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentsSection(
      ApprovalDetailState state, ThemeData theme, DateFormat dateFormat) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Comments',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Add comment input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _addComment,
                  icon: const Icon(Icons.send),
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Comments list
            if (state.comments.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No comments yet'),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.comments.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final comment = state.comments[index];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(comment.authorRole[0].toUpperCase()),
                    ),
                    title: Text(comment.authorRole.replaceAll('_', ' ')),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(comment.content),
                        const SizedBox(height: 4),
                        Text(
                          dateFormat.format(comment.createdAt),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                  );
                },
              ),
          ],
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
      case 'escalated':
        color = Colors.purple;
        displayStatus = 'Escalated';
        icon = Icons.arrow_upward;
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

  bool _canTakeAction(ApprovalRequest request) {
    return request.status == 'pending_review' ||
        request.status == 'under_review';
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

  String _getLevelName(int level) {
    switch (level) {
      case 1:
        return 'L1';
      case 2:
        return 'Regional';
      case 3:
        return 'Super';
      default:
        return 'L$level';
    }
  }

  void _handleApprove(ApprovalRequest request) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Approval'),
        content: const Text('Are you sure you want to approve this request?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Approve'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(approvalDetailProvider.notifier).approveRequest(
            request.id,
            notes: _notesController.text.isNotEmpty
                ? _notesController.text
                : null,
          );
      _notesController.clear();
    }
  }

  void _showDenyDialog(ApprovalRequest request) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deny Request'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please provide a reason for denial:'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              if (reasonController.text.isNotEmpty) {
                Navigator.pop(context);
                await ref.read(approvalDetailProvider.notifier).denyRequest(
                      request.id,
                      reason: reasonController.text,
                    );
              }
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Deny'),
          ),
        ],
      ),
    );
  }

  void _showRequestInfoDialog(ApprovalRequest request) {
    final questionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Request Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('What information do you need from the requester?'),
            const SizedBox(height: 16),
            TextField(
              controller: questionController,
              decoration: const InputDecoration(
                labelText: 'Question',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              if (questionController.text.isNotEmpty) {
                Navigator.pop(context);
                await ref.read(approvalDetailProvider.notifier).requestInfo(
                      request.id,
                      question: questionController.text,
                    );
              }
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _handleEscalate(ApprovalRequest request) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Escalate Request'),
        content: const Text(
            'Are you sure you want to escalate this request to a higher level?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Escalate'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(approvalDetailProvider.notifier).escalateRequest(
            request.id,
            reason: _notesController.text.isNotEmpty
                ? _notesController.text
                : 'Escalated for higher review',
          );
      _notesController.clear();
    }
  }

  void _addComment() async {
    if (_commentController.text.isEmpty) return;

    await ref.read(approvalDetailProvider.notifier).addComment(
          widget.requestId,
          content: _commentController.text,
        );
    _commentController.clear();
  }
}
