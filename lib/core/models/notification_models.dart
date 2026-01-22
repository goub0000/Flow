import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_models.freezed.dart';
part 'notification_models.g.dart';

/// Notification type enum (matches database enum)
enum NotificationType {
  @JsonValue('application_status')
  applicationStatus,

  @JsonValue('grade_posted')
  gradePosted,

  @JsonValue('message_received')
  messageReceived,

  @JsonValue('meeting_scheduled')
  meetingScheduled,

  @JsonValue('meeting_reminder')
  meetingReminder,

  @JsonValue('achievement_earned')
  achievementEarned,

  @JsonValue('deadline_reminder')
  deadlineReminder,

  @JsonValue('recommendation_ready')
  recommendationReady,

  @JsonValue('system_announcement')
  systemAnnouncement,

  @JsonValue('comment_received')
  commentReceived,

  @JsonValue('mention')
  mention,

  @JsonValue('event_reminder')
  eventReminder,

  // Approval workflow notifications
  @JsonValue('approval_request_new')
  approvalRequestNew,

  @JsonValue('approval_request_action_needed')
  approvalRequestActionNeeded,

  @JsonValue('approval_request_status_changed')
  approvalRequestStatusChanged,

  @JsonValue('approval_request_escalated')
  approvalRequestEscalated,

  @JsonValue('approval_request_expiring')
  approvalRequestExpiring,

  @JsonValue('approval_request_comment')
  approvalRequestComment,
}

/// Notification priority
enum NotificationPriority {
  @JsonValue(0)
  normal,

  @JsonValue(1)
  high,

  @JsonValue(2)
  urgent,
}

/// Extension on NotificationType for display text and icons
extension NotificationTypeExtension on NotificationType {
  /// Get display text for notification type
  String get displayText {
    switch (this) {
      case NotificationType.applicationStatus:
        return 'Application Update';
      case NotificationType.gradePosted:
        return 'New Grade';
      case NotificationType.messageReceived:
        return 'New Message';
      case NotificationType.meetingScheduled:
        return 'Meeting Scheduled';
      case NotificationType.meetingReminder:
        return 'Meeting Reminder';
      case NotificationType.achievementEarned:
        return 'Achievement Earned';
      case NotificationType.deadlineReminder:
        return 'Deadline Reminder';
      case NotificationType.recommendationReady:
        return 'New Recommendation';
      case NotificationType.systemAnnouncement:
        return 'Announcement';
      case NotificationType.commentReceived:
        return 'New Comment';
      case NotificationType.mention:
        return 'You Were Mentioned';
      case NotificationType.eventReminder:
        return 'Event Reminder';
      case NotificationType.approvalRequestNew:
        return 'New Approval Request';
      case NotificationType.approvalRequestActionNeeded:
        return 'Action Required';
      case NotificationType.approvalRequestStatusChanged:
        return 'Request Status Update';
      case NotificationType.approvalRequestEscalated:
        return 'Request Escalated';
      case NotificationType.approvalRequestExpiring:
        return 'Request Expiring Soon';
      case NotificationType.approvalRequestComment:
        return 'New Comment on Request';
    }
  }

  /// Get icon name for notification type
  String get iconName {
    switch (this) {
      case NotificationType.applicationStatus:
        return 'school';
      case NotificationType.gradePosted:
        return 'grade';
      case NotificationType.messageReceived:
        return 'message';
      case NotificationType.meetingScheduled:
        return 'event';
      case NotificationType.meetingReminder:
        return 'alarm';
      case NotificationType.achievementEarned:
        return 'emoji_events';
      case NotificationType.deadlineReminder:
        return 'alarm';
      case NotificationType.recommendationReady:
        return 'lightbulb';
      case NotificationType.systemAnnouncement:
        return 'campaign';
      case NotificationType.commentReceived:
        return 'comment';
      case NotificationType.mention:
        return 'alternate_email';
      case NotificationType.eventReminder:
        return 'event_available';
      case NotificationType.approvalRequestNew:
        return 'assignment';
      case NotificationType.approvalRequestActionNeeded:
        return 'pending_actions';
      case NotificationType.approvalRequestStatusChanged:
        return 'update';
      case NotificationType.approvalRequestEscalated:
        return 'trending_up';
      case NotificationType.approvalRequestExpiring:
        return 'timer';
      case NotificationType.approvalRequestComment:
        return 'chat';
    }
  }

  /// Get color for notification type (Material color name)
  String get colorName {
    switch (this) {
      case NotificationType.applicationStatus:
        return 'blue';
      case NotificationType.gradePosted:
        return 'green';
      case NotificationType.messageReceived:
        return 'purple';
      case NotificationType.meetingScheduled:
        return 'orange';
      case NotificationType.meetingReminder:
        return 'orange';
      case NotificationType.achievementEarned:
        return 'amber';
      case NotificationType.deadlineReminder:
        return 'red';
      case NotificationType.recommendationReady:
        return 'teal';
      case NotificationType.systemAnnouncement:
        return 'indigo';
      case NotificationType.commentReceived:
        return 'purple';
      case NotificationType.mention:
        return 'pink';
      case NotificationType.eventReminder:
        return 'cyan';
      case NotificationType.approvalRequestNew:
        return 'blue';
      case NotificationType.approvalRequestActionNeeded:
        return 'orange';
      case NotificationType.approvalRequestStatusChanged:
        return 'teal';
      case NotificationType.approvalRequestEscalated:
        return 'purple';
      case NotificationType.approvalRequestExpiring:
        return 'red';
      case NotificationType.approvalRequestComment:
        return 'indigo';
    }
  }

  /// Check if this notification type should show a badge
  bool get showsBadge {
    switch (this) {
      case NotificationType.messageReceived:
      case NotificationType.gradePosted:
      case NotificationType.applicationStatus:
      case NotificationType.achievementEarned:
      case NotificationType.commentReceived:
      case NotificationType.mention:
      case NotificationType.approvalRequestNew:
      case NotificationType.approvalRequestActionNeeded:
      case NotificationType.approvalRequestEscalated:
        return true;
      default:
        return false;
    }
  }
}

/// App notification model
/// Using "AppNotification" to avoid conflict with system Notification class
@freezed
class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String id,
    required String userId,
    required NotificationType type,
    required String title,
    required String message,
    @Default({}) Map<String, dynamic> metadata,
    String? actionUrl,
    @Default(false) bool isRead,
    @Default(false) bool isArchived,
    @Default(NotificationPriority.normal) NotificationPriority priority,
    required DateTime createdAt,
    DateTime? readAt,
    DateTime? archivedAt,
    DateTime? deletedAt,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);
}

/// Extension on AppNotification for helper methods
extension AppNotificationExtension on AppNotification {
  /// Check if notification is unread
  bool get isUnread => !isRead;

  /// Check if notification is active (not archived or deleted)
  bool get isActive => !isArchived && deletedAt == null;

  /// Get time ago string (e.g., "2 hours ago")
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year${difference.inDays > 730 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month${difference.inDays > 60 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  /// Get formatted date string
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays == 0) {
      return 'Today at ${_formatTime(createdAt)}';
    } else if (difference.inDays == 1) {
      return 'Yesterday at ${_formatTime(createdAt)}';
    } else if (difference.inDays < 7) {
      return '${_getDayName(createdAt.weekday)} at ${_formatTime(createdAt)}';
    } else {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year} at ${_formatTime(createdAt)}';
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }
}

/// Notification preference model
@freezed
class NotificationPreference with _$NotificationPreference {
  const factory NotificationPreference({
    required String id,
    required String userId,
    required NotificationType notificationType,
    @Default(true) bool inAppEnabled,
    @Default(true) bool emailEnabled,
    @Default(true) bool pushEnabled,
    String? quietHoursStart,
    String? quietHoursEnd,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _NotificationPreference;

  factory NotificationPreference.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferenceFromJson(json);
}

/// Request model for creating a notification
@freezed
class CreateNotificationRequest with _$CreateNotificationRequest {
  const factory CreateNotificationRequest({
    required String userId,
    required NotificationType type,
    required String title,
    required String message,
    @Default({}) Map<String, dynamic> metadata,
    String? actionUrl,
    @Default(NotificationPriority.normal) NotificationPriority priority,
  }) = _CreateNotificationRequest;

  factory CreateNotificationRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateNotificationRequestFromJson(json);
}

/// Request model for updating notification preferences
@freezed
class UpdateNotificationPreferencesRequest
    with _$UpdateNotificationPreferencesRequest {
  const factory UpdateNotificationPreferencesRequest({
    required NotificationType notificationType,
    bool? inAppEnabled,
    bool? emailEnabled,
    bool? pushEnabled,
    String? quietHoursStart,
    String? quietHoursEnd,
  }) = _UpdateNotificationPreferencesRequest;

  factory UpdateNotificationPreferencesRequest.fromJson(
          Map<String, dynamic> json) =>
      _$UpdateNotificationPreferencesRequestFromJson(json);
}

/// Response model for notifications list
@freezed
class NotificationsResponse with _$NotificationsResponse {
  const factory NotificationsResponse({
    required List<AppNotification> notifications,
    required int totalCount,
    required int unreadCount,
    @Default(1) int page,
    @Default(20) int limit,
    @Default(false) bool hasMore,
  }) = _NotificationsResponse;

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationsResponseFromJson(json);
}

/// Filter model for querying notifications
@freezed
class NotificationFilter with _$NotificationFilter {
  const factory NotificationFilter({
    @Default(1) int page,
    @Default(20) int limit,
    bool? isRead,
    bool? isArchived,
    List<NotificationType>? types,
    DateTime? startDate,
    DateTime? endDate,
    NotificationPriority? priority,
  }) = _NotificationFilter;

  factory NotificationFilter.fromJson(Map<String, dynamic> json) =>
      _$NotificationFilterFromJson(json);
}
