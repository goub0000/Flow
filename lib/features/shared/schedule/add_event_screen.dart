import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/schedule_widgets.dart';

/// Add/Edit Event Screen
///
/// Form for creating and editing calendar events:
/// - Event type selection
/// - Title and description
/// - Date and time pickers
/// - Location input
/// - Course association
/// - Priority and recurrence
/// - Reminder configuration
/// - Attendee management
///
/// Backend Integration TODO:
/// - Save event to backend
/// - Validate event conflicts
/// - Send notifications
/// - Sync with calendar services

class AddEventScreen extends StatefulWidget {
  final EventModel? event;
  final DateTime? initialDate;

  const AddEventScreen({
    super.key,
    this.event,
    this.initialDate,
  });

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  late EventType _selectedType;
  late DateTime _startDate;
  late TimeOfDay _startTime;
  late DateTime _endDate;
  late TimeOfDay _endTime;
  EventPriority _priority = EventPriority.medium;
  EventRecurrence _recurrence = EventRecurrence.none;
  bool _hasReminder = false;
  Duration _reminderBefore = const Duration(minutes: 30);
  String? _selectedCourseId;
  final List<String> _attendees = [];

  bool get _isEditing => widget.event != null;

  @override
  void initState() {
    super.initState();

    if (widget.event != null) {
      // Editing existing event
      final event = widget.event!;
      _titleController.text = event.title;
      _descriptionController.text = event.description ?? '';
      _locationController.text = event.location ?? '';
      _selectedType = event.type;
      _startDate = event.startTime;
      _startTime = TimeOfDay.fromDateTime(event.startTime);
      _endDate = event.endTime;
      _endTime = TimeOfDay.fromDateTime(event.endTime);
      _priority = event.priority;
      _recurrence = event.recurrence;
      _hasReminder = event.hasReminder;
      _reminderBefore = event.reminderBefore ?? const Duration(minutes: 30);
      _selectedCourseId = event.courseId;
      _attendees.addAll(event.attendees);
    } else {
      // Creating new event
      _selectedType = EventType.other;
      final initialDateTime = widget.initialDate ?? DateTime.now();
      _startDate = initialDateTime;
      _startTime = TimeOfDay.fromDateTime(initialDateTime);
      _endDate = initialDateTime;
      _endTime = TimeOfDay(
        hour: (initialDateTime.hour + 1) % 24,
        minute: initialDateTime.minute,
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Event' : 'Add Event'),
        actions: [
          TextButton(
            onPressed: _saveEvent,
            child: const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Event Type Selection
            _buildSectionHeader('Event Type'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: EventType.values.map((type) {
                return EventTypeChip(
                  type: type,
                  isSelected: type == _selectedType,
                  onTap: () {
                    setState(() {
                      _selectedType = type;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Title
            _buildSectionHeader('Title'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Enter event title',
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

            // Start Date & Time
            _buildSectionHeader('Start'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildDateField(_startDate, (date) {
                    setState(() {
                      _startDate = date;
                    });
                  }),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTimeField(_startTime, (time) {
                    setState(() {
                      _startTime = time;
                    });
                  }),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // End Date & Time
            _buildSectionHeader('End'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildDateField(_endDate, (date) {
                    setState(() {
                      _endDate = date;
                    });
                  }),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTimeField(_endTime, (time) {
                    setState(() {
                      _endTime = time;
                    });
                  }),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Location
            _buildSectionHeader('Location (Optional)'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                hintText: 'Add location',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 24),

            // Priority
            _buildSectionHeader('Priority'),
            const SizedBox(height: 8),
            SegmentedButton<EventPriority>(
              segments: EventPriority.values.map((priority) {
                return ButtonSegment<EventPriority>(
                  value: priority,
                  label: Text(priority.displayName),
                  icon: Icon(
                    Icons.circle,
                    size: 12,
                    color: priority.color,
                  ),
                );
              }).toList(),
              selected: {_priority},
              onSelectionChanged: (Set<EventPriority> selected) {
                setState(() {
                  _priority = selected.first;
                });
              },
            ),
            const SizedBox(height: 24),

            // Recurrence
            _buildSectionHeader('Recurrence'),
            const SizedBox(height: 8),
            DropdownButtonFormField<EventRecurrence>(
              initialValue: _recurrence,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.repeat),
              ),
              items: EventRecurrence.values.map((recurrence) {
                return DropdownMenuItem(
                  value: recurrence,
                  child: Text(recurrence.displayName),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _recurrence = value;
                  });
                }
              },
            ),
            const SizedBox(height: 24),

            // Reminder
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Reminder',
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
                    if (_hasReminder) ...[
                      const SizedBox(height: 16),
                      DropdownButtonFormField<Duration>(
                        initialValue: _reminderBefore,
                        decoration: const InputDecoration(
                          labelText: 'Remind me',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: Duration(minutes: 5),
                            child: Text('5 minutes before'),
                          ),
                          DropdownMenuItem(
                            value: Duration(minutes: 15),
                            child: Text('15 minutes before'),
                          ),
                          DropdownMenuItem(
                            value: Duration(minutes: 30),
                            child: Text('30 minutes before'),
                          ),
                          DropdownMenuItem(
                            value: Duration(hours: 1),
                            child: Text('1 hour before'),
                          ),
                          DropdownMenuItem(
                            value: Duration(hours: 2),
                            child: Text('2 hours before'),
                          ),
                          DropdownMenuItem(
                            value: Duration(hours: 24),
                            child: Text('1 day before'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _reminderBefore = value;
                            });
                          }
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Course (if lecture/assignment/exam)
            if (_selectedType == EventType.lecture ||
                _selectedType == EventType.assignment ||
                _selectedType == EventType.exam) ...[
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
            ],

            // Attendees (if meeting)
            if (_selectedType == EventType.meeting) ...[
              _buildSectionHeader('Attendees'),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_attendees.isEmpty)
                        Text(
                          'No attendees added',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        )
                      else
                        ..._attendees.map((attendee) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  radius: 16,
                                  child: Icon(Icons.person, size: 16),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(attendee),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, size: 20),
                                  onPressed: () {
                                    setState(() {
                                      _attendees.remove(attendee);
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        }),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: _addAttendee,
                        icon: const Icon(Icons.person_add),
                        label: const Text('Add Attendee'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Save Button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _saveEvent,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(_isEditing ? 'Update Event' : 'Create Event'),
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

  Widget _buildDateField(DateTime date, Function(DateTime) onDateChanged) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (picked != null) {
          onDateChanged(picked);
        }
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.calendar_today),
        ),
        child: Text(_formatDate(date)),
      ),
    );
  }

  Widget _buildTimeField(TimeOfDay time, Function(TimeOfDay) onTimeChanged) {
    return InkWell(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: time,
        );
        if (picked != null) {
          onTimeChanged(picked);
        }
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.access_time),
        ),
        child: Text(time.format(context)),
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

  List<Map<String, String>> _getMockCourses() {
    return [
      {'id': '1', 'name': 'Mobile App Development'},
      {'id': '2', 'name': 'Data Structures'},
      {'id': '3', 'name': 'Web Technologies'},
      {'id': '4', 'name': 'Artificial Intelligence'},
    ];
  }

  void _addAttendee() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Attendee'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Name or Email',
            border: OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final attendee = controller.text.trim();
              if (attendee.isNotEmpty) {
                setState(() {
                  _attendees.add(attendee);
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

  void _saveEvent() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Combine date and time
    final startDateTime = DateTime(
      _startDate.year,
      _startDate.month,
      _startDate.day,
      _startTime.hour,
      _startTime.minute,
    );

    final endDateTime = DateTime(
      _endDate.year,
      _endDate.month,
      _endDate.day,
      _endTime.hour,
      _endTime.minute,
    );

    // Validate end time is after start time
    if (endDateTime.isBefore(startDateTime) || endDateTime.isAtSameMomentAs(startDateTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('End time must be after start time'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // TODO: Save to backend
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isEditing ? 'Event updated' : 'Event created'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}
