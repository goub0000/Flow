import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/models/counseling_models.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../shared/widgets/refresh_utilities.dart';
import '../../../providers/counselor_dashboard_provider.dart';
import '../../../providers/counselor_students_provider.dart';
import '../../../providers/counselor_sessions_provider.dart';

class CounselorOverviewTab extends ConsumerStatefulWidget {
  final VoidCallback onNavigateToStudents;
  final VoidCallback onNavigateToSessions;

  const CounselorOverviewTab({
    super.key,
    required this.onNavigateToStudents,
    required this.onNavigateToSessions,
  });

  @override
  ConsumerState<CounselorOverviewTab> createState() => _CounselorOverviewTabState();
}

class _CounselorOverviewTabState extends ConsumerState<CounselorOverviewTab> with RefreshableMixin {
  Future<void> _handleRefresh() async {
    return handleRefresh(() async {
      try {
        // Refresh all data sources in parallel
        await Future.wait([
          ref.read(counselorDashboardProvider.notifier).loadDashboardData(),
          ref.read(counselorStudentsProvider.notifier).fetchStudents(),
          ref.read(counselorSessionsProvider.notifier).fetchSessions(),
        ]);

        // Update last refresh time
        ref.read(lastRefreshTimeProvider('counselor_dashboard').notifier).state = DateTime.now();

        // Show success feedback
        if (mounted) {
          showRefreshFeedback(context, success: true);
        }
      } catch (e) {
        // Show error feedback
        if (mounted) {
          showRefreshFeedback(
            context,
            success: false,
            message: 'Failed to refresh: ${e.toString()}',
          );
        }
        rethrow;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(counselorDashboardLoadingProvider);
    final error = ref.watch(counselorDashboardErrorProvider);
    final statistics = ref.watch(counselorDashboardStatisticsProvider);
    final students = ref.watch(counselorStudentsListProvider);
    final sessions = ref.watch(counselorSessionsListProvider);

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(error, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(counselorDashboardProvider.notifier).loadDashboardData();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (isLoading) {
      return const LoadingIndicator(message: 'Loading overview...');
    }

    final totalStudents = statistics['totalStudents'] as int? ?? 0;
    final todaySessions = statistics['todaySessions'] as int? ?? 0;
    final upcomingSessions = statistics['upcomingSessions'] as int? ?? 0;
    final pendingRecommendations = statistics['pendingRecommendations'] as int? ?? 0;

    final todaySessionsList = sessions.where((s) => s.isToday).toList();

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          // Last refresh timestamp
          const LastRefreshIndicator(providerKey: 'counselor_dashboard'),
          const SizedBox(height: 8),
          // Stats Cards
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.people,
                  label: 'Students',
                  value: '$totalStudents',
                  color: AppColors.counselorRole,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.event_available,
                  label: 'Today',
                  value: '$todaySessions',
                  color: AppColors.warning,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.event,
                  label: 'Upcoming',
                  value: '$upcomingSessions',
                  color: AppColors.info,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.edit_note,
                  label: 'Pending',
                  value: '$pendingRecommendations',
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Today's Sessions
          if (todaySessions > 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today\'s Sessions',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: widget.onNavigateToSessions,
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...todaySessionsList.map((session) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CustomCard(
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.warning,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              session.studentName,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatSessionType(session.type),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _formatTime(session.scheduledDate),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.warning,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${session.duration.inMinutes} min',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 24),
          ],

          // Recent Students
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Students',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (students.isNotEmpty)
                TextButton(
                  onPressed: widget.onNavigateToStudents,
                  child: const Text('View All'),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (students.isEmpty)
            CustomCard(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 48,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Students Assigned',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your students will appear here when assigned',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            ...students.take(3).map((student) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CustomCard(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          student.initials,
                          style: const TextStyle(
                            color: AppColors.textOnPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              student.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${student.grade} • GPA: ${student.gpa}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getGPAColor(student.gpa).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${student.gpa}',
                          style: TextStyle(
                            color: _getGPAColor(student.gpa),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          const SizedBox(height: 24),

          // Pending Recommendations Summary
          if (pendingRecommendations > 0) ...[
            CustomCard(
              color: AppColors.warning.withValues(alpha: 0.05),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.edit_note, color: AppColors.warning, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pending Recommendations',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'You have $pendingRecommendations draft recommendations',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$pendingRecommendations',
                      style: const TextStyle(
                        color: AppColors.warning,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getGPAColor(double gpa) {
    if (gpa >= 3.7) return AppColors.success;
    if (gpa >= 3.0) return AppColors.info;
    if (gpa >= 2.5) return AppColors.warning;
    return AppColors.error;
  }

  String _formatSessionType(String type) {
    switch (type) {
      case 'individual':
        return 'Individual';
      case 'group':
        return 'Group';
      case 'career':
        return 'Career';
      case 'academic':
        return 'Academic';
      case 'personal':
        return 'Personal';
      default:
        return type;
    }
  }

  String _formatTime(DateTime date) {
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      color: color.withValues(alpha: 0.1),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
      ),
    );
  }
}
