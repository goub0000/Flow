// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/admin_permissions.dart';
import '../../../../core/l10n_extension.dart';
import '../../../shared/widgets/logo_avatar.dart';
// AdminShell is now provided by ShellRoute in admin_routes.dart
import '../../shared/widgets/admin_data_table.dart';
import '../../shared/widgets/permission_guard.dart';
import '../../shared/widgets/export_dialog.dart';
import '../../shared/widgets/bulk_action_bar.dart';
import '../../shared/services/export_service.dart';
import '../../shared/services/bulk_operations_service.dart';
import '../../shared/utils/debouncer.dart';
import '../../shared/providers/admin_users_provider.dart';

/// Institutions List Screen - Manage institution accounts
///
/// Features:
/// - View all institutions (filtered by regional scope for Regional Admins)
/// - Search and filter institutions
/// - View institution details
/// - Approve/reject institution applications
/// - Edit institution profiles
/// - Deactivate/activate accounts
/// - Export institution data
class InstitutionsListScreen extends ConsumerStatefulWidget {
  const InstitutionsListScreen({super.key});

  @override
  ConsumerState<InstitutionsListScreen> createState() =>
      _InstitutionsListScreenState();
}

class _InstitutionsListScreenState
    extends ConsumerState<InstitutionsListScreen> {
  // TODO: Replace with actual state management
  final TextEditingController _searchController = TextEditingController();
  final _searchDebouncer = Debouncer(delay: const Duration(milliseconds: 500));
  String _searchQuery = '';
  String _selectedStatus = 'all';
  String _selectedType = 'all';
  List<InstitutionRowData> _selectedItems = [];
  bool _isBulkOperationInProgress = false;

  @override
  void dispose() {
    _searchController.dispose();
    _searchDebouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch institutions from backend
    // - API endpoint: GET /api/admin/users/institutions
    // - Support pagination, filtering, search
    // - Filter by regional scope for Regional Admins
    // - Include: profile data, verification status, program counts

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
                // Bulk Action Bar
                BulkActionBar(
                  selectedCount: _selectedItems.length,
                  onClearSelection: () {
                    setState(() => _selectedItems = []);
                  },
                  isProcessing: _isBulkOperationInProgress,
                  actions: [
                    BulkAction(
                      label: context.l10n.adminUsersListApprove,
                      icon: Icons.check_circle,
                      onPressed: _handleBulkApprove,
                    ),
                    BulkAction(
                      label: context.l10n.adminUsersListDeactivate,
                      icon: Icons.block,
                      onPressed: _handleBulkDeactivate,
                      isDestructive: true,
                    ),
                  ],
                ),

                // Data Table
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
                context.l10n.adminUsersListInstitutionsTitle,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.adminUsersListInstitutionsSubtitle,
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
                    final users = ref.read(adminInstitutionsProvider);
                    await showExportDialog(
                      context: context,
                      title: context.l10n.adminUsersListExportInstitutions,
                      onExport: (format) => ExportService.exportInstitutions(
                        institutions: users,
                        format: format,
                      ),
                    );
                  },
                  icon: const Icon(Icons.download, size: 20),
                  label: Text(context.l10n.adminUsersListExport),
                ),
              ),
              const SizedBox(width: 12),
              // Add institution button (requires permission)
              PermissionGuard(
                permission: AdminPermission.editInstitutions,
                child: ElevatedButton.icon(
                  onPressed: () => context.go('/admin/users/institutions/create'),
                  icon: const Icon(Icons.add, size: 20),
                  label: Text(context.l10n.adminUsersListAddInstitution),
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
                hintText: context.l10n.adminUsersListSearchInstitutionsHint,
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
                labelText: context.l10n.adminUsersListStatusLabel,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              items: [
                DropdownMenuItem(value: 'all', child: Text(context.l10n.adminUsersListAllStatus)),
                DropdownMenuItem(value: 'active', child: Text(context.l10n.adminUsersListStatusActive)),
                DropdownMenuItem(value: 'inactive', child: Text(context.l10n.adminUsersListStatusInactive)),
                DropdownMenuItem(
                    value: 'pending', child: Text(context.l10n.adminUsersListStatusPendingApproval)),
                DropdownMenuItem(value: 'rejected', child: Text(context.l10n.adminUsersListStatusRejected)),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedStatus = value);
                }
              },
            ),
          ),
          const SizedBox(width: 16),

          // Type Filter
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: InputDecoration(
                labelText: context.l10n.adminUsersListTypeLabel,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              items: [
                DropdownMenuItem(value: 'all', child: Text(context.l10n.adminUsersListAllTypes)),
                DropdownMenuItem(
                    value: 'university', child: Text(context.l10n.adminUsersListTypeUniversity)),
                DropdownMenuItem(value: 'college', child: Text(context.l10n.adminUsersListTypeCollege)),
                DropdownMenuItem(
                    value: 'vocational', child: Text(context.l10n.adminUsersListTypeVocational)),
                DropdownMenuItem(
                    value: 'language', child: Text(context.l10n.adminUsersListTypeLanguageSchool)),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedType = value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    // Get users from provider and convert to InstitutionRowData
    final users = ref.watch(adminInstitutionsProvider);
    var institutions = users.map((user) {
      // Extract metadata fields if available
      final metadata = user.metadata ?? {};
      return InstitutionRowData(
        id: user.id,
        name: user.displayName ?? 'Unknown Institution',
        email: user.email,
        institutionId: 'INS${user.id.substring(0, 6).toUpperCase()}',
        type: metadata['institution_type']?.toString() ?? 'Not specified',
        location: metadata['location']?.toString() ?? 'Not specified',
        programs: (metadata['programs_count'] as int?) ?? 0,
        status: metadata['isActive'] == true ? 'Active' : 'Pending',
        joinedDate: _formatDate(user.createdAt),
      );
    }).toList();

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      institutions = institutions.where((institution) {
        return institution.name.toLowerCase().contains(_searchQuery) ||
            institution.email.toLowerCase().contains(_searchQuery) ||
            institution.institutionId.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    // Apply status filter
    if (_selectedStatus != 'all') {
      institutions = institutions.where((institution) => institution.status == _selectedStatus).toList();
    }

    // Apply type filter
    if (_selectedType != 'all') {
      institutions = institutions.where((institution) => institution.type.toLowerCase() == _selectedType).toList();
    }

    return AdminDataTable<InstitutionRowData>(
      columns: [
        DataTableColumn(
          label: context.l10n.adminUsersListColumnInstitution,
          cellBuilder: (institution) => Row(
            children: [
              LogoAvatar.institution(
                logoUrl: null, // TODO: Add logoUrl field to institution model
                name: institution.name,
                size: 32,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    institution.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    institution.email,
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
          label: context.l10n.adminUsersListColumnInstitutionId,
          cellBuilder: (institution) => Text(institution.institutionId),
        ),
        DataTableColumn(
          label: context.l10n.adminUsersListColumnType,
          cellBuilder: (institution) => Text(institution.type),
        ),
        DataTableColumn(
          label: context.l10n.adminUsersListColumnLocation,
          cellBuilder: (institution) => Text(
            institution.location,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataTableColumn(
          label: context.l10n.adminUsersListColumnPrograms,
          cellBuilder: (institution) => Text(institution.programs.toString()),
        ),
        DataTableColumn(
          label: context.l10n.adminUsersListColumnStatus,
          cellBuilder: (institution) => _buildStatusChip(institution.status),
        ),
        DataTableColumn(
          label: context.l10n.adminUsersListColumnJoined,
          cellBuilder: (institution) => Text(institution.joinedDate),
        ),
      ],
      data: institutions,
      isLoading: false, // TODO: Set from actual loading state
      enableSelection: true,
      onSelectionChanged: (selectedItems) {
        setState(() => _selectedItems = selectedItems);
      },
      onRowTap: (institution) {
        // TODO: Navigate to institution detail screen
        _showInstitutionDetails(institution);
      },
      rowActions: [
        DataTableAction(
          icon: Icons.visibility,
          tooltip: context.l10n.adminUsersListViewDetails,
          onPressed: (institution) {
            // TODO: Navigate to institution detail screen
            _showInstitutionDetails(institution);
          },
        ),
        DataTableAction(
          icon: Icons.edit,
          tooltip: context.l10n.adminUsersListEditInstitution,
          onPressed: (institution) {
            // TODO: Navigate to edit institution screen
          },
        ),
        DataTableAction(
          icon: Icons.check_circle,
          tooltip: context.l10n.adminUsersListApprove,
          color: AppColors.success,
          onPressed: (institution) {
            // TODO: Show confirmation dialog
            // TODO: Call approve API
          },
        ),
        DataTableAction(
          icon: Icons.block,
          tooltip: context.l10n.adminUsersListDeactivateAccount,
          color: AppColors.error,
          onPressed: (institution) {
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
        label = context.l10n.adminUsersListStatusActive;
        break;
      case 'inactive':
        color = AppColors.textSecondary;
        label = context.l10n.adminUsersListStatusInactive;
        break;
      case 'pending':
        color = AppColors.warning;
        label = context.l10n.adminUsersListStatusPending;
        break;
      case 'rejected':
        color = AppColors.error;
        label = context.l10n.adminUsersListStatusRejected;
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

  void _showInstitutionDetails(InstitutionRowData institution) {
    // Navigate to institution detail screen
    context.go('/admin/users/institutions/${institution.id}');
  }

  /// Helper method to format date relative to now
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()} weeks ago';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()} months ago';
    return '${(diff.inDays / 365).floor()} years ago';
  }

  /// Handle bulk approve operation
  Future<void> _handleBulkApprove() async {
    if (_selectedItems.isEmpty) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.adminUsersListApproveInstitutionsTitle),
        content: Text(
          context.l10n.adminUsersListApproveInstitutionsConfirm(_selectedItems.length),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(context.l10n.adminUsersListCancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(context.l10n.adminUsersListApprove),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isBulkOperationInProgress = true);

    try {
      final institutionIds = _selectedItems.map((item) => item.id).toList();
      final result = await BulkOperationsService.approveInstitutions(
        institutionIds: institutionIds,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: result.isSuccess ? AppColors.success : AppColors.error,
          ),
        );

        if (result.isSuccess) {
          setState(() => _selectedItems = []);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isBulkOperationInProgress = false);
      }
    }
  }

  /// Handle bulk deactivate operation
  Future<void> _handleBulkDeactivate() async {
    if (_selectedItems.isEmpty) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.adminUsersListDeactivateInstitutionsTitle),
        content: Text(
          context.l10n.adminUsersListDeactivateInstitutionsConfirm(_selectedItems.length),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(context.l10n.adminUsersListCancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: Text(context.l10n.adminUsersListDeactivate),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isBulkOperationInProgress = true);

    try {
      final institutionIds = _selectedItems.map((item) => item.id).toList();
      final result = await BulkOperationsService.deactivateUsers(
        userIds: institutionIds,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: result.isSuccess ? AppColors.success : AppColors.error,
          ),
        );

        if (result.isSuccess) {
          setState(() => _selectedItems = []);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isBulkOperationInProgress = false);
      }
    }
  }
}

/// Temporary data model for table rows
/// TODO: Replace with actual Institution model from backend
class InstitutionRowData {
  final String id;
  final String name;
  final String email;
  final String institutionId;
  final String type;
  final String location;
  final int programs;
  final String status;
  final String joinedDate;

  InstitutionRowData({
    required this.id,
    required this.name,
    required this.email,
    required this.institutionId,
    required this.type,
    required this.location,
    required this.programs,
    required this.status,
    required this.joinedDate,
  });
}
