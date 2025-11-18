import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/progress_model.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../providers/student_progress_provider.dart';
import '../../providers/student_analytics_provider.dart';
import '../../../shared/providers/profile_provider.dart';

class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Fetch analytics data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(currentProfileProvider);
      if (user != null) {
        ref.read(studentAnalyticsProvider(user.id).notifier).fetchAll();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(progressLoadingProvider);
    final error = ref.watch(progressErrorProvider);
    final courseProgressList = ref.watch(courseProgressListProvider);

    if (isLoading) {
      return const Scaffold(
        body: LoadingIndicator(message: 'Loading progress...'),
      );
    }

    if (error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Progress')),
        body: EmptyState(
          icon: Icons.error_outline,
          title: 'Error Loading Progress',
          message: error,
          actionLabel: 'Retry',
          onAction: () => ref.read(progressProvider.notifier).fetchProgress(),
        ),
      );
    }

    if (courseProgressList.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Progress')),
        body: const EmptyState(
          icon: Icons.assessment_outlined,
          title: 'No Progress Data',
          message: 'Enroll in courses to start tracking your progress.',
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Progress'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Courses'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildCoursesTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    final averageGrade = ref.watch(averageGradeProvider);
    final overallCompletion = ref.watch(overallCompletionProvider);
    final courseProgressList = ref.watch(courseProgressListProvider);
    final totalAssignments = ref.watch(totalAssignmentsProvider);
    final completedCoursesCount = ref.watch(completedCoursesCountProvider);

    // Calculate monthly progress from course progress list
    final monthlyProgress = _calculateMonthlyProgress(courseProgressList);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Cards
          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  icon: Icons.show_chart,
                  label: 'Average Grade',
                  value: '${averageGrade.toStringAsFixed(1)}%',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryCard(
                  icon: Icons.trending_up,
                  label: 'Completion',
                  value: '${overallCompletion.toStringAsFixed(0)}%',
                  color: AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  icon: Icons.school,
                  label: 'Courses',
                  value:
                      '$completedCoursesCount/${courseProgressList.length}',
                  color: AppColors.info,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryCard(
                  icon: Icons.assignment,
                  label: 'Assignments',
                  value: '$totalAssignments',
                  color: AppColors.warning,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Application Success Rate Chart (Phase 4.2)
          _ApplicationSuccessChart(),
          const SizedBox(height: 24),

          // GPA Trend Chart (Phase 4.2)
          _GpaTrendChart(),
          const SizedBox(height: 24),

          // Grade Trend Chart
          if (monthlyProgress.isNotEmpty) ...[
            Text(
              'Grade Trend',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            CustomCard(
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: LineChart(
                      _buildGradeTrendData(monthlyProgress),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Study Time Chart
            Text(
              'Study Time (Hours)',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            CustomCard(
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: BarChart(
                      _buildStudyTimeData(monthlyProgress),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Course Completion Chart
          Text(
            'Course Completion',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          CustomCard(
            child: Row(
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: PieChart(
                    _buildCourseCompletionData(completedCoursesCount, courseProgressList.length),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _LegendItem(
                        color: AppColors.success,
                        label: 'Completed',
                        value: '$completedCoursesCount',
                      ),
                      const SizedBox(height: 8),
                      _LegendItem(
                        color: AppColors.warning,
                        label: 'In Progress',
                        value: '${courseProgressList.length - completedCoursesCount}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesTab() {
    final courseProgressList = ref.watch(courseProgressListProvider);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: courseProgressList.length,
      itemBuilder: (context, index) {
        final progress = courseProgressList[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: CustomCard(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CourseProgressDetailScreen(progress: progress),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            progress.courseName,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            progress.gradeStatus,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: _getGradeColor(progress.currentGrade),
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${progress.currentGrade.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Progress Bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progress',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                        ),
                        Text(
                          '${progress.completionPercentage.toStringAsFixed(0)}%',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress.completionPercentage / 100,
                        minHeight: 8,
                        backgroundColor: AppColors.surface,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getProgressColor(progress.completionPercentage),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Stats Row
                Row(
                  children: [
                    _StatChip(
                      icon: Icons.assignment,
                      label:
                          '${progress.assignmentsCompleted}/${progress.totalAssignments}',
                    ),
                    const SizedBox(width: 12),
                    _StatChip(
                      icon: Icons.quiz,
                      label:
                          '${progress.quizzesCompleted}/${progress.totalQuizzes}',
                    ),
                    const SizedBox(width: 12),
                    _StatChip(
                      icon: Icons.access_time,
                      label: progress.formattedTimeSpent,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  LineChartData _buildGradeTrendData(List<MonthlyProgress> monthlyProgress) {
    final spots = monthlyProgress
        .asMap()
        .entries
        .map((entry) => FlSpot(
              entry.key.toDouble(),
              entry.value.averageGrade,
            ))
        .toList();

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 20,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: AppColors.border.withValues(alpha: 0.3),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              return Text(
                '${value.toInt()}%',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index >= 0 &&
                  index < monthlyProgress.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    monthlyProgress[index].month,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: (monthlyProgress.length - 1).toDouble(),
      minY: 60,
      maxY: 100,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: AppColors.primary,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: AppColors.primary,
                strokeWidth: 2,
                strokeColor: Colors.white,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            color: AppColors.primary.withValues(alpha: 0.1),
          ),
        ),
      ],
    );
  }

  BarChartData _buildStudyTimeData(List<MonthlyProgress> monthlyProgress) {
    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: 50,
      barTouchData: BarTouchData(enabled: false),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              return Text(
                '${value.toInt()}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index >= 0 &&
                  index < monthlyProgress.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    monthlyProgress[index].month,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 10,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: AppColors.border.withValues(alpha: 0.3),
            strokeWidth: 1,
          );
        },
      ),
      borderData: FlBorderData(show: false),
      barGroups: monthlyProgress
          .asMap()
          .entries
          .map((entry) {
        return BarChartGroupData(
          x: entry.key,
          barRods: [
            BarChartRodData(
              toY: entry.value.timeSpent.inHours.toDouble(),
              color: AppColors.info,
              width: 20,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  PieChartData _buildCourseCompletionData(int completed, int total) {
    return PieChartData(
      sectionsSpace: 2,
      centerSpaceRadius: 30,
      sections: [
        PieChartSectionData(
          value: completed.toDouble(),
          color: AppColors.success,
          radius: 40,
          showTitle: false,
        ),
        PieChartSectionData(
          value: (total - completed).toDouble(),
          color: AppColors.warning,
          radius: 40,
          showTitle: false,
        ),
      ],
    );
  }

  List<MonthlyProgress> _calculateMonthlyProgress(List<CourseProgress> courseProgressList) {
    // Placeholder method - backend should provide actual monthly data
    if (courseProgressList.isEmpty) {
      return [];
    }
    // Return placeholder data for chart display
    return [
      MonthlyProgress(month: 'M1', averageGrade: 0, assignmentsCompleted: 0, timeSpent: Duration.zero),
      MonthlyProgress(month: 'M2', averageGrade: 0, assignmentsCompleted: 0, timeSpent: Duration.zero),
      MonthlyProgress(month: 'M3', averageGrade: 0, assignmentsCompleted: 0, timeSpent: Duration.zero),
      MonthlyProgress(month: 'M4', averageGrade: 0, assignmentsCompleted: 0, timeSpent: Duration.zero),
    ];
  }

  Color _getGradeColor(double grade) {
    if (grade >= 90) return AppColors.success;
    if (grade >= 80) return AppColors.info;
    if (grade >= 70) return AppColors.primary;
    if (grade >= 60) return AppColors.warning;
    return AppColors.error;
  }

  Color _getProgressColor(double progress) {
    if (progress >= 90) return AppColors.success;
    if (progress >= 70) return AppColors.info;
    if (progress >= 50) return AppColors.primary;
    return AppColors.warning;
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String value;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const Spacer(),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}

// Course Progress Detail Screen
class CourseProgressDetailScreen extends StatelessWidget {
  final CourseProgress progress;

  const CourseProgressDetailScreen({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(progress.courseName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall Stats Card
            CustomCard(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _DetailStat(
                        label: 'Current Grade',
                        value: '${progress.currentGrade.toStringAsFixed(0)}%',
                        color: _getGradeColor(progress.currentGrade),
                      ),
                      _DetailStat(
                        label: 'Completion',
                        value:
                            '${progress.completionPercentage.toStringAsFixed(0)}%',
                        color: AppColors.success,
                      ),
                      _DetailStat(
                        label: 'Time Spent',
                        value: progress.formattedTimeSpent,
                        color: AppColors.info,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Modules
            Text(
              'Modules',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            CustomCard(
              padding: EdgeInsets.zero,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: progress.modules.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final module = progress.modules[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: module.isCompleted
                          ? AppColors.success.withValues(alpha: 0.1)
                          : AppColors.surface,
                      child: Icon(
                        module.isCompleted ? Icons.check : Icons.lock_outline,
                        color: module.isCompleted
                            ? AppColors.success
                            : AppColors.textSecondary,
                      ),
                    ),
                    title: Text(
                      module.name,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text('Lesson ${module.lessonNumber}'),
                    trailing: module.isCompleted
                        ? null
                        : const Icon(Icons.chevron_right),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Grades
            Text(
              'Recent Grades',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...progress.grades.map((grade) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            grade.name,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getGradeColor(grade.percentage)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${grade.grade}/${grade.maxGrade}',
                              style: TextStyle(
                                color: _getGradeColor(grade.percentage),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Submitted ${_formatDate(grade.submittedAt)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (grade.feedback != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Feedback',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                grade.feedback!,
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Color _getGradeColor(double grade) {
    if (grade >= 90) return AppColors.success;
    if (grade >= 80) return AppColors.info;
    if (grade >= 70) return AppColors.primary;
    if (grade >= 60) return AppColors.warning;
    return AppColors.error;
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

class _DetailStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _DetailStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ],
    );
  }
}

/// Application Success Rate Pie Chart Widget (Phase 4.2)
class _ApplicationSuccessChart extends ConsumerWidget {
  const _ApplicationSuccessChart();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(currentProfileProvider);

    if (user == null) {
      return const SizedBox.shrink();
    }

    final applicationSuccessData = ref.watch(studentApplicationSuccessProvider(user.id));
    final isLoading = ref.watch(studentAnalyticsLoadingProvider(user.id));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Application Success Rate',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        CustomCard(
          child: isLoading
              ? const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                )
              : applicationSuccessData == null
                  ? const SizedBox(
                      height: 200,
                      child: Center(
                        child: Text('No application data available'),
                      ),
                    )
                  : _buildApplicationSuccessContent(applicationSuccessData, theme),
        ),
      ],
    );
  }

  Widget _buildApplicationSuccessContent(Map<String, dynamic> data, ThemeData theme) {
    final totalApplications = data['total_applications'] as int;
    final acceptanceRate = (data['acceptance_rate'] as num).toDouble();
    final distributions = data['distributions'] as List<dynamic>;

    if (totalApplications == 0) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text('No applications yet'),
        ),
      );
    }

    // Color mapping for different statuses
    final statusColors = {
      'Accepted': AppColors.success,
      'Pending': AppColors.info,
      'Rejected': AppColors.error,
      'Withdrawn': AppColors.textSecondary,
    };

    return Row(
      children: [
        // Pie Chart
        SizedBox(
          width: 160,
          height: 160,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: distributions.map<PieChartSectionData>((dist) {
                final status = dist['status'] as String;
                final count = (dist['count'] as num).toInt();
                final percentage = (dist['percentage'] as num).toDouble();
                final color = statusColors[status] ?? AppColors.primary;

                return PieChartSectionData(
                  value: count.toDouble(),
                  title: '${percentage.toStringAsFixed(0)}%',
                  color: color,
                  radius: 50,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(width: 24),
        // Legend and Stats
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Acceptance Rate Highlight
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Acceptance Rate',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${acceptanceRate.toStringAsFixed(1)}%',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Legend
              ...distributions.map<Widget>((dist) {
                final status = dist['status'] as String;
                final count = (dist['count'] as num).toInt();
                final color = statusColors[status] ?? AppColors.primary;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _LegendItem(
                    color: color,
                    label: status,
                    value: '$count',
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

/// GPA Trend Line Chart Widget (Phase 4.2)
class _GpaTrendChart extends ConsumerWidget {
  const _GpaTrendChart();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(currentProfileProvider);

    if (user == null) {
      return const SizedBox.shrink();
    }

    final gpaTrendData = ref.watch(studentGpaTrendProvider(user.id));
    final isLoading = ref.watch(studentAnalyticsLoadingProvider(user.id));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'GPA Trend',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        CustomCard(
          child: isLoading
              ? const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                )
              : gpaTrendData == null
                  ? const SizedBox(
                      height: 200,
                      child: Center(
                        child: Text('No GPA data available'),
                      ),
                    )
                  : _buildGpaTrendContent(gpaTrendData, theme),
        ),
      ],
    );
  }

  Widget _buildGpaTrendContent(Map<String, dynamic> data, ThemeData theme) {
    final currentGpa = (data['current_gpa'] as num).toDouble();
    final goalGpa = (data['goal_gpa'] as num).toDouble();
    final trend = data['trend'] as String;
    final dataPoints = data['data_points'] as List<dynamic>;

    // Trend color and icon
    final trendColor = trend == 'improving'
        ? AppColors.success
        : trend == 'declining'
            ? AppColors.error
            : AppColors.info;
    final trendIcon = trend == 'improving'
        ? Icons.trending_up
        : trend == 'declining'
            ? Icons.trending_down
            : Icons.trending_flat;

    return Column(
      children: [
        // Summary Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  currentGpa.toStringAsFixed(2),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Current GPA',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  goalGpa.toStringAsFixed(2),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Goal GPA',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    Icon(trendIcon, color: trendColor, size: 24),
                    const SizedBox(width: 4),
                    Text(
                      trend.toUpperCase(),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: trendColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Trend',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Line Chart
        if (dataPoints.length > 1) ...[
          SizedBox(
            height: 200,
            child: LineChart(
              _buildGpaTrendChartData(dataPoints),
            ),
          ),
        ] else ...[
          // Single data point - show simple display
          Container(
            height: 100,
            alignment: Alignment.center,
            child: Text(
              'Historical GPA data will appear here as you progress through semesters',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ],
    );
  }

  LineChartData _buildGpaTrendChartData(List<dynamic> dataPoints) {
    final spots = dataPoints
        .asMap()
        .entries
        .map((entry) => FlSpot(
              entry.key.toDouble(),
              (entry.value['gpa'] as num).toDouble(),
            ))
        .toList();

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 0.5,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: AppColors.border.withValues(alpha: 0.3),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toStringAsFixed(1),
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index >= 0 && index < dataPoints.length) {
                final semester = dataPoints[index]['semester'] as String;
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    semester,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: (dataPoints.length - 1).toDouble(),
      minY: 0,
      maxY: 4.0,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: AppColors.primary,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: AppColors.primary,
                strokeWidth: 2,
                strokeColor: Colors.white,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            color: AppColors.primary.withValues(alpha: 0.1),
          ),
        ),
      ],
    );
  }
}
