// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StudentActivity _$StudentActivityFromJson(Map<String, dynamic> json) {
  return _StudentActivity.fromJson(json);
}

/// @nodoc
mixin _$StudentActivity {
  String get id => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  StudentActivityType get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;
  String? get relatedEntityId => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  /// Serializes this StudentActivity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StudentActivity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StudentActivityCopyWith<StudentActivity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StudentActivityCopyWith<$Res> {
  factory $StudentActivityCopyWith(
    StudentActivity value,
    $Res Function(StudentActivity) then,
  ) = _$StudentActivityCopyWithImpl<$Res, StudentActivity>;
  @useResult
  $Res call({
    String id,
    DateTime timestamp,
    StudentActivityType type,
    String title,
    String description,
    String icon,
    String? relatedEntityId,
    Map<String, dynamic> metadata,
  });
}

/// @nodoc
class _$StudentActivityCopyWithImpl<$Res, $Val extends StudentActivity>
    implements $StudentActivityCopyWith<$Res> {
  _$StudentActivityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StudentActivity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? timestamp = null,
    Object? type = null,
    Object? title = null,
    Object? description = null,
    Object? icon = null,
    Object? relatedEntityId = freezed,
    Object? metadata = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as StudentActivityType,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            icon: null == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                      as String,
            relatedEntityId: freezed == relatedEntityId
                ? _value.relatedEntityId
                : relatedEntityId // ignore: cast_nullable_to_non_nullable
                      as String?,
            metadata: null == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StudentActivityImplCopyWith<$Res>
    implements $StudentActivityCopyWith<$Res> {
  factory _$$StudentActivityImplCopyWith(
    _$StudentActivityImpl value,
    $Res Function(_$StudentActivityImpl) then,
  ) = __$$StudentActivityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    DateTime timestamp,
    StudentActivityType type,
    String title,
    String description,
    String icon,
    String? relatedEntityId,
    Map<String, dynamic> metadata,
  });
}

/// @nodoc
class __$$StudentActivityImplCopyWithImpl<$Res>
    extends _$StudentActivityCopyWithImpl<$Res, _$StudentActivityImpl>
    implements _$$StudentActivityImplCopyWith<$Res> {
  __$$StudentActivityImplCopyWithImpl(
    _$StudentActivityImpl _value,
    $Res Function(_$StudentActivityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StudentActivity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? timestamp = null,
    Object? type = null,
    Object? title = null,
    Object? description = null,
    Object? icon = null,
    Object? relatedEntityId = freezed,
    Object? metadata = null,
  }) {
    return _then(
      _$StudentActivityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as StudentActivityType,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        icon: null == icon
            ? _value.icon
            : icon // ignore: cast_nullable_to_non_nullable
                  as String,
        relatedEntityId: freezed == relatedEntityId
            ? _value.relatedEntityId
            : relatedEntityId // ignore: cast_nullable_to_non_nullable
                  as String?,
        metadata: null == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StudentActivityImpl implements _StudentActivity {
  const _$StudentActivityImpl({
    required this.id,
    required this.timestamp,
    required this.type,
    required this.title,
    required this.description,
    required this.icon,
    this.relatedEntityId,
    final Map<String, dynamic> metadata = const {},
  }) : _metadata = metadata;

  factory _$StudentActivityImpl.fromJson(Map<String, dynamic> json) =>
      _$$StudentActivityImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime timestamp;
  @override
  final StudentActivityType type;
  @override
  final String title;
  @override
  final String description;
  @override
  final String icon;
  @override
  final String? relatedEntityId;
  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'StudentActivity(id: $id, timestamp: $timestamp, type: $type, title: $title, description: $description, icon: $icon, relatedEntityId: $relatedEntityId, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StudentActivityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.relatedEntityId, relatedEntityId) ||
                other.relatedEntityId == relatedEntityId) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    timestamp,
    type,
    title,
    description,
    icon,
    relatedEntityId,
    const DeepCollectionEquality().hash(_metadata),
  );

  /// Create a copy of StudentActivity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StudentActivityImplCopyWith<_$StudentActivityImpl> get copyWith =>
      __$$StudentActivityImplCopyWithImpl<_$StudentActivityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$StudentActivityImplToJson(this);
  }
}

abstract class _StudentActivity implements StudentActivity {
  const factory _StudentActivity({
    required final String id,
    required final DateTime timestamp,
    required final StudentActivityType type,
    required final String title,
    required final String description,
    required final String icon,
    final String? relatedEntityId,
    final Map<String, dynamic> metadata,
  }) = _$StudentActivityImpl;

  factory _StudentActivity.fromJson(Map<String, dynamic> json) =
      _$StudentActivityImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get timestamp;
  @override
  StudentActivityType get type;
  @override
  String get title;
  @override
  String get description;
  @override
  String get icon;
  @override
  String? get relatedEntityId;
  @override
  Map<String, dynamic> get metadata;

  /// Create a copy of StudentActivity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StudentActivityImplCopyWith<_$StudentActivityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StudentActivityFeedResponse _$StudentActivityFeedResponseFromJson(
  Map<String, dynamic> json,
) {
  return _StudentActivityFeedResponse.fromJson(json);
}

/// @nodoc
mixin _$StudentActivityFeedResponse {
  List<StudentActivity> get activities => throw _privateConstructorUsedError;
  int get totalCount => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;

  /// Serializes this StudentActivityFeedResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StudentActivityFeedResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StudentActivityFeedResponseCopyWith<StudentActivityFeedResponse>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StudentActivityFeedResponseCopyWith<$Res> {
  factory $StudentActivityFeedResponseCopyWith(
    StudentActivityFeedResponse value,
    $Res Function(StudentActivityFeedResponse) then,
  ) =
      _$StudentActivityFeedResponseCopyWithImpl<
        $Res,
        StudentActivityFeedResponse
      >;
  @useResult
  $Res call({
    List<StudentActivity> activities,
    int totalCount,
    int page,
    int limit,
    bool hasMore,
  });
}

/// @nodoc
class _$StudentActivityFeedResponseCopyWithImpl<
  $Res,
  $Val extends StudentActivityFeedResponse
>
    implements $StudentActivityFeedResponseCopyWith<$Res> {
  _$StudentActivityFeedResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StudentActivityFeedResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activities = null,
    Object? totalCount = null,
    Object? page = null,
    Object? limit = null,
    Object? hasMore = null,
  }) {
    return _then(
      _value.copyWith(
            activities: null == activities
                ? _value.activities
                : activities // ignore: cast_nullable_to_non_nullable
                      as List<StudentActivity>,
            totalCount: null == totalCount
                ? _value.totalCount
                : totalCount // ignore: cast_nullable_to_non_nullable
                      as int,
            page: null == page
                ? _value.page
                : page // ignore: cast_nullable_to_non_nullable
                      as int,
            limit: null == limit
                ? _value.limit
                : limit // ignore: cast_nullable_to_non_nullable
                      as int,
            hasMore: null == hasMore
                ? _value.hasMore
                : hasMore // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StudentActivityFeedResponseImplCopyWith<$Res>
    implements $StudentActivityFeedResponseCopyWith<$Res> {
  factory _$$StudentActivityFeedResponseImplCopyWith(
    _$StudentActivityFeedResponseImpl value,
    $Res Function(_$StudentActivityFeedResponseImpl) then,
  ) = __$$StudentActivityFeedResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<StudentActivity> activities,
    int totalCount,
    int page,
    int limit,
    bool hasMore,
  });
}

/// @nodoc
class __$$StudentActivityFeedResponseImplCopyWithImpl<$Res>
    extends
        _$StudentActivityFeedResponseCopyWithImpl<
          $Res,
          _$StudentActivityFeedResponseImpl
        >
    implements _$$StudentActivityFeedResponseImplCopyWith<$Res> {
  __$$StudentActivityFeedResponseImplCopyWithImpl(
    _$StudentActivityFeedResponseImpl _value,
    $Res Function(_$StudentActivityFeedResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StudentActivityFeedResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activities = null,
    Object? totalCount = null,
    Object? page = null,
    Object? limit = null,
    Object? hasMore = null,
  }) {
    return _then(
      _$StudentActivityFeedResponseImpl(
        activities: null == activities
            ? _value._activities
            : activities // ignore: cast_nullable_to_non_nullable
                  as List<StudentActivity>,
        totalCount: null == totalCount
            ? _value.totalCount
            : totalCount // ignore: cast_nullable_to_non_nullable
                  as int,
        page: null == page
            ? _value.page
            : page // ignore: cast_nullable_to_non_nullable
                  as int,
        limit: null == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int,
        hasMore: null == hasMore
            ? _value.hasMore
            : hasMore // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StudentActivityFeedResponseImpl
    implements _StudentActivityFeedResponse {
  const _$StudentActivityFeedResponseImpl({
    required final List<StudentActivity> activities,
    required this.totalCount,
    this.page = 1,
    this.limit = 10,
    this.hasMore = false,
  }) : _activities = activities;

  factory _$StudentActivityFeedResponseImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$StudentActivityFeedResponseImplFromJson(json);

  final List<StudentActivity> _activities;
  @override
  List<StudentActivity> get activities {
    if (_activities is EqualUnmodifiableListView) return _activities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activities);
  }

  @override
  final int totalCount;
  @override
  @JsonKey()
  final int page;
  @override
  @JsonKey()
  final int limit;
  @override
  @JsonKey()
  final bool hasMore;

  @override
  String toString() {
    return 'StudentActivityFeedResponse(activities: $activities, totalCount: $totalCount, page: $page, limit: $limit, hasMore: $hasMore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StudentActivityFeedResponseImpl &&
            const DeepCollectionEquality().equals(
              other._activities,
              _activities,
            ) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_activities),
    totalCount,
    page,
    limit,
    hasMore,
  );

  /// Create a copy of StudentActivityFeedResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StudentActivityFeedResponseImplCopyWith<_$StudentActivityFeedResponseImpl>
  get copyWith =>
      __$$StudentActivityFeedResponseImplCopyWithImpl<
        _$StudentActivityFeedResponseImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StudentActivityFeedResponseImplToJson(this);
  }
}

abstract class _StudentActivityFeedResponse
    implements StudentActivityFeedResponse {
  const factory _StudentActivityFeedResponse({
    required final List<StudentActivity> activities,
    required final int totalCount,
    final int page,
    final int limit,
    final bool hasMore,
  }) = _$StudentActivityFeedResponseImpl;

  factory _StudentActivityFeedResponse.fromJson(Map<String, dynamic> json) =
      _$StudentActivityFeedResponseImpl.fromJson;

  @override
  List<StudentActivity> get activities;
  @override
  int get totalCount;
  @override
  int get page;
  @override
  int get limit;
  @override
  bool get hasMore;

  /// Create a copy of StudentActivityFeedResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StudentActivityFeedResponseImplCopyWith<_$StudentActivityFeedResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}

StudentActivityFilterRequest _$StudentActivityFilterRequestFromJson(
  Map<String, dynamic> json,
) {
  return _StudentActivityFilterRequest.fromJson(json);
}

/// @nodoc
mixin _$StudentActivityFilterRequest {
  int get page => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  List<StudentActivityType>? get activityTypes =>
      throw _privateConstructorUsedError;
  DateTime? get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;

  /// Serializes this StudentActivityFilterRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StudentActivityFilterRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StudentActivityFilterRequestCopyWith<StudentActivityFilterRequest>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StudentActivityFilterRequestCopyWith<$Res> {
  factory $StudentActivityFilterRequestCopyWith(
    StudentActivityFilterRequest value,
    $Res Function(StudentActivityFilterRequest) then,
  ) =
      _$StudentActivityFilterRequestCopyWithImpl<
        $Res,
        StudentActivityFilterRequest
      >;
  @useResult
  $Res call({
    int page,
    int limit,
    List<StudentActivityType>? activityTypes,
    DateTime? startDate,
    DateTime? endDate,
  });
}

/// @nodoc
class _$StudentActivityFilterRequestCopyWithImpl<
  $Res,
  $Val extends StudentActivityFilterRequest
>
    implements $StudentActivityFilterRequestCopyWith<$Res> {
  _$StudentActivityFilterRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StudentActivityFilterRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? limit = null,
    Object? activityTypes = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
  }) {
    return _then(
      _value.copyWith(
            page: null == page
                ? _value.page
                : page // ignore: cast_nullable_to_non_nullable
                      as int,
            limit: null == limit
                ? _value.limit
                : limit // ignore: cast_nullable_to_non_nullable
                      as int,
            activityTypes: freezed == activityTypes
                ? _value.activityTypes
                : activityTypes // ignore: cast_nullable_to_non_nullable
                      as List<StudentActivityType>?,
            startDate: freezed == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            endDate: freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StudentActivityFilterRequestImplCopyWith<$Res>
    implements $StudentActivityFilterRequestCopyWith<$Res> {
  factory _$$StudentActivityFilterRequestImplCopyWith(
    _$StudentActivityFilterRequestImpl value,
    $Res Function(_$StudentActivityFilterRequestImpl) then,
  ) = __$$StudentActivityFilterRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int page,
    int limit,
    List<StudentActivityType>? activityTypes,
    DateTime? startDate,
    DateTime? endDate,
  });
}

/// @nodoc
class __$$StudentActivityFilterRequestImplCopyWithImpl<$Res>
    extends
        _$StudentActivityFilterRequestCopyWithImpl<
          $Res,
          _$StudentActivityFilterRequestImpl
        >
    implements _$$StudentActivityFilterRequestImplCopyWith<$Res> {
  __$$StudentActivityFilterRequestImplCopyWithImpl(
    _$StudentActivityFilterRequestImpl _value,
    $Res Function(_$StudentActivityFilterRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StudentActivityFilterRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? limit = null,
    Object? activityTypes = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
  }) {
    return _then(
      _$StudentActivityFilterRequestImpl(
        page: null == page
            ? _value.page
            : page // ignore: cast_nullable_to_non_nullable
                  as int,
        limit: null == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int,
        activityTypes: freezed == activityTypes
            ? _value._activityTypes
            : activityTypes // ignore: cast_nullable_to_non_nullable
                  as List<StudentActivityType>?,
        startDate: freezed == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        endDate: freezed == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StudentActivityFilterRequestImpl
    implements _StudentActivityFilterRequest {
  const _$StudentActivityFilterRequestImpl({
    this.page = 1,
    this.limit = 10,
    final List<StudentActivityType>? activityTypes,
    this.startDate,
    this.endDate,
  }) : _activityTypes = activityTypes;

  factory _$StudentActivityFilterRequestImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$StudentActivityFilterRequestImplFromJson(json);

  @override
  @JsonKey()
  final int page;
  @override
  @JsonKey()
  final int limit;
  final List<StudentActivityType>? _activityTypes;
  @override
  List<StudentActivityType>? get activityTypes {
    final value = _activityTypes;
    if (value == null) return null;
    if (_activityTypes is EqualUnmodifiableListView) return _activityTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime? startDate;
  @override
  final DateTime? endDate;

  @override
  String toString() {
    return 'StudentActivityFilterRequest(page: $page, limit: $limit, activityTypes: $activityTypes, startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StudentActivityFilterRequestImpl &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            const DeepCollectionEquality().equals(
              other._activityTypes,
              _activityTypes,
            ) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    page,
    limit,
    const DeepCollectionEquality().hash(_activityTypes),
    startDate,
    endDate,
  );

  /// Create a copy of StudentActivityFilterRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StudentActivityFilterRequestImplCopyWith<
    _$StudentActivityFilterRequestImpl
  >
  get copyWith =>
      __$$StudentActivityFilterRequestImplCopyWithImpl<
        _$StudentActivityFilterRequestImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StudentActivityFilterRequestImplToJson(this);
  }
}

abstract class _StudentActivityFilterRequest
    implements StudentActivityFilterRequest {
  const factory _StudentActivityFilterRequest({
    final int page,
    final int limit,
    final List<StudentActivityType>? activityTypes,
    final DateTime? startDate,
    final DateTime? endDate,
  }) = _$StudentActivityFilterRequestImpl;

  factory _StudentActivityFilterRequest.fromJson(Map<String, dynamic> json) =
      _$StudentActivityFilterRequestImpl.fromJson;

  @override
  int get page;
  @override
  int get limit;
  @override
  List<StudentActivityType>? get activityTypes;
  @override
  DateTime? get startDate;
  @override
  DateTime? get endDate;

  /// Create a copy of StudentActivityFilterRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StudentActivityFilterRequestImplCopyWith<
    _$StudentActivityFilterRequestImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
