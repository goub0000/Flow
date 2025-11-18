import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/models/program_model.dart';
import '../../../../../core/models/applicant_model.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../shared/widgets/refresh_utilities.dart';
import '../../../../shared/providers/profile_provider.dart';
import '../../../providers/institution_dashboard_provider.dart';
import '../../../providers/institution_applicants_realtime_provider.dart';
import '../../../providers/institution_analytics_provider.dart';

class OverviewTab extends ConsumerStatefulWidget {
  final Function(int)? onNavigate;

  const OverviewTab({super.key, this.onNavigate});

  @override
  ConsumerState<OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends ConsumerState<OverviewTab> with RefreshableMixin {
  @override
  void initState() {
    super.initState();
    // Fetch analytics data on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profile = ref.read(profileProvider);
      if (profile != null && profile.institutionId != null) {
        ref.read(institutionAnalyticsProvider(profile.institutionId!).notifier).fetchAll();
      }
    });
  }

  Future<void> _handleRefresh() async {
    return handleRefresh(() async {
      try {
        // Refresh dashboard data
        await ref.read(institutionDashboardProvider.notifier).loadDashboardData();

        // Try to refresh real-time provider if available
        try {
          ref.read(institutionApplicantsRealtimeProvider.notifier).refresh();
        } catch (e) {
          print('[DEBUG] Real-time provider refresh skipped: $e');
        }

        // Refresh analytics data
        final profile = ref.read(profileProvider);
        if (profile != null && profile.institutionId != null) {
          await ref.read(institutionAnalyticsProvider(profile.institutionId!).notifier).refresh();
        }

        // Update last refresh time
        ref.read(lastRefreshTimeProvider('institution_dashboard').notifier).state = DateTime.now();

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
    final isLoading = ref.watch(institutionDashboardLoadingProvider);
    final error = ref.watch(institutionDashboardErrorProvider);
    final statistics = ref.watch(institutionDashboardStatisticsProvider);

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
                ref.read(institutionDashboardProvider.notifier).loadDashboardData();
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

    final totalApplicants = statistics['totalApplicants'] as int? ?? 0;
    final pendingApplicants = statistics['pendingApplicants'] as int? ?? 0;
    final underReviewApplicants = statistics['underReviewApplicants'] as int? ?? 0;
    final acceptedApplicants = statistics['acceptedApplicants'] as int? ?? 0;
    final rejectedApplicants = statistics['rejectedApplicants'] as int? ?? 0;
    final totalPrograms = statistics['totalPrograms'] as int? ?? 0;
    final activePrograms = statistics['activePrograms'] as int? ?? 0;
    final totalEnrollments = statistics['totalEnrolled'] as int? ?? 0;

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          // Last refresh timestamp
          const LastRefreshIndicator(providerKey: 'institution_dashboard'),
          const SizedBox(height: 8),
          // Statistics Cards
          Row(
            children: [
              Expanded(
                child: IconCard(
                  icon: Icons.people_outline,
                  title: 'Total Applicants',
                  value: '$totalApplicants',
                  iconColor: AppColors.info,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: IconCard(
                  icon: Icons.pending_actions,
                  title: 'Pending Review',
                  value: '$pendingApplicants',
                  iconColor: AppColors.warning,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: IconCard(
                  icon: Icons.school_outlined,
                  title: 'Active Programs',
                  value: '$activePrograms',
                  iconColor: AppColors.success,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: IconCard(
                  icon: Icons.group,
                  title: 'Total Students',
                  value: '$totalEnrollments',
                  iconColor: AppColors.primary,
                ),
              ),
            ],
          ),
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
                      color: AppColors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.rate_review, color: AppColors.warning),
                  ),
                  title: const Text('Review Pending Applications'),
                  subtitle: Text('$pendingApplicants applications waiting'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: pendingApplicants > 0 ? () {
                    // Navigate to applicants tab (index 1)
                    widget.onNavigate?.call(1);
                  } : null,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.visibility, color: AppColors.info),
                  ),
                  title: const Text('Under Review'),
                  subtitle: Text('$underReviewApplicants applications in progress'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: underReviewApplicants > 0 ? () {
                    // Navigate to applicants tab (index 1)
                    widget.onNavigate?.call(1);
                  } : null,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.check_circle, color: AppColors.success),
                  ),
                  title: const Text('Accepted Applicants'),
                  subtitle: Text('$acceptedApplicants applications approved'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: acceptedApplicants > 0 ? () {
                    // Navigate to applicants tab (index 1)
                    widget.onNavigate?.call(1);
                  } : null,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.add_circle, color: AppColors.primary),
                  ),
                  title: const Text('Create New Program'),
                  subtitle: const Text('Add a new course or program'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navigate to programs tab (index 2)
                    widget.onNavigate?.call(2);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Application Summary
          Text(
            'Application Summary',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          CustomCard(
            child: Column(
              children: [
                _SummaryRow(
                  icon: Icons.pending_actions,
                  label: 'Pending Review',
                  value: '$pendingApplicants',
                  color: AppColors.warning,
                ),
                const Divider(),
                _SummaryRow(
                  icon: Icons.rate_review,
                  label: 'Under Review',
                  value: '$underReviewApplicants',
                  color: AppColors.info,
                ),
                const Divider(),
                _SummaryRow(
                  icon: Icons.check_circle,
                  label: 'Accepted',
                  value: '$acceptedApplicants',
                  color: AppColors.success,
                ),
                const Divider(),
                _SummaryRow(
                  icon: Icons.cancel,
                  label: 'Rejected',
                  value: '$rejectedApplicants',
                  color: AppColors.error,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Programs Summary
          Text(
            'Programs Overview',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          CustomCard(
            child: Column(
              children: [
                _SummaryRow(
                  icon: Icons.school,
                  label: 'Total Programs',
                  value: '$totalPrograms',
                  color: AppColors.primary,
                ),
                const Divider(),
                _SummaryRow(
                  icon: Icons.visibility,
                  label: 'Active Programs',
                  value: '$activePrograms',
                  color: AppColors.success,
                ),
                const Divider(),
                _SummaryRow(
                  icon: Icons.visibility_off,
                  label: 'Inactive Programs',
                  value: '${totalPrograms - activePrograms}',
                  color: AppColors.textSecondary,
                ),
                const Divider(),
                _SummaryRow(
                  icon: Icons.group,
                  label: 'Total Enrollments',
                  value: '$totalEnrollments',
                  color: AppColors.info,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Analytics Section - Application Funnel
          _buildAnalyticsSection(),
        ],
      ),
    );
  }

  Widget _buildAnalyticsSection() {
    final profile = ref.watch(profileProvider);
    if (profile == null || profile.institutionId == null) {
      return const SizedBox.shrink();
    }

    final funnelData = ref.watch(institutionApplicationFunnelProvider(profile.institutionId!));
    final demographicsData = ref.watch(institutionApplicantDemographicsProvider(profile.institutionId!));
    final popularityData = ref.watch(institutionProgramPopularityProvider(profile.institutionId!));
    final decisionData = ref.watch(institutionTimeToDecisionProvider(profile.institutionId!));
    final isAnalyticsLoading = ref.watch(institutionAnalyticsLoadingProvider(profile.institutionId!));

    if (isAnalyticsLoading) {
      return const CustomCard(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Application Funnel
        if (funnelData != null) ...[
          Text(
            'Application Funnel',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          CustomCard(
            child: Column(
              children: [
                SizedBox(
                  height: 250,
                  child: _buildFunnelChart(funnelData),
                ),
                const SizedBox(height: 16),
                Text(
                  'Overall Conversion Rate: ${funnelData.overallConversionRate.toStringAsFixed(1)}%',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],

        // Applicant Demographics
        if (demographicsData != null && demographicsData.totalApplicants > 0) ...[
          Text(
            'Applicant Demographics',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Applicants: ${demographicsData.totalApplicants}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 24),
                Text(
                  'By Location',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: _buildPieChart(demographicsData.locationDistribution),
                ),
                const SizedBox(height: 24),
                Text(
                  'By Age Group',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: _buildPieChart(demographicsData.ageDistribution),
                ),
                const SizedBox(height: 24),
                Text(
                  'By Academic Background',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: _buildPieChart(demographicsData.academicBackgroundDistribution),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],

        // Program Popularity
        if (popularityData != null && popularityData.totalPrograms > 0) ...[
          Text(
            'Program Popularity',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Top Programs by Applications',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                ...popularityData.mostApplied.take(5).map((program) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              program.programName,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          Text(
                            '${program.applications} apps',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: program.applications / popularityData.mostApplied.first.applications,
                        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],

        // Time-to-Decision
        if (decisionData != null) ...[
          Text(
            'Application Processing Time',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: CustomCard(
                  child: Column(
                    children: [
                      Icon(Icons.timer, color: AppColors.info, size: 32),
                      const SizedBox(height: 8),
                      Text(
                        '${decisionData.averageDays.toStringAsFixed(1)} days',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.info,
                        ),
                      ),
                      Text(
                        'Average Time',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomCard(
                  child: Column(
                    children: [
                      Icon(Icons.pending_actions, color: AppColors.warning, size: 32),
                      const SizedBox(height: 8),
                      Text(
                        '${decisionData.pendingApplications}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.warning,
                        ),
                      ),
                      Text(
                        'Pending',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ],
    );
  }

  Widget _buildFunnelChart(ApplicationFunnelData data) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: data.totalViewed.toDouble() * 1.1,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final stage = data.stages[group.x.toInt()];
              return BarTooltipItem(
                '${stage.stage}\n${stage.count}\n${stage.percentage.toStringAsFixed(1)}%',
                const TextStyle(color: Colors.white),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() < 0 || value.toInt() >= data.stages.length) {
                  return const SizedBox.shrink();
                }
                final stage = data.stages[value.toInt()];
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    stage.stage,
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: data.stages.asMap().entries.map((entry) {
          final index = entry.key;
          final stage = entry.value;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: stage.count.toDouble(),
                color: _getStageColor(index),
                width: 40,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPieChart(List<DemographicDistribution> data) {
    if (data.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: PieChart(
            PieChartData(
              sections: data.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return PieChartSectionData(
                  value: item.count.toDouble(),
                  title: '${item.percentage.toStringAsFixed(1)}%',
                  color: _getPieColor(index),
                  radius: 60,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: data.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: _getPieColor(index),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${item.label}: ${item.count}',
                        style: Theme.of(context).textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Color _getStageColor(int index) {
    const colors = [
      AppColors.info,
      AppColors.primary,
      AppColors.warning,
      Color(0xFF9C27B0),
      AppColors.success,
    ];
    return colors[index % colors.length];
  }

  Color _getPieColor(int index) {
    const colors = [
      AppColors.primary,
      AppColors.success,
      AppColors.warning,
      AppColors.info,
      AppColors.error,
      Color(0xFF9C27B0),
      Color(0xFF00BCD4),
      Color(0xFFFF9800),
    ];
    return colors[index % colors.length];
  }

}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Row(
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
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
        ],
      ),
    );
  }
}
