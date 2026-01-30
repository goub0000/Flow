import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/admin_permissions.dart';
import '../../shared/widgets/permission_guard.dart';
import '../../shared/providers/admin_analytics_provider.dart';
import '../../shared/providers/admin_finance_provider.dart';

/// Analytics Dashboard Screen - System-wide analytics and reports
class AnalyticsDashboardScreen extends ConsumerStatefulWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  ConsumerState<AnalyticsDashboardScreen> createState() =>
      _AnalyticsDashboardScreenState();
}

class _AnalyticsDashboardScreenState
    extends ConsumerState<AnalyticsDashboardScreen> {
  String _selectedTimeRange = '30days';
  String _selectedCategory = 'overview';

  // Async chart data
  Map<String, dynamic>? _userGrowthData;
  Map<String, dynamic>? _roleDistributionData;
  bool _chartsLoading = false;

  @override
  void initState() {
    super.initState();
    _loadChartData();
  }

  Future<void> _loadChartData() async {
    setState(() => _chartsLoading = true);
    final notifier = ref.read(adminAnalyticsProvider.notifier);
    final results = await Future.wait([
      notifier.fetchUserGrowth(_selectedTimeRange),
      notifier.fetchRoleDistribution(),
    ]);
    if (mounted) {
      setState(() {
        _userGrowthData = results[0];
        _roleDistributionData = results[1];
        _chartsLoading = false;
      });
    }
  }

  void _refreshAll() {
    ref.read(adminAnalyticsProvider.notifier).fetchAnalytics();
    ref.read(adminFinanceProvider.notifier).fetchTransactions();
    ref.read(adminFinanceProvider.notifier).fetchStatistics();
    _loadChartData();
  }

  String _formatCurrency(dynamic value) {
    final num amount = value is num ? value : 0;
    return 'KES ${amount.toStringAsFixed(2)}';
  }

  String _formatPercent(dynamic value) {
    final num pct = value is num ? value : 0;
    final sign = pct >= 0 ? '+' : '';
    return '$sign${pct.toStringAsFixed(1)}%';
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  Widget _buildContent() {
    final analyticsState = ref.watch(adminAnalyticsProvider);
    final isLoading = analyticsState.isLoading || _chartsLoading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        _buildCategoryTabs(),
        const SizedBox(height: 24),
        if (analyticsState.error != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: AppColors.error, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      analyticsState.error!,
                      style: TextStyle(color: AppColors.error, fontSize: 13),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, size: 18),
                    onPressed: _refreshAll,
                    tooltip: 'Retry',
                  ),
                ],
              ),
            ),
          ),
        if (isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: LinearProgressIndicator(),
          ),
        if (isLoading) const SizedBox(height: 16),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildCategoryContent(),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.analytics,
                    size: 32,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Analytics & Reports',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Comprehensive platform analytics and insights',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  value: _selectedTimeRange,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.calendar_today, size: 16),
                  items: const [
                    DropdownMenuItem(value: '7days', child: Text('Last 7 Days')),
                    DropdownMenuItem(value: '30days', child: Text('Last 30 Days')),
                    DropdownMenuItem(value: '90days', child: Text('Last 90 Days')),
                    DropdownMenuItem(value: 'year', child: Text('This Year')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedTimeRange = value);
                      _refreshAll();
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: _refreshAll,
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh Data',
              ),
              const SizedBox(width: 8),
              PermissionGuard(
                permission: AdminPermission.exportData,
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showExportDialog();
                  },
                  icon: const Icon(Icons.download, size: 20),
                  label: const Text('Export Report'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          _buildTab('overview', 'Overview', Icons.dashboard),
          _buildTab('users', 'Users', Icons.people),
          _buildTab('applications', 'Applications', Icons.description),
          _buildTab('financial', 'Financial', Icons.attach_money),
          _buildTab('content', 'Content', Icons.library_books),
          _buildTab('engagement', 'Engagement', Icons.trending_up),
        ],
      ),
    );
  }

  Widget _buildTab(String id, String label, IconData icon) {
    final isSelected = _selectedCategory == id;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () {
          setState(() => _selectedCategory = id);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary
                : AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryContent() {
    switch (_selectedCategory) {
      case 'overview':
        return _buildOverviewContent();
      case 'users':
        return _buildUsersAnalytics();
      case 'applications':
        return _buildApplicationsAnalytics();
      case 'financial':
        return _buildFinancialAnalytics();
      case 'content':
        return _buildContentAnalytics();
      case 'engagement':
        return _buildEngagementAnalytics();
      default:
        return _buildOverviewContent();
    }
  }

  Widget _buildOverviewContent() {
    final metrics = ref.watch(adminAnalyticsMetricsProvider);
    final financeStats = ref.watch(adminFinanceStatisticsProvider);

    final totalUsers = metrics['total_users'] ?? 0;
    final usersChange = metrics['total_users_change_percent'] ?? 0.0;
    final applications7d = metrics['applications_7days'] ?? 0;
    final totalRevenue = financeStats['totalRevenue'] ?? 0.0;
    final successRate = financeStats['successRate'] ?? 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Key Performance Indicators'),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildKPICard(
                'Total Users',
                '$totalUsers',
                '${_formatPercent(usersChange)} vs last period',
                Icons.people,
                AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                'Active Applications',
                '$applications7d',
                'Last 7 days',
                Icons.description,
                AppColors.success,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                'Revenue (MTD)',
                _formatCurrency(financeStats['revenueThisMonth'] ?? totalRevenue),
                'Month to date',
                Icons.attach_money,
                AppColors.warning,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                'Success Rate',
                '${successRate.toStringAsFixed(1)}%',
                'Transaction success',
                Icons.check_circle,
                AppColors.error,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        _buildSectionTitle('Trends & Analytics'),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: _buildChartCard(
                'User Growth',
                'New user registrations over time',
                _buildUserGrowthChart(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildChartCard(
                'User Distribution',
                'By user type',
                _buildRoleDistributionChart(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        _buildSectionTitle('Quick Statistics'),
        const SizedBox(height: 16),
        _buildQuickStats(metrics),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildUsersAnalytics() {
    final metrics = ref.watch(adminAnalyticsMetricsProvider);
    final totalUsers = metrics['total_users'] ?? 0;
    final activeUsers = metrics['active_users_30days'] ?? 0;
    final newUsers = metrics['new_registrations_7days'] ?? 0;
    final activeChange = metrics['active_users_change_percent'] ?? 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('User Analytics'),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildKPICard(
                'Total Users',
                '$totalUsers',
                'All registered users',
                Icons.people,
                AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                'Active Users',
                '$activeUsers',
                'Last 30 days',
                Icons.person_outline,
                AppColors.success,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                'New Users',
                '$newUsers',
                'Last 7 days',
                Icons.person_add,
                AppColors.warning,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                'Active Change',
                _formatPercent(activeChange),
                '30-day active change',
                Icons.trending_up,
                AppColors.error,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildChartCard(
          'User Registrations',
          'New user sign-ups over time',
          _buildUserGrowthChart(),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildChartCard(
                'User Types',
                'Distribution by role',
                _buildRoleDistributionChart(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildChartCard(
                'Regional Distribution',
                'Users by region',
                _buildPlaceholderChart('Regional data not yet available'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildApplicationsAnalytics() {
    final metrics = ref.watch(adminAnalyticsMetricsProvider);
    final applications7d = metrics['applications_7days'] ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Application Analytics'),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildKPICard(
                'Recent Applications',
                '$applications7d',
                'Last 7 days',
                Icons.description,
                AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                'Approved',
                '${metrics['approved_applications'] ?? 0}',
                'Total approved',
                Icons.check_circle,
                AppColors.success,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                'Pending',
                '${metrics['pending_applications'] ?? 0}',
                'Awaiting review',
                Icons.pending,
                AppColors.warning,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                'Rejected',
                '${metrics['rejected_applications'] ?? 0}',
                'Total rejected',
                Icons.cancel,
                AppColors.error,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildChartCard(
          'Application Submissions',
          'New applications over time',
          _buildPlaceholderChart('Application trend data'),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildFinancialAnalytics() {
    final financeStats = ref.watch(adminFinanceStatisticsProvider);
    final totalRevenue = financeStats['totalRevenue'] ?? 0.0;
    final revenueThisMonth = financeStats['revenueThisMonth'] ?? 0.0;
    final totalTransactions = financeStats['totalTransactions'] ?? 0;
    final avgTransactionValue = financeStats['avgTransactionValue'] ?? 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Financial Analytics'),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildKPICard(
                'Total Revenue',
                _formatCurrency(totalRevenue),
                'All time',
                Icons.attach_money,
                AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                'This Month',
                _formatCurrency(revenueThisMonth),
                'Month to date',
                Icons.trending_up,
                AppColors.success,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                'Transactions',
                '$totalTransactions',
                'Total transactions',
                Icons.receipt,
                AppColors.warning,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                'Avg Transaction',
                _formatCurrency(avgTransactionValue),
                'Average value',
                Icons.analytics,
                AppColors.error,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildChartCard(
          'Revenue Trend',
          'Revenue breakdown',
          _buildPlaceholderChart('Revenue trend data'),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildContentAnalytics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Content Analytics'),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildKPICard(
                'Total Content',
                '0',
                'Published items',
                Icons.library_books,
                AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                'Avg Completion',
                '0%',
                'Content completion rate',
                Icons.check_circle,
                AppColors.success,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                'Engagement',
                '0',
                'Total interactions',
                Icons.touch_app,
                AppColors.warning,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                'Popular Content',
                '0',
                'Most viewed items',
                Icons.visibility,
                AppColors.error,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildChartCard(
          'Content Engagement',
          'User interactions over time',
          _buildPlaceholderChart('Content engagement data'),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildEngagementAnalytics() {
    final metrics = ref.watch(adminAnalyticsMetricsProvider);
    final activeUsers = metrics['active_users_30days'] ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Platform Engagement'),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildKPICard(
                'Active Users (30d)',
                '$activeUsers',
                'Active last 30 days',
                Icons.people,
                AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                'Session Duration',
                '0 min',
                'Average time',
                Icons.access_time,
                AppColors.success,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                'Page Views',
                '0',
                'Total views',
                Icons.visibility,
                AppColors.warning,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                'Bounce Rate',
                '0%',
                'Single page visits',
                Icons.exit_to_app,
                AppColors.error,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildChartCard(
          'Daily Active Users',
          'User activity over time',
          _buildPlaceholderChart('Daily active user data'),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildKPICard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
  ) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(icon, size: 20, color: color.withValues(alpha: 0.6)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard(String title, String subtitle, Widget chart) {
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 20),
          chart,
        ],
      ),
    );
  }

  /// Simple bar chart for user growth data
  Widget _buildUserGrowthChart() {
    if (_chartsLoading) {
      return SizedBox(
        height: 200,
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (_userGrowthData == null) {
      return _buildPlaceholderChart('No user growth data available');
    }

    final data = _userGrowthData!;
    final labels = data['labels'] as List<dynamic>? ?? [];
    final values = data['data'] as List<dynamic>? ??
        data['values'] as List<dynamic>? ?? [];

    if (labels.isEmpty || values.isEmpty) {
      return _buildPlaceholderChart('No user growth data available');
    }

    final numericValues = values.map((v) => (v as num).toDouble()).toList();
    final maxValue = numericValues.reduce(max);

    return SizedBox(
      height: 200,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(min(labels.length, numericValues.length), (index) {
          final barHeight = maxValue > 0
              ? (numericValues[index] / maxValue) * 160
              : 0.0;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '${numericValues[index].toInt()}',
                    style: TextStyle(
                      fontSize: 9,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: barHeight,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.7),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${labels[index]}',
                    style: TextStyle(
                      fontSize: 9,
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  /// Simple horizontal bar chart for role distribution
  Widget _buildRoleDistributionChart() {
    if (_chartsLoading) {
      return SizedBox(
        height: 200,
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (_roleDistributionData == null) {
      return _buildPlaceholderChart('No role distribution data available');
    }

    final data = _roleDistributionData!;
    final roles = data['roles'] as Map<String, dynamic>? ?? {};

    if (roles.isEmpty) {
      return _buildPlaceholderChart('No role distribution data available');
    }

    final total = roles.values.fold<int>(0, (sum, v) => sum + (v as int? ?? 0));
    final colors = [
      AppColors.primary,
      AppColors.success,
      AppColors.warning,
      AppColors.error,
      AppColors.textSecondary,
    ];

    return SizedBox(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: roles.entries.toList().asMap().entries.map((entry) {
          final index = entry.key;
          final role = entry.value;
          final count = role.value as int? ?? 0;
          final fraction = total > 0 ? count / total : 0.0;
          final color = colors[index % colors.length];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Text(
                    role.key,
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        height: 20,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: fraction,
                        child: Container(
                          height: 20,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPlaceholderChart(String label) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border, style: BorderStyle.solid),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart,
              size: 48,
              color: AppColors.textSecondary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(Map<String, dynamic> metrics) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildStatRow('Total Students', '${metrics['total_students'] ?? 0}', Icons.school),
          Divider(height: 24, color: AppColors.border),
          _buildStatRow('Total Institutions', '${metrics['total_institutions'] ?? 0}', Icons.business),
          Divider(height: 24, color: AppColors.border),
          _buildStatRow('Total Counselors', '${metrics['total_counselors'] ?? 0}', Icons.psychology),
          Divider(height: 24, color: AppColors.border),
          _buildStatRow('Total Recommenders', '${metrics['total_recommenders'] ?? 0}', Icons.recommend),
          Divider(height: 24, color: AppColors.border),
          _buildStatRow('Platform Uptime', '99.9%', Icons.cloud_done),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.download, color: AppColors.primary),
            const SizedBox(width: 12),
            const Text('Export Analytics Report'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select export format:'),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('CSV'),
              subtitle: const Text('Comma-separated values'),
              onTap: () {
                // TODO: Export as CSV
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Excel'),
              subtitle: const Text('Microsoft Excel format'),
              onTap: () {
                // TODO: Export as Excel
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('PDF'),
              subtitle: const Text('Portable document format'),
              onTap: () {
                // TODO: Export as PDF
                Navigator.pop(context);
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
}
