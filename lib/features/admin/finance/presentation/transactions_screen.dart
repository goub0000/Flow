import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/admin_permissions.dart';
// AdminShell is now provided by ShellRoute in admin_routes.dart
import '../../shared/widgets/admin_data_table.dart';
import '../../shared/widgets/permission_guard.dart';

/// Transactions Screen - View and manage payment transactions
///
/// Features:
/// - View all payment transactions
/// - Filter by status, type, date range, amount
/// - Search transactions
/// - Process refunds
/// - View transaction details
/// - Export transaction reports
/// - Monitor payment settlement status
class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  // TODO: Replace with actual state management
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'all';
  String _selectedType = 'all';
  String _selectedDateRange = 'last30days';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch transactions from backend
    // - API endpoint: GET /api/admin/finance/transactions
    // - Support pagination, filtering, search
    // - Include: transaction details, user info, payment method, status
    // - Real-time updates for status changes

    // Content is wrapped by AdminShell via ShellRoute
    return _buildContent();
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Page Header with Stats
        _buildHeader(),
        const SizedBox(height: 24),

        // Stats Cards
        _buildStatsCards(),
        const SizedBox(height: 24),

        // Filters and Search
        _buildFiltersSection(),
        const SizedBox(height: 24),

        // Data Table
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: _buildDataTable(),
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
                    'Transactions',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Monitor and manage payment transactions',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Row(
            children: [
              // Refresh button
              IconButton(
                onPressed: () {
                  // TODO: Refresh transactions
                },
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh Transactions',
              ),
              const SizedBox(width: 8),
              // Export button (requires permission)
              PermissionGuard(
                permission: AdminPermission.exportData,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Implement export functionality
                    // - Generate CSV/Excel report
                    // - Include filtered data
                    // - Trigger download
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

  Widget _buildStatsCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total Volume',
              'KES 0.00', // TODO: Replace with actual data
              'Last 30 days',
              Icons.trending_up,
              AppColors.success,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'Successful',
              '0', // TODO: Replace with actual data
              '0.0% success rate',
              Icons.check_circle,
              AppColors.success,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'Failed',
              '0', // TODO: Replace with actual data
              '0.0% failure rate',
              Icons.error,
              AppColors.error,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'Pending',
              '0', // TODO: Replace with actual data
              'Awaiting processing',
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
          // Search
          Expanded(
            flex: 2,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by transaction ID, user, or amount...',
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
                // TODO: Implement search
                // - Debounce input
                // - Call API with search query
                // - Update results
              },
            ),
          ),
          const SizedBox(width: 16),

          // Status Filter
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Status')),
                DropdownMenuItem(value: 'completed', child: Text('Completed')),
                DropdownMenuItem(value: 'pending', child: Text('Pending')),
                DropdownMenuItem(value: 'failed', child: Text('Failed')),
                DropdownMenuItem(value: 'refunded', child: Text('Refunded')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedStatus = value);
                  // TODO: Apply filter and reload data
                }
              },
            ),
          ),
          const SizedBox(width: 16),

          // Type Filter
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: InputDecoration(
                labelText: 'Type',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Types')),
                DropdownMenuItem(value: 'application', child: Text('Application Fee')),
                DropdownMenuItem(value: 'subscription', child: Text('Subscription')),
                DropdownMenuItem(value: 'service', child: Text('Service Fee')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedType = value);
                  // TODO: Apply filter and reload data
                }
              },
            ),
          ),
          const SizedBox(width: 16),

          // Date Range Filter
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedDateRange,
              decoration: InputDecoration(
                labelText: 'Date Range',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'today', child: Text('Today')),
                DropdownMenuItem(value: 'yesterday', child: Text('Yesterday')),
                DropdownMenuItem(value: 'last7days', child: Text('Last 7 Days')),
                DropdownMenuItem(value: 'last30days', child: Text('Last 30 Days')),
                DropdownMenuItem(value: 'custom', child: Text('Custom Range')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedDateRange = value);
                  // TODO: Apply filter and reload data
                  // TODO: Show date picker for custom range
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    // TODO: Replace with actual data from backend
    final List<TransactionRowData> transactions = [];

    return AdminDataTable<TransactionRowData>(
      columns: [
        DataTableColumn(
          label: 'Transaction ID',
          cellBuilder: (txn) => Text(
            txn.transactionId,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              fontFamily: 'monospace',
            ),
          ),
          sortable: true,
        ),
        DataTableColumn(
          label: 'User',
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
                txn.userEmail,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        DataTableColumn(
          label: 'Type',
          cellBuilder: (txn) => Text(
            txn.type,
            style: const TextStyle(fontSize: 13),
          ),
        ),
        DataTableColumn(
          label: 'Amount',
          cellBuilder: (txn) => Text(
            txn.amount,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
        DataTableColumn(
          label: 'Payment Method',
          cellBuilder: (txn) => _buildPaymentMethodChip(txn.paymentMethod),
        ),
        DataTableColumn(
          label: 'Status',
          cellBuilder: (txn) => _buildStatusChip(txn.status),
        ),
        DataTableColumn(
          label: 'Date',
          cellBuilder: (txn) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                txn.date,
                style: const TextStyle(fontSize: 13),
              ),
              Text(
                txn.time,
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
      isLoading: false, // TODO: Set from actual loading state
      enableSelection: true,
      onSelectionChanged: (selectedItems) {
        // TODO: Handle bulk actions on selected items
      },
      onRowTap: (txn) {
        _showTransactionDetails(txn);
      },
      rowActions: [
        DataTableAction(
          icon: Icons.visibility,
          tooltip: 'View Details',
          onPressed: (txn) {
            _showTransactionDetails(txn);
          },
        ),
        DataTableAction(
          icon: Icons.receipt,
          tooltip: 'Download Receipt',
          onPressed: (txn) {
            // TODO: Generate and download receipt
          },
        ),
        DataTableAction(
          icon: Icons.replay,
          tooltip: 'Process Refund',
          color: AppColors.warning,
          onPressed: (txn) {
            // TODO: Show refund confirmation dialog
            // TODO: Process refund (requires AdminPermission.processRefunds)
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

  Widget _buildPaymentMethodChip(String method) {
    IconData icon;
    Color color = AppColors.primary;

    switch (method.toLowerCase()) {
      case 'm-pesa':
      case 'mpesa':
        icon = Icons.phone_android;
        color = AppColors.success;
        break;
      case 'card':
      case 'credit card':
        icon = Icons.credit_card;
        break;
      case 'bank':
      case 'bank transfer':
        icon = Icons.account_balance;
        break;
      default:
        icon = Icons.payment;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          method,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _showTransactionDetails(TransactionRowData txn) {
    // TODO: Implement detailed transaction modal
    // - Full transaction details
    // - Payment gateway response
    // - User information
    // - Timeline of status changes
    // - Related transactions (refunds, etc.)
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
            const Text('Transaction Details'),
          ],
        ),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Transaction ID', txn.transactionId),
              _buildDetailRow('User', txn.userName),
              _buildDetailRow('Email', txn.userEmail),
              _buildDetailRow('Type', txn.type),
              _buildDetailRow('Amount', txn.amount),
              _buildDetailRow('Payment Method', txn.paymentMethod),
              _buildDetailRow('Status', txn.status),
              _buildDetailRow('Date', '${txn.date} ${txn.time}'),
              const SizedBox(height: 16),
              Text(
                'Full details will be available with backend integration.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          PermissionGuard(
            permission: AdminPermission.processRefunds,
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showRefundDialog(txn);
              },
              child: const Text('Process Refund'),
            ),
          ),
        ],
      ),
    );
  }

  void _showRefundDialog(TransactionRowData txn) {
    // TODO: Implement refund processing dialog
    // - Confirm refund amount
    // - Add refund reason
    // - Call refund API
    // - Show confirmation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.replay,
              color: AppColors.warning,
            ),
            const SizedBox(width: 12),
            const Text('Process Refund'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to refund this transaction?',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Transaction ID', txn.transactionId),
            _buildDetailRow('User', txn.userName),
            _buildDetailRow('Amount', txn.amount),
            const SizedBox(height: 16),
            Text(
              'This action cannot be undone.',
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
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Process refund
              // - Call refund API
              // - Update transaction status
              // - Show success message
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Refund will be processed with backend integration'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warning,
            ),
            child: const Text('Process Refund'),
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

/// Temporary data model for table rows
/// TODO: Replace with actual Transaction model from backend
class TransactionRowData {
  final String id;
  final String transactionId;
  final String userName;
  final String userEmail;
  final String type;
  final String amount;
  final String paymentMethod;
  final String status;
  final String date;
  final String time;

  TransactionRowData({
    required this.id,
    required this.transactionId,
    required this.userName,
    required this.userEmail,
    required this.type,
    required this.amount,
    required this.paymentMethod,
    required this.status,
    required this.date,
    required this.time,
  });
}
