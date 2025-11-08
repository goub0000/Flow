import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/payment_model.dart';
import '../widgets/custom_card.dart';
import '../widgets/loading_indicator.dart';
import '../providers/payment_provider.dart';
import 'payment_processing_screen.dart';

class PaymentMethodScreen extends ConsumerStatefulWidget {
  final String itemId;
  final String itemName;
  final String itemType;
  final double amount;
  final String currency;

  const PaymentMethodScreen({
    super.key,
    required this.itemId,
    required this.itemName,
    required this.itemType,
    required this.amount,
    required this.currency,
  });

  @override
  ConsumerState<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends ConsumerState<PaymentMethodScreen> {
  PaymentMethod? _selectedMethod;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(paymentProvider.notifier).fetchPaymentMethods();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLoading = ref.watch(paymentLoadingProvider);
    final error = ref.watch(paymentErrorProvider);
    final methods = ref.watch(paymentMethodsListProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          tooltip: 'Back',
        ),
        title: const Text('Select Payment Method'),
      ),
      body: error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(error, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(paymentProvider.notifier).fetchPaymentMethods();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : isLoading
              ? const LoadingIndicator(message: 'Loading payment methods...')
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Payment Summary Card
                      CustomCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Payment Summary',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _SummaryRow(
                              label: 'Item',
                              value: widget.itemName,
                            ),
                            const SizedBox(height: 12),
                            _SummaryRow(
                              label: 'Type',
                              value: _formatItemType(widget.itemType),
                            ),
                            const SizedBox(height: 12),
                            const Divider(),
                            const SizedBox(height: 12),
                            _SummaryRow(
                              label: 'Total Amount',
                              value: '${widget.currency} ${widget.amount.toStringAsFixed(2)}',
                              valueStyle: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Payment Methods
                      Text(
                        'Choose Payment Method',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),

                      ...methods.where((method) {
                        return method.isActive &&
                            method.supportedCurrencies.contains(widget.currency);
                      }).map((method) {
                        final isSelected = _selectedMethod?.id == method.id;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedMethod = method;
                              });
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.border,
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                color: isSelected
                                    ? AppColors.primary.withValues(alpha: 0.05)
                                    : Colors.transparent,
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  // Icon
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: AppColors.surface,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      method.icon,
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                  ),
                                  const SizedBox(width: 16),

                                  // Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          method.name,
                                          style: theme.textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        if (method.description != null) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            method.description!,
                                            style: theme.textTheme.bodySmall?.copyWith(
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),

                                  // Selection Indicator
                                  if (isSelected)
                                    const Icon(
                                      Icons.check_circle,
                                      color: AppColors.primary,
                                    )
                                  else
                                    Icon(
                                      Icons.circle_outlined,
                                      color: AppColors.border,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),

                      const SizedBox(height: 24),

                      // Security Notice
                      CustomCard(
                        color: AppColors.info.withValues(alpha: 0.1),
                        child: Row(
                          children: [
                            const Icon(Icons.lock, color: AppColors.info, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Your payment information is secure and encrypted',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.info,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Continue Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _selectedMethod != null ? _proceedToPayment : null,
                          child: Text(
                            'Continue to Payment',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  void _proceedToPayment() {
    if (_selectedMethod == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentProcessingScreen(
          itemId: widget.itemId,
          itemName: widget.itemName,
          itemType: widget.itemType,
          amount: widget.amount,
          currency: widget.currency,
          paymentMethod: _selectedMethod!,
        ),
      ),
    );
  }

  String _formatItemType(String type) {
    switch (type) {
      case 'course':
        return 'Course Enrollment';
      case 'program':
        return 'Program Application';
      case 'counseling_session':
        return 'Counseling Session';
      default:
        return type;
    }
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? valueStyle;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: valueStyle ??
              theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
