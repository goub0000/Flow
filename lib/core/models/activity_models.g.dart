// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StudentActivityImpl _$$StudentActivityImplFromJson(
  Map<String, dynamic> json,
) => _$StudentActivityImpl(
  id: json['id'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
  type: $enumDecode(_$StudentActivityTypeEnumMap, json['type']),
  title: json['title'] as String,
  description: json['description'] as String,
  icon: json['icon'] as String,
  relatedEntityId: json['relatedEntityId'] as String?,
  metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$$StudentActivityImplToJson(
  _$StudentActivityImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'timestamp': instance.timestamp.toIso8601String(),
  'type': _$StudentActivityTypeEnumMap[instance.type]!,
  'title': instance.title,
  'description': instance.description,
  'icon': instance.icon,
  'relatedEntityId': instance.relatedEntityId,
  'metadata': instance.metadata,
};

const _$StudentActivityTypeEnumMap = {
  StudentActivityType.applicationSubmitted: 'application_submitted',
  StudentActivityType.applicationStatusChanged: 'application_status_changed',
  StudentActivityType.achievementEarned: 'achievement_earned',
  StudentActivityType.paymentMade: 'payment_made',
  StudentActivityType.messageReceived: 'message_received',
  StudentActivityType.courseCompleted: 'course_completed',
  StudentActivityType.meetingScheduled: 'meeting_scheduled',
  StudentActivityType.meetingCompleted: 'meeting_completed',
};

_$StudentActivityFeedResponseImpl _$$StudentActivityFeedResponseImplFromJson(
  Map<String, dynamic> json,
) => _$StudentActivityFeedResponseImpl(
  activities: (json['activities'] as List<dynamic>)
      .map((e) => StudentActivity.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalCount: (json['totalCount'] as num).toInt(),
  page: (json['page'] as num?)?.toInt() ?? 1,
  limit: (json['limit'] as num?)?.toInt() ?? 10,
  hasMore: json['hasMore'] as bool? ?? false,
);

Map<String, dynamic> _$$StudentActivityFeedResponseImplToJson(
  _$StudentActivityFeedResponseImpl instance,
) => <String, dynamic>{
  'activities': instance.activities,
  'totalCount': instance.totalCount,
  'page': instance.page,
  'limit': instance.limit,
  'hasMore': instance.hasMore,
};

_$StudentActivityFilterRequestImpl _$$StudentActivityFilterRequestImplFromJson(
  Map<String, dynamic> json,
) => _$StudentActivityFilterRequestImpl(
  page: (json['page'] as num?)?.toInt() ?? 1,
  limit: (json['limit'] as num?)?.toInt() ?? 10,
  activityTypes: (json['activityTypes'] as List<dynamic>?)
      ?.map((e) => $enumDecode(_$StudentActivityTypeEnumMap, e))
      .toList(),
  startDate: json['startDate'] == null
      ? null
      : DateTime.parse(json['startDate'] as String),
  endDate: json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String),
);

Map<String, dynamic> _$$StudentActivityFilterRequestImplToJson(
  _$StudentActivityFilterRequestImpl instance,
) => <String, dynamic>{
  'page': instance.page,
  'limit': instance.limit,
  'activityTypes': instance.activityTypes
      ?.map((e) => _$StudentActivityTypeEnumMap[e]!)
      .toList(),
  'startDate': instance.startDate?.toIso8601String(),
  'endDate': instance.endDate?.toIso8601String(),
};
