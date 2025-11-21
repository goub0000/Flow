// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_consent.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserConsentImpl _$$UserConsentImplFromJson(Map<String, dynamic> json) =>
    _$UserConsentImpl(
      userId: json['userId'] as String,
      status: $enumDecode(_$ConsentStatusEnumMap, json['status']),
      timestamp: DateTime.parse(json['timestamp'] as String),
      version: json['version'] as String,
      categoryConsents: (json['categoryConsents'] as Map<String, dynamic>).map(
        (k, e) => MapEntry($enumDecode(_$CookieCategoryEnumMap, k), e as bool),
      ),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      ipAddress: json['ipAddress'] as String?,
      userAgent: json['userAgent'] as String?,
      history: (json['history'] as List<dynamic>?)
              ?.map((e) =>
                  ConsentHistoryEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$UserConsentImplToJson(_$UserConsentImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'status': _$ConsentStatusEnumMap[instance.status]!,
      'timestamp': instance.timestamp.toIso8601String(),
      'version': instance.version,
      'categoryConsents': instance.categoryConsents
          .map((k, e) => MapEntry(_$CookieCategoryEnumMap[k]!, e)),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'ipAddress': instance.ipAddress,
      'userAgent': instance.userAgent,
      'history': instance.history,
    };

const _$ConsentStatusEnumMap = {
  ConsentStatus.notAsked: 'notAsked',
  ConsentStatus.accepted: 'accepted',
  ConsentStatus.customized: 'customized',
  ConsentStatus.declined: 'declined',
};

const _$CookieCategoryEnumMap = {
  CookieCategory.essential: 'essential',
  CookieCategory.functional: 'functional',
  CookieCategory.analytics: 'analytics',
  CookieCategory.marketing: 'marketing',
};

_$ConsentHistoryEntryImpl _$$ConsentHistoryEntryImplFromJson(
        Map<String, dynamic> json) =>
    _$ConsentHistoryEntryImpl(
      timestamp: DateTime.parse(json['timestamp'] as String),
      status: $enumDecode(_$ConsentStatusEnumMap, json['status']),
      categoryConsents: (json['categoryConsents'] as Map<String, dynamic>).map(
        (k, e) => MapEntry($enumDecode(_$CookieCategoryEnumMap, k), e as bool),
      ),
      action: json['action'] as String?,
      ipAddress: json['ipAddress'] as String?,
    );

Map<String, dynamic> _$$ConsentHistoryEntryImplToJson(
        _$ConsentHistoryEntryImpl instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp.toIso8601String(),
      'status': _$ConsentStatusEnumMap[instance.status]!,
      'categoryConsents': instance.categoryConsents
          .map((k, e) => MapEntry(_$CookieCategoryEnumMap[k]!, e)),
      'action': instance.action,
      'ipAddress': instance.ipAddress,
    };
