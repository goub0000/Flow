import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../widgets/progress_analytics_widgets.dart';

/// Progress Dashboard Screen
///
/// Overview of user's learning progress and statistics.
/// Features:
/// - Overall progress metrics
/// - Current streak
/// - Course progress
/// - Study time analytics
/// - Recent achievements
/// - Learning goals
///
/// Backend Integration TODO:
/// - Fetch user progress data
/// - Calculate real-time statistics
/// - Track study sessions
/// - Sync across devices

class ProgressDashboardScreen extends StatefulWidget {
  const ProgressDashboardScreen({super.key});

  @override
  State<ProgressDashboardScreen> createState() =>
      _ProgressDashboardScreenState();
}

class _ProgressDashboardScreenState extends State<ProgressDashboardScreen> {
  TimePeriod _selectedPeriod = TimePeriod.week;
  late LearningStatistics _statistics;
  late List<CourseProgress> _courseProgress;

  @override
  void initState() {
    super.initState();
    _generateMockData();
  }

  void _generateMockData() {
    _statistics = const LearningStatistics(
      totalCoursesEnrolled: 12,
      totalCoursesCompleted: 5,
      totalTimeSpent: Duration(hours: 87, minutes: 35),
      currentStreak: 7,
      longestStreak: 21,
      averageScore: 87.5,
      certificatesEarned: 5,
      assignmentsCompleted: 34,
    );

    _courseProgress = [
      CourseProgress(
        courseId: '1',
        courseTitle: 'Flutter Development Masterclass',
        completionPercentage: 75,
        completedLessons: 18,
        totalLessons: 24,
        timeSpent: const Duration(hours: 12, minutes: 30),
        lastAccessed: DateTime.now().subtract(const Duration(hours: 2)),
        averageScore: 92,
      ),
      CourseProgress(
        courseId: '2',
        courseTitle: 'Data Structures and Algorithms',
        completionPercentage: 45,
        completedLessons: 9,
        totalLessons: 20,
        timeSpent: const Duration(hours: 8),
        lastAccessed: DateTime.now().subtract(const Duration(days: 1)),
        averageScore: 85,
      ),
      CourseProgress(
        courseId: '3',
        courseTitle: 'UI/UX Design Fundamentals',
        completionPercentage: 100,
        completedLessons: 16,
        totalLessons: 16,
        timeSpent: const Duration(hours: 10),
        lastAccessed: DateTime.now().subtract(const Duration(days: 3)),
        averageScore: 95,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Progress'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              // TODO: Show calendar view
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Welcome Header
          Text(
            'Keep up the great work!',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re making excellent progress',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),

          // Streak
          StreakCounter(
            currentStreak: _statistics.currentStreak,
            longestStreak: _statistics.longestStreak,
          ),
          const SizedBox(height: 24),

          // Statistics Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
            children: [
              StatisticsCard(
                icon: Icons.school,
                label: 'Courses Completed',
                value: '${_statistics.totalCoursesCompleted}',
                color: AppColors.success,
                subtitle: 'of ${_statistics.totalCoursesEnrolled} enrolled',
              ),
              StatisticsCard(
                icon: Icons.timer,
                label: 'Study Time',
                value: '${_statistics.totalTimeSpent.inHours}h',
                color: AppColors.primary,
                subtitle: 'Total learning time',
              ),
              StatisticsCard(
                icon: Icons.grade,
                label: 'Average Score',
                value: '${_statistics.averageScore.toInt()}%',
                color: Colors.amber,
              ),
              StatisticsCard(
                icon: Icons.workspace_premium,
                label: 'Certificates',
                value: '${_statistics.certificatesEarned}',
                color: Colors.purple,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Time Period Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Learning Activity',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TimePeriodSelector(
            selectedPeriod: _selectedPeriod,
            onChanged: (period) {
              setState(() {
                _selectedPeriod = period;
              });
            },
          ),
          const SizedBox(height: 16),

          // Weekly Activity Chart
          SimpleBarChart(
            data: const {
              'Mon': 45,
              'Tue': 30,
              'Wed': 60,
              'Thu': 20,
              'Fri': 50,
              'Sat': 75,
              'Sun': 40,
            },
            title: 'Study Time (minutes)',
            color: AppColors.primary,
          ),
          const SizedBox(height: 24),

          // Course Progress
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Course Progress',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: View all courses
                },
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._courseProgress.map((progress) {
            return CourseProgressCard(
              progress: progress,
              onTap: () {
                // TODO: Navigate to course
              },
            );
          }),
        ],
      ),
    );
  }
}
