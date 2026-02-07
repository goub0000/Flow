// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';

/// Schedule Screen for students
/// Shows upcoming sessions, classes, and deadlines in a calendar view
class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime _currentMonth = DateTime.now();

  // Mock schedule data - TODO: Replace with backend data
  final List<ScheduleEvent> _events = [
    ScheduleEvent(
      id: '1',
      title: 'Counseling Session',
      description: 'Career guidance with your counselor',
      startTime: DateTime.now().add(const Duration(hours: 2)),
      endTime: DateTime.now().add(const Duration(hours: 3)),
      type: EventType.counseling,
      location: 'Online - Video Call',
    ),
    ScheduleEvent(
      id: '2',
      title: 'Application Deadline',
      description: 'University of Ghana application due',
      startTime: DateTime.now().add(const Duration(days: 3)),
      endTime: DateTime.now().add(const Duration(days: 3)),
      type: EventType.deadline,
    ),
    ScheduleEvent(
      id: '3',
      title: 'Flutter Course - Module 3',
      description: 'State Management with Riverpod',
      startTime: DateTime.now().add(const Duration(days: 1, hours: 10)),
      endTime: DateTime.now().add(const Duration(days: 1, hours: 12)),
      type: EventType.course,
      location: 'Online',
    ),
    ScheduleEvent(
      id: '4',
      title: 'Group Study Session',
      description: 'Math preparation with study group',
      startTime: DateTime.now().add(const Duration(days: 2, hours: 14)),
      endTime: DateTime.now().add(const Duration(days: 2, hours: 16)),
      type: EventType.study,
      location: 'Library Room 204',
    ),
    ScheduleEvent(
      id: '5',
      title: 'Essay Submission',
      description: 'Personal statement for MIT application',
      startTime: DateTime.now().add(const Duration(days: 5)),
      endTime: DateTime.now().add(const Duration(days: 5)),
      type: EventType.deadline,
    ),
  ];

  List<ScheduleEvent> get _eventsForSelectedDate {
    return _events.where((event) {
      return event.startTime.year == _selectedDate.year &&
          event.startTime.month == _selectedDate.month &&
          event.startTime.day == _selectedDate.day;
    }).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  bool _hasEventsOnDate(DateTime date) {
    return _events.any((event) {
      return event.startTime.year == date.year &&
          event.startTime.month == date.month &&
          event.startTime.day == date.day;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.studentScheduleTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: () {
              setState(() {
                _selectedDate = DateTime.now();
                _currentMonth = DateTime.now();
              });
            },
            tooltip: context.l10n.studentScheduleGoToToday,
          ),
        ],
      ),
      body: Column(
        children: [
          // Calendar
          _buildCalendar(theme),
          const Divider(height: 1),
          // Events list
          Expanded(
            child: _buildEventsList(theme),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.studentScheduleAddEventSoon)),
          );
        },
        icon: const Icon(Icons.add),
        label: Text(context.l10n.studentScheduleAddEvent),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildCalendar(ThemeData theme) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildCalendarHeader(theme),
          _buildWeekdayHeaders(),
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              setState(() {
                _currentMonth = DateTime(
                  _currentMonth.year,
                  _currentMonth.month - 1,
                );
              });
            },
          ),
          Text(
            DateFormat('MMMM yyyy').format(_currentMonth),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              setState(() {
                _currentMonth = DateTime(
                  _currentMonth.year,
                  _currentMonth.month + 1,
                );
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeaders() {
    final weekdays = [
      context.l10n.studentScheduleWeekdaySun,
      context.l10n.studentScheduleWeekdayMon,
      context.l10n.studentScheduleWeekdayTue,
      context.l10n.studentScheduleWeekdayWed,
      context.l10n.studentScheduleWeekdayThu,
      context.l10n.studentScheduleWeekdayFri,
      context.l10n.studentScheduleWeekdaySat,
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: weekdays.map((day) {
          return Expanded(
            child: Center(
              child: Text(
                day,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final startWeekday = firstDayOfMonth.weekday % 7;

    final totalCells = startWeekday + daysInMonth;
    final rows = (totalCells / 7).ceil();

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: List.generate(rows, (rowIndex) {
          return Row(
            children: List.generate(7, (colIndex) {
              final cellIndex = rowIndex * 7 + colIndex;
              final dayNumber = cellIndex - startWeekday + 1;

              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return const Expanded(child: SizedBox(height: 44));
              }

              final date = DateTime(_currentMonth.year, _currentMonth.month, dayNumber);
              final isSelected = _selectedDate.day == date.day &&
                  _selectedDate.month == date.month &&
                  _selectedDate.year == date.year;
              final isToday = date.day == today.day &&
                  date.month == today.month &&
                  date.year == today.year;
              final hasEvents = _hasEventsOnDate(date);

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => _selectedDate = date);
                  },
                  child: Container(
                    height: 44,
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : isToday
                              ? AppColors.primary.withValues(alpha: 0.1)
                              : null,
                      borderRadius: BorderRadius.circular(8),
                      border: isToday && !isSelected
                          ? Border.all(color: AppColors.primary, width: 1.5)
                          : null,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          dayNumber.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected || isToday
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                        if (hasEvents)
                          Positioned(
                            bottom: 4,
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.white : AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        }),
      ),
    );
  }

  Widget _buildEventsList(ThemeData theme) {
    final events = _eventsForSelectedDate;
    final dateStr = DateFormat('EEEE, MMMM d').format(_selectedDate);

    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_available,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.studentScheduleNoEventsOn(dateStr),
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.studentScheduleEnjoyFreeTime,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          dateStr,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...events.map((event) => _buildEventCard(event, theme)),
      ],
    );
  }

  Widget _buildEventCard(ScheduleEvent event, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: event.type.color.withValues(alpha: 0.3)),
      ),
      child: InkWell(
        onTap: () => _showEventDetails(event),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time indicator
              Container(
                width: 4,
                height: 60,
                decoration: BoxDecoration(
                  color: event.type.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              // Event details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          event.type.icon,
                          size: 16,
                          color: event.type.color,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          event.type.labelFor(context),
                          style: TextStyle(
                            fontSize: 12,
                            color: event.type.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (event.description != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        event.description!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          event.type == EventType.deadline
                              ? context.l10n.studentScheduleDueBy(DateFormat('h:mm a').format(event.endTime))
                              : '${DateFormat('h:mm a').format(event.startTime)} - ${DateFormat('h:mm a').format(event.endTime)}',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                        if (event.location != null) ...[
                          const SizedBox(width: 12),
                          Icon(Icons.location_on, size: 14, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              event.location!,
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  void _showEventDetails(ScheduleEvent event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.8,
        expand: false,
        builder: (context, scrollController) => ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: event.type.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(event.type.icon, size: 16, color: event.type.color),
                      const SizedBox(width: 6),
                      Text(
                        event.type.labelFor(context),
                        style: TextStyle(
                          color: event.type.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              event.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if (event.description != null) ...[
              const SizedBox(height: 8),
              Text(
                event.description!,
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            ],
            const SizedBox(height: 24),
            _buildDetailRow(Icons.calendar_today, context.l10n.studentScheduleDate,
                DateFormat('EEEE, MMMM d, y').format(event.startTime)),
            _buildDetailRow(
              Icons.access_time,
              context.l10n.studentScheduleTime,
              event.type == EventType.deadline
                  ? context.l10n.studentScheduleDueBy(DateFormat('h:mm a').format(event.endTime))
                  : '${DateFormat('h:mm a').format(event.startTime)} - ${DateFormat('h:mm a').format(event.endTime)}',
            ),
            if (event.location != null)
              _buildDetailRow(Icons.location_on, context.l10n.studentScheduleLocation, event.location!),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(context.l10n.studentScheduleEditSoon)),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: Text(context.l10n.studentScheduleEdit),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(context.l10n.studentScheduleReminderSet)),
                      );
                    },
                    icon: const Icon(Icons.notifications),
                    label: Text(context.l10n.studentScheduleRemindMe),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[500]),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Event types
enum EventType {
  counseling,
  course,
  deadline,
  study,
  other;

  String labelFor(BuildContext context) {
    switch (this) {
      case EventType.counseling:
        return context.l10n.studentScheduleEventCounseling;
      case EventType.course:
        return context.l10n.studentScheduleEventCourse;
      case EventType.deadline:
        return context.l10n.studentScheduleEventDeadline;
      case EventType.study:
        return context.l10n.studentScheduleEventStudy;
      case EventType.other:
        return context.l10n.studentScheduleEventOther;
    }
  }

  IconData get icon {
    switch (this) {
      case EventType.counseling:
        return Icons.psychology;
      case EventType.course:
        return Icons.school;
      case EventType.deadline:
        return Icons.flag;
      case EventType.study:
        return Icons.menu_book;
      case EventType.other:
        return Icons.event;
    }
  }

  Color get color {
    switch (this) {
      case EventType.counseling:
        return Colors.teal;
      case EventType.course:
        return Colors.blue;
      case EventType.deadline:
        return Colors.red;
      case EventType.study:
        return Colors.orange;
      case EventType.other:
        return Colors.grey;
    }
  }
}

/// Schedule event model
class ScheduleEvent {
  final String id;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final EventType type;
  final String? location;

  ScheduleEvent({
    required this.id,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    required this.type,
    this.location,
  });
}
