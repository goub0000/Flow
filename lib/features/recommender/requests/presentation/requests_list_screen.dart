import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/counseling_models.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../providers/recommender_requests_provider.dart';

class RequestsListScreen extends ConsumerStatefulWidget {
  const RequestsListScreen({super.key});

  @override
  ConsumerState<RequestsListScreen> createState() => _RequestsListScreenState();
}

class _RequestsListScreenState extends ConsumerState<RequestsListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(recommenderRequestsLoadingProvider);
    final error = ref.watch(recommenderRequestsErrorProvider);
    final allRequests = ref.watch(recommenderRequestsListProvider);
    final pendingRequests = ref.watch(pendingRequestsProvider);
    final submittedRequests = ref.watch(submittedRequestsProvider);

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
                ref.read(recommenderRequestsProvider.notifier).fetchRequests();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (isLoading) {
      return const LoadingIndicator(message: 'Loading requests...');
    }

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: 'All (${allRequests.length})'),
            Tab(text: 'Pending (${pendingRequests.length})'),
            Tab(text: 'Submitted (${submittedRequests.length})'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildRequestsList(allRequests, 'all'),
              _buildRequestsList(pendingRequests, 'pending'),
              _buildRequestsList(submittedRequests, 'submitted'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRequestsList(List<Recommendation> requests, String type) {
    if (requests.isEmpty) {
      String message;
      switch (type) {
        case 'pending':
          message = 'No pending recommendation requests';
          break;
        case 'submitted':
          message = 'No submitted recommendations yet';
          break;
        default:
          message = 'No recommendation requests';
      }

      return EmptyState(
        icon: Icons.description_outlined,
        title: 'No Requests',
        message: message,
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(recommenderRequestsProvider.notifier).fetchRequests();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final request = requests[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _RequestCard(
              request: request,
              onTap: () async {
                await context.push(
                  '/recommender/requests/${request.id}',
                  extra: request,
                );
                if (context.mounted) {
                  ref.read(recommenderRequestsProvider.notifier).fetchRequests();
                }
              },
            ),
          );
        },
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final Recommendation request;
  final VoidCallback onTap;

  const _RequestCard({
    required this.request,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final daysLeft = request.deadline?.difference(DateTime.now()).inDays;
    final isOverdue = request.isOverdue;

    return CustomCard(
      onTap: onTap,
      color: isOverdue
          ? AppColors.error.withValues(alpha: 0.05)
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary,
                child: Text(
                  request.studentName.substring(0, 1),
                  style: const TextStyle(
                    color: AppColors.textOnPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.studentName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      request.institutionName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              _StatusChip(
                status: request.status,
                isOverdue: isOverdue,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            request.programName,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 16,
                color: isOverdue ? AppColors.error : AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                request.deadline != null
                    ? isOverdue
                        ? 'Overdue!'
                        : '$daysLeft days left'
                    : 'No deadline',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isOverdue ? AppColors.error : AppColors.textSecondary,
                      fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                    ),
              ),
              const Spacer(),
              if (request.isDraft)
                const Icon(
                  Icons.edit,
                  size: 16,
                  color: AppColors.warning,
                ),
              if (request.isSubmitted)
                const Icon(
                  Icons.check_circle,
                  size: 16,
                  color: AppColors.success,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  final bool isOverdue;

  const _StatusChip({
    required this.status,
    this.isOverdue = false,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    if (isOverdue) {
      color = AppColors.error;
      label = 'OVERDUE';
    } else {
      switch (status) {
        case 'draft':
          color = AppColors.warning;
          label = 'DRAFT';
          break;
        case 'submitted':
          color = AppColors.success;
          label = 'SUBMITTED';
          break;
        default:
          color = AppColors.textSecondary;
          label = status.toUpperCase();
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
