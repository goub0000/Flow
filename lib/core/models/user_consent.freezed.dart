// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_consent.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserConsent _$UserConsentFromJson(Map<String, dynamic> json) {
  return _UserConsent.fromJson(json);
}

/// @nodoc
mixin _$UserConsent {
  String get userId => throw _privateConstructorUsedError;
  ConsentStatus get status => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;
  Map<CookieCategory, bool> get categoryConsents =>
      throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  String? get ipAddress => throw _privateConstructorUsedError;
  String? get userAgent => throw _privateConstructorUsedError;
  List<ConsentHistoryEntry> get history => throw _privateConstructorUsedError;

  /// Serializes this UserConsent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserConsent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserConsentCopyWith<UserConsent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserConsentCopyWith<$Res> {
  factory $UserConsentCopyWith(
    UserConsent value,
    $Res Function(UserConsent) then,
  ) = _$UserConsentCopyWithImpl<$Res, UserConsent>;
  @useResult
  $Res call({
    String userId,
    ConsentStatus status,
    DateTime timestamp,
    String version,
    Map<CookieCategory, bool> categoryConsents,
    DateTime? expiresAt,
    String? ipAddress,
    String? userAgent,
    List<ConsentHistoryEntry> history,
  });
}

/// @nodoc
class _$UserConsentCopyWithImpl<$Res, $Val extends UserConsent>
    implements $UserConsentCopyWith<$Res> {
  _$UserConsentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserConsent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? status = null,
    Object? timestamp = null,
    Object? version = null,
    Object? categoryConsents = null,
    Object? expiresAt = freezed,
    Object? ipAddress = freezed,
    Object? userAgent = freezed,
    Object? history = null,
  }) {
    return _then(
      _value.copyWith(
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as ConsentStatus,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            version: null == version
                ? _value.version
                : version // ignore: cast_nullable_to_non_nullable
                      as String,
            categoryConsents: null == categoryConsents
                ? _value.categoryConsents
                : categoryConsents // ignore: cast_nullable_to_non_nullable
                      as Map<CookieCategory, bool>,
            expiresAt: freezed == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            ipAddress: freezed == ipAddress
                ? _value.ipAddress
                : ipAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
            userAgent: freezed == userAgent
                ? _value.userAgent
                : userAgent // ignore: cast_nullable_to_non_nullable
                      as String?,
            history: null == history
                ? _value.history
                : history // ignore: cast_nullable_to_non_nullable
                      as List<ConsentHistoryEntry>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserConsentImplCopyWith<$Res>
    implements $UserConsentCopyWith<$Res> {
  factory _$$UserConsentImplCopyWith(
    _$UserConsentImpl value,
    $Res Function(_$UserConsentImpl) then,
  ) = __$$UserConsentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userId,
    ConsentStatus status,
    DateTime timestamp,
    String version,
    Map<CookieCategory, bool> categoryConsents,
    DateTime? expiresAt,
    String? ipAddress,
    String? userAgent,
    List<ConsentHistoryEntry> history,
  });
}

/// @nodoc
class __$$UserConsentImplCopyWithImpl<$Res>
    extends _$UserConsentCopyWithImpl<$Res, _$UserConsentImpl>
    implements _$$UserConsentImplCopyWith<$Res> {
  __$$UserConsentImplCopyWithImpl(
    _$UserConsentImpl _value,
    $Res Function(_$UserConsentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserConsent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? status = null,
    Object? timestamp = null,
    Object? version = null,
    Object? categoryConsents = null,
    Object? expiresAt = freezed,
    Object? ipAddress = freezed,
    Object? userAgent = freezed,
    Object? history = null,
  }) {
    return _then(
      _$UserConsentImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as ConsentStatus,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        version: null == version
            ? _value.version
            : version // ignore: cast_nullable_to_non_nullable
                  as String,
        categoryConsents: null == categoryConsents
            ? _value._categoryConsents
            : categoryConsents // ignore: cast_nullable_to_non_nullable
                  as Map<CookieCategory, bool>,
        expiresAt: freezed == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        ipAddress: freezed == ipAddress
            ? _value.ipAddress
            : ipAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
        userAgent: freezed == userAgent
            ? _value.userAgent
            : userAgent // ignore: cast_nullable_to_non_nullable
                  as String?,
        history: null == history
            ? _value._history
            : history // ignore: cast_nullable_to_non_nullable
                  as List<ConsentHistoryEntry>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserConsentImpl extends _UserConsent {
  const _$UserConsentImpl({
    required this.userId,
    required this.status,
    required this.timestamp,
    required this.version,
    required final Map<CookieCategory, bool> categoryConsents,
    this.expiresAt,
    this.ipAddress,
    this.userAgent,
    final List<ConsentHistoryEntry> history = const [],
  }) : _categoryConsents = categoryConsents,
       _history = history,
       super._();

  factory _$UserConsentImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserConsentImplFromJson(json);

  @override
  final String userId;
  @override
  final ConsentStatus status;
  @override
  final DateTime timestamp;
  @override
  final String version;
  final Map<CookieCategory, bool> _categoryConsents;
  @override
  Map<CookieCategory, bool> get categoryConsents {
    if (_categoryConsents is EqualUnmodifiableMapView) return _categoryConsents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_categoryConsents);
  }

  @override
  final DateTime? expiresAt;
  @override
  final String? ipAddress;
  @override
  final String? userAgent;
  final List<ConsentHistoryEntry> _history;
  @override
  @JsonKey()
  List<ConsentHistoryEntry> get history {
    if (_history is EqualUnmodifiableListView) return _history;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_history);
  }

  @override
  String toString() {
    return 'UserConsent(userId: $userId, status: $status, timestamp: $timestamp, version: $version, categoryConsents: $categoryConsents, expiresAt: $expiresAt, ipAddress: $ipAddress, userAgent: $userAgent, history: $history)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserConsentImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.version, version) || other.version == version) &&
            const DeepCollectionEquality().equals(
              other._categoryConsents,
              _categoryConsents,
            ) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.ipAddress, ipAddress) ||
                other.ipAddress == ipAddress) &&
            (identical(other.userAgent, userAgent) ||
                other.userAgent == userAgent) &&
            const DeepCollectionEquality().equals(other._history, _history));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    status,
    timestamp,
    version,
    const DeepCollectionEquality().hash(_categoryConsents),
    expiresAt,
    ipAddress,
    userAgent,
    const DeepCollectionEquality().hash(_history),
  );

  /// Create a copy of UserConsent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserConsentImplCopyWith<_$UserConsentImpl> get copyWith =>
      __$$UserConsentImplCopyWithImpl<_$UserConsentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserConsentImplToJson(this);
  }
}

abstract class _UserConsent extends UserConsent {
  const factory _UserConsent({
    required final String userId,
    required final ConsentStatus status,
    required final DateTime timestamp,
    required final String version,
    required final Map<CookieCategory, bool> categoryConsents,
    final DateTime? expiresAt,
    final String? ipAddress,
    final String? userAgent,
    final List<ConsentHistoryEntry> history,
  }) = _$UserConsentImpl;
  const _UserConsent._() : super._();

  factory _UserConsent.fromJson(Map<String, dynamic> json) =
      _$UserConsentImpl.fromJson;

  @override
  String get userId;
  @override
  ConsentStatus get status;
  @override
  DateTime get timestamp;
  @override
  String get version;
  @override
  Map<CookieCategory, bool> get categoryConsents;
  @override
  DateTime? get expiresAt;
  @override
  String? get ipAddress;
  @override
  String? get userAgent;
  @override
  List<ConsentHistoryEntry> get history;

  /// Create a copy of UserConsent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserConsentImplCopyWith<_$UserConsentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ConsentHistoryEntry _$ConsentHistoryEntryFromJson(Map<String, dynamic> json) {
  return _ConsentHistoryEntry.fromJson(json);
}

/// @nodoc
mixin _$ConsentHistoryEntry {
  DateTime get timestamp => throw _privateConstructorUsedError;
  ConsentStatus get status => throw _privateConstructorUsedError;
  Map<CookieCategory, bool> get categoryConsents =>
      throw _privateConstructorUsedError;
  String? get action =>
      throw _privateConstructorUsedError; // e.g., "user_updated", "auto_renewed", "admin_reset"
  String? get ipAddress => throw _privateConstructorUsedError;

  /// Serializes this ConsentHistoryEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConsentHistoryEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConsentHistoryEntryCopyWith<ConsentHistoryEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConsentHistoryEntryCopyWith<$Res> {
  factory $ConsentHistoryEntryCopyWith(
    ConsentHistoryEntry value,
    $Res Function(ConsentHistoryEntry) then,
  ) = _$ConsentHistoryEntryCopyWithImpl<$Res, ConsentHistoryEntry>;
  @useResult
  $Res call({
    DateTime timestamp,
    ConsentStatus status,
    Map<CookieCategory, bool> categoryConsents,
    String? action,
    String? ipAddress,
  });
}

/// @nodoc
class _$ConsentHistoryEntryCopyWithImpl<$Res, $Val extends ConsentHistoryEntry>
    implements $ConsentHistoryEntryCopyWith<$Res> {
  _$ConsentHistoryEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConsentHistoryEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? status = null,
    Object? categoryConsents = null,
    Object? action = freezed,
    Object? ipAddress = freezed,
  }) {
    return _then(
      _value.copyWith(
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as ConsentStatus,
            categoryConsents: null == categoryConsents
                ? _value.categoryConsents
                : categoryConsents // ignore: cast_nullable_to_non_nullable
                      as Map<CookieCategory, bool>,
            action: freezed == action
                ? _value.action
                : action // ignore: cast_nullable_to_non_nullable
                      as String?,
            ipAddress: freezed == ipAddress
                ? _value.ipAddress
                : ipAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ConsentHistoryEntryImplCopyWith<$Res>
    implements $ConsentHistoryEntryCopyWith<$Res> {
  factory _$$ConsentHistoryEntryImplCopyWith(
    _$ConsentHistoryEntryImpl value,
    $Res Function(_$ConsentHistoryEntryImpl) then,
  ) = __$$ConsentHistoryEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DateTime timestamp,
    ConsentStatus status,
    Map<CookieCategory, bool> categoryConsents,
    String? action,
    String? ipAddress,
  });
}

/// @nodoc
class __$$ConsentHistoryEntryImplCopyWithImpl<$Res>
    extends _$ConsentHistoryEntryCopyWithImpl<$Res, _$ConsentHistoryEntryImpl>
    implements _$$ConsentHistoryEntryImplCopyWith<$Res> {
  __$$ConsentHistoryEntryImplCopyWithImpl(
    _$ConsentHistoryEntryImpl _value,
    $Res Function(_$ConsentHistoryEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConsentHistoryEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? status = null,
    Object? categoryConsents = null,
    Object? action = freezed,
    Object? ipAddress = freezed,
  }) {
    return _then(
      _$ConsentHistoryEntryImpl(
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as ConsentStatus,
        categoryConsents: null == categoryConsents
            ? _value._categoryConsents
            : categoryConsents // ignore: cast_nullable_to_non_nullable
                  as Map<CookieCategory, bool>,
        action: freezed == action
            ? _value.action
            : action // ignore: cast_nullable_to_non_nullable
                  as String?,
        ipAddress: freezed == ipAddress
            ? _value.ipAddress
            : ipAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ConsentHistoryEntryImpl implements _ConsentHistoryEntry {
  const _$ConsentHistoryEntryImpl({
    required this.timestamp,
    required this.status,
    required final Map<CookieCategory, bool> categoryConsents,
    this.action,
    this.ipAddress,
  }) : _categoryConsents = categoryConsents;

  factory _$ConsentHistoryEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConsentHistoryEntryImplFromJson(json);

  @override
  final DateTime timestamp;
  @override
  final ConsentStatus status;
  final Map<CookieCategory, bool> _categoryConsents;
  @override
  Map<CookieCategory, bool> get categoryConsents {
    if (_categoryConsents is EqualUnmodifiableMapView) return _categoryConsents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_categoryConsents);
  }

  @override
  final String? action;
  // e.g., "user_updated", "auto_renewed", "admin_reset"
  @override
  final String? ipAddress;

  @override
  String toString() {
    return 'ConsentHistoryEntry(timestamp: $timestamp, status: $status, categoryConsents: $categoryConsents, action: $action, ipAddress: $ipAddress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConsentHistoryEntryImpl &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(
              other._categoryConsents,
              _categoryConsents,
            ) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.ipAddress, ipAddress) ||
                other.ipAddress == ipAddress));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    timestamp,
    status,
    const DeepCollectionEquality().hash(_categoryConsents),
    action,
    ipAddress,
  );

  /// Create a copy of ConsentHistoryEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConsentHistoryEntryImplCopyWith<_$ConsentHistoryEntryImpl> get copyWith =>
      __$$ConsentHistoryEntryImplCopyWithImpl<_$ConsentHistoryEntryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ConsentHistoryEntryImplToJson(this);
  }
}

abstract class _ConsentHistoryEntry implements ConsentHistoryEntry {
  const factory _ConsentHistoryEntry({
    required final DateTime timestamp,
    required final ConsentStatus status,
    required final Map<CookieCategory, bool> categoryConsents,
    final String? action,
    final String? ipAddress,
  }) = _$ConsentHistoryEntryImpl;

  factory _ConsentHistoryEntry.fromJson(Map<String, dynamic> json) =
      _$ConsentHistoryEntryImpl.fromJson;

  @override
  DateTime get timestamp;
  @override
  ConsentStatus get status;
  @override
  Map<CookieCategory, bool> get categoryConsents;
  @override
  String? get action; // e.g., "user_updated", "auto_renewed", "admin_reset"
  @override
  String? get ipAddress;

  /// Create a copy of ConsentHistoryEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConsentHistoryEntryImplCopyWith<_$ConsentHistoryEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
