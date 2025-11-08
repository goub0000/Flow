// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cookie_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CookieDataImpl _$$CookieDataImplFromJson(Map<String, dynamic> json) =>
    _$CookieDataImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: $enumDecode(_$CookieDataTypeEnumMap, json['type']),
      timestamp: DateTime.parse(json['timestamp'] as String),
      data: json['data'] as Map<String, dynamic>,
      isAnonymized: json['isAnonymized'] as bool? ?? false,
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      sessionId: json['sessionId'] as String?,
    );

Map<String, dynamic> _$$CookieDataImplToJson(_$CookieDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': _$CookieDataTypeEnumMap[instance.type]!,
      'timestamp': instance.timestamp.toIso8601String(),
      'data': instance.data,
      'isAnonymized': instance.isAnonymized,
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'sessionId': instance.sessionId,
    };

const _$CookieDataTypeEnumMap = {
  CookieDataType.authToken: 'authToken',
  CookieDataType.sessionId: 'sessionId',
  CookieDataType.userPreference: 'userPreference',
  CookieDataType.pageView: 'pageView',
  CookieDataType.clickEvent: 'clickEvent',
  CookieDataType.searchQuery: 'searchQuery',
  CookieDataType.deviceInfo: 'deviceInfo',
  CookieDataType.performanceMetric: 'performanceMetric',
  CookieDataType.recommendation: 'recommendation',
  CookieDataType.campaignTracking: 'campaignTracking',
};

_$SessionAnalyticsImpl _$$SessionAnalyticsImplFromJson(
  Map<String, dynamic> json,
) => _$SessionAnalyticsImpl(
  sessionId: json['sessionId'] as String,
  userId: json['userId'] as String,
  startTime: DateTime.parse(json['startTime'] as String),
  endTime: json['endTime'] == null
      ? null
      : DateTime.parse(json['endTime'] as String),
  pagesVisited:
      (json['pagesVisited'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  interactions:
      (json['interactions'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ) ??
      const {},
  deviceType: json['deviceType'] as String?,
  browser: json['browser'] as String?,
  referrer: json['referrer'] as String?,
  totalDuration: (json['totalDuration'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$SessionAnalyticsImplToJson(
  _$SessionAnalyticsImpl instance,
) => <String, dynamic>{
  'sessionId': instance.sessionId,
  'userId': instance.userId,
  'startTime': instance.startTime.toIso8601String(),
  'endTime': instance.endTime?.toIso8601String(),
  'pagesVisited': instance.pagesVisited,
  'interactions': instance.interactions,
  'deviceType': instance.deviceType,
  'browser': instance.browser,
  'referrer': instance.referrer,
  'totalDuration': instance.totalDuration,
};
