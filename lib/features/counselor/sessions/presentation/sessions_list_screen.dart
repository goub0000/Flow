import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/counseling_models.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../providers/counselor_sessions_provider.dart';

class SessionsListScreen extends ConsumerStatefulWidget {
  const SessionsListScreen({super.key});

  @override
  ConsumerState<SessionsListScreen> createState() => _SessionsListScreenState();
}

class _SessionsListScreenState extends ConsumerState<SessionsListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(counselorSessionsLoadingProvider);
    final error = ref.watch(counselorSessionsErrorProvider);
    final todaySessions = ref.watch(todaySessionsProvider);
    final upcomingSessions = ref.watch(upcomingSessionsProvider);
    final completedSessions = ref.watch(completedSessionsProvider);

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
                ref.read(counselorSessionsProvider.notifier).fetchSessions();
              },
              child: Text(context.l10n.counselorSessionRetry),
            ),
          ],
        ),
      );
    }

    if (isLoading) {
      return LoadingIndicator(message: context.l10n.counselorSessionLoadingSessions);
    }

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: context.l10n.counselorSessionTodayTab('${todaySessions.length}')),
            Tab(text: context.l10n.counselorSessionUpcomingTab('${upcomingSessions.length}')),
            Tab(text: context.l10n.counselorSessionCompletedTab('${completedSessions.length}')),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildSessionsList(todaySessions, 'today'),
              _buildSessionsList(upcomingSessions, 'upcoming'),
              _buildSessionsList(completedSessions, 'completed'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSessionsList(List<CounselingSession> sessions, String type) {
    if (sessions.isEmpty) {
      String message;
      switch (type) {
        case 'today':
          message = context.l10n.counselorSessionNoSessionsToday;
          break;
        case 'upcoming':
          message = context.l10n.counselorSessionNoUpcomingSessions;
          break;
        case 'completed':
          message = context.l10n.counselorSessionNoCompletedSessions;
          break;
        default:
          message = context.l10n.counselorSessionNoSessions;
      }

      return EmptyState(
        icon: Icons.event_outlined,
        title: context.l10n.counselorSessionNoSessionsTitle,
        message: message,
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(counselorSessionsProvider.notifier).fetchSessions();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          final session = sessions[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _SessionCard(
              session: session,
              onTap: () {
                _showSessionDetail(session);
              },
            ),
          );
        },
      ),
    );
  }

  void _showSessionDetail(CounselingSession session) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _formatSessionType(session.type),
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _DetailRow(
                  icon: Icons.person,
                  label: context.l10n.counselorSessionStudentLabel,
                  value: session.studentName,
                ),
                const SizedBox(height: 12),
                _DetailRow(
                  icon: Icons.calendar_today,
                  label: context.l10n.counselorSessionDateTime,
                  value: _formatDateTime(session.scheduledDate),
                ),
                const SizedBox(height: 12),
                _DetailRow(
                  icon: Icons.timer,
                  label: context.l10n.counselorSessionDurationLabel,
                  value: context.l10n.counselorSessionMinutesValue('${session.duration.inMinutes}'),
                ),
                const SizedBox(height: 12),
                _DetailRow(
                  icon: Icons.label,
                  label: context.l10n.counselorSessionStatusLabel,
                  value: session.status.toUpperCase(),
                ),
                if (session.notes != null) ...[
                  const SizedBox(height: 24),
                  Text(
                    context.l10n.counselorSessionNotes,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(session.notes!),
                ],
                if (session.summary != null) ...[
                  const SizedBox(height: 24),
                  Text(
                    context.l10n.counselorSessionSummary,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(session.summary!),
                ],
                if (session.actionItems != null && session.actionItems!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text(
                    context.l10n.counselorSessionActionItems,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  ...session.actionItems!.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_circle_outline,
                              size: 20, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Expanded(child: Text(item)),
                        ],
                      ),
                    );
                  }),
                ],
                const SizedBox(height: 24),
                if (session.status == 'scheduled') ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _startSession(session);
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: Text(context.l10n.counselorSessionStartSession),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _cancelSession(session);
                      },
                      icon: const Icon(Icons.cancel, color: AppColors.error),
                      label: Text(context.l10n.counselorSessionCancelSession),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatSessionType(String type) {
    switch (type) {
      case 'individual':
        return context.l10n.counselorSessionIndividualCounseling;
      case 'group':
        return context.l10n.counselorSessionGroupSession;
      case 'career':
        return context.l10n.counselorSessionCareerCounseling;
      case 'academic':
        return context.l10n.counselorSessionAcademicAdvising;
      case 'personal':
        return context.l10n.counselorSessionPersonalCounseling;
      default:
        return type;
    }
  }

  String _formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _startSession(CounselingSession session) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.counselorSessionStartSession),
        content: Text(
          context.l10n.counselorSessionStartSessionWith(session.studentName),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.counselorSessionCancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.counselorSessionStart),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(counselorSessionsProvider.notifier).updateSessionStatus(
        session.id,
        'in_progress',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.counselorSessionStarted(session.studentName)),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  Future<void> _cancelSession(CounselingSession session) async {
    final reason = await showDialog<String>(
      context: context,
      builder: (context) {
        String? selectedReason;
        return AlertDialog(
          title: Text(context.l10n.counselorSessionCancelSession),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.counselorSessionCancelSessionWith(session.studentName)),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.counselorSessionReasonForCancellation,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  RadioListTile<String>(
                    title: Text(context.l10n.counselorSessionStudentUnavailable),
                    value: 'student_unavailable',
                    groupValue: selectedReason,
                    onChanged: (value) => setState(() => selectedReason = value),
                  ),
                  RadioListTile<String>(
                    title: Text(context.l10n.counselorSessionCounselorUnavailable),
                    value: 'counselor_unavailable',
                    groupValue: selectedReason,
                    onChanged: (value) => setState(() => selectedReason = value),
                  ),
                  RadioListTile<String>(
                    title: Text(context.l10n.counselorSessionRescheduled),
                    value: 'rescheduled',
                    groupValue: selectedReason,
                    onChanged: (value) => setState(() => selectedReason = value),
                  ),
                  RadioListTile<String>(
                    title: Text(context.l10n.counselorSessionOther),
                    value: 'other',
                    groupValue: selectedReason,
                    onChanged: (value) => setState(() => selectedReason = value),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.l10n.counselorSessionBack),
            ),
            ElevatedButton(
              onPressed: selectedReason != null
                  ? () => Navigator.pop(context, selectedReason)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              child: Text(context.l10n.counselorSessionCancelSession),
            ),
          ],
        );
      },
    );

    if (reason != null && mounted) {
      await ref.read(counselorSessionsProvider.notifier).updateSessionStatus(
        session.id,
        'cancelled',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.counselorSessionCancelled(session.studentName)),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}

class _SessionCard extends StatelessWidget {
  final CounselingSession session;
  final VoidCallback onTap;

  const _SessionCard({
    required this.session,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isToday = session.isToday;

    return CustomCard(
      onTap: onTap,
      color: isToday
          ? AppColors.warning.withValues(alpha: 0.05)
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: _getTypeColor(),
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
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatSessionType(context, session.type),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              if (isToday)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    context.l10n.counselorSessionTodayBadge,
                    style: const TextStyle(
                      color: AppColors.warning,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                _formatTime(session.scheduledDate),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(width: 16),
              const Icon(Icons.timer, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                context.l10n.counselorSessionDurationMin('${session.duration.inMinutes}'),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getTypeColor() {
    switch (session.type) {
      case 'career':
        return AppColors.primary;
      case 'academic':
        return AppColors.info;
      case 'personal':
        return AppColors.warning;
      case 'group':
        return AppColors.success;
      default:
        return AppColors.counselorRole;
    }
  }

  String _formatSessionType(BuildContext context, String type) {
    switch (type) {
      case 'individual':
        return context.l10n.counselorSessionIndividual;
      case 'group':
        return context.l10n.counselorSessionGroup;
      case 'career':
        return context.l10n.counselorSessionCareer;
      case 'academic':
        return context.l10n.counselorSessionAcademic;
      case 'personal':
        return context.l10n.counselorSessionPersonal;
      default:
        return type;
    }
  }

  String _formatTime(DateTime date) {
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
