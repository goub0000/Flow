import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Course Preferences Screen
///
/// Allows users to customize their learning experience.
/// Features:
/// - Learning goals
/// - Difficulty preferences
/// - Subject interests
/// - Study pace
/// - Notification preferences for courses

class CoursePreferencesScreen extends StatefulWidget {
  const CoursePreferencesScreen({super.key});

  @override
  State<CoursePreferencesScreen> createState() =>
      _CoursePreferencesScreenState();
}

class _CoursePreferencesScreenState extends State<CoursePreferencesScreen> {
  String _studyPace = 'moderate';
  String _difficulty = 'intermediate';
  final Set<String> _selectedInterests = {'programming', 'design'};

  final List<String> _availableInterests = [
    'programming',
    'design',
    'business',
    'marketing',
    'data science',
    'languages',
    'music',
    'art',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Preferences'),
        actions: [
          TextButton(
            onPressed: _savePreferences,
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
          // Learning Goals
          Text(
            'Learning Goals',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'What do you want to achieve?',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Main Goal',
                      hintText: 'e.g., Learn web development',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Study Pace
          Text(
            'Study Pace',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                RadioListTile<String>(
                  title: const Text('Relaxed'),
                  subtitle: const Text('1-2 hours per week'),
                  value: 'relaxed',
                  groupValue: _studyPace,
                  onChanged: (value) {
                    setState(() => _studyPace = value!);
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Moderate'),
                  subtitle: const Text('3-5 hours per week'),
                  value: 'moderate',
                  groupValue: _studyPace,
                  onChanged: (value) {
                    setState(() => _studyPace = value!);
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Intensive'),
                  subtitle: const Text('6+ hours per week'),
                  value: 'intensive',
                  groupValue: _studyPace,
                  onChanged: (value) {
                    setState(() => _studyPace = value!);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Difficulty Level
          Text(
            'Preferred Difficulty',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                RadioListTile<String>(
                  title: const Text('Beginner'),
                  subtitle: const Text('I\'m just starting out'),
                  value: 'beginner',
                  groupValue: _difficulty,
                  onChanged: (value) {
                    setState(() => _difficulty = value!);
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Intermediate'),
                  subtitle: const Text('I have some experience'),
                  value: 'intermediate',
                  groupValue: _difficulty,
                  onChanged: (value) {
                    setState(() => _difficulty = value!);
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Advanced'),
                  subtitle: const Text('I\'m looking for challenges'),
                  value: 'advanced',
                  groupValue: _difficulty,
                  onChanged: (value) {
                    setState(() => _difficulty = value!);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Interests
          Text(
            'Subject Interests',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select your areas of interest',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableInterests.map((interest) {
                  final isSelected = _selectedInterests.contains(interest);
                  return FilterChip(
                    label: Text(interest),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedInterests.add(interest);
                        } else {
                          _selectedInterests.remove(interest);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _savePreferences() {
    // TODO: Save preferences to backend
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Preferences saved successfully'),
        backgroundColor: AppColors.success,
      ),
    );
    Navigator.pop(context);
  }
}
