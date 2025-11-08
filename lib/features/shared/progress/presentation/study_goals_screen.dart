import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../widgets/progress_analytics_widgets.dart';

/// Study Goals Screen
///
/// Track and manage learning goals.

class StudyGoalsScreen extends StatefulWidget {
  const StudyGoalsScreen({super.key});

  @override
  State<StudyGoalsScreen> createState() => _StudyGoalsScreenState();
}

class _StudyGoalsScreenState extends State<StudyGoalsScreen> {
  late List<StudyGoal> _goals;

  @override
  void initState() {
    super.initState();
    _generateMockGoals();
  }

  void _generateMockGoals() {
    _goals = [
      StudyGoal(
        id: '1',
        title: 'Complete 3 courses this month',
        type: GoalType.coursesComplete,
        target: 3,
        progress: 2,
        deadline: DateTime.now().add(const Duration(days: 15)),
      ),
      StudyGoal(
        id: '2',
        title: 'Study 20 hours this week',
        type: GoalType.studyTime,
        target: 1200, // minutes
        progress: 850,
        deadline: DateTime.now().add(const Duration(days: 3)),
      ),
      StudyGoal(
        id: '3',
        title: 'Maintain 30-day streak',
        type: GoalType.streak,
        target: 30,
        progress: 7,
        deadline: DateTime.now().add(const Duration(days: 23)),
      ),
      StudyGoal(
        id: '4',
        title: 'Achieve 90% quiz average',
        type: GoalType.quizScore,
        target: 90,
        progress: 87,
        deadline: DateTime.now().add(const Duration(days: 30)),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Goals'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Your Goals',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          ..._goals.map((goal) => StudyGoalCard(goal: goal)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Create goal coming soon')),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Goal'),
      ),
    );
  }
}
