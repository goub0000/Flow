import 'package:flutter/material.dart';

/// Bulk Message Model
class BulkMessage {
  final String id;
  final String subject;
  final String content;
  final MessageRecipientGroup recipientGroup;
  final List<String> recipientIds;
  final MessagePriority priority;
  final MessageChannel channel;
  final DateTime? scheduledFor;
  final MessageStatus status;
  final DateTime createdAt;
  final int sentCount;
  final int failedCount;

  BulkMessage({
    required this.id,
    required this.subject,
    required this.content,
    required this.recipientGroup,
    this.recipientIds = const [],
    this.priority = MessagePriority.normal,
    this.channel = MessageChannel.inApp,
    this.scheduledFor,
    this.status = MessageStatus.draft,
    required this.createdAt,
    this.sentCount = 0,
    this.failedCount = 0,
  });
}

/// Message Recipient Group
enum MessageRecipientGroup {
  allUsers,
  students,
  institutions,
  parents,
  counselors,
  recommenders,
  custom,
}

/// Message Priority
enum MessagePriority {
  low,
  normal,
  high,
  urgent,
}

/// Message Channel
enum MessageChannel {
  inApp,
  email,
  push,
  sms,
  all,
}

/// Message Status
enum MessageStatus {
  draft,
  scheduled,
  sending,
  sent,
  failed,
  cancelled,
}

/// Message Template
class MessageTemplate {
  final String id;
  final String name;
  final String subject;
  final String content;
  final MessageCategory category;
  final List<String> variables;
  final IconData icon;

  MessageTemplate({
    required this.id,
    required this.name,
    required this.subject,
    required this.content,
    required this.category,
    this.variables = const [],
    required this.icon,
  });
}

/// Message Category
enum MessageCategory {
  announcement,
  reminder,
  notification,
  promotion,
  update,
}

/// Extension for recipient group
extension MessageRecipientGroupExtension on MessageRecipientGroup {
  String get label {
    switch (this) {
      case MessageRecipientGroup.allUsers:
        return 'All Users';
      case MessageRecipientGroup.students:
        return 'Students';
      case MessageRecipientGroup.institutions:
        return 'Institutions';
      case MessageRecipientGroup.parents:
        return 'Parents';
      case MessageRecipientGroup.counselors:
        return 'Counselors';
      case MessageRecipientGroup.recommenders:
        return 'Recommenders';
      case MessageRecipientGroup.custom:
        return 'Custom Selection';
    }
  }

  IconData get icon {
    switch (this) {
      case MessageRecipientGroup.allUsers:
        return Icons.group;
      case MessageRecipientGroup.students:
        return Icons.school;
      case MessageRecipientGroup.institutions:
        return Icons.business;
      case MessageRecipientGroup.parents:
        return Icons.family_restroom;
      case MessageRecipientGroup.counselors:
        return Icons.psychology;
      case MessageRecipientGroup.recommenders:
        return Icons.recommend;
      case MessageRecipientGroup.custom:
        return Icons.tune;
    }
  }
}

/// Extension for message priority
extension MessagePriorityExtension on MessagePriority {
  String get label {
    switch (this) {
      case MessagePriority.low:
        return 'Low';
      case MessagePriority.normal:
        return 'Normal';
      case MessagePriority.high:
        return 'High';
      case MessagePriority.urgent:
        return 'Urgent';
    }
  }

  Color get color {
    switch (this) {
      case MessagePriority.low:
        return Colors.grey;
      case MessagePriority.normal:
        return Colors.blue;
      case MessagePriority.high:
        return Colors.orange;
      case MessagePriority.urgent:
        return Colors.red;
    }
  }
}

/// Extension for message channel
extension MessageChannelExtension on MessageChannel {
  String get label {
    switch (this) {
      case MessageChannel.inApp:
        return 'In-App';
      case MessageChannel.email:
        return 'Email';
      case MessageChannel.push:
        return 'Push Notification';
      case MessageChannel.sms:
        return 'SMS';
      case MessageChannel.all:
        return 'All Channels';
    }
  }

  IconData get icon {
    switch (this) {
      case MessageChannel.inApp:
        return Icons.notifications;
      case MessageChannel.email:
        return Icons.email;
      case MessageChannel.push:
        return Icons.phone_iphone;
      case MessageChannel.sms:
        return Icons.sms;
      case MessageChannel.all:
        return Icons.campaign;
    }
  }
}

/// Extension for message status
extension MessageStatusExtension on MessageStatus {
  String get label {
    switch (this) {
      case MessageStatus.draft:
        return 'Draft';
      case MessageStatus.scheduled:
        return 'Scheduled';
      case MessageStatus.sending:
        return 'Sending';
      case MessageStatus.sent:
        return 'Sent';
      case MessageStatus.failed:
        return 'Failed';
      case MessageStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get color {
    switch (this) {
      case MessageStatus.draft:
        return Colors.grey;
      case MessageStatus.scheduled:
        return Colors.blue;
      case MessageStatus.sending:
        return Colors.orange;
      case MessageStatus.sent:
        return Colors.green;
      case MessageStatus.failed:
        return Colors.red;
      case MessageStatus.cancelled:
        return Colors.grey;
    }
  }
}

/// Extension for message category
extension MessageCategoryExtension on MessageCategory {
  String get label {
    switch (this) {
      case MessageCategory.announcement:
        return 'Announcement';
      case MessageCategory.reminder:
        return 'Reminder';
      case MessageCategory.notification:
        return 'Notification';
      case MessageCategory.promotion:
        return 'Promotion';
      case MessageCategory.update:
        return 'Update';
    }
  }
}
