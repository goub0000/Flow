import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/payment_model.dart';
import '../widgets/custom_card.dart';
import 'payment_method_screen.dart';
import '../settings/contact_support_screen.dart';

class PaymentFailureScreen extends StatelessWidget {
  final Payment? payment;
  final String itemId;
  final String itemName;
  final String itemType;
  final double amount;
  final String currency;
  final String? errorMessage;

  const PaymentFailureScreen({
    super.key,
    this.payment,
    required this.itemId,
    required this.itemName,
    required this.itemType,
    required this.amount,
    required this.currency,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Failed'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 32),

            // Error Icon with Animation
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 600),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.error_outline,
                      color: AppColors.error,
                      size: 80,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Error Message
            Text(
              'Payment Failed',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage ?? 'We could not process your payment. Please try again.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Error Details Card (if payment object exists)
            if (payment != null) ...[
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transaction Details',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _DetailRow(
                      label: 'Transaction ID',
                      value: payment!.transactionId ?? 'N/A',
                    ),
                    const Divider(height: 24),
                    _DetailRow(
                      label: 'Reference',
                      value: payment!.reference ?? 'N/A',
                    ),
                    const Divider(height: 24),
                    _DetailRow(
                      label: 'Payment Method',
                      value: payment!.methodDisplayName,
                    ),
                    const Divider(height: 24),
                    _DetailRow(
                      label: 'Amount',
                      value: payment!.formattedAmount,
                    ),
                    if (payment!.failureReason != null) ...[
                      const Divider(height: 24),
                      _DetailRow(
                        label: 'Failure Reason',
                        value: payment!.failureReason!,
                        valueColor: AppColors.error,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Common Issues Card
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Common Issues',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _IssueItem(
                    icon: Icons.account_balance_wallet,
                    title: 'Insufficient Funds',
                    description: 'Ensure you have sufficient balance in your account',
                  ),
                  const SizedBox(height: 12),
                  _IssueItem(
                    icon: Icons.credit_card_off,
                    title: 'Card Declined',
                    description: 'Check with your bank or try a different card',
                  ),
                  const SizedBox(height: 12),
                  _IssueItem(
                    icon: Icons.signal_wifi_off,
                    title: 'Network Issues',
                    description: 'Ensure you have a stable internet connection',
                  ),
                  const SizedBox(height: 12),
                  _IssueItem(
                    icon: Icons.lock_outline,
                    title: 'Incorrect Details',
                    description: 'Verify your payment information is correct',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Help Notice
            CustomCard(
              color: AppColors.info.withValues(alpha: 0.1),
              child: Row(
                children: [
                  const Icon(Icons.help_outline, color: AppColors.info, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'If the problem persists, please contact support',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.info,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigate back to payment method selection to retry
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => PaymentMethodScreen(
                        itemId: itemId,
                        itemName: itemName,
                        itemType: itemType,
                        amount: amount,
                        currency: currency,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ContactSupportScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.support_agent),
                label: const Text('Contact Support'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: TextButton.icon(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                icon: const Icon(Icons.home),
                label: const Text('Back to Home'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 16),
        Flexible(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

class _IssueItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _IssueItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.error, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
