import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../core/l10n_extension.dart';
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
        title: Text(state.request?.requestNumber ?? context.l10n.adminApprovalRequest),
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
            tooltip: context.l10n.adminApprovalRefresh,
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
            Text(context.l10n.adminApprovalErrorWithMessage(state.error!)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref
                  .read(approvalDetailProvider.notifier)
                  .loadRequest(widget.requestId),
              child: Text(context.l10n.adminApprovalRetry),
            ),
          ],
        ),
      );
    }

    final request = state.request;
    if (request == null) {
      return Center(child: Text(context.l10n.adminApprovalRequestNotFound));
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
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
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
              context.l10n.adminApprovalDetails,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(context.l10n.adminApprovalInitiatedBy,
                request.initiatorName ?? request.initiatedByRole),
            _buildDetailRow(context.l10n.adminApprovalRole, request.initiatedByRole.replaceAll('_', ' ')),
            _buildDetailRow(
                context.l10n.adminApprovalRequestType, request.requestType.replaceAll('_', ' ')),
            _buildDetailRow(context.l10n.adminApprovalCreated, dateFormat.format(request.createdAt)),
            if (request.expiresAt != null)
              _buildDetailRow(context.l10n.adminApprovalExpiresLabel, dateFormat.format(request.expiresAt!)),
            _buildDetailRow(
                context.l10n.adminApprovalApprovalLevel, '${request.currentApprovalLevel} of ${request.requiredApprovalLevel}'),
            const Divider(height: 24),
            Text(
              context.l10n.adminApprovalJustification,
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
              context.l10n.adminApprovalChain,
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
              context.l10n.adminApprovalActions,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: context.l10n.adminApprovalNotesOptional,
                hintText: context.l10n.adminApprovalAddNotesHint,
                border: const OutlineInputBorder(),
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
                  label: Text(context.l10n.adminApprovalApprove),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
                FilledButton.icon(
                  onPressed: () => _showDenyDialog(request),
                  icon: const Icon(Icons.close),
                  label: Text(context.l10n.adminApprovalDeny),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => _showRequestInfoDialog(request),
                  icon: const Icon(Icons.info),
                  label: Text(context.l10n.adminApprovalRequestInfo),
                ),
                OutlinedButton.icon(
                  onPressed: () => _handleEscalate(request),
                  icon: const Icon(Icons.arrow_upward),
                  label: Text(context.l10n.adminApprovalEscalate),
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
              context.l10n.adminApprovalComments,
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
                    decoration: InputDecoration(
                      hintText: context.l10n.adminApprovalAddCommentHint,
                      border: const OutlineInputBorder(),
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
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(context.l10n.adminApprovalNoCommentsYet),
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

  Widget _buildStatusBadge(String status) {
    Color color;
    String displayStatus;
    IconData? icon;

    switch (status.toLowerCase()) {
      case 'pending_review':
        color = Colors.orange;
        displayStatus = context.l10n.adminApprovalStatusPending;
        icon = Icons.pending;
        break;
      case 'under_review':
        color = Colors.blue;
        displayStatus = context.l10n.adminApprovalUnderReview;
        icon = Icons.rate_review;
        break;
      case 'approved':
        color = Colors.green;
        displayStatus = context.l10n.adminApprovalApproved;
        icon = Icons.check_circle;
        break;
      case 'denied':
        color = Colors.red;
        displayStatus = context.l10n.adminApprovalDenied;
        icon = Icons.cancel;
        break;
      case 'escalated':
        color = Colors.purple;
        displayStatus = context.l10n.adminApprovalEscalated;
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
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
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
        return context.l10n.adminApprovalLevelRegional;
      case 3:
        return context.l10n.adminApprovalLevelSuper;
      default:
        return 'L$level';
    }
  }

  void _handleApprove(ApprovalRequest request) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.adminApprovalConfirmApproval),
        content: Text(context.l10n.adminApprovalConfirmApproveMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.adminApprovalCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.adminApprovalApprove),
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
        title: Text(context.l10n.adminApprovalDenyRequest),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(context.l10n.adminApprovalProvideReasonDenial),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: InputDecoration(
                labelText: context.l10n.adminApprovalReason,
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.adminApprovalCancel),
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
            child: Text(context.l10n.adminApprovalDeny),
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
        title: Text(context.l10n.adminApprovalRequestInformation),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(context.l10n.adminApprovalWhatInfoNeeded),
            const SizedBox(height: 16),
            TextField(
              controller: questionController,
              decoration: InputDecoration(
                labelText: context.l10n.adminApprovalQuestion,
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.adminApprovalCancel),
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
            child: Text(context.l10n.adminApprovalSend),
          ),
        ],
      ),
    );
  }

  void _handleEscalate(ApprovalRequest request) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.adminApprovalEscalateRequest),
        content: Text(context.l10n.adminApprovalConfirmEscalateMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.adminApprovalCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.adminApprovalEscalate),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(approvalDetailProvider.notifier).escalateRequest(
            request.id,
            reason: _notesController.text.isNotEmpty
                ? _notesController.text
                : context.l10n.adminApprovalEscalatedForReview,
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
