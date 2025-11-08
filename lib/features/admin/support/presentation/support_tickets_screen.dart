import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/admin_permissions.dart';
import '../../shared/widgets/admin_shell.dart';
import '../../shared/widgets/admin_data_table.dart';
import '../../shared/widgets/permission_guard.dart';

/// Support Tickets Screen - Manage user support tickets
///
/// Features:
/// - View all support tickets
/// - Assign tickets to support agents
/// - Update ticket status
/// - Reply to tickets
/// - Categorize tickets by type and priority
/// - Track resolution time
/// - Ticket escalation
/// - Knowledge base integration
class SupportTicketsScreen extends ConsumerStatefulWidget {
  const SupportTicketsScreen({super.key});

  @override
  ConsumerState<SupportTicketsScreen> createState() =>
      _SupportTicketsScreenState();
}

class _SupportTicketsScreenState extends ConsumerState<SupportTicketsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'open';
  String _selectedPriority = 'all';
  String _selectedCategory = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch tickets from backend
    // - API endpoint: GET /api/admin/support/tickets
    // - Support pagination, filtering, search
    // - Real-time updates for new tickets
    // - Include user information and ticket history

    return AdminShell(
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Page Header
        _buildHeader(),
        const SizedBox(height: 24),

        // Stats Cards
        _buildStatsCards(),
        const SizedBox(height: 24),

        // Filters and Search
        _buildFiltersSection(),
        const SizedBox(height: 24),

        // Data Table
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: _buildDataTable(),
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
                    'Support Tickets',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Manage and resolve user support requests',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Row(
            children: [
              // Knowledge Base button
              PermissionGuard(
                permission: AdminPermission.manageKnowledgeBase,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Navigate to knowledge base
                  },
                  icon: const Icon(Icons.menu_book, size: 20),
                  label: const Text('Knowledge Base'),
                ),
              ),
              const SizedBox(width: 12),
              // Live Chat button
              PermissionGuard(
                permission: AdminPermission.accessLiveChat,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Open live chat
                  },
                  icon: const Icon(Icons.chat, size: 20),
                  label: const Text('Live Chat'),
                ),
              ),
              const SizedBox(width: 12),
              // Refresh button
              IconButton(
                onPressed: () {
                  // TODO: Refresh tickets
                },
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh Tickets',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Open Tickets',
              '0',
              'Pending resolution',
              Icons.pending,
              AppColors.warning,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'In Progress',
              '0',
              'Being handled',
              Icons.timelapse,
              AppColors.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'Resolved',
              '0',
              'Last 7 days',
              Icons.check_circle,
              AppColors.success,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'Avg Response',
              '0h',
              'Average response time',
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
          // Search
          Expanded(
            flex: 2,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by ticket ID, user, or subject...',
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
                // TODO: Implement search
              },
            ),
          ),
          const SizedBox(width: 16),

          // Status Filter
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Status')),
                DropdownMenuItem(value: 'open', child: Text('Open')),
                DropdownMenuItem(value: 'in_progress', child: Text('In Progress')),
                DropdownMenuItem(value: 'resolved', child: Text('Resolved')),
                DropdownMenuItem(value: 'closed', child: Text('Closed')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedStatus = value);
                  // TODO: Apply filter and reload data
                }
              },
            ),
          ),
          const SizedBox(width: 16),

          // Priority Filter
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedPriority,
              decoration: InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Priorities')),
                DropdownMenuItem(value: 'urgent', child: Text('Urgent')),
                DropdownMenuItem(value: 'high', child: Text('High')),
                DropdownMenuItem(value: 'medium', child: Text('Medium')),
                DropdownMenuItem(value: 'low', child: Text('Low')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedPriority = value);
                  // TODO: Apply filter and reload data
                }
              },
            ),
          ),
          const SizedBox(width: 16),

          // Category Filter
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Categories')),
                DropdownMenuItem(value: 'technical', child: Text('Technical')),
                DropdownMenuItem(value: 'billing', child: Text('Billing')),
                DropdownMenuItem(value: 'account', child: Text('Account')),
                DropdownMenuItem(value: 'general', child: Text('General')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCategory = value);
                  // TODO: Apply filter and reload data
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    // TODO: Replace with actual data from backend
    final List<TicketRowData> tickets = [];

    return AdminDataTable<TicketRowData>(
      columns: [
        DataTableColumn(
          label: 'Ticket ID',
          cellBuilder: (ticket) => Text(
            ticket.ticketId,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              fontFamily: 'monospace',
            ),
          ),
          sortable: true,
        ),
        DataTableColumn(
          label: 'Subject',
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
                ticket.preview,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        DataTableColumn(
          label: 'User',
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
                ticket.userEmail,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        DataTableColumn(
          label: 'Category',
          cellBuilder: (ticket) => Text(
            ticket.category,
            style: const TextStyle(fontSize: 13),
          ),
        ),
        DataTableColumn(
          label: 'Priority',
          cellBuilder: (ticket) => _buildPriorityChip(ticket.priority),
        ),
        DataTableColumn(
          label: 'Status',
          cellBuilder: (ticket) => _buildStatusChip(ticket.status),
        ),
        DataTableColumn(
          label: 'Assigned To',
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
                ticket.createdDate,
                style: const TextStyle(fontSize: 13),
              ),
              Text(
                ticket.timeSince,
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
      isLoading: false,
      enableSelection: true,
      onSelectionChanged: (selectedItems) {
        // TODO: Handle bulk actions
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

  void _showTicketDetails(TicketRowData ticket) {
    // TODO: Implement detailed ticket view
    // - Full ticket history
    // - All messages/replies
    // - User information
    // - Ticket actions (assign, resolve, escalate)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.confirmation_number, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Ticket ${ticket.ticketId}',
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
              const SizedBox(height: 16),
              Text(
                'Full ticket details and conversation history will be available with backend integration.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
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

  void _showAssignDialog(TicketRowData ticket) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
            Text('Assign ticket ${ticket.ticketId} to:'),
            const SizedBox(height: 16),
            // TODO: Load list of support agents from backend
            const Text('Support agent selection will be available with backend integration.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Assign ticket
              Navigator.pop(context);
            },
            child: const Text('Assign'),
          ),
        ],
      ),
    );
  }

  void _resolveTicket(TicketRowData ticket) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
            Text('Mark ticket ${ticket.ticketId} as resolved?'),
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
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Resolve ticket
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Ticket will be resolved with backend integration'),
                  backgroundColor: AppColors.success,
                ),
              );
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

/// Temporary data model for table rows
/// TODO: Replace with actual Ticket model from backend
class TicketRowData {
  final String id;
  final String ticketId;
  final String subject;
  final String preview;
  final String userName;
  final String userEmail;
  final String category;
  final String priority;
  final String status;
  final String? assignedTo;
  final String createdDate;
  final String timeSince;

  TicketRowData({
    required this.id,
    required this.ticketId,
    required this.subject,
    required this.preview,
    required this.userName,
    required this.userEmail,
    required this.category,
    required this.priority,
    required this.status,
    this.assignedTo,
    required this.createdDate,
    required this.timeSince,
  });
}
