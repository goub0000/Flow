import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/admin_permissions.dart';
import '../../../../core/l10n_extension.dart';
import '../../shared/widgets/admin_data_table.dart';
import '../../shared/widgets/permission_guard.dart';
import '../../shared/providers/admin_support_provider.dart';

/// Support Tickets Screen - Manage user support tickets
class SupportTicketsScreen extends ConsumerStatefulWidget {
  const SupportTicketsScreen({super.key});

  @override
  ConsumerState<SupportTicketsScreen> createState() =>
      _SupportTicketsScreenState();
}

class _SupportTicketsScreenState extends ConsumerState<SupportTicketsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'all';
  String _selectedPriority = 'all';
  String _selectedCategory = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<SupportTicket> _getFilteredTickets(List<SupportTicket> tickets) {
    var filtered = tickets;

    if (_selectedStatus != 'all') {
      filtered = filtered.where((t) => t.status == _selectedStatus).toList();
    }
    if (_selectedPriority != 'all') {
      filtered = filtered.where((t) => t.priority == _selectedPriority).toList();
    }
    if (_selectedCategory != 'all') {
      filtered = filtered.where((t) => t.category == _selectedCategory).toList();
    }

    final query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      filtered = filtered.where((t) =>
        t.id.toLowerCase().contains(query) ||
        t.subject.toLowerCase().contains(query) ||
        t.userName.toLowerCase().contains(query) ||
        t.description.toLowerCase().contains(query)
      ).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  Widget _buildContent() {
    final supportState = ref.watch(adminSupportProvider);
    final stats = ref.watch(adminTicketStatisticsProvider);
    final avgResolution = ref.watch(adminAverageResolutionTimeProvider);
    final filteredTickets = _getFilteredTickets(supportState.tickets);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        _buildStatsCards(stats, avgResolution),
        const SizedBox(height: 24),
        if (supportState.error != null)
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
                      supportState.error!,
                      style: TextStyle(color: AppColors.error, fontSize: 13),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, size: 18),
                    onPressed: () => ref.read(adminSupportProvider.notifier).fetchTickets(),
                    tooltip: context.l10n.adminSupportTicketRetry,
                  ),
                ],
              ),
            ),
          ),
        if (supportState.error != null) const SizedBox(height: 24),
        _buildFiltersSection(),
        const SizedBox(height: 24),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: _buildDataTable(filteredTickets, supportState.isLoading),
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
                  Icon(
                    Icons.support_agent,
                    size: 32,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    context.l10n.adminSupportTicketTitle,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.adminSupportTicketSubtitle,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Row(
            children: [
              PermissionGuard(
                permission: AdminPermission.manageKnowledgeBase,
                child: OutlinedButton.icon(
                  onPressed: () {
                    context.go('/admin/knowledge-base');
                  },
                  icon: const Icon(Icons.menu_book, size: 20),
                  label: Text(context.l10n.adminSupportTicketKnowledgeBase),
                ),
              ),
              const SizedBox(width: 12),
              PermissionGuard(
                permission: AdminPermission.accessLiveChat,
                child: OutlinedButton.icon(
                  onPressed: () {
                    context.go('/admin/chat');
                  },
                  icon: const Icon(Icons.chat, size: 20),
                  label: Text(context.l10n.adminSupportTicketLiveChat),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () {
                  ref.read(adminSupportProvider.notifier).fetchTickets();
                },
                icon: const Icon(Icons.refresh),
                tooltip: context.l10n.adminSupportTicketRefresh,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(Map<String, int> stats, double avgResolution) {
    final resolvedCount = stats['resolved'] ?? 0;
    final avgHours = avgResolution.toStringAsFixed(1);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              context.l10n.adminSupportTicketOpenTickets,
              '${stats['open'] ?? 0}',
              context.l10n.adminSupportTicketPendingResolution,
              Icons.pending,
              AppColors.warning,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              context.l10n.adminSupportTicketInProgress,
              '${stats['inProgress'] ?? 0}',
              context.l10n.adminSupportTicketBeingHandled,
              Icons.timelapse,
              AppColors.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              context.l10n.adminSupportTicketResolved,
              '$resolvedCount',
              context.l10n.adminSupportTicketTotalResolved,
              Icons.check_circle,
              AppColors.success,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              context.l10n.adminSupportTicketAvgResponse,
              '${avgHours}h',
              context.l10n.adminSupportTicketAvgResolutionTime,
              Icons.access_time,
              AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
  ) {
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
              Text(
                title,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(icon, size: 20, color: color.withValues(alpha: 0.6)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
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
            flex: 2,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: context.l10n.adminSupportTicketSearchHint,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: InputDecoration(
                labelText: context.l10n.adminSupportTicketStatusLabel,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              items: [
                DropdownMenuItem(value: 'all', child: Text(context.l10n.adminSupportTicketAllStatus)),
                DropdownMenuItem(value: 'open', child: Text(context.l10n.adminSupportTicketStatusOpen)),
                DropdownMenuItem(value: 'in_progress', child: Text(context.l10n.adminSupportTicketStatusInProgress)),
                DropdownMenuItem(value: 'resolved', child: Text(context.l10n.adminSupportTicketStatusResolved)),
                DropdownMenuItem(value: 'closed', child: Text(context.l10n.adminSupportTicketStatusClosed)),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedStatus = value);
                }
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedPriority,
              decoration: InputDecoration(
                labelText: context.l10n.adminSupportTicketPriorityLabel,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              items: [
                DropdownMenuItem(value: 'all', child: Text(context.l10n.adminSupportTicketAllPriorities)),
                DropdownMenuItem(value: 'urgent', child: Text(context.l10n.adminSupportTicketPriorityUrgent)),
                DropdownMenuItem(value: 'high', child: Text(context.l10n.adminSupportTicketPriorityHigh)),
                DropdownMenuItem(value: 'medium', child: Text(context.l10n.adminSupportTicketPriorityMedium)),
                DropdownMenuItem(value: 'low', child: Text(context.l10n.adminSupportTicketPriorityLow)),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedPriority = value);
                }
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: context.l10n.adminSupportTicketCategoryLabel,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              items: [
                DropdownMenuItem(value: 'all', child: Text(context.l10n.adminSupportTicketAllCategories)),
                DropdownMenuItem(value: 'technical', child: Text(context.l10n.adminSupportTicketCategoryTechnical)),
                DropdownMenuItem(value: 'billing', child: Text(context.l10n.adminSupportTicketCategoryBilling)),
                DropdownMenuItem(value: 'account', child: Text(context.l10n.adminSupportTicketCategoryAccount)),
                DropdownMenuItem(value: 'general', child: Text(context.l10n.adminSupportTicketCategoryGeneral)),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCategory = value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _timeSince(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return context.l10n.adminSupportTicketDaysAgo(diff.inDays);
    if (diff.inHours > 0) return context.l10n.adminSupportTicketHoursAgo(diff.inHours);
    if (diff.inMinutes > 0) return context.l10n.adminSupportTicketMinutesAgo(diff.inMinutes);
    return context.l10n.adminSupportTicketJustNow;
  }

  Widget _buildDataTable(List<SupportTicket> tickets, bool isLoading) {
    return AdminDataTable<SupportTicket>(
      columns: [
        DataTableColumn(
          label: context.l10n.adminSupportTicketColumnTicketId,
          cellBuilder: (ticket) => Text(
            ticket.id,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              fontFamily: 'monospace',
            ),
          ),
          sortable: true,
        ),
        DataTableColumn(
          label: context.l10n.adminSupportTicketColumnSubject,
          cellBuilder: (ticket) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                ticket.subject,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                ticket.description,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
        DataTableColumn(
          label: context.l10n.adminSupportTicketColumnUser,
          cellBuilder: (ticket) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                ticket.userName,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              Text(
                ticket.userRole,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        DataTableColumn(
          label: context.l10n.adminSupportTicketColumnCategory,
          cellBuilder: (ticket) => Text(
            ticket.category,
            style: const TextStyle(fontSize: 13),
          ),
        ),
        DataTableColumn(
          label: context.l10n.adminSupportTicketColumnPriority,
          cellBuilder: (ticket) => _buildPriorityChip(ticket.priority),
        ),
        DataTableColumn(
          label: context.l10n.adminSupportTicketColumnStatus,
          cellBuilder: (ticket) => _buildStatusChip(ticket.status),
        ),
        DataTableColumn(
          label: context.l10n.adminSupportTicketColumnAssignedTo,
          cellBuilder: (ticket) => Text(
            ticket.assignedTo ?? 'Unassigned',
            style: TextStyle(
              fontSize: 12,
              color: ticket.assignedTo == null
                  ? AppColors.textSecondary
                  : AppColors.textPrimary,
              fontStyle:
                  ticket.assignedTo == null ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        ),
        DataTableColumn(
          label: 'Created',
          cellBuilder: (ticket) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatDate(ticket.createdAt),
                style: const TextStyle(fontSize: 13),
              ),
              Text(
                _timeSince(ticket.createdAt),
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          sortable: true,
        ),
      ],
      data: tickets,
      isLoading: isLoading,
      enableSelection: true,
      onSelectionChanged: (selectedItems) {
        // Handle bulk actions
      },
      onRowTap: (ticket) {
        _showTicketDetails(ticket);
      },
      rowActions: [
        DataTableAction(
          icon: Icons.visibility,
          tooltip: 'View Details',
          onPressed: (ticket) {
            _showTicketDetails(ticket);
          },
        ),
        DataTableAction(
          icon: Icons.reply,
          tooltip: 'Reply',
          onPressed: (ticket) {
            // TODO: Open reply dialog
          },
        ),
        DataTableAction(
          icon: Icons.person_add,
          tooltip: 'Assign',
          onPressed: (ticket) {
            _showAssignDialog(ticket);
          },
        ),
        DataTableAction(
          icon: Icons.check,
          tooltip: 'Resolve',
          color: AppColors.success,
          onPressed: (ticket) {
            _resolveTicket(ticket);
          },
        ),
      ],
    );
  }

  Widget _buildPriorityChip(String priority) {
    Color color;
    String label;

    switch (priority.toLowerCase()) {
      case 'urgent':
        color = AppColors.error;
        label = 'Urgent';
        break;
      case 'high':
        color = AppColors.warning;
        label = 'High';
        break;
      case 'medium':
        color = AppColors.primary;
        label = 'Medium';
        break;
      case 'low':
        color = AppColors.textSecondary;
        label = 'Low';
        break;
      default:
        color = AppColors.textSecondary;
        label = priority;
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
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String label;

    switch (status.toLowerCase()) {
      case 'open':
        color = AppColors.warning;
        label = 'Open';
        break;
      case 'in_progress':
        color = AppColors.primary;
        label = 'In Progress';
        break;
      case 'resolved':
        color = AppColors.success;
        label = 'Resolved';
        break;
      case 'closed':
        color = AppColors.textSecondary;
        label = 'Closed';
        break;
      default:
        color = AppColors.textSecondary;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showTicketDetails(SupportTicket ticket) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.confirmation_number, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Ticket ${ticket.id}',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 700,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ticket.subject,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                ticket.description,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailRow('User', ticket.userName),
              _buildDetailRow('Role', ticket.userRole),
              _buildDetailRow('Category', ticket.category),
              _buildDetailRow('Priority', ticket.priority),
              _buildDetailRow('Status', ticket.status),
              _buildDetailRow('Assigned To', ticket.assignedTo ?? 'Unassigned'),
              _buildDetailRow('Created', _formatDate(ticket.createdAt)),
              if (ticket.resolvedAt != null)
                _buildDetailRow('Resolved', _formatDate(ticket.resolvedAt!)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          PermissionGuard(
            permission: AdminPermission.manageTickets,
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Open reply dialog
              },
              child: const Text('Reply'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAssignDialog(SupportTicket ticket) {
    final agentController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.person_add, color: AppColors.primary),
            const SizedBox(width: 12),
            const Text('Assign Ticket'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Assign ticket ${ticket.id} to:'),
            const SizedBox(height: 16),
            TextField(
              controller: agentController,
              decoration: const InputDecoration(
                labelText: 'Agent ID or Name',
                hintText: 'Enter support agent ID...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final agentId = agentController.text.trim();
              if (agentId.isEmpty) return;
              Navigator.pop(dialogContext);
              final success = await ref
                  .read(adminSupportProvider.notifier)
                  .assignTicket(ticket.id, agentId);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success
                        ? 'Ticket assigned successfully'
                        : 'Failed to assign ticket'),
                    backgroundColor: success ? AppColors.success : AppColors.error,
                  ),
                );
              }
            },
            child: const Text('Assign'),
          ),
        ],
      ),
    );
  }

  void _resolveTicket(SupportTicket ticket) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.success),
            const SizedBox(width: 12),
            const Text('Resolve Ticket'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mark ticket ${ticket.id} as resolved?'),
            const SizedBox(height: 16),
            const TextField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Resolution Notes (Optional)',
                hintText: 'Add any resolution notes...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              final success = await ref
                  .read(adminSupportProvider.notifier)
                  .updateTicketStatus(ticket.id, 'resolved');
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success
                        ? 'Ticket resolved successfully'
                        : 'Failed to resolve ticket'),
                    backgroundColor: success ? AppColors.success : AppColors.error,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
            ),
            child: const Text('Resolve'),
          ),
        ],
      ),
    );
  }
}
