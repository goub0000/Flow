import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/user_profile_widgets.dart';

/// User Statistics Screen
///
/// Detailed analytics and statistics display:
/// - Learning progress charts
/// - Course completion rates
/// - Study time analytics
/// - Quiz performance
/// - Streak tracking
/// - Activity heatmap
///
/// Backend Integration TODO:
/// - Fetch detailed statistics from backend
/// - Generate analytics charts
/// - Export statistics data
/// - Track historical data

class UserStatisticsScreen extends StatefulWidget {
  final String? statisticsType;

  const UserStatisticsScreen({
    super.key,
    this.statisticsType,
  });

  @override
  State<UserStatisticsScreen> createState() => _UserStatisticsScreenState();
}

class _UserStatisticsScreenState extends State<UserStatisticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late UserStatistics _statistics;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _generateMockStatistics();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _generateMockStatistics() {
    final now = DateTime.now();
    _statistics = UserStatistics(
      coursesEnrolled: 8,
      coursesCompleted: 3,
      totalLessons: 120,
      lessonsCompleted: 75,
      quizzesTaken: 24,
      averageScore: 87.5,
      totalStudyHours: 156,
      currentStreak: 7,
      longestStreak: 21,
      tasksCompleted: 45,
      notesCreated: 32,
      achievements: [
        AchievementModel(
          id: '1',
          title: 'First Course',
          description: 'Complete your first course',
          icon: Icons.school,
          color: AppColors.primary,
          earnedAt: now.subtract(const Duration(days: 45)),
        ),
        AchievementModel(
          id: '2',
          title: 'Week Warrior',
          description: 'Maintain a 7-day streak',
          icon: Icons.local_fire_department,
          color: AppColors.warning,
          earnedAt: now.subtract(const Duration(days: 7)),
        ),
        AchievementModel(
          id: '3',
          title: 'Quiz Master',
          description: 'Score 100% on a quiz',
          icon: Icons.emoji_events,
          color: AppColors.success,
          earnedAt: now.subtract(const Duration(days: 12)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareStatistics,
            tooltip: 'Share',
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportStatistics,
            tooltip: 'Export',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Learning'),
            Tab(text: 'Performance'),
            Tab(text: 'Activity'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildLearningTab(),
          _buildPerformanceTab(),
          _buildActivityTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Summary Cards
        Row(
          children: [
            Expanded(
              child: StatisticsCard(
                title: 'Total Courses',
                value: '${_statistics.coursesEnrolled}',
                icon: Icons.school,
                color: AppColors.primary,
                subtitle: '${_statistics.coursesCompleted} completed',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatisticsCard(
                title: 'Study Hours',
                value: '${_statistics.totalStudyHours}',
                icon: Icons.timer,
                color: AppColors.info,
                subtitle: 'Total time invested',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatisticsCard(
                title: 'Current Streak',
                value: '${_statistics.currentStreak}',
                icon: Icons.local_fire_department,
                color: AppColors.error,
                subtitle: 'Days in a row',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatisticsCard(
                title: 'Avg Score',
                value: '${_statistics.averageScore.toStringAsFixed(1)}%',
                icon: Icons.grade,
                color: AppColors.success,
                subtitle: 'From ${_statistics.quizzesTaken} quizzes',
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // Progress Overview
        Text(
          'Progress Overview',
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
                  children: [
                    ProgressRing(
                      progress: _statistics.courseCompletionRate / 100,
                      size: 100,
                      color: AppColors.primary,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${_statistics.courseCompletionRate.toInt()}%',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Course Completion',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${_statistics.coursesCompleted} out of ${_statistics.coursesEnrolled} courses completed',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 24),
                Row(
                  children: [
                    ProgressRing(
                      progress: _statistics.lessonCompletionRate / 100,
                      size: 100,
                      color: AppColors.success,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${_statistics.lessonCompletionRate.toInt()}%',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.success,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lesson Progress',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${_statistics.lessonsCompleted} out of ${_statistics.totalLessons} lessons completed',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Weekly Activity
        Text(
          'This Week',
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
                _buildWeeklyStatRow(
                  'Lessons Completed',
                  12,
                  Icons.book,
                  AppColors.primary,
                ),
                const SizedBox(height: 16),
                _buildWeeklyStatRow(
                  'Quizzes Taken',
                  3,
                  Icons.quiz,
                  AppColors.info,
                ),
                const SizedBox(height: 16),
                _buildWeeklyStatRow(
                  'Tasks Completed',
                  8,
                  Icons.check_circle,
                  AppColors.success,
                ),
                const SizedBox(height: 16),
                _buildWeeklyStatRow(
                  'Study Hours',
                  14,
                  Icons.timer,
                  AppColors.warning,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLearningTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Course Progress',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),

        // Course Progress List
        ..._buildMockCourseProgress(),

        const SizedBox(height: 32),

        Text(
          'Learning Milestones',
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
                _buildMilestoneRow(
                  'First Course Started',
                  'Mobile App Development',
                  Icons.school,
                  AppColors.primary,
                  true,
                ),
                const SizedBox(height: 16),
                _buildMilestoneRow(
                  'First Course Completed',
                  'Introduction to Flutter',
                  Icons.emoji_events,
                  AppColors.success,
                  true,
                ),
                const SizedBox(height: 16),
                _buildMilestoneRow(
                  'Perfect Quiz Score',
                  '100% on Quiz #3',
                  Icons.grade,
                  AppColors.warning,
                  true,
                ),
                const SizedBox(height: 16),
                _buildMilestoneRow(
                  'Complete 5 Courses',
                  'Keep learning!',
                  Icons.workspace_premium,
                  AppColors.textSecondary,
                  false,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Quiz Performance',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.grade,
                        color: AppColors.success,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_statistics.averageScore.toStringAsFixed(1)}%',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.success,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Average Score',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 20),
                _buildPerformanceRow('Total Quizzes', '${_statistics.quizzesTaken}'),
                const SizedBox(height: 12),
                _buildPerformanceRow('Passed', '22'),
                const SizedBox(height: 12),
                _buildPerformanceRow('Failed', '2'),
                const SizedBox(height: 12),
                _buildPerformanceRow('Best Score', '100%'),
                const SizedBox(height: 12),
                _buildPerformanceRow('Lowest Score', '65%'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),

        Text(
          'Recent Scores',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),

        ..._buildMockRecentScores(),
      ],
    );
  }

  Widget _buildActivityTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Study Streak',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.local_fire_department,
                    color: AppColors.error,
                    size: 40,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_statistics.currentStreak} Days',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.error,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Current Streak',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Longest: ${_statistics.longestStreak} days',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),

        Text(
          'Productivity',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),

        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.3,
          children: [
            StatisticsCard(
              title: 'Tasks',
              value: '${_statistics.tasksCompleted}',
              icon: Icons.check_circle,
              color: const Color(0xFF9C27B0),
              subtitle: 'Completed',
            ),
            StatisticsCard(
              title: 'Notes',
              value: '${_statistics.notesCreated}',
              icon: Icons.note_alt,
              color: AppColors.info,
              subtitle: 'Created',
            ),
            StatisticsCard(
              title: 'Achievements',
              value: '${_statistics.achievements.where((a) => a.isUnlocked).length}',
              icon: Icons.emoji_events,
              color: AppColors.warning,
              subtitle: 'Unlocked',
            ),
            StatisticsCard(
              title: 'Study Time',
              value: '${(_statistics.totalStudyHours / _statistics.coursesEnrolled).toStringAsFixed(1)}h',
              icon: Icons.access_time,
              color: AppColors.primary,
              subtitle: 'Per course',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeeklyStatRow(
    String label,
    int value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Text(
          '$value',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
      ],
    );
  }

  List<Widget> _buildMockCourseProgress() {
    final courses = [
      {'name': 'Mobile App Development', 'progress': 0.85, 'color': AppColors.primary},
      {'name': 'Data Structures', 'progress': 0.60, 'color': AppColors.success},
      {'name': 'Web Technologies', 'progress': 0.45, 'color': AppColors.info},
      {'name': 'Artificial Intelligence', 'progress': 0.20, 'color': AppColors.warning},
    ];

    return courses.map((course) {
      return Column(
        children: [
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
                          course['name'] as String,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      Text(
                        '${((course['progress'] as double) * 100).toInt()}%',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: course['color'] as Color,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: course['progress'] as double,
                    backgroundColor: AppColors.border,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      course['color'] as Color,
                    ),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      );
    }).toList();
  }

  Widget _buildMilestoneRow(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    bool isCompleted,
  ) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: isCompleted ? color : AppColors.border,
              width: 2,
            ),
          ),
          child: Icon(
            icon,
            color: isCompleted ? color : AppColors.textSecondary,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isCompleted
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
        if (isCompleted)
          const Icon(
            Icons.check_circle,
            color: AppColors.success,
            size: 20,
          ),
      ],
    );
  }

  Widget _buildPerformanceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  List<Widget> _buildMockRecentScores() {
    final scores = [
      {'title': 'Data Structures Quiz #5', 'score': 95, 'date': 'Yesterday'},
      {'title': 'Flutter Basics Test', 'score': 88, 'date': '2 days ago'},
      {'title': 'Web Dev Assessment', 'score': 92, 'date': '3 days ago'},
    ];

    return scores.map((score) {
      return Column(
        children: [
          Card(
            child: ListTile(
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getScoreColor(score['score'] as int)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '${score['score']}%',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _getScoreColor(score['score'] as int),
                        ),
                  ),
                ),
              ),
              title: Text(
                score['title'] as String,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(score['date'] as String),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      );
    }).toList();
  }

  Color _getScoreColor(int score) {
    if (score >= 90) return AppColors.success;
    if (score >= 75) return AppColors.info;
    if (score >= 60) return AppColors.warning;
    return AppColors.error;
  }

  void _shareStatistics() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality coming soon'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _exportStatistics() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exporting statistics...'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}
