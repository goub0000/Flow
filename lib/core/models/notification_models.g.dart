// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppNotificationImpl _$$AppNotificationImplFromJson(
        Map<String, dynamic> json) =>
    _$AppNotificationImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
      title: json['title'] as String,
      message: json['message'] as String,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      actionUrl: json['actionUrl'] as String?,
      isRead: json['isRead'] as bool? ?? false,
      isArchived: json['isArchived'] as bool? ?? false,
      priority: $enumDecodeNullable(
              _$NotificationPriorityEnumMap, json['priority']) ??
          NotificationPriority.normal,
      createdAt: DateTime.parse(json['createdAt'] as String),
      readAt: json['readAt'] == null
          ? null
          : DateTime.parse(json['readAt'] as String),
      archivedAt: json['archivedAt'] == null
          ? null
          : DateTime.parse(json['archivedAt'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
    );

Map<String, dynamic> _$$AppNotificationImplToJson(
        _$AppNotificationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'title': instance.title,
      'message': instance.message,
      'metadata': instance.metadata,
      'actionUrl': instance.actionUrl,
      'isRead': instance.isRead,
      'isArchived': instance.isArchived,
      'priority': _$NotificationPriorityEnumMap[instance.priority]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'readAt': instance.readAt?.toIso8601String(),
      'archivedAt': instance.archivedAt?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };

const _$NotificationTypeEnumMap = {
  NotificationType.applicationStatus: 'application_status',
  NotificationType.gradePosted: 'grade_posted',
  NotificationType.messageReceived: 'message_received',
  NotificationType.meetingScheduled: 'meeting_scheduled',
  NotificationType.meetingReminder: 'meeting_reminder',
  NotificationType.achievementEarned: 'achievement_earned',
  NotificationType.deadlineReminder: 'deadline_reminder',
  NotificationType.recommendationReady: 'recommendation_ready',
  NotificationType.systemAnnouncement: 'system_announcement',
  NotificationType.commentReceived: 'comment_received',
  NotificationType.mention: 'mention',
  NotificationType.eventReminder: 'event_reminder',
  NotificationType.approvalRequestNew: 'approval_request_new',
  NotificationType.approvalRequestActionNeeded:
      'approval_request_action_needed',
  NotificationType.approvalRequestStatusChanged:
      'approval_request_status_changed',
  NotificationType.approvalRequestEscalated: 'approval_request_escalated',
  NotificationType.approvalRequestExpiring: 'approval_request_expiring',
  NotificationType.approvalRequestComment: 'approval_request_comment',
};

const _$NotificationPriorityEnumMap = {
  NotificationPriority.normal: 0,
  NotificationPriority.high: 1,
  NotificationPriority.urgent: 2,
};

_$NotificationPreferenceImpl _$$NotificationPreferenceImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationPreferenceImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      notificationType:
          $enumDecode(_$NotificationTypeEnumMap, json['notificationType']),
      inAppEnabled: json['inAppEnabled'] as bool? ?? true,
      emailEnabled: json['emailEnabled'] as bool? ?? true,
      pushEnabled: json['pushEnabled'] as bool? ?? true,
      quietHoursStart: json['quietHoursStart'] as String?,
      quietHoursEnd: json['quietHoursEnd'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$NotificationPreferenceImplToJson(
        _$NotificationPreferenceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'notificationType': _$NotificationTypeEnumMap[instance.notificationType]!,
      'inAppEnabled': instance.inAppEnabled,
      'emailEnabled': instance.emailEnabled,
      'pushEnabled': instance.pushEnabled,
      'quietHoursStart': instance.quietHoursStart,
      'quietHoursEnd': instance.quietHoursEnd,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$CreateNotificationRequestImpl _$$CreateNotificationRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateNotificationRequestImpl(
      userId: json['userId'] as String,
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
      title: json['title'] as String,
      message: json['message'] as String,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      actionUrl: json['actionUrl'] as String?,
      priority: $enumDecodeNullable(
              _$NotificationPriorityEnumMap, json['priority']) ??
          NotificationPriority.normal,
    );

Map<String, dynamic> _$$CreateNotificationRequestImplToJson(
        _$CreateNotificationRequestImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'title': instance.title,
      'message': instance.message,
      'metadata': instance.metadata,
      'actionUrl': instance.actionUrl,
      'priority': _$NotificationPriorityEnumMap[instance.priority]!,
    };

_$UpdateNotificationPreferencesRequestImpl
    _$$UpdateNotificationPreferencesRequestImplFromJson(
            Map<String, dynamic> json) =>
        _$UpdateNotificationPreferencesRequestImpl(
          notificationType:
              $enumDecode(_$NotificationTypeEnumMap, json['notificationType']),
          inAppEnabled: json['inAppEnabled'] as bool?,
          emailEnabled: json['emailEnabled'] as bool?,
          pushEnabled: json['pushEnabled'] as bool?,
          quietHoursStart: json['quietHoursStart'] as String?,
          quietHoursEnd: json['quietHoursEnd'] as String?,
        );

Map<String, dynamic> _$$UpdateNotificationPreferencesRequestImplToJson(
        _$UpdateNotificationPreferencesRequestImpl instance) =>
    <String, dynamic>{
      'notificationType': _$NotificationTypeEnumMap[instance.notificationType]!,
      'inAppEnabled': instance.inAppEnabled,
      'emailEnabled': instance.emailEnabled,
      'pushEnabled': instance.pushEnabled,
      'quietHoursStart': instance.quietHoursStart,
      'quietHoursEnd': instance.quietHoursEnd,
    };

_$NotificationsResponseImpl _$$NotificationsResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationsResponseImpl(
      notifications: (json['notifications'] as List<dynamic>)
          .map((e) => AppNotification.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['totalCount'] as num).toInt(),
      unreadCount: (json['unreadCount'] as num).toInt(),
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 20,
      hasMore: json['hasMore'] as bool? ?? false,
    );

Map<String, dynamic> _$$NotificationsResponseImplToJson(
        _$NotificationsResponseImpl instance) =>
    <String, dynamic>{
      'notifications': instance.notifications,
      'totalCount': instance.totalCount,
      'unreadCount': instance.unreadCount,
      'page': instance.page,
      'limit': instance.limit,
      'hasMore': instance.hasMore,
    };

_$NotificationFilterImpl _$$NotificationFilterImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationFilterImpl(
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 20,
      isRead: json['isRead'] as bool?,
      isArchived: json['isArchived'] as bool?,
      types: (json['types'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$NotificationTypeEnumMap, e))
          .toList(),
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      priority:
          $enumDecodeNullable(_$NotificationPriorityEnumMap, json['priority']),
    );

Map<String, dynamic> _$$NotificationFilterImplToJson(
        _$NotificationFilterImpl instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'isRead': instance.isRead,
      'isArchived': instance.isArchived,
      'types':
          instance.types?.map((e) => _$NotificationTypeEnumMap[e]!).toList(),
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'priority': _$NotificationPriorityEnumMap[instance.priority],
    };
