import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/admin_permissions.dart';
import '../../shared/widgets/admin_shell.dart';
import '../../shared/widgets/admin_data_table.dart';
import '../../shared/widgets/permission_guard.dart';

/// Content Management Screen - Manage educational content and curriculum
///
/// Features:
/// - View all educational content (courses, lessons, resources)
/// - Create, edit, and delete content
/// - Content approval workflow
/// - Version management
/// - Translation management
/// - Content categorization and tagging
/// - Preview content before publishing
class ContentManagementScreen extends ConsumerStatefulWidget {
  const ContentManagementScreen({super.key});

  @override
  ConsumerState<ContentManagementScreen> createState() =>
      _ContentManagementScreenState();
}

class _ContentManagementScreenState
    extends ConsumerState<ContentManagementScreen> {
  // TODO: Replace with actual state management
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'all';
  String _selectedType = 'all';
  String _selectedSubject = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch content from backend
    // - API endpoint: GET /api/admin/content
    // - Support pagination, filtering, search
    // - Include: content metadata, author, status, translations
    // - Filter based on admin permissions (content admins see all)

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
                    Icons.library_books,
                    size: 32,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Content Management',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Manage educational content, courses, and curriculum',
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
                permission: AdminPermission.exportData,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Implement export functionality
                    // - Generate CSV/Excel file
                    // - Include content metadata
                    // - Trigger download
                  },
                  icon: const Icon(Icons.download, size: 20),
                  label: const Text('Export'),
                ),
              ),
              const SizedBox(width: 12),
              // Create content button (requires permission)
              PermissionGuard(
                permission: AdminPermission.createContent,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Navigate to content creation screen
                  },
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text('Create Content'),
                ),
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
              'Total Content',
              '0', // TODO: Replace with actual data
              'All content items',
              Icons.library_books,
              AppColors.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'Published',
              '0', // TODO: Replace with actual data
              'Live content',
              Icons.check_circle,
              AppColors.success,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'Pending Approval',
              '0', // TODO: Replace with actual data
              'Awaiting review',
              Icons.pending,
              AppColors.warning,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'Draft',
              '0', // TODO: Replace with actual data
              'In progress',
              Icons.edit_note,
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
                hintText: 'Search by title, author, or keywords...',
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
                DropdownMenuItem(value: 'published', child: Text('Published')),
                DropdownMenuItem(value: 'pending', child: Text('Pending Approval')),
                DropdownMenuItem(value: 'draft', child: Text('Draft')),
                DropdownMenuItem(value: 'archived', child: Text('Archived')),
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
                DropdownMenuItem(value: 'course', child: Text('Course')),
                DropdownMenuItem(value: 'lesson', child: Text('Lesson')),
                DropdownMenuItem(value: 'resource', child: Text('Resource')),
                DropdownMenuItem(value: 'assessment', child: Text('Assessment')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedType = value);
                  // TODO: Apply filter and reload data
                }
              },
            ),
          ),
          const SizedBox(width: 16),

          // Subject Filter
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedSubject,
              decoration: InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Subjects')),
                DropdownMenuItem(value: 'mathematics', child: Text('Mathematics')),
                DropdownMenuItem(value: 'science', child: Text('Science')),
                DropdownMenuItem(value: 'english', child: Text('English')),
                DropdownMenuItem(value: 'history', child: Text('History')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedSubject = value);
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
    final List<ContentRowData> contentItems = [];

    return AdminDataTable<ContentRowData>(
      columns: [
        DataTableColumn(
          label: 'Title',
          cellBuilder: (content) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                content.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                content.subtitle,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          sortable: true,
        ),
        DataTableColumn(
          label: 'Type',
          cellBuilder: (content) => _buildTypeChip(content.type),
        ),
        DataTableColumn(
          label: 'Subject',
          cellBuilder: (content) => Text(
            content.subject,
            style: const TextStyle(fontSize: 13),
          ),
        ),
        DataTableColumn(
          label: 'Author',
          cellBuilder: (content) => Text(
            content.author,
            style: const TextStyle(fontSize: 13),
          ),
        ),
        DataTableColumn(
          label: 'Status',
          cellBuilder: (content) => _buildStatusChip(content.status),
        ),
        DataTableColumn(
          label: 'Version',
          cellBuilder: (content) => Text(
            content.version,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
        ),
        DataTableColumn(
          label: 'Translations',
          cellBuilder: (content) => Text(
            content.translations.toString(),
            style: const TextStyle(fontSize: 13),
          ),
        ),
        DataTableColumn(
          label: 'Last Updated',
          cellBuilder: (content) => Text(
            content.lastUpdated,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          sortable: true,
        ),
      ],
      data: contentItems,
      isLoading: false, // TODO: Set from actual loading state
      enableSelection: true,
      onSelectionChanged: (selectedItems) {
        // TODO: Handle bulk actions on selected items
      },
      onRowTap: (content) {
        _showContentDetails(content);
      },
      rowActions: [
        DataTableAction(
          icon: Icons.visibility,
          tooltip: 'Preview',
          onPressed: (content) {
            // TODO: Preview content
          },
        ),
        DataTableAction(
          icon: Icons.edit,
          tooltip: 'Edit',
          onPressed: (content) {
            // TODO: Navigate to edit screen
          },
        ),
        DataTableAction(
          icon: Icons.check_circle,
          tooltip: 'Approve',
          color: AppColors.success,
          onPressed: (content) {
            // TODO: Show approval dialog (requires AdminPermission.approveContent)
            _showApprovalDialog(content);
          },
        ),
        DataTableAction(
          icon: Icons.translate,
          tooltip: 'Manage Translations',
          onPressed: (content) {
            // TODO: Navigate to translation management
          },
        ),
        DataTableAction(
          icon: Icons.delete,
          tooltip: 'Delete',
          color: AppColors.error,
          onPressed: (content) {
            // TODO: Show delete confirmation (requires AdminPermission.deleteContent)
            _showDeleteDialog(content);
          },
        ),
      ],
    );
  }

  Widget _buildTypeChip(String type) {
    Color color;
    IconData icon;

    switch (type.toLowerCase()) {
      case 'course':
        color = AppColors.primary;
        icon = Icons.school;
        break;
      case 'lesson':
        color = AppColors.success;
        icon = Icons.class_;
        break;
      case 'resource':
        color = AppColors.warning;
        icon = Icons.description;
        break;
      case 'assessment':
        color = AppColors.error;
        icon = Icons.quiz;
        break;
      default:
        color = AppColors.textSecondary;
        icon = Icons.article;
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
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            type,
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
      case 'published':
        color = AppColors.success;
        label = 'Published';
        break;
      case 'pending':
        color = AppColors.warning;
        label = 'Pending';
        break;
      case 'draft':
        color = AppColors.textSecondary;
        label = 'Draft';
        break;
      case 'archived':
        color = AppColors.error;
        label = 'Archived';
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

  void _showContentDetails(ContentRowData content) {
    // TODO: Implement content details modal/screen
    // - Full content metadata
    // - Preview of content
    // - Version history
    // - Translation status
    // - Usage statistics
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.article,
              color: AppColors.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                content.title,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 600,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Type', content.type),
              _buildDetailRow('Subject', content.subject),
              _buildDetailRow('Author', content.author),
              _buildDetailRow('Status', content.status),
              _buildDetailRow('Version', content.version),
              _buildDetailRow('Translations', content.translations.toString()),
              _buildDetailRow('Last Updated', content.lastUpdated),
              const SizedBox(height: 16),
              Text(
                'Full content details and preview will be available with backend integration.',
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
            child: const Text('Close'),
          ),
          PermissionGuard(
            permission: AdminPermission.editContent,
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Navigate to edit screen
              },
              child: const Text('Edit'),
            ),
          ),
        ],
      ),
    );
  }

  void _showApprovalDialog(ContentRowData content) {
    // TODO: Implement content approval dialog
    // - Review content
    // - Add approval notes
    // - Approve or reject
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: AppColors.success,
            ),
            const SizedBox(width: 12),
            const Text('Approve Content'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Approve "${content.title}" for publication?',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Type', content.type),
            _buildDetailRow('Author', content.author),
            _buildDetailRow('Version', content.version),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Reject content
              Navigator.pop(context);
            },
            child: Text(
              'Reject',
              style: TextStyle(color: AppColors.error),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Approve content
              // - Update content status
              // - Notify author
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Content will be approved with backend integration'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
            ),
            child: const Text('Approve'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(ContentRowData content) {
    // TODO: Implement content deletion dialog
    // - Confirm deletion
    // - Check for dependencies
    // - Soft delete vs hard delete
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.warning,
              color: AppColors.error,
            ),
            const SizedBox(width: 12),
            const Text('Delete Content'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to delete "${content.title}"?',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Text(
              'This action cannot be undone.',
              style: TextStyle(
                color: AppColors.error,
                fontSize: 12,
                fontWeight: FontWeight.w600,
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
              // TODO: Delete content
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Content will be deleted with backend integration'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Delete'),
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
/// TODO: Replace with actual Content model from backend
class ContentRowData {
  final String id;
  final String title;
  final String subtitle;
  final String type;
  final String subject;
  final String author;
  final String status;
  final String version;
  final int translations;
  final String lastUpdated;

  ContentRowData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.subject,
    required this.author,
    required this.status,
    required this.version,
    required this.translations,
    required this.lastUpdated,
  });
}
