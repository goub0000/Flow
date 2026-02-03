import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/l10n_extension.dart';
import '../widgets/schedule_widgets.dart';

/// Event Details Screen
///
/// Displays comprehensive event information:
/// - Event details (title, time, location, etc.)
/// - Edit and delete options
/// - Add to calendar
/// - Share event
/// - Set reminders
/// - View attendees
///
/// Backend Integration TODO:
/// - Fetch event details from backend
/// - Update event information
/// - Send calendar invites
/// - Sync with external calendars

class EventDetailsScreen extends StatefulWidget {
  final EventModel event;

  const EventDetailsScreen({
    super.key,
    required this.event,
  });

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late EventModel _event;

  @override
  void initState() {
    super.initState();
    _event = widget.event;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editEvent,
            tooltip: 'Edit',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteEvent,
            tooltip: 'Delete',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _event.eventColor.withValues(alpha: 0.1),
                border: Border(
                  bottom: BorderSide(
                    color: _event.eventColor,
                    width: 3,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _event.eventColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _event.type.icon,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _event.type.displayName,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: _event.eventColor,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _event.title,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (_event.priority == EventPriority.high) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.error),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.priority_high,
                            size: 16,
                            color: AppColors.error,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'High Priority',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Event Details
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date & Time
                  _buildDetailRow(
                    icon: Icons.access_time,
                    title: 'Date & Time',
                    content: _buildDateTimeContent(),
                  ),
                  const Divider(height: 32),

                  // Duration
                  _buildDetailRow(
                    icon: Icons.timer,
                    title: 'Duration',
                    content: Text(
                      _event.formattedDuration,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),

                  if (_event.location != null) ...[
                    const Divider(height: 32),
                    _buildDetailRow(
                      icon: Icons.location_on,
                      title: 'Location',
                      content: Text(
                        _event.location!,
                        style: theme.textTheme.bodyLarge,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.directions),
                        onPressed: _getDirections,
                        tooltip: 'Get Directions',
                      ),
                    ),
                  ],

                  if (_event.courseName != null) ...[
                    const Divider(height: 32),
                    _buildDetailRow(
                      icon: Icons.class_,
                      title: 'Course',
                      content: Text(
                        _event.courseName!,
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                  ],

                  if (_event.description != null) ...[
                    const Divider(height: 32),
                    _buildDetailRow(
                      icon: Icons.description,
                      title: 'Description',
                      content: Text(
                        _event.description!,
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                  ],

                  if (_event.recurrence != EventRecurrence.none) ...[
                    const Divider(height: 32),
                    _buildDetailRow(
                      icon: Icons.repeat,
                      title: 'Recurrence',
                      content: Text(
                        _event.recurrence.displayName,
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                  ],

                  if (_event.hasReminder) ...[
                    const Divider(height: 32),
                    _buildDetailRow(
                      icon: Icons.notifications_active,
                      title: 'Reminder',
                      content: Text(
                        _formatReminderTime(_event.reminderBefore),
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                  ],

                  if (_event.attendees.isNotEmpty) ...[
                    const Divider(height: 32),
                    _buildDetailRow(
                      icon: Icons.people,
                      title: 'Attendees',
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _event.attendees.map((attendee) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              attendee,
                              style: theme.textTheme.bodyLarge,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],

                  const Divider(height: 32),

                  // Action Buttons
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _toggleComplete,
                      icon: Icon(
                        _event.isCompleted
                            ? Icons.check_circle
                            : Icons.check_circle_outline,
                      ),
                      label: Text(
                        _event.isCompleted
                            ? 'Marked as Complete'
                            : 'Mark as Complete',
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: _event.isCompleted
                            ? AppColors.success
                            : AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _addToCalendar,
                          icon: const Icon(Icons.event),
                          label: const Text('Add to Calendar'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _shareEvent,
                          icon: const Icon(Icons.share),
                          label: const Text('Share'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required Widget content,
    Widget? trailing,
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
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _buildDateTimeContent() {
    final theme = Theme.of(context);
    final dateFormat = _formatFullDate(_event.startTime);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          dateFormat,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _event.formattedTimeRange,
          style: theme.textTheme.bodyLarge,
        ),
        if (_event.isInProgress) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: AppColors.success),
            ),
            child: Text(
              'In Progress',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ] else if (_event.isPast) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Ended',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }

  String _formatFullDate(DateTime date) {
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
    final weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatReminderTime(Duration? duration) {
    if (duration == null) return 'At time of event';

    if (duration.inHours >= 24) {
      final days = duration.inHours ~/ 24;
      return '$days ${days == 1 ? 'day' : 'days'} before';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} ${duration.inHours == 1 ? 'hour' : 'hours'} before';
    } else {
      return '${duration.inMinutes} ${duration.inMinutes == 1 ? 'minute' : 'minutes'} before';
    }
  }

  void _editEvent() {
    Navigator.pushNamed(
      context,
      '/schedule/edit-event',
      arguments: _event,
    );
  }

  void _deleteEvent() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event?'),
        content: Text('Are you sure you want to delete "${_event.title}"?'),
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
                  content: Text('Event deleted'),
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

  void _toggleComplete() {
    setState(() {
      _event = _event.copyWith(isCompleted: !_event.isCompleted);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _event.isCompleted
              ? 'Marked as complete'
              : 'Marked as incomplete',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _addToCalendar() {
    // TODO: Add to device calendar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Add to calendar functionality coming soon'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _shareEvent() {
    // TODO: Share event
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality coming soon'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _getDirections() {
    // TODO: Open maps with location
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Getting directions to ${_event.location}...'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
