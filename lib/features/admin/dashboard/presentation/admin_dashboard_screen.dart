import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/coming_soon_dialog.dart';
import '../../../shared/widgets/refresh_utilities.dart';
import '../../../shared/cookies/presentation/cookie_banner.dart';
import '../../shared/providers/admin_auth_provider.dart';
import '../../shared/providers/admin_analytics_provider.dart';
import '../../shared/providers/admin_support_provider.dart';
import '../../shared/widgets/admin_shell.dart';

/// Admin Dashboard Screen - Main dashboard with KPIs and stats
/// Phase 2: Using AdminShell with sidebar and top bar
/// Mock admin auto-login enabled for testing
class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        AdminShell(
          child: _DashboardContent(),
        ),
        // Cookie consent banner
        const Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: CookieBanner(),
        ),
      ],
    );
  }
}

class _DashboardContent extends ConsumerStatefulWidget {
  @override
  ConsumerState<_DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends ConsumerState<_DashboardContent> with RefreshableMixin {
  Future<void> _handleRefresh() async {
    return handleRefresh(() async {
      try {
        // Refresh all data sources
        await Future.wait([
          ref.read(adminAnalyticsProvider.notifier).fetchAnalytics(),
          ref.read(adminSupportProvider.notifier).fetchTickets(),
        ]);

        // Update last refresh time
        ref.read(lastRefreshTimeProvider('admin_dashboard').notifier).state = DateTime.now();

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
    final adminUser = ref.watch(currentAdminUserProvider);
    final theme = Theme.of(context);
    final metrics = ref.watch(adminAnalyticsMetricsProvider);
    final isLoading = ref.watch(adminAnalyticsLoadingProvider);

    if (adminUser == null) {
      return const Center(
        child: Text('Not authenticated'),
      );
    }

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Page header
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dashboard',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Welcome back, ${adminUser.displayName}',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Quick actions
              PopupMenuButton<String>(
                child: ElevatedButton.icon(
                  onPressed: null, // Use PopupMenuButton's onSelected instead
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text('Quick Action'),
                ),
                onSelected: (String value) {
                  switch (value) {
                    case 'add_user':
                      ComingSoonDialog.show(
                        context,
                        featureName: 'Add User',
                        customMessage: 'Quickly add new users to the system with role assignments and permissions.',
                      );
                      break;
                    case 'create_announcement':
                      ComingSoonDialog.show(
                        context,
                        featureName: 'Create Announcement',
                        customMessage: 'Send announcements to all users or specific groups.',
                      );
                      break;
                    case 'generate_report':
                      ComingSoonDialog.show(
                        context,
                        featureName: 'Generate Report',
                        customMessage: 'Generate comprehensive reports with analytics and insights.',
                      );
                      break;
                    case 'bulk_actions':
                      ComingSoonDialog.show(
                        context,
                        featureName: 'Bulk Actions',
                        customMessage: 'Perform bulk operations on multiple entities at once.',
                      );
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'add_user',
                    child: ListTile(
                      leading: Icon(Icons.person_add),
                      title: Text('Add User'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'create_announcement',
                    child: ListTile(
                      leading: Icon(Icons.campaign),
                      title: Text('Create Announcement'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'generate_report',
                    child: ListTile(
                      leading: Icon(Icons.analytics),
                      title: Text('Generate Report'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'bulk_actions',
                    child: ListTile(
                      leading: Icon(Icons.checklist),
                      title: Text('Bulk Actions'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Last refresh timestamp
          const LastRefreshIndicator(providerKey: 'admin_dashboard'),
          const SizedBox(height: 24),

          // KPI Cards Grid
          GridView.count(
            crossAxisCount: 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.5,
            children: [
              _KPICard(
                title: 'Total Users',
                value: isLoading ? '--' : '${metrics['totalUsers'] ?? 0}',
                icon: Icons.people,
                color: AppColors.primary,
                change: isLoading ? '--' : '+${metrics['userGrowthRate'] ?? 0}%',
                isPositive: true,
              ),
              _KPICard(
                title: 'Active Sessions',
                value: isLoading ? '--' : '${metrics['dailyActiveUsers'] ?? 0}',
                icon: Icons.trending_up,
                color: AppColors.success,
                change: isLoading ? '--' : '${metrics['weeklyActiveUsers'] ?? 0} weekly',
                isPositive: true,
              ),
              _KPICard(
                title: 'Revenue',
                value: isLoading ? '--' : '\$${(metrics['totalRevenue'] ?? 0).toStringAsFixed(0)}',
                icon: Icons.attach_money,
                color: AppColors.accent,
                change: isLoading ? '--' : '+${metrics['revenueGrowthRate'] ?? 0}%',
                isPositive: true,
              ),
              _KPICard(
                title: 'Applications',
                value: isLoading ? '--' : '${metrics['pendingApplications'] ?? 0}',
                icon: Icons.assignment,
                color: AppColors.info,
                change: isLoading ? '--' : '${metrics['totalApplications'] ?? 0} total',
                isPositive: true,
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Charts Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Growth Chart
              Expanded(
                flex: 2,
                child: _UserGrowthChart(),
              ),
              const SizedBox(width: 16),
              // User Distribution Pie Chart
              Expanded(
                child: _UserDistributionChart(),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Recent Activity Section
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recent Activity
              Expanded(
                flex: 2,
                child: _ActivityCard(),
              ),
              const SizedBox(width: 16),
              // Quick Stats
              Expanded(
                child: _QuickStatsCard(metrics: metrics, isLoading: isLoading),
              ),
            ],
          ),
        ],
        ),
      ),
    );
  }
}

class _KPICard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String change;
  final bool isPositive;

  const _KPICard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.change,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPositive
                      ? AppColors.success.withValues(alpha: 0.1)
                      : AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  change,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isPositive ? AppColors.success : AppColors.error,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Fetch recent activity from backend
    // - API endpoint: GET /api/admin/dashboard/recent-activity
    // - Load last 10 activities from audit log
    // - Include: user registrations, logins, content updates, transactions
    // - Group by timestamp and filter by admin's regional scope

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // Empty state - waiting for backend data
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(
                    Icons.history,
                    size: 48,
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No recent activity',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickStatsCard extends StatelessWidget {
  final Map<String, dynamic> metrics;
  final bool isLoading;

  const _QuickStatsCard({
    required this.metrics,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Stats',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _QuickStatItem(
            label: 'Total Enrollments',
            value: isLoading ? '--' : '${metrics['totalEnrollments'] ?? 0}',
            color: AppColors.primary,
          ),
          _QuickStatItem(
            label: 'Completion Rate',
            value: isLoading ? '--' : '${metrics['completionRate'] ?? 0}%',
            color: AppColors.success,
          ),
          _QuickStatItem(
            label: 'Courses',
            value: isLoading ? '--' : '${metrics['totalCourses'] ?? 0}',
            color: AppColors.accent,
          ),
          _QuickStatItem(
            label: 'Avg Rating',
            value: isLoading ? '--' : '${metrics['averageRating'] ?? 0}',
            color: AppColors.info,
          ),
        ],
      ),
    );
  }
}

class _QuickStatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _QuickStatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _UserGrowthChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'User Growth',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'New user registrations over the past 6 months',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 500,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppColors.border,
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
                          value.toInt().toString(),
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                        if (value.toInt() >= 0 && value.toInt() < months.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              months[value.toInt()],
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          );
                        }
                        return const Text('');
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
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 1200),
                      FlSpot(1, 1400),
                      FlSpot(2, 1650),
                      FlSpot(3, 1800),
                      FlSpot(4, 2100),
                      FlSpot(5, 2400),
                    ],
                    isCurved: true,
                    color: AppColors.primary,
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: AppColors.primary,
                          strokeWidth: 2,
                          strokeColor: AppColors.surface,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.primary.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UserDistributionChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'User Distribution',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'By user type',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 160,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: 66,
                    title: '66%',
                    color: AppColors.primary,
                    radius: 50,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    value: 15,
                    title: '15%',
                    color: AppColors.secondary,
                    radius: 50,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    value: 12,
                    title: '12%',
                    color: AppColors.accent,
                    radius: 50,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    value: 7,
                    title: '7%',
                    color: AppColors.success,
                    radius: 50,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
                sectionsSpace: 2,
                centerSpaceRadius: 0,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildLegendItem('Students', AppColors.primary, '8,234'),
          const SizedBox(height: 8),
          _buildLegendItem('Parents', AppColors.secondary, '1,865'),
          const SizedBox(height: 8),
          _buildLegendItem('Counselors', AppColors.accent, '1,496'),
          const SizedBox(height: 8),
          _buildLegendItem('Recommenders', AppColors.success, '863'),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, String value) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
