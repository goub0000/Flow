import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/cookie_constants.dart';
import '../../../../core/providers/cookie_providers.dart';

class ConsentAnalyticsScreen extends ConsumerWidget {
  const ConsentAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cookie Consent Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Refresh analytics data
              ref.invalidate(consentStatisticsProvider);
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overview Cards
            _buildOverviewSection(context, ref),
            const SizedBox(height: 24),

            // Consent Status Distribution
            _buildConsentDistributionSection(context, ref),
            const SizedBox(height: 24),

            // Category Analytics
            _buildCategoryAnalyticsSection(context, ref),
            const SizedBox(height: 24),

            // Recent Activity
            _buildRecentActivitySection(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewSection(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(consentStatisticsProvider);

    return statsAsync.when(
      data: (stats) {
        final totalUsers = stats['totalUsers'] as int? ?? 0;
        final consented = stats['totalConsented'] as int? ?? 0;
        final acceptedAll = stats['acceptedAll'] as int? ?? 0;
        final customized = stats['customized'] as int? ?? 0;
        final consentRate = totalUsers > 0
            ? (consented / totalUsers * 100).toStringAsFixed(1)
            : '0.0';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overview',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _buildStatCard(
                  'Total Users',
                  totalUsers.toString(),
                  Icons.people,
                  AppColors.primary,
                ),
                _buildStatCard(
                  'Consent Rate',
                  '$consentRate%',
                  Icons.check_circle,
                  AppColors.success,
                ),
                _buildStatCard(
                  'Accept All',
                  acceptedAll.toString(),
                  Icons.done_all,
                  AppColors.info,
                ),
                _buildStatCard(
                  'Customized',
                  customized.toString(),
                  Icons.tune,
                  AppColors.warning,
                ),
              ],
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error loading statistics: $error'),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsentDistributionSection(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(consentStatisticsProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Consent Status Distribution',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            statsAsync.when(
              data: (stats) {
                final totalUsers = stats['totalUsers'] as int? ?? 1;
                final acceptedAll = stats['acceptedAll'] as int? ?? 0;
                final customized = stats['customized'] as int? ?? 0;
                final declined = stats['declined'] as int? ?? 0;
                final notAsked = stats['notAsked'] as int? ?? 0;

                return SizedBox(
                  height: 250,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        if (acceptedAll > 0)
                          PieChartSectionData(
                            value: acceptedAll.toDouble(),
                            title: '${(acceptedAll / totalUsers * 100).toStringAsFixed(0)}%',
                            color: AppColors.success,
                            radius: 100,
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        if (customized > 0)
                          PieChartSectionData(
                            value: customized.toDouble(),
                            title: '${(customized / totalUsers * 100).toStringAsFixed(0)}%',
                            color: AppColors.warning,
                            radius: 100,
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        if (declined > 0)
                          PieChartSectionData(
                            value: declined.toDouble(),
                            title: '${(declined / totalUsers * 100).toStringAsFixed(0)}%',
                            color: AppColors.error,
                            radius: 100,
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        if (notAsked > 0)
                          PieChartSectionData(
                            value: notAsked.toDouble(),
                            title: '${(notAsked / totalUsers * 100).toStringAsFixed(0)}%',
                            color: Colors.grey,
                            radius: 100,
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                      ],
                      sectionsSpace: 2,
                      centerSpaceRadius: 0,
                    ),
                  ),
                );
              },
              loading: () => const SizedBox(
                height: 250,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, stack) => SizedBox(
                height: 250,
                child: Center(child: Text('Error: $error')),
              ),
            ),
            const SizedBox(height: 16),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        _buildLegendItem('Accept All', AppColors.success),
        _buildLegendItem('Customized', AppColors.warning),
        _buildLegendItem('Declined', AppColors.error),
        _buildLegendItem('Not Asked', Colors.grey),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildCategoryAnalyticsSection(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(consentStatisticsProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Category Acceptance Rates',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            statsAsync.when(
              data: (stats) {
                final categoryStats = stats['categoryBreakdown'] as Map<String, dynamic>? ?? {};

                return Column(
                  children: CookieCategory.values.map((category) {
                    final accepted = (categoryStats[category.name] as int?) ?? 0;
                    final total = (stats['totalConsented'] as int?) ?? 1;
                    final percentage = (accepted / total * 100).toStringAsFixed(1);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(category.icon, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                category.displayName,
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                              const Spacer(),
                              Text(
                                '$percentage%',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: accepted / total,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _getCategoryColor(category),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(CookieCategory category) {
    switch (category) {
      case CookieCategory.essential:
        return AppColors.success;
      case CookieCategory.functional:
        return AppColors.info;
      case CookieCategory.analytics:
        return AppColors.warning;
      case CookieCategory.marketing:
        return AppColors.primary;
    }
  }

  Widget _buildRecentActivitySection(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Recent Consent Activity',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {
                    // Navigate to user data viewer
                  },
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  label: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Placeholder for recent activity list
            _buildActivityItem(
              'User #12345',
              'Accepted all cookies',
              DateTime.now().subtract(const Duration(minutes: 5)),
              Icons.check_circle,
              AppColors.success,
            ),
            _buildActivityItem(
              'User #12346',
              'Customized preferences',
              DateTime.now().subtract(const Duration(hours: 1)),
              Icons.tune,
              AppColors.warning,
            ),
            _buildActivityItem(
              'User #12347',
              'Declined cookies',
              DateTime.now().subtract(const Duration(hours: 2)),
              Icons.cancel,
              AppColors.error,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(
    String userId,
    String action,
    DateTime timestamp,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
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
                  userId,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  action,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            _formatTimestamp(timestamp),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }
}
