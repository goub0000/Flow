/// Notification preferences model - Matches backend NotificationPreferencesResponse
class NotificationPreferences {
  final String id;
  final String userId;
  final bool emailEnabled;
  final bool pushEnabled;
  final bool smsEnabled;
  final bool inAppEnabled;
  final Map<String, bool> notificationTypes;
  final String? quietHoursStart; // Format: "HH:MM"
  final String? quietHoursEnd; // Format: "HH:MM"
  final DateTime createdAt;
  final DateTime updatedAt;

  const NotificationPreferences({
    required this.id,
    required this.userId,
    this.emailEnabled = true,
    this.pushEnabled = true,
    this.smsEnabled = false,
    this.inAppEnabled = true,
    this.notificationTypes = const {},
    this.quietHoursStart,
    this.quietHoursEnd,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      emailEnabled: json['email_enabled'] as bool? ?? true,
      pushEnabled: json['push_enabled'] as bool? ?? true,
      smsEnabled: json['sms_enabled'] as bool? ?? false,
      inAppEnabled: json['in_app_enabled'] as bool? ?? true,
      notificationTypes: (json['notification_types'] as Map<String, dynamic>?)
          ?.map((key, value) => MapEntry(key, value as bool)) ?? {},
      quietHoursStart: json['quiet_hours_start'] as String?,
      quietHoursEnd: json['quiet_hours_end'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'email_enabled': emailEnabled,
      'push_enabled': pushEnabled,
      'sms_enabled': smsEnabled,
      'in_app_enabled': inAppEnabled,
      'notification_types': notificationTypes,
      'quiet_hours_start': quietHoursStart,
      'quiet_hours_end': quietHoursEnd,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  NotificationPreferences copyWith({
    String? id,
    String? userId,
    bool? emailEnabled,
    bool? pushEnabled,
    bool? smsEnabled,
    bool? inAppEnabled,
    Map<String, bool>? notificationTypes,
    String? quietHoursStart,
    String? quietHoursEnd,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationPreferences(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      emailEnabled: emailEnabled ?? this.emailEnabled,
      pushEnabled: pushEnabled ?? this.pushEnabled,
      smsEnabled: smsEnabled ?? this.smsEnabled,
      inAppEnabled: inAppEnabled ?? this.inAppEnabled,
      notificationTypes: notificationTypes ?? this.notificationTypes,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Check if a specific notification type is enabled
  bool isTypeEnabled(String type) {
    return notificationTypes[type] ?? true; // Default to enabled if not specified
  }

  /// Create default preferences
  static NotificationPreferences createDefault(String userId) {
    final now = DateTime.now();
    return NotificationPreferences(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      emailEnabled: true,
      pushEnabled: true,
      smsEnabled: false,
      inAppEnabled: true,
      notificationTypes: const {},
      createdAt: now,
      updatedAt: now,
    );
  }
}

/// Notification preferences update request
class NotificationPreferencesUpdate {
  final bool? emailEnabled;
  final bool? pushEnabled;
  final bool? smsEnabled;
  final bool? inAppEnabled;
  final Map<String, bool>? notificationTypes;
  final String? quietHoursStart;
  final String? quietHoursEnd;

  const NotificationPreferencesUpdate({
    this.emailEnabled,
    this.pushEnabled,
    this.smsEnabled,
    this.inAppEnabled,
    this.notificationTypes,
    this.quietHoursStart,
    this.quietHoursEnd,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (emailEnabled != null) map['email_enabled'] = emailEnabled;
    if (pushEnabled != null) map['push_enabled'] = pushEnabled;
    if (smsEnabled != null) map['sms_enabled'] = smsEnabled;
    if (inAppEnabled != null) map['in_app_enabled'] = inAppEnabled;
    if (notificationTypes != null) map['notification_types'] = notificationTypes;
    if (quietHoursStart != null) map['quiet_hours_start'] = quietHoursStart;
    if (quietHoursEnd != null) map['quiet_hours_end'] = quietHoursEnd;
    return map;
  }
}
