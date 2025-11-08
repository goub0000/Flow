import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Schedule & Calendar Widgets Library
///
/// Comprehensive widget collection for calendar and event management:
/// - Event models and types
/// - Calendar views (month, week, day)
/// - Event cards and lists
/// - Time slot widgets
/// - Event creation dialogs
///
/// Backend Integration TODO:
/// - Sync with backend calendar API
/// - Real-time event updates
/// - Notification scheduling
/// - Calendar sharing and permissions

// ============================================================================
// MODELS
// ============================================================================

/// Event Type Enum
enum EventType {
  lecture,
  assignment,
  exam,
  meeting,
  reminder,
  holiday,
  other;

  String get displayName {
    switch (this) {
      case EventType.lecture:
        return 'Lecture';
      case EventType.assignment:
        return 'Assignment';
      case EventType.exam:
        return 'Exam';
      case EventType.meeting:
        return 'Meeting';
      case EventType.reminder:
        return 'Reminder';
      case EventType.holiday:
        return 'Holiday';
      case EventType.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case EventType.lecture:
        return Icons.school;
      case EventType.assignment:
        return Icons.assignment;
      case EventType.exam:
        return Icons.quiz;
      case EventType.meeting:
        return Icons.people;
      case EventType.reminder:
        return Icons.notifications;
      case EventType.holiday:
        return Icons.celebration;
      case EventType.other:
        return Icons.event;
    }
  }

  Color get color {
    switch (this) {
      case EventType.lecture:
        return AppColors.primary;
      case EventType.assignment:
        return AppColors.warning;
      case EventType.exam:
        return AppColors.error;
      case EventType.meeting:
        return AppColors.info;
      case EventType.reminder:
        return const Color(0xFF9C27B0);
      case EventType.holiday:
        return AppColors.success;
      case EventType.other:
        return AppColors.textSecondary;
    }
  }
}

/// Event Priority
enum EventPriority {
  low,
  medium,
  high;

  String get displayName {
    switch (this) {
      case EventPriority.low:
        return 'Low';
      case EventPriority.medium:
        return 'Medium';
      case EventPriority.high:
        return 'High';
    }
  }

  Color get color {
    switch (this) {
      case EventPriority.low:
        return AppColors.success;
      case EventPriority.medium:
        return AppColors.warning;
      case EventPriority.high:
        return AppColors.error;
    }
  }
}

/// Event Recurrence
enum EventRecurrence {
  none,
  daily,
  weekly,
  monthly;

  String get displayName {
    switch (this) {
      case EventRecurrence.none:
        return 'Does not repeat';
      case EventRecurrence.daily:
        return 'Daily';
      case EventRecurrence.weekly:
        return 'Weekly';
      case EventRecurrence.monthly:
        return 'Monthly';
    }
  }
}

/// Event Model
class EventModel {
  final String id;
  final String title;
  final String? description;
  final EventType type;
  final DateTime startTime;
  final DateTime endTime;
  final String? location;
  final String? courseId;
  final String? courseName;
  final EventPriority priority;
  final EventRecurrence recurrence;
  final bool hasReminder;
  final Duration? reminderBefore;
  final List<String> attendees;
  final bool isCompleted;
  final Color? customColor;

  EventModel({
    required this.id,
    required this.title,
    this.description,
    required this.type,
    required this.startTime,
    required this.endTime,
    this.location,
    this.courseId,
    this.courseName,
    this.priority = EventPriority.medium,
    this.recurrence = EventRecurrence.none,
    this.hasReminder = false,
    this.reminderBefore,
    this.attendees = const [],
    this.isCompleted = false,
    this.customColor,
  });

  Duration get duration => endTime.difference(startTime);

  String get formattedDuration {
    final minutes = duration.inMinutes;
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (hours > 0) {
      return remainingMinutes > 0
          ? '${hours}h ${remainingMinutes}m'
          : '${hours}h';
    }
    return '${minutes}m';
  }

  String get formattedTimeRange {
    final start = _formatTime(startTime);
    final end = _formatTime(endTime);
    return '$start - $end';
  }

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  bool get isToday {
    final now = DateTime.now();
    return startTime.year == now.year &&
        startTime.month == now.month &&
        startTime.day == now.day;
  }

  bool get isPast {
    return endTime.isBefore(DateTime.now());
  }

  bool get isUpcoming {
    return startTime.isAfter(DateTime.now());
  }

  bool get isInProgress {
    final now = DateTime.now();
    return startTime.isBefore(now) && endTime.isAfter(now);
  }

  Color get eventColor => customColor ?? type.color;

  EventModel copyWith({
    String? title,
    String? description,
    EventType? type,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    EventPriority? priority,
    bool? isCompleted,
  }) {
    return EventModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      courseId: courseId,
      courseName: courseName,
      priority: priority ?? this.priority,
      recurrence: recurrence,
      hasReminder: hasReminder,
      reminderBefore: reminderBefore,
      attendees: attendees,
      isCompleted: isCompleted ?? this.isCompleted,
      customColor: customColor,
    );
  }
}

// ============================================================================
// WIDGETS
// ============================================================================

/// Event Card Widget
class EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback? onTap;
  final VoidCallback? onComplete;
  final VoidCallback? onDelete;
  final bool showDate;

  const EventCard({
    super.key,
    required this.event,
    this.onTap,
    this.onComplete,
    this.onDelete,
    this.showDate = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: BorderSide(
                color: event.eventColor,
                width: 4,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Event Icon
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: event.eventColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        event.type.icon,
                        color: event.eventColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Event Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  event.title,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    decoration: event.isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (event.priority == EventPriority.high)
                                Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.error.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'High',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: AppColors.error,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 14,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                event.formattedTimeRange,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              if (showDate) ...[
                                const SizedBox(width: 8),
                                Text(
                                  '•',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _formatDate(event.startTime),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Status Badge
                    if (event.isInProgress)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Now',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),

                if (event.courseName != null || event.location != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (event.courseName != null) ...[
                        Icon(
                          Icons.class_,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            event.courseName!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                      if (event.courseName != null && event.location != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            '•',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ),
                      if (event.location != null) ...[
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            event.location!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],

                if (event.description != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    event.description!,
                    style: theme.textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                if (onComplete != null || onDelete != null) ...[
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (onComplete != null)
                        Expanded(
                          child: TextButton.icon(
                            onPressed: onComplete,
                            icon: Icon(
                              event.isCompleted
                                  ? Icons.check_circle
                                  : Icons.check_circle_outline,
                              size: 18,
                            ),
                            label: Text(
                              event.isCompleted ? 'Completed' : 'Mark Complete',
                            ),
                          ),
                        ),
                      if (onDelete != null)
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: onDelete,
                          color: AppColors.error,
                          iconSize: 20,
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final eventDate = DateTime(date.year, date.month, date.day);
    final difference = eventDate.difference(today).inDays;

    if (difference == 0) return 'Today';
    if (difference == 1) return 'Tomorrow';
    if (difference == -1) return 'Yesterday';

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

/// Compact Event List Item
class EventListItem extends StatelessWidget {
  final EventModel event;
  final VoidCallback? onTap;

  const EventListItem({
    super.key,
    required this.event,
    this.onTap,
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
            // Time
            SizedBox(
              width: 60,
              child: Text(
                _formatTime(event.startTime),
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: event.isInProgress
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
              ),
            ),

            // Event Indicator
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                color: event.eventColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),

            // Event Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      decoration:
                          event.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (event.location != null) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 12,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.location!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Duration
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: event.eventColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                event.formattedDuration,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: event.eventColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }
}

/// Calendar Day Cell
class CalendarDayCell extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final bool isToday;
  final bool isCurrentMonth;
  final List<EventModel> events;
  final VoidCallback? onTap;

  const CalendarDayCell({
    super.key,
    required this.date,
    this.isSelected = false,
    this.isToday = false,
    this.isCurrentMonth = true,
    this.events = const [],
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : isToday
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : null,
          borderRadius: BorderRadius.circular(8),
          border: isToday && !isSelected
              ? Border.all(color: AppColors.primary, width: 2)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${date.day}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? Colors.white
                    : !isCurrentMonth
                        ? AppColors.textSecondary.withValues(alpha: 0.5)
                        : AppColors.textPrimary,
              ),
            ),
            if (events.isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: events.take(3).map((event) {
                  return Container(
                    width: 4,
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : event.eventColor,
                      shape: BoxShape.circle,
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty Schedule State
class EmptyScheduleState extends StatelessWidget {
  final String message;
  final String? subtitle;
  final VoidCallback? onAddEvent;

  const EmptyScheduleState({
    super.key,
    this.message = 'No events scheduled',
    this.subtitle,
    this.onAddEvent,
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
              Icons.event_available,
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
            if (onAddEvent != null) ...[
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onAddEvent,
                icon: const Icon(Icons.add),
                label: const Text('Add Event'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Event Type Filter Chip
class EventTypeChip extends StatelessWidget {
  final EventType type;
  final bool isSelected;
  final VoidCallback? onTap;

  const EventTypeChip({
    super.key,
    required this.type,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FilterChip(
      label: Text(type.displayName),
      avatar: Icon(
        type.icon,
        size: 18,
        color: isSelected ? Colors.white : type.color,
      ),
      selected: isSelected,
      onSelected: onTap != null ? (_) => onTap!() : null,
      backgroundColor: type.color.withValues(alpha: 0.1),
      selectedColor: type.color,
      labelStyle: theme.textTheme.bodySmall?.copyWith(
        color: isSelected ? Colors.white : type.color,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

/// Time Slot Widget for Day View
class TimeSlot extends StatelessWidget {
  final int hour;
  final List<EventModel> events;
  final VoidCallback? onTap;

  const TimeSlot({
    super.key,
    required this.hour,
    this.events = const [],
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.border.withValues(alpha: 0.3)),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 60,
              child: Padding(
                padding: const EdgeInsets.only(top: 4, right: 8),
                child: Text(
                  '$displayHour $period',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            Expanded(
              child: events.isEmpty
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.all(4),
                      child: Column(
                        children: events.map((event) {
                          return Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 2),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: event.eventColor.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                                border: Border(
                                  left: BorderSide(
                                    color: event.eventColor,
                                    width: 3,
                                  ),
                                ),
                              ),
                              child: Text(
                                event.title,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
