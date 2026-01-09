import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/admin_permissions.dart';
// AdminShell is now provided by ShellRoute in admin_routes.dart
import '../../shared/widgets/permission_guard.dart';

/// Analytics Dashboard Screen - System-wide analytics and reports
///
/// Features:
/// - Key performance indicators (KPIs)
/// - User analytics (registrations, active users, retention)
/// - Application analytics (submissions, approvals, success rates)
/// - Financial analytics (revenue, transaction volumes)
/// - Content analytics (engagement, completion rates)
/// - Custom report builder
/// - Data visualization with charts
/// - Export analytics data
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

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch analytics data from backend
    // - API endpoint: GET /api/admin/analytics
    // - Support time range filtering
    // - Aggregate data by category
    // - Real-time updates for live metrics

    // Content is wrapped by AdminShell via ShellRoute
    return _buildContent();
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Page Header
        _buildHeader(),
        const SizedBox(height: 24),

        // Category Tabs
        _buildCategoryTabs(),
        const SizedBox(height: 24),

        // Main Content
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
              // Time Range Selector
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
                    DropdownMenuItem(value: 'custom', child: Text('Custom Range')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedTimeRange = value);
                      // TODO: Refresh data with new time range
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              // Refresh button
              IconButton(
                onPressed: () {
                  // TODO: Refresh analytics data
                },
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh Data',
              ),
              const SizedBox(width: 8),
              // Export button (requires permission)
              PermissionGuard(
                permission: AdminPermission.exportData,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Export analytics report
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Key Metrics
        _buildSectionTitle('Key Performance Indicators'),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildKPICard(
                'Total Users',
                '0',
                '+0% vs last period',
                Icons.people,
                AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                'Active Applications',
                '0',
                '0 pending review',
                Icons.description,
                AppColors.success,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                'Revenue (MTD)',
                'KES 0.00',
                '+0% vs last month',
                Icons.attach_money,
                AppColors.warning,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                'Success Rate',
                '0%',
                'Application approvals',
                Icons.check_circle,
                AppColors.error,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // Charts Section
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
                _buildPlaceholderChart('Line Chart - User Growth'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildChartCard(
                'User Distribution',
                'By user type',
                _buildPlaceholderChart('Pie Chart - User Types'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildChartCard(
                'Application Status',
                'Current application states',
                _buildPlaceholderChart('Bar Chart - Applications'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildChartCard(
                'Revenue Trend',
                'Monthly revenue breakdown',
                _buildPlaceholderChart('Line Chart - Revenue'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // Quick Stats
        _buildSectionTitle('Quick Statistics'),
        const SizedBox(height: 16),
        _buildQuickStats(),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildUsersAnalytics() {
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
                '0',
                'All registered users',
                Icons.people,
                AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                'Active Users',
                '0',
                'Last 30 days',
                Icons.person_outline,
                AppColors.success,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                'New Users',
                '0',
                'This month',
                Icons.person_add,
                AppColors.warning,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                'Retention Rate',
                '0%',
                '30-day retention',
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
          _buildPlaceholderChart('Line Chart - Registrations'),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildChartCard(
                'User Types',
                'Distribution by role',
                _buildPlaceholderChart('Pie Chart - Roles'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildChartCard(
                'Regional Distribution',
                'Users by region',
                _buildPlaceholderChart('Bar Chart - Regions'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildApplicationsAnalytics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Application Analytics'),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildKPICard(
                'Total Applications',
                '0',
                'All submissions',
                Icons.description,
                AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                'Approved',
                '0',
                'Success rate: 0%',
                Icons.check_circle,
                AppColors.success,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                'Pending',
                '0',
                'Awaiting review',
                Icons.pending,
                AppColors.warning,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                'Rejected',
                '0',
                'Rejection rate: 0%',
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
          _buildPlaceholderChart('Line Chart - Submissions'),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildChartCard(
                'Status Distribution',
                'Applications by status',
                _buildPlaceholderChart('Pie Chart - Status'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildChartCard(
                'Program Popularity',
                'Top programs by applications',
                _buildPlaceholderChart('Bar Chart - Programs'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildFinancialAnalytics() {
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
                'KES 0.00',
                'All time',
                Icons.attach_money,
                AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                'This Month',
                'KES 0.00',
                '+0% vs last month',
                Icons.trending_up,
                AppColors.success,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                'Transactions',
                '0',
                'Successful payments',
                Icons.receipt,
                AppColors.warning,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                'Avg Transaction',
                'KES 0.00',
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
          'Monthly revenue over time',
          _buildPlaceholderChart('Line Chart - Revenue'),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildChartCard(
                'Payment Methods',
                'Revenue by payment type',
                _buildPlaceholderChart('Pie Chart - Methods'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildChartCard(
                'Transaction Status',
                'Success vs failure rate',
                _buildPlaceholderChart('Bar Chart - Status'),
              ),
            ),
          ],
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
          _buildPlaceholderChart('Line Chart - Engagement'),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildChartCard(
                'Content Types',
                'Distribution by type',
                _buildPlaceholderChart('Pie Chart - Types'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildChartCard(
                'Top Performers',
                'Most engaged content',
                _buildPlaceholderChart('Bar Chart - Content'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildEngagementAnalytics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Platform Engagement'),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildKPICard(
                'Daily Active Users',
                '0',
                'Active today',
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
          _buildPlaceholderChart('Line Chart - DAU'),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildChartCard(
                'Popular Pages',
                'Most visited pages',
                _buildPlaceholderChart('Bar Chart - Pages'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildChartCard(
                'User Journey',
                'Navigation patterns',
                _buildPlaceholderChart('Flow Chart - Journey'),
              ),
            ),
          ],
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
            const SizedBox(height: 4),
            Text(
              'Chart will appear with backend integration',
              style: TextStyle(
                color: AppColors.textSecondary.withValues(alpha: 0.6),
                fontSize: 11,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildStatRow('Total Students', '0', Icons.school),
          Divider(height: 24, color: AppColors.border),
          _buildStatRow('Total Institutions', '0', Icons.business),
          Divider(height: 24, color: AppColors.border),
          _buildStatRow('Total Counselors', '0', Icons.psychology),
          Divider(height: 24, color: AppColors.border),
          _buildStatRow('Total Recommenders', '0', Icons.recommend),
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
