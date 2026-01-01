import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/admin_permissions.dart';
import '../../shared/widgets/admin_shell.dart';
import '../../shared/widgets/admin_data_table.dart';
import '../../shared/widgets/permission_guard.dart';
import '../../shared/providers/admin_content_provider.dart';
import '../../shared/utils/debouncer.dart';

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
  final String? initialTypeFilter;
  final String? pageTitle;

  const ContentManagementScreen({
    super.key,
    this.initialTypeFilter,
    this.pageTitle,
  });

  @override
  ConsumerState<ContentManagementScreen> createState() =>
      _ContentManagementScreenState();
}

class _ContentManagementScreenState
    extends ConsumerState<ContentManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  final _searchDebouncer = Debouncer(delay: const Duration(milliseconds: 500));
  String _searchQuery = '';
  String _selectedStatus = 'all';
  late String _selectedType;
  String _selectedSubject = 'all';

  @override
  void initState() {
    super.initState();
    // Valid types from database: video, text, interactive, live, hybrid
    const validTypes = ['all', 'video', 'text', 'interactive', 'live', 'hybrid'];
    final initialType = widget.initialTypeFilter ?? 'all';
    _selectedType = validTypes.contains(initialType) ? initialType : 'all';
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchDebouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
    final title = widget.pageTitle ?? 'Content Management';
    final subtitle = _getSubtitle();

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
                    _getHeaderIcon(),
                    size: 32,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Export feature coming soon')),
                    );
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
                  onPressed: _showCreateContentDialog,
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

  IconData _getHeaderIcon() {
    switch (widget.initialTypeFilter) {
      case 'video':
        return Icons.play_circle;
      case 'text':
        return Icons.article;
      case 'interactive':
        return Icons.touch_app;
      case 'live':
        return Icons.live_tv;
      case 'hybrid':
        return Icons.layers;
      default:
        return Icons.library_books;
    }
  }

  String _getSubtitle() {
    switch (widget.initialTypeFilter) {
      case 'video':
        return 'Manage video courses and tutorials';
      case 'text':
        return 'Manage text-based learning materials';
      case 'interactive':
        return 'Manage interactive learning content';
      case 'live':
        return 'Manage live sessions and webinars';
      case 'hybrid':
        return 'Manage hybrid learning experiences';
      default:
        return 'Manage educational content, courses, and curriculum';
    }
  }

  void _showCreateContentDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    // course_type must be: video, text, interactive, live, hybrid (database constraint)
    String selectedType = 'video';
    String selectedCategory = 'technology';
    String selectedLevel = 'beginner';
    bool isCreating = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.add_circle, color: AppColors.primary),
              const SizedBox(width: 12),
              const Text('Create New Content'),
            ],
          ),
          content: SizedBox(
            width: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Title *',
                    hintText: 'Enter content title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter content description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedType,
                        decoration: InputDecoration(
                          labelText: 'Type *',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'video', child: Text('Video Course')),
                          DropdownMenuItem(value: 'text', child: Text('Text Course')),
                          DropdownMenuItem(value: 'interactive', child: Text('Interactive')),
                          DropdownMenuItem(value: 'live', child: Text('Live Session')),
                          DropdownMenuItem(value: 'hybrid', child: Text('Hybrid')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setDialogState(() => selectedType = value);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedLevel,
                        decoration: InputDecoration(
                          labelText: 'Level *',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'beginner', child: Text('Beginner')),
                          DropdownMenuItem(value: 'intermediate', child: Text('Intermediate')),
                          DropdownMenuItem(value: 'advanced', child: Text('Advanced')),
                          DropdownMenuItem(value: 'expert', child: Text('Expert')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setDialogState(() => selectedLevel = value);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'technology', child: Text('Technology')),
                    DropdownMenuItem(value: 'business', child: Text('Business')),
                    DropdownMenuItem(value: 'science', child: Text('Science')),
                    DropdownMenuItem(value: 'arts', child: Text('Arts')),
                    DropdownMenuItem(value: 'education', child: Text('Education')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() => selectedCategory = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Content will be created as a draft. You can edit and publish it later.',
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
              onPressed: isCreating ? null : () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: isCreating ? null : () async {
                if (titleController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Please enter a title'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                  return;
                }

                setDialogState(() => isCreating = true);

                final success = await ref.read(adminContentProvider.notifier).createContent(
                  title: titleController.text.trim(),
                  description: descriptionController.text.trim().isEmpty
                      ? null
                      : descriptionController.text.trim(),
                  type: selectedType,
                  category: selectedCategory,
                  level: selectedLevel,
                );

                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success
                          ? 'Created "${titleController.text}" as draft'
                          : 'Failed to create content'),
                      backgroundColor: success ? AppColors.success : AppColors.error,
                    ),
                  );
                }
              },
              child: isCreating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCards() {
    final stats = ref.watch(adminContentStatisticsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total Content',
              stats.total.toString(),
              'All content items',
              Icons.library_books,
              AppColors.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'Published',
              stats.published.toString(),
              'Live content',
              Icons.check_circle,
              AppColors.success,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'Pending Approval',
              stats.pending.toString(),
              'Awaiting review',
              Icons.pending,
              AppColors.warning,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'Draft',
              stats.draft.toString(),
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
                DropdownMenuItem(value: 'published', child: Text('Published')),
                DropdownMenuItem(value: 'pending', child: Text('Pending Approval')),
                DropdownMenuItem(value: 'draft', child: Text('Draft')),
                DropdownMenuItem(value: 'archived', child: Text('Archived')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedStatus = value);
                }
              },
            ),
          ),
          const SizedBox(width: 16),

          // Type Filter (matches database: video, text, interactive, live, hybrid)
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
                DropdownMenuItem(value: 'video', child: Text('Video')),
                DropdownMenuItem(value: 'text', child: Text('Text')),
                DropdownMenuItem(value: 'interactive', child: Text('Interactive')),
                DropdownMenuItem(value: 'live', child: Text('Live')),
                DropdownMenuItem(value: 'hybrid', child: Text('Hybrid')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedType = value);
                }
              },
            ),
          ),
          const SizedBox(width: 16),

          // Category Filter
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedSubject,
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
                DropdownMenuItem(value: 'technology', child: Text('Technology')),
                DropdownMenuItem(value: 'business', child: Text('Business')),
                DropdownMenuItem(value: 'science', child: Text('Science')),
                DropdownMenuItem(value: 'arts', child: Text('Arts')),
                DropdownMenuItem(value: 'education', child: Text('Education')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedSubject = value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    // Get content from provider
    final contentState = ref.watch(adminContentProvider);
    final isLoading = contentState.isLoading;

    // Apply local filters
    var contentItems = contentState.content.map((item) {
      return ContentRowData(
        id: item.id,
        title: item.title,
        subtitle: item.description ?? '',
        type: item.type,
        subject: item.category ?? 'Uncategorized',
        author: item.authorName ?? item.institutionName ?? 'Unknown',
        status: item.status,
        version: 'v1.0',
        translations: 1,
        lastUpdated: _formatDate(item.updatedAt ?? item.createdAt),
      );
    }).toList();

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      contentItems = contentItems.where((content) {
        return content.title.toLowerCase().contains(_searchQuery) ||
            content.author.toLowerCase().contains(_searchQuery) ||
            content.subject.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    // Apply status filter
    if (_selectedStatus != 'all') {
      contentItems = contentItems.where((content) => content.status == _selectedStatus).toList();
    }

    // Apply type filter
    if (_selectedType != 'all') {
      contentItems = contentItems.where((content) => content.type == _selectedType).toList();
    }

    // Apply category filter
    if (_selectedSubject != 'all') {
      contentItems = contentItems.where((content) =>
          content.subject.toLowerCase() == _selectedSubject.toLowerCase()).toList();
    }

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
              if (content.subtitle.isNotEmpty)
                Text(
                  content.subtitle,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
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
          label: 'Category',
          cellBuilder: (content) => Text(
            content.subject,
            style: const TextStyle(fontSize: 13),
          ),
        ),
        DataTableColumn(
          label: 'Author/Institution',
          cellBuilder: (content) => Text(
            content.author,
            style: const TextStyle(fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataTableColumn(
          label: 'Status',
          cellBuilder: (content) => _buildStatusChip(content.status),
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
      isLoading: isLoading,
      enableSelection: true,
      onSelectionChanged: (selectedItems) {
        // Handle bulk actions on selected items
      },
      onRowTap: (content) {
        _showContentDetails(content);
      },
      rowActions: [
        DataTableAction(
          icon: Icons.visibility,
          tooltip: 'Preview',
          onPressed: (content) {
            _showContentDetails(content);
          },
        ),
        DataTableAction(
          icon: Icons.person_add,
          tooltip: 'Assign',
          color: AppColors.primary,
          onPressed: (content) {
            _showAssignContentDialog(content);
          },
        ),
        DataTableAction(
          icon: Icons.check_circle,
          tooltip: 'Approve/Publish',
          color: AppColors.success,
          onPressed: (content) {
            _showApprovalDialog(content);
          },
        ),
        DataTableAction(
          icon: Icons.archive,
          tooltip: 'Archive',
          color: AppColors.warning,
          onPressed: (content) {
            _showArchiveDialog(content);
          },
        ),
        DataTableAction(
          icon: Icons.delete,
          tooltip: 'Delete',
          color: AppColors.error,
          onPressed: (content) {
            _showDeleteDialog(content);
          },
        ),
      ],
    );
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

  /// Show archive confirmation dialog
  void _showArchiveDialog(ContentRowData content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.archive,
              color: AppColors.warning,
            ),
            const SizedBox(width: 12),
            const Text('Archive Content'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to archive "${content.title}"?',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Text(
              'Archived content will not be visible to users.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
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
            onPressed: () async {
              Navigator.pop(context);
              final success = await ref.read(adminContentProvider.notifier)
                  .archiveContent(content.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success
                        ? 'Content archived successfully'
                        : 'Failed to archive content'),
                    backgroundColor: success ? AppColors.success : AppColors.error,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warning,
            ),
            child: const Text('Archive'),
          ),
        ],
      ),
    );
  }

  /// Show assign content dialog
  void _showAssignContentDialog(ContentRowData content) {
    String selectedTargetType = 'all_students';
    bool isRequired = false;
    bool isAssigning = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.person_add, color: AppColors.primary),
              const SizedBox(width: 12),
              const Expanded(
                child: Text('Assign Content'),
              ),
            ],
          ),
          content: SizedBox(
            width: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Content being assigned
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(_getTypeIcon(content.type), color: AppColors.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              content.title,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${content.type} • ${content.subject}',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Target type selection
                Text(
                  'Assign to:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedTargetType,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'all_students',
                      child: Row(
                        children: [
                          Icon(Icons.groups, size: 20),
                          SizedBox(width: 8),
                          Text('All Students'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'institution',
                      child: Row(
                        children: [
                          Icon(Icons.business, size: 20),
                          SizedBox(width: 8),
                          Text('Specific Institutions'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'student',
                      child: Row(
                        children: [
                          Icon(Icons.person, size: 20),
                          SizedBox(width: 8),
                          Text('Specific Students'),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() => selectedTargetType = value);
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Required toggle
                SwitchListTile(
                  title: const Text('Required'),
                  subtitle: Text(
                    isRequired
                        ? 'This content is mandatory for assigned users'
                        : 'This content is optional for assigned users',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  value: isRequired,
                  onChanged: (value) {
                    setDialogState(() => isRequired = value);
                  },
                  activeColor: AppColors.primary,
                  contentPadding: EdgeInsets.zero,
                ),

                const SizedBox(height: 12),
                if (selectedTargetType != 'all_students')
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.warning.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline,
                            size: 20, color: AppColors.warning),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Individual selection coming soon. For now, use "All Students" to assign to everyone.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
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
              onPressed: isAssigning ? null : () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              onPressed: isAssigning
                  ? null
                  : () async {
                      setDialogState(() => isAssigning = true);

                      final success = await ref
                          .read(adminContentProvider.notifier)
                          .assignContent(
                            contentId: content.id,
                            targetType: selectedTargetType,
                            isRequired: isRequired,
                          );

                      if (mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(success
                                ? 'Content assigned successfully'
                                : 'Failed to assign content'),
                            backgroundColor:
                                success ? AppColors.success : AppColors.error,
                          ),
                        );
                      }
                    },
              icon: isAssigning
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.send, size: 18),
              label: Text(isAssigning ? 'Assigning...' : 'Assign'),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'video':
        return Icons.play_circle;
      case 'text':
        return Icons.article;
      case 'interactive':
        return Icons.touch_app;
      case 'live':
        return Icons.live_tv;
      case 'hybrid':
        return Icons.layers;
      default:
        return Icons.school;
    }
  }

  Widget _buildTypeChip(String type) {
    Color color;
    IconData icon;

    switch (type.toLowerCase()) {
      case 'video':
        color = AppColors.primary;
        icon = Icons.play_circle;
        break;
      case 'text':
        color = AppColors.success;
        icon = Icons.article;
        break;
      case 'interactive':
        color = AppColors.warning;
        icon = Icons.touch_app;
        break;
      case 'live':
        color = AppColors.error;
        icon = Icons.live_tv;
        break;
      case 'hybrid':
        color = Colors.purple;
        icon = Icons.layers;
        break;
      default:
        color = AppColors.textSecondary;
        icon = Icons.school;
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
            _buildDetailRow('Status', content.status),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await ref.read(adminContentProvider.notifier)
                  .rejectContent(content.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success
                        ? 'Content rejected - set to draft'
                        : 'Failed to reject content'),
                    backgroundColor: success ? AppColors.warning : AppColors.error,
                  ),
                );
              }
            },
            child: Text(
              'Reject',
              style: TextStyle(color: AppColors.error),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await ref.read(adminContentProvider.notifier)
                  .approveContent(content.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success
                        ? 'Content approved and published'
                        : 'Failed to approve content'),
                    backgroundColor: success ? AppColors.success : AppColors.error,
                  ),
                );
              }
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
              'This will archive the content. It can be restored later.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
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
            onPressed: () async {
              Navigator.pop(context);
              final success = await ref.read(adminContentProvider.notifier)
                  .deleteContent(content.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success
                        ? 'Content deleted successfully'
                        : 'Failed to delete content'),
                    backgroundColor: success ? AppColors.success : AppColors.error,
                  ),
                );
              }
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
