import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n_extension.dart';
import '../../../../core/constants/admin_permissions.dart';
import '../../shared/widgets/admin_data_table.dart';
import '../../shared/widgets/permission_guard.dart';
import '../../shared/providers/admin_finance_provider.dart';

/// Refunds Management Screen - Process and track refund requests
class RefundsScreen extends ConsumerStatefulWidget {
  const RefundsScreen({super.key});

  @override
  ConsumerState<RefundsScreen> createState() => _RefundsScreenState();
}

class _RefundsScreenState extends ConsumerState<RefundsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Transaction> _getRefundTransactions(List<Transaction> transactions) {
    var filtered = transactions.where((t) =>
      t.type == 'refund' || t.status == 'refunded',
    ).toList();

    if (_selectedStatus != 'all') {
      filtered = filtered.where((t) => t.status == _selectedStatus).toList();
    }

    final query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      filtered = filtered.where((t) =>
        t.id.toLowerCase().contains(query) ||
        t.userName.toLowerCase().contains(query) ||
        t.amount.toStringAsFixed(2).contains(query)
      ).toList();
    }

    return filtered;
  }

  /// Get pending refund candidates — completed payments that can be refunded
  List<Transaction> _getPendingRefundCandidates(List<Transaction> transactions) {
    return transactions.where((t) =>
      t.type == 'payment' && t.status == 'completed',
    ).toList();
  }

  String _formatCurrency(dynamic value) {
    final num amount = value is num ? value : 0;
    return 'KES ${amount.toStringAsFixed(2)}';
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final financeState = ref.watch(adminFinanceProvider);
    final refunds = _getRefundTransactions(financeState.transactions);
    final candidates = _getPendingRefundCandidates(financeState.transactions);

    final totalRefunded = refunds
        .where((t) => t.status == 'completed')
        .fold<double>(0, (sum, t) => sum + t.amount);
    final pendingRefunds = refunds
        .where((t) => t.status == 'pending')
        .fold<double>(0, (sum, t) => sum + t.amount);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        _buildStatsCards(refunds.length, totalRefunded, pendingRefunds, candidates.length),
        const SizedBox(height: 24),
        _buildFilters(),
        const SizedBox(height: 24),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: _buildDataTable(refunds, financeState.isLoading),
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
                  Icon(Icons.replay, size: 32, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Text(
                    context.l10n.adminFinanceRefundsTitle,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.adminFinanceRefundsSubtitle,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => ref.read(adminFinanceProvider.notifier).fetchTransactions(),
                icon: const Icon(Icons.refresh),
                tooltip: context.l10n.adminFinanceRefresh,
              ),
              const SizedBox(width: 8),
              PermissionGuard(
                permission: AdminPermission.processRefunds,
                child: ElevatedButton.icon(
                  onPressed: () => _showNewRefundDialog(),
                  icon: const Icon(Icons.add, size: 20),
                  label: Text(context.l10n.adminFinanceNewRefund),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(int totalCount, double totalRefunded, double pendingAmount, int eligibleCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(child: _buildStatCard(context.l10n.adminFinanceTotalRefunds, '$totalCount', context.l10n.adminFinanceAllRefundTransactions, Icons.replay, AppColors.primary)),
          const SizedBox(width: 16),
          Expanded(child: _buildStatCard(context.l10n.adminFinanceRefundedAmount, _formatCurrency(totalRefunded), context.l10n.adminFinanceSuccessfullyRefunded, Icons.check_circle, AppColors.success)),
          const SizedBox(width: 16),
          Expanded(child: _buildStatCard(context.l10n.adminFinancePending, _formatCurrency(pendingAmount), context.l10n.adminFinanceAwaitingProcessing, Icons.pending, AppColors.warning)),
          const SizedBox(width: 16),
          Expanded(child: _buildStatCard(context.l10n.adminFinanceEligible, '$eligibleCount', context.l10n.adminFinancePaymentsEligibleForRefund, Icons.receipt, AppColors.info)),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String subtitle, IconData icon, Color color) {
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
              Text(title, style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w500)),
              Icon(icon, size: 20, color: color.withValues(alpha: 0.6)),
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: context.l10n.adminFinanceSearchRefundsHint,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<String>(
              initialValue: _selectedStatus,
              decoration: InputDecoration(
                labelText: context.l10n.adminFinanceStatus,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              items: [
                DropdownMenuItem(value: 'all', child: Text(context.l10n.adminFinanceAllStatus)),
                DropdownMenuItem(value: 'completed', child: Text(context.l10n.adminFinanceCompleted)),
                DropdownMenuItem(value: 'pending', child: Text(context.l10n.adminFinancePending)),
                DropdownMenuItem(value: 'failed', child: Text(context.l10n.adminFinanceFailed)),
                DropdownMenuItem(value: 'refunded', child: Text(context.l10n.adminFinanceRefunded)),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _selectedStatus = v);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable(List<Transaction> refunds, bool isLoading) {
    return AdminDataTable<Transaction>(
      columns: [
        DataTableColumn(
          label: context.l10n.adminFinanceRefundId,
          cellBuilder: (txn) => Text(
            txn.id,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, fontFamily: 'monospace'),
          ),
          sortable: true,
        ),
        DataTableColumn(
          label: context.l10n.adminFinanceUser,
          cellBuilder: (txn) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(txn.userName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              Text(txn.userId, style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
            ],
          ),
        ),
        DataTableColumn(
          label: context.l10n.adminFinanceAmount,
          cellBuilder: (txn) => Text(
            _formatCurrency(txn.amount),
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ),
        DataTableColumn(
          label: context.l10n.adminFinanceReason,
          cellBuilder: (txn) {
            final reason = txn.metadata?['reason'] ?? txn.itemName ?? '-';
            return Text(reason.toString(), style: const TextStyle(fontSize: 13));
          },
        ),
        DataTableColumn(
          label: context.l10n.adminFinanceStatus,
          cellBuilder: (txn) => _buildStatusChip(txn.status),
        ),
        DataTableColumn(
          label: context.l10n.adminFinanceDate,
          cellBuilder: (txn) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_formatDate(txn.createdAt), style: const TextStyle(fontSize: 13)),
              Text(_formatTime(txn.createdAt), style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
            ],
          ),
          sortable: true,
        ),
      ],
      data: refunds,
      isLoading: isLoading,
      enableSelection: true,
      onRowTap: (txn) => _showRefundDetails(txn),
      rowActions: [
        DataTableAction(
          icon: Icons.visibility,
          tooltip: context.l10n.adminFinanceViewDetails,
          onPressed: (txn) => _showRefundDetails(txn),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String label;
    switch (status.toLowerCase()) {
      case 'completed':
      case 'refunded':
        color = AppColors.success;
        label = status == 'refunded' ? context.l10n.adminFinanceRefunded : context.l10n.adminFinanceCompleted;
        break;
      case 'pending':
        color = AppColors.warning;
        label = context.l10n.adminFinancePending;
        break;
      case 'failed':
        color = AppColors.error;
        label = context.l10n.adminFinanceFailed;
        break;
      default:
        color = AppColors.textSecondary;
        label = status;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }

  void _showRefundDetails(Transaction txn) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.replay, color: AppColors.primary),
            const SizedBox(width: 12),
            Text(context.l10n.adminFinanceRefundDetails),
          ],
        ),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow(context.l10n.adminFinanceRefundId, txn.id),
              _buildDetailRow(context.l10n.adminFinanceUser, txn.userName),
              _buildDetailRow(context.l10n.adminFinanceUserId, txn.userId),
              _buildDetailRow(context.l10n.adminFinanceAmount, _formatCurrency(txn.amount)),
              _buildDetailRow(context.l10n.adminFinanceCurrency, txn.currency),
              _buildDetailRow(context.l10n.adminFinanceStatus, txn.status),
              if (txn.metadata?['reason'] != null)
                _buildDetailRow(context.l10n.adminFinanceReason, txn.metadata!['reason'].toString()),
              if (txn.metadata?['originalTransaction'] != null)
                _buildDetailRow(context.l10n.adminFinanceOriginalTxn, txn.metadata!['originalTransaction'].toString()),
              _buildDetailRow(context.l10n.adminFinanceDate, '${_formatDate(txn.createdAt)} ${_formatTime(txn.createdAt)}'),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(context.l10n.adminFinanceClose)),
        ],
      ),
    );
  }

  void _showNewRefundDialog() {
    final transactions = ref.read(adminFinanceProvider).transactions;
    final candidates = _getPendingRefundCandidates(transactions);

    if (candidates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.adminFinanceNoEligibleTransactions)),
      );
      return;
    }

    Transaction? selectedTxn;
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.replay, color: AppColors.warning),
              const SizedBox(width: 12),
              Text(context.l10n.adminFinanceProcessNewRefund),
            ],
          ),
          content: SizedBox(
            width: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.adminFinanceSelectTransactionToRefund, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                DropdownButtonFormField<Transaction>(
                  initialValue: selectedTxn,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    hintText: context.l10n.adminFinanceChooseTransaction,
                  ),
                  isExpanded: true,
                  items: candidates.take(20).map((t) {
                    return DropdownMenuItem(
                      value: t,
                      child: Text(
                        '${t.id.length > 16 ? '${t.id.substring(0, 16)}...' : t.id} — ${_formatCurrency(t.amount)} — ${t.userName}',
                        style: const TextStyle(fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (v) => setDialogState(() => selectedTxn = v),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: reasonController,
                  decoration: InputDecoration(
                    labelText: context.l10n.adminFinanceReasonForRefund,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  maxLines: 2,
                ),
                if (selectedTxn != null) ...[
                  const SizedBox(height: 16),
                  _buildDetailRow(context.l10n.adminFinanceAmount, _formatCurrency(selectedTxn!.amount)),
                  _buildDetailRow(context.l10n.adminFinanceUser, selectedTxn!.userName),
                ],
                const SizedBox(height: 12),
                Text(context.l10n.adminFinanceActionCannotBeUndone, style: TextStyle(color: AppColors.error, fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text(context.l10n.adminFinanceCancel)),
            ElevatedButton(
              onPressed: selectedTxn != null
                  ? () async {
                      Navigator.pop(ctx);
                      final success = await ref.read(adminFinanceProvider.notifier).processRefund(
                        selectedTxn!.id,
                        selectedTxn!.amount,
                        reasonController.text.isNotEmpty ? reasonController.text : 'Admin initiated refund',
                      );
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(success ? context.l10n.adminFinanceRefundProcessedSuccess : context.l10n.adminFinanceRefundProcessedFail),
                            backgroundColor: success ? AppColors.success : AppColors.error,
                          ),
                        );
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning),
              child: Text(context.l10n.adminFinanceProcessRefund),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
