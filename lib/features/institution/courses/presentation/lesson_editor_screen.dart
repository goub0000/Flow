// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/course_content_models.dart';
import '../../../../core/models/quiz_assignment_models.dart';
import '../../../../core/l10n_extension.dart';
import '../../../institution/providers/course_content_provider.dart';
import '../widgets/video_content_editor.dart';
import '../widgets/text_content_editor.dart';
import '../widgets/quiz_content_editor.dart';
import '../widgets/assignment_content_editor.dart';

/// Screen for editing lesson content with college-grade content editors
class LessonEditorScreen extends ConsumerStatefulWidget {
  final String lessonId;
  final String moduleId;
  final CourseLesson lesson;

  const LessonEditorScreen({
    super.key,
    required this.lessonId,
    required this.moduleId,
    required this.lesson,
  });

  @override
  ConsumerState<LessonEditorScreen> createState() => _LessonEditorScreenState();
}

class _LessonEditorScreenState extends ConsumerState<LessonEditorScreen>
    with SingleTickerProviderStateMixin {
  final _basicInfoFormKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TabController _tabController;
  late int _durationMinutes;
  late bool _isMandatory;
  late bool _isPublished;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _titleController = TextEditingController(text: widget.lesson.title);
    _descriptionController = TextEditingController(text: widget.lesson.description ?? '');
    _durationMinutes = widget.lesson.durationMinutes;
    _isMandatory = widget.lesson.isMandatory;
    _isPublished = widget.lesson.isPublished;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveLesson() async {
    if (!_basicInfoFormKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      // Update basic lesson info
      final lessonRequest = LessonRequest(
        title: _titleController.text,
        description: _descriptionController.text,
        lessonType: widget.lesson.lessonType,
        orderIndex: widget.lesson.orderIndex,
        durationMinutes: _durationMinutes,
        isMandatory: _isMandatory,
        isPublished: _isPublished,
      );

      final updatedLesson = await ref
          .read(lessonsProvider.notifier)
          .updateLesson(widget.lessonId, widget.moduleId, lessonRequest);

      if (updatedLesson != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.lessonEditorSaveSuccess)),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${context.l10n.lessonEditorSaveError}: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${context.l10n.lessonEditorEdit} ${widget.lesson.lessonType.displayName}'),
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveLesson,
              tooltip: context.l10n.lessonEditorSaveLesson,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBasicInfoSection(),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 32),
            _buildContentEditorSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _basicInfoFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.lessonEditorBasicInfo,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: context.l10n.lessonEditorLessonTitle,
                  border: const OutlineInputBorder(),
                  helperText: context.l10n.lessonEditorLessonTitleHelper,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return context.l10n.lessonEditorLessonTitleError;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: context.l10n.lessonEditorDescription,
                  border: const OutlineInputBorder(),
                  helperText: context.l10n.lessonEditorDescriptionHelper,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: _durationMinutes.toString(),
                      decoration: InputDecoration(
                        labelText: context.l10n.lessonEditorDuration,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.access_time),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _durationMinutes = int.tryParse(value) ?? 0;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SwitchListTile(
                          title: Text(context.l10n.lessonEditorMandatory),
                          subtitle: Text(context.l10n.lessonEditorMandatorySubtitle),
                          value: _isMandatory,
                          onChanged: (value) {
                            setState(() => _isMandatory = value);
                          },
                        ),
                        SwitchListTile(
                          title: Text(context.l10n.lessonEditorPublished),
                          subtitle: Text(context.l10n.lessonEditorPublishedSubtitle),
                          value: _isPublished,
                          onChanged: (value) {
                            setState(() => _isPublished = value);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentEditorSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.lessonEditorLessonContent,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        _buildContentEditor(),
      ],
    );
  }

  Widget _buildContentEditor() {
    switch (widget.lesson.lessonType) {
      case LessonType.video:
        return VideoContentEditor(
          initialContent: null, // TODO: Load from API
          onSave: _handleVideoContentSave,
        );

      case LessonType.text:
        return TextContentEditor(
          initialContent: null, // TODO: Load from API
          onSave: _handleTextContentSave,
        );

      case LessonType.quiz:
        return QuizContentEditor(
          initialContent: null, // TODO: Load from API
          onSave: _handleQuizContentSave,
        );

      case LessonType.assignment:
        return AssignmentContentEditor(
          initialContent: null, // TODO: Load from API
          onSave: _handleAssignmentContentSave,
        );
    }
  }

  Future<void> _handleVideoContentSave(VideoContentRequest content) async {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.lessonEditorVideoSavePending)),
      );
    }
  }

  Future<void> _handleTextContentSave(TextContentRequest content) async {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.lessonEditorTextSavePending)),
      );
    }
  }

  Future<void> _handleQuizContentSave(QuizContentRequest content) async {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.lessonEditorQuizSavePending)),
      );
    }
  }

  Future<void> _handleAssignmentContentSave(AssignmentContentRequest content) async {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.lessonEditorAssignmentSavePending)),
      );
    }
  }
}
