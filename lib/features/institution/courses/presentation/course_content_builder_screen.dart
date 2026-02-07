// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/course_content_models.dart';
import '../../../../core/models/course_model.dart';
import '../../../../core/l10n_extension.dart';
import '../../../institution/providers/course_content_provider.dart';
import 'lesson_editor_screen.dart';
import '../widgets/advanced_module_editor.dart';

class CourseContentBuilderScreen extends ConsumerStatefulWidget {
  final String courseId;
  final Course? course;

  const CourseContentBuilderScreen({
    super.key,
    required this.courseId,
    this.course,
  });

  @override
  ConsumerState<CourseContentBuilderScreen> createState() =>
      _CourseContentBuilderScreenState();
}

class _CourseContentBuilderScreenState
    extends ConsumerState<CourseContentBuilderScreen> {
  final _lessonFormKey = GlobalKey<FormState>();
  final _moduleTitleController = TextEditingController();
  final _moduleDescriptionController = TextEditingController();
  final _lessonTitleController = TextEditingController();
  final _lessonDescriptionController = TextEditingController();

  @override
  void dispose() {
    _moduleTitleController.dispose();
    _moduleDescriptionController.dispose();
    _lessonTitleController.dispose();
    _lessonDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final modulesState = ref.watch(courseModulesProvider(widget.courseId));
    final expandedModules = ref.watch(expandedModulesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course?.title ?? context.l10n.instCourseContentBuilder),
        actions: [
          IconButton(
            icon: const Icon(Icons.preview),
            onPressed: () {
              // TODO: Navigate to preview
            },
            tooltip: context.l10n.instCoursePreviewCourse,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: modulesState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : modulesState.error != null
              ? _buildErrorWidget(modulesState.error!)
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCourseInfoCard(),
                      const SizedBox(height: 24),
                      _buildAddModuleButton(),
                      const SizedBox(height: 16),
                      if (modulesState.modules.isEmpty)
                        _buildEmptyState()
                      else
                        ...modulesState.modules.map((module) {
                          final isExpanded = expandedModules.contains(module.id);
                          return _buildModuleCard(module, isExpanded);
                        }),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddModuleDialog,
        icon: const Icon(Icons.add),
        label: Text(context.l10n.instCourseAddModule),
      ),
    );
  }

  Widget _buildCourseInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.course?.title ?? context.l10n.instCourseCourseTitle,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.course?.description ?? '',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _showEditCourseInfoDialog(),
                  icon: const Icon(Icons.edit),
                  label: Text(context.l10n.instCourseEditInfo),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddModuleButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          context.l10n.instCourseCourseModules,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        ElevatedButton.icon(
          onPressed: _showAddModuleDialog,
          icon: const Icon(Icons.add),
          label: Text(context.l10n.instCourseAddModule),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48.0),
        child: Column(
          children: [
            Icon(
              Icons.school_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.instCourseNoModulesYet,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.instCourseStartBuildingModules,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleCard(CourseModule module, bool isExpanded) {
    final lessonsState = ref.watch(lessonsProvider);
    final lessons = lessonsState.getLessonsForModule(module.id);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          InkWell(
            onTap: () => _toggleModuleExpansion(module.id),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withValues(alpha:0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      context.l10n.instCourseModuleIndex(module.orderIndex),
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          module.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (module.description != null && module.description!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            module.description!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Chip(
                    label: Text(context.l10n.instCourseLessonsCount(module.lessonCount)),
                    avatar: const Icon(Icons.playlist_play, size: 18),
                  ),
                  const SizedBox(width: 8),
                  if (module.durationMinutes > 0)
                    Chip(
                      label: Text(module.durationDisplay),
                      avatar: const Icon(Icons.access_time, size: 18),
                    ),
                  const SizedBox(width: 8),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _showEditModuleDialog(module);
                      } else if (value == 'delete') {
                        _deleteModule(module.id);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            const Icon(Icons.edit, size: 20),
                            const SizedBox(width: 8),
                            Text(context.l10n.instCourseEditModule),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(Icons.delete, size: 20, color: Colors.red),
                            const SizedBox(width: 8),
                            Text(context.l10n.instCourseDeleteModule,
                                style: const TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (module.learningObjectives.isNotEmpty) ...[
                    Text(
                      context.l10n.instCourseLearningObjectives,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: module.learningObjectives
                          .map((objective) => Chip(
                                label: Text(objective),
                                backgroundColor: Colors.blue[50],
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.l10n.instCourseLessons,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _showAddLessonDialog(module.id),
                        icon: const Icon(Icons.add, size: 18),
                        label: Text(context.l10n.instCourseAddLesson),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (lessons.isEmpty)
                    _buildEmptyLessonsState(module.id)
                  else
                    ...lessons.map((lesson) => _buildLessonItem(lesson, module.id)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyLessonsState(String moduleId) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.playlist_add, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text(
              context.l10n.instCourseNoLessonsInModule,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonItem(CourseLesson lesson, String moduleId) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      child: ListTile(
        onTap: () => _showEditLessonDialog(lesson, moduleId),
        leading: CircleAvatar(
          backgroundColor: _getLessonTypeColor(lesson.lessonType),
          child: Icon(
            lesson.lessonType.icon,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(lesson.title),
        subtitle: (lesson.description != null && lesson.description!.isNotEmpty)
            ? Text(
                lesson.description!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (lesson.durationMinutes > 0)
              Chip(
                label: Text(lesson.durationDisplay),
                avatar: const Icon(Icons.access_time, size: 16),
                visualDensity: VisualDensity.compact,
              ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  _showEditLessonDialog(lesson, moduleId);
                } else if (value == 'delete') {
                  _deleteLesson(lesson.id, moduleId);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      const Icon(Icons.edit, size: 20),
                      const SizedBox(width: 8),
                      Text(context.l10n.instCourseEditLesson),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      const Icon(Icons.delete, size: 20, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(context.l10n.instCourseDeleteLesson, style: const TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              context.l10n.instCourseError,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(courseModulesProvider(widget.courseId).notifier).refresh();
              },
              icon: const Icon(Icons.refresh),
              label: Text(context.l10n.instCourseRetry),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleModuleExpansion(String moduleId) {
    final currentExpanded = ref.read(expandedModulesProvider);
    final newExpanded = Set<String>.from(currentExpanded);

    if (newExpanded.contains(moduleId)) {
      newExpanded.remove(moduleId);
    } else {
      newExpanded.add(moduleId);
      // Fetch lessons for this module
      ref.read(lessonsProvider.notifier).fetchModuleLessons(moduleId);
    }

    ref.read(expandedModulesProvider.notifier).state = newExpanded;
  }

  Color _getLessonTypeColor(LessonType type) {
    switch (type) {
      case LessonType.video:
        return Colors.red;
      case LessonType.text:
        return Colors.blue;
      case LessonType.quiz:
        return Colors.green;
      case LessonType.assignment:
        return Colors.orange;
    }
  }

  void _showAddModuleDialog() {
    final modulesState = ref.read(courseModulesProvider(widget.courseId));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AdvancedModuleEditor(
        allModules: modulesState.modules,
        onSave: (request) async {
          final orderIndex = modulesState.modules.length + 1;
          final fullRequest = ModuleRequest(
            title: request.title,
            description: request.description,
            orderIndex: orderIndex,
            learningObjectives: request.learningObjectives,
            isPublished: request.isPublished,
          );

          final result = await ref
              .read(courseModulesProvider(widget.courseId).notifier)
              .createModule(fullRequest);

          if (!context.mounted) return;
          if (result != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.l10n.instCourseModuleCreatedSuccess(request.title)),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
      ),
    );
  }

  void _showEditModuleDialog(CourseModule module) {
    final modulesState = ref.read(courseModulesProvider(widget.courseId));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AdvancedModuleEditor(
        existingModule: module,
        allModules: modulesState.modules,
        onSave: (request) async {
          final fullRequest = ModuleRequest(
            title: request.title,
            description: request.description,
            orderIndex: module.orderIndex,
            learningObjectives: request.learningObjectives,
            isPublished: request.isPublished,
          );

          final result = await ref
              .read(courseModulesProvider(widget.courseId).notifier)
              .updateModule(module.id, fullRequest);

          if (!context.mounted) return;
          if (result != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.l10n.instCourseModuleUpdatedSuccess(request.title)),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
      ),
    );
  }

  void _showAddLessonDialog(String moduleId) {
    _lessonTitleController.clear();
    _lessonDescriptionController.clear();
    LessonType selectedType = LessonType.video;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(context.l10n.instCourseAddNewLesson),
          content: Form(
            key: _lessonFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<LessonType>(
                  value: selectedType,
                  decoration: InputDecoration(
                    labelText: context.l10n.instCourseLessonType,
                    border: OutlineInputBorder(),
                  ),
                  items: LessonType.values
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Row(
                              children: [
                                Icon(type.icon, size: 20),
                                const SizedBox(width: 8),
                                Text(type.displayName),
                              ],
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() => selectedType = value!);
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _lessonTitleController,
                  decoration: InputDecoration(
                    labelText: context.l10n.instCourseLessonTitle,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.l10n.instCoursePleaseEnterTitle;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _lessonDescriptionController,
                  decoration: InputDecoration(
                    labelText: context.l10n.instCourseDescription,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.l10n.instCourseCancel),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_lessonFormKey.currentState!.validate()) {
                  final lessons = ref.read(lessonsProvider).getLessonsForModule(moduleId);
                  final request = LessonRequest(
                    title: _lessonTitleController.text,
                    description: _lessonDescriptionController.text,
                    lessonType: selectedType,
                    orderIndex: lessons.length + 1,
                    isMandatory: false,
                  );

                  final result = await ref
                      .read(lessonsProvider.notifier)
                      .createLesson(moduleId, request);

                  if (result != null && context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(context.l10n.instCourseLessonCreatedSuccess)),
                    );
                  }
                }
              },
              child: Text(context.l10n.instCourseCreate),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditLessonDialog(CourseLesson lesson, String moduleId) async {
    // Navigate to the lesson editor screen with the college-grade content editors
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => LessonEditorScreen(
          lessonId: lesson.id,
          moduleId: moduleId,
          lesson: lesson,
        ),
      ),
    );

    if (!mounted) return;

    // Refresh lessons if changes were made
    if (result == true) {
      ref.read(lessonsProvider.notifier).fetchModuleLessons(moduleId);
    }
  }

  Future<void> _deleteModule(String moduleId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.instCourseDeleteModule),
        content: Text(
          context.l10n.instCourseDeleteModuleConfirm,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.instCourseCancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(context.l10n.instCourseDelete),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await ref
          .read(courseModulesProvider(widget.courseId).notifier)
          .deleteModule(moduleId);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.instCourseModuleDeletedSuccess)),
        );
      }
    }
  }

  Future<void> _deleteLesson(String lessonId, String moduleId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.instCourseDeleteLesson),
        content: Text(context.l10n.instCourseDeleteLessonConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.instCourseCancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(context.l10n.instCourseDelete),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await ref
          .read(lessonsProvider.notifier)
          .deleteLesson(lessonId, moduleId);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.instCourseLessonDeletedSuccess)),
        );
      }
    }
  }

  void _showEditCourseInfoDialog() {
    final titleController = TextEditingController(text: widget.course?.title ?? '');
    final descriptionController = TextEditingController(text: widget.course?.description ?? '');
    String selectedType = widget.course?.courseType.toString() ?? 'video';
    String selectedLevel = widget.course?.level.toString() ?? 'beginner';
    bool isSaving = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.edit, color: Colors.blue),
              const SizedBox(width: 12),
              Text(context.l10n.instCourseEditCourseInfo),
            ],
          ),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: context.l10n.instCourseTitleLabel,
                      hintText: context.l10n.instCourseEnterTitle,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: context.l10n.instCourseDescription,
                      hintText: context.l10n.instCourseEnterDescription,
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedType,
                          decoration: InputDecoration(
                            labelText: context.l10n.instApplicantType,
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'video', child: Text('Video')),
                            DropdownMenuItem(value: 'text', child: Text('Text')),
                            DropdownMenuItem(value: 'interactive', child: Text('Interactive')),
                            DropdownMenuItem(value: 'live', child: Text('Live')),
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
                            labelText: context.l10n.instCourseLevel,
                            border: OutlineInputBorder(),
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
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: isSaving ? null : () => Navigator.pop(context),
              child: Text(context.l10n.instCourseCancel),
            ),
            ElevatedButton.icon(
              onPressed: isSaving
                  ? null
                  : () async {
                      if (titleController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(context.l10n.instCourseTitleRequired)),
                        );
                        return;
                      }

                      setDialogState(() => isSaving = true);

                      // TODO: Call API to update course info
                      // For now just show success message
                      await Future.delayed(const Duration(milliseconds: 500));

                      if (!context.mounted) return;
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(context.l10n.instCourseInfoUpdatedSuccess),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
              icon: isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.save),
              label: Text(isSaving ? context.l10n.instCourseSaving : context.l10n.instCourseSaveChanges),
            ),
          ],
        ),
      ),
    );
  }
}
