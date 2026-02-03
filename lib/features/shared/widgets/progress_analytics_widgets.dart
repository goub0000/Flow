import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/l10n_extension.dart';

/// Progress & Analytics Widgets Library
///
/// Reusable components for learning progress tracking and analytics.
/// All components work without backend integration using mock data patterns.
///
/// Backend Integration TODO:
/// - Fetch user progress data
/// - Calculate learning statistics
/// - Track study time
/// - Store achievement data
/// - Generate analytics reports
/// - Sync progress across devices

// ============================================================================
// MODELS
// ============================================================================

/// Course Progress Model
class CourseProgress {
  final String courseId;
  final String courseTitle;
  final double completionPercentage;
  final int completedLessons;
  final int totalLessons;
  final Duration timeSpent;
  final DateTime lastAccessed;
  final double averageScore;

  const CourseProgress({
    required this.courseId,
    required this.courseTitle,
    required this.completionPercentage,
    required this.completedLessons,
    required this.totalLessons,
    required this.timeSpent,
    required this.lastAccessed,
    this.averageScore = 0.0,
  });
}

/// Learning Statistics Model
class LearningStatistics {
  final int totalCoursesEnrolled;
  final int totalCoursesCompleted;
  final Duration totalTimeSpent;
  final int currentStreak;
  final int longestStreak;
  final double averageScore;
  final int certificatesEarned;
  final int assignmentsCompleted;

  const LearningStatistics({
    required this.totalCoursesEnrolled,
    required this.totalCoursesCompleted,
    required this.totalTimeSpent,
    required this.currentStreak,
    required this.longestStreak,
    required this.averageScore,
    required this.certificatesEarned,
    required this.assignmentsCompleted,
  });
}

/// Achievement Model
class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final DateTime? unlockedAt;
  final bool isUnlocked;
  final int progress;
  final int target;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.unlockedAt,
    this.isUnlocked = false,
    this.progress = 0,
    this.target = 1,
  });

  double get progressPercentage => (progress / target * 100).clamp(0, 100);
}

/// Study Goal Model
class StudyGoal {
  final String id;
  final String title;
  final GoalType type;
  final int target;
  final int progress;
  final DateTime deadline;
  final bool isCompleted;

  const StudyGoal({
    required this.id,
    required this.title,
    required this.type,
    required this.target,
    required this.progress,
    required this.deadline,
    this.isCompleted = false,
  });

  double get progressPercentage => (progress / target * 100).clamp(0, 100);
}

/// Goal Type Enum
enum GoalType {
  coursesComplete,
  studyTime,
  lessonsComplete,
  quizScore,
  streak,
}

extension GoalTypeExtension on GoalType {
  String get displayName {
    switch (this) {
      case GoalType.coursesComplete:
        return 'Courses Completed';
      case GoalType.studyTime:
        return 'Study Time';
      case GoalType.lessonsComplete:
        return 'Lessons Completed';
      case GoalType.quizScore:
        return 'Quiz Average';
      case GoalType.streak:
        return 'Learning Streak';
    }
  }

  IconData get icon {
    switch (this) {
      case GoalType.coursesComplete:
        return Icons.school;
      case GoalType.studyTime:
        return Icons.timer;
      case GoalType.lessonsComplete:
        return Icons.book;
      case GoalType.quizScore:
        return Icons.grade;
      case GoalType.streak:
        return Icons.local_fire_department;
    }
  }

  String formatValue(int value) {
    switch (this) {
      case GoalType.coursesComplete:
      case GoalType.lessonsComplete:
        return value.toString();
      case GoalType.studyTime:
        return '${(value / 60).toStringAsFixed(0)}h';
      case GoalType.quizScore:
        return '$value%';
      case GoalType.streak:
        return '$value days';
    }
  }
}

/// Time Period Enum
enum TimePeriod {
  today,
  week,
  month,
  year,
  allTime,
}

extension TimePeriodExtension on TimePeriod {
  String get displayName {
    switch (this) {
      case TimePeriod.today:
        return 'Today';
      case TimePeriod.week:
        return 'This Week';
      case TimePeriod.month:
        return 'This Month';
      case TimePeriod.year:
        return 'This Year';
      case TimePeriod.allTime:
        return 'All Time';
    }
  }
}

// ============================================================================
// WIDGETS
// ============================================================================

/// Circular Progress Indicator with Label
class CircularProgressCard extends StatelessWidget {
  final double progress;
  final String label;
  final String? sublabel;
  final Color? color;
  final double size;

  const CircularProgressCard({
    super.key,
    required this.progress,
    required this.label,
    this.sublabel,
    this.color,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressColor = color ?? AppColors.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  value: progress / 100,
                  strokeWidth: 8,
                  backgroundColor: progressColor.withValues(alpha: 0.1),
                  color: progressColor,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${progress.toInt()}%',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: progressColor,
                    ),
                  ),
                  if (sublabel != null)
                    Text(
                      sublabel!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Statistics Card
class StatisticsCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? color;
  final String? subtitle;
  final VoidCallback? onTap;

  const StatisticsCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.color,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = color ?? AppColors.primary;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: cardColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: cardColor, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cardColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Course Progress Card
class CourseProgressCard extends StatelessWidget {
  final CourseProgress progress;
  final VoidCallback? onTap;

  const CourseProgressCard({
    super.key,
    required this.progress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                progress.courseTitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: progress.completionPercentage / 100,
                      backgroundColor:
                          AppColors.primary.withValues(alpha: 0.1),
                      color: AppColors.primary,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${progress.completionPercentage.toInt()}%',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    context.l10n.swProgressLessonsCount(progress.completedLessons, progress.totalLessons),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDuration(progress.timeSpent),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    }
    return '${duration.inMinutes}m';
  }
}

/// Achievement Badge
class AchievementBadge extends StatelessWidget {
  final Achievement achievement;
  final VoidCallback? onTap;
  final bool showProgress;

  const AchievementBadge({
    super.key,
    required this.achievement,
    this.onTap,
    this.showProgress = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLocked = !achievement.isUnlocked;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: achievement.color.withValues(
                    alpha: isLocked ? 0.1 : 0.2,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      achievement.icon,
                      size: 32,
                      color: isLocked
                          ? AppColors.textSecondary
                          : achievement.color,
                    ),
                    if (isLocked)
                      Icon(
                        Icons.lock,
                        size: 20,
                        color: AppColors.textSecondary,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                achievement.title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isLocked ? AppColors.textSecondary : null,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                achievement.description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (showProgress && !achievement.isUnlocked) ...[
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: achievement.progressPercentage / 100,
                  backgroundColor: AppColors.surface,
                  color: achievement.color,
                  minHeight: 4,
                  borderRadius: BorderRadius.circular(2),
                ),
                const SizedBox(height: 4),
                Text(
                  '${achievement.progress}/${achievement.target}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
              if (achievement.isUnlocked && achievement.unlockedAt != null) ...[
                const SizedBox(height: 8),
                Text(
                  context.l10n.swProgressUnlocked(_formatDate(context, achievement.unlockedAt!)),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) return context.l10n.swProgressToday;
    if (difference == 1) return context.l10n.swProgressYesterday;
    if (difference < 7) return context.l10n.swProgressDaysAgo(difference);

    return '${date.day}/${date.month}/${date.year}';
  }
}

/// Study Goal Card
class StudyGoalCard extends StatelessWidget {
  final StudyGoal goal;
  final VoidCallback? onTap;

  const StudyGoalCard({
    super.key,
    required this.goal,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final daysLeft = goal.deadline.difference(DateTime.now()).inDays;
    final isOverdue = daysLeft < 0;
    final isCompleted = goal.isCompleted;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppColors.success.withValues(alpha: 0.1)
                          : AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      goal.type.icon,
                      size: 20,
                      color: isCompleted ? AppColors.success : AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          goal.title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            decoration: isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        Text(
                          goal.type.displayName,
                          style: theme.textTheme.bodySmall?.copyWith(
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
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LinearProgressIndicator(
                          value: goal.progressPercentage / 100,
                          backgroundColor:
                              AppColors.primary.withValues(alpha: 0.1),
                          color: isCompleted
                              ? AppColors.success
                              : AppColors.primary,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${goal.type.formatValue(goal.progress)} / ${goal.type.formatValue(goal.target)}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              isCompleted
                                  ? context.l10n.swProgressCompleted
                                  : isOverdue
                                      ? context.l10n.swProgressOverdue
                                      : context.l10n.swProgressDaysLeft(daysLeft),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isCompleted
                                    ? AppColors.success
                                    : isOverdue
                                        ? AppColors.error
                                        : AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
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
    );
  }
}

/// Streak Counter
class StreakCounter extends StatelessWidget {
  final int currentStreak;
  final int longestStreak;

  const StreakCounter({
    super.key,
    required this.currentStreak,
    required this.longestStreak,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.withValues(alpha: 0.2),
            Colors.deepOrange.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.orange.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_fire_department,
              color: Colors.orange,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '$currentStreak',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      context.l10n.swProgressDayStreak,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  context.l10n.swProgressLongestStreak(longestStreak),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Time Period Selector
class TimePeriodSelector extends StatelessWidget {
  final TimePeriod selectedPeriod;
  final ValueChanged<TimePeriod> onChanged;

  const TimePeriodSelector({
    super.key,
    required this.selectedPeriod,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: TimePeriod.values.map((period) {
          final isSelected = period == selectedPeriod;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(period.displayName),
              selected: isSelected,
              onSelected: (_) => onChanged(period),
              backgroundColor: Colors.transparent,
              selectedColor: AppColors.primary.withValues(alpha: 0.1),
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.border,
              ),
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Simple Bar Chart (Mock)
class SimpleBarChart extends StatelessWidget {
  final Map<String, double> data;
  final String? title;
  final Color? color;

  const SimpleBarChart({
    super.key,
    required this.data,
    this.title,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chartColor = color ?? AppColors.primary;
    final maxValue = data.values.isEmpty ? 1.0 : data.values.reduce((a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(
                title!,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
            ],
            SizedBox(
              height: 200,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: data.entries.map((entry) {
                  final barHeight = (entry.value / maxValue * 160).clamp(10.0, 160.0);
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            entry.value.toInt().toString(),
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: barHeight,
                            decoration: BoxDecoration(
                              color: chartColor,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            entry.key,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
