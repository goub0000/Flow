import 'package:flutter/material.dart';

/// Admin Notification Model
class AdminNotification {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final NotificationPriority priority;
  final DateTime timestamp;
  final bool isRead;
  final String? actionUrl;
  final Map<String, dynamic>? metadata;

  AdminNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.priority = NotificationPriority.normal,
    required this.timestamp,
    this.isRead = false,
    this.actionUrl,
    this.metadata,
  });

  AdminNotification copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    NotificationPriority? priority,
    DateTime? timestamp,
    bool? isRead,
    String? actionUrl,
    Map<String, dynamic>? metadata,
  }) {
    return AdminNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      actionUrl: actionUrl ?? this.actionUrl,
      metadata: metadata ?? this.metadata,
    );
  }

  IconData get icon {
    switch (type) {
      case NotificationType.userActivity:
        return Icons.person;
      case NotificationType.systemAlert:
        return Icons.warning;
      case NotificationType.security:
        return Icons.security;
      case NotificationType.payment:
        return Icons.payment;
      case NotificationType.content:
        return Icons.article;
      case NotificationType.support:
        return Icons.support_agent;
      case NotificationType.general:
        return Icons.notifications;
    }
  }

  Color get color {
    switch (priority) {
      case NotificationPriority.critical:
        return Colors.red;
      case NotificationPriority.high:
        return Colors.orange;
      case NotificationPriority.normal:
        return Colors.blue;
      case NotificationPriority.low:
        return Colors.grey;
    }
  }
}

/// Notification Type
enum NotificationType {
  userActivity,
  systemAlert,
  security,
  payment,
  content,
  support,
  general,
}

/// Notification Priority
enum NotificationPriority {
  critical,
  high,
  normal,
  low,
}

/// Extension for notification type
extension NotificationTypeExtension on NotificationType {
  String get label {
    switch (this) {
      case NotificationType.userActivity:
        return 'User Activity';
      case NotificationType.systemAlert:
        return 'System Alert';
      case NotificationType.security:
        return 'Security';
      case NotificationType.payment:
        return 'Payment';
      case NotificationType.content:
        return 'Content';
      case NotificationType.support:
        return 'Support';
      case NotificationType.general:
        return 'General';
    }
  }
}

/// Extension for notification priority
extension NotificationPriorityExtension on NotificationPriority {
  String get label {
    switch (this) {
      case NotificationPriority.critical:
        return 'Critical';
      case NotificationPriority.high:
        return 'High';
      case NotificationPriority.normal:
        return 'Normal';
      case NotificationPriority.low:
        return 'Low';
    }
  }
}
