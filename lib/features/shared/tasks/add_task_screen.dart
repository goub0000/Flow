import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/l10n_extension.dart';
import '../widgets/task_widgets.dart';

/// Add/Edit Task Screen
///
/// Form for creating and editing tasks:
/// - Title and description
/// - Priority selection
/// - Due date picker
/// - Tags management
/// - Course association
/// - Subtasks creation
/// - Reminder settings
///
/// Backend Integration TODO:
/// - Save task to backend
/// - Validate task data
/// - Send task notifications
/// - Sync with calendar

class AddTaskScreen extends StatefulWidget {
  final TaskModel? task;

  const AddTaskScreen({
    super.key,
    this.task,
  });

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagController = TextEditingController();

  TaskPriority _priority = TaskPriority.none;
  TaskStatus _status = TaskStatus.todo;
  DateTime? _dueDate;
  TimeOfDay? _dueTime;
  List<String> _tags = [];
  String? _selectedCourseId;
  List<SubtaskModel> _subtasks = [];
  bool _hasReminder = false;

  bool get _isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      // Editing existing task
      final task = widget.task!;
      _titleController.text = task.title;
      _descriptionController.text = task.description ?? '';
      _priority = task.priority;
      _status = task.status;
      _dueDate = task.dueDate;
      if (task.dueDate != null) {
        _dueTime = TimeOfDay.fromDateTime(task.dueDate!);
      }
      _tags = List.from(task.tags);
      _selectedCourseId = task.courseId;
      _subtasks = List.from(task.subtasks);
      _hasReminder = task.reminderDate != null;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          tooltip: 'Back',
        ),
        title: Text(_isEditing ? 'Edit Task' : 'Add Task'),
        actions: [
          TextButton(
            onPressed: _saveTask,
            child: const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title
            _buildSectionHeader('Title'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Enter task title',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Description
            _buildSectionHeader('Description (Optional)'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: 'Add description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 24),

            // Priority
            _buildSectionHeader('Priority'),
            const SizedBox(height: 8),
            SegmentedButton<TaskPriority>(
              segments: TaskPriority.values.map((priority) {
                return ButtonSegment<TaskPriority>(
                  value: priority,
                  label: Text(priority.displayName),
                  icon: Icon(
                    priority.icon,
                    size: 16,
                    color: priority.color,
                  ),
                );
              }).toList(),
              selected: {_priority},
              onSelectionChanged: (Set<TaskPriority> selected) {
                setState(() {
                  _priority = selected.first;
                });
              },
            ),
            const SizedBox(height: 24),

            // Status (only show when editing)
            if (_isEditing) ...[
              _buildSectionHeader('Status'),
              const SizedBox(height: 8),
              SegmentedButton<TaskStatus>(
                segments: TaskStatus.values.map((status) {
                  return ButtonSegment<TaskStatus>(
                    value: status,
                    label: Text(status.displayName),
                    icon: Icon(
                      status.icon,
                      size: 16,
                      color: status.color,
                    ),
                  );
                }).toList(),
                selected: {_status},
                onSelectionChanged: (Set<TaskStatus> selected) {
                  setState(() {
                    _status = selected.first;
                  });
                },
              ),
              const SizedBox(height: 24),
            ],

            // Due Date
            _buildSectionHeader('Due Date (Optional)'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: InkWell(
                    onTap: _selectDate,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        _dueDate == null
                            ? 'Select date'
                            : _formatDate(_dueDate!),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: _dueDate != null ? _selectTime : null,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.access_time),
                        enabled: _dueDate != null,
                      ),
                      child: Text(
                        _dueTime == null
                            ? 'Time'
                            : _dueTime!.format(context),
                      ),
                    ),
                  ),
                ),
                if (_dueDate != null)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _dueDate = null;
                        _dueTime = null;
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: 24),

            // Course
            _buildSectionHeader('Course (Optional)'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedCourseId,
              decoration: const InputDecoration(
                hintText: 'Select course',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.class_),
              ),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('None'),
                ),
                ..._getMockCourses().map((course) {
                  return DropdownMenuItem(
                    value: course['id'],
                    child: Text(course['name']!),
                  );
                }),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCourseId = value;
                });
              },
            ),
            const SizedBox(height: 24),

            // Tags
            _buildSectionHeader('Tags'),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_tags.isEmpty)
                      Text(
                        'No tags added',
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                      )
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _tags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '#$tag',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const SizedBox(width: 6),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _tags.remove(tag);
                                    });
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    size: 16,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _tagController,
                            decoration: const InputDecoration(
                              hintText: 'Add tag',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            textInputAction: TextInputAction.done,
                            onSubmitted: _addTag,
                          ),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed: () => _addTag(_tagController.text),
                          child: const Text('Add'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Subtasks
            _buildSectionHeader('Subtasks'),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_subtasks.isEmpty)
                      Text(
                        'No subtasks added',
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                      )
                    else
                      ..._subtasks.map((subtask) {
                        return SubtaskItem(
                          subtask: subtask,
                          onToggle: (value) => _toggleSubtask(subtask),
                          onDelete: () => _deleteSubtask(subtask),
                        );
                      }),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: _addSubtask,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Subtask'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Reminder
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Set Reminder',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    Switch(
                      value: _hasReminder,
                      onChanged: (value) {
                        setState(() {
                          _hasReminder = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _saveTask,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(_isEditing ? 'Update Task' : 'Create Task'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
            letterSpacing: 0.5,
          ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        _dueDate = picked;
        _dueTime ??= const TimeOfDay(hour: 23, minute: 59);
      });
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _dueTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _dueTime = picked;
      });
    }
  }

  void _addTag(String tag) {
    final trimmedTag = tag.trim();
    if (trimmedTag.isNotEmpty && !_tags.contains(trimmedTag)) {
      setState(() {
        _tags.add(trimmedTag);
        _tagController.clear();
      });
    }
  }

  void _addSubtask() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Subtask'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Subtask title',
            border: OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.sentences,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final title = controller.text.trim();
              if (title.isNotEmpty) {
                setState(() {
                  _subtasks.add(SubtaskModel(
                    id: DateTime.now().toString(),
                    title: title,
                  ));
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _toggleSubtask(SubtaskModel subtask) {
    setState(() {
      final index = _subtasks.indexWhere((st) => st.id == subtask.id);
      if (index != -1) {
        _subtasks[index] = subtask.copyWith(
          isCompleted: !subtask.isCompleted,
        );
      }
    });
  }

  void _deleteSubtask(SubtaskModel subtask) {
    setState(() {
      _subtasks.removeWhere((st) => st.id == subtask.id);
    });
  }

  List<Map<String, String>> _getMockCourses() {
    return [
      {'id': '1', 'name': 'Mobile App Development'},
      {'id': '2', 'name': 'Data Structures'},
      {'id': '3', 'name': 'Web Technologies'},
      {'id': '4', 'name': 'Artificial Intelligence'},
    ];
  }

  void _saveTask() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // TODO: Save to backend
    // When saving, combine _dueDate and _dueTime into a single DateTime
    // DateTime? finalDueDate;
    // if (_dueDate != null && _dueTime != null) {
    //   finalDueDate = DateTime(
    //     _dueDate!.year,
    //     _dueDate!.month,
    //     _dueDate!.day,
    //     _dueTime!.hour,
    //     _dueTime!.minute,
    //   );
    // } else if (_dueDate != null) {
    //   finalDueDate = DateTime(
    //     _dueDate!.year,
    //     _dueDate!.month,
    //     _dueDate!.day,
    //     23,
    //     59,
    //   );
    // }

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isEditing ? 'Task updated' : 'Task created'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}
