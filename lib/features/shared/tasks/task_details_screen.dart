import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/task_widgets.dart';

/// Task Details Screen
///
/// Displays comprehensive task information:
/// - Task details and description
/// - Subtasks management
/// - Priority and status
/// - Due date and reminders
/// - Tags and category
/// - Edit and delete options
///
/// Backend Integration TODO:
/// - Fetch task details from backend
/// - Update task information
/// - Sync subtask progress
/// - Send task notifications

class TaskDetailsScreen extends StatefulWidget {
  final TaskModel task;

  const TaskDetailsScreen({
    super.key,
    required this.task,
  });

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  late TaskModel _task;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          IconButton(
            icon: Icon(
              _task.isFavorite ? Icons.star : Icons.star_border,
            ),
            onPressed: _toggleFavorite,
            tooltip: 'Favorite',
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editTask,
            tooltip: 'Edit',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteTask,
            tooltip: 'Delete',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _task.taskColor.withValues(alpha: 0.1),
                border: Border(
                  bottom: BorderSide(
                    color: _task.taskColor,
                    width: 3,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status and Priority
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _task.status.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: _task.status.color),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _task.status.icon,
                              size: 16,
                              color: _task.status.color,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _task.status.displayName,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: _task.status.color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_task.priority != TaskPriority.none) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _task.priority.color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: _task.priority.color),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _task.priority.icon,
                                size: 16,
                                color: _task.priority.color,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _task.priority.displayName,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: _task.priority.color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Title
                  Text(
                    _task.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      decoration:
                          _task.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),

                  // Progress Bar (if has subtasks)
                  if (_task.subtasks.isNotEmpty && !_task.isCompleted) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: _task.progress,
                            backgroundColor: AppColors.border,
                            borderRadius: BorderRadius.circular(4),
                            minHeight: 8,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${(_task.progress * 100).toInt()}%',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Task Details
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  if (_task.description != null &&
                      _task.description!.isNotEmpty) ...[
                    _buildSectionHeader('Description'),
                    const SizedBox(height: 12),
                    Text(
                      _task.description!,
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Due Date
                  if (_task.dueDate != null) ...[
                    _buildDetailRow(
                      icon: Icons.calendar_today,
                      title: 'Due Date',
                      content: Text(
                        _formatDate(_task.dueDate!),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: _task.isOverdue
                              ? AppColors.error
                              : AppColors.textPrimary,
                          fontWeight: _task.isOverdue
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    if (_task.isOverdue) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.error),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.warning,
                              color: AppColors.error,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'This task is overdue',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                  ],

                  // Course
                  if (_task.courseName != null) ...[
                    _buildDetailRow(
                      icon: Icons.class_,
                      title: 'Course',
                      content: Text(
                        _task.courseName!,
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Tags
                  if (_task.tags.isNotEmpty) ...[
                    _buildSectionHeader('Tags'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _task.tags.map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '#$tag',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Subtasks
                  if (_task.subtasks.isNotEmpty) ...[
                    Row(
                      children: [
                        _buildSectionHeader('Subtasks'),
                        const Spacer(),
                        Text(
                          _task.progressText,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: _task.subtasks.map((subtask) {
                            return SubtaskItem(
                              subtask: subtask,
                              onToggle: (value) =>
                                  _toggleSubtask(subtask),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Created Date
                  _buildDetailRow(
                    icon: Icons.access_time,
                    title: 'Created',
                    content: Text(
                      _formatDateTime(_task.createdAt),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),

                  // Completed Date
                  if (_task.completedAt != null) ...[
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      icon: Icons.check_circle,
                      title: 'Completed',
                      content: Text(
                        _formatDateTime(_task.completedAt!),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 32),

                  // Action Buttons
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _toggleStatus,
                      icon: Icon(
                        _task.isCompleted
                            ? Icons.undo
                            : Icons.check_circle,
                      ),
                      label: Text(
                        _task.isCompleted
                            ? 'Mark as Incomplete'
                            : 'Mark as Complete',
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: _task.isCompleted
                            ? AppColors.warning
                            : AppColors.success,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
            letterSpacing: 0.5,
          ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required Widget content,
  }) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              content,
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(date.year, date.month, date.day);
    final difference = taskDate.difference(today).inDays;

    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    final dateStr =
        '${months[date.month - 1]} ${date.day}, ${date.year}';

    if (difference == 0) return '$dateStr (Today)';
    if (difference == 1) return '$dateStr (Tomorrow)';
    if (difference == -1) return '$dateStr (Yesterday)';
    if (difference < -1) return '$dateStr (${-difference} days ago)';
    if (difference < 7) return '$dateStr (in $difference days)';

    return dateStr;
  }

  String _formatDateTime(DateTime dateTime) {
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

    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

    return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year} at $displayHour:$minute $period';
  }

  void _toggleFavorite() {
    setState(() {
      _task = _task.copyWith(isFavorite: !_task.isFavorite);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _task.isFavorite
              ? 'Added to favorites'
              : 'Removed from favorites',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _toggleStatus() {
    setState(() {
      final newStatus =
          _task.isCompleted ? TaskStatus.todo : TaskStatus.completed;
      _task = _task.copyWith(
        status: newStatus,
        completedAt:
            newStatus == TaskStatus.completed ? DateTime.now() : null,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _task.isCompleted
              ? 'Task completed!'
              : 'Task marked as incomplete',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _toggleSubtask(SubtaskModel subtask) {
    setState(() {
      final subtasks = _task.subtasks.map((st) {
        if (st.id == subtask.id) {
          return st.copyWith(isCompleted: !st.isCompleted);
        }
        return st;
      }).toList();
      _task = _task.copyWith(subtasks: subtasks);
    });
  }

  void _editTask() {
    Navigator.pushNamed(
      context,
      '/tasks/edit',
      arguments: _task,
    );
  }

  void _deleteTask() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task?'),
        content: Text('Are you sure you want to delete "${_task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close details screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Task deleted'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
