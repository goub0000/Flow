/// Notification model - Matches backend schema from notifications_api.py
class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String body;
  final String notificationType; // system, application_status, enrollment, etc.
  final String priority; // low, normal, high, urgent
  final List<String> channels; // in_app, push, email, sms
  final String? actionUrl; // Deep link or URL
  final String? actionText; // Button text
  final String? imageUrl;
  final bool isRead;
  final DateTime? readAt;
  final bool isDelivered;
  final DateTime? deliveredAt;
  final Map<String, dynamic>? metadata;
  final DateTime? expiresAt;
  final DateTime? scheduledFor;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Legacy field for backward compatibility
  String get type => notificationType;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.notificationType,
    this.priority = 'normal',
    this.channels = const ['in_app'],
    this.actionUrl,
    this.actionText,
    this.imageUrl,
    this.isRead = false,
    this.readAt,
    this.isDelivered = false,
    this.deliveredAt,
    this.metadata,
    this.expiresAt,
    this.scheduledFor,
    required this.createdAt,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? createdAt;

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      body: json['message'] as String? ?? json['body'] as String? ?? '',
      notificationType: json['notification_type'] as String? ?? json['type'] as String? ?? 'system',
      priority: json['priority'] as String? ?? 'normal',
      channels: (json['channels'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const ['in_app'],
      actionUrl: json['action_url'] as String?,
      actionText: json['action_text'] as String?,
      imageUrl: json['image_url'] as String?,
      isRead: json['is_read'] as bool? ?? false,
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at'] as String) : null,
      isDelivered: json['is_delivered'] as bool? ?? false,
      deliveredAt: json['delivered_at'] != null ? DateTime.parse(json['delivered_at'] as String) : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
      expiresAt: json['expires_at'] != null ? DateTime.parse(json['expires_at'] as String) : null,
      scheduledFor: json['scheduled_for'] != null ? DateTime.parse(json['scheduled_for'] as String) : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'message': body,
      'notification_type': notificationType,
      'priority': priority,
      'channels': channels,
      'action_url': actionUrl,
      'action_text': actionText,
      'image_url': imageUrl,
      'is_read': isRead,
      'read_at': readAt?.toIso8601String(),
      'is_delivered': isDelivered,
      'delivered_at': deliveredAt?.toIso8601String(),
      'metadata': metadata,
      'expires_at': expiresAt?.toIso8601String(),
      'scheduled_for': scheduledFor?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  NotificationModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? body,
    String? notificationType,
    String? priority,
    List<String>? channels,
    String? actionUrl,
    String? actionText,
    String? imageUrl,
    bool? isRead,
    DateTime? readAt,
    bool? isDelivered,
    DateTime? deliveredAt,
    Map<String, dynamic>? metadata,
    DateTime? expiresAt,
    DateTime? scheduledFor,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      notificationType: notificationType ?? this.notificationType,
      priority: priority ?? this.priority,
      channels: channels ?? this.channels,
      actionUrl: actionUrl ?? this.actionUrl,
      actionText: actionText ?? this.actionText,
      imageUrl: imageUrl ?? this.imageUrl,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      isDelivered: isDelivered ?? this.isDelivered,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      metadata: metadata ?? this.metadata,
      expiresAt: expiresAt ?? this.expiresAt,
      scheduledFor: scheduledFor ?? this.scheduledFor,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Mock notifications for development
  static List<NotificationModel> mockNotifications() {
    final now = DateTime.now();
    return [
      NotificationModel(
        id: '1',
        userId: 'user1',
        title: 'Application Accepted',
        body: 'Your application to University of Ghana has been accepted!',
        notificationType: 'application_status',
        priority: 'high',
        channels: const ['in_app', 'push', 'email'],
        actionUrl: '/student/applications/1',
        actionText: 'View Application',
        isRead: false,
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      NotificationModel(
        id: '2',
        userId: 'user1',
        title: 'New Course Available',
        body: 'Data Science course is now available for enrollment',
        notificationType: 'course_update',
        priority: 'normal',
        channels: const ['in_app'],
        actionUrl: '/find-your-path',
        actionText: 'Browse Courses',
        isRead: false,
        createdAt: now.subtract(const Duration(hours: 5)),
      ),
      NotificationModel(
        id: '3',
        userId: 'user1',
        title: 'Payment Successful',
        body: 'Your payment of \$50 has been processed successfully',
        notificationType: 'payment',
        priority: 'normal',
        channels: const ['in_app', 'email'],
        actionUrl: '/student/payments',
        actionText: 'View Receipt',
        isRead: true,
        readAt: now.subtract(const Duration(hours: 18)),
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      NotificationModel(
        id: '4',
        userId: 'user1',
        title: 'Application Under Review',
        body: 'Your application is currently being reviewed',
        notificationType: 'application_status',
        priority: 'normal',
        channels: const ['in_app'],
        isRead: true,
        readAt: now.subtract(const Duration(days: 1, hours: 12)),
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      NotificationModel(
        id: '5',
        userId: 'user1',
        title: 'Deadline Reminder',
        body: 'Application deadline for Makerere University is in 7 days',
        notificationType: 'deadline_reminder',
        priority: 'urgent',
        channels: const ['in_app', 'push'],
        actionUrl: '/student/applications/new',
        actionText: 'Apply Now',
        isRead: true,
        readAt: now.subtract(const Duration(days: 2, hours: 6)),
        createdAt: now.subtract(const Duration(days: 3)),
      ),
    ];
  }

  /// Single mock notification for development
  static NotificationModel mockNotification([int index = 0]) {
    final now = DateTime.now();
    final titles = [
      'Application Accepted',
      'New Course Available',
      'Payment Successful',
      'Application Under Review',
      'Deadline Reminder',
    ];
    final bodies = [
      'Your application to University of Ghana has been accepted!',
      'Data Science course is now available for enrollment',
      'Your payment of \$50 has been processed successfully',
      'Your application is currently being reviewed',
      'Application deadline for Makerere University is in 7 days',
    ];
    final types = ['application_status', 'course_update', 'payment', 'application_status', 'deadline_reminder'];
    final priorities = ['high', 'normal', 'normal', 'normal', 'urgent'];

    return NotificationModel(
      id: '${index + 1}',
      userId: 'user1',
      title: titles[index % titles.length],
      body: bodies[index % bodies.length],
      notificationType: types[index % types.length],
      priority: priorities[index % priorities.length],
      isRead: index % 3 == 0,
      readAt: index % 3 == 0 ? now.subtract(Duration(hours: (index + 1) * 3)) : null,
      createdAt: now.subtract(Duration(hours: (index + 1) * 2)),
    );
  }
}
