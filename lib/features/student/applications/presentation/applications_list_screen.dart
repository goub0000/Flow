import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/application_model.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../../shared/widgets/refresh_utilities.dart';
import '../../providers/student_applications_provider.dart';
import '../../providers/student_applications_realtime_provider.dart';

class ApplicationsListScreen extends ConsumerStatefulWidget {
  const ApplicationsListScreen({super.key});

  @override
  ConsumerState<ApplicationsListScreen> createState() => _ApplicationsListScreenState();
}

class _ApplicationsListScreenState extends ConsumerState<ApplicationsListScreen>
    with SingleTickerProviderStateMixin, RefreshableMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshApplications() async {
    return handleRefresh(() async {
      try {
        await ref.read(applicationsProvider.notifier).fetchApplications();

        // Try to refresh real-time provider if available
        try {
          ref.read(studentApplicationsRealtimeProvider.notifier).refresh();
        } catch (e) {
          print('[DEBUG] Real-time provider refresh skipped: $e');
        }

        // Update last refresh time
        ref.read(lastRefreshTimeProvider('applications_list').notifier).state = DateTime.now();

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
            message: 'Failed to refresh applications',
          );
        }
        rethrow;
      }
    });
  }

  List<Application> _getFilteredApplications(List<Application> applications, String status) {
    if (status == 'all') return applications;
    return applications.where((app) => app.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    final applications = ref.watch(applicationsListProvider);
    final isLoading = ref.watch(applicationsLoadingProvider);
    final error = ref.watch(applicationsErrorProvider);
    final pendingCount = ref.watch(pendingApplicationsCountProvider);
    final underReviewCount = ref.watch(underReviewApplicationsCountProvider);
    final acceptedCount = ref.watch(acceptedApplicationsCountProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/student/dashboard');
            }
          },
          tooltip: 'Back',
        ),
        title: const Text('My Applications'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: 'All (${applications.length})'),
            Tab(text: 'Pending ($pendingCount)'),
            Tab(text: 'Under Review ($underReviewCount)'),
            Tab(text: 'Accepted ($acceptedCount)'),
          ],
        ),
      ),
      body: isLoading
          ? const LoadingIndicator(message: 'Loading applications...')
          : error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: AppColors.error),
                      const SizedBox(height: 16),
                      Text(error, style: TextStyle(color: AppColors.error)),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _refreshApplications,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildApplicationsList(applications),
                    _buildApplicationsList(_getFilteredApplications(applications, 'pending')),
                    _buildApplicationsList(_getFilteredApplications(applications, 'under_review')),
                    _buildApplicationsList(_getFilteredApplications(applications, 'accepted')),
                  ],
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push('/student/applications/create');
          // No need to manually refresh - the provider already refreshes after submission
        },
        icon: const Icon(Icons.add),
        label: const Text('New Application'),
      ),
    );
  }

  Widget _buildApplicationsList(List<Application> applications) {
    if (applications.isEmpty) {
      return const EmptyState(
        icon: Icons.description_outlined,
        title: 'No Applications',
        message: 'You haven\'t submitted any applications yet.',
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshApplications,
      child: Column(
        children: [
          const LastRefreshIndicator(providerKey: 'applications_list'),
          Expanded(
            child: _buildApplicationsListInternal(applications),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationsListInternal(List<Application> applications) {
    if (applications.isEmpty) {
      return EmptyState(
        icon: Icons.description_outlined,
        title: 'No Applications',
        message: 'You haven\'t submitted any applications yet',
        actionLabel: 'Create Application',
        onAction: () {
          context.push('/student/applications/create');
        },
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: applications.length,
      itemBuilder: (context, index) {
        final application = applications[index];
        return _ApplicationCard(
          application: application,
          onTap: () {
            context.go('/student/applications/${application.id}', extra: application);
          },
        );
      },
    );
  }
}

class _ApplicationCard extends StatelessWidget {
  final Application application;
  final VoidCallback onTap;

  const _ApplicationCard({
    required this.application,
    required this.onTap,
  });

  StatusBadge _getStatusBadge() {
    switch (application.status) {
      case 'pending':
        return StatusBadge.pending();
      case 'under_review':
        return StatusBadge.inProgress();
      case 'accepted':
        return StatusBadge.approved();
      case 'rejected':
        return StatusBadge.rejected();
      default:
        return StatusBadge.pending();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final daysAgo =
        DateTime.now().difference(application.submittedAt).inDays;

    return CustomCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  application.institutionName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _getStatusBadge(),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            application.programName,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _InfoItem(
                icon: Icons.calendar_today,
                label: daysAgo == 0
                    ? 'Today'
                    : daysAgo == 1
                        ? 'Yesterday'
                        : '$daysAgo days ago',
              ),
              if (application.applicationFee != null)
                _InfoItem(
                  icon: application.feePaid
                      ? Icons.check_circle
                      : Icons.warning,
                  label: application.feePaid
                      ? 'Fee Paid'
                      : 'Payment Pending',
                  color: application.feePaid
                      ? AppColors.success
                      : AppColors.warning,
                ),
            ],
          ),
          if (application.reviewedAt != null) ...[
            const SizedBox(height: 8),
            Text(
              'Reviewed ${DateTime.now().difference(application.reviewedAt!).inDays} days ago',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _InfoItem({
    required this.icon,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final itemColor = color ?? AppColors.textSecondary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: itemColor),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(color: itemColor),
        ),
      ],
    );
  }
}
