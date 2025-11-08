import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/models/program_model.dart';
import '../../../../../core/models/applicant_model.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../providers/institution_dashboard_provider.dart';

class OverviewTab extends ConsumerWidget {
  final Function(int)? onNavigate;

  const OverviewTab({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      onRefresh: () async {
        await ref.read(institutionDashboardProvider.notifier).loadDashboardData();
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
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
                    onNavigate?.call(1);
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
                    onNavigate?.call(1);
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
                    onNavigate?.call(1);
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
                    onNavigate?.call(2);
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
        ],
      ),
    );
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
