import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/l10n_extension.dart';
import '../widgets/schedule_widgets.dart';

/// Calendar Screen
///
/// Main calendar interface with multiple views:
/// - Month view with event indicators
/// - Week view with time slots
/// - Day view with hourly schedule
/// - Event filtering by type
/// - Quick add event
///
/// Backend Integration TODO:
/// - Fetch events from backend
/// - Real-time event synchronization
/// - Calendar sharing
/// - Export to external calendars

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDate = DateTime.now();
  DateTime _currentMonth = DateTime.now();
  EventType? _filterType;
  late List<EventModel> _events;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _generateMockEvents();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _generateMockEvents() {
    final now = DateTime.now();
    _events = [
      EventModel(
        id: '1',
        title: 'Flutter Development Lecture',
        description: 'Introduction to Flutter widgets and state management',
        type: EventType.lecture,
        startTime: DateTime(now.year, now.month, now.day, 9, 0),
        endTime: DateTime(now.year, now.month, now.day, 10, 30),
        location: 'Room 301',
        courseId: '1',
        courseName: 'Mobile App Development',
        priority: EventPriority.medium,
      ),
      EventModel(
        id: '2',
        title: 'Assignment 3 Due',
        description: 'Submit Flutter todo app project',
        type: EventType.assignment,
        startTime: DateTime(now.year, now.month, now.day, 23, 59),
        endTime: DateTime(now.year, now.month, now.day, 23, 59),
        courseId: '1',
        courseName: 'Mobile App Development',
        priority: EventPriority.high,
        hasReminder: true,
        reminderBefore: const Duration(hours: 2),
      ),
      EventModel(
        id: '3',
        title: 'Midterm Exam',
        description: 'Chapters 1-5, bring calculator',
        type: EventType.exam,
        startTime: DateTime(now.year, now.month, now.day + 2, 14, 0),
        endTime: DateTime(now.year, now.month, now.day + 2, 16, 0),
        location: 'Exam Hall A',
        courseId: '2',
        courseName: 'Data Structures',
        priority: EventPriority.high,
        hasReminder: true,
        reminderBefore: const Duration(hours: 24),
      ),
      EventModel(
        id: '4',
        title: 'Study Group Meeting',
        description: 'Review for upcoming exam',
        type: EventType.meeting,
        startTime: DateTime(now.year, now.month, now.day + 1, 15, 0),
        endTime: DateTime(now.year, now.month, now.day + 1, 17, 0),
        location: 'Library Room 5',
        attendees: ['John', 'Sarah', 'Mike'],
        priority: EventPriority.medium,
      ),
      EventModel(
        id: '5',
        title: 'Office Hours - Dr. Smith',
        description: 'Ask about final project requirements',
        type: EventType.meeting,
        startTime: DateTime(now.year, now.month, now.day, 13, 0),
        endTime: DateTime(now.year, now.month, now.day, 14, 0),
        location: 'Office 204',
        priority: EventPriority.low,
      ),
      EventModel(
        id: '6',
        title: 'Web Development Lab',
        type: EventType.lecture,
        startTime: DateTime(now.year, now.month, now.day + 3, 10, 0),
        endTime: DateTime(now.year, now.month, now.day + 3, 12, 0),
        location: 'Computer Lab 2',
        courseId: '3',
        courseName: 'Web Technologies',
        recurrence: EventRecurrence.weekly,
      ),
      EventModel(
        id: '7',
        title: 'Submit Research Paper',
        description: 'Final draft of research paper on AI',
        type: EventType.assignment,
        startTime: DateTime(now.year, now.month, now.day + 5, 17, 0),
        endTime: DateTime(now.year, now.month, now.day + 5, 17, 0),
        courseId: '4',
        courseName: 'Artificial Intelligence',
        priority: EventPriority.high,
      ),
    ];
  }

  List<EventModel> get _filteredEvents {
    return _events.where((event) {
      if (_filterType != null && event.type != _filterType) {
        return false;
      }
      return true;
    }).toList();
  }

  List<EventModel> _getEventsForDate(DateTime date) {
    return _filteredEvents.where((event) {
      return event.startTime.year == date.year &&
          event.startTime.month == date.month &&
          event.startTime.day == date.day;
    }).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.sharedScheduleCalendar),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterOptions,
            tooltip: context.l10n.sharedScheduleFilter,
          ),
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: _goToToday,
            tooltip: context.l10n.sharedScheduleToday,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Month'),
            Tab(text: 'Week'),
            Tab(text: 'Day'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Date Navigation
          _buildDateNavigation(),

          // Filter Chips
          if (_filterType != null) _buildFilterChips(),

          // Calendar Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMonthView(),
                _buildWeekView(),
                _buildDayView(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'calendar_fab',
        onPressed: _addEvent,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDateNavigation() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _previousPeriod,
          ),
          Expanded(
            child: Text(
              _getDateRangeText(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _nextPeriod,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          EventTypeChip(
            type: _filterType!,
            isSelected: true,
          ),
          const SizedBox(width: 8),
          TextButton.icon(
            onPressed: () {
              setState(() {
                _filterType = null;
              });
            },
            icon: const Icon(Icons.close, size: 16),
            label: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthView() {
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDayOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday % 7;
    final daysInMonth = lastDayOfMonth.day;

    return Column(
      children: [
        // Weekday Headers
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                        ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        // Calendar Grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: 42,
            itemBuilder: (context, index) {
              final dayNumber = index - firstWeekday + 1;

              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return const SizedBox();
              }

              final date =
                  DateTime(_currentMonth.year, _currentMonth.month, dayNumber);
              final events = _getEventsForDate(date);
              final isSelected = _isSameDay(date, _selectedDate);
              final isToday = _isSameDay(date, DateTime.now());

              return CalendarDayCell(
                date: date,
                isSelected: isSelected,
                isToday: isToday,
                isCurrentMonth: true,
                events: events,
                onTap: () {
                  setState(() {
                    _selectedDate = date;
                  });
                },
              );
            },
          ),
        ),

        // Events for Selected Day
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: AppColors.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: _buildEventsList(_getEventsForDate(_selectedDate)),
        ),
      ],
    );
  }

  Widget _buildWeekView() {
    final startOfWeek = _selectedDate.subtract(
      Duration(days: _selectedDate.weekday % 7),
    );

    return Column(
      children: [
        // Week Days Header
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: List.generate(7, (index) {
              final date = startOfWeek.add(Duration(days: index));
              final isToday = _isSameDay(date, DateTime.now());
              final isSelected = _isSameDay(date, _selectedDate);

              return Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : isToday
                              ? AppColors.primary.withValues(alpha: 0.1)
                              : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          ['S', 'M', 'T', 'W', 'T', 'F', 'S'][index],
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textSecondary,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${date.day}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color:
                                    isSelected ? Colors.white : AppColors.textPrimary,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),

        // Events for Week
        Expanded(
          child: _buildEventsList(_getEventsForDate(_selectedDate)),
        ),
      ],
    );
  }

  Widget _buildDayView() {
    final events = _getEventsForDate(_selectedDate);

    return ListView.builder(
      itemCount: 24,
      itemBuilder: (context, hour) {
        final hourEvents = events.where((event) {
          return event.startTime.hour == hour;
        }).toList();

        return TimeSlot(
          hour: hour,
          events: hourEvents,
          onTap: () {
            _addEventAtTime(hour);
          },
        );
      },
    );
  }

  Widget _buildEventsList(List<EventModel> events) {
    if (events.isEmpty) {
      return EmptyScheduleState(
        message: 'No events',
        subtitle: 'Tap + to add an event',
        onAddEvent: _addEvent,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return EventCard(
          event: event,
          onTap: () => _viewEventDetails(event),
          onComplete: () => _toggleEventComplete(event),
          onDelete: () => _deleteEvent(event),
        );
      },
    );
  }

  String _getDateRangeText() {
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

    switch (_tabController.index) {
      case 0: // Month
        return '${months[_currentMonth.month - 1]} ${_currentMonth.year}';
      case 1: // Week
        final startOfWeek = _selectedDate.subtract(
          Duration(days: _selectedDate.weekday % 7),
        );
        final endOfWeek = startOfWeek.add(const Duration(days: 6));
        return '${months[startOfWeek.month - 1]} ${startOfWeek.day} - ${months[endOfWeek.month - 1]} ${endOfWeek.day}';
      case 2: // Day
        return '${months[_selectedDate.month - 1]} ${_selectedDate.day}, ${_selectedDate.year}';
      default:
        return '';
    }
  }

  void _previousPeriod() {
    setState(() {
      switch (_tabController.index) {
        case 0: // Month
          _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
          break;
        case 1: // Week
          _selectedDate = _selectedDate.subtract(const Duration(days: 7));
          break;
        case 2: // Day
          _selectedDate = _selectedDate.subtract(const Duration(days: 1));
          break;
      }
    });
  }

  void _nextPeriod() {
    setState(() {
      switch (_tabController.index) {
        case 0: // Month
          _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
          break;
        case 1: // Week
          _selectedDate = _selectedDate.add(const Duration(days: 7));
          break;
        case 2: // Day
          _selectedDate = _selectedDate.add(const Duration(days: 1));
          break;
      }
    });
  }

  void _goToToday() {
    setState(() {
      final now = DateTime.now();
      _selectedDate = now;
      _currentMonth = now;
    });
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Filter by Type'),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const Divider(height: 1),
            ...EventType.values.map((type) {
              return ListTile(
                leading: Icon(type.icon, color: type.color),
                title: Text(type.displayName),
                onTap: () {
                  setState(() {
                    _filterType = type;
                  });
                  Navigator.pop(context);
                },
              );
            }),
            ListTile(
              leading: const Icon(Icons.clear),
              title: const Text('Clear Filter'),
              onTap: () {
                setState(() {
                  _filterType = null;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _addEvent() {
    Navigator.pushNamed(
      context,
      '/schedule/add-event',
      arguments: _selectedDate,
    );
  }

  void _addEventAtTime(int hour) {
    final eventTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      hour,
      0,
    );
    Navigator.pushNamed(
      context,
      '/schedule/add-event',
      arguments: eventTime,
    );
  }

  void _viewEventDetails(EventModel event) {
    Navigator.pushNamed(
      context,
      '/schedule/event-details',
      arguments: event,
    );
  }

  void _toggleEventComplete(EventModel event) {
    setState(() {
      final index = _events.indexWhere((e) => e.id == event.id);
      if (index != -1) {
        _events[index] = event.copyWith(isCompleted: !event.isCompleted);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          event.isCompleted ? 'Marked as incomplete' : 'Marked as complete',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _deleteEvent(EventModel event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event?'),
        content: Text('Are you sure you want to delete "${event.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                _events.removeWhere((e) => e.id == event.id);
              });
              Navigator.pop(context);
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

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
