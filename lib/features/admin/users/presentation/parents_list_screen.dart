// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/admin_permissions.dart';
// AdminShell is now provided by ShellRoute in admin_routes.dart
import '../../shared/widgets/admin_data_table.dart';
import '../../shared/widgets/permission_guard.dart';
import '../../shared/widgets/export_dialog.dart';
import '../../shared/widgets/bulk_action_bar.dart';
import '../../shared/services/export_service.dart';
import '../../shared/services/bulk_operations_service.dart';
import '../../shared/utils/debouncer.dart';
import '../../shared/providers/admin_users_provider.dart';

/// Parents List Screen - Manage parent accounts
///
/// Features:
/// - View all parents (filtered by regional scope for Regional Admins)
/// - Search and filter parents
/// - View parent details and linked children
/// - Edit parent profiles
/// - Deactivate/activate accounts
/// - Export parent data
class ParentsListScreen extends ConsumerStatefulWidget {
  const ParentsListScreen({super.key});

  @override
  ConsumerState<ParentsListScreen> createState() => _ParentsListScreenState();
}

class _ParentsListScreenState extends ConsumerState<ParentsListScreen> {
  // TODO: Replace with actual state management
  final TextEditingController _searchController = TextEditingController();
  final _searchDebouncer = Debouncer(delay: const Duration(milliseconds: 500));
  String _searchQuery = '';
  String _selectedStatus = 'all';
  List<ParentRowData> _selectedItems = [];
  bool _isBulkOperationInProgress = false;

  @override
  void dispose() {
    _searchController.dispose();
    _searchDebouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch parents from backend
    // - API endpoint: GET /api/admin/users/parents
    // - Support pagination, filtering, search
    // - Filter by regional scope for Regional Admins
    // - Include: profile data, linked children count

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
                      label: 'Activate',
                      icon: Icons.check_circle,
                      onPressed: _handleBulkActivate,
                    ),
                    BulkAction(
                      label: 'Deactivate',
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
                'Parents',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Manage parent accounts and family connections',
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
                    final users = ref.read(adminParentsProvider);
                    await showExportDialog(
                      context: context,
                      title: 'Export Parents',
                      onExport: (format) => ExportService.exportParents(
                        parents: users,
                        format: format,
                      ),
                    );
                  },
                  icon: const Icon(Icons.download, size: 20),
                  label: const Text('Export'),
                ),
              ),
              const SizedBox(width: 12),
              // Add parent button (requires permission)
              PermissionGuard(
                permission: AdminPermission.editUsers,
                child: ElevatedButton.icon(
                  onPressed: () => context.go('/admin/users/parents/create'),
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text('Add Parent'),
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
                hintText: 'Search by name, email, or parent ID...',
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
                DropdownMenuItem(value: 'active', child: Text('Active')),
                DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
                DropdownMenuItem(
                    value: 'pending', child: Text('Pending Verification')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedStatus = value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    // Get users from provider and convert to ParentRowData
    final users = ref.watch(adminParentsProvider);
    var parents = users.map((user) {
      // Extract metadata fields if available
      final metadata = user.metadata ?? {};
      return ParentRowData(
        id: user.id,
        name: user.displayName ?? 'Unknown Parent',
        email: user.email,
        parentId: 'PAR${user.id.substring(0, 6).toUpperCase()}',
        phone: user.phoneNumber ?? 'Not specified',
        children: (metadata['children_count'] as int?) ?? 0,
        status: metadata['isActive'] == true ? 'active' : 'inactive',
        joinedDate: _formatDate(user.createdAt),
      );
    }).toList();

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      parents = parents.where((parent) {
        return parent.name.toLowerCase().contains(_searchQuery) ||
            parent.email.toLowerCase().contains(_searchQuery) ||
            parent.parentId.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    // Apply status filter
    if (_selectedStatus != 'all') {
      parents = parents.where((parent) => parent.status == _selectedStatus).toList();
    }

    return AdminDataTable<ParentRowData>(
      columns: [
        DataTableColumn(
          label: 'Parent',
          cellBuilder: (parent) => Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.accent.withValues(alpha: 0.1),
                child: Text(
                  parent.initials,
                  style: TextStyle(
                    color: AppColors.accent,
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
                    parent.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    parent.email,
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
          label: 'Parent ID',
          cellBuilder: (parent) => Text(parent.parentId),
        ),
        DataTableColumn(
          label: 'Phone',
          cellBuilder: (parent) => Text(parent.phone),
        ),
        DataTableColumn(
          label: 'Children',
          cellBuilder: (parent) => Text(parent.children.toString()),
        ),
        DataTableColumn(
          label: 'Status',
          cellBuilder: (parent) => _buildStatusChip(parent.status),
        ),
        DataTableColumn(
          label: 'Joined',
          cellBuilder: (parent) => Text(parent.joinedDate),
        ),
      ],
      data: parents,
      isLoading: false, // TODO: Set from actual loading state
      enableSelection: true,
      onSelectionChanged: (selectedItems) {
        setState(() => _selectedItems = selectedItems);
      },
      onRowTap: (parent) {
        // TODO: Navigate to parent detail screen
        _showParentDetails(parent);
      },
      rowActions: [
        DataTableAction(
          icon: Icons.visibility,
          tooltip: 'View Details',
          onPressed: (parent) {
            // TODO: Navigate to parent detail screen
            _showParentDetails(parent);
          },
        ),
        DataTableAction(
          icon: Icons.edit,
          tooltip: 'Edit Parent',
          onPressed: (parent) {
            // TODO: Navigate to edit parent screen
          },
        ),
        DataTableAction(
          icon: Icons.block,
          tooltip: 'Deactivate Account',
          color: AppColors.error,
          onPressed: (parent) {
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
        label = 'Active';
        break;
      case 'inactive':
        color = AppColors.textSecondary;
        label = 'Inactive';
        break;
      case 'pending':
        color = AppColors.warning;
        label = 'Pending';
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

  void _showParentDetails(ParentRowData parent) {
    // Navigate to parent detail screen
    context.go('/admin/users/parents/${parent.id}');
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

  Future<void> _handleBulkActivate() async {
    if (_selectedItems.isEmpty) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Activate Parents'),
        content: Text('Are you sure you want to activate ${_selectedItems.length} parent(s)?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Activate')),
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
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error));
    } finally {
      if (mounted) setState(() => _isBulkOperationInProgress = false);
    }
  }

  Future<void> _handleBulkDeactivate() async {
    if (_selectedItems.isEmpty) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deactivate Parents'),
        content: Text('Are you sure you want to deactivate ${_selectedItems.length} parent(s)?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.of(context).pop(true), style: ElevatedButton.styleFrom(backgroundColor: AppColors.error), child: const Text('Deactivate')),
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
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error));
    } finally {
      if (mounted) setState(() => _isBulkOperationInProgress = false);
    }
  }
}

/// Temporary data model for table rows
/// TODO: Replace with actual Parent model from backend
class ParentRowData {
  final String id;
  final String name;
  final String email;
  final String parentId;
  final String phone;
  final int children;
  final String status;
  final String joinedDate;

  ParentRowData({
    required this.id,
    required this.name,
    required this.email,
    required this.parentId,
    required this.phone,
    required this.children,
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
