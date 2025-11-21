// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) {
  return _AppNotification.fromJson(json);
}

/// @nodoc
mixin _$AppNotification {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  NotificationType get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;
  String? get actionUrl => throw _privateConstructorUsedError;
  bool get isRead => throw _privateConstructorUsedError;
  bool get isArchived => throw _privateConstructorUsedError;
  NotificationPriority get priority => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get readAt => throw _privateConstructorUsedError;
  DateTime? get archivedAt => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AppNotificationCopyWith<AppNotification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppNotificationCopyWith<$Res> {
  factory $AppNotificationCopyWith(
          AppNotification value, $Res Function(AppNotification) then) =
      _$AppNotificationCopyWithImpl<$Res, AppNotification>;
  @useResult
  $Res call(
      {String id,
      String userId,
      NotificationType type,
      String title,
      String message,
      Map<String, dynamic> metadata,
      String? actionUrl,
      bool isRead,
      bool isArchived,
      NotificationPriority priority,
      DateTime createdAt,
      DateTime? readAt,
      DateTime? archivedAt,
      DateTime? deletedAt});
}

/// @nodoc
class _$AppNotificationCopyWithImpl<$Res, $Val extends AppNotification>
    implements $AppNotificationCopyWith<$Res> {
  _$AppNotificationCopyWithImpl(this._value, this._then);

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
    Object? title = null,
    Object? message = null,
    Object? metadata = null,
    Object? actionUrl = freezed,
    Object? isRead = null,
    Object? isArchived = null,
    Object? priority = null,
    Object? createdAt = null,
    Object? readAt = freezed,
    Object? archivedAt = freezed,
    Object? deletedAt = freezed,
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
              as NotificationType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      actionUrl: freezed == actionUrl
          ? _value.actionUrl
          : actionUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      isArchived: null == isArchived
          ? _value.isArchived
          : isArchived // ignore: cast_nullable_to_non_nullable
              as bool,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as NotificationPriority,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      archivedAt: freezed == archivedAt
          ? _value.archivedAt
          : archivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppNotificationImplCopyWith<$Res>
    implements $AppNotificationCopyWith<$Res> {
  factory _$$AppNotificationImplCopyWith(_$AppNotificationImpl value,
          $Res Function(_$AppNotificationImpl) then) =
      __$$AppNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      NotificationType type,
      String title,
      String message,
      Map<String, dynamic> metadata,
      String? actionUrl,
      bool isRead,
      bool isArchived,
      NotificationPriority priority,
      DateTime createdAt,
      DateTime? readAt,
      DateTime? archivedAt,
      DateTime? deletedAt});
}

/// @nodoc
class __$$AppNotificationImplCopyWithImpl<$Res>
    extends _$AppNotificationCopyWithImpl<$Res, _$AppNotificationImpl>
    implements _$$AppNotificationImplCopyWith<$Res> {
  __$$AppNotificationImplCopyWithImpl(
      _$AppNotificationImpl _value, $Res Function(_$AppNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? title = null,
    Object? message = null,
    Object? metadata = null,
    Object? actionUrl = freezed,
    Object? isRead = null,
    Object? isArchived = null,
    Object? priority = null,
    Object? createdAt = null,
    Object? readAt = freezed,
    Object? archivedAt = freezed,
    Object? deletedAt = freezed,
  }) {
    return _then(_$AppNotificationImpl(
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
              as NotificationType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      actionUrl: freezed == actionUrl
          ? _value.actionUrl
          : actionUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      isArchived: null == isArchived
          ? _value.isArchived
          : isArchived // ignore: cast_nullable_to_non_nullable
              as bool,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as NotificationPriority,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      archivedAt: freezed == archivedAt
          ? _value.archivedAt
          : archivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppNotificationImpl implements _AppNotification {
  const _$AppNotificationImpl(
      {required this.id,
      required this.userId,
      required this.type,
      required this.title,
      required this.message,
      final Map<String, dynamic> metadata = const {},
      this.actionUrl,
      this.isRead = false,
      this.isArchived = false,
      this.priority = NotificationPriority.normal,
      required this.createdAt,
      this.readAt,
      this.archivedAt,
      this.deletedAt})
      : _metadata = metadata;

  factory _$AppNotificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppNotificationImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final NotificationType type;
  @override
  final String title;
  @override
  final String message;
  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  final String? actionUrl;
  @override
  @JsonKey()
  final bool isRead;
  @override
  @JsonKey()
  final bool isArchived;
  @override
  @JsonKey()
  final NotificationPriority priority;
  @override
  final DateTime createdAt;
  @override
  final DateTime? readAt;
  @override
  final DateTime? archivedAt;
  @override
  final DateTime? deletedAt;

  @override
  String toString() {
    return 'AppNotification(id: $id, userId: $userId, type: $type, title: $title, message: $message, metadata: $metadata, actionUrl: $actionUrl, isRead: $isRead, isArchived: $isArchived, priority: $priority, createdAt: $createdAt, readAt: $readAt, archivedAt: $archivedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppNotificationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.actionUrl, actionUrl) ||
                other.actionUrl == actionUrl) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.isArchived, isArchived) ||
                other.isArchived == isArchived) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.readAt, readAt) || other.readAt == readAt) &&
            (identical(other.archivedAt, archivedAt) ||
                other.archivedAt == archivedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      type,
      title,
      message,
      const DeepCollectionEquality().hash(_metadata),
      actionUrl,
      isRead,
      isArchived,
      priority,
      createdAt,
      readAt,
      archivedAt,
      deletedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppNotificationImplCopyWith<_$AppNotificationImpl> get copyWith =>
      __$$AppNotificationImplCopyWithImpl<_$AppNotificationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppNotificationImplToJson(
      this,
    );
  }
}

abstract class _AppNotification implements AppNotification {
  const factory _AppNotification(
      {required final String id,
      required final String userId,
      required final NotificationType type,
      required final String title,
      required final String message,
      final Map<String, dynamic> metadata,
      final String? actionUrl,
      final bool isRead,
      final bool isArchived,
      final NotificationPriority priority,
      required final DateTime createdAt,
      final DateTime? readAt,
      final DateTime? archivedAt,
      final DateTime? deletedAt}) = _$AppNotificationImpl;

  factory _AppNotification.fromJson(Map<String, dynamic> json) =
      _$AppNotificationImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  NotificationType get type;
  @override
  String get title;
  @override
  String get message;
  @override
  Map<String, dynamic> get metadata;
  @override
  String? get actionUrl;
  @override
  bool get isRead;
  @override
  bool get isArchived;
  @override
  NotificationPriority get priority;
  @override
  DateTime get createdAt;
  @override
  DateTime? get readAt;
  @override
  DateTime? get archivedAt;
  @override
  DateTime? get deletedAt;
  @override
  @JsonKey(ignore: true)
  _$$AppNotificationImplCopyWith<_$AppNotificationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NotificationPreference _$NotificationPreferenceFromJson(
    Map<String, dynamic> json) {
  return _NotificationPreference.fromJson(json);
}

/// @nodoc
mixin _$NotificationPreference {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  NotificationType get notificationType => throw _privateConstructorUsedError;
  bool get inAppEnabled => throw _privateConstructorUsedError;
  bool get emailEnabled => throw _privateConstructorUsedError;
  bool get pushEnabled => throw _privateConstructorUsedError;
  String? get quietHoursStart => throw _privateConstructorUsedError;
  String? get quietHoursEnd => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NotificationPreferenceCopyWith<NotificationPreference> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationPreferenceCopyWith<$Res> {
  factory $NotificationPreferenceCopyWith(NotificationPreference value,
          $Res Function(NotificationPreference) then) =
      _$NotificationPreferenceCopyWithImpl<$Res, NotificationPreference>;
  @useResult
  $Res call(
      {String id,
      String userId,
      NotificationType notificationType,
      bool inAppEnabled,
      bool emailEnabled,
      bool pushEnabled,
      String? quietHoursStart,
      String? quietHoursEnd,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$NotificationPreferenceCopyWithImpl<$Res,
        $Val extends NotificationPreference>
    implements $NotificationPreferenceCopyWith<$Res> {
  _$NotificationPreferenceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? notificationType = null,
    Object? inAppEnabled = null,
    Object? emailEnabled = null,
    Object? pushEnabled = null,
    Object? quietHoursStart = freezed,
    Object? quietHoursEnd = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
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
      notificationType: null == notificationType
          ? _value.notificationType
          : notificationType // ignore: cast_nullable_to_non_nullable
              as NotificationType,
      inAppEnabled: null == inAppEnabled
          ? _value.inAppEnabled
          : inAppEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      emailEnabled: null == emailEnabled
          ? _value.emailEnabled
          : emailEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      pushEnabled: null == pushEnabled
          ? _value.pushEnabled
          : pushEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      quietHoursStart: freezed == quietHoursStart
          ? _value.quietHoursStart
          : quietHoursStart // ignore: cast_nullable_to_non_nullable
              as String?,
      quietHoursEnd: freezed == quietHoursEnd
          ? _value.quietHoursEnd
          : quietHoursEnd // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationPreferenceImplCopyWith<$Res>
    implements $NotificationPreferenceCopyWith<$Res> {
  factory _$$NotificationPreferenceImplCopyWith(
          _$NotificationPreferenceImpl value,
          $Res Function(_$NotificationPreferenceImpl) then) =
      __$$NotificationPreferenceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      NotificationType notificationType,
      bool inAppEnabled,
      bool emailEnabled,
      bool pushEnabled,
      String? quietHoursStart,
      String? quietHoursEnd,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$NotificationPreferenceImplCopyWithImpl<$Res>
    extends _$NotificationPreferenceCopyWithImpl<$Res,
        _$NotificationPreferenceImpl>
    implements _$$NotificationPreferenceImplCopyWith<$Res> {
  __$$NotificationPreferenceImplCopyWithImpl(
      _$NotificationPreferenceImpl _value,
      $Res Function(_$NotificationPreferenceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? notificationType = null,
    Object? inAppEnabled = null,
    Object? emailEnabled = null,
    Object? pushEnabled = null,
    Object? quietHoursStart = freezed,
    Object? quietHoursEnd = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$NotificationPreferenceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      notificationType: null == notificationType
          ? _value.notificationType
          : notificationType // ignore: cast_nullable_to_non_nullable
              as NotificationType,
      inAppEnabled: null == inAppEnabled
          ? _value.inAppEnabled
          : inAppEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      emailEnabled: null == emailEnabled
          ? _value.emailEnabled
          : emailEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      pushEnabled: null == pushEnabled
          ? _value.pushEnabled
          : pushEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      quietHoursStart: freezed == quietHoursStart
          ? _value.quietHoursStart
          : quietHoursStart // ignore: cast_nullable_to_non_nullable
              as String?,
      quietHoursEnd: freezed == quietHoursEnd
          ? _value.quietHoursEnd
          : quietHoursEnd // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationPreferenceImpl implements _NotificationPreference {
  const _$NotificationPreferenceImpl(
      {required this.id,
      required this.userId,
      required this.notificationType,
      this.inAppEnabled = true,
      this.emailEnabled = true,
      this.pushEnabled = true,
      this.quietHoursStart,
      this.quietHoursEnd,
      required this.createdAt,
      required this.updatedAt});

  factory _$NotificationPreferenceImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationPreferenceImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final NotificationType notificationType;
  @override
  @JsonKey()
  final bool inAppEnabled;
  @override
  @JsonKey()
  final bool emailEnabled;
  @override
  @JsonKey()
  final bool pushEnabled;
  @override
  final String? quietHoursStart;
  @override
  final String? quietHoursEnd;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'NotificationPreference(id: $id, userId: $userId, notificationType: $notificationType, inAppEnabled: $inAppEnabled, emailEnabled: $emailEnabled, pushEnabled: $pushEnabled, quietHoursStart: $quietHoursStart, quietHoursEnd: $quietHoursEnd, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationPreferenceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.notificationType, notificationType) ||
                other.notificationType == notificationType) &&
            (identical(other.inAppEnabled, inAppEnabled) ||
                other.inAppEnabled == inAppEnabled) &&
            (identical(other.emailEnabled, emailEnabled) ||
                other.emailEnabled == emailEnabled) &&
            (identical(other.pushEnabled, pushEnabled) ||
                other.pushEnabled == pushEnabled) &&
            (identical(other.quietHoursStart, quietHoursStart) ||
                other.quietHoursStart == quietHoursStart) &&
            (identical(other.quietHoursEnd, quietHoursEnd) ||
                other.quietHoursEnd == quietHoursEnd) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      notificationType,
      inAppEnabled,
      emailEnabled,
      pushEnabled,
      quietHoursStart,
      quietHoursEnd,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationPreferenceImplCopyWith<_$NotificationPreferenceImpl>
      get copyWith => __$$NotificationPreferenceImplCopyWithImpl<
          _$NotificationPreferenceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationPreferenceImplToJson(
      this,
    );
  }
}

abstract class _NotificationPreference implements NotificationPreference {
  const factory _NotificationPreference(
      {required final String id,
      required final String userId,
      required final NotificationType notificationType,
      final bool inAppEnabled,
      final bool emailEnabled,
      final bool pushEnabled,
      final String? quietHoursStart,
      final String? quietHoursEnd,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$NotificationPreferenceImpl;

  factory _NotificationPreference.fromJson(Map<String, dynamic> json) =
      _$NotificationPreferenceImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  NotificationType get notificationType;
  @override
  bool get inAppEnabled;
  @override
  bool get emailEnabled;
  @override
  bool get pushEnabled;
  @override
  String? get quietHoursStart;
  @override
  String? get quietHoursEnd;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$NotificationPreferenceImplCopyWith<_$NotificationPreferenceImpl>
      get copyWith => throw _privateConstructorUsedError;
}

CreateNotificationRequest _$CreateNotificationRequestFromJson(
    Map<String, dynamic> json) {
  return _CreateNotificationRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateNotificationRequest {
  String get userId => throw _privateConstructorUsedError;
  NotificationType get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;
  String? get actionUrl => throw _privateConstructorUsedError;
  NotificationPriority get priority => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CreateNotificationRequestCopyWith<CreateNotificationRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateNotificationRequestCopyWith<$Res> {
  factory $CreateNotificationRequestCopyWith(CreateNotificationRequest value,
          $Res Function(CreateNotificationRequest) then) =
      _$CreateNotificationRequestCopyWithImpl<$Res, CreateNotificationRequest>;
  @useResult
  $Res call(
      {String userId,
      NotificationType type,
      String title,
      String message,
      Map<String, dynamic> metadata,
      String? actionUrl,
      NotificationPriority priority});
}

/// @nodoc
class _$CreateNotificationRequestCopyWithImpl<$Res,
        $Val extends CreateNotificationRequest>
    implements $CreateNotificationRequestCopyWith<$Res> {
  _$CreateNotificationRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? type = null,
    Object? title = null,
    Object? message = null,
    Object? metadata = null,
    Object? actionUrl = freezed,
    Object? priority = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as NotificationType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      actionUrl: freezed == actionUrl
          ? _value.actionUrl
          : actionUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as NotificationPriority,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateNotificationRequestImplCopyWith<$Res>
    implements $CreateNotificationRequestCopyWith<$Res> {
  factory _$$CreateNotificationRequestImplCopyWith(
          _$CreateNotificationRequestImpl value,
          $Res Function(_$CreateNotificationRequestImpl) then) =
      __$$CreateNotificationRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      NotificationType type,
      String title,
      String message,
      Map<String, dynamic> metadata,
      String? actionUrl,
      NotificationPriority priority});
}

/// @nodoc
class __$$CreateNotificationRequestImplCopyWithImpl<$Res>
    extends _$CreateNotificationRequestCopyWithImpl<$Res,
        _$CreateNotificationRequestImpl>
    implements _$$CreateNotificationRequestImplCopyWith<$Res> {
  __$$CreateNotificationRequestImplCopyWithImpl(
      _$CreateNotificationRequestImpl _value,
      $Res Function(_$CreateNotificationRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? type = null,
    Object? title = null,
    Object? message = null,
    Object? metadata = null,
    Object? actionUrl = freezed,
    Object? priority = null,
  }) {
    return _then(_$CreateNotificationRequestImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as NotificationType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      actionUrl: freezed == actionUrl
          ? _value.actionUrl
          : actionUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as NotificationPriority,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateNotificationRequestImpl implements _CreateNotificationRequest {
  const _$CreateNotificationRequestImpl(
      {required this.userId,
      required this.type,
      required this.title,
      required this.message,
      final Map<String, dynamic> metadata = const {},
      this.actionUrl,
      this.priority = NotificationPriority.normal})
      : _metadata = metadata;

  factory _$CreateNotificationRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateNotificationRequestImplFromJson(json);

  @override
  final String userId;
  @override
  final NotificationType type;
  @override
  final String title;
  @override
  final String message;
  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  final String? actionUrl;
  @override
  @JsonKey()
  final NotificationPriority priority;

  @override
  String toString() {
    return 'CreateNotificationRequest(userId: $userId, type: $type, title: $title, message: $message, metadata: $metadata, actionUrl: $actionUrl, priority: $priority)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateNotificationRequestImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.actionUrl, actionUrl) ||
                other.actionUrl == actionUrl) &&
            (identical(other.priority, priority) ||
                other.priority == priority));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, userId, type, title, message,
      const DeepCollectionEquality().hash(_metadata), actionUrl, priority);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateNotificationRequestImplCopyWith<_$CreateNotificationRequestImpl>
      get copyWith => __$$CreateNotificationRequestImplCopyWithImpl<
          _$CreateNotificationRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateNotificationRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateNotificationRequest implements CreateNotificationRequest {
  const factory _CreateNotificationRequest(
      {required final String userId,
      required final NotificationType type,
      required final String title,
      required final String message,
      final Map<String, dynamic> metadata,
      final String? actionUrl,
      final NotificationPriority priority}) = _$CreateNotificationRequestImpl;

  factory _CreateNotificationRequest.fromJson(Map<String, dynamic> json) =
      _$CreateNotificationRequestImpl.fromJson;

  @override
  String get userId;
  @override
  NotificationType get type;
  @override
  String get title;
  @override
  String get message;
  @override
  Map<String, dynamic> get metadata;
  @override
  String? get actionUrl;
  @override
  NotificationPriority get priority;
  @override
  @JsonKey(ignore: true)
  _$$CreateNotificationRequestImplCopyWith<_$CreateNotificationRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

UpdateNotificationPreferencesRequest
    _$UpdateNotificationPreferencesRequestFromJson(Map<String, dynamic> json) {
  return _UpdateNotificationPreferencesRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateNotificationPreferencesRequest {
  NotificationType get notificationType => throw _privateConstructorUsedError;
  bool? get inAppEnabled => throw _privateConstructorUsedError;
  bool? get emailEnabled => throw _privateConstructorUsedError;
  bool? get pushEnabled => throw _privateConstructorUsedError;
  String? get quietHoursStart => throw _privateConstructorUsedError;
  String? get quietHoursEnd => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UpdateNotificationPreferencesRequestCopyWith<
          UpdateNotificationPreferencesRequest>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateNotificationPreferencesRequestCopyWith<$Res> {
  factory $UpdateNotificationPreferencesRequestCopyWith(
          UpdateNotificationPreferencesRequest value,
          $Res Function(UpdateNotificationPreferencesRequest) then) =
      _$UpdateNotificationPreferencesRequestCopyWithImpl<$Res,
          UpdateNotificationPreferencesRequest>;
  @useResult
  $Res call(
      {NotificationType notificationType,
      bool? inAppEnabled,
      bool? emailEnabled,
      bool? pushEnabled,
      String? quietHoursStart,
      String? quietHoursEnd});
}

/// @nodoc
class _$UpdateNotificationPreferencesRequestCopyWithImpl<$Res,
        $Val extends UpdateNotificationPreferencesRequest>
    implements $UpdateNotificationPreferencesRequestCopyWith<$Res> {
  _$UpdateNotificationPreferencesRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notificationType = null,
    Object? inAppEnabled = freezed,
    Object? emailEnabled = freezed,
    Object? pushEnabled = freezed,
    Object? quietHoursStart = freezed,
    Object? quietHoursEnd = freezed,
  }) {
    return _then(_value.copyWith(
      notificationType: null == notificationType
          ? _value.notificationType
          : notificationType // ignore: cast_nullable_to_non_nullable
              as NotificationType,
      inAppEnabled: freezed == inAppEnabled
          ? _value.inAppEnabled
          : inAppEnabled // ignore: cast_nullable_to_non_nullable
              as bool?,
      emailEnabled: freezed == emailEnabled
          ? _value.emailEnabled
          : emailEnabled // ignore: cast_nullable_to_non_nullable
              as bool?,
      pushEnabled: freezed == pushEnabled
          ? _value.pushEnabled
          : pushEnabled // ignore: cast_nullable_to_non_nullable
              as bool?,
      quietHoursStart: freezed == quietHoursStart
          ? _value.quietHoursStart
          : quietHoursStart // ignore: cast_nullable_to_non_nullable
              as String?,
      quietHoursEnd: freezed == quietHoursEnd
          ? _value.quietHoursEnd
          : quietHoursEnd // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateNotificationPreferencesRequestImplCopyWith<$Res>
    implements $UpdateNotificationPreferencesRequestCopyWith<$Res> {
  factory _$$UpdateNotificationPreferencesRequestImplCopyWith(
          _$UpdateNotificationPreferencesRequestImpl value,
          $Res Function(_$UpdateNotificationPreferencesRequestImpl) then) =
      __$$UpdateNotificationPreferencesRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {NotificationType notificationType,
      bool? inAppEnabled,
      bool? emailEnabled,
      bool? pushEnabled,
      String? quietHoursStart,
      String? quietHoursEnd});
}

/// @nodoc
class __$$UpdateNotificationPreferencesRequestImplCopyWithImpl<$Res>
    extends _$UpdateNotificationPreferencesRequestCopyWithImpl<$Res,
        _$UpdateNotificationPreferencesRequestImpl>
    implements _$$UpdateNotificationPreferencesRequestImplCopyWith<$Res> {
  __$$UpdateNotificationPreferencesRequestImplCopyWithImpl(
      _$UpdateNotificationPreferencesRequestImpl _value,
      $Res Function(_$UpdateNotificationPreferencesRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notificationType = null,
    Object? inAppEnabled = freezed,
    Object? emailEnabled = freezed,
    Object? pushEnabled = freezed,
    Object? quietHoursStart = freezed,
    Object? quietHoursEnd = freezed,
  }) {
    return _then(_$UpdateNotificationPreferencesRequestImpl(
      notificationType: null == notificationType
          ? _value.notificationType
          : notificationType // ignore: cast_nullable_to_non_nullable
              as NotificationType,
      inAppEnabled: freezed == inAppEnabled
          ? _value.inAppEnabled
          : inAppEnabled // ignore: cast_nullable_to_non_nullable
              as bool?,
      emailEnabled: freezed == emailEnabled
          ? _value.emailEnabled
          : emailEnabled // ignore: cast_nullable_to_non_nullable
              as bool?,
      pushEnabled: freezed == pushEnabled
          ? _value.pushEnabled
          : pushEnabled // ignore: cast_nullable_to_non_nullable
              as bool?,
      quietHoursStart: freezed == quietHoursStart
          ? _value.quietHoursStart
          : quietHoursStart // ignore: cast_nullable_to_non_nullable
              as String?,
      quietHoursEnd: freezed == quietHoursEnd
          ? _value.quietHoursEnd
          : quietHoursEnd // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateNotificationPreferencesRequestImpl
    implements _UpdateNotificationPreferencesRequest {
  const _$UpdateNotificationPreferencesRequestImpl(
      {required this.notificationType,
      this.inAppEnabled,
      this.emailEnabled,
      this.pushEnabled,
      this.quietHoursStart,
      this.quietHoursEnd});

  factory _$UpdateNotificationPreferencesRequestImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$UpdateNotificationPreferencesRequestImplFromJson(json);

  @override
  final NotificationType notificationType;
  @override
  final bool? inAppEnabled;
  @override
  final bool? emailEnabled;
  @override
  final bool? pushEnabled;
  @override
  final String? quietHoursStart;
  @override
  final String? quietHoursEnd;

  @override
  String toString() {
    return 'UpdateNotificationPreferencesRequest(notificationType: $notificationType, inAppEnabled: $inAppEnabled, emailEnabled: $emailEnabled, pushEnabled: $pushEnabled, quietHoursStart: $quietHoursStart, quietHoursEnd: $quietHoursEnd)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateNotificationPreferencesRequestImpl &&
            (identical(other.notificationType, notificationType) ||
                other.notificationType == notificationType) &&
            (identical(other.inAppEnabled, inAppEnabled) ||
                other.inAppEnabled == inAppEnabled) &&
            (identical(other.emailEnabled, emailEnabled) ||
                other.emailEnabled == emailEnabled) &&
            (identical(other.pushEnabled, pushEnabled) ||
                other.pushEnabled == pushEnabled) &&
            (identical(other.quietHoursStart, quietHoursStart) ||
                other.quietHoursStart == quietHoursStart) &&
            (identical(other.quietHoursEnd, quietHoursEnd) ||
                other.quietHoursEnd == quietHoursEnd));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, notificationType, inAppEnabled,
      emailEnabled, pushEnabled, quietHoursStart, quietHoursEnd);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateNotificationPreferencesRequestImplCopyWith<
          _$UpdateNotificationPreferencesRequestImpl>
      get copyWith => __$$UpdateNotificationPreferencesRequestImplCopyWithImpl<
          _$UpdateNotificationPreferencesRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateNotificationPreferencesRequestImplToJson(
      this,
    );
  }
}

abstract class _UpdateNotificationPreferencesRequest
    implements UpdateNotificationPreferencesRequest {
  const factory _UpdateNotificationPreferencesRequest(
          {required final NotificationType notificationType,
          final bool? inAppEnabled,
          final bool? emailEnabled,
          final bool? pushEnabled,
          final String? quietHoursStart,
          final String? quietHoursEnd}) =
      _$UpdateNotificationPreferencesRequestImpl;

  factory _UpdateNotificationPreferencesRequest.fromJson(
          Map<String, dynamic> json) =
      _$UpdateNotificationPreferencesRequestImpl.fromJson;

  @override
  NotificationType get notificationType;
  @override
  bool? get inAppEnabled;
  @override
  bool? get emailEnabled;
  @override
  bool? get pushEnabled;
  @override
  String? get quietHoursStart;
  @override
  String? get quietHoursEnd;
  @override
  @JsonKey(ignore: true)
  _$$UpdateNotificationPreferencesRequestImplCopyWith<
          _$UpdateNotificationPreferencesRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

NotificationsResponse _$NotificationsResponseFromJson(
    Map<String, dynamic> json) {
  return _NotificationsResponse.fromJson(json);
}

/// @nodoc
mixin _$NotificationsResponse {
  List<AppNotification> get notifications => throw _privateConstructorUsedError;
  int get totalCount => throw _privateConstructorUsedError;
  int get unreadCount => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NotificationsResponseCopyWith<NotificationsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationsResponseCopyWith<$Res> {
  factory $NotificationsResponseCopyWith(NotificationsResponse value,
          $Res Function(NotificationsResponse) then) =
      _$NotificationsResponseCopyWithImpl<$Res, NotificationsResponse>;
  @useResult
  $Res call(
      {List<AppNotification> notifications,
      int totalCount,
      int unreadCount,
      int page,
      int limit,
      bool hasMore});
}

/// @nodoc
class _$NotificationsResponseCopyWithImpl<$Res,
        $Val extends NotificationsResponse>
    implements $NotificationsResponseCopyWith<$Res> {
  _$NotificationsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notifications = null,
    Object? totalCount = null,
    Object? unreadCount = null,
    Object? page = null,
    Object? limit = null,
    Object? hasMore = null,
  }) {
    return _then(_value.copyWith(
      notifications: null == notifications
          ? _value.notifications
          : notifications // ignore: cast_nullable_to_non_nullable
              as List<AppNotification>,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationsResponseImplCopyWith<$Res>
    implements $NotificationsResponseCopyWith<$Res> {
  factory _$$NotificationsResponseImplCopyWith(
          _$NotificationsResponseImpl value,
          $Res Function(_$NotificationsResponseImpl) then) =
      __$$NotificationsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<AppNotification> notifications,
      int totalCount,
      int unreadCount,
      int page,
      int limit,
      bool hasMore});
}

/// @nodoc
class __$$NotificationsResponseImplCopyWithImpl<$Res>
    extends _$NotificationsResponseCopyWithImpl<$Res,
        _$NotificationsResponseImpl>
    implements _$$NotificationsResponseImplCopyWith<$Res> {
  __$$NotificationsResponseImplCopyWithImpl(_$NotificationsResponseImpl _value,
      $Res Function(_$NotificationsResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notifications = null,
    Object? totalCount = null,
    Object? unreadCount = null,
    Object? page = null,
    Object? limit = null,
    Object? hasMore = null,
  }) {
    return _then(_$NotificationsResponseImpl(
      notifications: null == notifications
          ? _value._notifications
          : notifications // ignore: cast_nullable_to_non_nullable
              as List<AppNotification>,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationsResponseImpl implements _NotificationsResponse {
  const _$NotificationsResponseImpl(
      {required final List<AppNotification> notifications,
      required this.totalCount,
      required this.unreadCount,
      this.page = 1,
      this.limit = 20,
      this.hasMore = false})
      : _notifications = notifications;

  factory _$NotificationsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationsResponseImplFromJson(json);

  final List<AppNotification> _notifications;
  @override
  List<AppNotification> get notifications {
    if (_notifications is EqualUnmodifiableListView) return _notifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notifications);
  }

  @override
  final int totalCount;
  @override
  final int unreadCount;
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
    return 'NotificationsResponse(notifications: $notifications, totalCount: $totalCount, unreadCount: $unreadCount, page: $page, limit: $limit, hasMore: $hasMore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationsResponseImpl &&
            const DeepCollectionEquality()
                .equals(other._notifications, _notifications) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_notifications),
      totalCount,
      unreadCount,
      page,
      limit,
      hasMore);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationsResponseImplCopyWith<_$NotificationsResponseImpl>
      get copyWith => __$$NotificationsResponseImplCopyWithImpl<
          _$NotificationsResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationsResponseImplToJson(
      this,
    );
  }
}

abstract class _NotificationsResponse implements NotificationsResponse {
  const factory _NotificationsResponse(
      {required final List<AppNotification> notifications,
      required final int totalCount,
      required final int unreadCount,
      final int page,
      final int limit,
      final bool hasMore}) = _$NotificationsResponseImpl;

  factory _NotificationsResponse.fromJson(Map<String, dynamic> json) =
      _$NotificationsResponseImpl.fromJson;

  @override
  List<AppNotification> get notifications;
  @override
  int get totalCount;
  @override
  int get unreadCount;
  @override
  int get page;
  @override
  int get limit;
  @override
  bool get hasMore;
  @override
  @JsonKey(ignore: true)
  _$$NotificationsResponseImplCopyWith<_$NotificationsResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

NotificationFilter _$NotificationFilterFromJson(Map<String, dynamic> json) {
  return _NotificationFilter.fromJson(json);
}

/// @nodoc
mixin _$NotificationFilter {
  int get page => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  bool? get isRead => throw _privateConstructorUsedError;
  bool? get isArchived => throw _privateConstructorUsedError;
  List<NotificationType>? get types => throw _privateConstructorUsedError;
  DateTime? get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  NotificationPriority? get priority => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NotificationFilterCopyWith<NotificationFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationFilterCopyWith<$Res> {
  factory $NotificationFilterCopyWith(
          NotificationFilter value, $Res Function(NotificationFilter) then) =
      _$NotificationFilterCopyWithImpl<$Res, NotificationFilter>;
  @useResult
  $Res call(
      {int page,
      int limit,
      bool? isRead,
      bool? isArchived,
      List<NotificationType>? types,
      DateTime? startDate,
      DateTime? endDate,
      NotificationPriority? priority});
}

/// @nodoc
class _$NotificationFilterCopyWithImpl<$Res, $Val extends NotificationFilter>
    implements $NotificationFilterCopyWith<$Res> {
  _$NotificationFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? limit = null,
    Object? isRead = freezed,
    Object? isArchived = freezed,
    Object? types = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? priority = freezed,
  }) {
    return _then(_value.copyWith(
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      isRead: freezed == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool?,
      isArchived: freezed == isArchived
          ? _value.isArchived
          : isArchived // ignore: cast_nullable_to_non_nullable
              as bool?,
      types: freezed == types
          ? _value.types
          : types // ignore: cast_nullable_to_non_nullable
              as List<NotificationType>?,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      priority: freezed == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as NotificationPriority?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationFilterImplCopyWith<$Res>
    implements $NotificationFilterCopyWith<$Res> {
  factory _$$NotificationFilterImplCopyWith(_$NotificationFilterImpl value,
          $Res Function(_$NotificationFilterImpl) then) =
      __$$NotificationFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int page,
      int limit,
      bool? isRead,
      bool? isArchived,
      List<NotificationType>? types,
      DateTime? startDate,
      DateTime? endDate,
      NotificationPriority? priority});
}

/// @nodoc
class __$$NotificationFilterImplCopyWithImpl<$Res>
    extends _$NotificationFilterCopyWithImpl<$Res, _$NotificationFilterImpl>
    implements _$$NotificationFilterImplCopyWith<$Res> {
  __$$NotificationFilterImplCopyWithImpl(_$NotificationFilterImpl _value,
      $Res Function(_$NotificationFilterImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? limit = null,
    Object? isRead = freezed,
    Object? isArchived = freezed,
    Object? types = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? priority = freezed,
  }) {
    return _then(_$NotificationFilterImpl(
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      isRead: freezed == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool?,
      isArchived: freezed == isArchived
          ? _value.isArchived
          : isArchived // ignore: cast_nullable_to_non_nullable
              as bool?,
      types: freezed == types
          ? _value._types
          : types // ignore: cast_nullable_to_non_nullable
              as List<NotificationType>?,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      priority: freezed == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as NotificationPriority?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationFilterImpl implements _NotificationFilter {
  const _$NotificationFilterImpl(
      {this.page = 1,
      this.limit = 20,
      this.isRead,
      this.isArchived,
      final List<NotificationType>? types,
      this.startDate,
      this.endDate,
      this.priority})
      : _types = types;

  factory _$NotificationFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationFilterImplFromJson(json);

  @override
  @JsonKey()
  final int page;
  @override
  @JsonKey()
  final int limit;
  @override
  final bool? isRead;
  @override
  final bool? isArchived;
  final List<NotificationType>? _types;
  @override
  List<NotificationType>? get types {
    final value = _types;
    if (value == null) return null;
    if (_types is EqualUnmodifiableListView) return _types;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime? startDate;
  @override
  final DateTime? endDate;
  @override
  final NotificationPriority? priority;

  @override
  String toString() {
    return 'NotificationFilter(page: $page, limit: $limit, isRead: $isRead, isArchived: $isArchived, types: $types, startDate: $startDate, endDate: $endDate, priority: $priority)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationFilterImpl &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.isArchived, isArchived) ||
                other.isArchived == isArchived) &&
            const DeepCollectionEquality().equals(other._types, _types) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.priority, priority) ||
                other.priority == priority));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      page,
      limit,
      isRead,
      isArchived,
      const DeepCollectionEquality().hash(_types),
      startDate,
      endDate,
      priority);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationFilterImplCopyWith<_$NotificationFilterImpl> get copyWith =>
      __$$NotificationFilterImplCopyWithImpl<_$NotificationFilterImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationFilterImplToJson(
      this,
    );
  }
}

abstract class _NotificationFilter implements NotificationFilter {
  const factory _NotificationFilter(
      {final int page,
      final int limit,
      final bool? isRead,
      final bool? isArchived,
      final List<NotificationType>? types,
      final DateTime? startDate,
      final DateTime? endDate,
      final NotificationPriority? priority}) = _$NotificationFilterImpl;

  factory _NotificationFilter.fromJson(Map<String, dynamic> json) =
      _$NotificationFilterImpl.fromJson;

  @override
  int get page;
  @override
  int get limit;
  @override
  bool? get isRead;
  @override
  bool? get isArchived;
  @override
  List<NotificationType>? get types;
  @override
  DateTime? get startDate;
  @override
  DateTime? get endDate;
  @override
  NotificationPriority? get priority;
  @override
  @JsonKey(ignore: true)
  _$$NotificationFilterImplCopyWith<_$NotificationFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
