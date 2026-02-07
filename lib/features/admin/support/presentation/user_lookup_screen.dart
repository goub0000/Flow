// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/constants/user_roles.dart';
import '../../shared/widgets/admin_data_table.dart';
import '../../shared/providers/admin_user_lookup_provider.dart';

/// User Lookup Screen - Search and view user details
class UserLookupScreen extends ConsumerStatefulWidget {
  const UserLookupScreen({super.key});

  @override
  ConsumerState<UserLookupScreen> createState() => _UserLookupScreenState();
}

class _UserLookupScreenState extends ConsumerState<UserLookupScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref.read(adminUserLookupProvider.notifier).searchUsers(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final lookupState = ref.watch(adminUserLookupProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        _buildSearchBar(),
        const SizedBox(height: 24),
        _buildStatsCards(lookupState),
        const SizedBox(height: 24),
        if (lookupState.error != null)
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
                      lookupState.error!,
                      style: TextStyle(color: AppColors.error, fontSize: 13),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, size: 18),
                    onPressed: () => ref.read(adminUserLookupProvider.notifier).fetchAllUsers(),
                    tooltip: 'Retry',
                  ),
                ],
              ),
            ),
          ),
        if (lookupState.error != null) const SizedBox(height: 24),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: _buildDataTable(lookupState.searchResults, lookupState.isLoading),
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
                  Icon(Icons.person_search, size: 32, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Text(
                    'User Lookup',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Search and view detailed user information',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
            ],
          ),
          IconButton(
            onPressed: () => ref.read(adminUserLookupProvider.notifier).fetchAllUsers(),
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search by name, email, ID, or role...',
          prefixIcon: const Icon(Icons.search, size: 24),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.border),
          ),
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        style: const TextStyle(fontSize: 16),
        onChanged: _onSearchChanged,
      ),
    );
  }

  Widget _buildStatsCards(AdminUserLookupState lookupState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(child: _buildStatCard('Total Users', '${lookupState.totalUsers}', 'All registered users', Icons.people, AppColors.primary)),
          const SizedBox(width: 16),
          Expanded(child: _buildStatCard('Active Users', '${lookupState.activeUsers}', 'Currently active', Icons.person, AppColors.success)),
          const SizedBox(width: 16),
          Expanded(child: _buildStatCard('Students', '${lookupState.studentCount}', 'Student accounts', Icons.school, AppColors.info)),
          const SizedBox(width: 16),
          Expanded(child: _buildStatCard('Institutions', '${lookupState.institutionCount}', 'Institution accounts', Icons.business, AppColors.warning)),
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

  Widget _buildDataTable(List<UserModel> users, bool isLoading) {
    return AdminDataTable<UserModel>(
      columns: [
        DataTableColumn(
          label: 'Name',
          cellBuilder: (user) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                backgroundImage: user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
                child: user.photoUrl == null
                    ? Text(
                        user.initials,
                        style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600),
                      )
                    : null,
              ),
              const SizedBox(width: 8),
              Text(
                user.displayName ?? 'Unknown',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ],
          ),
        ),
        DataTableColumn(
          label: 'Email',
          cellBuilder: (user) => Text(
            user.email,
            style: const TextStyle(fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataTableColumn(
          label: 'Role',
          cellBuilder: (user) => _buildRoleBadge(user.activeRole),
        ),
        DataTableColumn(
          label: 'Status',
          cellBuilder: (user) {
            final isActive = user.metadata?['isActive'] ?? true;
            return _buildStatusBadge(isActive == true);
          },
        ),
        DataTableColumn(
          label: 'Created',
          cellBuilder: (user) => Text(
            _formatDate(user.createdAt),
            style: const TextStyle(fontSize: 13),
          ),
          sortable: true,
        ),
        DataTableColumn(
          label: 'Last Login',
          cellBuilder: (user) => Text(
            user.lastLoginAt != null ? _timeSince(user.lastLoginAt!) : 'Never',
            style: TextStyle(
              fontSize: 13,
              color: user.lastLoginAt == null ? AppColors.textSecondary : AppColors.textPrimary,
              fontStyle: user.lastLoginAt == null ? FontStyle.italic : FontStyle.normal,
            ),
          ),
          sortable: true,
        ),
      ],
      data: users,
      isLoading: isLoading,
      onRowTap: (user) => _showUserDetails(user),
      rowActions: [
        DataTableAction(
          icon: Icons.visibility,
          tooltip: 'View Details',
          onPressed: (user) => _showUserDetails(user),
        ),
      ],
    );
  }

  Widget _buildRoleBadge(UserRole role) {
    final color = AppColors.getRoleColor(UserRoleHelper.getRoleName(role));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        role.displayName,
        style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildStatusBadge(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.success.withValues(alpha: 0.1)
            : AppColors.textSecondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: TextStyle(
          fontSize: 12,
          color: isActive ? AppColors.success : AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _timeSince(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }

  void _showUserDetails(UserModel user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              backgroundImage: user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
              child: user.photoUrl == null
                  ? Text(user.initials, style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600))
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.displayName ?? 'Unknown User', style: const TextStyle(fontSize: 18)),
                  Text(user.email, style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                ],
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 450,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(),
                _buildDetailRow('User ID', user.id),
                _buildDetailRow('Role', user.activeRole.displayName),
                _buildDetailRow('Email Verified', user.isEmailVerified ? 'Yes' : 'No'),
                _buildDetailRow('Phone', user.phoneNumber ?? 'Not provided'),
                _buildDetailRow('Phone Verified', user.isPhoneVerified ? 'Yes' : 'No'),
                _buildDetailRow('Created', _formatDate(user.createdAt)),
                _buildDetailRow('Last Login', user.lastLoginAt != null ? _formatDate(user.lastLoginAt!) : 'Never'),
                if (user.availableRoles.length > 1)
                  _buildDetailRow('Available Roles', user.availableRoles.map((r) => r.displayName).join(', ')),
                // Role-specific fields from metadata
                if (user.metadata != null) ...[
                  const SizedBox(height: 8),
                  Text('Additional Info', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primary)),
                  const SizedBox(height: 8),
                  ..._buildMetadataRows(user),
                ],
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
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

  List<Widget> _buildMetadataRows(UserModel user) {
    final meta = user.metadata!;
    final rows = <Widget>[];

    final fields = <String, String>{
      'school': 'School',
      'grade': 'Grade',
      'graduation_year': 'Graduation Year',
      'institution_type': 'Institution Type',
      'location': 'Location',
      'website': 'Website',
      'specialty': 'Specialty',
      'organization': 'Organization',
      'position': 'Position',
      'children_count': 'Children Count',
      'occupation': 'Occupation',
    };

    for (final entry in fields.entries) {
      final value = meta[entry.key];
      if (value != null && value.toString().isNotEmpty && value.toString() != 'null') {
        rows.add(_buildDetailRow(entry.value, value.toString()));
      }
    }

    return rows;
  }
}
