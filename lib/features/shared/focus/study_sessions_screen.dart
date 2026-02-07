import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/user_roles.dart';
import '../widgets/focus_tools_widgets.dart';
import '../../authentication/providers/auth_provider.dart';

/// Study Sessions Screen
///
/// History and management of focus sessions:
/// - View completed sessions
/// - Filter by date/course
/// - Session statistics
/// - Export session data
///
/// Backend Integration TODO:
/// - Fetch sessions from backend
/// - Delete sessions
/// - Edit session details
/// - Export reports

class StudySessionsScreen extends ConsumerStatefulWidget {
  const StudySessionsScreen({super.key});

  @override
  ConsumerState<StudySessionsScreen> createState() => _StudySessionsScreenState();
}

class _StudySessionsScreenState extends ConsumerState<StudySessionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<FocusSession> _sessions;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _generateMockSessions();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _generateMockSessions() {
    final now = DateTime.now();

    _sessions = [
      FocusSession(
        id: '1',
        type: SessionType.pomodoro,
        duration: const Duration(minutes: 25),
        completedDuration: const Duration(minutes: 25),
        status: SessionStatus.completed,
        startTime: now.subtract(const Duration(hours: 2)),
        endTime: now.subtract(const Duration(hours: 2, minutes: -25)),
        taskName: 'Study for Data Structures Exam',
        courseId: '1',
        courseName: 'Data Structures & Algorithms',
        focusLevel: FocusLevel.deep,
        distractions: 0,
      ),
      FocusSession(
        id: '2',
        type: SessionType.shortBreak,
        duration: const Duration(minutes: 5),
        completedDuration: const Duration(minutes: 5),
        status: SessionStatus.completed,
        startTime: now.subtract(const Duration(hours: 1, minutes: 35)),
        endTime: now.subtract(const Duration(hours: 1, minutes: 30)),
      ),
      FocusSession(
        id: '3',
        type: SessionType.pomodoro,
        duration: const Duration(minutes: 25),
        completedDuration: const Duration(minutes: 18),
        status: SessionStatus.cancelled,
        startTime: now.subtract(const Duration(hours: 1, minutes: 30)),
        endTime: now.subtract(const Duration(hours: 1, minutes: 12)),
        taskName: 'Complete Web Dev Assignment',
        courseId: '2',
        courseName: 'Web Technologies',
        focusLevel: FocusLevel.moderate,
        distractions: 2,
      ),
      FocusSession(
        id: '4',
        type: SessionType.pomodoro,
        duration: const Duration(minutes: 25),
        completedDuration: const Duration(minutes: 25),
        status: SessionStatus.completed,
        startTime: now.subtract(const Duration(days: 1, hours: 3)),
        endTime: now.subtract(const Duration(days: 1, hours: 3, minutes: -25)),
        taskName: 'Practice Flutter Widgets',
        courseId: '3',
        courseName: 'Mobile App Development',
        focusLevel: FocusLevel.deep,
        distractions: 1,
      ),
      FocusSession(
        id: '5',
        type: SessionType.pomodoro,
        duration: const Duration(minutes: 25),
        completedDuration: const Duration(minutes: 25),
        status: SessionStatus.completed,
        startTime: now.subtract(const Duration(days: 2)),
        endTime: now.subtract(const Duration(days: 2, minutes: -25)),
        taskName: 'Review AI Concepts',
        courseId: '4',
        courseName: 'Artificial Intelligence',
        focusLevel: FocusLevel.light,
        distractions: 3,
      ),
    ];
  }

  List<FocusSession> get _todaySessions {
    final today = DateTime.now();
    return _sessions
        .where((s) =>
            s.startTime.day == today.day &&
            s.startTime.month == today.month &&
            s.startTime.year == today.year)
        .toList();
  }

  List<FocusSession> get _thisWeekSessions {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return _sessions.where((s) => s.startTime.isAfter(weekStart)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              final user = ref.read(authProvider).user;
              if (user != null) {
                context.go(user.activeRole.dashboardRoute);
              }
            }
          },
          tooltip: context.l10n.studySessionsBack,
        ),
        title: Text(context.l10n.studySessionsTitle),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: context.l10n.studySessionsToday(_todaySessions.length)),
            Tab(text: context.l10n.studySessionsThisWeek(_thisWeekSessions.length)),
            Tab(text: context.l10n.studySessionsAll(_sessions.length)),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildStatsHeader(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSessionsList(_todaySessions),
                _buildSessionsList(_thisWeekSessions),
                _buildSessionsList(_sessions),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsHeader() {
    final completedCount =
        _sessions.where((s) => s.isCompleted).length;
    final totalMinutes = _sessions
        .where((s) => s.isCompleted)
        .fold<int>(0, (sum, s) => sum + (s.completedDuration?.inMinutes ?? 0));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(context.l10n.studySessionsSessions, '$completedCount', Icons.timer),
          _buildStatItem(context.l10n.studySessionsTotalTime, '${totalMinutes}m', Icons.schedule),
          _buildStatItem(context.l10n.studySessionsAvgFocus, '${(85).toStringAsFixed(0)}%', Icons.trending_up),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSessionsList(List<FocusSession> sessions) {
    if (sessions.isEmpty) {
      return EmptyFocusState(
        message: context.l10n.studySessionsNoSessions,
        subtitle: context.l10n.studySessionsNoSessionsSubtitle,
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        // TODO: Refresh from backend
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          return FocusSessionCard(
            session: sessions[index],
            onTap: () => _showSessionDetails(sessions[index]),
          );
        },
      ),
    );
  }

  void _showSessionDetails(FocusSession session) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: session.typeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(session.typeIcon, color: session.typeColor),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.taskName ?? session.typeLabel,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (session.courseName != null)
                        Text(
                          session.courseName!,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildDetailRow(context.l10n.studySessionsDuration, session.formattedDuration),
            _buildDetailRow(context.l10n.studySessionsStatus, session.statusLabel),
            if (session.focusLevel != null)
              _buildDetailRow(
                  context.l10n.studySessionsFocusLevel, session.focusLevel!.name.toUpperCase()),
            if (session.distractions != null)
              _buildDetailRow(context.l10n.studySessionsDistractions, '${session.distractions}'),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                child: Text(context.l10n.studySessionsClose),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey[600]),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
