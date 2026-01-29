import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/payment_model.dart';

/// State class for managing payments
class PaymentsState {
  final List<Payment> payments;
  final List<PaymentMethod> paymentMethods;
  final PaymentMethod? defaultPaymentMethod;
  final bool isLoading;
  final String? error;

  const PaymentsState({
    this.payments = const [],
    this.paymentMethods = const [],
    this.defaultPaymentMethod,
    this.isLoading = false,
    this.error,
  });

  PaymentsState copyWith({
    List<Payment>? payments,
    List<PaymentMethod>? paymentMethods,
    PaymentMethod? defaultPaymentMethod,
    bool? isLoading,
    String? error,
  }) {
    return PaymentsState(
      payments: payments ?? this.payments,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      defaultPaymentMethod: defaultPaymentMethod ?? this.defaultPaymentMethod,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier for managing payments
class PaymentsNotifier extends StateNotifier<PaymentsState> {
  PaymentsNotifier() : super(const PaymentsState()) {
    fetchPayments();
    fetchPaymentMethods();
  }

  /// Fetch all payments for current user
  /// TODO: Connect to backend API
  Future<void> fetchPayments() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Replace with actual Supabase query
      // Example: supabase
      //   .from('payments')
      //   .select()
      //   .eq('user_id', currentUserId)
      //   .order('created_at', ascending: false)

      await Future.delayed(const Duration(seconds: 1));

      // Mock data for development
      final mockPayments = List<Payment>.generate(
        15,
        (index) => Payment.mockPayment(index),
      );

      state = state.copyWith(
        payments: mockPayments,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch payments: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Fetch payment methods
  /// TODO: Connect to backend API
  Future<void> fetchPaymentMethods() async {
    try {
      // TODO: Fetch saved payment methods from backend API

      await Future.delayed(const Duration(milliseconds: 500));

      // Mock data
      final mockMethods = [
        PaymentMethod.mockCard(),
        PaymentMethod.mockMPesa(),
      ];

      state = state.copyWith(
        paymentMethods: mockMethods,
        defaultPaymentMethod: mockMethods.first,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch payment methods: ${e.toString()}',
      );
    }
  }

  /// Process a payment
  /// TODO: Connect to payment gateway (Flutterwave, M-Pesa, etc.)
  Future<bool> processPayment({
    required String itemId,
    required String itemName,
    required String itemType,
    required double amount,
    required String currency,
    required PaymentMethod method,
  }) async {
    try {
      // TODO: Integrate with payment gateway
      // 1. Initialize payment with gateway
      // 2. Handle payment callback
      // 3. Verify payment
      // 4. Update payment record in backend API

      await Future.delayed(const Duration(seconds: 2));

      final newPayment = Payment(
        id: 'pay_${DateTime.now().millisecondsSinceEpoch}',
        userId: 'current_user_id',
        itemId: itemId,
        itemName: itemName,
        itemType: itemType,
        amount: amount,
        currency: currency,
        method: method.type,
        status: 'completed',
        transactionId: 'txn_${DateTime.now().millisecondsSinceEpoch}',
        createdAt: DateTime.now(),
      );

      final updatedPayments = [newPayment, ...state.payments];
      state = state.copyWith(payments: updatedPayments);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Payment failed: ${e.toString()}',
      );
      return false;
    }
  }

  /// Add payment method
  /// TODO: Connect to backend API
  Future<bool> addPaymentMethod(PaymentMethod method) async {
    try {
      // TODO: Save to backend API (store securely)

      await Future.delayed(const Duration(milliseconds: 500));

      final updatedMethods = [...state.paymentMethods, method];
      state = state.copyWith(paymentMethods: updatedMethods);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to add payment method: ${e.toString()}',
      );
      return false;
    }
  }

  /// Remove payment method
  /// TODO: Connect to backend API
  Future<bool> removePaymentMethod(String methodId) async {
    try {
      // TODO: Remove from backend API

      await Future.delayed(const Duration(milliseconds: 500));

      final updatedMethods = state.paymentMethods
          .where((method) => method.id != methodId)
          .toList();

      state = state.copyWith(paymentMethods: updatedMethods);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to remove payment method: ${e.toString()}',
      );
      return false;
    }
  }

  /// Set default payment method
  /// TODO: Connect to backend API
  Future<void> setDefaultPaymentMethod(String methodId) async {
    try {
      // TODO: Update in backend API

      final method = state.paymentMethods.firstWhere((m) => m.id == methodId);
      state = state.copyWith(defaultPaymentMethod: method);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to set default payment method: ${e.toString()}',
      );
    }
  }

  /// Filter payments by status
  List<Payment> filterByStatus(String status) {
    if (status == 'all') return state.payments;

    return state.payments.where((payment) => payment.status == status).toList();
  }

  /// Filter payments by type
  List<Payment> filterByType(String type) {
    if (type == 'all') return state.payments;

    return state.payments.where((payment) => payment.itemType == type).toList();
  }

  /// Get payment statistics
  Map<String, dynamic> getPaymentStatistics() {
    double totalAmount = 0;
    double completedAmount = 0;
    int completedCount = 0;
    int pendingCount = 0;
    int failedCount = 0;

    for (final payment in state.payments) {
      totalAmount += payment.amount;

      if (payment.status == 'completed') {
        completedAmount += payment.amount;
        completedCount++;
      } else if (payment.status == 'pending') {
        pendingCount++;
      } else if (payment.status == 'failed') {
        failedCount++;
      }
    }

    return {
      'total': state.payments.length,
      'completed': completedCount,
      'pending': pendingCount,
      'failed': failedCount,
      'totalAmount': totalAmount,
      'completedAmount': completedAmount,
      'currency': state.payments.isNotEmpty ? state.payments.first.currency : 'USD',
    };
  }

  /// Get recent payments (last 7 days)
  List<Payment> getRecentPayments() {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    return state.payments.where((payment) {
      return payment.createdAt.isAfter(sevenDaysAgo);
    }).toList();
  }
}

/// Provider for payments state
final paymentsProvider = StateNotifierProvider<PaymentsNotifier, PaymentsState>((ref) {
  return PaymentsNotifier();
});

/// Provider for payments list
final paymentsListProvider = Provider<List<Payment>>((ref) {
  final paymentsState = ref.watch(paymentsProvider);
  return paymentsState.payments;
});

/// Provider for payment methods list
final paymentMethodsListProvider = Provider<List<PaymentMethod>>((ref) {
  final paymentsState = ref.watch(paymentsProvider);
  return paymentsState.paymentMethods;
});

/// Provider for default payment method
final defaultPaymentMethodProvider = Provider<PaymentMethod?>((ref) {
  final paymentsState = ref.watch(paymentsProvider);
  return paymentsState.defaultPaymentMethod;
});

/// Provider for payment statistics
final paymentStatisticsProvider = Provider<Map<String, dynamic>>((ref) {
  final notifier = ref.watch(paymentsProvider.notifier);
  return notifier.getPaymentStatistics();
});

/// Provider for recent payments
final recentPaymentsProvider = Provider<List<Payment>>((ref) {
  final notifier = ref.watch(paymentsProvider.notifier);
  return notifier.getRecentPayments();
});

/// Provider for checking if payments are loading
final paymentsLoadingProvider = Provider<bool>((ref) {
  final paymentsState = ref.watch(paymentsProvider);
  return paymentsState.isLoading;
});

/// Provider for payments error
final paymentsErrorProvider = Provider<String?>((ref) {
  final paymentsState = ref.watch(paymentsProvider);
  return paymentsState.error;
});

// Aliases for compatibility with screens
final paymentProvider = paymentsProvider;
final paymentLoadingProvider = paymentsLoadingProvider;
final paymentErrorProvider = paymentsErrorProvider;
final paymentHistoryListProvider = paymentsListProvider;

/// Provider for completed payments
final completedPaymentsProvider = Provider<List<Payment>>((ref) {
  final notifier = ref.watch(paymentsProvider.notifier);
  return notifier.filterByStatus('completed');
});

/// Provider for processing payments
final processingPaymentsProvider = Provider<List<Payment>>((ref) {
  final notifier = ref.watch(paymentsProvider.notifier);
  return notifier.filterByStatus('processing');
});

/// Provider for failed payments
final failedPaymentsProvider = Provider<List<Payment>>((ref) {
  final notifier = ref.watch(paymentsProvider.notifier);
  return notifier.filterByStatus('failed');
});
