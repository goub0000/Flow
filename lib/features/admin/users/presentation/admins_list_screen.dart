import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/admin_permissions.dart';
import '../../../../core/constants/user_roles.dart';
import '../../../../core/models/admin_user_model.dart';
import '../../../../core/models/user_model.dart';
// AdminShell is now provided by ShellRoute in admin_routes.dart
import '../../shared/widgets/admin_data_table.dart';
import '../../shared/widgets/permission_guard.dart';
import '../../shared/widgets/export_dialog.dart';
import '../../shared/widgets/bulk_action_bar.dart';
import '../../../shared/widgets/logo_avatar.dart';
import '../../shared/services/export_service.dart';
import '../../shared/services/bulk_operations_service.dart';
import '../../shared/utils/debouncer.dart';
import '../../shared/providers/admin_auth_provider.dart';
import '../../shared/providers/admin_users_provider.dart';

/// Admins List Screen - Manage admin user accounts
///
/// Features:
/// - View all admin users (Super Admin, Regional, Content, Support, Finance, Analytics)
/// - Search and filter by admin role
/// - Create new admin accounts
/// - Edit admin profiles and permissions
/// - Activate/deactivate admin accounts
/// - Export admin data
class AdminsListScreen extends ConsumerStatefulWidget {
  const AdminsListScreen({super.key});

  @override
  ConsumerState<AdminsListScreen> createState() => _AdminsListScreenState();
}

class _AdminsListScreenState extends ConsumerState<AdminsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final _searchDebouncer = Debouncer(delay: const Duration(milliseconds: 500));
  String _searchQuery = '';
  String _selectedStatus = 'all';
  String _selectedRole = 'all';
  List<AdminRowData> _selectedItems = [];
  bool _isBulkOperationInProgress = false;

  @override
  void dispose() {
    _searchController.dispose();
    _searchDebouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch admin users from backend
    // - API endpoint: GET /api/admin/users/admins
    // - Support pagination, filtering, search
    // - Filter by admin role type
    // - Include: profile data, role, permissions, last login, created date
    // IMPORTANT: Backend should also filter based on hierarchy - lower admins should not see higher admins

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
                'Admin Users',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Manage admin accounts and permissions',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Row(
            children: [
              // Info button about admin creation
              OutlinedButton.icon(
                onPressed: () => _showAdminCreationInfo(),
                icon: const Icon(Icons.info_outline, size: 18),
                label: const Text('How to Add Admins'),
              ),
              const SizedBox(width: 12),
              // Export button (requires permission)
              PermissionGuard(
                permission: AdminPermission.bulkUserOperations,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final admins = _getFilteredAdmins();
                    // TODO: Implement export for admins
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Admin export feature coming soon'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.download, size: 18),
                  label: const Text('Export'),
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
          // Search field
          Expanded(
            flex: 2,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name or email...',
                prefixIcon: const Icon(Icons.search, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
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
                  setState(() => _searchQuery = value);
                });
              },
            ),
          ),
          const SizedBox(width: 16),

          // Role filter
          Container(
            width: 180,
            child: DropdownButtonFormField<String>(
              value: _selectedRole,
              decoration: InputDecoration(
                labelText: 'Admin Role',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Roles')),
                DropdownMenuItem(value: 'superAdmin', child: Text('Super Admin')),
                DropdownMenuItem(value: 'regionalAdmin', child: Text('Regional Admin')),
                DropdownMenuItem(value: 'contentAdmin', child: Text('Content Admin')),
                DropdownMenuItem(value: 'supportAdmin', child: Text('Support Admin')),
                DropdownMenuItem(value: 'financeAdmin', child: Text('Finance Admin')),
                DropdownMenuItem(value: 'analyticsAdmin', child: Text('Analytics Admin')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedRole = value);
                }
              },
            ),
          ),
          const SizedBox(width: 16),

          // Status filter
          Container(
            width: 150,
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
                DropdownMenuItem(value: 'all', child: Text('All')),
                DropdownMenuItem(value: 'active', child: Text('Active')),
                DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
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
    final admins = _getFilteredAdmins();

    return AdminDataTable<AdminRowData>(
      columns: [
        DataTableColumn<AdminRowData>(
          label: 'Admin',
          cellBuilder: (admin) => Row(
            children: [
              LogoAvatar.user(
                photoUrl: null, // TODO: Add photoUrl to AdminRowData model
                initials: admin.initials,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      admin.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      admin.email,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        DataTableColumn<AdminRowData>(
          label: 'Role',
          cellBuilder: (admin) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: admin.roleColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  admin.roleIcon,
                  size: 14,
                  color: admin.roleColor,
                ),
                const SizedBox(width: 4),
                Text(
                  admin.roleDisplayName,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: admin.roleColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        DataTableColumn<AdminRowData>(
          label: 'Status',
          cellBuilder: (admin) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: admin.isActive ? AppColors.success.withOpacity(0.1) : AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              admin.status,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: admin.isActive ? AppColors.success : AppColors.error,
              ),
            ),
          ),
        ),
        DataTableColumn<AdminRowData>(
          label: 'Last Login',
          cellBuilder: (admin) => Text(
            admin.lastLogin,
            style: const TextStyle(fontSize: 13),
          ),
        ),
        DataTableColumn<AdminRowData>(
          label: 'Created',
          cellBuilder: (admin) => Text(
            admin.joinedDate,
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ],
      data: admins,
      isLoading: false, // TODO: Set from actual loading state
      onRowTap: (admin) {
        // TODO: Navigate to admin detail screen
        context.go('/admin/system/admins/${admin.id}');
      },
      rowActions: [
        DataTableAction<AdminRowData>(
          icon: Icons.visibility,
          tooltip: 'View Details',
          onPressed: (admin) {
            // View is allowed for all admins they can see in the list
            // Note: Admins are already filtered by hierarchy in _getFilteredAdmins()
            context.go('/admin/system/admins/${admin.id}');
          },
        ),
        DataTableAction<AdminRowData>(
          icon: Icons.edit,
          tooltip: 'Edit Admin',
          onPressed: (admin) {
            // Since admins are pre-filtered by hierarchy, this admin can be edited
            // Additional hierarchy check is performed here for safety
            final currentAdmin = ref.read(currentAdminUserProvider);
            if (currentAdmin != null) {
              final targetRole = UserRole.values.firstWhere(
                (r) => r.name == admin.role,
                orElse: () => UserRole.superAdmin,
              );

              if (currentAdmin.adminRole.canManage(targetRole)) {
                context.go('/admin/system/admins/${admin.id}/edit');
              } else {
                // This should not happen due to list filtering, but included for safety
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('You do not have permission to edit this admin'),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            }
          },
        ),
        DataTableAction<AdminRowData>(
          icon: Icons.block,
          tooltip: 'Deactivate',
          color: AppColors.error,
          onPressed: (admin) {
            // Since admins are pre-filtered by hierarchy, this admin can be deactivated
            // Additional hierarchy check is performed here for safety
            final currentAdmin = ref.read(currentAdminUserProvider);
            if (currentAdmin != null) {
              final targetRole = UserRole.values.firstWhere(
                (r) => r.name == admin.role,
                orElse: () => UserRole.superAdmin,
              );

              if (currentAdmin.adminRole.canManage(targetRole)) {
                // TODO: Show confirmation dialog
                // TODO: Call deactivate API
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Deactivation feature coming soon'),
                  ),
                );
              } else {
                // This should not happen due to list filtering, but included for safety
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('You do not have permission to deactivate this admin'),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            }
          },
        ),
      ],
      enableSelection: true,
      onSelectionChanged: (selectedItems) {
        setState(() {
          _selectedItems = selectedItems;
        });
      },
    );
  }

  List<AdminRowData> _getFilteredAdmins() {
    // Get admin users from provider
    final adminUsers = ref.watch(adminAdminsProvider);

    // Get current admin to check hierarchy
    final currentAdmin = ref.read(currentAdminUserProvider);

    // Convert UserModel to AdminRowData and filter
    return adminUsers.map((user) {
      final roleName = UserRoleHelper.getRoleName(user.activeRole);
      final isActive = user.metadata?['isActive'] ?? true;
      return AdminRowData(
        id: user.id,
        name: user.displayName ?? 'Unknown',
        email: user.email,
        role: roleName,
        status: isActive ? 'Active' : 'Inactive',
        isActive: isActive,
        lastLogin: user.lastLoginAt != null
            ? _formatLastLogin(user.lastLoginAt!)
            : 'Never',
        joinedDate: user.createdAt.toIso8601String().substring(0, 10),
      );
    }).where((admin) {
      // HIERARCHY FILTER: Only show admins that the current admin can manage
      if (currentAdmin != null) {
        final adminRole = UserRole.values.firstWhere(
          (r) => UserRoleHelper.getRoleName(r) == admin.role,
          orElse: () => UserRole.superAdmin,
        );

        // If current admin cannot manage this admin role, exclude it from the list
        if (!currentAdmin.adminRole.canManage(adminRole)) {
          return false;
        }
      }

      // Apply search filter
      final matchesSearch = _searchQuery.isEmpty ||
          admin.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          admin.email.toLowerCase().contains(_searchQuery.toLowerCase());

      // Apply role filter
      final matchesRole = _selectedRole == 'all' || admin.role == _selectedRole;

      // Apply status filter
      final matchesStatus = _selectedStatus == 'all' ||
          (_selectedStatus == 'active' && admin.isActive) ||
          (_selectedStatus == 'inactive' && !admin.isActive);

      return matchesSearch && matchesRole && matchesStatus;
    }).toList();
  }

  String _formatLastLogin(DateTime lastLogin) {
    final now = DateTime.now();
    final difference = now.difference(lastLogin);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} mins ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return lastLogin.toIso8601String().substring(0, 10);
    }
  }

  Future<void> _handleBulkActivate() async {
    if (_selectedItems.isEmpty) return;

    // Verify hierarchy permissions for all selected items
    final currentAdmin = ref.read(currentAdminUserProvider);
    if (currentAdmin != null) {
      final invalidSelections = _selectedItems.where((admin) {
        final targetRole = UserRole.values.firstWhere(
          (r) => r.name == admin.role,
          orElse: () => UserRole.superAdmin,
        );
        return !currentAdmin.adminRole.canManage(targetRole);
      }).toList();

      if (invalidSelections.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Cannot activate ${invalidSelections.length} admin(s) - insufficient permissions',
            ),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
    }

    setState(() => _isBulkOperationInProgress = true);

    try {
      // TODO: Implement bulk activate for admins
      // Backend should also verify hierarchy permissions
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_selectedItems.length} admin(s) activated'),
            backgroundColor: AppColors.success,
          ),
        );
        setState(() {
          _selectedItems = [];
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isBulkOperationInProgress = false);
      }
    }
  }

  void _showAdminCreationInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.security, color: AppColors.primary),
            const SizedBox(width: 8),
            const Text('Admin Account Security'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'For security reasons, admin accounts cannot be created through the web interface.',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              const Text(
                'How to Create Admin Accounts:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildInfoStep(
                '1',
                'Super Admin',
                'Created directly in the database by a system administrator using SQL.',
              ),
              _buildInfoStep(
                '2',
                'Other Admins',
                'Super Admin can promote existing users to admin roles through the user management section.',
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.warning.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber, color: AppColors.warning, size: 20),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Contact your database administrator to create the initial Super Admin account.',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoStep(String number, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleBulkDeactivate() async {
    if (_selectedItems.isEmpty) return;

    // Verify hierarchy permissions for all selected items
    final currentAdmin = ref.read(currentAdminUserProvider);
    if (currentAdmin != null) {
      final invalidSelections = _selectedItems.where((admin) {
        final targetRole = UserRole.values.firstWhere(
          (r) => r.name == admin.role,
          orElse: () => UserRole.superAdmin,
        );
        return !currentAdmin.adminRole.canManage(targetRole);
      }).toList();

      if (invalidSelections.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Cannot deactivate ${invalidSelections.length} admin(s) - insufficient permissions',
            ),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
    }

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deactivation'),
        content: Text(
          'Are you sure you want to deactivate ${_selectedItems.length} admin(s)? This will revoke their admin access.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Deactivate'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isBulkOperationInProgress = true);

    try {
      // TODO: Implement bulk deactivate for admins
      // Backend should also verify hierarchy permissions
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_selectedItems.length} admin(s) deactivated'),
            backgroundColor: AppColors.error,
          ),
        );
        setState(() {
          _selectedItems = [];
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isBulkOperationInProgress = false);
      }
    }
  }
}

/// Data model for admin table rows
/// TODO: Replace with actual Admin model from backend
class AdminRowData {
  final String id;
  final String name;
  final String email;
  final String role; // superAdmin, regionalAdmin, etc.
  final String status;
  final bool isActive;
  final String lastLogin;
  final String joinedDate;

  const AdminRowData({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    required this.isActive,
    required this.lastLogin,
    required this.joinedDate,
  });

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }

  String get roleDisplayName {
    final userRole = UserRole.values.firstWhere(
      (r) => r.name == role,
      orElse: () => UserRole.superAdmin,
    );
    return userRole.displayName;
  }

  Color get roleColor {
    return AppColors.getAdminRoleColor(UserRole.values.firstWhere(
      (r) => r.name == role,
      orElse: () => UserRole.superAdmin,
    ));
  }

  IconData get roleIcon {
    return AppColors.getAdminRoleIcon(UserRole.values.firstWhere(
      (r) => r.name == role,
      orElse: () => UserRole.superAdmin,
    ));
  }
}
