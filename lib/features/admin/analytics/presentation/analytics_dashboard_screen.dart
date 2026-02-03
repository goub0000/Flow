import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/admin_permissions.dart';
import '../../../../core/l10n_extension.dart';
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
                    tooltip: context.l10n.adminChatRetry,
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
                    context.l10n.adminAnalyticsTitle,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.adminAnalyticsSubtitle,
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
                  items: [
                    DropdownMenuItem(value: '7days', child: Text(context.l10n.adminAnalyticsLast7Days)),
                    DropdownMenuItem(value: '30days', child: Text(context.l10n.adminAnalyticsLast30Days)),
                    DropdownMenuItem(value: '90days', child: Text(context.l10n.adminAnalyticsLast90Days)),
                    DropdownMenuItem(value: 'year', child: Text(context.l10n.adminAnalyticsThisYear)),
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
                tooltip: context.l10n.adminAnalyticsRefreshData,
              ),
              const SizedBox(width: 8),
              PermissionGuard(
                permission: AdminPermission.exportData,
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showExportDialog();
                  },
                  icon: const Icon(Icons.download, size: 20),
                  label: Text(context.l10n.adminAnalyticsExportReport),
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
          _buildTab('overview', context.l10n.adminAnalyticsOverview, Icons.dashboard),
          _buildTab('users', context.l10n.adminAnalyticsUsers, Icons.people),
          _buildTab('applications', context.l10n.adminAnalyticsApplications, Icons.description),
          _buildTab('financial', context.l10n.adminAnalyticsFinancial, Icons.attach_money),
          _buildTab('content', context.l10n.adminAnalyticsContent, Icons.library_books),
          _buildTab('engagement', context.l10n.adminAnalyticsEngagement, Icons.trending_up),
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
        _buildSectionTitle(context.l10n.adminAnalyticsKpi),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildKPICard(
                context.l10n.adminAnalyticsTotalUsers,
                '$totalUsers',
                '${_formatPercent(usersChange)} ${context.l10n.adminAnalyticsVsLastPeriod}',
                Icons.people,
                AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                context.l10n.adminAnalyticsActiveApplications,
                '$applications7d',
                context.l10n.adminAnalyticsLast7DaysShort,
                Icons.description,
                AppColors.success,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                context.l10n.adminAnalyticsRevenueMtd,
                _formatCurrency(financeStats['revenueThisMonth'] ?? totalRevenue),
                context.l10n.adminAnalyticsMonthToDate,
                Icons.attach_money,
                AppColors.warning,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                context.l10n.adminAnalyticsSuccessRate,
                '${successRate.toStringAsFixed(1)}%',
                context.l10n.adminAnalyticsTransactionSuccess,
                Icons.check_circle,
                AppColors.error,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        _buildSectionTitle(context.l10n.adminAnalyticsTrends),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: _buildChartCard(
                context.l10n.adminAnalyticsUserGrowth,
                context.l10n.adminAnalyticsNewRegOverTime,
                _buildUserGrowthChart(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildChartCard(
                context.l10n.adminAnalyticsUserDistribution,
                context.l10n.adminAnalyticsByUserType,
                _buildRoleDistributionChart(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        _buildSectionTitle(context.l10n.adminAnalyticsQuickStats),
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
        _buildSectionTitle(context.l10n.adminAnalyticsUserAnalytics),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildKPICard(
                context.l10n.adminAnalyticsTotalUsers,
                '$totalUsers',
                context.l10n.adminAnalyticsAllRegisteredUsers,
                Icons.people,
                AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                context.l10n.adminAnalyticsActiveUsers,
                '$activeUsers',
                context.l10n.adminAnalyticsLast30Days,
                Icons.person_outline,
                AppColors.success,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                context.l10n.adminAnalyticsNewUsers,
                '$newUsers',
                context.l10n.adminAnalyticsLast7DaysShort,
                Icons.person_add,
                AppColors.warning,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                context.l10n.adminAnalyticsActiveChange,
                _formatPercent(activeChange),
                context.l10n.adminAnalytics30DayActiveChange,
                Icons.trending_up,
                AppColors.error,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildChartCard(
          context.l10n.adminAnalyticsUserRegistrations,
          context.l10n.adminAnalyticsNewSignUpsOverTime,
          _buildUserGrowthChart(),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildChartCard(
                context.l10n.adminAnalyticsUserTypes,
                context.l10n.adminAnalyticsDistributionByRole,
                _buildRoleDistributionChart(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildChartCard(
                context.l10n.adminAnalyticsRegionalDistribution,
                context.l10n.adminAnalyticsUsersByRegion,
                _buildPlaceholderChart(context.l10n.adminAnalyticsRegionalDataNotAvailable),
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
        _buildSectionTitle(context.l10n.adminAnalyticsApplicationAnalytics),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildKPICard(
                context.l10n.adminAnalyticsRecentApplications,
                '$applications7d',
                context.l10n.adminAnalyticsLast7DaysShort,
                Icons.description,
                AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                context.l10n.adminAnalyticsApproved,
                '${metrics['approved_applications'] ?? 0}',
                context.l10n.adminAnalyticsTotalApproved,
                Icons.check_circle,
                AppColors.success,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                context.l10n.adminAnalyticsPending,
                '${metrics['pending_applications'] ?? 0}',
                context.l10n.adminAnalyticsAwaitingReview,
                Icons.pending,
                AppColors.warning,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                context.l10n.adminAnalyticsRejected,
                '${metrics['rejected_applications'] ?? 0}',
                context.l10n.adminAnalyticsTotalRejected,
                Icons.cancel,
                AppColors.error,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildChartCard(
          context.l10n.adminAnalyticsApplicationSubmissions,
          context.l10n.adminAnalyticsNewAppsOverTime,
          _buildPlaceholderChart(context.l10n.adminAnalyticsAppTrendData),
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
        _buildSectionTitle(context.l10n.adminAnalyticsFinancialAnalytics),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildKPICard(
                context.l10n.adminAnalyticsTotalRevenue,
                _formatCurrency(totalRevenue),
                context.l10n.adminAnalyticsAllTime,
                Icons.attach_money,
                AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                context.l10n.adminAnalyticsThisMonth,
                _formatCurrency(revenueThisMonth),
                context.l10n.adminAnalyticsMonthToDate,
                Icons.trending_up,
                AppColors.success,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                context.l10n.adminAnalyticsTransactions,
                '$totalTransactions',
                context.l10n.adminAnalyticsTotalTransactions,
                Icons.receipt,
                AppColors.warning,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                context.l10n.adminAnalyticsAvgTransaction,
                _formatCurrency(avgTransactionValue),
                context.l10n.adminAnalyticsAverageValue,
                Icons.analytics,
                AppColors.error,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildChartCard(
          context.l10n.adminAnalyticsRevenueTrend,
          context.l10n.adminAnalyticsRevenueBreakdown,
          _buildPlaceholderChart(context.l10n.adminAnalyticsRevenueTrendData),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildContentAnalytics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context.l10n.adminAnalyticsContentAnalytics),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildKPICard(
                context.l10n.adminAnalyticsTotalContent,
                '0',
                context.l10n.adminAnalyticsPublishedItems,
                Icons.library_books,
                AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                context.l10n.adminAnalyticsAvgCompletion,
                '0%',
                context.l10n.adminAnalyticsContentCompletionRate,
                Icons.check_circle,
                AppColors.success,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                context.l10n.adminAnalyticsEngagementLabel,
                '0',
                context.l10n.adminAnalyticsTotalInteractions,
                Icons.touch_app,
                AppColors.warning,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                context.l10n.adminAnalyticsPopularContent,
                '0',
                context.l10n.adminAnalyticsMostViewedItems,
                Icons.visibility,
                AppColors.error,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildChartCard(
          context.l10n.adminAnalyticsContentEngagement,
          context.l10n.adminAnalyticsUserInteractionsOverTime,
          _buildPlaceholderChart(context.l10n.adminAnalyticsContentEngagementData),
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
        _buildSectionTitle(context.l10n.adminAnalyticsPlatformEngagement),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildKPICard(
                context.l10n.adminAnalyticsActiveUsers30d,
                '$activeUsers',
                context.l10n.adminAnalyticsActiveLast30Days,
                Icons.people,
                AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                context.l10n.adminAnalyticsSessionDuration,
                '0 min',
                context.l10n.adminAnalyticsAverageTime,
                Icons.access_time,
                AppColors.success,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                context.l10n.adminAnalyticsPageViews,
                '0',
                context.l10n.adminAnalyticsTotalViews,
                Icons.visibility,
                AppColors.warning,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                context.l10n.adminAnalyticsBounceRate,
                '0%',
                context.l10n.adminAnalyticsSinglePageVisits,
                Icons.exit_to_app,
                AppColors.error,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildChartCard(
          context.l10n.adminAnalyticsDailyActiveUsers,
          context.l10n.adminAnalyticsUserActivityOverTime,
          _buildPlaceholderChart(context.l10n.adminAnalyticsDailyActiveUserData),
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
      return _buildPlaceholderChart(context.l10n.adminAnalyticsNoUserGrowthData);
    }

    final data = _userGrowthData!;
    final labels = data['labels'] as List<dynamic>? ?? [];
    final values = data['data'] as List<dynamic>? ??
        data['values'] as List<dynamic>? ?? [];

    if (labels.isEmpty || values.isEmpty) {
      return _buildPlaceholderChart(context.l10n.adminAnalyticsNoUserGrowthData);
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
      return _buildPlaceholderChart(context.l10n.adminAnalyticsNoRoleDistData);
    }

    final data = _roleDistributionData!;
    final roles = data['roles'] as Map<String, dynamic>? ?? {};

    if (roles.isEmpty) {
      return _buildPlaceholderChart(context.l10n.adminAnalyticsNoRoleDistData);
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
          _buildStatRow(context.l10n.adminAnalyticsTotalStudents, '${metrics['total_students'] ?? 0}', Icons.school),
          Divider(height: 24, color: AppColors.border),
          _buildStatRow(context.l10n.adminAnalyticsTotalInstitutions, '${metrics['total_institutions'] ?? 0}', Icons.business),
          Divider(height: 24, color: AppColors.border),
          _buildStatRow(context.l10n.adminAnalyticsTotalCounselors, '${metrics['total_counselors'] ?? 0}', Icons.psychology),
          Divider(height: 24, color: AppColors.border),
          _buildStatRow(context.l10n.adminAnalyticsTotalRecommenders, '${metrics['total_recommenders'] ?? 0}', Icons.recommend),
          Divider(height: 24, color: AppColors.border),
          _buildStatRow(context.l10n.adminAnalyticsPlatformUptime, '99.9%', Icons.cloud_done),
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
            Text(context.l10n.adminAnalyticsExportTitle),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.adminAnalyticsSelectFormat),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: Text(context.l10n.adminAnalyticsCsv),
              subtitle: Text(context.l10n.adminAnalyticsCsvDesc),
              onTap: () {
                // TODO: Export as CSV
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: Text(context.l10n.adminAnalyticsExcel),
              subtitle: Text(context.l10n.adminAnalyticsExcelDesc),
              onTap: () {
                // TODO: Export as Excel
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: Text(context.l10n.adminAnalyticsPdf),
              subtitle: Text(context.l10n.adminAnalyticsPdfDesc),
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
            child: Text(context.l10n.adminChatCancel),
          ),
        ],
      ),
    );
  }
}
