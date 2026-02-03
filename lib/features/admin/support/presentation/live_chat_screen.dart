import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n_extension.dart';
import '../../shared/widgets/admin_data_table.dart';
import '../../shared/providers/admin_live_chat_provider.dart';

/// Live Chat Screen - Manage escalated chat support queue
class LiveChatScreen extends ConsumerStatefulWidget {
  const LiveChatScreen({super.key});

  @override
  ConsumerState<LiveChatScreen> createState() => _LiveChatScreenState();
}

class _LiveChatScreenState extends ConsumerState<LiveChatScreen> {
  String _selectedStatus = '';
  String _selectedPriority = '';

  List<LiveChatQueueItem> _getFilteredItems(List<LiveChatQueueItem> items) {
    var filtered = items;

    if (_selectedStatus.isNotEmpty) {
      filtered = filtered.where((i) => i.status == _selectedStatus).toList();
    }
    if (_selectedPriority.isNotEmpty) {
      filtered = filtered.where((i) => i.priority == _selectedPriority).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(adminLiveChatProvider);
    final filteredItems = _getFilteredItems(chatState.queueItems);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        _buildStatsCards(chatState),
        const SizedBox(height: 24),
        if (chatState.error != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: AppColors.error, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      chatState.error!,
                      style: TextStyle(color: AppColors.error, fontSize: 13),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, size: 18),
                    onPressed: () => ref.read(adminLiveChatProvider.notifier).fetchQueue(),
                    tooltip: 'Retry',
                  ),
                ],
              ),
            ),
          ),
        if (chatState.error != null) const SizedBox(height: 24),
        _buildFiltersSection(),
        const SizedBox(height: 24),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: _buildDataTable(filteredItems, chatState.isLoading),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.chat, size: 32, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Text(
                    'Live Chat Support',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Manage escalated chat conversations and support queue',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              ref.read(adminLiveChatProvider.notifier).fetchQueue();
              ref.read(adminLiveChatProvider.notifier).fetchStats();
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(AdminLiveChatState chatState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(child: _buildStatCard('Pending Queue', '${chatState.pendingCount}', 'Awaiting assignment', Icons.pending, AppColors.warning)),
          const SizedBox(width: 16),
          Expanded(child: _buildStatCard('Assigned', '${chatState.assignedCount}', 'Assigned to agents', Icons.person, AppColors.primary)),
          const SizedBox(width: 16),
          Expanded(child: _buildStatCard('In Progress', '${chatState.inProgressCount}', 'Being handled', Icons.timelapse, AppColors.info)),
          const SizedBox(width: 16),
          Expanded(child: _buildStatCard('Total Conversations', '${chatState.totalConversations}', 'All time', Icons.forum, AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w500)),
              Icon(icon, size: 20, color: color.withValues(alpha: 0.6)),
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              items: const [
                DropdownMenuItem(value: '', child: Text('All Status')),
                DropdownMenuItem(value: 'pending', child: Text('Pending')),
                DropdownMenuItem(value: 'assigned', child: Text('Assigned')),
                DropdownMenuItem(value: 'in_progress', child: Text('In Progress')),
                DropdownMenuItem(value: 'resolved', child: Text('Resolved')),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _selectedStatus = value);
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedPriority,
              decoration: InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              items: const [
                DropdownMenuItem(value: '', child: Text('All Priorities')),
                DropdownMenuItem(value: 'urgent', child: Text('Urgent')),
                DropdownMenuItem(value: 'high', child: Text('High')),
                DropdownMenuItem(value: 'medium', child: Text('Medium')),
                DropdownMenuItem(value: 'low', child: Text('Low')),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _selectedPriority = value);
              },
            ),
          ),
          const SizedBox(width: 16),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget _buildDataTable(List<LiveChatQueueItem> items, bool isLoading) {
    return AdminDataTable<LiveChatQueueItem>(
      columns: [
        DataTableColumn(
          label: 'User',
          cellBuilder: (item) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(item.userName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              Text(item.userEmail, style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
            ],
          ),
        ),
        DataTableColumn(
          label: 'Summary',
          cellBuilder: (item) => SizedBox(
            width: 200,
            child: Text(
              item.summary,
              style: const TextStyle(fontSize: 13),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ),
        DataTableColumn(
          label: 'Priority',
          cellBuilder: (item) => _buildPriorityBadge(item.priority),
        ),
        DataTableColumn(
          label: 'Status',
          cellBuilder: (item) => _buildStatusBadge(item.status),
        ),
        DataTableColumn(
          label: 'Type',
          cellBuilder: (item) => Text(
            item.escalationType,
            style: const TextStyle(fontSize: 13),
          ),
        ),
        DataTableColumn(
          label: 'Wait Time',
          cellBuilder: (item) => Text(
            _formatWaitTime(item.createdAt),
            style: const TextStyle(fontSize: 13),
          ),
          sortable: true,
        ),
        DataTableColumn(
          label: 'Assigned',
          cellBuilder: (item) => Text(
            item.assignedToName ?? 'Unassigned',
            style: TextStyle(
              fontSize: 12,
              color: item.assignedToName == null ? AppColors.textSecondary : AppColors.textPrimary,
              fontStyle: item.assignedToName == null ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        ),
      ],
      data: items,
      isLoading: isLoading,
      rowActions: [
        DataTableAction(
          icon: Icons.person_add,
          tooltip: 'Assign to Self',
          color: AppColors.primary,
          onPressed: (item) => _assignToSelf(item),
        ),
        DataTableAction(
          icon: Icons.reply,
          tooltip: 'Reply',
          onPressed: (item) => _showReplyDialog(item),
        ),
        DataTableAction(
          icon: Icons.visibility,
          tooltip: 'View Conversation',
          onPressed: (item) => _showConversationDetails(item),
        ),
      ],
    );
  }

  Widget _buildPriorityBadge(String priority) {
    Color color;
    switch (priority.toLowerCase()) {
      case 'urgent':
        color = AppColors.error;
        break;
      case 'high':
        color = AppColors.warning;
        break;
      case 'medium':
        color = AppColors.info;
        break;
      default:
        color = AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        priority[0].toUpperCase() + priority.substring(1),
        style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String label;
    switch (status.toLowerCase()) {
      case 'pending':
        color = AppColors.warning;
        label = 'Pending';
        break;
      case 'assigned':
        color = AppColors.primary;
        label = 'Assigned';
        break;
      case 'in_progress':
        color = AppColors.info;
        label = 'In Progress';
        break;
      case 'resolved':
        color = AppColors.success;
        label = 'Resolved';
        break;
      default:
        color = AppColors.textSecondary;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500),
      ),
    );
  }

  String _formatWaitTime(DateTime createdAt) {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inDays > 0) return '${diff.inDays}d ${diff.inHours % 24}h';
    if (diff.inHours > 0) return '${diff.inHours}h ${diff.inMinutes % 60}m';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m';
    return 'Just now';
  }

  Future<void> _assignToSelf(LiveChatQueueItem item) async {
    final success = await ref.read(adminLiveChatProvider.notifier).assignToSelf(item.id);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Conversation assigned to you')),
      );
    }
  }

  void _showReplyDialog(LiveChatQueueItem item) {
    final replyController = TextEditingController();
    bool markResolved = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Reply to ${item.userName}'),
          content: SizedBox(
            width: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Summary: ${item.summary}',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: replyController,
                  decoration: const InputDecoration(
                    labelText: 'Your reply',
                    border: OutlineInputBorder(),
                    hintText: 'Type your response...',
                  ),
                  maxLines: 5,
                ),
                const SizedBox(height: 12),
                CheckboxListTile(
                  value: markResolved,
                  onChanged: (value) {
                    setDialogState(() => markResolved = value ?? false);
                  },
                  title: const Text('Mark as resolved'),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (replyController.text.trim().isEmpty) return;

                final success = await ref.read(adminLiveChatProvider.notifier).sendReply(
                  item.conversationId,
                  replyController.text.trim(),
                  resolve: markResolved,
                );

                if (success && context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(markResolved ? 'Reply sent and conversation resolved' : 'Reply sent')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
              ),
              child: const Text('Send Reply'),
            ),
          ],
        ),
      ),
    );
  }

  void _showConversationDetails(LiveChatQueueItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Conversation: ${item.userName}'),
        content: SizedBox(
          width: 450,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('Queue ID', item.id),
                _buildDetailRow('Conversation ID', item.conversationId),
                _buildDetailRow('User', item.userName),
                _buildDetailRow('Email', item.userEmail),
                _buildDetailRow('Summary', item.summary),
                _buildDetailRow('Priority', item.priority),
                _buildDetailRow('Status', item.status),
                _buildDetailRow('Escalation Type', item.escalationType),
                _buildDetailRow('Reason', item.reason),
                _buildDetailRow('Assigned To', item.assignedToName ?? 'Unassigned'),
                _buildDetailRow('Created', _formatDateTime(item.createdAt)),
                if (item.assignedAt != null)
                  _buildDetailRow('Assigned At', _formatDateTime(item.assignedAt!)),
                if (item.responseTimeSeconds != null)
                  _buildDetailRow('Response Time', '${item.responseTimeSeconds}s'),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          if (item.status == 'pending')
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                _assignToSelf(item);
              },
              icon: const Icon(Icons.person_add, size: 18),
              label: const Text('Assign to Self'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
              ),
            ),
        ],
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
            width: 130,
            child: Text(
              label,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
