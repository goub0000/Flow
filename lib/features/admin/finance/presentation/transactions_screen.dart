import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n_extension.dart';
import '../../../../core/constants/admin_permissions.dart';
import '../../shared/widgets/admin_data_table.dart';
import '../../shared/widgets/permission_guard.dart';
import '../../shared/providers/admin_finance_provider.dart';

/// Transactions Screen - View and manage payment transactions
class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'all';
  String _selectedType = 'all';
  String _selectedDateRange = 'last30days';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Transaction> _getFilteredTransactions(List<Transaction> transactions) {
    var filtered = transactions;

    if (_selectedStatus != 'all') {
      filtered = filtered.where((t) => t.status == _selectedStatus).toList();
    }
    if (_selectedType != 'all') {
      filtered = filtered.where((t) => t.type == _selectedType).toList();
    }

    // Date range filtering
    final now = DateTime.now();
    DateTime? startDate;
    switch (_selectedDateRange) {
      case 'today':
        startDate = DateTime(now.year, now.month, now.day);
        break;
      case 'yesterday':
        startDate = DateTime(now.year, now.month, now.day - 1);
        break;
      case 'last7days':
        startDate = now.subtract(const Duration(days: 7));
        break;
      case 'last30days':
        startDate = now.subtract(const Duration(days: 30));
        break;
    }
    if (startDate != null) {
      filtered = filtered.where((t) => t.createdAt.isAfter(startDate!)).toList();
    }

    final query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      filtered = filtered.where((t) =>
        t.id.toLowerCase().contains(query) ||
        t.userName.toLowerCase().contains(query) ||
        t.amount.toStringAsFixed(2).contains(query) ||
        (t.itemName?.toLowerCase().contains(query) ?? false)
      ).toList();
    }

    return filtered;
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
    return _buildContent();
  }

  Widget _buildContent() {
    final financeState = ref.watch(adminFinanceProvider);
    final statistics = ref.watch(adminFinanceStatisticsProvider);
    final filteredTransactions = _getFilteredTransactions(financeState.transactions);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        _buildStatsCards(statistics),
        const SizedBox(height: 24),
        if (financeState.error != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.all(12),
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
                      financeState.error!,
                      style: TextStyle(color: AppColors.error, fontSize: 13),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, size: 18),
                    onPressed: () => ref.read(adminFinanceProvider.notifier).fetchTransactions(),
                    tooltip: context.l10n.adminFinanceRetry,
                  ),
                ],
              ),
            ),
          ),
        if (financeState.error != null) const SizedBox(height: 24),
        _buildFiltersSection(),
        const SizedBox(height: 24),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: _buildDataTable(filteredTransactions, financeState.isLoading),
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
                    Icons.account_balance_wallet,
                    size: 32,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    context.l10n.adminFinanceTransactionsTitle,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.adminFinanceTransactionsSubtitle,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  ref.read(adminFinanceProvider.notifier).fetchTransactions();
                },
                icon: const Icon(Icons.refresh),
                tooltip: context.l10n.adminFinanceRefreshTransactions,
              ),
              const SizedBox(width: 8),
              PermissionGuard(
                permission: AdminPermission.exportData,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Implement export functionality
                  },
                  icon: const Icon(Icons.download, size: 20),
                  label: Text(context.l10n.adminFinanceExportReport),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(Map<String, dynamic> statistics) {
    final totalRevenue = statistics['totalRevenue'] ?? 0.0;
    final successfulCount = statistics['successfulTransactions'] ?? 0;
    final successRate = statistics['successRate'] ?? 0.0;
    final failedCount = statistics['failedTransactions'] ?? 0;
    final totalCount = statistics['totalTransactions'] ?? 0;
    final failureRate = totalCount > 0 ? (failedCount / totalCount * 100) : 0.0;
    final pendingAmount = statistics['pendingAmount'] ?? 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              context.l10n.adminFinanceTotalVolume,
              _formatCurrency(totalRevenue),
              context.l10n.adminFinanceAllCompletedPayments,
              Icons.trending_up,
              AppColors.success,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              context.l10n.adminFinanceSuccessful,
              '$successfulCount',
              '${successRate.toStringAsFixed(1)}% success rate',
              Icons.check_circle,
              AppColors.success,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              context.l10n.adminFinanceFailed,
              '$failedCount',
              '${failureRate.toStringAsFixed(1)}% failure rate',
              Icons.error,
              AppColors.error,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              context.l10n.adminFinancePending,
              _formatCurrency(pendingAmount),
              context.l10n.adminFinanceAwaitingProcessing,
              Icons.pending,
              AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
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
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
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

  Widget _buildFiltersSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: context.l10n.adminFinanceSearchTransactionsHint,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: InputDecoration(
                labelText: context.l10n.adminFinanceStatus,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              items: [
                DropdownMenuItem(value: 'all', child: Text(context.l10n.adminFinanceAllStatus)),
                DropdownMenuItem(value: 'completed', child: Text(context.l10n.adminFinanceCompleted)),
                DropdownMenuItem(value: 'pending', child: Text(context.l10n.adminFinancePending)),
                DropdownMenuItem(value: 'failed', child: Text(context.l10n.adminFinanceFailed)),
                DropdownMenuItem(value: 'refunded', child: Text(context.l10n.adminFinanceRefunded)),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedStatus = value);
                }
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: InputDecoration(
                labelText: context.l10n.adminFinanceType,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              items: [
                DropdownMenuItem(value: 'all', child: Text(context.l10n.adminFinanceAllTypes)),
                DropdownMenuItem(value: 'payment', child: Text(context.l10n.adminFinancePayment)),
                DropdownMenuItem(value: 'refund', child: Text(context.l10n.adminFinanceRefund)),
                DropdownMenuItem(value: 'settlement', child: Text(context.l10n.adminFinanceSettlement)),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedType = value);
                }
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedDateRange,
              decoration: InputDecoration(
                labelText: context.l10n.adminFinanceDateRange,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              items: [
                DropdownMenuItem(value: 'today', child: Text(context.l10n.adminFinanceToday)),
                DropdownMenuItem(value: 'yesterday', child: Text(context.l10n.adminFinanceYesterday)),
                DropdownMenuItem(value: 'last7days', child: Text(context.l10n.adminFinanceLast7Days)),
                DropdownMenuItem(value: 'last30days', child: Text(context.l10n.adminFinanceLast30Days)),
                DropdownMenuItem(value: 'all', child: Text(context.l10n.adminFinanceAllTime)),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedDateRange = value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable(List<Transaction> transactions, bool isLoading) {
    return AdminDataTable<Transaction>(
      columns: [
        DataTableColumn(
          label: context.l10n.adminFinanceTransactionId,
          cellBuilder: (txn) => Text(
            txn.id,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              fontFamily: 'monospace',
            ),
          ),
          sortable: true,
        ),
        DataTableColumn(
          label: context.l10n.adminFinanceUser,
          cellBuilder: (txn) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                txn.userName,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              Text(
                txn.userId,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        DataTableColumn(
          label: context.l10n.adminFinanceType,
          cellBuilder: (txn) => Text(
            txn.type,
            style: const TextStyle(fontSize: 13),
          ),
        ),
        DataTableColumn(
          label: context.l10n.adminFinanceAmount,
          cellBuilder: (txn) => Text(
            _formatCurrency(txn.amount),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
        DataTableColumn(
          label: context.l10n.adminFinanceDescription,
          cellBuilder: (txn) => Text(
            txn.itemName ?? txn.itemType ?? '-',
            style: const TextStyle(fontSize: 13),
          ),
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
              Text(
                _formatDate(txn.createdAt),
                style: const TextStyle(fontSize: 13),
              ),
              Text(
                _formatTime(txn.createdAt),
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          sortable: true,
        ),
      ],
      data: transactions,
      isLoading: isLoading,
      enableSelection: true,
      onSelectionChanged: (selectedItems) {
        // Handle bulk actions
      },
      onRowTap: (txn) {
        _showTransactionDetails(txn);
      },
      rowActions: [
        DataTableAction(
          icon: Icons.visibility,
          tooltip: context.l10n.adminFinanceViewDetails,
          onPressed: (txn) {
            _showTransactionDetails(txn);
          },
        ),
        DataTableAction(
          icon: Icons.receipt,
          tooltip: context.l10n.adminFinanceDownloadReceipt,
          onPressed: (txn) {
            // TODO: Generate and download receipt
          },
        ),
        DataTableAction(
          icon: Icons.replay,
          tooltip: context.l10n.adminFinanceProcessRefund,
          color: AppColors.warning,
          onPressed: (txn) {
            _showRefundDialog(txn);
          },
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String label;

    switch (status.toLowerCase()) {
      case 'completed':
      case 'success':
        color = AppColors.success;
        label = 'Completed';
        break;
      case 'pending':
        color = AppColors.warning;
        label = 'Pending';
        break;
      case 'failed':
        color = AppColors.error;
        label = 'Failed';
        break;
      case 'refunded':
        color = AppColors.textSecondary;
        label = 'Refunded';
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
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showTransactionDetails(Transaction txn) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.receipt_long,
              color: AppColors.primary,
            ),
            const SizedBox(width: 12),
            Text(context.l10n.adminFinanceTransactionDetails),
          ],
        ),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(context.l10n.adminFinanceTransactionId, txn.id),
              _buildDetailRow(context.l10n.adminFinanceUser, txn.userName),
              _buildDetailRow(context.l10n.adminFinanceUserId, txn.userId),
              _buildDetailRow(context.l10n.adminFinanceType, txn.type),
              _buildDetailRow(context.l10n.adminFinanceAmount, _formatCurrency(txn.amount)),
              _buildDetailRow(context.l10n.adminFinanceCurrency, txn.currency),
              _buildDetailRow(context.l10n.adminFinanceStatus, txn.status),
              if (txn.itemName != null)
                _buildDetailRow(context.l10n.adminFinanceDescription, txn.itemName!),
              if (txn.itemType != null)
                _buildDetailRow(context.l10n.adminFinanceItemType, txn.itemType!),
              _buildDetailRow(context.l10n.adminFinanceDate, '${_formatDate(txn.createdAt)} ${_formatTime(txn.createdAt)}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.adminFinanceClose),
          ),
          PermissionGuard(
            permission: AdminPermission.processRefunds,
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showRefundDialog(txn);
              },
              child: Text(context.l10n.adminFinanceProcessRefund),
            ),
          ),
        ],
      ),
    );
  }

  void _showRefundDialog(Transaction txn) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.replay,
              color: AppColors.warning,
            ),
            const SizedBox(width: 12),
            Text(context.l10n.adminFinanceProcessRefund),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.adminFinanceConfirmRefund,
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(context.l10n.adminFinanceTransactionId, txn.id),
            _buildDetailRow(context.l10n.adminFinanceUser, txn.userName),
            _buildDetailRow(context.l10n.adminFinanceAmount, _formatCurrency(txn.amount)),
            const SizedBox(height: 16),
            Text(
              context.l10n.adminFinanceActionCannotBeUndone,
              style: TextStyle(
                color: AppColors.error,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(context.l10n.adminFinanceCancel),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              final success = await ref
                  .read(adminFinanceProvider.notifier)
                  .processRefund(txn.id, txn.amount, 'Admin initiated refund');
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success
                        ? context.l10n.adminFinanceRefundSuccess
                        : context.l10n.adminFinanceRefundFailed),
                    backgroundColor: success ? AppColors.success : AppColors.error,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warning,
            ),
            child: Text(context.l10n.adminFinanceProcessRefund),
          ),
        ],
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
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
