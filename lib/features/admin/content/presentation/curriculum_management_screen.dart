// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n_extension.dart';
import '../../shared/widgets/admin_data_table.dart';
import '../../shared/providers/admin_curriculum_provider.dart';
import '../../shared/providers/admin_course_list_provider.dart';
import '../../shared/utils/debouncer.dart';

/// Curriculum Management Screen - Manage modules across all courses
class CurriculumManagementScreen extends ConsumerStatefulWidget {
  const CurriculumManagementScreen({super.key});

  @override
  ConsumerState<CurriculumManagementScreen> createState() =>
      _CurriculumManagementScreenState();
}

class _CurriculumManagementScreenState
    extends ConsumerState<CurriculumManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  final _searchDebouncer = Debouncer(delay: const Duration(milliseconds: 500));
  String _searchQuery = '';
  String _selectedStatus = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    _searchDebouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        _buildStatsCards(),
        const SizedBox(height: 24),
        _buildFiltersSection(),
        const SizedBox(height: 24),
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
                  Icon(Icons.school, size: 32, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Text(
                    context.l10n.adminContentCurriculumManagement,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.adminContentManageModulesAndLessons,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
            ],
          ),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  ref.read(adminCurriculumProvider.notifier).fetchCurriculum();
                },
                icon: const Icon(Icons.refresh, size: 20),
                label: Text(context.l10n.adminContentRefresh),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _showCreateModuleDialog,
                icon: const Icon(Icons.add, size: 20),
                label: Text(context.l10n.adminContentCreateModule),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCreateModuleDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String? selectedCourseId;
    bool isCreating = false;

    // Pre-fetch courses
    ref.read(adminCourseListProvider.notifier).fetchCourses();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final courseListState = ref.watch(adminCourseListProvider);

          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.add_circle, color: AppColors.primary),
                const SizedBox(width: 12),
                Text(context.l10n.adminContentCreateNewModule),
              ],
            ),
            content: SizedBox(
              width: 500,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Course selector
                  DropdownButtonFormField<String>(
                    value: selectedCourseId,
                    decoration: InputDecoration(
                      labelText: context.l10n.adminContentCourseRequired,
                      hintText: courseListState.isLoading
                          ? context.l10n.adminContentLoadingCourses
                          : context.l10n.adminContentSelectCourse,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: courseListState.courses
                        .map((c) => DropdownMenuItem(
                              value: c.id,
                              child: Text(
                                c.title,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setDialogState(() => selectedCourseId = value);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: context.l10n.adminContentModuleTitleRequired,
                      hintText: context.l10n.adminContentEnterModuleTitle,
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
                      labelText: context.l10n.adminContentDescription,
                      hintText: context.l10n.adminContentEnterModuleDescription,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.adminContentModuleCreatedAsDraft,
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
                child: Text(context.l10n.adminContentCancel),
              ),
              ElevatedButton(
                onPressed: isCreating
                    ? null
                    : () async {
                        if (selectedCourseId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(context.l10n.adminContentPleaseSelectCourse),
                              backgroundColor: AppColors.error,
                            ),
                          );
                          return;
                        }
                        if (titleController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(context.l10n.adminContentPleaseEnterTitle),
                              backgroundColor: AppColors.error,
                            ),
                          );
                          return;
                        }

                        setDialogState(() => isCreating = true);

                        final success = await ref
                            .read(adminCurriculumProvider.notifier)
                            .createModule(
                              courseId: selectedCourseId!,
                              title: titleController.text.trim(),
                              description:
                                  descriptionController.text.trim().isEmpty
                                      ? null
                                      : descriptionController.text.trim(),
                            );

                        if (!context.mounted) return;
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(success
                                ? context.l10n.adminContentModuleCreated(titleController.text)
                                : context.l10n.adminContentFailedToCreateModule),
                            backgroundColor:
                                success ? AppColors.success : AppColors.error,
                          ),
                        );
                      },
                child: isCreating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(context.l10n.adminContentCreate),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatsCards() {
    final stats = ref.watch(adminCurriculumStatsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              context.l10n.adminContentTotalModules,
              stats.totalModules.toString(),
              context.l10n.adminContentAcrossAllCourses,
              Icons.view_module,
              AppColors.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              context.l10n.adminContentPublished,
              stats.publishedModules.toString(),
              context.l10n.adminContentLiveModules,
              Icons.check_circle,
              AppColors.success,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              context.l10n.adminContentDrafts,
              stats.draftModules.toString(),
              context.l10n.adminContentUnpublishedModules,
              Icons.edit_note,
              AppColors.warning,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              context.l10n.adminContentTotalLessons,
              stats.totalLessons.toString(),
              context.l10n.adminContentAllLessons,
              Icons.list_alt,
              Colors.purple,
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
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
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
          Expanded(
            flex: 2,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: context.l10n.adminContentSearchModules,
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
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: InputDecoration(
                labelText: context.l10n.adminContentStatus,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              items: [
                DropdownMenuItem(value: 'all', child: Text(context.l10n.adminContentAllStatus)),
                DropdownMenuItem(value: 'published', child: Text(context.l10n.adminContentPublished)),
                DropdownMenuItem(value: 'draft', child: Text(context.l10n.adminContentDraft)),
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
    final curriculumState = ref.watch(adminCurriculumProvider);
    final isLoading = curriculumState.isLoading;

    var items = curriculumState.modules.map((m) {
      return CurriculumRowData(
        id: m.id,
        courseId: m.courseId,
        title: m.title,
        courseTitle: m.courseTitle,
        lessonCount: m.lessonCount,
        duration: m.durationMinutes > 0 ? '${m.durationMinutes} min' : '-',
        isPublished: m.isPublished,
        lastUpdated: _formatDate(m.updatedAt ?? m.createdAt),
      );
    }).toList();

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      items = items.where((item) {
        return item.title.toLowerCase().contains(_searchQuery) ||
            item.courseTitle.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    // Apply status filter
    if (_selectedStatus == 'published') {
      items = items.where((item) => item.isPublished).toList();
    } else if (_selectedStatus == 'draft') {
      items = items.where((item) => !item.isPublished).toList();
    }

    return AdminDataTable<CurriculumRowData>(
      columns: [
        DataTableColumn(
          label: context.l10n.adminContentModuleTitle,
          cellBuilder: (item) => Text(
            item.title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          sortable: true,
        ),
        DataTableColumn(
          label: context.l10n.adminContentCourse,
          cellBuilder: (item) => Text(
            item.courseTitle,
            style: const TextStyle(fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataTableColumn(
          label: context.l10n.adminContentLessons,
          cellBuilder: (item) => Text(
            item.lessonCount.toString(),
            style: const TextStyle(fontSize: 13),
          ),
        ),
        DataTableColumn(
          label: context.l10n.adminContentDuration,
          cellBuilder: (item) => Text(
            item.duration,
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ),
        DataTableColumn(
          label: context.l10n.adminContentStatus,
          cellBuilder: (item) => _buildStatusChip(item.isPublished),
        ),
        DataTableColumn(
          label: context.l10n.adminContentUpdated,
          cellBuilder: (item) => Text(
            item.lastUpdated,
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          sortable: true,
        ),
      ],
      data: items,
      isLoading: isLoading,
      onRowTap: (item) => _showModuleDetails(item),
      rowActions: [
        DataTableAction(
          icon: Icons.visibility,
          tooltip: context.l10n.adminContentViewDetails,
          onPressed: (item) => _showModuleDetails(item),
        ),
        DataTableAction(
          icon: Icons.edit,
          tooltip: context.l10n.adminContentEditInBuilder,
          color: AppColors.primary,
          onPressed: (item) {
            context.go('/admin/content/${item.courseId}/edit');
          },
        ),
      ],
    );
  }

  Widget _buildStatusChip(bool isPublished) {
    final color = isPublished ? AppColors.success : AppColors.textSecondary;
    final label = isPublished ? context.l10n.adminContentPublished : context.l10n.adminContentDraft;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  void _showModuleDetails(CurriculumRowData item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.school, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(item.title, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(context.l10n.adminContentCourse, item.courseTitle),
              _buildDetailRow(context.l10n.adminContentLessons, item.lessonCount.toString()),
              _buildDetailRow(context.l10n.adminContentDuration, item.duration),
              _buildDetailRow(context.l10n.adminContentStatus, item.isPublished ? context.l10n.adminContentPublished : context.l10n.adminContentDraft),
              _buildDetailRow(context.l10n.adminContentLastUpdated, item.lastUpdated),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.adminContentClose),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              context.go('/admin/content/${item.courseId}/edit');
            },
            icon: const Icon(Icons.edit, size: 18),
            label: Text(context.l10n.adminContentEditInBuilder),
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
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

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
}

/// Row data model for the curriculum table
class CurriculumRowData {
  final String id;
  final String courseId;
  final String title;
  final String courseTitle;
  final int lessonCount;
  final String duration;
  final bool isPublished;
  final String lastUpdated;

  CurriculumRowData({
    required this.id,
    required this.courseId,
    required this.title,
    required this.courseTitle,
    required this.lessonCount,
    required this.duration,
    required this.isPublished,
    required this.lastUpdated,
  });
}
