import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Tasks & To-Do Lists Widgets Library
///
/// Comprehensive widget collection for task management:
/// - Task models and types
/// - Task cards and lists
/// - Priority indicators
/// - Progress tracking
/// - Subtasks management
///
/// Backend Integration TODO:
/// - Sync tasks with backend
/// - Real-time collaboration
/// - Task reminders and notifications
/// - Cloud backup and restore

// ============================================================================
// MODELS
// ============================================================================

/// Task Priority
enum TaskPriority {
  none,
  low,
  medium,
  high;

  String get displayName {
    switch (this) {
      case TaskPriority.none:
        return 'No Priority';
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
    }
  }

  Color get color {
    switch (this) {
      case TaskPriority.none:
        return AppColors.textSecondary;
      case TaskPriority.low:
        return AppColors.info;
      case TaskPriority.medium:
        return AppColors.warning;
      case TaskPriority.high:
        return AppColors.error;
    }
  }

  IconData get icon {
    switch (this) {
      case TaskPriority.none:
        return Icons.remove;
      case TaskPriority.low:
        return Icons.keyboard_arrow_down;
      case TaskPriority.medium:
        return Icons.remove;
      case TaskPriority.high:
        return Icons.keyboard_arrow_up;
    }
  }
}

/// Task Status
enum TaskStatus {
  todo,
  inProgress,
  completed;

  String get displayName {
    switch (this) {
      case TaskStatus.todo:
        return 'To Do';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.completed:
        return 'Completed';
    }
  }

  Color get color {
    switch (this) {
      case TaskStatus.todo:
        return AppColors.textSecondary;
      case TaskStatus.inProgress:
        return AppColors.info;
      case TaskStatus.completed:
        return AppColors.success;
    }
  }

  IconData get icon {
    switch (this) {
      case TaskStatus.todo:
        return Icons.circle_outlined;
      case TaskStatus.inProgress:
        return Icons.timelapse;
      case TaskStatus.completed:
        return Icons.check_circle;
    }
  }
}

/// Subtask Model
class SubtaskModel {
  final String id;
  final String title;
  final bool isCompleted;

  SubtaskModel({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  SubtaskModel copyWith({
    String? title,
    bool? isCompleted,
  }) {
    return SubtaskModel(
      id: id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

/// Task Model
class TaskModel {
  final String id;
  final String title;
  final String? description;
  final TaskPriority priority;
  final TaskStatus status;
  final DateTime? dueDate;
  final DateTime? reminderDate;
  final List<String> tags;
  final String? category;
  final List<SubtaskModel> subtasks;
  final DateTime createdAt;
  final DateTime? completedAt;
  final bool isFavorite;
  final String? courseId;
  final String? courseName;
  final Color? customColor;

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    this.priority = TaskPriority.none,
    this.status = TaskStatus.todo,
    this.dueDate,
    this.reminderDate,
    this.tags = const [],
    this.category,
    this.subtasks = const [],
    required this.createdAt,
    this.completedAt,
    this.isFavorite = false,
    this.courseId,
    this.courseName,
    this.customColor,
  });

  bool get isCompleted => status == TaskStatus.completed;

  bool get isOverdue {
    if (dueDate == null || isCompleted) return false;
    return dueDate!.isBefore(DateTime.now());
  }

  bool get isDueToday {
    if (dueDate == null) return false;
    final now = DateTime.now();
    return dueDate!.year == now.year &&
        dueDate!.month == now.month &&
        dueDate!.day == now.day;
  }

  bool get isDueSoon {
    if (dueDate == null || isCompleted) return false;
    final now = DateTime.now();
    final difference = dueDate!.difference(now);
    return difference.inHours > 0 && difference.inHours <= 48;
  }

  int get completedSubtasksCount {
    return subtasks.where((st) => st.isCompleted).length;
  }

  double get progress {
    if (isCompleted) return 1.0;
    if (subtasks.isEmpty) return 0.0;
    return completedSubtasksCount / subtasks.length;
  }

  String get progressText {
    if (subtasks.isEmpty) return '';
    return '$completedSubtasksCount/${subtasks.length}';
  }

  Color get taskColor {
    if (customColor != null) return customColor!;
    if (isOverdue) return AppColors.error;
    if (isDueToday) return AppColors.warning;
    return priority.color;
  }

  TaskModel copyWith({
    String? title,
    String? description,
    TaskPriority? priority,
    TaskStatus? status,
    DateTime? dueDate,
    bool clearDueDate = false,
    List<String>? tags,
    String? category,
    List<SubtaskModel>? subtasks,
    DateTime? completedAt,
    bool? isFavorite,
  }) {
    return TaskModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
      reminderDate: reminderDate,
      tags: tags ?? this.tags,
      category: category ?? this.category,
      subtasks: subtasks ?? this.subtasks,
      createdAt: createdAt,
      completedAt: completedAt ?? this.completedAt,
      isFavorite: isFavorite ?? this.isFavorite,
      courseId: courseId,
      courseName: courseName,
      customColor: customColor,
    );
  }
}

// ============================================================================
// WIDGETS
// ============================================================================

/// Task Card Widget
class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onTap;
  final Function(bool?)? onToggle;
  final VoidCallback? onFavorite;
  final VoidCallback? onDelete;
  final bool showCourse;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onToggle,
    this.onFavorite,
    this.onDelete,
    this.showCourse = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Checkbox
                  if (onToggle != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 12, top: 2),
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: task.isCompleted,
                          onChanged: onToggle,
                          shape: const CircleBorder(),
                        ),
                      ),
                    ),

                  // Task Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          task.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: task.isCompleted
                                ? AppColors.textSecondary
                                : AppColors.textPrimary,
                          ),
                        ),

                        // Description
                        if (task.description != null &&
                            task.description!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            task.description!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],

                        // Meta Information
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            // Priority
                            if (task.priority != TaskPriority.none)
                              _buildChip(
                                icon: task.priority.icon,
                                label: task.priority.displayName,
                                color: task.priority.color,
                              ),

                            // Due Date
                            if (task.dueDate != null)
                              _buildChip(
                                icon: Icons.calendar_today,
                                label: _formatDueDate(task.dueDate!),
                                color: task.isOverdue
                                    ? AppColors.error
                                    : task.isDueToday
                                        ? AppColors.warning
                                        : AppColors.textSecondary,
                              ),

                            // Course
                            if (showCourse && task.courseName != null)
                              _buildChip(
                                icon: Icons.class_,
                                label: task.courseName!,
                                color: AppColors.primary,
                              ),

                            // Subtasks Progress
                            if (task.subtasks.isNotEmpty)
                              _buildChip(
                                icon: Icons.checklist,
                                label: task.progressText,
                                color: AppColors.info,
                              ),
                          ],
                        ),

                        // Tags
                        if (task.tags.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: task.tags.map((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '#$tag',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: AppColors.primary,
                                    fontSize: 11,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],

                        // Progress Bar
                        if (task.subtasks.isNotEmpty && !task.isCompleted) ...[
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: task.progress,
                            backgroundColor: AppColors.border,
                            borderRadius: BorderRadius.circular(4),
                            minHeight: 6,
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Actions
                  Column(
                    children: [
                      if (onFavorite != null)
                        IconButton(
                          icon: Icon(
                            task.isFavorite
                                ? Icons.star
                                : Icons.star_border,
                            size: 20,
                          ),
                          onPressed: onFavorite,
                          color: task.isFavorite
                              ? AppColors.warning
                              : AppColors.textSecondary,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      if (onDelete != null) ...[
                        const SizedBox(height: 8),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 20),
                          onPressed: onDelete,
                          color: AppColors.error,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDueDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(date.year, date.month, date.day);
    final difference = taskDate.difference(today).inDays;

    if (difference == 0) return 'Today';
    if (difference == 1) return 'Tomorrow';
    if (difference == -1) return 'Yesterday';
    if (difference < -1) return '${-difference} days ago';
    if (difference < 7) return 'In $difference days';

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
    return '${months[date.month - 1]} ${date.day}';
  }
}

/// Compact Task List Item
class TaskListItem extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onTap;
  final Function(bool?)? onToggle;

  const TaskListItem({
    super.key,
    required this.task,
    this.onTap,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Checkbox
            if (onToggle != null)
              Checkbox(
                value: task.isCompleted,
                onChanged: onToggle,
                shape: const CircleBorder(),
              ),
            if (onToggle != null) const SizedBox(width: 12),

            // Priority Indicator
            if (task.priority != TaskPriority.none)
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: task.priority.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            if (task.priority != TaskPriority.none) const SizedBox(width: 12),

            // Task Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      decoration:
                          task.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (task.dueDate != null) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: task.isOverdue
                              ? AppColors.error
                              : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDueDate(task.dueDate!),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: task.isOverdue
                                ? AppColors.error
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Subtasks indicator
            if (task.subtasks.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  task.progressText,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.info,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDueDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(date.year, date.month, date.day);
    final difference = taskDate.difference(today).inDays;

    if (difference == 0) return 'Today';
    if (difference == 1) return 'Tomorrow';
    if (difference < 0) return 'Overdue';

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
    return '${months[date.month - 1]} ${date.day}';
  }
}

/// Empty Tasks State
class EmptyTasksState extends StatelessWidget {
  final String message;
  final String? subtitle;
  final VoidCallback? onAddTask;

  const EmptyTasksState({
    super.key,
    this.message = 'No tasks yet',
    this.subtitle,
    this.onAddTask,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 80,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onAddTask != null) ...[
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onAddTask,
                icon: const Icon(Icons.add),
                label: const Text('Add Task'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Priority Filter Chip
class PriorityFilterChip extends StatelessWidget {
  final TaskPriority priority;
  final bool isSelected;
  final VoidCallback? onTap;

  const PriorityFilterChip({
    super.key,
    required this.priority,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FilterChip(
      label: Text(priority.displayName),
      avatar: Icon(
        priority.icon,
        size: 18,
        color: isSelected ? Colors.white : priority.color,
      ),
      selected: isSelected,
      onSelected: onTap != null ? (_) => onTap!() : null,
      backgroundColor: priority.color.withValues(alpha: 0.1),
      selectedColor: priority.color,
      labelStyle: theme.textTheme.bodySmall?.copyWith(
        color: isSelected ? Colors.white : priority.color,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

/// Task Category Card
class TaskCategoryCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const TaskCategoryCard({
    super.key,
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                '$count',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Subtask Item Widget
class SubtaskItem extends StatelessWidget {
  final SubtaskModel subtask;
  final Function(bool?)? onToggle;
  final VoidCallback? onDelete;

  const SubtaskItem({
    super.key,
    required this.subtask,
    this.onToggle,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          if (onToggle != null)
            Checkbox(
              value: subtask.isCompleted,
              onChanged: onToggle,
              shape: const CircleBorder(),
            ),
          if (onToggle != null) const SizedBox(width: 8),
          Expanded(
            child: Text(
              subtask.title,
              style: theme.textTheme.bodyMedium?.copyWith(
                decoration:
                    subtask.isCompleted ? TextDecoration.lineThrough : null,
                color: subtask.isCompleted
                    ? AppColors.textSecondary
                    : AppColors.textPrimary,
              ),
            ),
          ),
          if (onDelete != null)
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: onDelete,
              color: AppColors.textSecondary,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}
