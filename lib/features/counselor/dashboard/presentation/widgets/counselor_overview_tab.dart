import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/models/counseling_models.dart';
import '../../../../../core/models/meeting_models.dart' as models;
import '../../../../../core/providers/meetings_provider.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../shared/widgets/refresh_utilities.dart';
import '../../../providers/counselor_dashboard_provider.dart';
import '../../../providers/counselor_students_provider.dart';
import '../../../providers/counselor_sessions_provider.dart';
import '../../../meetings/presentation/meeting_requests_screen.dart';
import '../../../meetings/presentation/availability_management_screen.dart';
import '../../../../../core/l10n_extension.dart';

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
          ref.read(staffMeetingsProvider.notifier).fetchMeetings(),
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

    // Meetings state
    final pendingRequests = ref.watch(staffPendingRequestsProvider);
    final todayMeetings = ref.watch(staffTodayMeetingsProvider);

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
              child: Text(context.l10n.dashCommonRetry),
            ),
          ],
        ),
      );
    }

    if (isLoading) {
      return LoadingIndicator(message: context.l10n.dashCommonLoadingOverview);
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
                  label: context.l10n.dashCounselorStudents,
                  value: '$totalStudents',
                  color: AppColors.counselorRole,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.event_available,
                  label: context.l10n.dashCounselorToday,
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
                  label: context.l10n.dashCommonUpcoming,
                  value: '$upcomingSessions',
                  color: AppColors.info,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.edit_note,
                  label: context.l10n.dashCommonPending,
                  value: '$pendingRecommendations',
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.pending_actions,
                  label: context.l10n.dashCommonRequests,
                  value: '${pendingRequests.length}',
                  color: AppColors.error,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.event_available,
                  label: context.l10n.dashCommonMeetings,
                  value: '${todayMeetings.length}',
                  color: AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Meeting Requests
          if (pendingRequests.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      context.l10n.dashCounselorMeetingRequests,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${pendingRequests.length}',
                        style: const TextStyle(
                          color: AppColors.error,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MeetingRequestsScreen(),
                      ),
                    );
                  },
                  child: Text(context.l10n.dashCommonViewAll),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...pendingRequests.take(2).map((meeting) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _MeetingRequestCard(
                  meeting: meeting,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MeetingRequestsScreen(),
                      ),
                    );
                  },
                ),
              );
            }),
            if (pendingRequests.length > 2)
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MeetingRequestsScreen(),
                    ),
                  );
                },
                child: Text(context.l10n.dashCounselorViewMoreRequests(pendingRequests.length - 2)),
              ),
            const SizedBox(height: 24),
          ],

          // Quick Actions
          CustomCard(
            color: AppColors.primary.withValues(alpha: 0.05),
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.counselorRole.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.event_available, color: AppColors.counselorRole),
                  ),
                  title: Text(context.l10n.dashCounselorManageAvailability),
                  subtitle: Text(context.l10n.dashCounselorSetMeetingHours),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AvailabilityManagementScreen(),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.pending_actions, color: AppColors.warning),
                  ),
                  title: Text(context.l10n.dashCounselorMeetingRequests),
                  subtitle: Text(context.l10n.dashCounselorPendingApproval(pendingRequests.length)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (pendingRequests.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${pendingRequests.length}',
                            style: const TextStyle(
                              color: AppColors.textOnPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      const SizedBox(width: 8),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MeetingRequestsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Today's Sessions
          if (todaySessions > 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.dashCounselorTodaySessions,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: widget.onNavigateToSessions,
                  child: Text(context.l10n.dashCommonViewAll),
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
                              _formatSessionType(session.type, context),
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
                context.l10n.dashCounselorMyStudents,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (students.isNotEmpty)
                TextButton(
                  onPressed: widget.onNavigateToStudents,
                  child: Text(context.l10n.dashCommonViewAll),
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
                      context.l10n.dashCounselorNoStudents,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.dashCounselorNoStudentsHint,
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
                          context.l10n.dashCounselorPendingRecommendations,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          context.l10n.dashCounselorDraftRecommendations(pendingRecommendations),
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

  String _formatSessionType(String type, BuildContext context) {
    switch (type) {
      case 'individual':
        return context.l10n.dashCounselorSessionIndividual;
      case 'group':
        return context.l10n.dashCounselorSessionGroup;
      case 'career':
        return context.l10n.dashCounselorSessionCareer;
      case 'academic':
        return context.l10n.dashCounselorSessionAcademic;
      case 'personal':
        return context.l10n.dashCounselorSessionPersonal;
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

class _MeetingRequestCard extends StatelessWidget {
  final models.Meeting meeting;
  final VoidCallback onTap;

  const _MeetingRequestCard({
    required this.meeting,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('MMM d, h:mm a');

    IconData meetingModeIcon;
    switch (meeting.meetingMode) {
      case models.MeetingMode.videoCall:
        meetingModeIcon = Icons.videocam;
        break;
      case models.MeetingMode.inPerson:
        meetingModeIcon = Icons.person;
        break;
      case models.MeetingMode.phoneCall:
        meetingModeIcon = Icons.phone;
        break;
    }

    return CustomCard(
      onTap: onTap,
      color: AppColors.error.withValues(alpha: 0.03),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(meetingModeIcon, color: AppColors.error, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meeting.parentName ?? 'Parent',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  meeting.subject,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.schedule, size: 12, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      '${meeting.durationMinutes} min',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                    ),
                    if (meeting.scheduledDate != null) ...[
                      const SizedBox(width: 12),
                      Icon(Icons.calendar_today, size: 12, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        dateFormatter.format(meeting.scheduledDate!),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.pending, size: 14, color: AppColors.error),
                const SizedBox(width: 4),
                Text(
                  context.l10n.dashCounselorStatusPending,
                  style: const TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
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
