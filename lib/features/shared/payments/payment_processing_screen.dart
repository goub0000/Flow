import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/payment_model.dart';
import '../widgets/custom_card.dart';
import 'payment_success_screen.dart';
import 'payment_failure_screen.dart';

class PaymentProcessingScreen extends StatefulWidget {
  final String itemId;
  final String itemName;
  final String itemType;
  final double amount;
  final String currency;
  final PaymentMethod paymentMethod;

  const PaymentProcessingScreen({
    super.key,
    required this.itemId,
    required this.itemName,
    required this.itemType,
    required this.amount,
    required this.currency,
    required this.paymentMethod,
  });

  @override
  State<PaymentProcessingScreen> createState() =>
      _PaymentProcessingScreenState();
}

class _PaymentProcessingScreenState extends State<PaymentProcessingScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  // Form controllers for different payment methods
  final _phoneController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardNameController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cardNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Pay with ${widget.paymentMethod.name}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Amount Card
              CustomCard(
                color: AppColors.primary.withValues(alpha: 0.1),
                child: Column(
                  children: [
                    Text(
                      'Amount to Pay',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.currency} ${widget.amount.toStringAsFixed(2)}',
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.itemName,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Payment Method Specific Form
              if (widget.paymentMethod.type == 'mpesa')
                _buildMpesaForm()
              else if (widget.paymentMethod.type == 'card')
                _buildCardForm()
              else
                _buildFlutterwaveForm(),

              const SizedBox(height: 24),

              // Security Notice
              CustomCard(
                color: AppColors.info.withValues(alpha: 0.1),
                child: Row(
                  children: [
                    const Icon(Icons.security, color: AppColors.info, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your payment is secured with end-to-end encryption',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.info,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Pay Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isProcessing ? null : _processPayment,
                  icon: _isProcessing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.payment),
                  label: Text(
                    _isProcessing
                        ? 'Processing...'
                        : 'Pay ${widget.currency} ${widget.amount.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMpesaForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'M-Pesa Payment',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(
            labelText: 'M-Pesa Phone Number',
            hintText: '254712345678',
            prefixIcon: Icon(Icons.phone),
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your M-Pesa phone number';
            }
            if (!RegExp(r'^254[0-9]{9}$').hasMatch(value)) {
              return 'Please enter a valid Kenyan phone number (254...)';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        CustomCard(
          color: AppColors.warning.withValues(alpha: 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.info, color: AppColors.warning, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    'How to pay',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.warning,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildInfoStep(
                  '1', 'You will receive an M-Pesa prompt on your phone'),
              const SizedBox(height: 8),
              _buildInfoStep('2', 'Enter your M-Pesa PIN to confirm payment'),
              const SizedBox(height: 8),
              _buildInfoStep('3', 'Wait for confirmation SMS'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCardForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Card Details',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _cardNameController,
          decoration: const InputDecoration(
            labelText: 'Cardholder Name',
            hintText: 'JOHN DOE',
            prefixIcon: Icon(Icons.person),
            border: OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.characters,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter cardholder name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _cardNumberController,
          decoration: const InputDecoration(
            labelText: 'Card Number',
            hintText: '1234 5678 9012 3456',
            prefixIcon: Icon(Icons.credit_card),
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(16),
            _CardNumberFormatter(),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter card number';
            }
            final digitsOnly = value.replaceAll(' ', '');
            if (digitsOnly.length < 13 || digitsOnly.length > 19) {
              return 'Please enter a valid card number';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _expiryController,
                decoration: const InputDecoration(
                  labelText: 'Expiry Date',
                  hintText: 'MM/YY',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                  _ExpiryDateFormatter(),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  if (!RegExp(r'^(0[1-9]|1[0-2])/[0-9]{2}$').hasMatch(value)) {
                    return 'Invalid format';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _cvvController,
                decoration: const InputDecoration(
                  labelText: 'CVV',
                  hintText: '123',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  if (value.length < 3) {
                    return 'Invalid CVV';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFlutterwaveForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Flutterwave Payment',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment Options',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              _buildPaymentOption(Icons.credit_card, 'Card Payment',
                  'Pay with debit or credit card'),
              const Divider(height: 24),
              _buildPaymentOption(Icons.phone_android, 'Mobile Money',
                  'Pay with mobile money (M-Pesa, Airtel, etc.)'),
              const Divider(height: 24),
              _buildPaymentOption(Icons.account_balance, 'Bank Transfer',
                  'Direct bank transfer'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        CustomCard(
          color: AppColors.info.withValues(alpha: 0.1),
          child: Row(
            children: [
              const Icon(Icons.info, color: AppColors.info, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'You will be redirected to Flutterwave secure payment page',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.info,
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOption(IconData icon, String title, String description) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoStep(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: AppColors.warning,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  Future<void> _processPayment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isProcessing = true);

    // TODO: Integrate with actual payment gateway
    // For M-Pesa: Call Daraja API with phone number from _phoneController
    // Example: await mpesaService.initiateSTKPush(phoneNumber: _phoneController.text, amount: widget.amount)
    //
    // For Flutterwave: Initialize Flutterwave transaction
    // Example: await flutterwaveService.initializePayment(amount: widget.amount, currency: widget.currency)
    //
    // For Card: Process card payment via payment gateway
    // Example: await cardService.processPayment(cardNumber: _cardNumberController.text, ...)
    //
    // Replace mock delay below with actual API calls
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      setState(() => _isProcessing = false);

      // TODO: Replace with actual payment response from backend
      // For demo purposes, simulate 80% success rate
      final bool paymentSuccessful = DateTime.now().millisecond % 10 < 8;

      if (paymentSuccessful) {
        // Simulate successful payment
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentSuccessScreen(
              payment: Payment(
                id: 'pay_${DateTime.now().millisecondsSinceEpoch}',
                userId: 'user1',
                itemId: widget.itemId,
                itemName: widget.itemName,
                itemType: widget.itemType,
                amount: widget.amount,
                currency: widget.currency,
                method: widget.paymentMethod.type,
                status: 'completed',
                createdAt: DateTime.now(),
                completedAt: DateTime.now(),
                transactionId:
                    '${widget.paymentMethod.type.toUpperCase()}-${DateTime.now().millisecondsSinceEpoch}',
                reference: 'REF-${DateTime.now().millisecondsSinceEpoch}',
              ),
            ),
          ),
        );
      } else {
        // Simulate payment failure
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentFailureScreen(
              itemId: widget.itemId,
              itemName: widget.itemName,
              itemType: widget.itemType,
              amount: widget.amount,
              currency: widget.currency,
              errorMessage: 'Transaction was declined. Please check your payment details and try again.',
              payment: Payment(
                id: 'pay_${DateTime.now().millisecondsSinceEpoch}',
                userId: 'user1',
                itemId: widget.itemId,
                itemName: widget.itemName,
                itemType: widget.itemType,
                amount: widget.amount,
                currency: widget.currency,
                method: widget.paymentMethod.type,
                status: 'failed',
                createdAt: DateTime.now(),
                transactionId:
                    '${widget.paymentMethod.type.toUpperCase()}-${DateTime.now().millisecondsSinceEpoch}',
                reference: 'REF-${DateTime.now().millisecondsSinceEpoch}',
                failureReason: 'Transaction declined by payment gateway',
              ),
            ),
          ),
        );
      }
    }
  }
}

// Custom input formatter for card number
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i + 1 != text.length) {
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

// Custom input formatter for expiry date
class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll('/', '');

    if (text.length <= 2) {
      return newValue.copyWith(text: text);
    }

    final formatted = '${text.substring(0, 2)}/${text.substring(2)}';
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
