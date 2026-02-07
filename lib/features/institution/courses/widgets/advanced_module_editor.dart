import 'package:flutter/material.dart';
import '../../../../core/models/course_content_models.dart';
import '../../../../core/l10n_extension.dart';

/// Advanced Module Editor Dialog
/// Features: Learning objectives management, duration tracking, prerequisites, and more
class AdvancedModuleEditor extends StatefulWidget {
  final CourseModule? existingModule;
  final List<CourseModule> allModules;
  final Function(ModuleRequest) onSave;

  const AdvancedModuleEditor({
    super.key,
    this.existingModule,
    required this.allModules,
    required this.onSave,
  });

  @override
  State<AdvancedModuleEditor> createState() => _AdvancedModuleEditorState();
}

class _AdvancedModuleEditorState extends State<AdvancedModuleEditor>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _objectiveController;
  late TabController _tabController;

  final List<String> _learningObjectives = [];
  final Set<String> _selectedPrerequisites = {};
  int _estimatedDuration = 0;
  bool _isPublished = true;
  bool _isMandatory = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _titleController = TextEditingController(
      text: widget.existingModule?.title ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.existingModule?.description ?? '',
    );
    _objectiveController = TextEditingController();

    if (widget.existingModule != null) {
      _learningObjectives.addAll(widget.existingModule!.learningObjectives);
      _estimatedDuration = widget.existingModule!.durationMinutes;
      _isPublished = widget.existingModule!.isPublished;
      // Prerequisites would come from a separate field if we add it to the model
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _objectiveController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildBasicInfoTab(),
                  _buildLearningObjectivesTab(),
                  _buildSettingsTab(),
                ],
              ),
            ),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha:0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.folder_open,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.existingModule == null
                      ? context.l10n.instCourseCreateNewModule
                      : context.l10n.instCourseEditModule,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.existingModule == null
                      ? context.l10n.instCourseAddModuleSubtitle
                      : context.l10n.instCourseUpdateModuleSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: Theme.of(context).primaryColor,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Theme.of(context).primaryColor,
        tabs: [
          Tab(
            icon: const Icon(Icons.info_outline),
            text: context.l10n.instCourseBasicInfo,
          ),
          Tab(
            icon: const Icon(Icons.checklist),
            text: context.l10n.instCourseLearningObjectives,
          ),
          Tab(
            icon: const Icon(Icons.settings),
            text: context.l10n.instCourseSettings,
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Module Title
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: context.l10n.instCourseModuleTitle,
                hintText: context.l10n.instCourseModuleTitleHint,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.title),
                helperText: context.l10n.instCourseModuleTitleHelper,
                counterText: '${_titleController.text.length}/100',
              ),
              maxLength: 100,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return context.l10n.instCourseModuleTitleRequired;
                }
                if (value.length < 5) {
                  return context.l10n.instCourseModuleTitleMinLength;
                }
                return null;
              },
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 24),

            // Module Description
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: context.l10n.instCourseModuleDescription,
                hintText: context.l10n.instCourseModuleDescriptionHint,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.description),
                alignLabelWithHint: true,
                helperText: context.l10n.instCourseModuleDescriptionHelper,
                counterText: '${_descriptionController.text.length}/500',
              ),
              maxLines: 5,
              maxLength: 500,
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 24),

            // Estimated Duration
            TextFormField(
              initialValue: _estimatedDuration.toString(),
              decoration: InputDecoration(
                labelText: context.l10n.instCourseEstimatedDuration,
                hintText: '60',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.access_time),
                helperText: context.l10n.instCourseEstimatedDurationHelper,
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _estimatedDuration = int.tryParse(value) ?? 0;
                });
              },
            ),
            const SizedBox(height: 24),

            // Quick Stats Summary
            _buildQuickStats(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics, color: Colors.blue.shade700, size: 20),
                const SizedBox(width: 8),
                Text(
                  context.l10n.instCourseModuleOverview,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _buildStatChip(
                  Icons.checklist,
                  context.l10n.instCourseObjectivesCount(_learningObjectives.length),
                  Colors.green,
                ),
                _buildStatChip(
                  Icons.timer,
                  context.l10n.instCourseMinutesShort(_estimatedDuration),
                  Colors.orange,
                ),
                _buildStatChip(
                  Icons.playlist_play,
                  context.l10n.instCourseLessonsCount(widget.existingModule?.lessonCount ?? 0),
                  Colors.purple,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha:0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLearningObjectivesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.amber.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    context.l10n.instCourseLearningObjectivesInfo,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.amber.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Add objective field
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  controller: _objectiveController,
                  decoration: InputDecoration(
                    labelText: context.l10n.instCourseAddLearningObjective,
                    hintText: context.l10n.instCourseObjectiveHint,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.add_circle_outline),
                  ),
                  maxLines: 2,
                  onSubmitted: (_) => _addObjective(),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _addObjective,
                icon: const Icon(Icons.add),
                label: Text(context.l10n.instCourseAdd),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Objectives list
          if (_learningObjectives.isEmpty)
            _buildEmptyObjectivesState()
          else
            _buildObjectivesList(),
        ],
      ),
    );
  }

  Widget _buildEmptyObjectivesState() {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 2),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.checklist, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              context.l10n.instCourseNoObjectivesYet,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.instCourseNoObjectivesSubtitle,
              style: TextStyle(color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildObjectivesList() {
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _learningObjectives.length,
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (newIndex > oldIndex) newIndex--;
          final item = _learningObjectives.removeAt(oldIndex);
          _learningObjectives.insert(newIndex, item);
        });
      },
      itemBuilder: (context, index) {
        final objective = _learningObjectives[index];
        return Card(
          key: ValueKey(objective),
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 1,
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha:0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
            title: Text(objective),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ReorderableDragStartListener(
                  index: index,
                  child: const Icon(Icons.drag_handle, color: Colors.grey),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () => _editObjective(index),
                ),
                IconButton(
                  icon: Icon(Icons.delete, size: 20, color: Colors.red.shade400),
                  onPressed: () => _removeObjective(index),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Publishing Settings
          Text(
            context.l10n.instCoursePublishingSettings,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: Icon(
                    Icons.visibility,
                    color: _isPublished ? Colors.green : Colors.grey,
                  ),
                  title: Text(context.l10n.instCoursePublished),
                  subtitle: Text(
                    _isPublished
                        ? context.l10n.instCourseModuleVisibleToStudents
                        : context.l10n.instCourseModuleHiddenFromStudents,
                    style: TextStyle(
                      color: _isPublished ? Colors.green.shade700 : Colors.grey,
                    ),
                  ),
                  value: _isPublished,
                  onChanged: (value) => setState(() => _isPublished = value),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: Icon(
                    Icons.star,
                    color: _isMandatory ? Colors.orange : Colors.grey,
                  ),
                  title: Text(context.l10n.instCourseMandatory),
                  subtitle: Text(
                    _isMandatory
                        ? context.l10n.instCourseStudentsMustComplete
                        : context.l10n.instCourseModuleOptional,
                    style: TextStyle(
                      color: _isMandatory ? Colors.orange.shade700 : Colors.grey,
                    ),
                  ),
                  value: _isMandatory,
                  onChanged: (value) => setState(() => _isMandatory = value),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Prerequisites
          Text(
            context.l10n.instCoursePrerequisites,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.instCoursePrerequisitesDescription,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          const SizedBox(height: 16),
          _buildPrerequisitesSection(),
        ],
      ),
    );
  }

  Widget _buildPrerequisitesSection() {
    final availableModules = widget.allModules.where((m) {
      // Exclude current module if editing
      if (widget.existingModule != null) {
        return m.id != widget.existingModule!.id;
      }
      return true;
    }).toList();

    if (availableModules.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            context.l10n.instCourseNoOtherModulesAvailable,
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
      );
    }

    return Card(
      child: Column(
        children: availableModules.map((module) {
          final isSelected = _selectedPrerequisites.contains(module.id);
          return CheckboxListTile(
            secondary: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha:0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                context.l10n.instCourseModuleNumber(module.orderIndex),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            title: Text(module.title),
            subtitle: module.description != null
                ? Text(
                    module.description!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                : null,
            value: isSelected,
            onChanged: (value) {
              setState(() {
                if (value == true) {
                  _selectedPrerequisites.add(module.id);
                } else {
                  _selectedPrerequisites.remove(module.id);
                }
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
            label: Text(context.l10n.instCourseCancel),
          ),
          Row(
            children: [
              if (widget.existingModule == null)
                OutlinedButton.icon(
                  onPressed: _saveDraft,
                  icon: const Icon(Icons.save_outlined),
                  label: Text(context.l10n.instCourseSaveAsDraft),
                ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _saveModule,
                icon: const Icon(Icons.check_circle),
                label: Text(
                  widget.existingModule == null
                      ? context.l10n.instCourseCreateModule
                      : context.l10n.instCourseUpdateModule,
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _addObjective() {
    final text = _objectiveController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _learningObjectives.add(text);
        _objectiveController.clear();
      });
    }
  }

  void _editObjective(int index) {
    final controller = TextEditingController(text: _learningObjectives[index]);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.instCourseEditLearningObjective),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: context.l10n.instCourseObjective,
            border: const OutlineInputBorder(),
          ),
          maxLines: 3,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(context.l10n.instCourseCancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  _learningObjectives[index] = controller.text.trim();
                });
                Navigator.pop(dialogContext);
              }
            },
            child: Text(context.l10n.instCourseUpdate),
          ),
        ],
      ),
    );
  }

  void _removeObjective(int index) {
    setState(() {
      _learningObjectives.removeAt(index);
    });
  }

  void _saveDraft() {
    _isPublished = false;
    _saveModule();
  }

  void _saveModule() {
    if (_formKey.currentState!.validate()) {
      final request = ModuleRequest(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        orderIndex: widget.existingModule?.orderIndex ?? 1,
        learningObjectives: _learningObjectives,
        isPublished: _isPublished,
        // Note: isMandatory and prerequisites would need to be added to the model
      );

      widget.onSave(request);
      Navigator.pop(context, true);
    }
  }
}
