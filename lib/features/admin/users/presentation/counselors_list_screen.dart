import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n_extension.dart';
import '../../../../core/constants/admin_permissions.dart';
// AdminShell is now provided by ShellRoute in admin_routes.dart
import '../../shared/widgets/admin_data_table.dart';
import '../../shared/widgets/permission_guard.dart';
import '../../shared/widgets/export_dialog.dart';
import '../../shared/widgets/bulk_action_bar.dart';
import '../../shared/services/export_service.dart';
import '../../shared/services/bulk_operations_service.dart';
import '../../shared/utils/export_utils.dart';
import '../../shared/utils/debouncer.dart';
import '../../shared/providers/admin_users_provider.dart';

/// Counselors List Screen - Manage counselor accounts
///
/// Features:
/// - View all counselors (filtered by regional scope for Regional Admins)
/// - Search and filter counselors
/// - View counselor details and student assignments
/// - Edit counselor profiles
/// - Deactivate/activate accounts
/// - Export counselor data
class CounselorsListScreen extends ConsumerStatefulWidget {
  const CounselorsListScreen({super.key});

  @override
  ConsumerState<CounselorsListScreen> createState() =>
      _CounselorsListScreenState();
}

class _CounselorsListScreenState extends ConsumerState<CounselorsListScreen> {
  // TODO: Replace with actual state management
  final TextEditingController _searchController = TextEditingController();
  final _searchDebouncer = Debouncer(delay: const Duration(milliseconds: 500));
  String _searchQuery = '';
  String _selectedStatus = 'all';
  String _selectedSpecialty = 'all';
  List<CounselorRowData> _selectedItems = [];
  bool _isBulkOperationInProgress = false;

  @override
  void dispose() {
    _searchController.dispose();
    _searchDebouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch counselors from backend
    // - API endpoint: GET /api/admin/users/counselors
    // - Support pagination, filtering, search
    // - Filter by regional scope for Regional Admins
    // - Include: profile data, specialty, student count, session stats

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
            child: Column(
              children: [
                BulkActionBar(
                  selectedCount: _selectedItems.length,
                  onClearSelection: () => setState(() => _selectedItems = []),
                  isProcessing: _isBulkOperationInProgress,
                  actions: [
                    BulkAction(
                      label: context.l10n.adminUserActivate,
                      icon: Icons.check_circle,
                      onPressed: _handleBulkActivate,
                    ),
                    BulkAction(
                      label: context.l10n.adminUserDeactivate,
                      icon: Icons.block,
                      onPressed: _handleBulkDeactivate,
                      isDestructive: true,
                    ),
                  ],
                ),
                Expanded(child: _buildDataTable()),
              ],
            ),
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
              Text(
                context.l10n.adminUserCounselors,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.adminUserManageCounselorAccounts,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Row(
            children: [
              // Export button (requires permission)
              PermissionGuard(
                permission: AdminPermission.bulkUserOperations,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final users = ref.read(adminCounselorsProvider);
                    await showExportDialog(
                      context: context,
                      title: context.l10n.adminUserExportCounselors,
                      onExport: (format) => ExportService.exportCounselors(
                        counselors: users,
                        format: format,
                      ),
                    );
                  },
                  icon: const Icon(Icons.download, size: 20),
                  label: Text(context.l10n.adminUserExport),
                ),
              ),
              const SizedBox(width: 12),
              // Add counselor button (requires permission)
              PermissionGuard(
                permission: AdminPermission.editUsers,
                child: ElevatedButton.icon(
                  onPressed: () => context.go('/admin/users/counselors/create'),
                  icon: const Icon(Icons.add, size: 20),
                  label: Text(context.l10n.adminUserAddCounselor),
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
      child: Row(
        children: [
          // Search
          Expanded(
            flex: 2,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: context.l10n.adminUserSearchCounselors,
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
                _searchDebouncer.call(() {
                  setState(() => _searchQuery = value.toLowerCase());
                });
              },
            ),
          ),
          const SizedBox(width: 16),

          // Status Filter
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: InputDecoration(
                labelText: context.l10n.adminUserStatus,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              items: [
                DropdownMenuItem(value: 'all', child: Text(context.l10n.adminUserAllStatus)),
                DropdownMenuItem(value: 'active', child: Text(context.l10n.adminUserActive)),
                DropdownMenuItem(value: 'inactive', child: Text(context.l10n.adminUserInactive)),
                DropdownMenuItem(
                    value: 'pending', child: Text(context.l10n.adminUserPendingVerification)),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedStatus = value);
                }
              },
            ),
          ),
          const SizedBox(width: 16),

          // Specialty Filter
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedSpecialty,
              decoration: InputDecoration(
                labelText: context.l10n.adminUserSpecialty,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              items: [
                DropdownMenuItem(value: 'all', child: Text(context.l10n.adminUserAllSpecialties)),
                DropdownMenuItem(value: 'academic', child: Text(context.l10n.adminUserAcademic)),
                DropdownMenuItem(value: 'career', child: Text(context.l10n.adminUserCareer)),
                DropdownMenuItem(
                    value: 'college', child: Text(context.l10n.adminUserCollegeAdmissions)),
                DropdownMenuItem(
                    value: 'financial', child: Text(context.l10n.adminUserFinancialAid)),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedSpecialty = value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    // Get users from provider and convert to CounselorRowData
    final users = ref.watch(adminCounselorsProvider);
    var counselors = users.map((user) {
      // Extract metadata fields if available
      final metadata = user.metadata ?? {};
      return CounselorRowData(
        id: user.id,
        name: user.displayName ?? context.l10n.adminCounselorsListUnknownCounselor,
        email: user.email,
        counselorId: 'COU${user.id.substring(0, 6).toUpperCase()}',
        specialty: metadata['specialty']?.toString() ?? context.l10n.adminCounselorsListNotSpecified,
        students: (metadata['students_count'] as int?) ?? 0,
        sessions: (metadata['sessions_count'] as int?) ?? 0,
        status: metadata['isActive'] == true ? 'active' : 'inactive',
        joinedDate: _formatDate(user.createdAt, context),
      );
    }).toList();

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      counselors = counselors.where((counselor) {
        return counselor.name.toLowerCase().contains(_searchQuery) ||
            counselor.email.toLowerCase().contains(_searchQuery) ||
            counselor.counselorId.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    // Apply status filter
    if (_selectedStatus != 'all') {
      counselors = counselors.where((counselor) => counselor.status == _selectedStatus).toList();
    }

    // Apply specialty filter
    if (_selectedSpecialty != 'all') {
      counselors = counselors.where((counselor) => counselor.specialty.toLowerCase().contains(_selectedSpecialty)).toList();
    }

    return AdminDataTable<CounselorRowData>(
      columns: [
        DataTableColumn(
          label: context.l10n.adminUserCounselorColumn,
          cellBuilder: (counselor) => Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Text(
                  counselor.initials,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    counselor.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    counselor.email,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          sortable: true,
        ),
        DataTableColumn(
          label: context.l10n.adminUserCounselorId,
          cellBuilder: (counselor) => Text(counselor.counselorId),
        ),
        DataTableColumn(
          label: context.l10n.adminUserSpecialty,
          cellBuilder: (counselor) => Text(counselor.specialty),
        ),
        DataTableColumn(
          label: context.l10n.adminUserStudents,
          cellBuilder: (counselor) => Text(counselor.students.toString()),
        ),
        DataTableColumn(
          label: context.l10n.adminUserSessions,
          cellBuilder: (counselor) => Text(counselor.sessions.toString()),
        ),
        DataTableColumn(
          label: context.l10n.adminUserStatus,
          cellBuilder: (counselor) => _buildStatusChip(counselor.status),
        ),
        DataTableColumn(
          label: context.l10n.adminUserJoined,
          cellBuilder: (counselor) => Text(counselor.joinedDate),
        ),
      ],
      data: counselors,
      isLoading: false, // TODO: Set from actual loading state
      enableSelection: true,
      onSelectionChanged: (selectedItems) {
        setState(() => _selectedItems = selectedItems);
      },
      onRowTap: (counselor) {
        // TODO: Navigate to counselor detail screen
        _showCounselorDetails(counselor);
      },
      rowActions: [
        DataTableAction(
          icon: Icons.visibility,
          tooltip: context.l10n.adminUserViewDetails,
          onPressed: (counselor) {
            // TODO: Navigate to counselor detail screen
            _showCounselorDetails(counselor);
          },
        ),
        DataTableAction(
          icon: Icons.edit,
          tooltip: context.l10n.adminUserEditCounselor,
          onPressed: (counselor) {
            // TODO: Navigate to edit counselor screen
          },
        ),
        DataTableAction(
          icon: Icons.block,
          tooltip: context.l10n.adminUserDeactivateAccount,
          color: AppColors.error,
          onPressed: (counselor) {
            // TODO: Show confirmation dialog
            // TODO: Call deactivate API
          },
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String label;

    switch (status) {
      case 'active':
        color = AppColors.success;
        label = context.l10n.adminUserActive;
        break;
      case 'inactive':
        color = AppColors.textSecondary;
        label = context.l10n.adminUserInactive;
        break;
      case 'pending':
        color = AppColors.warning;
        label = context.l10n.adminUserPending;
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

  void _showCounselorDetails(CounselorRowData counselor) {
    // Navigate to counselor detail screen
    context.go('/admin/users/counselors/${counselor.id}');
  }

  /// Helper method to format date relative to now
  String _formatDate(DateTime date, BuildContext context) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) return context.l10n.adminCounselorsListToday;
    if (diff.inDays == 1) return context.l10n.adminCounselorsListYesterday;
    if (diff.inDays < 7) return context.l10n.adminCounselorsListDaysAgo(diff.inDays);
    if (diff.inDays < 30) return context.l10n.adminCounselorsListWeeksAgo((diff.inDays / 7).floor());
    if (diff.inDays < 365) return context.l10n.adminCounselorsListMonthsAgo((diff.inDays / 30).floor());
    return context.l10n.adminCounselorsListYearsAgo((diff.inDays / 365).floor());
  }

  Future<void> _handleBulkActivate() async {
    if (_selectedItems.isEmpty) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.adminUserActivateCounselors),
        content: Text(context.l10n.adminUserConfirmActivateCounselors(_selectedItems.length)),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(context.l10n.adminUserCancel)),
          ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: Text(context.l10n.adminUserActivate)),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() => _isBulkOperationInProgress = true);
    try {
      final result = await BulkOperationsService.activateUsers(userIds: _selectedItems.map((item) => item.id).toList());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.message), backgroundColor: result.isSuccess ? AppColors.success : AppColors.error));
        if (result.isSuccess) setState(() => _selectedItems = []);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.adminCounselorsListError(e.toString())), backgroundColor: AppColors.error));
    } finally {
      if (mounted) setState(() => _isBulkOperationInProgress = false);
    }
  }

  Future<void> _handleBulkDeactivate() async {
    if (_selectedItems.isEmpty) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.adminUserDeactivateCounselors),
        content: Text(context.l10n.adminUserConfirmDeactivateCounselors(_selectedItems.length)),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(context.l10n.adminUserCancel)),
          ElevatedButton(onPressed: () => Navigator.of(context).pop(true), style: ElevatedButton.styleFrom(backgroundColor: AppColors.error), child: Text(context.l10n.adminUserDeactivate)),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() => _isBulkOperationInProgress = true);
    try {
      final result = await BulkOperationsService.deactivateUsers(userIds: _selectedItems.map((item) => item.id).toList());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.message), backgroundColor: result.isSuccess ? AppColors.success : AppColors.error));
        if (result.isSuccess) setState(() => _selectedItems = []);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.adminCounselorsListError(e.toString())), backgroundColor: AppColors.error));
    } finally {
      if (mounted) setState(() => _isBulkOperationInProgress = false);
    }
  }
}

/// Temporary data model for table rows
/// TODO: Replace with actual Counselor model from backend
class CounselorRowData {
  final String id;
  final String name;
  final String email;
  final String counselorId;
  final String specialty;
  final int students;
  final int sessions;
  final String status;
  final String joinedDate;

  CounselorRowData({
    required this.id,
    required this.name,
    required this.email,
    required this.counselorId,
    required this.specialty,
    required this.students,
    required this.sessions,
    required this.status,
    required this.joinedDate,
  });

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}
