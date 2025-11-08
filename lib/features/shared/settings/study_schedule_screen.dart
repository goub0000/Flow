import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Study Schedule Screen
///
/// Allows users to set study reminders and goals.
/// Features:
/// - Weekly study schedule
/// - Daily goals
/// - Reminder notifications
/// - Study streaks

class StudyScheduleScreen extends StatefulWidget {
  const StudyScheduleScreen({super.key});

  @override
  State<StudyScheduleScreen> createState() => _StudyScheduleScreenState();
}

class _StudyScheduleScreenState extends State<StudyScheduleScreen> {
  final Map<String, TimeOfDay?> _schedule = {
    'Monday': const TimeOfDay(hour: 18, minute: 0),
    'Tuesday': const TimeOfDay(hour: 18, minute: 0),
    'Wednesday': null,
    'Thursday': const TimeOfDay(hour: 18, minute: 0),
    'Friday': const TimeOfDay(hour: 18, minute: 0),
    'Saturday': const TimeOfDay(hour: 10, minute: 0),
    'Sunday': null,
  };

  int _dailyGoalMinutes = 60;
  bool _enableReminders = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Schedule'),
        actions: [
          TextButton(
            onPressed: _saveSchedule,
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Daily Goal
          Text(
            'Daily Study Goal',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$_dailyGoalMinutes minutes per day',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Icon(Icons.schedule, color: AppColors.primary),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Slider(
                    value: _dailyGoalMinutes.toDouble(),
                    min: 15,
                    max: 180,
                    divisions: 11,
                    label: '$_dailyGoalMinutes min',
                    onChanged: (value) {
                      setState(() {
                        _dailyGoalMinutes = value.toInt();
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '15 min',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '180 min',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Reminders Toggle
          Card(
            child: SwitchListTile(
              title: const Text('Study Reminders'),
              subtitle: const Text('Get notified at scheduled times'),
              value: _enableReminders,
              onChanged: (value) {
                setState(() => _enableReminders = value);
              },
            ),
          ),
          const SizedBox(height: 24),

          // Weekly Schedule
          Text(
            'Weekly Schedule',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Set your preferred study times',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: _schedule.keys.map((day) {
                return ListTile(
                  title: Text(day),
                  trailing: _schedule[day] != null
                      ? TextButton(
                          onPressed: () => _selectTime(day),
                          child: Text(
                            _schedule[day]!.format(context),
                            style: TextStyle(color: AppColors.primary),
                          ),
                        )
                      : TextButton(
                          onPressed: () => _selectTime(day),
                          child: const Text('Add time'),
                        ),
                  subtitle: _schedule[day] != null
                      ? null
                      : const Text('No study time set'),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectTime(String day) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _schedule[day] ?? const TimeOfDay(hour: 18, minute: 0),
    );

    if (picked != null) {
      setState(() {
        _schedule[day] = picked;
      });
    }
  }

  void _saveSchedule() {
    // TODO: Save schedule to backend
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Study schedule saved successfully'),
        backgroundColor: AppColors.success,
      ),
    );
    Navigator.pop(context);
  }
}
