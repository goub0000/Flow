class Payment {
  final String id;
  final String userId;
  final String itemId; // Course ID, Program ID, etc.
  final String itemName;
  final String itemType; // course, program, counseling_session
  final double amount;
  final String currency; // USD, KES, UGX, TZS, etc.
  final String method; // flutterwave, mpesa, card
  final String status; // pending, processing, completed, failed, refunded
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? transactionId;
  final String? reference;
  final Map<String, dynamic>? metadata;
  final String? failureReason;

  Payment({
    required this.id,
    required this.userId,
    required this.itemId,
    required this.itemName,
    required this.itemType,
    required this.amount,
    required this.currency,
    required this.method,
    required this.status,
    required this.createdAt,
    this.completedAt,
    this.transactionId,
    this.reference,
    this.metadata,
    this.failureReason,
  });

  bool get isPending => status == 'pending';
  bool get isProcessing => status == 'processing';
  bool get isCompleted => status == 'completed';
  bool get isFailed => status == 'failed';
  bool get isRefunded => status == 'refunded';

  String get formattedAmount => '$currency ${amount.toStringAsFixed(2)}';

  String get statusDisplayName {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'processing':
        return 'Processing';
      case 'completed':
        return 'Completed';
      case 'failed':
        return 'Failed';
      case 'refunded':
        return 'Refunded';
      default:
        return status;
    }
  }

  String get methodDisplayName {
    switch (method) {
      case 'flutterwave':
        return 'Flutterwave';
      case 'mpesa':
        return 'M-Pesa';
      case 'card':
        return 'Card';
      default:
        return method;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'itemId': itemId,
      'itemName': itemName,
      'itemType': itemType,
      'amount': amount,
      'currency': currency,
      'method': method,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'transactionId': transactionId,
      'reference': reference,
      'metadata': metadata,
      'failureReason': failureReason,
    };
  }

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] as String,
      userId: json['userId'] as String,
      itemId: json['itemId'] as String,
      itemName: json['itemName'] as String,
      itemType: json['itemType'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      method: json['method'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      transactionId: json['transactionId'] as String?,
      reference: json['reference'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      failureReason: json['failureReason'] as String?,
    );
  }

  /// Single mock payment for development
  static Payment mockPayment([int index = 0]) {
    final itemNames = ['Advanced Mathematics', 'Physics Fundamentals', 'Career Counseling Session', 'Computer Science BSc'];
    final itemTypes = ['course', 'course', 'counseling_session', 'program'];
    final amounts = [49.99, 39.99, 25.00, 5000.00];
    final methods = ['flutterwave', 'mpesa', 'card', 'flutterwave'];
    final statuses = ['completed', 'completed', 'failed', 'processing'];

    return Payment(
      id: 'pay${index + 1}',
      userId: 'user1',
      itemId: '${itemTypes[index % itemTypes.length]}${(index % 3) + 1}',
      itemName: itemNames[index % itemNames.length],
      itemType: itemTypes[index % itemTypes.length],
      amount: amounts[index % amounts.length],
      currency: 'USD',
      method: methods[index % methods.length],
      status: statuses[index % statuses.length],
      createdAt: DateTime.now().subtract(Duration(days: (index + 1) * 2)),
      completedAt: statuses[index % statuses.length] == 'completed'
          ? DateTime.now().subtract(Duration(days: (index + 1) * 2))
          : null,
      transactionId: statuses[index % statuses.length] == 'completed'
          ? 'TX-${index + 1}23456'
          : null,
      reference: 'REF-${index + 1}23456',
      failureReason: statuses[index % statuses.length] == 'failed'
          ? 'Insufficient funds'
          : null,
    );
  }

  static List<Payment> mockPayments({String? userId}) {
    return [
      Payment(
        id: 'pay1',
        userId: userId ?? 'user1',
        itemId: 'course1',
        itemName: 'Advanced Mathematics',
        itemType: 'course',
        amount: 49.99,
        currency: 'USD',
        method: 'flutterwave',
        status: 'completed',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        completedAt: DateTime.now().subtract(const Duration(days: 5)),
        transactionId: 'FLW-TX-123456',
        reference: 'REF-123456',
      ),
      Payment(
        id: 'pay2',
        userId: userId ?? 'user1',
        itemId: 'course2',
        itemName: 'Physics Fundamentals',
        itemType: 'course',
        amount: 39.99,
        currency: 'USD',
        method: 'mpesa',
        status: 'completed',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        completedAt: DateTime.now().subtract(const Duration(days: 10)),
        transactionId: 'MPESA-TX-789012',
        reference: 'REF-789012',
      ),
      Payment(
        id: 'pay3',
        userId: userId ?? 'user1',
        itemId: 'session1',
        itemName: 'Career Counseling Session',
        itemType: 'counseling_session',
        amount: 25.00,
        currency: 'USD',
        method: 'card',
        status: 'failed',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        reference: 'REF-345678',
      ),
      Payment(
        id: 'pay4',
        userId: userId ?? 'user1',
        itemId: 'program1',
        itemName: 'Computer Science BSc',
        itemType: 'program',
        amount: 5000.00,
        currency: 'USD',
        method: 'flutterwave',
        status: 'processing',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        reference: 'REF-901234',
      ),
    ];
  }
}

class PaymentMethod {
  final String id;
  final String name;
  final String type; // flutterwave, mpesa, card
  final String icon;
  final List<String> supportedCurrencies;
  final bool isActive;
  final String? description;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
    required this.supportedCurrencies,
    required this.isActive,
    this.description,
  });

  static List<PaymentMethod> availableMethods() {
    return [
      PaymentMethod(
        id: 'flutterwave',
        name: 'Flutterwave',
        type: 'flutterwave',
        icon: '💳',
        supportedCurrencies: ['USD', 'KES', 'UGX', 'TZS', 'GHS', 'NGN'],
        isActive: true,
        description: 'Pay with card, mobile money, or bank transfer',
      ),
      PaymentMethod(
        id: 'mpesa',
        name: 'M-Pesa',
        type: 'mpesa',
        icon: '📱',
        supportedCurrencies: ['KES'],
        isActive: true,
        description: 'Pay directly from your M-Pesa account',
      ),
      PaymentMethod(
        id: 'card',
        name: 'Credit/Debit Card',
        type: 'card',
        icon: '💳',
        supportedCurrencies: ['USD', 'EUR', 'GBP'],
        isActive: true,
        description: 'Pay with Visa, Mastercard, or American Express',
      ),
    ];
  }

  /// Mock card payment method
  static PaymentMethod mockCard() {
    return PaymentMethod(
      id: 'card',
      name: 'Credit/Debit Card',
      type: 'card',
      icon: '💳',
      supportedCurrencies: ['USD', 'EUR', 'GBP'],
      isActive: true,
      description: 'Pay with Visa, Mastercard, or American Express',
    );
  }

  /// Mock M-Pesa payment method
  static PaymentMethod mockMPesa() {
    return PaymentMethod(
      id: 'mpesa',
      name: 'M-Pesa',
      type: 'mpesa',
      icon: '📱',
      supportedCurrencies: ['KES'],
      isActive: true,
      description: 'Pay directly from your M-Pesa account',
    );
  }
}
