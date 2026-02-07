// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/admin_permissions.dart';
import '../../../../core/l10n_extension.dart';
// AdminShell is now provided by ShellRoute in admin_routes.dart
import '../../shared/widgets/admin_data_table.dart';
import '../../shared/widgets/permission_guard.dart';

/// Audit Log Screen - View and filter system audit logs
///
/// Features:
/// - View all administrative activities
/// - Filter by user, action type, date range
/// - Search audit logs
/// - Export audit reports
/// - Real-time log monitoring
class AuditLogScreen extends ConsumerStatefulWidget {
  const AuditLogScreen({super.key});

  @override
  ConsumerState<AuditLogScreen> createState() => _AuditLogScreenState();
}

class _AuditLogScreenState extends ConsumerState<AuditLogScreen> {
  // TODO: Replace with actual state management
  final TextEditingController _searchController = TextEditingController();
  String _selectedAction = 'all';
  String _selectedDateRange = 'today';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch audit logs from backend
    // - API endpoint: GET /api/admin/system/audit-logs
    // - Support pagination, filtering, search
    // - Real-time updates via WebSocket or polling
    // - Include: user info, action type, timestamp, IP address, details

    // Content is wrapped by AdminShell via ShellRoute
    return _buildContent();
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Page Header
        _buildHeader(),
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
                    Icons.security,
                    size: 32,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    context.l10n.adminAuditTitle,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.adminAuditSubtitle,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Row(
            children: [
              // Refresh button
              IconButton(
                onPressed: () {
                  // TODO: Refresh audit logs
                },
                icon: const Icon(Icons.refresh),
                tooltip: context.l10n.adminAuditRefreshLogs,
              ),
              const SizedBox(width: 8),
              // Export button (requires permission)
              PermissionGuard(
                permission: AdminPermission.exportAuditLogs,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Implement export functionality
                    // - Generate CSV/PDF report
                    // - Include filtered data
                    // - Trigger download
                  },
                  icon: const Icon(Icons.download, size: 20),
                  label: Text(context.l10n.adminAuditExportReport),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            children: [
              // Search
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: context.l10n.adminAuditSearchHint,
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
                    // - Debounce input
                    // - Call API with search query
                    // - Update results
                  },
                ),
              ),
              const SizedBox(width: 16),

              // Action Filter
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedAction,
                  decoration: InputDecoration(
                    labelText: context.l10n.adminAuditActionType,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  items: [
                    DropdownMenuItem(value: 'all', child: Text(context.l10n.adminAuditAllActions)),
                    DropdownMenuItem(value: 'login', child: Text(context.l10n.adminAuditLogin)),
                    DropdownMenuItem(value: 'logout', child: Text(context.l10n.adminAuditLogout)),
                    DropdownMenuItem(
                        value: 'create', child: Text(context.l10n.adminAuditCreateRecord)),
                    DropdownMenuItem(
                        value: 'update', child: Text(context.l10n.adminAuditUpdateRecord)),
                    DropdownMenuItem(
                        value: 'delete', child: Text(context.l10n.adminAuditDeleteRecord)),
                    DropdownMenuItem(
                        value: 'export', child: Text(context.l10n.adminAuditExportData)),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedAction = value);
                      // TODO: Apply filter and reload data
                    }
                  },
                ),
              ),
              const SizedBox(width: 16),

              // Date Range Filter
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedDateRange,
                  decoration: InputDecoration(
                    labelText: context.l10n.adminAuditDateRange,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  items: [
                    DropdownMenuItem(value: 'today', child: Text(context.l10n.adminAuditToday)),
                    DropdownMenuItem(
                        value: 'yesterday', child: Text(context.l10n.adminAuditYesterday)),
                    DropdownMenuItem(
                        value: 'last7days', child: Text(context.l10n.adminAuditLast7Days)),
                    DropdownMenuItem(
                        value: 'last30days', child: Text(context.l10n.adminAuditLast30Days)),
                    DropdownMenuItem(
                        value: 'custom', child: Text(context.l10n.adminAuditCustomRange)),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedDateRange = value);
                      // TODO: Apply filter and reload data
                      // TODO: Show date picker for custom range
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    // TODO: Replace with actual data from backend
    final List<AuditLogRowData> logs = [];

    return AdminDataTable<AuditLogRowData>(
      columns: [
        DataTableColumn(
          label: context.l10n.adminAuditTimestamp,
          cellBuilder: (log) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                log.timestamp,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              Text(
                log.timeSince,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          sortable: true,
        ),
        DataTableColumn(
          label: context.l10n.adminAuditUser,
          cellBuilder: (log) => Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: _getActionColor(log.action).withValues(alpha: 0.1),
                child: Text(
                  log.userInitials,
                  style: TextStyle(
                    color: _getActionColor(log.action),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      log.userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      log.userRole,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        DataTableColumn(
          label: context.l10n.adminAuditAction,
          cellBuilder: (log) => _buildActionChip(log.action),
        ),
        DataTableColumn(
          label: context.l10n.adminAuditResource,
          cellBuilder: (log) => Text(
            log.resource,
            style: const TextStyle(fontSize: 13),
          ),
        ),
        DataTableColumn(
          label: context.l10n.adminAuditDetails,
          cellBuilder: (log) => Text(
            log.details,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataTableColumn(
          label: context.l10n.adminAuditIpAddress,
          cellBuilder: (log) => Text(
            log.ipAddress,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
        ),
      ],
      data: logs,
      isLoading: false, // TODO: Set from actual loading state
      enableSelection: false,
      onRowTap: (log) {
        // TODO: Show detailed log entry modal
        _showLogDetails(log);
      },
      rowActions: [
        DataTableAction(
          icon: Icons.info_outline,
          tooltip: context.l10n.adminAuditViewDetails,
          onPressed: (log) {
            _showLogDetails(log);
          },
        ),
      ],
    );
  }

  Color _getActionColor(String action) {
    switch (action.toLowerCase()) {
      case 'login':
      case 'create':
        return AppColors.success;
      case 'update':
        return AppColors.primary;
      case 'delete':
      case 'logout':
        return AppColors.error;
      case 'export':
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }

  Widget _buildActionChip(String action) {
    final color = _getActionColor(action);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getActionIcon(action),
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            action,
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

  IconData _getActionIcon(String action) {
    switch (action.toLowerCase()) {
      case 'login':
        return Icons.login;
      case 'logout':
        return Icons.logout;
      case 'create':
        return Icons.add_circle_outline;
      case 'update':
        return Icons.edit_outlined;
      case 'delete':
        return Icons.delete_outline;
      case 'export':
        return Icons.download;
      default:
        return Icons.pending_actions;
    }
  }

  void _showLogDetails(AuditLogRowData log) {
    // TODO: Implement detailed log entry modal
    // - Show full details
    // - Display request/response data
    // - Show user agent and browser info
    // - Display geolocation data
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.article_outlined,
              color: AppColors.primary,
            ),
            const SizedBox(width: 12),
            Text(context.l10n.adminAuditLogDetails),
          ],
        ),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(context.l10n.adminAuditTimestamp, log.timestamp),
              _buildDetailRow(context.l10n.adminAuditUser, log.userName),
              _buildDetailRow(context.l10n.adminAuditRole, log.userRole),
              _buildDetailRow(context.l10n.adminAuditAction, log.action),
              _buildDetailRow(context.l10n.adminAuditResource, log.resource),
              _buildDetailRow(context.l10n.adminAuditDetails, log.details),
              _buildDetailRow(context.l10n.adminAuditIpAddress, log.ipAddress),
              const SizedBox(height: 16),
              Text(
                context.l10n.adminAuditBackendIntegrationNote,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.adminAuditClose),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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
}

/// Temporary data model for table rows
/// TODO: Replace with actual AuditLog model from backend
class AuditLogRowData {
  final String id;
  final String timestamp;
  final String timeSince;
  final String userName;
  final String userRole;
  final String userInitials;
  final String action;
  final String resource;
  final String details;
  final String ipAddress;

  AuditLogRowData({
    required this.id,
    required this.timestamp,
    required this.timeSince,
    required this.userName,
    required this.userRole,
    required this.userInitials,
    required this.action,
    required this.resource,
    required this.details,
    required this.ipAddress,
  });
}
