// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cookie_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CookieData _$CookieDataFromJson(Map<String, dynamic> json) {
  return _CookieData.fromJson(json);
}

/// @nodoc
mixin _$CookieData {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  CookieDataType get type => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  Map<String, dynamic> get data => throw _privateConstructorUsedError;
  bool get isAnonymized => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  String? get sessionId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CookieDataCopyWith<CookieData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CookieDataCopyWith<$Res> {
  factory $CookieDataCopyWith(
          CookieData value, $Res Function(CookieData) then) =
      _$CookieDataCopyWithImpl<$Res, CookieData>;
  @useResult
  $Res call(
      {String id,
      String userId,
      CookieDataType type,
      DateTime timestamp,
      Map<String, dynamic> data,
      bool isAnonymized,
      DateTime? expiresAt,
      String? sessionId});
}

/// @nodoc
class _$CookieDataCopyWithImpl<$Res, $Val extends CookieData>
    implements $CookieDataCopyWith<$Res> {
  _$CookieDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? timestamp = null,
    Object? data = null,
    Object? isAnonymized = null,
    Object? expiresAt = freezed,
    Object? sessionId = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as CookieDataType,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      isAnonymized: null == isAnonymized
          ? _value.isAnonymized
          : isAnonymized // ignore: cast_nullable_to_non_nullable
              as bool,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sessionId: freezed == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CookieDataImplCopyWith<$Res>
    implements $CookieDataCopyWith<$Res> {
  factory _$$CookieDataImplCopyWith(
          _$CookieDataImpl value, $Res Function(_$CookieDataImpl) then) =
      __$$CookieDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      CookieDataType type,
      DateTime timestamp,
      Map<String, dynamic> data,
      bool isAnonymized,
      DateTime? expiresAt,
      String? sessionId});
}

/// @nodoc
class __$$CookieDataImplCopyWithImpl<$Res>
    extends _$CookieDataCopyWithImpl<$Res, _$CookieDataImpl>
    implements _$$CookieDataImplCopyWith<$Res> {
  __$$CookieDataImplCopyWithImpl(
      _$CookieDataImpl _value, $Res Function(_$CookieDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? timestamp = null,
    Object? data = null,
    Object? isAnonymized = null,
    Object? expiresAt = freezed,
    Object? sessionId = freezed,
  }) {
    return _then(_$CookieDataImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as CookieDataType,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      isAnonymized: null == isAnonymized
          ? _value.isAnonymized
          : isAnonymized // ignore: cast_nullable_to_non_nullable
              as bool,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sessionId: freezed == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CookieDataImpl extends _CookieData {
  const _$CookieDataImpl(
      {required this.id,
      required this.userId,
      required this.type,
      required this.timestamp,
      required final Map<String, dynamic> data,
      this.isAnonymized = false,
      this.expiresAt,
      this.sessionId})
      : _data = data,
        super._();

  factory _$CookieDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$CookieDataImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final CookieDataType type;
  @override
  final DateTime timestamp;
  final Map<String, dynamic> _data;
  @override
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  @override
  @JsonKey()
  final bool isAnonymized;
  @override
  final DateTime? expiresAt;
  @override
  final String? sessionId;

  @override
  String toString() {
    return 'CookieData(id: $id, userId: $userId, type: $type, timestamp: $timestamp, data: $data, isAnonymized: $isAnonymized, expiresAt: $expiresAt, sessionId: $sessionId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CookieDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.isAnonymized, isAnonymized) ||
                other.isAnonymized == isAnonymized) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      type,
      timestamp,
      const DeepCollectionEquality().hash(_data),
      isAnonymized,
      expiresAt,
      sessionId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CookieDataImplCopyWith<_$CookieDataImpl> get copyWith =>
      __$$CookieDataImplCopyWithImpl<_$CookieDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CookieDataImplToJson(
      this,
    );
  }
}

abstract class _CookieData extends CookieData {
  const factory _CookieData(
      {required final String id,
      required final String userId,
      required final CookieDataType type,
      required final DateTime timestamp,
      required final Map<String, dynamic> data,
      final bool isAnonymized,
      final DateTime? expiresAt,
      final String? sessionId}) = _$CookieDataImpl;
  const _CookieData._() : super._();

  factory _CookieData.fromJson(Map<String, dynamic> json) =
      _$CookieDataImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  CookieDataType get type;
  @override
  DateTime get timestamp;
  @override
  Map<String, dynamic> get data;
  @override
  bool get isAnonymized;
  @override
  DateTime? get expiresAt;
  @override
  String? get sessionId;
  @override
  @JsonKey(ignore: true)
  _$$CookieDataImplCopyWith<_$CookieDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SessionAnalytics _$SessionAnalyticsFromJson(Map<String, dynamic> json) {
  return _SessionAnalytics.fromJson(json);
}

/// @nodoc
mixin _$SessionAnalytics {
  String get sessionId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime? get endTime => throw _privateConstructorUsedError;
  List<String> get pagesVisited => throw _privateConstructorUsedError;
  Map<String, int> get interactions => throw _privateConstructorUsedError;
  String? get deviceType => throw _privateConstructorUsedError;
  String? get browser => throw _privateConstructorUsedError;
  String? get referrer => throw _privateConstructorUsedError;
  int get totalDuration => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SessionAnalyticsCopyWith<SessionAnalytics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionAnalyticsCopyWith<$Res> {
  factory $SessionAnalyticsCopyWith(
          SessionAnalytics value, $Res Function(SessionAnalytics) then) =
      _$SessionAnalyticsCopyWithImpl<$Res, SessionAnalytics>;
  @useResult
  $Res call(
      {String sessionId,
      String userId,
      DateTime startTime,
      DateTime? endTime,
      List<String> pagesVisited,
      Map<String, int> interactions,
      String? deviceType,
      String? browser,
      String? referrer,
      int totalDuration});
}

/// @nodoc
class _$SessionAnalyticsCopyWithImpl<$Res, $Val extends SessionAnalytics>
    implements $SessionAnalyticsCopyWith<$Res> {
  _$SessionAnalyticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? userId = null,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? pagesVisited = null,
    Object? interactions = null,
    Object? deviceType = freezed,
    Object? browser = freezed,
    Object? referrer = freezed,
    Object? totalDuration = null,
  }) {
    return _then(_value.copyWith(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      pagesVisited: null == pagesVisited
          ? _value.pagesVisited
          : pagesVisited // ignore: cast_nullable_to_non_nullable
              as List<String>,
      interactions: null == interactions
          ? _value.interactions
          : interactions // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      deviceType: freezed == deviceType
          ? _value.deviceType
          : deviceType // ignore: cast_nullable_to_non_nullable
              as String?,
      browser: freezed == browser
          ? _value.browser
          : browser // ignore: cast_nullable_to_non_nullable
              as String?,
      referrer: freezed == referrer
          ? _value.referrer
          : referrer // ignore: cast_nullable_to_non_nullable
              as String?,
      totalDuration: null == totalDuration
          ? _value.totalDuration
          : totalDuration // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SessionAnalyticsImplCopyWith<$Res>
    implements $SessionAnalyticsCopyWith<$Res> {
  factory _$$SessionAnalyticsImplCopyWith(_$SessionAnalyticsImpl value,
          $Res Function(_$SessionAnalyticsImpl) then) =
      __$$SessionAnalyticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String sessionId,
      String userId,
      DateTime startTime,
      DateTime? endTime,
      List<String> pagesVisited,
      Map<String, int> interactions,
      String? deviceType,
      String? browser,
      String? referrer,
      int totalDuration});
}

/// @nodoc
class __$$SessionAnalyticsImplCopyWithImpl<$Res>
    extends _$SessionAnalyticsCopyWithImpl<$Res, _$SessionAnalyticsImpl>
    implements _$$SessionAnalyticsImplCopyWith<$Res> {
  __$$SessionAnalyticsImplCopyWithImpl(_$SessionAnalyticsImpl _value,
      $Res Function(_$SessionAnalyticsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? userId = null,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? pagesVisited = null,
    Object? interactions = null,
    Object? deviceType = freezed,
    Object? browser = freezed,
    Object? referrer = freezed,
    Object? totalDuration = null,
  }) {
    return _then(_$SessionAnalyticsImpl(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      pagesVisited: null == pagesVisited
          ? _value._pagesVisited
          : pagesVisited // ignore: cast_nullable_to_non_nullable
              as List<String>,
      interactions: null == interactions
          ? _value._interactions
          : interactions // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      deviceType: freezed == deviceType
          ? _value.deviceType
          : deviceType // ignore: cast_nullable_to_non_nullable
              as String?,
      browser: freezed == browser
          ? _value.browser
          : browser // ignore: cast_nullable_to_non_nullable
              as String?,
      referrer: freezed == referrer
          ? _value.referrer
          : referrer // ignore: cast_nullable_to_non_nullable
              as String?,
      totalDuration: null == totalDuration
          ? _value.totalDuration
          : totalDuration // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionAnalyticsImpl extends _SessionAnalytics {
  const _$SessionAnalyticsImpl(
      {required this.sessionId,
      required this.userId,
      required this.startTime,
      this.endTime,
      final List<String> pagesVisited = const [],
      final Map<String, int> interactions = const {},
      this.deviceType,
      this.browser,
      this.referrer,
      this.totalDuration = 0})
      : _pagesVisited = pagesVisited,
        _interactions = interactions,
        super._();

  factory _$SessionAnalyticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionAnalyticsImplFromJson(json);

  @override
  final String sessionId;
  @override
  final String userId;
  @override
  final DateTime startTime;
  @override
  final DateTime? endTime;
  final List<String> _pagesVisited;
  @override
  @JsonKey()
  List<String> get pagesVisited {
    if (_pagesVisited is EqualUnmodifiableListView) return _pagesVisited;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pagesVisited);
  }

  final Map<String, int> _interactions;
  @override
  @JsonKey()
  Map<String, int> get interactions {
    if (_interactions is EqualUnmodifiableMapView) return _interactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_interactions);
  }

  @override
  final String? deviceType;
  @override
  final String? browser;
  @override
  final String? referrer;
  @override
  @JsonKey()
  final int totalDuration;

  @override
  String toString() {
    return 'SessionAnalytics(sessionId: $sessionId, userId: $userId, startTime: $startTime, endTime: $endTime, pagesVisited: $pagesVisited, interactions: $interactions, deviceType: $deviceType, browser: $browser, referrer: $referrer, totalDuration: $totalDuration)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionAnalyticsImpl &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            const DeepCollectionEquality()
                .equals(other._pagesVisited, _pagesVisited) &&
            const DeepCollectionEquality()
                .equals(other._interactions, _interactions) &&
            (identical(other.deviceType, deviceType) ||
                other.deviceType == deviceType) &&
            (identical(other.browser, browser) || other.browser == browser) &&
            (identical(other.referrer, referrer) ||
                other.referrer == referrer) &&
            (identical(other.totalDuration, totalDuration) ||
                other.totalDuration == totalDuration));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      sessionId,
      userId,
      startTime,
      endTime,
      const DeepCollectionEquality().hash(_pagesVisited),
      const DeepCollectionEquality().hash(_interactions),
      deviceType,
      browser,
      referrer,
      totalDuration);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionAnalyticsImplCopyWith<_$SessionAnalyticsImpl> get copyWith =>
      __$$SessionAnalyticsImplCopyWithImpl<_$SessionAnalyticsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionAnalyticsImplToJson(
      this,
    );
  }
}

abstract class _SessionAnalytics extends SessionAnalytics {
  const factory _SessionAnalytics(
      {required final String sessionId,
      required final String userId,
      required final DateTime startTime,
      final DateTime? endTime,
      final List<String> pagesVisited,
      final Map<String, int> interactions,
      final String? deviceType,
      final String? browser,
      final String? referrer,
      final int totalDuration}) = _$SessionAnalyticsImpl;
  const _SessionAnalytics._() : super._();

  factory _SessionAnalytics.fromJson(Map<String, dynamic> json) =
      _$SessionAnalyticsImpl.fromJson;

  @override
  String get sessionId;
  @override
  String get userId;
  @override
  DateTime get startTime;
  @override
  DateTime? get endTime;
  @override
  List<String> get pagesVisited;
  @override
  Map<String, int> get interactions;
  @override
  String? get deviceType;
  @override
  String? get browser;
  @override
  String? get referrer;
  @override
  int get totalDuration;
  @override
  @JsonKey(ignore: true)
  _$$SessionAnalyticsImplCopyWith<_$SessionAnalyticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
