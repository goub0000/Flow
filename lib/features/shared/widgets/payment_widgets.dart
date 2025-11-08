import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';

/// Payment Widgets for Financial Transactions
///
/// Provides comprehensive payment UI components:
/// - Payment method cards
/// - Transaction tiles
/// - Payment status indicators
/// - Amount displays
/// - Payment form fields
///
/// Backend Integration TODO:
/// ```dart
/// // Payment processing with Stripe/PayPal/M-Pesa
/// import 'package:flutter_stripe/flutter_stripe.dart';
/// import 'package:dio/dio.dart';
///
/// class PaymentService {
///   final Dio _dio;
///
///   Future<PaymentIntent> createPaymentIntent({
///     required double amount,
///     required String currency,
///     String? customerId,
///   }) async {
///     final response = await _dio.post('/api/payments/create-intent', data: {
///       'amount': (amount * 100).toInt(), // Convert to cents
///       'currency': currency,
///       'customerId': customerId,
///     });
///     return PaymentIntent.fromJson(response.data);
///   }
///
///   Future<void> processPayment({
///     required String paymentMethodId,
///     required String paymentIntentId,
///   }) async {
///     await _dio.post('/api/payments/process', data: {
///       'paymentMethodId': paymentMethodId,
///       'paymentIntentId': paymentIntentId,
///     });
///   }
///
///   Future<List<Transaction>> getTransactionHistory({
///     int limit = 20,
///     String? startAfter,
///   }) async {
///     final response = await _dio.get('/api/payments/transactions', queryParameters: {
///       'limit': limit,
///       'startAfter': startAfter,
///     });
///     return (response.data['transactions'] as List)
///         .map((json) => Transaction.fromJson(json))
///         .toList();
///   }
/// }
/// ```

/// Payment Method Type
enum PaymentMethodType {
  card,
  mobileMoney,
  bankTransfer,
  paypal,
  stripe,
}

/// Payment Status
enum PaymentStatus {
  pending,
  processing,
  completed,
  failed,
  refunded,
  cancelled,
}

/// Transaction Type
enum TransactionType {
  payment,
  refund,
  withdrawal,
  deposit,
}

/// Payment Method Model
class PaymentMethod {
  final String id;
  final PaymentMethodType type;
  final String name;
  final String? last4;
  final String? brand;
  final String? expiryDate;
  final bool isDefault;
  final String? iconAsset;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.name,
    this.last4,
    this.brand,
    this.expiryDate,
    this.isDefault = false,
    this.iconAsset,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'],
      type: PaymentMethodType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => PaymentMethodType.card,
      ),
      name: json['name'],
      last4: json['last4'],
      brand: json['brand'],
      expiryDate: json['expiryDate'],
      isDefault: json['isDefault'] ?? false,
      iconAsset: json['iconAsset'],
    );
  }
}

/// Transaction Model
class Transaction {
  final String id;
  final TransactionType type;
  final PaymentStatus status;
  final double amount;
  final String currency;
  final String description;
  final DateTime createdAt;
  final String? paymentMethodId;
  final String? receiptUrl;
  final Map<String, dynamic>? metadata;

  Transaction({
    required this.id,
    required this.type,
    required this.status,
    required this.amount,
    required this.currency,
    required this.description,
    required this.createdAt,
    this.paymentMethodId,
    this.receiptUrl,
    this.metadata,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      type: TransactionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => TransactionType.payment,
      ),
      status: PaymentStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => PaymentStatus.pending,
      ),
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] ?? 'KES',
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      paymentMethodId: json['paymentMethodId'],
      receiptUrl: json['receiptUrl'],
      metadata: json['metadata'],
    );
  }

  String get formattedAmount {
    final symbol = _getCurrencySymbol(currency);
    return '$symbol${amount.toStringAsFixed(2)}';
  }

  String _getCurrencySymbol(String currency) {
    switch (currency.toUpperCase()) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'KES':
        return 'KSh ';
      default:
        return currency;
    }
  }
}

/// Payment Status Badge
class PaymentStatusBadge extends StatelessWidget {
  final PaymentStatus status;
  final bool showIcon;

  const PaymentStatusBadge({
    super.key,
    required this.status,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getStatusConfig();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: config['color'].withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: config['color'].withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(config['icon'], size: 14, color: config['color']),
            const SizedBox(width: 6),
          ],
          Text(
            config['label'],
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: config['color'],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getStatusConfig() {
    switch (status) {
      case PaymentStatus.pending:
        return {
          'label': 'Pending',
          'color': AppColors.warning,
          'icon': Icons.pending,
        };
      case PaymentStatus.processing:
        return {
          'label': 'Processing',
          'color': AppColors.info,
          'icon': Icons.sync,
        };
      case PaymentStatus.completed:
        return {
          'label': 'Completed',
          'color': AppColors.success,
          'icon': Icons.check_circle,
        };
      case PaymentStatus.failed:
        return {
          'label': 'Failed',
          'color': AppColors.error,
          'icon': Icons.error,
        };
      case PaymentStatus.refunded:
        return {
          'label': 'Refunded',
          'color': AppColors.textSecondary,
          'icon': Icons.undo,
        };
      case PaymentStatus.cancelled:
        return {
          'label': 'Cancelled',
          'color': AppColors.textSecondary,
          'icon': Icons.cancel,
        };
    }
  }
}

/// Payment Method Card Widget
class PaymentMethodCard extends StatelessWidget {
  final PaymentMethod method;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool isSelected;

  const PaymentMethodCard({
    super.key,
    required this.method,
    this.onTap,
    this.onDelete,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.05)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // Payment method icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getMethodColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getMethodIcon(),
                  color: _getMethodColor(),
                ),
              ),
              const SizedBox(width: 16),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            method.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (method.isDefault)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Default',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getMethodDetails(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Delete button
              if (onDelete != null) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  color: AppColors.error,
                  onPressed: onDelete,
                  tooltip: 'Remove payment method',
                ),
              ],

              // Selected indicator
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: AppColors.primary,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getMethodIcon() {
    switch (method.type) {
      case PaymentMethodType.card:
        return Icons.credit_card;
      case PaymentMethodType.mobileMoney:
        return Icons.phone_android;
      case PaymentMethodType.bankTransfer:
        return Icons.account_balance;
      case PaymentMethodType.paypal:
        return Icons.payments;
      case PaymentMethodType.stripe:
        return Icons.payment;
    }
  }

  Color _getMethodColor() {
    switch (method.type) {
      case PaymentMethodType.card:
        return AppColors.primary;
      case PaymentMethodType.mobileMoney:
        return AppColors.success;
      case PaymentMethodType.bankTransfer:
        return AppColors.info;
      case PaymentMethodType.paypal:
        return const Color(0xFF0070BA);
      case PaymentMethodType.stripe:
        return const Color(0xFF635BFF);
    }
  }

  String _getMethodDetails() {
    switch (method.type) {
      case PaymentMethodType.card:
        return '${method.brand ?? 'Card'} •••• ${method.last4 ?? '****'}';
      case PaymentMethodType.mobileMoney:
        return '••• ${method.last4 ?? '****'}';
      case PaymentMethodType.bankTransfer:
        return 'Bank Account •••• ${method.last4 ?? '****'}';
      case PaymentMethodType.paypal:
        return 'PayPal Account';
      case PaymentMethodType.stripe:
        return 'Stripe Payment';
    }
  }
}

/// Transaction Tile Widget
class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;

  const TransactionTile({
    super.key,
    required this.transaction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getTypeColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getTypeIcon(),
                  color: _getTypeColor(),
                ),
              ),
              const SizedBox(width: 16),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.description,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        PaymentStatusBadge(
                          status: transaction.status,
                          showIcon: false,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatDate(transaction.createdAt),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Amount
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _getFormattedAmount(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _getAmountColor(),
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (onTap != null)
                    const Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTypeIcon() {
    switch (transaction.type) {
      case TransactionType.payment:
        return Icons.arrow_upward;
      case TransactionType.refund:
        return Icons.undo;
      case TransactionType.withdrawal:
        return Icons.arrow_downward;
      case TransactionType.deposit:
        return Icons.add_circle;
    }
  }

  Color _getTypeColor() {
    switch (transaction.type) {
      case TransactionType.payment:
        return AppColors.error;
      case TransactionType.refund:
        return AppColors.warning;
      case TransactionType.withdrawal:
        return AppColors.error;
      case TransactionType.deposit:
        return AppColors.success;
    }
  }

  Color _getAmountColor() {
    switch (transaction.type) {
      case TransactionType.payment:
      case TransactionType.withdrawal:
        return AppColors.error;
      case TransactionType.refund:
      case TransactionType.deposit:
        return AppColors.success;
    }
  }

  String _getFormattedAmount() {
    final prefix = (transaction.type == TransactionType.payment ||
            transaction.type == TransactionType.withdrawal)
        ? '-'
        : '+';
    return '$prefix${transaction.formattedAmount}';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

/// Amount Display Widget
class AmountDisplay extends StatelessWidget {
  final double amount;
  final String currency;
  final String? label;
  final Color? color;
  final double fontSize;

  const AmountDisplay({
    super.key,
    required this.amount,
    this.currency = 'KES',
    this.label,
    this.color,
    this.fontSize = 32,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final symbol = _getCurrencySymbol(currency);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
        ],
        Text(
          '$symbol${amount.toStringAsFixed(2)}',
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
            color: color ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  String _getCurrencySymbol(String currency) {
    switch (currency.toUpperCase()) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'KES':
        return 'KSh ';
      default:
        return currency;
    }
  }
}

/// Card Number Input Field
class CardNumberField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const CardNumberField({
    super.key,
    required this.controller,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Card Number',
        hintText: '1234 5678 9012 3456',
        errorText: errorText,
        prefixIcon: const Icon(Icons.credit_card),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(16),
        _CardNumberInputFormatter(),
      ],
      onChanged: onChanged,
    );
  }
}

/// Card Expiry Input Field
class CardExpiryField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const CardExpiryField({
    super.key,
    required this.controller,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Expiry Date',
        hintText: 'MM/YY',
        errorText: errorText,
        prefixIcon: const Icon(Icons.calendar_today),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
        _CardExpiryInputFormatter(),
      ],
      onChanged: onChanged,
    );
  }
}

/// CVV Input Field
class CVVField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const CVVField({
    super.key,
    required this.controller,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'CVV',
        hintText: '123',
        errorText: errorText,
        prefixIcon: const Icon(Icons.lock),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      keyboardType: TextInputType.number,
      obscureText: true,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(3),
      ],
      onChanged: onChanged,
    );
  }
}

/// Card Number Input Formatter
class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      final nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' ');
      }
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Card Expiry Input Formatter
class _CardExpiryInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if (i == 1 && text.length > 2) {
        buffer.write('/');
      }
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
