import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
// AdminShell is now provided by ShellRoute in admin_routes.dart
import '../../shared/widgets/admin_data_table.dart';
import '../../shared/utils/debouncer.dart';
import '../../shared/widgets/export_dialog.dart';
import '../../shared/utils/export_utils.dart';

/// Activity Logs Screen - Audit trail of admin actions
class ActivityLogsScreen extends ConsumerStatefulWidget {
  const ActivityLogsScreen({super.key});

  @override
  ConsumerState<ActivityLogsScreen> createState() => _ActivityLogsScreenState();
}

class _ActivityLogsScreenState extends ConsumerState<ActivityLogsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final _searchDebouncer = Debouncer(delay: const Duration(milliseconds: 500));
  String _searchQuery = '';
  String _selectedActionType = 'all';
  String _selectedSeverity = 'all';
  DateTimeRange? _selectedDateRange;

  @override
  void dispose() {
    _searchController.dispose();
    _searchDebouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Content is wrapped by AdminShell via ShellRoute
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Activity Logs',
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Audit trail of all administrative actions',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: _handleExportLogs,
                          icon: const Icon(Icons.download, size: 20),
                          label: const Text('Export Logs'),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                              _selectedActionType = 'all';
                              _selectedSeverity = 'all';
                              _selectedDateRange = null;
                            });
                          },
                          icon: const Icon(Icons.refresh, size: 20),
                          label: const Text('Reset Filters'),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildFilters(),
              ],
            ),
          ),

          // Data Table
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildDataTable(),
            ),
          ),
          const SizedBox(height: 24),
        ],
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
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
                    hintText: 'Search by admin, action, or target...',
                    prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.primary, width: 2),
                    ),
                    filled: true,
                    fillColor: AppColors.background,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  onChanged: (value) {
                    _searchDebouncer.call(() {
                      setState(() => _searchQuery = value.toLowerCase());
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),

              // Action Type Filter
              Expanded(
                child: _buildDropdownFilter(
                  label: 'Action Type',
                  value: _selectedActionType,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All Types')),
                    DropdownMenuItem(value: 'create', child: Text('Create')),
                    DropdownMenuItem(value: 'update', child: Text('Update')),
                    DropdownMenuItem(value: 'delete', child: Text('Delete')),
                    DropdownMenuItem(value: 'login', child: Text('Login')),
                    DropdownMenuItem(value: 'logout', child: Text('Logout')),
                    DropdownMenuItem(value: 'export', child: Text('Export')),
                    DropdownMenuItem(value: 'bulk_operation', child: Text('Bulk Operation')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedActionType = value);
                    }
                  },
                ),
              ),
              const SizedBox(width: 16),

              // Severity Filter
              Expanded(
                child: _buildDropdownFilter(
                  label: 'Severity',
                  value: _selectedSeverity,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All Severity')),
                    DropdownMenuItem(value: 'info', child: Text('Info')),
                    DropdownMenuItem(value: 'warning', child: Text('Warning')),
                    DropdownMenuItem(value: 'critical', child: Text('Critical')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedSeverity = value);
                    }
                  },
                ),
              ),
              const SizedBox(width: 16),

              // Date Range Picker
              OutlinedButton.icon(
                onPressed: _handleDateRangePicker,
                icon: const Icon(Icons.date_range, size: 20),
                label: Text(
                  _selectedDateRange == null
                      ? 'Date Range'
                      : '${DateFormat('MMM d').format(_selectedDateRange!.start)} - ${DateFormat('MMM d').format(_selectedDateRange!.end)}',
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownFilter({
    required String label,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            items: items,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildDataTable() {
    var logs = _getMockActivityLogs();

    // Apply filters
    if (_searchQuery.isNotEmpty) {
      logs = logs.where((log) {
        return log.adminName.toLowerCase().contains(_searchQuery) ||
            log.actionType.toLowerCase().contains(_searchQuery) ||
            log.targetType.toLowerCase().contains(_searchQuery) ||
            log.details.toLowerCase().contains(_searchQuery) ||
            log.ipAddress.contains(_searchQuery);
      }).toList();
    }

    if (_selectedActionType != 'all') {
      logs = logs.where((log) => log.actionType.toLowerCase() == _selectedActionType).toList();
    }

    if (_selectedSeverity != 'all') {
      logs = logs.where((log) => log.severity.toLowerCase() == _selectedSeverity).toList();
    }

    if (_selectedDateRange != null) {
      logs = logs.where((log) {
        return log.timestamp.isAfter(_selectedDateRange!.start) &&
            log.timestamp.isBefore(_selectedDateRange!.end.add(const Duration(days: 1)));
      }).toList();
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: AdminDataTable<ActivityLogData>(
        columns: [
          DataTableColumn<ActivityLogData>(
            label: 'Timestamp',
            cellBuilder: (log) => Text(
              DateFormat('MMM d, yyyy HH:mm').format(log.timestamp),
              style: const TextStyle(fontSize: 13),
            ),
            sortable: true,
          ),
          DataTableColumn<ActivityLogData>(
            label: 'Admin',
            cellBuilder: (log) => Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Text(
                    log.adminName.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    log.adminName,
                    style: const TextStyle(fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            sortable: true,
          ),
          DataTableColumn<ActivityLogData>(
            label: 'Action',
            cellBuilder: (log) => _buildActionBadge(log.actionType),
            sortable: true,
          ),
          DataTableColumn<ActivityLogData>(
            label: 'Target',
            cellBuilder: (log) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  log.targetType,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (log.targetId != null)
                  Text(
                    'ID: ${log.targetId}',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
            sortable: false,
          ),
          DataTableColumn<ActivityLogData>(
            label: 'Details',
            cellBuilder: (log) => SizedBox(
              width: 200,
              child: Text(
                log.details,
                style: const TextStyle(fontSize: 13),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            sortable: false,
          ),
          DataTableColumn<ActivityLogData>(
            label: 'Severity',
            cellBuilder: (log) => _buildSeverityBadge(log.severity),
            sortable: true,
          ),
          DataTableColumn<ActivityLogData>(
            label: 'IP Address',
            cellBuilder: (log) => Text(
              log.ipAddress,
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'monospace',
                color: AppColors.textSecondary,
              ),
            ),
            sortable: false,
          ),
        ],
        data: logs,
        rowsPerPage: 25,
        enableSelection: false,
        enableColumnVisibility: true,
      ),
    );
  }

  Widget _buildActionBadge(String actionType) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (actionType.toLowerCase()) {
      case 'create':
        backgroundColor = AppColors.success.withValues(alpha: 0.1);
        textColor = AppColors.success;
        icon = Icons.add_circle;
        break;
      case 'update':
        backgroundColor = AppColors.primary.withValues(alpha: 0.1);
        textColor = AppColors.primary;
        icon = Icons.edit;
        break;
      case 'delete':
        backgroundColor = AppColors.error.withValues(alpha: 0.1);
        textColor = AppColors.error;
        icon = Icons.delete;
        break;
      case 'login':
        backgroundColor = Colors.blue.withValues(alpha: 0.1);
        textColor = Colors.blue;
        icon = Icons.login;
        break;
      case 'logout':
        backgroundColor = Colors.grey.withValues(alpha: 0.1);
        textColor = Colors.grey;
        icon = Icons.logout;
        break;
      case 'export':
        backgroundColor = Colors.purple.withValues(alpha: 0.1);
        textColor = Colors.purple;
        icon = Icons.download;
        break;
      case 'bulk_operation':
        backgroundColor = Colors.orange.withValues(alpha: 0.1);
        textColor = Colors.orange;
        icon = Icons.grid_on;
        break;
      default:
        backgroundColor = AppColors.textSecondary.withValues(alpha: 0.1);
        textColor = AppColors.textSecondary;
        icon = Icons.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 6),
          Text(
            actionType,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeverityBadge(String severity) {
    Color backgroundColor;
    Color textColor;

    switch (severity.toLowerCase()) {
      case 'critical':
        backgroundColor = AppColors.error.withValues(alpha: 0.1);
        textColor = AppColors.error;
        break;
      case 'warning':
        backgroundColor = Colors.orange.withValues(alpha: 0.1);
        textColor = Colors.orange;
        break;
      case 'info':
      default:
        backgroundColor = AppColors.primary.withValues(alpha: 0.1);
        textColor = AppColors.primary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        severity.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  Future<void> _handleDateRangePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedDateRange = picked);
    }
  }

  Future<void> _handleExportLogs() async {
    final logs = _getMockActivityLogs();

    await showDialog(
      context: context,
      builder: (context) => ExportDialog(
        title: 'Export Activity Logs',
        onExport: (format) async {
          final data = logs.map((log) {
            return {
              'Timestamp': DateFormat('yyyy-MM-dd HH:mm:ss').format(log.timestamp),
              'Admin': log.adminName,
              'Action Type': log.actionType,
              'Target Type': log.targetType,
              'Target ID': log.targetId ?? 'N/A',
              'Details': log.details,
              'Severity': log.severity,
              'IP Address': log.ipAddress,
            };
          }).toList();

          switch (format) {
            case ExportFormat.csv:
              await ExportUtils.exportToCSV(
                data: data,
                filename: 'activity_logs_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv',
              );
              break;
            case ExportFormat.excel:
              await ExportUtils.exportToExcel(
                data: data,
                filename: 'activity_logs_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.xlsx',
                sheetName: 'Activity Logs',
              );
              break;
            case ExportFormat.pdf:
              await ExportUtils.exportToPDF(
                data: data,
                filename: 'activity_logs_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf',
                title: 'Activity Logs Report',
              );
              break;
          }
        },
      ),
    );
  }

  List<ActivityLogData> _getMockActivityLogs() {
    return [
      ActivityLogData(
        id: '1',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        adminName: 'John Admin',
        actionType: 'Create',
        targetType: 'Student',
        targetId: 'STU001',
        details: 'Created new student account for Jane Doe',
        severity: 'Info',
        ipAddress: '192.168.1.100',
      ),
      ActivityLogData(
        id: '2',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        adminName: 'Sarah Manager',
        actionType: 'Update',
        targetType: 'Institution',
        targetId: 'INST023',
        details: 'Updated institution verification status to Verified',
        severity: 'Info',
        ipAddress: '192.168.1.101',
      ),
      ActivityLogData(
        id: '3',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        adminName: 'John Admin',
        actionType: 'Delete',
        targetType: 'Parent',
        targetId: 'PAR045',
        details: 'Deleted inactive parent account (user request)',
        severity: 'Warning',
        ipAddress: '192.168.1.100',
      ),
      ActivityLogData(
        id: '4',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        adminName: 'Mike Supervisor',
        actionType: 'Login',
        targetType: 'Admin Session',
        targetId: null,
        details: 'Admin logged in successfully',
        severity: 'Info',
        ipAddress: '192.168.1.102',
      ),
      ActivityLogData(
        id: '5',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        adminName: 'Sarah Manager',
        actionType: 'Bulk_Operation',
        targetType: 'Students',
        targetId: null,
        details: 'Activated 15 student accounts',
        severity: 'Warning',
        ipAddress: '192.168.1.101',
      ),
      ActivityLogData(
        id: '6',
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        adminName: 'John Admin',
        actionType: 'Export',
        targetType: 'Students',
        targetId: null,
        details: 'Exported 250 student records to CSV',
        severity: 'Info',
        ipAddress: '192.168.1.100',
      ),
      ActivityLogData(
        id: '7',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        adminName: 'Mike Supervisor',
        actionType: 'Update',
        targetType: 'Counselor',
        targetId: 'COU012',
        details: 'Updated counselor specialization and availability',
        severity: 'Info',
        ipAddress: '192.168.1.102',
      ),
      ActivityLogData(
        id: '8',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        adminName: 'Sarah Manager',
        actionType: 'Create',
        targetType: 'Recommender',
        targetId: 'REC087',
        details: 'Created new recommender account for Prof. Smith',
        severity: 'Info',
        ipAddress: '192.168.1.101',
      ),
      ActivityLogData(
        id: '9',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
        adminName: 'John Admin',
        actionType: 'Logout',
        targetType: 'Admin Session',
        targetId: null,
        details: 'Admin logged out',
        severity: 'Info',
        ipAddress: '192.168.1.100',
      ),
      ActivityLogData(
        id: '10',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        adminName: 'Mike Supervisor',
        actionType: 'Delete',
        targetType: 'Institution',
        targetId: 'INST099',
        details: 'Deleted duplicate institution entry',
        severity: 'Critical',
        ipAddress: '192.168.1.102',
      ),
      ActivityLogData(
        id: '11',
        timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
        adminName: 'Sarah Manager',
        actionType: 'Bulk_Operation',
        targetType: 'Parents',
        targetId: null,
        details: 'Deactivated 8 inactive parent accounts',
        severity: 'Warning',
        ipAddress: '192.168.1.101',
      ),
      ActivityLogData(
        id: '12',
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        adminName: 'John Admin',
        actionType: 'Create',
        targetType: 'Institution',
        targetId: 'INST145',
        details: 'Added new institution: Harvard University',
        severity: 'Info',
        ipAddress: '192.168.1.100',
      ),
      ActivityLogData(
        id: '13',
        timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 4)),
        adminName: 'Mike Supervisor',
        actionType: 'Update',
        targetType: 'Student',
        targetId: 'STU234',
        details: 'Updated student profile verification status',
        severity: 'Info',
        ipAddress: '192.168.1.102',
      ),
      ActivityLogData(
        id: '14',
        timestamp: DateTime.now().subtract(const Duration(days: 4)),
        adminName: 'Sarah Manager',
        actionType: 'Export',
        targetType: 'Counselors',
        targetId: null,
        details: 'Exported 45 counselor records to Excel',
        severity: 'Info',
        ipAddress: '192.168.1.101',
      ),
      ActivityLogData(
        id: '15',
        timestamp: DateTime.now().subtract(const Duration(days: 5)),
        adminName: 'John Admin',
        actionType: 'Login',
        targetType: 'Admin Session',
        targetId: null,
        details: 'Admin logged in successfully',
        severity: 'Info',
        ipAddress: '192.168.1.100',
      ),
      ActivityLogData(
        id: '16',
        timestamp: DateTime.now().subtract(const Duration(days: 5, hours: 6)),
        adminName: 'Mike Supervisor',
        actionType: 'Delete',
        targetType: 'Student',
        targetId: 'STU567',
        details: 'Deleted student account due to policy violation',
        severity: 'Critical',
        ipAddress: '192.168.1.102',
      ),
      ActivityLogData(
        id: '17',
        timestamp: DateTime.now().subtract(const Duration(days: 6)),
        adminName: 'Sarah Manager',
        actionType: 'Bulk_Operation',
        targetType: 'Institutions',
        targetId: null,
        details: 'Approved 12 pending institution verifications',
        severity: 'Warning',
        ipAddress: '192.168.1.101',
      ),
      ActivityLogData(
        id: '18',
        timestamp: DateTime.now().subtract(const Duration(days: 7)),
        adminName: 'John Admin',
        actionType: 'Update',
        targetType: 'Recommender',
        targetId: 'REC156',
        details: 'Updated recommender contact information',
        severity: 'Info',
        ipAddress: '192.168.1.100',
      ),
      ActivityLogData(
        id: '19',
        timestamp: DateTime.now().subtract(const Duration(days: 8)),
        adminName: 'Mike Supervisor',
        actionType: 'Create',
        targetType: 'Parent',
        targetId: 'PAR789',
        details: 'Created parent account linked to student STU001',
        severity: 'Info',
        ipAddress: '192.168.1.102',
      ),
      ActivityLogData(
        id: '20',
        timestamp: DateTime.now().subtract(const Duration(days: 9)),
        adminName: 'Sarah Manager',
        actionType: 'Logout',
        targetType: 'Admin Session',
        targetId: null,
        details: 'Admin logged out',
        severity: 'Info',
        ipAddress: '192.168.1.101',
      ),
    ];
  }
}

/// Activity Log Data Model
class ActivityLogData {
  final String id;
  final DateTime timestamp;
  final String adminName;
  final String actionType;
  final String targetType;
  final String? targetId;
  final String details;
  final String severity;
  final String ipAddress;

  ActivityLogData({
    required this.id,
    required this.timestamp,
    required this.adminName,
    required this.actionType,
    required this.targetType,
    this.targetId,
    required this.details,
    required this.severity,
    required this.ipAddress,
  });
}
