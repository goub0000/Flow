// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/l10n_extension.dart';
import '../../providers/approvals_provider.dart';
import '../widgets/approval_request_card.dart';
import '../widgets/approval_filter_dialog.dart';

/// Screen displaying list of approval requests
class ApprovalListScreen extends ConsumerStatefulWidget {
  const ApprovalListScreen({super.key});

  @override
  ConsumerState<ApprovalListScreen> createState() => _ApprovalListScreenState();
}

class _ApprovalListScreenState extends ConsumerState<ApprovalListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(approvalsListProvider.notifier).fetchRequests();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(approvalsListProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(approvalsListProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.adminApprovalRequests),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            tooltip: context.l10n.adminApprovalFilter,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(approvalsListProvider.notifier).refresh(),
            tooltip: context.l10n.adminApprovalRefresh,
          ),
        ],
      ),
      body: Column(
        children: [
          // Active filter indicator
          if (state.currentFilter != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: theme.colorScheme.primaryContainer,
              child: Row(
                children: [
                  Icon(
                    Icons.filter_alt,
                    size: 16,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    context.l10n.adminApprovalFiltersApplied,
                    style: TextStyle(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () =>
                        ref.read(approvalsListProvider.notifier).clearFilter(),
                    child: Text(context.l10n.adminApprovalClear),
                  ),
                ],
              ),
            ),

          // Results summary
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  context.l10n.adminApprovalRequestCount(state.total),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // List
          Expanded(
            child: _buildList(state),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/admin/approvals/create'),
        icon: const Icon(Icons.add),
        label: Text(context.l10n.adminApprovalNewRequest),
      ),
    );
  }

  Widget _buildList(ApprovalsListState state) {
    if (state.isLoading && state.requests.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(context.l10n.adminApprovalErrorWithMessage(state.error!)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  ref.read(approvalsListProvider.notifier).refresh(),
              child: Text(context.l10n.adminApprovalRetry),
            ),
          ],
        ),
      );
    }

    if (state.requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(context.l10n.adminApprovalNoRequestsFound),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.go('/admin/approvals/create'),
              child: Text(context.l10n.adminApprovalCreateNewRequest),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(approvalsListProvider.notifier).refresh(),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
        itemCount: state.requests.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.requests.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final request = state.requests[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ApprovalRequestCard(
              request: request,
              onTap: () => context.go('/admin/approvals/${request.id}'),
            ),
          );
        },
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => ApprovalFilterDialog(
        currentFilter: ref.read(approvalsListProvider).currentFilter,
        onApply: (filter) {
          ref.read(approvalsListProvider.notifier).applyFilter(filter);
          Navigator.pop(context);
        },
      ),
    );
  }
}
