import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/admin_permissions.dart';
import '../../shared/widgets/admin_shell.dart';
import '../../shared/widgets/admin_data_table.dart';
import '../../shared/widgets/permission_guard.dart';
import '../../shared/widgets/export_dialog.dart';
import '../../shared/widgets/bulk_action_bar.dart';
import '../../shared/services/export_service.dart';
import '../../shared/services/bulk_operations_service.dart';
import '../../shared/utils/export_utils.dart';
import '../../shared/utils/debouncer.dart';
import '../../shared/providers/admin_users_provider.dart';

/// Recommenders List Screen - Manage recommender accounts
///
/// Features:
/// - View all recommenders (filtered by regional scope for Regional Admins)
/// - Search and filter recommenders
/// - View recommender details and recommendation stats
/// - Edit recommender profiles
/// - Deactivate/activate accounts
/// - Export recommender data
class RecommendersListScreen extends ConsumerStatefulWidget {
  const RecommendersListScreen({super.key});

  @override
  ConsumerState<RecommendersListScreen> createState() =>
      _RecommendersListScreenState();
}

class _RecommendersListScreenState
    extends ConsumerState<RecommendersListScreen> {
  // TODO: Replace with actual state management
  final TextEditingController _searchController = TextEditingController();
  final _searchDebouncer = Debouncer(delay: const Duration(milliseconds: 500));
  String _searchQuery = '';
  String _selectedStatus = 'all';
  String _selectedType = 'all';
  List<RecommenderRowData> _selectedItems = [];
  bool _isBulkOperationInProgress = false;

  @override
  void dispose() {
    _searchController.dispose();
    _searchDebouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch recommenders from backend
    // - API endpoint: GET /api/admin/users/recommenders
    // - Support pagination, filtering, search
    // - Filter by regional scope for Regional Admins
    // - Include: profile data, recommendation counts, organization

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
                'Recommenders',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Manage recommender accounts and recommendation requests',
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
                    final users = ref.read(adminRecommendersProvider);
                    await showExportDialog(
                      context: context,
                      title: 'Export Recommenders',
                      onExport: (format) => ExportService.exportRecommenders(
                        recommenders: users,
                        format: format,
                      ),
                    );
                  },
                  icon: const Icon(Icons.download, size: 20),
                  label: const Text('Export'),
                ),
              ),
              const SizedBox(width: 12),
              // Add recommender button (requires permission)
              PermissionGuard(
                permission: AdminPermission.editUsers,
                child: ElevatedButton.icon(
                  onPressed: () => context.go('/admin/users/recommenders/create'),
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text('Add Recommender'),
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
                hintText: 'Search by name, email, or recommender ID...',
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
          const SizedBox(width: 16),

          // Type Filter
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: InputDecoration(
                labelText: 'Type',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Types')),
                DropdownMenuItem(value: 'teacher', child: Text('Teacher')),
                DropdownMenuItem(value: 'professor', child: Text('Professor')),
                DropdownMenuItem(value: 'employer', child: Text('Employer')),
                DropdownMenuItem(value: 'mentor', child: Text('Mentor')),
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
    // Get users from provider and convert to RecommenderRowData
    final users = ref.watch(adminRecommendersProvider);
    var recommenders = users.map((user) {
      // Extract metadata fields if available
      final metadata = user.metadata ?? {};
      return RecommenderRowData(
        id: user.id,
        name: user.displayName ?? 'Unknown Recommender',
        email: user.email,
        recommenderId: 'REC${user.id.substring(0, 6).toUpperCase()}',
        type: metadata['recommender_type']?.toString() ?? 'Not specified',
        organization: metadata['organization']?.toString() ?? 'Not specified',
        requests: (metadata['requests_count'] as int?) ?? 0,
        completed: (metadata['completed_count'] as int?) ?? 0,
        status: metadata['isActive'] == true ? 'active' : 'inactive',
        joinedDate: _formatDate(user.createdAt),
      );
    }).toList();

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      recommenders = recommenders.where((recommender) {
        return recommender.name.toLowerCase().contains(_searchQuery) ||
            recommender.email.toLowerCase().contains(_searchQuery) ||
            recommender.recommenderId.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    // Apply status filter
    if (_selectedStatus != 'all') {
      recommenders = recommenders.where((recommender) => recommender.status == _selectedStatus).toList();
    }

    // Apply type filter
    if (_selectedType != 'all') {
      recommenders = recommenders.where((recommender) => recommender.type.toLowerCase() == _selectedType).toList();
    }

    return AdminDataTable<RecommenderRowData>(
      columns: [
        DataTableColumn(
          label: 'Recommender',
          cellBuilder: (recommender) => Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.success.withValues(alpha: 0.1),
                child: Text(
                  recommender.initials,
                  style: TextStyle(
                    color: AppColors.success,
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
                    recommender.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    recommender.email,
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
          label: 'Recommender ID',
          cellBuilder: (recommender) => Text(recommender.recommenderId),
        ),
        DataTableColumn(
          label: 'Type',
          cellBuilder: (recommender) => Text(recommender.type),
        ),
        DataTableColumn(
          label: 'Organization',
          cellBuilder: (recommender) => Text(
            recommender.organization,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataTableColumn(
          label: 'Requests',
          cellBuilder: (recommender) => Text(recommender.requests.toString()),
        ),
        DataTableColumn(
          label: 'Completed',
          cellBuilder: (recommender) => Text(recommender.completed.toString()),
        ),
        DataTableColumn(
          label: 'Status',
          cellBuilder: (recommender) => _buildStatusChip(recommender.status),
        ),
        DataTableColumn(
          label: 'Joined',
          cellBuilder: (recommender) => Text(recommender.joinedDate),
        ),
      ],
      data: recommenders,
      isLoading: false, // TODO: Set from actual loading state
      enableSelection: true,
      onSelectionChanged: (selectedItems) {
        setState(() => _selectedItems = selectedItems);
      },
      onRowTap: (recommender) {
        // TODO: Navigate to recommender detail screen
        _showRecommenderDetails(recommender);
      },
      rowActions: [
        DataTableAction(
          icon: Icons.visibility,
          tooltip: 'View Details',
          onPressed: (recommender) {
            // TODO: Navigate to recommender detail screen
            _showRecommenderDetails(recommender);
          },
        ),
        DataTableAction(
          icon: Icons.edit,
          tooltip: 'Edit Recommender',
          onPressed: (recommender) {
            // TODO: Navigate to edit recommender screen
          },
        ),
        DataTableAction(
          icon: Icons.block,
          tooltip: 'Deactivate Account',
          color: AppColors.error,
          onPressed: (recommender) {
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

  void _showRecommenderDetails(RecommenderRowData recommender) {
    // Navigate to recommender detail screen
    context.go('/admin/users/recommenders/${recommender.id}');
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
        title: const Text('Activate Recommenders'),
        content: Text('Are you sure you want to activate ${_selectedItems.length} recommender(s)?'),
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
        title: const Text('Deactivate Recommenders'),
        content: Text('Are you sure you want to deactivate ${_selectedItems.length} recommender(s)?'),
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
/// TODO: Replace with actual Recommender model from backend
class RecommenderRowData {
  final String id;
  final String name;
  final String email;
  final String recommenderId;
  final String type;
  final String organization;
  final int requests;
  final int completed;
  final String status;
  final String joinedDate;

  RecommenderRowData({
    required this.id,
    required this.name,
    required this.email,
    required this.recommenderId,
    required this.type,
    required this.organization,
    required this.requests,
    required this.completed,
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
