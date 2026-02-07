// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/l10n_extension.dart';
import '../../models/approval_models.dart';
import '../../providers/approvals_provider.dart';
import '../widgets/approval_stats_card.dart';
import '../widgets/pending_approvals_card.dart';

/// Admin approval dashboard screen
class ApprovalDashboardScreen extends ConsumerStatefulWidget {
  const ApprovalDashboardScreen({super.key});

  @override
  ConsumerState<ApprovalDashboardScreen> createState() =>
      _ApprovalDashboardScreenState();
}

class _ApprovalDashboardScreenState
    extends ConsumerState<ApprovalDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch data on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(approvalStatsProvider.notifier).fetchStatistics();
      ref.read(pendingActionsProvider.notifier).fetchPendingActions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final statsState = ref.watch(approvalStatsProvider);
    final pendingState = ref.watch(pendingActionsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.adminApprovalWorkflow),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshAll,
            tooltip: context.l10n.adminApprovalRefresh,
          ),
          IconButton(
            icon: const Icon(Icons.list_alt),
            onPressed: () => context.go('/admin/approvals/list'),
            tooltip: context.l10n.adminApprovalViewAllRequests,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshAll,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Statistics Overview
              Text(
                context.l10n.adminApprovalOverview,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              if (statsState.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (statsState.error != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      context.l10n.adminApprovalErrorLoadingStats(statsState.error!),
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
                )
              else if (statsState.statistics != null)
                _buildStatisticsGrid(statsState.statistics!),

              const SizedBox(height: 24),

              // Pending Actions
              Text(
                context.l10n.adminApprovalYourPendingActions,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              if (pendingState.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (pendingState.error != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      context.l10n.adminApprovalErrorLoadingPending(pendingState.error!),
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
                )
              else if (pendingState.pendingActions != null)
                _buildPendingActionsSection(pendingState.pendingActions!),

              const SizedBox(height: 24),

              // Quick Actions
              Text(
                context.l10n.adminApprovalQuickActions,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildQuickActionsGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsGrid(ApprovalStatistics stats) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        ApprovalStatsCard(
          title: context.l10n.adminApprovalTotalRequests,
          value: stats.totalRequests.toString(),
          icon: Icons.assignment,
          color: Colors.blue,
        ),
        ApprovalStatsCard(
          title: context.l10n.adminApprovalPendingReview,
          value: stats.pendingRequests.toString(),
          icon: Icons.pending_actions,
          color: Colors.orange,
        ),
        ApprovalStatsCard(
          title: context.l10n.adminApprovalUnderReview,
          value: stats.underReviewRequests.toString(),
          icon: Icons.rate_review,
          color: Colors.purple,
        ),
        ApprovalStatsCard(
          title: context.l10n.adminApprovalApproved,
          value: stats.approvedRequests.toString(),
          icon: Icons.check_circle,
          color: Colors.green,
        ),
        ApprovalStatsCard(
          title: context.l10n.adminApprovalDenied,
          value: stats.deniedRequests.toString(),
          icon: Icons.cancel,
          color: Colors.red,
        ),
        ApprovalStatsCard(
          title: context.l10n.adminApprovalExecuted,
          value: stats.executedRequests.toString(),
          icon: Icons.done_all,
          color: Colors.teal,
        ),
      ],
    );
  }

  Widget _buildPendingActionsSection(MyPendingActionsResponse pending) {
    if (pending.total == 0) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 48,
                color: Colors.green.shade400,
              ),
              const SizedBox(height: 12),
              Text(
                context.l10n.adminApprovalAllCaughtUp,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(context.l10n.adminApprovalNoPendingActions),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        if (pending.pendingReviews.isNotEmpty) ...[
          PendingApprovalsCard(
            title: context.l10n.adminApprovalPendingReviews,
            items: pending.pendingReviews,
            icon: Icons.rate_review,
            color: Colors.orange,
            onTap: (item) => context.go('/admin/approvals/${item.id}'),
          ),
          const SizedBox(height: 12),
        ],
        if (pending.awaitingMyInfo.isNotEmpty) ...[
          PendingApprovalsCard(
            title: context.l10n.adminApprovalAwaitingYourResponse,
            items: pending.awaitingMyInfo,
            icon: Icons.info_outline,
            color: Colors.amber,
            onTap: (item) => context.go('/admin/approvals/${item.id}'),
          ),
          const SizedBox(height: 12),
        ],
        if (pending.delegatedToMe.isNotEmpty)
          PendingApprovalsCard(
            title: context.l10n.adminApprovalDelegatedToYou,
            items: pending.delegatedToMe,
            icon: Icons.forward,
            color: Colors.purple,
            onTap: (item) => context.go('/admin/approvals/${item.id}'),
          ),
      ],
    );
  }

  Widget _buildQuickActionsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.5,
      children: [
        _QuickActionCard(
          icon: Icons.add_circle,
          label: context.l10n.adminApprovalNewRequest,
          onTap: () => context.go('/admin/approvals/create'),
        ),
        _QuickActionCard(
          icon: Icons.list,
          label: context.l10n.adminApprovalAllRequests,
          onTap: () => context.go('/admin/approvals/list'),
        ),
        _QuickActionCard(
          icon: Icons.history,
          label: context.l10n.adminApprovalMyRequests,
          onTap: () => context.go('/admin/approvals/my-requests'),
        ),
        _QuickActionCard(
          icon: Icons.settings,
          label: context.l10n.adminApprovalConfigurationLabel,
          onTap: () => context.go('/admin/approvals/config'),
        ),
      ],
    );
  }

  Future<void> _refreshAll() async {
    await Future.wait([
      ref.read(approvalStatsProvider.notifier).refresh(),
      ref.read(pendingActionsProvider.notifier).refresh(),
    ]);
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
