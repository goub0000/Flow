import 'package:flutter/material.dart';
import 'package:flow/core/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/focus_tools_widgets.dart';

/// Focus Analytics Screen
///
/// Detailed productivity analytics:
/// - Focus time trends
/// - Session completion rates
/// - Weekly/monthly charts
/// - Peak productivity hours
/// - Course-wise breakdown
///
/// Backend Integration TODO:
/// - Fetch analytics from backend
/// - Generate custom reports
/// - Export data
/// - Compare with peers

class FocusAnalyticsScreen extends StatefulWidget {
  const FocusAnalyticsScreen({super.key});

  @override
  State<FocusAnalyticsScreen> createState() => _FocusAnalyticsScreenState();
}

class _FocusAnalyticsScreenState extends State<FocusAnalyticsScreen> {
  late StudySessionStats _stats;

  @override
  void initState() {
    super.initState();
    _generateMockStats();
  }

  void _generateMockStats() {
    _stats = const StudySessionStats(
      totalSessions: 48,
      completedSessions: 42,
      totalFocusTime: Duration(hours: 17, minutes: 30),
      longestSession: Duration(minutes: 50),
      currentStreak: 7,
      bestStreak: 14,
      averageFocusScore: 87.5,
      sessionsByDay: {
        'Mon': 8,
        'Tue': 6,
        'Wed': 7,
        'Thu': 5,
        'Fri': 9,
        'Sat': 4,
        'Sun': 3,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.focusAnalyticsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareReport,
            tooltip: context.l10n.focusAnalyticsShare,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: Refresh from backend
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats overview
              _buildStatsOverview(),
              const SizedBox(height: 24),

              // Weekly chart
              WeeklyFocusChart(sessionsByDay: _stats.sessionsByDay),
              const SizedBox(height: 24),

              // Stats grid
              _buildStatsGrid(),
              const SizedBox(height: 24),

              // Insights
              _buildInsights(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsOverview() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Colors.deepPurple],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.focusAnalyticsThisMonth,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _stats.formattedTotalTime,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.focusAnalyticsTotalFocusTime,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildOverviewStat(
                '${_stats.completedSessions}',
                context.l10n.focusAnalyticsSessions,
              ),
              _buildOverviewStat(
                '${_stats.completionRate.toStringAsFixed(0)}%',
                context.l10n.focusAnalyticsCompletion,
              ),
              _buildOverviewStat(
                '${_stats.averageFocusScore.toStringAsFixed(0)}%',
                context.l10n.focusAnalyticsAvgFocus,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewStat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.1,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        FocusStatsCard(
          label: context.l10n.focusAnalyticsCurrentStreak,
          value: '${_stats.currentStreak}',
          icon: Icons.local_fire_department,
          color: Colors.orange,
          subtitle: context.l10n.focusAnalyticsDaysInARow,
        ),
        FocusStatsCard(
          label: context.l10n.focusAnalyticsBestStreak,
          value: '${_stats.bestStreak}',
          icon: Icons.emoji_events,
          color: Colors.amber,
          subtitle: context.l10n.focusAnalyticsDaysAchieved,
        ),
        FocusStatsCard(
          label: context.l10n.focusAnalyticsLongestSession,
          value: _stats.formattedLongestSession,
          icon: Icons.timer,
          color: AppColors.primary,
        ),
        FocusStatsCard(
          label: context.l10n.focusAnalyticsCompletionRate,
          value: '${_stats.completionRate.toStringAsFixed(0)}%',
          icon: Icons.check_circle,
          color: AppColors.success,
        ),
      ],
    );
  }

  Widget _buildInsights() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Colors.amber),
                const SizedBox(width: 12),
                Text(
                  context.l10n.focusAnalyticsInsights,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInsightItem(
              Icons.trending_up,
              context.l10n.focusAnalyticsPeakFocusTime,
              context.l10n.focusAnalyticsPeakFocusTimeDesc,
              Colors.green,
            ),
            const SizedBox(height: 12),
            _buildInsightItem(
              Icons.star,
              context.l10n.focusAnalyticsGreatWeek,
              context.l10n.focusAnalyticsGreatWeekDesc,
              Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildInsightItem(
              Icons.whatshot,
              context.l10n.focusAnalyticsKeepItUp,
              context.l10n.focusAnalyticsKeepItUpDesc,
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightItem(
    IconData icon,
    String title,
    String description,
    Color color,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _shareReport() {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.focusAnalyticsShareComingSoon),
      ),
    );
  }
}
