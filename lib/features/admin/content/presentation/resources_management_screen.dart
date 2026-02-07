// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n_extension.dart';
import '../../shared/widgets/admin_data_table.dart';
import '../../shared/providers/admin_resources_provider.dart';
import '../../shared/providers/admin_course_list_provider.dart';
import '../../shared/utils/debouncer.dart';

/// Resources Management Screen - Manage video and text content across all courses
class ResourcesManagementScreen extends ConsumerStatefulWidget {
  const ResourcesManagementScreen({super.key});

  @override
  ConsumerState<ResourcesManagementScreen> createState() =>
      _ResourcesManagementScreenState();
}

class _ResourcesManagementScreenState
    extends ConsumerState<ResourcesManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  final _searchDebouncer = Debouncer(delay: const Duration(milliseconds: 500));
  String _searchQuery = '';
  String _selectedType = 'all';

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
                  Icon(Icons.folder, size: 32, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Text(
                    context.l10n.adminContentResourcesManagement,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.adminContentManageVideoAndText,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
            ],
          ),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  ref.read(adminResourcesProvider.notifier).fetchResources();
                },
                icon: const Icon(Icons.refresh, size: 20),
                label: Text(context.l10n.adminContentRefresh),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _showCreateResourceDialog,
                icon: const Icon(Icons.add, size: 20),
                label: Text(context.l10n.adminContentCreateResource),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCreateResourceDialog() {
    final lessonTitleController = TextEditingController();
    final videoUrlController = TextEditingController();
    final textContentController = TextEditingController();
    String selectedType = 'video';
    String? selectedCourseId;
    String? selectedModuleId;
    List<ModuleListItem> modules = [];
    bool isCreating = false;
    bool isLoadingModules = false;

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
                Text(context.l10n.adminContentCreateNewResource),
              ],
            ),
            content: SizedBox(
              width: 550,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Resource type
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: InputDecoration(
                        labelText: context.l10n.adminContentResourceTypeRequired,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items: [
                        DropdownMenuItem(value: 'video', child: Text(context.l10n.adminContentVideo)),
                        DropdownMenuItem(value: 'text', child: Text(context.l10n.adminContentTextContent)),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() => selectedType = value);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
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
                                child: Text(c.title,
                                    overflow: TextOverflow.ellipsis),
                              ))
                          .toList(),
                      onChanged: (value) async {
                        setDialogState(() {
                          selectedCourseId = value;
                          selectedModuleId = null;
                          modules = [];
                          isLoadingModules = true;
                        });
                        if (value != null) {
                          final fetched = await ref
                              .read(adminCourseListProvider.notifier)
                              .fetchModules(value);
                          setDialogState(() {
                            modules = fetched;
                            isLoadingModules = false;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    // Module selector
                    DropdownButtonFormField<String>(
                      value: selectedModuleId,
                      decoration: InputDecoration(
                        labelText: context.l10n.adminContentModuleRequired,
                        hintText: isLoadingModules
                            ? context.l10n.adminContentLoadingModules
                            : selectedCourseId == null
                                ? context.l10n.adminContentSelectCourseFirst
                                : modules.isEmpty
                                    ? context.l10n.adminContentNoModulesInCourse
                                    : context.l10n.adminContentSelectModule,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items: modules
                          .map((m) => DropdownMenuItem(
                                value: m.id,
                                child: Text(m.title,
                                    overflow: TextOverflow.ellipsis),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setDialogState(() => selectedModuleId = value);
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: lessonTitleController,
                      decoration: InputDecoration(
                        labelText: context.l10n.adminContentLessonTitleRequired,
                        hintText: context.l10n.adminContentEnterLessonTitle,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Type-specific fields
                    if (selectedType == 'video') ...[
                      TextField(
                        controller: videoUrlController,
                        decoration: InputDecoration(
                          labelText: context.l10n.adminContentVideoUrlRequired,
                          hintText: context.l10n.adminContentVideoUrlHint,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ] else ...[
                      TextField(
                        controller: textContentController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: context.l10n.adminContentContentRequired,
                          hintText: context.l10n.adminContentEnterTextContent,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Text(
                      context.l10n.adminContentResourceCreatedAsDraft,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
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
                        if (selectedCourseId == null ||
                            selectedModuleId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text(context.l10n.adminContentPleaseSelectCourseAndModule),
                              backgroundColor: AppColors.error,
                            ),
                          );
                          return;
                        }
                        if (lessonTitleController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(context.l10n.adminContentPleaseEnterLessonTitle),
                              backgroundColor: AppColors.error,
                            ),
                          );
                          return;
                        }
                        if (selectedType == 'video' &&
                            videoUrlController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(context.l10n.adminContentPleaseEnterVideoUrl),
                              backgroundColor: AppColors.error,
                            ),
                          );
                          return;
                        }
                        if (selectedType == 'text' &&
                            textContentController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(context.l10n.adminContentPleaseEnterContent),
                              backgroundColor: AppColors.error,
                            ),
                          );
                          return;
                        }

                        setDialogState(() => isCreating = true);

                        final success = await ref
                            .read(adminResourcesProvider.notifier)
                            .createResource(
                              resourceType: selectedType,
                              courseId: selectedCourseId!,
                              moduleId: selectedModuleId!,
                              lessonTitle:
                                  lessonTitleController.text.trim(),
                              videoUrl: selectedType == 'video'
                                  ? videoUrlController.text.trim()
                                  : null,
                              content: selectedType == 'text'
                                  ? textContentController.text.trim()
                                  : null,
                            );

                        if (!context.mounted) return;
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(success
                                ? (selectedType == 'video' ? context.l10n.adminContentVideoResourceCreated : context.l10n.adminContentTextResourceCreated)
                                : context.l10n.adminContentFailedToCreateResource),
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
    final stats = ref.watch(adminResourcesStatsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              context.l10n.adminContentTotalResources,
              stats.totalResources.toString(),
              context.l10n.adminContentAllContentItems,
              Icons.folder_open,
              AppColors.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              context.l10n.adminContentVideos,
              stats.videoCount.toString(),
              context.l10n.adminContentVideoResources,
              Icons.play_circle,
              AppColors.error,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              context.l10n.adminContentTextContent,
              stats.textCount.toString(),
              context.l10n.adminContentTextResources,
              Icons.article,
              AppColors.success,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              context.l10n.adminContentTotalDuration,
              '${stats.totalDurationMinutes} min',
              context.l10n.adminContentVideoContent,
              Icons.timer,
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
                hintText: context.l10n.adminContentSearchResources,
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
              value: _selectedType,
              decoration: InputDecoration(
                labelText: context.l10n.adminContentResourceType,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              items: [
                DropdownMenuItem(value: 'all', child: Text(context.l10n.adminContentAllTypes)),
                DropdownMenuItem(value: 'video', child: Text(context.l10n.adminContentVideo)),
                DropdownMenuItem(value: 'text', child: Text(context.l10n.adminContentText)),
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
    final resourcesState = ref.watch(adminResourcesProvider);
    final isLoading = resourcesState.isLoading;

    var items = resourcesState.resources.map((r) {
      return ResourceRowData(
        id: r.id,
        resourceType: r.resourceType,
        title: r.title,
        lessonTitle: r.lessonTitle ?? '-',
        moduleTitle: r.moduleTitle ?? '-',
        courseTitle: r.courseTitle ?? '-',
        courseId: r.courseId ?? '',
        videoUrl: r.videoUrl,
        durationSeconds: r.durationSeconds,
        contentFormat: r.contentFormat,
        estimatedReadingTime: r.estimatedReadingTime,
        lastUpdated: _formatDate(r.updatedAt ?? r.createdAt),
      );
    }).toList();

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      items = items.where((item) {
        return item.title.toLowerCase().contains(_searchQuery) ||
            item.courseTitle.toLowerCase().contains(_searchQuery) ||
            item.lessonTitle.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    // Apply type filter
    if (_selectedType != 'all') {
      items = items.where((item) => item.resourceType == _selectedType).toList();
    }

    return AdminDataTable<ResourceRowData>(
      columns: [
        DataTableColumn(
          label: context.l10n.adminContentTitle,
          cellBuilder: (item) => Text(
            item.title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          sortable: true,
        ),
        DataTableColumn(
          label: context.l10n.adminContentType,
          cellBuilder: (item) => _buildTypeChip(item.resourceType),
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
          label: context.l10n.adminContentLocation,
          cellBuilder: (item) => Text(
            '${item.moduleTitle} > ${item.lessonTitle}',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataTableColumn(
          label: context.l10n.adminContentDurationReadTime,
          cellBuilder: (item) => Text(
            item.resourceType == 'video'
                ? _formatDuration(item.durationSeconds)
                : item.estimatedReadingTime != null
                    ? '${item.estimatedReadingTime} min read'
                    : '-',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
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
      onRowTap: (item) => _showResourceDetails(item),
      rowActions: [
        DataTableAction(
          icon: Icons.visibility,
          tooltip: context.l10n.adminContentViewDetails,
          onPressed: (item) => _showResourceDetails(item),
        ),
        DataTableAction(
          icon: Icons.edit,
          tooltip: context.l10n.adminContentEditInBuilder,
          color: AppColors.primary,
          onPressed: (item) {
            if (item.courseId.isNotEmpty) {
              context.go('/admin/content/${item.courseId}/edit');
            }
          },
        ),
      ],
    );
  }

  Widget _buildTypeChip(String type) {
    final isVideo = type == 'video';
    final color = isVideo ? AppColors.error : AppColors.success;
    final icon = isVideo ? Icons.play_circle : Icons.article;

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
            type[0].toUpperCase() + type.substring(1),
            style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  void _showResourceDetails(ResourceRowData item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              item.resourceType == 'video' ? Icons.play_circle : Icons.article,
              color: AppColors.primary,
            ),
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
              _buildDetailRow(context.l10n.adminContentType, item.resourceType == 'video' ? context.l10n.adminContentVideo : context.l10n.adminContentText),
              _buildDetailRow(context.l10n.adminContentCourse, item.courseTitle),
              _buildDetailRow(context.l10n.adminContentModule, item.moduleTitle),
              _buildDetailRow(context.l10n.adminContentLesson, item.lessonTitle),
              if (item.resourceType == 'video') ...[
                _buildDetailRow(context.l10n.adminContentDuration, _formatDuration(item.durationSeconds)),
                if (item.videoUrl != null)
                  _buildDetailRow(context.l10n.adminContentVideoUrl, item.videoUrl!),
              ] else ...[
                if (item.contentFormat != null)
                  _buildDetailRow(context.l10n.adminContentFormat, item.contentFormat!),
                if (item.estimatedReadingTime != null)
                  _buildDetailRow(context.l10n.adminContentReadingTime, '${item.estimatedReadingTime} min'),
              ],
              _buildDetailRow(context.l10n.adminContentLastUpdated, item.lastUpdated),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.adminContentClose),
          ),
          if (item.courseId.isNotEmpty)
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

  String _formatDuration(int? seconds) {
    if (seconds == null || seconds == 0) return '-';
    final minutes = seconds ~/ 60;
    final remaining = seconds % 60;
    if (minutes == 0) return '${remaining}s';
    if (remaining == 0) return '${minutes}m';
    return '${minutes}m ${remaining}s';
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

/// Row data model for the resources table
class ResourceRowData {
  final String id;
  final String resourceType;
  final String title;
  final String lessonTitle;
  final String moduleTitle;
  final String courseTitle;
  final String courseId;
  final String? videoUrl;
  final int? durationSeconds;
  final String? contentFormat;
  final int? estimatedReadingTime;
  final String lastUpdated;

  ResourceRowData({
    required this.id,
    required this.resourceType,
    required this.title,
    required this.lessonTitle,
    required this.moduleTitle,
    required this.courseTitle,
    required this.courseId,
    this.videoUrl,
    this.durationSeconds,
    this.contentFormat,
    this.estimatedReadingTime,
    required this.lastUpdated,
  });
}
