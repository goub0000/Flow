import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/payment_model.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_config.dart';
import '../../../../core/providers/service_providers.dart';

/// Transaction model for admin finance
class Transaction {
  final String id;
  final String userId;
  final String userName;
  final String type; // 'payment', 'refund', 'settlement'
  final double amount;
  final String currency;
  final String status;
  final String? itemType;
  final String? itemName;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  const Transaction({
    required this.id,
    required this.userId,
    required this.userName,
    required this.type,
    required this.amount,
    required this.currency,
    required this.status,
    this.itemType,
    this.itemName,
    required this.createdAt,
    this.metadata,
  });

  static Transaction fromPayment(Payment payment, String userName) {
    return Transaction(
      id: payment.id,
      userId: payment.userId,
      userName: userName,
      type: 'payment',
      amount: payment.amount,
      currency: payment.currency,
      status: payment.status,
      itemType: payment.itemType,
      itemName: null,
      createdAt: payment.createdAt,
      metadata: {'transactionId': payment.transactionId},
    );
  }

  static Transaction mockTransaction(int index) {
    final types = ['payment', 'refund', 'settlement'];
    final statuses = ['completed', 'pending', 'failed', 'processing'];
    final itemTypes = ['course', 'application', 'subscription'];

    return Transaction(
      id: 'txn_$index',
      userId: 'user_$index',
      userName: 'User ${index + 1}',
      type: types[index % types.length],
      amount: (100.0 + index * 50),
      currency: 'USD',
      status: statuses[index % statuses.length],
      itemType: itemTypes[index % itemTypes.length],
      itemName: 'Item ${index + 1}',
      createdAt: DateTime.now().subtract(Duration(days: index)),
      metadata: {'gateway': 'flutterwave'},
    );
  }
}

/// State class for admin finance
class AdminFinanceState {
  final List<Transaction> transactions;
  final Map<String, dynamic> statistics;
  final bool isLoading;
  final String? error;

  const AdminFinanceState({
    this.transactions = const [],
    this.statistics = const {},
    this.isLoading = false,
    this.error,
  });

  AdminFinanceState copyWith({
    List<Transaction>? transactions,
    Map<String, dynamic>? statistics,
    bool? isLoading,
    String? error,
  }) {
    return AdminFinanceState(
      transactions: transactions ?? this.transactions,
      statistics: statistics ?? this.statistics,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier for admin finance
class AdminFinanceNotifier extends StateNotifier<AdminFinanceState> {
  final ApiClient _apiClient;

  AdminFinanceNotifier(this._apiClient) : super(const AdminFinanceState()) {
    fetchTransactions();
  }

  /// Fetch all transactions from backend API
  Future<void> fetchTransactions() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiClient.get(
        '${ApiConfig.admin}/finance/transactions',
        fromJson: (data) {
          if (data is List) {
            // Backend may not have full transaction data yet
            return <Transaction>[];
          }
          return <Transaction>[];
        },
      );

      if (response.success) {
        final transactions = response.data ?? [];
        final stats = _calculateStatistics(transactions);

        state = state.copyWith(
          transactions: transactions,
          statistics: stats,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to fetch transactions',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch transactions: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Calculate financial statistics
  Map<String, dynamic> _calculateStatistics(List<Transaction> transactions) {
    double totalRevenue = 0;
    double totalRefunds = 0;
    double pendingAmount = 0;
    int successfulTransactions = 0;
    int failedTransactions = 0;

    for (final txn in transactions) {
      if (txn.type == 'payment' && txn.status == 'completed') {
        totalRevenue += txn.amount;
        successfulTransactions++;
      } else if (txn.type == 'refund' && txn.status == 'completed') {
        totalRefunds += txn.amount;
      } else if (txn.status == 'pending') {
        pendingAmount += txn.amount;
      } else if (txn.status == 'failed') {
        failedTransactions++;
      }
    }

    final netRevenue = totalRevenue - totalRefunds;

    return {
      'totalRevenue': totalRevenue,
      'totalRefunds': totalRefunds,
      'netRevenue': netRevenue,
      'pendingAmount': pendingAmount,
      'totalTransactions': transactions.length,
      'successfulTransactions': successfulTransactions,
      'failedTransactions': failedTransactions,
      'successRate': transactions.isEmpty
        ? 0.0
        : (successfulTransactions / transactions.length * 100),
    };
  }

  /// Process refund
  /// TODO: Connect to payment gateway API
  Future<bool> processRefund(String transactionId, double amount, String reason) async {
    try {
      // TODO: Call payment gateway refund API
      await Future.delayed(const Duration(seconds: 2));

      // Add refund transaction
      final refundTxn = Transaction(
        id: 'refund_${DateTime.now().millisecondsSinceEpoch}',
        userId: 'system',
        userName: 'System',
        type: 'refund',
        amount: amount,
        currency: 'USD',
        status: 'completed',
        createdAt: DateTime.now(),
        metadata: {'originalTransaction': transactionId, 'reason': reason},
      );

      final updatedTransactions = [refundTxn, ...state.transactions];
      final stats = _calculateStatistics(updatedTransactions);

      state = state.copyWith(
        transactions: updatedTransactions,
        statistics: stats,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to process refund: ${e.toString()}',
      );
      return false;
    }
  }

  /// Filter transactions
  List<Transaction> filterTransactions({
    String? type,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    var filtered = state.transactions;

    if (type != null && type != 'all') {
      filtered = filtered.where((txn) => txn.type == type).toList();
    }

    if (status != null && status != 'all') {
      filtered = filtered.where((txn) => txn.status == status).toList();
    }

    if (startDate != null) {
      filtered = filtered.where((txn) => txn.createdAt.isAfter(startDate)).toList();
    }

    if (endDate != null) {
      filtered = filtered.where((txn) => txn.createdAt.isBefore(endDate)).toList();
    }

    return filtered;
  }

  /// Get revenue by period
  Map<String, double> getRevenueByPeriod(String period) {
    // TODO: Implement grouping by day, week, month
    return {
      'Jan': 15000,
      'Feb': 18000,
      'Mar': 22000,
      'Apr': 19500,
      'May': 25000,
      'Jun': 28000,
    };
  }
}

/// Provider for admin finance state
final adminFinanceProvider = StateNotifierProvider<AdminFinanceNotifier, AdminFinanceState>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AdminFinanceNotifier(apiClient);
});

/// Provider for transactions list
final adminTransactionsListProvider = Provider<List<Transaction>>((ref) {
  final financeState = ref.watch(adminFinanceProvider);
  return financeState.transactions;
});

/// Provider for finance statistics
final adminFinanceStatisticsProvider = Provider<Map<String, dynamic>>((ref) {
  final financeState = ref.watch(adminFinanceProvider);
  return financeState.statistics;
});

/// Provider for checking if finance is loading
final adminFinanceLoadingProvider = Provider<bool>((ref) {
  final financeState = ref.watch(adminFinanceProvider);
  return financeState.isLoading;
});

/// Provider for finance error
final adminFinanceErrorProvider = Provider<String?>((ref) {
  final financeState = ref.watch(adminFinanceProvider);
  return financeState.error;
});
