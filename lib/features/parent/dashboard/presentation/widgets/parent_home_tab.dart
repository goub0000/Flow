import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/models/child_model.dart';
import '../../../../../core/models/meeting_models.dart' as models;
import '../../../../../core/providers/meetings_provider.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../shared/widgets/refresh_utilities.dart';
import '../../../providers/parent_children_provider.dart';
import '../../../providers/parent_alerts_provider.dart';
import '../../../reports/presentation/reports_screen.dart';
import '../../../scheduling/presentation/meeting_scheduler_screen.dart';

class ParentHomeTab extends ConsumerStatefulWidget {
  final VoidCallback onNavigateToChildren;
  final VoidCallback onNavigateToNotifications;
  final VoidCallback onNavigateToSettings;

  const ParentHomeTab({
    super.key,
    required this.onNavigateToChildren,
    required this.onNavigateToNotifications,
    required this.onNavigateToSettings,
  });

  @override
  ConsumerState<ParentHomeTab> createState() => _ParentHomeTabState();
}

class _ParentHomeTabState extends ConsumerState<ParentHomeTab> with RefreshableMixin {
  Future<void> _handleRefresh() async {
    return handleRefresh(() async {
      try {
        // Refresh all data sources in parallel
        await Future.wait([
          ref.read(parentChildrenProvider.notifier).fetchChildren(),
          ref.read(parentAlertsProvider.notifier).fetchAlerts(),
          ref.read(parentMeetingsProvider.notifier).fetchMeetings(),
        ]);

        // Update last refresh time
        ref.read(lastRefreshTimeProvider('parent_dashboard').notifier).state = DateTime.now();

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
    final isLoading = ref.watch(parentChildrenLoadingProvider);
    final children = ref.watch(parentChildrenListProvider);
    final error = ref.watch(parentChildrenErrorProvider);
    final statistics = ref.watch(parentChildrenStatisticsProvider);

    // Meetings state
    final upcomingMeetings = ref.watch(parentUpcomingMeetingsProvider);
    final pendingMeetings = ref.watch(parentPendingMeetingsProvider);

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
                ref.read(parentChildrenProvider.notifier).fetchChildren();
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

    final totalChildren = statistics['totalChildren'] as int;
    final averageGrade = statistics['averageGrade'] as double;
    final totalApplications = statistics['totalApplications'] as int;
    final pendingApplications = statistics['pendingApplications'] as int;

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          // Last refresh timestamp
          const LastRefreshIndicator(providerKey: 'parent_dashboard'),
          const SizedBox(height: 8),
          // Overview Stats
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.child_care,
                  label: 'Children',
                  value: '$totalChildren',
                  color: AppColors.parentRole,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.star,
                  label: 'Avg Grade',
                  value: averageGrade.toStringAsFixed(1),
                  color: _getGradeColor(averageGrade),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.description,
                  label: 'Applications',
                  value: '$totalApplications',
                  color: AppColors.info,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.pending_actions,
                  label: 'Pending',
                  value: '$pendingApplications',
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
                  icon: Icons.event_available,
                  label: 'Upcoming',
                  value: '${upcomingMeetings.length}',
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.pending,
                  label: 'Requests',
                  value: '${pendingMeetings.length}',
                  color: AppColors.counselorRole,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Meetings Overview
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Upcoming Meetings',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (upcomingMeetings.isNotEmpty)
                TextButton(
                  onPressed: () => _scheduleMeeting(context),
                  child: const Text('View All'),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (upcomingMeetings.isEmpty)
            CustomCard(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      Icons.event_busy,
                      size: 48,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Upcoming Meetings',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Schedule meetings with teachers or counselors',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => _scheduleMeeting(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Schedule Meeting'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textOnPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...upcomingMeetings.take(3).map((meeting) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _MeetingCard(meeting: meeting),
              );
            }),
          if (upcomingMeetings.length > 3)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TextButton(
                onPressed: () => _scheduleMeeting(context),
                child: Text('View ${upcomingMeetings.length - 3} more meetings'),
              ),
            ),
          const SizedBox(height: 24),

          // Children Overview
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Children Overview',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (children.isNotEmpty)
                TextButton(
                  onPressed: widget.onNavigateToChildren,
                  child: const Text('View All'),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (children.isEmpty)
            CustomCard(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      Icons.child_care_outlined,
                      size: 48,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Children Added',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add your children to track their progress',
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
            ...children.map((child) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CustomCard(
                  onTap: () {
                    context.go('/parent/children/${child.id}');
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: AppColors.primary,
                            child: Text(
                              child.initials,
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
                                  child.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  child.grade,
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
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  _getGradeColor(child.averageGrade).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${child.averageGrade.toStringAsFixed(1)}%',
                              style: TextStyle(
                                color: _getGradeColor(child.averageGrade),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _MiniStat(
                            icon: Icons.book_outlined,
                            value: '${child.enrolledCourses.length} courses',
                          ),
                          const SizedBox(width: 16),
                          _MiniStat(
                            icon: Icons.description_outlined,
                            value: '${child.applications.length} apps',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          const SizedBox(height: 24),

          // Quick Actions
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          CustomCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.assessment, color: AppColors.info),
                  ),
                  title: const Text('View All Reports'),
                  subtitle: const Text('Academic performance reports'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _viewReports(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.calendar_month, color: AppColors.warning),
                  ),
                  title: const Text('Schedule Meeting'),
                  subtitle: const Text('With teachers or counselors'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _scheduleMeeting(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.notifications, color: AppColors.success),
                  ),
                  title: const Text('Notification Settings'),
                  subtitle: const Text('Manage alerts and updates'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: widget.onNavigateToSettings,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Color _getGradeColor(double grade) {
  if (grade >= 90) return AppColors.success;
  if (grade >= 75) return AppColors.info;
  if (grade >= 60) return AppColors.warning;
  return AppColors.error;
}

void _viewReports(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const ReportsScreen(),
    ),
  );
}

void _scheduleMeeting(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
        title: const Text('Schedule Meeting'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Who would you like to meet with?'),
            const SizedBox(height: 16),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.school, color: AppColors.info),
              ),
              title: const Text('Teacher'),
              subtitle: const Text('Schedule a parent-teacher conference'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MeetingSchedulerScreen(
                      meetingType: MeetingType.teacher,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.counselorRole.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.support_agent, color: AppColors.counselorRole),
              ),
              title: const Text('Counselor'),
              subtitle: const Text('Meet with a guidance counselor'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MeetingSchedulerScreen(
                      meetingType: MeetingType.counselor,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
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
    // Use higher opacity for better visibility and accessibility
    // 0.15 provides good color visibility while maintaining readability
    return CustomCard(
      color: color.withValues(alpha: 0.15),
      child: Column(
        children: [
          // Darker icon for better contrast
          Icon(icon, color: _getDarkerColor(color), size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _getDarkerColor(color),
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }

  // Get darker shade for better contrast on light backgrounds
  Color _getDarkerColor(Color color) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness * 0.7).clamp(0.0, 1.0)).toColor();
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String value;

  const _MiniStat({
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _MeetingCard extends StatelessWidget {
  final models.Meeting meeting;

  const _MeetingCard({required this.meeting});

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('EEE, MMM d');
    final timeFormatter = DateFormat('h:mm a');

    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (meeting.status) {
      case models.MeetingStatus.pending:
        statusColor = AppColors.warning;
        statusIcon = Icons.pending;
        statusText = 'PENDING';
        break;
      case models.MeetingStatus.approved:
        statusColor = AppColors.success;
        statusIcon = Icons.check_circle;
        statusText = 'APPROVED';
        break;
      case models.MeetingStatus.declined:
        statusColor = AppColors.error;
        statusIcon = Icons.cancel;
        statusText = 'DECLINED';
        break;
      case models.MeetingStatus.cancelled:
        statusColor = AppColors.textSecondary;
        statusIcon = Icons.event_busy;
        statusText = 'CANCELLED';
        break;
      case models.MeetingStatus.completed:
        statusColor = AppColors.info;
        statusIcon = Icons.done_all;
        statusText = 'COMPLETED';
        break;
    }

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(meetingModeIcon, color: statusColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meeting.subject,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      meeting.staffName ?? 'Staff Member',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 12, color: statusColor),
                    const SizedBox(width: 4),
                    Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (meeting.scheduledDate != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(
                  dateFormatter.format(meeting.scheduledDate!),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: 16),
                Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(
                  timeFormatter.format(meeting.scheduledDate!),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: 16),
                Icon(Icons.schedule, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(
                  '${meeting.durationMinutes} min',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
          if (meeting.meetingLink != null && meeting.meetingMode == models.MeetingMode.videoCall) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.link, size: 14, color: AppColors.primary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    meeting.meetingLink!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.primary,
                          decoration: TextDecoration.underline,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
          if (meeting.location != null && meeting.meetingMode == models.MeetingMode.inPerson) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    meeting.location!,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
