// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'approval_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ApprovalAction _$ApprovalActionFromJson(Map<String, dynamic> json) {
  return _ApprovalAction.fromJson(json);
}

/// @nodoc
mixin _$ApprovalAction {
  String get id => throw _privateConstructorUsedError;
  String get requestId => throw _privateConstructorUsedError;
  String get reviewerId => throw _privateConstructorUsedError;
  String get reviewerRole => throw _privateConstructorUsedError;
  int get reviewerLevel => throw _privateConstructorUsedError;
  String get actionType => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String? get delegatedTo => throw _privateConstructorUsedError;
  String? get delegatedReason => throw _privateConstructorUsedError;
  int? get escalatedToLevel => throw _privateConstructorUsedError;
  String? get escalationReason => throw _privateConstructorUsedError;
  String? get infoRequested => throw _privateConstructorUsedError;
  bool get mfaVerified => throw _privateConstructorUsedError;
  DateTime get actedAt => throw _privateConstructorUsedError;
  String? get reviewerName => throw _privateConstructorUsedError;
  String? get reviewerEmail => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ApprovalActionCopyWith<ApprovalAction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApprovalActionCopyWith<$Res> {
  factory $ApprovalActionCopyWith(
          ApprovalAction value, $Res Function(ApprovalAction) then) =
      _$ApprovalActionCopyWithImpl<$Res, ApprovalAction>;
  @useResult
  $Res call(
      {String id,
      String requestId,
      String reviewerId,
      String reviewerRole,
      int reviewerLevel,
      String actionType,
      String? notes,
      String? delegatedTo,
      String? delegatedReason,
      int? escalatedToLevel,
      String? escalationReason,
      String? infoRequested,
      bool mfaVerified,
      DateTime actedAt,
      String? reviewerName,
      String? reviewerEmail});
}

/// @nodoc
class _$ApprovalActionCopyWithImpl<$Res, $Val extends ApprovalAction>
    implements $ApprovalActionCopyWith<$Res> {
  _$ApprovalActionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? requestId = null,
    Object? reviewerId = null,
    Object? reviewerRole = null,
    Object? reviewerLevel = null,
    Object? actionType = null,
    Object? notes = freezed,
    Object? delegatedTo = freezed,
    Object? delegatedReason = freezed,
    Object? escalatedToLevel = freezed,
    Object? escalationReason = freezed,
    Object? infoRequested = freezed,
    Object? mfaVerified = null,
    Object? actedAt = null,
    Object? reviewerName = freezed,
    Object? reviewerEmail = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      requestId: null == requestId
          ? _value.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String,
      reviewerId: null == reviewerId
          ? _value.reviewerId
          : reviewerId // ignore: cast_nullable_to_non_nullable
              as String,
      reviewerRole: null == reviewerRole
          ? _value.reviewerRole
          : reviewerRole // ignore: cast_nullable_to_non_nullable
              as String,
      reviewerLevel: null == reviewerLevel
          ? _value.reviewerLevel
          : reviewerLevel // ignore: cast_nullable_to_non_nullable
              as int,
      actionType: null == actionType
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      delegatedTo: freezed == delegatedTo
          ? _value.delegatedTo
          : delegatedTo // ignore: cast_nullable_to_non_nullable
              as String?,
      delegatedReason: freezed == delegatedReason
          ? _value.delegatedReason
          : delegatedReason // ignore: cast_nullable_to_non_nullable
              as String?,
      escalatedToLevel: freezed == escalatedToLevel
          ? _value.escalatedToLevel
          : escalatedToLevel // ignore: cast_nullable_to_non_nullable
              as int?,
      escalationReason: freezed == escalationReason
          ? _value.escalationReason
          : escalationReason // ignore: cast_nullable_to_non_nullable
              as String?,
      infoRequested: freezed == infoRequested
          ? _value.infoRequested
          : infoRequested // ignore: cast_nullable_to_non_nullable
              as String?,
      mfaVerified: null == mfaVerified
          ? _value.mfaVerified
          : mfaVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      actedAt: null == actedAt
          ? _value.actedAt
          : actedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reviewerName: freezed == reviewerName
          ? _value.reviewerName
          : reviewerName // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewerEmail: freezed == reviewerEmail
          ? _value.reviewerEmail
          : reviewerEmail // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApprovalActionImplCopyWith<$Res>
    implements $ApprovalActionCopyWith<$Res> {
  factory _$$ApprovalActionImplCopyWith(_$ApprovalActionImpl value,
          $Res Function(_$ApprovalActionImpl) then) =
      __$$ApprovalActionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String requestId,
      String reviewerId,
      String reviewerRole,
      int reviewerLevel,
      String actionType,
      String? notes,
      String? delegatedTo,
      String? delegatedReason,
      int? escalatedToLevel,
      String? escalationReason,
      String? infoRequested,
      bool mfaVerified,
      DateTime actedAt,
      String? reviewerName,
      String? reviewerEmail});
}

/// @nodoc
class __$$ApprovalActionImplCopyWithImpl<$Res>
    extends _$ApprovalActionCopyWithImpl<$Res, _$ApprovalActionImpl>
    implements _$$ApprovalActionImplCopyWith<$Res> {
  __$$ApprovalActionImplCopyWithImpl(
      _$ApprovalActionImpl _value, $Res Function(_$ApprovalActionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? requestId = null,
    Object? reviewerId = null,
    Object? reviewerRole = null,
    Object? reviewerLevel = null,
    Object? actionType = null,
    Object? notes = freezed,
    Object? delegatedTo = freezed,
    Object? delegatedReason = freezed,
    Object? escalatedToLevel = freezed,
    Object? escalationReason = freezed,
    Object? infoRequested = freezed,
    Object? mfaVerified = null,
    Object? actedAt = null,
    Object? reviewerName = freezed,
    Object? reviewerEmail = freezed,
  }) {
    return _then(_$ApprovalActionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      requestId: null == requestId
          ? _value.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String,
      reviewerId: null == reviewerId
          ? _value.reviewerId
          : reviewerId // ignore: cast_nullable_to_non_nullable
              as String,
      reviewerRole: null == reviewerRole
          ? _value.reviewerRole
          : reviewerRole // ignore: cast_nullable_to_non_nullable
              as String,
      reviewerLevel: null == reviewerLevel
          ? _value.reviewerLevel
          : reviewerLevel // ignore: cast_nullable_to_non_nullable
              as int,
      actionType: null == actionType
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      delegatedTo: freezed == delegatedTo
          ? _value.delegatedTo
          : delegatedTo // ignore: cast_nullable_to_non_nullable
              as String?,
      delegatedReason: freezed == delegatedReason
          ? _value.delegatedReason
          : delegatedReason // ignore: cast_nullable_to_non_nullable
              as String?,
      escalatedToLevel: freezed == escalatedToLevel
          ? _value.escalatedToLevel
          : escalatedToLevel // ignore: cast_nullable_to_non_nullable
              as int?,
      escalationReason: freezed == escalationReason
          ? _value.escalationReason
          : escalationReason // ignore: cast_nullable_to_non_nullable
              as String?,
      infoRequested: freezed == infoRequested
          ? _value.infoRequested
          : infoRequested // ignore: cast_nullable_to_non_nullable
              as String?,
      mfaVerified: null == mfaVerified
          ? _value.mfaVerified
          : mfaVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      actedAt: null == actedAt
          ? _value.actedAt
          : actedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reviewerName: freezed == reviewerName
          ? _value.reviewerName
          : reviewerName // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewerEmail: freezed == reviewerEmail
          ? _value.reviewerEmail
          : reviewerEmail // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApprovalActionImpl implements _ApprovalAction {
  const _$ApprovalActionImpl(
      {required this.id,
      required this.requestId,
      required this.reviewerId,
      required this.reviewerRole,
      required this.reviewerLevel,
      required this.actionType,
      this.notes,
      this.delegatedTo,
      this.delegatedReason,
      this.escalatedToLevel,
      this.escalationReason,
      this.infoRequested,
      this.mfaVerified = false,
      required this.actedAt,
      this.reviewerName,
      this.reviewerEmail});

  factory _$ApprovalActionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApprovalActionImplFromJson(json);

  @override
  final String id;
  @override
  final String requestId;
  @override
  final String reviewerId;
  @override
  final String reviewerRole;
  @override
  final int reviewerLevel;
  @override
  final String actionType;
  @override
  final String? notes;
  @override
  final String? delegatedTo;
  @override
  final String? delegatedReason;
  @override
  final int? escalatedToLevel;
  @override
  final String? escalationReason;
  @override
  final String? infoRequested;
  @override
  @JsonKey()
  final bool mfaVerified;
  @override
  final DateTime actedAt;
  @override
  final String? reviewerName;
  @override
  final String? reviewerEmail;

  @override
  String toString() {
    return 'ApprovalAction(id: $id, requestId: $requestId, reviewerId: $reviewerId, reviewerRole: $reviewerRole, reviewerLevel: $reviewerLevel, actionType: $actionType, notes: $notes, delegatedTo: $delegatedTo, delegatedReason: $delegatedReason, escalatedToLevel: $escalatedToLevel, escalationReason: $escalationReason, infoRequested: $infoRequested, mfaVerified: $mfaVerified, actedAt: $actedAt, reviewerName: $reviewerName, reviewerEmail: $reviewerEmail)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApprovalActionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.reviewerId, reviewerId) ||
                other.reviewerId == reviewerId) &&
            (identical(other.reviewerRole, reviewerRole) ||
                other.reviewerRole == reviewerRole) &&
            (identical(other.reviewerLevel, reviewerLevel) ||
                other.reviewerLevel == reviewerLevel) &&
            (identical(other.actionType, actionType) ||
                other.actionType == actionType) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.delegatedTo, delegatedTo) ||
                other.delegatedTo == delegatedTo) &&
            (identical(other.delegatedReason, delegatedReason) ||
                other.delegatedReason == delegatedReason) &&
            (identical(other.escalatedToLevel, escalatedToLevel) ||
                other.escalatedToLevel == escalatedToLevel) &&
            (identical(other.escalationReason, escalationReason) ||
                other.escalationReason == escalationReason) &&
            (identical(other.infoRequested, infoRequested) ||
                other.infoRequested == infoRequested) &&
            (identical(other.mfaVerified, mfaVerified) ||
                other.mfaVerified == mfaVerified) &&
            (identical(other.actedAt, actedAt) || other.actedAt == actedAt) &&
            (identical(other.reviewerName, reviewerName) ||
                other.reviewerName == reviewerName) &&
            (identical(other.reviewerEmail, reviewerEmail) ||
                other.reviewerEmail == reviewerEmail));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      requestId,
      reviewerId,
      reviewerRole,
      reviewerLevel,
      actionType,
      notes,
      delegatedTo,
      delegatedReason,
      escalatedToLevel,
      escalationReason,
      infoRequested,
      mfaVerified,
      actedAt,
      reviewerName,
      reviewerEmail);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ApprovalActionImplCopyWith<_$ApprovalActionImpl> get copyWith =>
      __$$ApprovalActionImplCopyWithImpl<_$ApprovalActionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApprovalActionImplToJson(
      this,
    );
  }
}

abstract class _ApprovalAction implements ApprovalAction {
  const factory _ApprovalAction(
      {required final String id,
      required final String requestId,
      required final String reviewerId,
      required final String reviewerRole,
      required final int reviewerLevel,
      required final String actionType,
      final String? notes,
      final String? delegatedTo,
      final String? delegatedReason,
      final int? escalatedToLevel,
      final String? escalationReason,
      final String? infoRequested,
      final bool mfaVerified,
      required final DateTime actedAt,
      final String? reviewerName,
      final String? reviewerEmail}) = _$ApprovalActionImpl;

  factory _ApprovalAction.fromJson(Map<String, dynamic> json) =
      _$ApprovalActionImpl.fromJson;

  @override
  String get id;
  @override
  String get requestId;
  @override
  String get reviewerId;
  @override
  String get reviewerRole;
  @override
  int get reviewerLevel;
  @override
  String get actionType;
  @override
  String? get notes;
  @override
  String? get delegatedTo;
  @override
  String? get delegatedReason;
  @override
  int? get escalatedToLevel;
  @override
  String? get escalationReason;
  @override
  String? get infoRequested;
  @override
  bool get mfaVerified;
  @override
  DateTime get actedAt;
  @override
  String? get reviewerName;
  @override
  String? get reviewerEmail;
  @override
  @JsonKey(ignore: true)
  _$$ApprovalActionImplCopyWith<_$ApprovalActionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ApprovalComment _$ApprovalCommentFromJson(Map<String, dynamic> json) {
  return _ApprovalComment.fromJson(json);
}

/// @nodoc
mixin _$ApprovalComment {
  String get id => throw _privateConstructorUsedError;
  String get requestId => throw _privateConstructorUsedError;
  String get authorId => throw _privateConstructorUsedError;
  String get authorRole => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  bool get isInternal => throw _privateConstructorUsedError;
  List<Map<String, String>> get attachments =>
      throw _privateConstructorUsedError;
  String? get parentCommentId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  String? get authorName => throw _privateConstructorUsedError;
  String? get authorEmail => throw _privateConstructorUsedError;
  List<ApprovalComment> get replies => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ApprovalCommentCopyWith<ApprovalComment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApprovalCommentCopyWith<$Res> {
  factory $ApprovalCommentCopyWith(
          ApprovalComment value, $Res Function(ApprovalComment) then) =
      _$ApprovalCommentCopyWithImpl<$Res, ApprovalComment>;
  @useResult
  $Res call(
      {String id,
      String requestId,
      String authorId,
      String authorRole,
      String content,
      bool isInternal,
      List<Map<String, String>> attachments,
      String? parentCommentId,
      DateTime createdAt,
      DateTime? updatedAt,
      DateTime? deletedAt,
      String? authorName,
      String? authorEmail,
      List<ApprovalComment> replies});
}

/// @nodoc
class _$ApprovalCommentCopyWithImpl<$Res, $Val extends ApprovalComment>
    implements $ApprovalCommentCopyWith<$Res> {
  _$ApprovalCommentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? requestId = null,
    Object? authorId = null,
    Object? authorRole = null,
    Object? content = null,
    Object? isInternal = null,
    Object? attachments = null,
    Object? parentCommentId = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? authorName = freezed,
    Object? authorEmail = freezed,
    Object? replies = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      requestId: null == requestId
          ? _value.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      authorRole: null == authorRole
          ? _value.authorRole
          : authorRole // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      isInternal: null == isInternal
          ? _value.isInternal
          : isInternal // ignore: cast_nullable_to_non_nullable
              as bool,
      attachments: null == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<Map<String, String>>,
      parentCommentId: freezed == parentCommentId
          ? _value.parentCommentId
          : parentCommentId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      authorName: freezed == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String?,
      authorEmail: freezed == authorEmail
          ? _value.authorEmail
          : authorEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      replies: null == replies
          ? _value.replies
          : replies // ignore: cast_nullable_to_non_nullable
              as List<ApprovalComment>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApprovalCommentImplCopyWith<$Res>
    implements $ApprovalCommentCopyWith<$Res> {
  factory _$$ApprovalCommentImplCopyWith(_$ApprovalCommentImpl value,
          $Res Function(_$ApprovalCommentImpl) then) =
      __$$ApprovalCommentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String requestId,
      String authorId,
      String authorRole,
      String content,
      bool isInternal,
      List<Map<String, String>> attachments,
      String? parentCommentId,
      DateTime createdAt,
      DateTime? updatedAt,
      DateTime? deletedAt,
      String? authorName,
      String? authorEmail,
      List<ApprovalComment> replies});
}

/// @nodoc
class __$$ApprovalCommentImplCopyWithImpl<$Res>
    extends _$ApprovalCommentCopyWithImpl<$Res, _$ApprovalCommentImpl>
    implements _$$ApprovalCommentImplCopyWith<$Res> {
  __$$ApprovalCommentImplCopyWithImpl(
      _$ApprovalCommentImpl _value, $Res Function(_$ApprovalCommentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? requestId = null,
    Object? authorId = null,
    Object? authorRole = null,
    Object? content = null,
    Object? isInternal = null,
    Object? attachments = null,
    Object? parentCommentId = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? authorName = freezed,
    Object? authorEmail = freezed,
    Object? replies = null,
  }) {
    return _then(_$ApprovalCommentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      requestId: null == requestId
          ? _value.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      authorRole: null == authorRole
          ? _value.authorRole
          : authorRole // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      isInternal: null == isInternal
          ? _value.isInternal
          : isInternal // ignore: cast_nullable_to_non_nullable
              as bool,
      attachments: null == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<Map<String, String>>,
      parentCommentId: freezed == parentCommentId
          ? _value.parentCommentId
          : parentCommentId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      authorName: freezed == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String?,
      authorEmail: freezed == authorEmail
          ? _value.authorEmail
          : authorEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      replies: null == replies
          ? _value._replies
          : replies // ignore: cast_nullable_to_non_nullable
              as List<ApprovalComment>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApprovalCommentImpl implements _ApprovalComment {
  const _$ApprovalCommentImpl(
      {required this.id,
      required this.requestId,
      required this.authorId,
      required this.authorRole,
      required this.content,
      this.isInternal = false,
      final List<Map<String, String>> attachments = const [],
      this.parentCommentId,
      required this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.authorName,
      this.authorEmail,
      final List<ApprovalComment> replies = const []})
      : _attachments = attachments,
        _replies = replies;

  factory _$ApprovalCommentImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApprovalCommentImplFromJson(json);

  @override
  final String id;
  @override
  final String requestId;
  @override
  final String authorId;
  @override
  final String authorRole;
  @override
  final String content;
  @override
  @JsonKey()
  final bool isInternal;
  final List<Map<String, String>> _attachments;
  @override
  @JsonKey()
  List<Map<String, String>> get attachments {
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachments);
  }

  @override
  final String? parentCommentId;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final DateTime? deletedAt;
  @override
  final String? authorName;
  @override
  final String? authorEmail;
  final List<ApprovalComment> _replies;
  @override
  @JsonKey()
  List<ApprovalComment> get replies {
    if (_replies is EqualUnmodifiableListView) return _replies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_replies);
  }

  @override
  String toString() {
    return 'ApprovalComment(id: $id, requestId: $requestId, authorId: $authorId, authorRole: $authorRole, content: $content, isInternal: $isInternal, attachments: $attachments, parentCommentId: $parentCommentId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, authorName: $authorName, authorEmail: $authorEmail, replies: $replies)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApprovalCommentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.authorId, authorId) ||
                other.authorId == authorId) &&
            (identical(other.authorRole, authorRole) ||
                other.authorRole == authorRole) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.isInternal, isInternal) ||
                other.isInternal == isInternal) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments) &&
            (identical(other.parentCommentId, parentCommentId) ||
                other.parentCommentId == parentCommentId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName) &&
            (identical(other.authorEmail, authorEmail) ||
                other.authorEmail == authorEmail) &&
            const DeepCollectionEquality().equals(other._replies, _replies));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      requestId,
      authorId,
      authorRole,
      content,
      isInternal,
      const DeepCollectionEquality().hash(_attachments),
      parentCommentId,
      createdAt,
      updatedAt,
      deletedAt,
      authorName,
      authorEmail,
      const DeepCollectionEquality().hash(_replies));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ApprovalCommentImplCopyWith<_$ApprovalCommentImpl> get copyWith =>
      __$$ApprovalCommentImplCopyWithImpl<_$ApprovalCommentImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApprovalCommentImplToJson(
      this,
    );
  }
}

abstract class _ApprovalComment implements ApprovalComment {
  const factory _ApprovalComment(
      {required final String id,
      required final String requestId,
      required final String authorId,
      required final String authorRole,
      required final String content,
      final bool isInternal,
      final List<Map<String, String>> attachments,
      final String? parentCommentId,
      required final DateTime createdAt,
      final DateTime? updatedAt,
      final DateTime? deletedAt,
      final String? authorName,
      final String? authorEmail,
      final List<ApprovalComment> replies}) = _$ApprovalCommentImpl;

  factory _ApprovalComment.fromJson(Map<String, dynamic> json) =
      _$ApprovalCommentImpl.fromJson;

  @override
  String get id;
  @override
  String get requestId;
  @override
  String get authorId;
  @override
  String get authorRole;
  @override
  String get content;
  @override
  bool get isInternal;
  @override
  List<Map<String, String>> get attachments;
  @override
  String? get parentCommentId;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  DateTime? get deletedAt;
  @override
  String? get authorName;
  @override
  String? get authorEmail;
  @override
  List<ApprovalComment> get replies;
  @override
  @JsonKey(ignore: true)
  _$$ApprovalCommentImplCopyWith<_$ApprovalCommentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ApprovalRequest _$ApprovalRequestFromJson(Map<String, dynamic> json) {
  return _ApprovalRequest.fromJson(json);
}

/// @nodoc
mixin _$ApprovalRequest {
  String get id => throw _privateConstructorUsedError;
  String get requestNumber => throw _privateConstructorUsedError;
  String get requestType => throw _privateConstructorUsedError;
  String get initiatedBy => throw _privateConstructorUsedError;
  String get initiatedByRole => throw _privateConstructorUsedError;
  DateTime get initiatedAt => throw _privateConstructorUsedError;
  String get targetResourceType => throw _privateConstructorUsedError;
  String? get targetResourceId => throw _privateConstructorUsedError;
  Map<String, dynamic>? get targetResourceSnapshot =>
      throw _privateConstructorUsedError;
  String get actionType => throw _privateConstructorUsedError;
  Map<String, dynamic> get actionPayload => throw _privateConstructorUsedError;
  String get justification => throw _privateConstructorUsedError;
  String get priority => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  int get currentApprovalLevel => throw _privateConstructorUsedError;
  int get requiredApprovalLevel => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get approvalChain =>
      throw _privateConstructorUsedError;
  String? get regionalScope => throw _privateConstructorUsedError;
  List<Map<String, String>> get attachments =>
      throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  DateTime? get executedAt => throw _privateConstructorUsedError;
  Map<String, dynamic>? get executionResult =>
      throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String? get initiatorName => throw _privateConstructorUsedError;
  String? get initiatorEmail => throw _privateConstructorUsedError;
  List<ApprovalAction> get actions => throw _privateConstructorUsedError;
  List<ApprovalComment> get comments => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ApprovalRequestCopyWith<ApprovalRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApprovalRequestCopyWith<$Res> {
  factory $ApprovalRequestCopyWith(
          ApprovalRequest value, $Res Function(ApprovalRequest) then) =
      _$ApprovalRequestCopyWithImpl<$Res, ApprovalRequest>;
  @useResult
  $Res call(
      {String id,
      String requestNumber,
      String requestType,
      String initiatedBy,
      String initiatedByRole,
      DateTime initiatedAt,
      String targetResourceType,
      String? targetResourceId,
      Map<String, dynamic>? targetResourceSnapshot,
      String actionType,
      Map<String, dynamic> actionPayload,
      String justification,
      String priority,
      DateTime? expiresAt,
      String status,
      int currentApprovalLevel,
      int requiredApprovalLevel,
      List<Map<String, dynamic>> approvalChain,
      String? regionalScope,
      List<Map<String, String>> attachments,
      Map<String, dynamic>? metadata,
      DateTime? executedAt,
      Map<String, dynamic>? executionResult,
      DateTime createdAt,
      DateTime updatedAt,
      String? initiatorName,
      String? initiatorEmail,
      List<ApprovalAction> actions,
      List<ApprovalComment> comments});
}

/// @nodoc
class _$ApprovalRequestCopyWithImpl<$Res, $Val extends ApprovalRequest>
    implements $ApprovalRequestCopyWith<$Res> {
  _$ApprovalRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? requestNumber = null,
    Object? requestType = null,
    Object? initiatedBy = null,
    Object? initiatedByRole = null,
    Object? initiatedAt = null,
    Object? targetResourceType = null,
    Object? targetResourceId = freezed,
    Object? targetResourceSnapshot = freezed,
    Object? actionType = null,
    Object? actionPayload = null,
    Object? justification = null,
    Object? priority = null,
    Object? expiresAt = freezed,
    Object? status = null,
    Object? currentApprovalLevel = null,
    Object? requiredApprovalLevel = null,
    Object? approvalChain = null,
    Object? regionalScope = freezed,
    Object? attachments = null,
    Object? metadata = freezed,
    Object? executedAt = freezed,
    Object? executionResult = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? initiatorName = freezed,
    Object? initiatorEmail = freezed,
    Object? actions = null,
    Object? comments = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      requestNumber: null == requestNumber
          ? _value.requestNumber
          : requestNumber // ignore: cast_nullable_to_non_nullable
              as String,
      requestType: null == requestType
          ? _value.requestType
          : requestType // ignore: cast_nullable_to_non_nullable
              as String,
      initiatedBy: null == initiatedBy
          ? _value.initiatedBy
          : initiatedBy // ignore: cast_nullable_to_non_nullable
              as String,
      initiatedByRole: null == initiatedByRole
          ? _value.initiatedByRole
          : initiatedByRole // ignore: cast_nullable_to_non_nullable
              as String,
      initiatedAt: null == initiatedAt
          ? _value.initiatedAt
          : initiatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      targetResourceType: null == targetResourceType
          ? _value.targetResourceType
          : targetResourceType // ignore: cast_nullable_to_non_nullable
              as String,
      targetResourceId: freezed == targetResourceId
          ? _value.targetResourceId
          : targetResourceId // ignore: cast_nullable_to_non_nullable
              as String?,
      targetResourceSnapshot: freezed == targetResourceSnapshot
          ? _value.targetResourceSnapshot
          : targetResourceSnapshot // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      actionType: null == actionType
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as String,
      actionPayload: null == actionPayload
          ? _value.actionPayload
          : actionPayload // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      justification: null == justification
          ? _value.justification
          : justification // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      currentApprovalLevel: null == currentApprovalLevel
          ? _value.currentApprovalLevel
          : currentApprovalLevel // ignore: cast_nullable_to_non_nullable
              as int,
      requiredApprovalLevel: null == requiredApprovalLevel
          ? _value.requiredApprovalLevel
          : requiredApprovalLevel // ignore: cast_nullable_to_non_nullable
              as int,
      approvalChain: null == approvalChain
          ? _value.approvalChain
          : approvalChain // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      regionalScope: freezed == regionalScope
          ? _value.regionalScope
          : regionalScope // ignore: cast_nullable_to_non_nullable
              as String?,
      attachments: null == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<Map<String, String>>,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      executedAt: freezed == executedAt
          ? _value.executedAt
          : executedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      executionResult: freezed == executionResult
          ? _value.executionResult
          : executionResult // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      initiatorName: freezed == initiatorName
          ? _value.initiatorName
          : initiatorName // ignore: cast_nullable_to_non_nullable
              as String?,
      initiatorEmail: freezed == initiatorEmail
          ? _value.initiatorEmail
          : initiatorEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      actions: null == actions
          ? _value.actions
          : actions // ignore: cast_nullable_to_non_nullable
              as List<ApprovalAction>,
      comments: null == comments
          ? _value.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<ApprovalComment>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApprovalRequestImplCopyWith<$Res>
    implements $ApprovalRequestCopyWith<$Res> {
  factory _$$ApprovalRequestImplCopyWith(_$ApprovalRequestImpl value,
          $Res Function(_$ApprovalRequestImpl) then) =
      __$$ApprovalRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String requestNumber,
      String requestType,
      String initiatedBy,
      String initiatedByRole,
      DateTime initiatedAt,
      String targetResourceType,
      String? targetResourceId,
      Map<String, dynamic>? targetResourceSnapshot,
      String actionType,
      Map<String, dynamic> actionPayload,
      String justification,
      String priority,
      DateTime? expiresAt,
      String status,
      int currentApprovalLevel,
      int requiredApprovalLevel,
      List<Map<String, dynamic>> approvalChain,
      String? regionalScope,
      List<Map<String, String>> attachments,
      Map<String, dynamic>? metadata,
      DateTime? executedAt,
      Map<String, dynamic>? executionResult,
      DateTime createdAt,
      DateTime updatedAt,
      String? initiatorName,
      String? initiatorEmail,
      List<ApprovalAction> actions,
      List<ApprovalComment> comments});
}

/// @nodoc
class __$$ApprovalRequestImplCopyWithImpl<$Res>
    extends _$ApprovalRequestCopyWithImpl<$Res, _$ApprovalRequestImpl>
    implements _$$ApprovalRequestImplCopyWith<$Res> {
  __$$ApprovalRequestImplCopyWithImpl(
      _$ApprovalRequestImpl _value, $Res Function(_$ApprovalRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? requestNumber = null,
    Object? requestType = null,
    Object? initiatedBy = null,
    Object? initiatedByRole = null,
    Object? initiatedAt = null,
    Object? targetResourceType = null,
    Object? targetResourceId = freezed,
    Object? targetResourceSnapshot = freezed,
    Object? actionType = null,
    Object? actionPayload = null,
    Object? justification = null,
    Object? priority = null,
    Object? expiresAt = freezed,
    Object? status = null,
    Object? currentApprovalLevel = null,
    Object? requiredApprovalLevel = null,
    Object? approvalChain = null,
    Object? regionalScope = freezed,
    Object? attachments = null,
    Object? metadata = freezed,
    Object? executedAt = freezed,
    Object? executionResult = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? initiatorName = freezed,
    Object? initiatorEmail = freezed,
    Object? actions = null,
    Object? comments = null,
  }) {
    return _then(_$ApprovalRequestImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      requestNumber: null == requestNumber
          ? _value.requestNumber
          : requestNumber // ignore: cast_nullable_to_non_nullable
              as String,
      requestType: null == requestType
          ? _value.requestType
          : requestType // ignore: cast_nullable_to_non_nullable
              as String,
      initiatedBy: null == initiatedBy
          ? _value.initiatedBy
          : initiatedBy // ignore: cast_nullable_to_non_nullable
              as String,
      initiatedByRole: null == initiatedByRole
          ? _value.initiatedByRole
          : initiatedByRole // ignore: cast_nullable_to_non_nullable
              as String,
      initiatedAt: null == initiatedAt
          ? _value.initiatedAt
          : initiatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      targetResourceType: null == targetResourceType
          ? _value.targetResourceType
          : targetResourceType // ignore: cast_nullable_to_non_nullable
              as String,
      targetResourceId: freezed == targetResourceId
          ? _value.targetResourceId
          : targetResourceId // ignore: cast_nullable_to_non_nullable
              as String?,
      targetResourceSnapshot: freezed == targetResourceSnapshot
          ? _value._targetResourceSnapshot
          : targetResourceSnapshot // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      actionType: null == actionType
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as String,
      actionPayload: null == actionPayload
          ? _value._actionPayload
          : actionPayload // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      justification: null == justification
          ? _value.justification
          : justification // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      currentApprovalLevel: null == currentApprovalLevel
          ? _value.currentApprovalLevel
          : currentApprovalLevel // ignore: cast_nullable_to_non_nullable
              as int,
      requiredApprovalLevel: null == requiredApprovalLevel
          ? _value.requiredApprovalLevel
          : requiredApprovalLevel // ignore: cast_nullable_to_non_nullable
              as int,
      approvalChain: null == approvalChain
          ? _value._approvalChain
          : approvalChain // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      regionalScope: freezed == regionalScope
          ? _value.regionalScope
          : regionalScope // ignore: cast_nullable_to_non_nullable
              as String?,
      attachments: null == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<Map<String, String>>,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      executedAt: freezed == executedAt
          ? _value.executedAt
          : executedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      executionResult: freezed == executionResult
          ? _value._executionResult
          : executionResult // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      initiatorName: freezed == initiatorName
          ? _value.initiatorName
          : initiatorName // ignore: cast_nullable_to_non_nullable
              as String?,
      initiatorEmail: freezed == initiatorEmail
          ? _value.initiatorEmail
          : initiatorEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      actions: null == actions
          ? _value._actions
          : actions // ignore: cast_nullable_to_non_nullable
              as List<ApprovalAction>,
      comments: null == comments
          ? _value._comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<ApprovalComment>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApprovalRequestImpl implements _ApprovalRequest {
  const _$ApprovalRequestImpl(
      {required this.id,
      required this.requestNumber,
      required this.requestType,
      required this.initiatedBy,
      required this.initiatedByRole,
      required this.initiatedAt,
      required this.targetResourceType,
      this.targetResourceId,
      final Map<String, dynamic>? targetResourceSnapshot,
      required this.actionType,
      final Map<String, dynamic> actionPayload = const {},
      required this.justification,
      required this.priority,
      this.expiresAt,
      required this.status,
      required this.currentApprovalLevel,
      required this.requiredApprovalLevel,
      final List<Map<String, dynamic>> approvalChain = const [],
      this.regionalScope,
      final List<Map<String, String>> attachments = const [],
      final Map<String, dynamic>? metadata,
      this.executedAt,
      final Map<String, dynamic>? executionResult,
      required this.createdAt,
      required this.updatedAt,
      this.initiatorName,
      this.initiatorEmail,
      final List<ApprovalAction> actions = const [],
      final List<ApprovalComment> comments = const []})
      : _targetResourceSnapshot = targetResourceSnapshot,
        _actionPayload = actionPayload,
        _approvalChain = approvalChain,
        _attachments = attachments,
        _metadata = metadata,
        _executionResult = executionResult,
        _actions = actions,
        _comments = comments;

  factory _$ApprovalRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApprovalRequestImplFromJson(json);

  @override
  final String id;
  @override
  final String requestNumber;
  @override
  final String requestType;
  @override
  final String initiatedBy;
  @override
  final String initiatedByRole;
  @override
  final DateTime initiatedAt;
  @override
  final String targetResourceType;
  @override
  final String? targetResourceId;
  final Map<String, dynamic>? _targetResourceSnapshot;
  @override
  Map<String, dynamic>? get targetResourceSnapshot {
    final value = _targetResourceSnapshot;
    if (value == null) return null;
    if (_targetResourceSnapshot is EqualUnmodifiableMapView)
      return _targetResourceSnapshot;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String actionType;
  final Map<String, dynamic> _actionPayload;
  @override
  @JsonKey()
  Map<String, dynamic> get actionPayload {
    if (_actionPayload is EqualUnmodifiableMapView) return _actionPayload;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_actionPayload);
  }

  @override
  final String justification;
  @override
  final String priority;
  @override
  final DateTime? expiresAt;
  @override
  final String status;
  @override
  final int currentApprovalLevel;
  @override
  final int requiredApprovalLevel;
  final List<Map<String, dynamic>> _approvalChain;
  @override
  @JsonKey()
  List<Map<String, dynamic>> get approvalChain {
    if (_approvalChain is EqualUnmodifiableListView) return _approvalChain;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_approvalChain);
  }

  @override
  final String? regionalScope;
  final List<Map<String, String>> _attachments;
  @override
  @JsonKey()
  List<Map<String, String>> get attachments {
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachments);
  }

  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime? executedAt;
  final Map<String, dynamic>? _executionResult;
  @override
  Map<String, dynamic>? get executionResult {
    final value = _executionResult;
    if (value == null) return null;
    if (_executionResult is EqualUnmodifiableMapView) return _executionResult;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String? initiatorName;
  @override
  final String? initiatorEmail;
  final List<ApprovalAction> _actions;
  @override
  @JsonKey()
  List<ApprovalAction> get actions {
    if (_actions is EqualUnmodifiableListView) return _actions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_actions);
  }

  final List<ApprovalComment> _comments;
  @override
  @JsonKey()
  List<ApprovalComment> get comments {
    if (_comments is EqualUnmodifiableListView) return _comments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_comments);
  }

  @override
  String toString() {
    return 'ApprovalRequest(id: $id, requestNumber: $requestNumber, requestType: $requestType, initiatedBy: $initiatedBy, initiatedByRole: $initiatedByRole, initiatedAt: $initiatedAt, targetResourceType: $targetResourceType, targetResourceId: $targetResourceId, targetResourceSnapshot: $targetResourceSnapshot, actionType: $actionType, actionPayload: $actionPayload, justification: $justification, priority: $priority, expiresAt: $expiresAt, status: $status, currentApprovalLevel: $currentApprovalLevel, requiredApprovalLevel: $requiredApprovalLevel, approvalChain: $approvalChain, regionalScope: $regionalScope, attachments: $attachments, metadata: $metadata, executedAt: $executedAt, executionResult: $executionResult, createdAt: $createdAt, updatedAt: $updatedAt, initiatorName: $initiatorName, initiatorEmail: $initiatorEmail, actions: $actions, comments: $comments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApprovalRequestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.requestNumber, requestNumber) ||
                other.requestNumber == requestNumber) &&
            (identical(other.requestType, requestType) ||
                other.requestType == requestType) &&
            (identical(other.initiatedBy, initiatedBy) ||
                other.initiatedBy == initiatedBy) &&
            (identical(other.initiatedByRole, initiatedByRole) ||
                other.initiatedByRole == initiatedByRole) &&
            (identical(other.initiatedAt, initiatedAt) ||
                other.initiatedAt == initiatedAt) &&
            (identical(other.targetResourceType, targetResourceType) ||
                other.targetResourceType == targetResourceType) &&
            (identical(other.targetResourceId, targetResourceId) ||
                other.targetResourceId == targetResourceId) &&
            const DeepCollectionEquality().equals(
                other._targetResourceSnapshot, _targetResourceSnapshot) &&
            (identical(other.actionType, actionType) ||
                other.actionType == actionType) &&
            const DeepCollectionEquality()
                .equals(other._actionPayload, _actionPayload) &&
            (identical(other.justification, justification) ||
                other.justification == justification) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.currentApprovalLevel, currentApprovalLevel) ||
                other.currentApprovalLevel == currentApprovalLevel) &&
            (identical(other.requiredApprovalLevel, requiredApprovalLevel) ||
                other.requiredApprovalLevel == requiredApprovalLevel) &&
            const DeepCollectionEquality()
                .equals(other._approvalChain, _approvalChain) &&
            (identical(other.regionalScope, regionalScope) ||
                other.regionalScope == regionalScope) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.executedAt, executedAt) ||
                other.executedAt == executedAt) &&
            const DeepCollectionEquality()
                .equals(other._executionResult, _executionResult) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.initiatorName, initiatorName) ||
                other.initiatorName == initiatorName) &&
            (identical(other.initiatorEmail, initiatorEmail) ||
                other.initiatorEmail == initiatorEmail) &&
            const DeepCollectionEquality().equals(other._actions, _actions) &&
            const DeepCollectionEquality().equals(other._comments, _comments));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        requestNumber,
        requestType,
        initiatedBy,
        initiatedByRole,
        initiatedAt,
        targetResourceType,
        targetResourceId,
        const DeepCollectionEquality().hash(_targetResourceSnapshot),
        actionType,
        const DeepCollectionEquality().hash(_actionPayload),
        justification,
        priority,
        expiresAt,
        status,
        currentApprovalLevel,
        requiredApprovalLevel,
        const DeepCollectionEquality().hash(_approvalChain),
        regionalScope,
        const DeepCollectionEquality().hash(_attachments),
        const DeepCollectionEquality().hash(_metadata),
        executedAt,
        const DeepCollectionEquality().hash(_executionResult),
        createdAt,
        updatedAt,
        initiatorName,
        initiatorEmail,
        const DeepCollectionEquality().hash(_actions),
        const DeepCollectionEquality().hash(_comments)
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ApprovalRequestImplCopyWith<_$ApprovalRequestImpl> get copyWith =>
      __$$ApprovalRequestImplCopyWithImpl<_$ApprovalRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApprovalRequestImplToJson(
      this,
    );
  }
}

abstract class _ApprovalRequest implements ApprovalRequest {
  const factory _ApprovalRequest(
      {required final String id,
      required final String requestNumber,
      required final String requestType,
      required final String initiatedBy,
      required final String initiatedByRole,
      required final DateTime initiatedAt,
      required final String targetResourceType,
      final String? targetResourceId,
      final Map<String, dynamic>? targetResourceSnapshot,
      required final String actionType,
      final Map<String, dynamic> actionPayload,
      required final String justification,
      required final String priority,
      final DateTime? expiresAt,
      required final String status,
      required final int currentApprovalLevel,
      required final int requiredApprovalLevel,
      final List<Map<String, dynamic>> approvalChain,
      final String? regionalScope,
      final List<Map<String, String>> attachments,
      final Map<String, dynamic>? metadata,
      final DateTime? executedAt,
      final Map<String, dynamic>? executionResult,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final String? initiatorName,
      final String? initiatorEmail,
      final List<ApprovalAction> actions,
      final List<ApprovalComment> comments}) = _$ApprovalRequestImpl;

  factory _ApprovalRequest.fromJson(Map<String, dynamic> json) =
      _$ApprovalRequestImpl.fromJson;

  @override
  String get id;
  @override
  String get requestNumber;
  @override
  String get requestType;
  @override
  String get initiatedBy;
  @override
  String get initiatedByRole;
  @override
  DateTime get initiatedAt;
  @override
  String get targetResourceType;
  @override
  String? get targetResourceId;
  @override
  Map<String, dynamic>? get targetResourceSnapshot;
  @override
  String get actionType;
  @override
  Map<String, dynamic> get actionPayload;
  @override
  String get justification;
  @override
  String get priority;
  @override
  DateTime? get expiresAt;
  @override
  String get status;
  @override
  int get currentApprovalLevel;
  @override
  int get requiredApprovalLevel;
  @override
  List<Map<String, dynamic>> get approvalChain;
  @override
  String? get regionalScope;
  @override
  List<Map<String, String>> get attachments;
  @override
  Map<String, dynamic>? get metadata;
  @override
  DateTime? get executedAt;
  @override
  Map<String, dynamic>? get executionResult;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  String? get initiatorName;
  @override
  String? get initiatorEmail;
  @override
  List<ApprovalAction> get actions;
  @override
  List<ApprovalComment> get comments;
  @override
  @JsonKey(ignore: true)
  _$$ApprovalRequestImplCopyWith<_$ApprovalRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ApprovalRequestListResponse _$ApprovalRequestListResponseFromJson(
    Map<String, dynamic> json) {
  return _ApprovalRequestListResponse.fromJson(json);
}

/// @nodoc
mixin _$ApprovalRequestListResponse {
  List<ApprovalRequest> get requests => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  int get pageSize => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ApprovalRequestListResponseCopyWith<ApprovalRequestListResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApprovalRequestListResponseCopyWith<$Res> {
  factory $ApprovalRequestListResponseCopyWith(
          ApprovalRequestListResponse value,
          $Res Function(ApprovalRequestListResponse) then) =
      _$ApprovalRequestListResponseCopyWithImpl<$Res,
          ApprovalRequestListResponse>;
  @useResult
  $Res call(
      {List<ApprovalRequest> requests,
      int total,
      int page,
      int pageSize,
      bool hasMore});
}

/// @nodoc
class _$ApprovalRequestListResponseCopyWithImpl<$Res,
        $Val extends ApprovalRequestListResponse>
    implements $ApprovalRequestListResponseCopyWith<$Res> {
  _$ApprovalRequestListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requests = null,
    Object? total = null,
    Object? page = null,
    Object? pageSize = null,
    Object? hasMore = null,
  }) {
    return _then(_value.copyWith(
      requests: null == requests
          ? _value.requests
          : requests // ignore: cast_nullable_to_non_nullable
              as List<ApprovalRequest>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApprovalRequestListResponseImplCopyWith<$Res>
    implements $ApprovalRequestListResponseCopyWith<$Res> {
  factory _$$ApprovalRequestListResponseImplCopyWith(
          _$ApprovalRequestListResponseImpl value,
          $Res Function(_$ApprovalRequestListResponseImpl) then) =
      __$$ApprovalRequestListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<ApprovalRequest> requests,
      int total,
      int page,
      int pageSize,
      bool hasMore});
}

/// @nodoc
class __$$ApprovalRequestListResponseImplCopyWithImpl<$Res>
    extends _$ApprovalRequestListResponseCopyWithImpl<$Res,
        _$ApprovalRequestListResponseImpl>
    implements _$$ApprovalRequestListResponseImplCopyWith<$Res> {
  __$$ApprovalRequestListResponseImplCopyWithImpl(
      _$ApprovalRequestListResponseImpl _value,
      $Res Function(_$ApprovalRequestListResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requests = null,
    Object? total = null,
    Object? page = null,
    Object? pageSize = null,
    Object? hasMore = null,
  }) {
    return _then(_$ApprovalRequestListResponseImpl(
      requests: null == requests
          ? _value._requests
          : requests // ignore: cast_nullable_to_non_nullable
              as List<ApprovalRequest>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
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
class _$ApprovalRequestListResponseImpl
    implements _ApprovalRequestListResponse {
  const _$ApprovalRequestListResponseImpl(
      {required final List<ApprovalRequest> requests,
      required this.total,
      required this.page,
      required this.pageSize,
      required this.hasMore})
      : _requests = requests;

  factory _$ApprovalRequestListResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ApprovalRequestListResponseImplFromJson(json);

  final List<ApprovalRequest> _requests;
  @override
  List<ApprovalRequest> get requests {
    if (_requests is EqualUnmodifiableListView) return _requests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_requests);
  }

  @override
  final int total;
  @override
  final int page;
  @override
  final int pageSize;
  @override
  final bool hasMore;

  @override
  String toString() {
    return 'ApprovalRequestListResponse(requests: $requests, total: $total, page: $page, pageSize: $pageSize, hasMore: $hasMore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApprovalRequestListResponseImpl &&
            const DeepCollectionEquality().equals(other._requests, _requests) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_requests),
      total,
      page,
      pageSize,
      hasMore);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ApprovalRequestListResponseImplCopyWith<_$ApprovalRequestListResponseImpl>
      get copyWith => __$$ApprovalRequestListResponseImplCopyWithImpl<
          _$ApprovalRequestListResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApprovalRequestListResponseImplToJson(
      this,
    );
  }
}

abstract class _ApprovalRequestListResponse
    implements ApprovalRequestListResponse {
  const factory _ApprovalRequestListResponse(
      {required final List<ApprovalRequest> requests,
      required final int total,
      required final int page,
      required final int pageSize,
      required final bool hasMore}) = _$ApprovalRequestListResponseImpl;

  factory _ApprovalRequestListResponse.fromJson(Map<String, dynamic> json) =
      _$ApprovalRequestListResponseImpl.fromJson;

  @override
  List<ApprovalRequest> get requests;
  @override
  int get total;
  @override
  int get page;
  @override
  int get pageSize;
  @override
  bool get hasMore;
  @override
  @JsonKey(ignore: true)
  _$$ApprovalRequestListResponseImplCopyWith<_$ApprovalRequestListResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ApprovalConfig _$ApprovalConfigFromJson(Map<String, dynamic> json) {
  return _ApprovalConfig.fromJson(json);
}

/// @nodoc
mixin _$ApprovalConfig {
  String get id => throw _privateConstructorUsedError;
  String get requestType => throw _privateConstructorUsedError;
  String get actionType => throw _privateConstructorUsedError;
  String? get targetResourceType => throw _privateConstructorUsedError;
  int get requiredApprovalLevel => throw _privateConstructorUsedError;
  bool get canSkipLevels => throw _privateConstructorUsedError;
  Map<String, dynamic> get skipLevelConditions =>
      throw _privateConstructorUsedError;
  List<String> get allowedInitiatorRoles => throw _privateConstructorUsedError;
  List<String> get allowedApproverRoles => throw _privateConstructorUsedError;
  String get defaultPriority => throw _privateConstructorUsedError;
  int? get defaultExpirationHours => throw _privateConstructorUsedError;
  bool get requiresMfa => throw _privateConstructorUsedError;
  bool get autoExecute => throw _privateConstructorUsedError;
  List<String> get notificationChannels => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ApprovalConfigCopyWith<ApprovalConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApprovalConfigCopyWith<$Res> {
  factory $ApprovalConfigCopyWith(
          ApprovalConfig value, $Res Function(ApprovalConfig) then) =
      _$ApprovalConfigCopyWithImpl<$Res, ApprovalConfig>;
  @useResult
  $Res call(
      {String id,
      String requestType,
      String actionType,
      String? targetResourceType,
      int requiredApprovalLevel,
      bool canSkipLevels,
      Map<String, dynamic> skipLevelConditions,
      List<String> allowedInitiatorRoles,
      List<String> allowedApproverRoles,
      String defaultPriority,
      int? defaultExpirationHours,
      bool requiresMfa,
      bool autoExecute,
      List<String> notificationChannels,
      bool isActive,
      String? description,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$ApprovalConfigCopyWithImpl<$Res, $Val extends ApprovalConfig>
    implements $ApprovalConfigCopyWith<$Res> {
  _$ApprovalConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? requestType = null,
    Object? actionType = null,
    Object? targetResourceType = freezed,
    Object? requiredApprovalLevel = null,
    Object? canSkipLevels = null,
    Object? skipLevelConditions = null,
    Object? allowedInitiatorRoles = null,
    Object? allowedApproverRoles = null,
    Object? defaultPriority = null,
    Object? defaultExpirationHours = freezed,
    Object? requiresMfa = null,
    Object? autoExecute = null,
    Object? notificationChannels = null,
    Object? isActive = null,
    Object? description = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      requestType: null == requestType
          ? _value.requestType
          : requestType // ignore: cast_nullable_to_non_nullable
              as String,
      actionType: null == actionType
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as String,
      targetResourceType: freezed == targetResourceType
          ? _value.targetResourceType
          : targetResourceType // ignore: cast_nullable_to_non_nullable
              as String?,
      requiredApprovalLevel: null == requiredApprovalLevel
          ? _value.requiredApprovalLevel
          : requiredApprovalLevel // ignore: cast_nullable_to_non_nullable
              as int,
      canSkipLevels: null == canSkipLevels
          ? _value.canSkipLevels
          : canSkipLevels // ignore: cast_nullable_to_non_nullable
              as bool,
      skipLevelConditions: null == skipLevelConditions
          ? _value.skipLevelConditions
          : skipLevelConditions // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      allowedInitiatorRoles: null == allowedInitiatorRoles
          ? _value.allowedInitiatorRoles
          : allowedInitiatorRoles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      allowedApproverRoles: null == allowedApproverRoles
          ? _value.allowedApproverRoles
          : allowedApproverRoles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      defaultPriority: null == defaultPriority
          ? _value.defaultPriority
          : defaultPriority // ignore: cast_nullable_to_non_nullable
              as String,
      defaultExpirationHours: freezed == defaultExpirationHours
          ? _value.defaultExpirationHours
          : defaultExpirationHours // ignore: cast_nullable_to_non_nullable
              as int?,
      requiresMfa: null == requiresMfa
          ? _value.requiresMfa
          : requiresMfa // ignore: cast_nullable_to_non_nullable
              as bool,
      autoExecute: null == autoExecute
          ? _value.autoExecute
          : autoExecute // ignore: cast_nullable_to_non_nullable
              as bool,
      notificationChannels: null == notificationChannels
          ? _value.notificationChannels
          : notificationChannels // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
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
abstract class _$$ApprovalConfigImplCopyWith<$Res>
    implements $ApprovalConfigCopyWith<$Res> {
  factory _$$ApprovalConfigImplCopyWith(_$ApprovalConfigImpl value,
          $Res Function(_$ApprovalConfigImpl) then) =
      __$$ApprovalConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String requestType,
      String actionType,
      String? targetResourceType,
      int requiredApprovalLevel,
      bool canSkipLevels,
      Map<String, dynamic> skipLevelConditions,
      List<String> allowedInitiatorRoles,
      List<String> allowedApproverRoles,
      String defaultPriority,
      int? defaultExpirationHours,
      bool requiresMfa,
      bool autoExecute,
      List<String> notificationChannels,
      bool isActive,
      String? description,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$ApprovalConfigImplCopyWithImpl<$Res>
    extends _$ApprovalConfigCopyWithImpl<$Res, _$ApprovalConfigImpl>
    implements _$$ApprovalConfigImplCopyWith<$Res> {
  __$$ApprovalConfigImplCopyWithImpl(
      _$ApprovalConfigImpl _value, $Res Function(_$ApprovalConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? requestType = null,
    Object? actionType = null,
    Object? targetResourceType = freezed,
    Object? requiredApprovalLevel = null,
    Object? canSkipLevels = null,
    Object? skipLevelConditions = null,
    Object? allowedInitiatorRoles = null,
    Object? allowedApproverRoles = null,
    Object? defaultPriority = null,
    Object? defaultExpirationHours = freezed,
    Object? requiresMfa = null,
    Object? autoExecute = null,
    Object? notificationChannels = null,
    Object? isActive = null,
    Object? description = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ApprovalConfigImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      requestType: null == requestType
          ? _value.requestType
          : requestType // ignore: cast_nullable_to_non_nullable
              as String,
      actionType: null == actionType
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as String,
      targetResourceType: freezed == targetResourceType
          ? _value.targetResourceType
          : targetResourceType // ignore: cast_nullable_to_non_nullable
              as String?,
      requiredApprovalLevel: null == requiredApprovalLevel
          ? _value.requiredApprovalLevel
          : requiredApprovalLevel // ignore: cast_nullable_to_non_nullable
              as int,
      canSkipLevels: null == canSkipLevels
          ? _value.canSkipLevels
          : canSkipLevels // ignore: cast_nullable_to_non_nullable
              as bool,
      skipLevelConditions: null == skipLevelConditions
          ? _value._skipLevelConditions
          : skipLevelConditions // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      allowedInitiatorRoles: null == allowedInitiatorRoles
          ? _value._allowedInitiatorRoles
          : allowedInitiatorRoles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      allowedApproverRoles: null == allowedApproverRoles
          ? _value._allowedApproverRoles
          : allowedApproverRoles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      defaultPriority: null == defaultPriority
          ? _value.defaultPriority
          : defaultPriority // ignore: cast_nullable_to_non_nullable
              as String,
      defaultExpirationHours: freezed == defaultExpirationHours
          ? _value.defaultExpirationHours
          : defaultExpirationHours // ignore: cast_nullable_to_non_nullable
              as int?,
      requiresMfa: null == requiresMfa
          ? _value.requiresMfa
          : requiresMfa // ignore: cast_nullable_to_non_nullable
              as bool,
      autoExecute: null == autoExecute
          ? _value.autoExecute
          : autoExecute // ignore: cast_nullable_to_non_nullable
              as bool,
      notificationChannels: null == notificationChannels
          ? _value._notificationChannels
          : notificationChannels // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
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
class _$ApprovalConfigImpl implements _ApprovalConfig {
  const _$ApprovalConfigImpl(
      {required this.id,
      required this.requestType,
      required this.actionType,
      this.targetResourceType,
      required this.requiredApprovalLevel,
      this.canSkipLevels = false,
      final Map<String, dynamic> skipLevelConditions = const {},
      final List<String> allowedInitiatorRoles = const [],
      final List<String> allowedApproverRoles = const [],
      this.defaultPriority = 'normal',
      this.defaultExpirationHours,
      this.requiresMfa = false,
      this.autoExecute = true,
      final List<String> notificationChannels = const ['in_app', 'email'],
      this.isActive = true,
      this.description,
      required this.createdAt,
      required this.updatedAt})
      : _skipLevelConditions = skipLevelConditions,
        _allowedInitiatorRoles = allowedInitiatorRoles,
        _allowedApproverRoles = allowedApproverRoles,
        _notificationChannels = notificationChannels;

  factory _$ApprovalConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApprovalConfigImplFromJson(json);

  @override
  final String id;
  @override
  final String requestType;
  @override
  final String actionType;
  @override
  final String? targetResourceType;
  @override
  final int requiredApprovalLevel;
  @override
  @JsonKey()
  final bool canSkipLevels;
  final Map<String, dynamic> _skipLevelConditions;
  @override
  @JsonKey()
  Map<String, dynamic> get skipLevelConditions {
    if (_skipLevelConditions is EqualUnmodifiableMapView)
      return _skipLevelConditions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_skipLevelConditions);
  }

  final List<String> _allowedInitiatorRoles;
  @override
  @JsonKey()
  List<String> get allowedInitiatorRoles {
    if (_allowedInitiatorRoles is EqualUnmodifiableListView)
      return _allowedInitiatorRoles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allowedInitiatorRoles);
  }

  final List<String> _allowedApproverRoles;
  @override
  @JsonKey()
  List<String> get allowedApproverRoles {
    if (_allowedApproverRoles is EqualUnmodifiableListView)
      return _allowedApproverRoles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allowedApproverRoles);
  }

  @override
  @JsonKey()
  final String defaultPriority;
  @override
  final int? defaultExpirationHours;
  @override
  @JsonKey()
  final bool requiresMfa;
  @override
  @JsonKey()
  final bool autoExecute;
  final List<String> _notificationChannels;
  @override
  @JsonKey()
  List<String> get notificationChannels {
    if (_notificationChannels is EqualUnmodifiableListView)
      return _notificationChannels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notificationChannels);
  }

  @override
  @JsonKey()
  final bool isActive;
  @override
  final String? description;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ApprovalConfig(id: $id, requestType: $requestType, actionType: $actionType, targetResourceType: $targetResourceType, requiredApprovalLevel: $requiredApprovalLevel, canSkipLevels: $canSkipLevels, skipLevelConditions: $skipLevelConditions, allowedInitiatorRoles: $allowedInitiatorRoles, allowedApproverRoles: $allowedApproverRoles, defaultPriority: $defaultPriority, defaultExpirationHours: $defaultExpirationHours, requiresMfa: $requiresMfa, autoExecute: $autoExecute, notificationChannels: $notificationChannels, isActive: $isActive, description: $description, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApprovalConfigImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.requestType, requestType) ||
                other.requestType == requestType) &&
            (identical(other.actionType, actionType) ||
                other.actionType == actionType) &&
            (identical(other.targetResourceType, targetResourceType) ||
                other.targetResourceType == targetResourceType) &&
            (identical(other.requiredApprovalLevel, requiredApprovalLevel) ||
                other.requiredApprovalLevel == requiredApprovalLevel) &&
            (identical(other.canSkipLevels, canSkipLevels) ||
                other.canSkipLevels == canSkipLevels) &&
            const DeepCollectionEquality()
                .equals(other._skipLevelConditions, _skipLevelConditions) &&
            const DeepCollectionEquality()
                .equals(other._allowedInitiatorRoles, _allowedInitiatorRoles) &&
            const DeepCollectionEquality()
                .equals(other._allowedApproverRoles, _allowedApproverRoles) &&
            (identical(other.defaultPriority, defaultPriority) ||
                other.defaultPriority == defaultPriority) &&
            (identical(other.defaultExpirationHours, defaultExpirationHours) ||
                other.defaultExpirationHours == defaultExpirationHours) &&
            (identical(other.requiresMfa, requiresMfa) ||
                other.requiresMfa == requiresMfa) &&
            (identical(other.autoExecute, autoExecute) ||
                other.autoExecute == autoExecute) &&
            const DeepCollectionEquality()
                .equals(other._notificationChannels, _notificationChannels) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.description, description) ||
                other.description == description) &&
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
      requestType,
      actionType,
      targetResourceType,
      requiredApprovalLevel,
      canSkipLevels,
      const DeepCollectionEquality().hash(_skipLevelConditions),
      const DeepCollectionEquality().hash(_allowedInitiatorRoles),
      const DeepCollectionEquality().hash(_allowedApproverRoles),
      defaultPriority,
      defaultExpirationHours,
      requiresMfa,
      autoExecute,
      const DeepCollectionEquality().hash(_notificationChannels),
      isActive,
      description,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ApprovalConfigImplCopyWith<_$ApprovalConfigImpl> get copyWith =>
      __$$ApprovalConfigImplCopyWithImpl<_$ApprovalConfigImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApprovalConfigImplToJson(
      this,
    );
  }
}

abstract class _ApprovalConfig implements ApprovalConfig {
  const factory _ApprovalConfig(
      {required final String id,
      required final String requestType,
      required final String actionType,
      final String? targetResourceType,
      required final int requiredApprovalLevel,
      final bool canSkipLevels,
      final Map<String, dynamic> skipLevelConditions,
      final List<String> allowedInitiatorRoles,
      final List<String> allowedApproverRoles,
      final String defaultPriority,
      final int? defaultExpirationHours,
      final bool requiresMfa,
      final bool autoExecute,
      final List<String> notificationChannels,
      final bool isActive,
      final String? description,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$ApprovalConfigImpl;

  factory _ApprovalConfig.fromJson(Map<String, dynamic> json) =
      _$ApprovalConfigImpl.fromJson;

  @override
  String get id;
  @override
  String get requestType;
  @override
  String get actionType;
  @override
  String? get targetResourceType;
  @override
  int get requiredApprovalLevel;
  @override
  bool get canSkipLevels;
  @override
  Map<String, dynamic> get skipLevelConditions;
  @override
  List<String> get allowedInitiatorRoles;
  @override
  List<String> get allowedApproverRoles;
  @override
  String get defaultPriority;
  @override
  int? get defaultExpirationHours;
  @override
  bool get requiresMfa;
  @override
  bool get autoExecute;
  @override
  List<String> get notificationChannels;
  @override
  bool get isActive;
  @override
  String? get description;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ApprovalConfigImplCopyWith<_$ApprovalConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ApprovalStatistics _$ApprovalStatisticsFromJson(Map<String, dynamic> json) {
  return _ApprovalStatistics.fromJson(json);
}

/// @nodoc
mixin _$ApprovalStatistics {
  int get totalRequests => throw _privateConstructorUsedError;
  int get pendingRequests => throw _privateConstructorUsedError;
  int get underReviewRequests => throw _privateConstructorUsedError;
  int get awaitingInfoRequests => throw _privateConstructorUsedError;
  int get approvedRequests => throw _privateConstructorUsedError;
  int get deniedRequests => throw _privateConstructorUsedError;
  int get withdrawnRequests => throw _privateConstructorUsedError;
  int get expiredRequests => throw _privateConstructorUsedError;
  int get executedRequests => throw _privateConstructorUsedError;
  int get failedRequests => throw _privateConstructorUsedError;
  int get requestsToday => throw _privateConstructorUsedError;
  int get requestsThisWeek => throw _privateConstructorUsedError;
  int get requestsThisMonth => throw _privateConstructorUsedError;
  double? get avgApprovalTimeHours => throw _privateConstructorUsedError;
  double? get approvalRate => throw _privateConstructorUsedError;
  Map<String, int> get byRequestType => throw _privateConstructorUsedError;
  Map<String, int> get byActionType => throw _privateConstructorUsedError;
  Map<String, int> get byPriority => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ApprovalStatisticsCopyWith<ApprovalStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApprovalStatisticsCopyWith<$Res> {
  factory $ApprovalStatisticsCopyWith(
          ApprovalStatistics value, $Res Function(ApprovalStatistics) then) =
      _$ApprovalStatisticsCopyWithImpl<$Res, ApprovalStatistics>;
  @useResult
  $Res call(
      {int totalRequests,
      int pendingRequests,
      int underReviewRequests,
      int awaitingInfoRequests,
      int approvedRequests,
      int deniedRequests,
      int withdrawnRequests,
      int expiredRequests,
      int executedRequests,
      int failedRequests,
      int requestsToday,
      int requestsThisWeek,
      int requestsThisMonth,
      double? avgApprovalTimeHours,
      double? approvalRate,
      Map<String, int> byRequestType,
      Map<String, int> byActionType,
      Map<String, int> byPriority});
}

/// @nodoc
class _$ApprovalStatisticsCopyWithImpl<$Res, $Val extends ApprovalStatistics>
    implements $ApprovalStatisticsCopyWith<$Res> {
  _$ApprovalStatisticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalRequests = null,
    Object? pendingRequests = null,
    Object? underReviewRequests = null,
    Object? awaitingInfoRequests = null,
    Object? approvedRequests = null,
    Object? deniedRequests = null,
    Object? withdrawnRequests = null,
    Object? expiredRequests = null,
    Object? executedRequests = null,
    Object? failedRequests = null,
    Object? requestsToday = null,
    Object? requestsThisWeek = null,
    Object? requestsThisMonth = null,
    Object? avgApprovalTimeHours = freezed,
    Object? approvalRate = freezed,
    Object? byRequestType = null,
    Object? byActionType = null,
    Object? byPriority = null,
  }) {
    return _then(_value.copyWith(
      totalRequests: null == totalRequests
          ? _value.totalRequests
          : totalRequests // ignore: cast_nullable_to_non_nullable
              as int,
      pendingRequests: null == pendingRequests
          ? _value.pendingRequests
          : pendingRequests // ignore: cast_nullable_to_non_nullable
              as int,
      underReviewRequests: null == underReviewRequests
          ? _value.underReviewRequests
          : underReviewRequests // ignore: cast_nullable_to_non_nullable
              as int,
      awaitingInfoRequests: null == awaitingInfoRequests
          ? _value.awaitingInfoRequests
          : awaitingInfoRequests // ignore: cast_nullable_to_non_nullable
              as int,
      approvedRequests: null == approvedRequests
          ? _value.approvedRequests
          : approvedRequests // ignore: cast_nullable_to_non_nullable
              as int,
      deniedRequests: null == deniedRequests
          ? _value.deniedRequests
          : deniedRequests // ignore: cast_nullable_to_non_nullable
              as int,
      withdrawnRequests: null == withdrawnRequests
          ? _value.withdrawnRequests
          : withdrawnRequests // ignore: cast_nullable_to_non_nullable
              as int,
      expiredRequests: null == expiredRequests
          ? _value.expiredRequests
          : expiredRequests // ignore: cast_nullable_to_non_nullable
              as int,
      executedRequests: null == executedRequests
          ? _value.executedRequests
          : executedRequests // ignore: cast_nullable_to_non_nullable
              as int,
      failedRequests: null == failedRequests
          ? _value.failedRequests
          : failedRequests // ignore: cast_nullable_to_non_nullable
              as int,
      requestsToday: null == requestsToday
          ? _value.requestsToday
          : requestsToday // ignore: cast_nullable_to_non_nullable
              as int,
      requestsThisWeek: null == requestsThisWeek
          ? _value.requestsThisWeek
          : requestsThisWeek // ignore: cast_nullable_to_non_nullable
              as int,
      requestsThisMonth: null == requestsThisMonth
          ? _value.requestsThisMonth
          : requestsThisMonth // ignore: cast_nullable_to_non_nullable
              as int,
      avgApprovalTimeHours: freezed == avgApprovalTimeHours
          ? _value.avgApprovalTimeHours
          : avgApprovalTimeHours // ignore: cast_nullable_to_non_nullable
              as double?,
      approvalRate: freezed == approvalRate
          ? _value.approvalRate
          : approvalRate // ignore: cast_nullable_to_non_nullable
              as double?,
      byRequestType: null == byRequestType
          ? _value.byRequestType
          : byRequestType // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      byActionType: null == byActionType
          ? _value.byActionType
          : byActionType // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      byPriority: null == byPriority
          ? _value.byPriority
          : byPriority // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApprovalStatisticsImplCopyWith<$Res>
    implements $ApprovalStatisticsCopyWith<$Res> {
  factory _$$ApprovalStatisticsImplCopyWith(_$ApprovalStatisticsImpl value,
          $Res Function(_$ApprovalStatisticsImpl) then) =
      __$$ApprovalStatisticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalRequests,
      int pendingRequests,
      int underReviewRequests,
      int awaitingInfoRequests,
      int approvedRequests,
      int deniedRequests,
      int withdrawnRequests,
      int expiredRequests,
      int executedRequests,
      int failedRequests,
      int requestsToday,
      int requestsThisWeek,
      int requestsThisMonth,
      double? avgApprovalTimeHours,
      double? approvalRate,
      Map<String, int> byRequestType,
      Map<String, int> byActionType,
      Map<String, int> byPriority});
}

/// @nodoc
class __$$ApprovalStatisticsImplCopyWithImpl<$Res>
    extends _$ApprovalStatisticsCopyWithImpl<$Res, _$ApprovalStatisticsImpl>
    implements _$$ApprovalStatisticsImplCopyWith<$Res> {
  __$$ApprovalStatisticsImplCopyWithImpl(_$ApprovalStatisticsImpl _value,
      $Res Function(_$ApprovalStatisticsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalRequests = null,
    Object? pendingRequests = null,
    Object? underReviewRequests = null,
    Object? awaitingInfoRequests = null,
    Object? approvedRequests = null,
    Object? deniedRequests = null,
    Object? withdrawnRequests = null,
    Object? expiredRequests = null,
    Object? executedRequests = null,
    Object? failedRequests = null,
    Object? requestsToday = null,
    Object? requestsThisWeek = null,
    Object? requestsThisMonth = null,
    Object? avgApprovalTimeHours = freezed,
    Object? approvalRate = freezed,
    Object? byRequestType = null,
    Object? byActionType = null,
    Object? byPriority = null,
  }) {
    return _then(_$ApprovalStatisticsImpl(
      totalRequests: null == totalRequests
          ? _value.totalRequests
          : totalRequests // ignore: cast_nullable_to_non_nullable
              as int,
      pendingRequests: null == pendingRequests
          ? _value.pendingRequests
          : pendingRequests // ignore: cast_nullable_to_non_nullable
              as int,
      underReviewRequests: null == underReviewRequests
          ? _value.underReviewRequests
          : underReviewRequests // ignore: cast_nullable_to_non_nullable
              as int,
      awaitingInfoRequests: null == awaitingInfoRequests
          ? _value.awaitingInfoRequests
          : awaitingInfoRequests // ignore: cast_nullable_to_non_nullable
              as int,
      approvedRequests: null == approvedRequests
          ? _value.approvedRequests
          : approvedRequests // ignore: cast_nullable_to_non_nullable
              as int,
      deniedRequests: null == deniedRequests
          ? _value.deniedRequests
          : deniedRequests // ignore: cast_nullable_to_non_nullable
              as int,
      withdrawnRequests: null == withdrawnRequests
          ? _value.withdrawnRequests
          : withdrawnRequests // ignore: cast_nullable_to_non_nullable
              as int,
      expiredRequests: null == expiredRequests
          ? _value.expiredRequests
          : expiredRequests // ignore: cast_nullable_to_non_nullable
              as int,
      executedRequests: null == executedRequests
          ? _value.executedRequests
          : executedRequests // ignore: cast_nullable_to_non_nullable
              as int,
      failedRequests: null == failedRequests
          ? _value.failedRequests
          : failedRequests // ignore: cast_nullable_to_non_nullable
              as int,
      requestsToday: null == requestsToday
          ? _value.requestsToday
          : requestsToday // ignore: cast_nullable_to_non_nullable
              as int,
      requestsThisWeek: null == requestsThisWeek
          ? _value.requestsThisWeek
          : requestsThisWeek // ignore: cast_nullable_to_non_nullable
              as int,
      requestsThisMonth: null == requestsThisMonth
          ? _value.requestsThisMonth
          : requestsThisMonth // ignore: cast_nullable_to_non_nullable
              as int,
      avgApprovalTimeHours: freezed == avgApprovalTimeHours
          ? _value.avgApprovalTimeHours
          : avgApprovalTimeHours // ignore: cast_nullable_to_non_nullable
              as double?,
      approvalRate: freezed == approvalRate
          ? _value.approvalRate
          : approvalRate // ignore: cast_nullable_to_non_nullable
              as double?,
      byRequestType: null == byRequestType
          ? _value._byRequestType
          : byRequestType // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      byActionType: null == byActionType
          ? _value._byActionType
          : byActionType // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      byPriority: null == byPriority
          ? _value._byPriority
          : byPriority // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApprovalStatisticsImpl implements _ApprovalStatistics {
  const _$ApprovalStatisticsImpl(
      {this.totalRequests = 0,
      this.pendingRequests = 0,
      this.underReviewRequests = 0,
      this.awaitingInfoRequests = 0,
      this.approvedRequests = 0,
      this.deniedRequests = 0,
      this.withdrawnRequests = 0,
      this.expiredRequests = 0,
      this.executedRequests = 0,
      this.failedRequests = 0,
      this.requestsToday = 0,
      this.requestsThisWeek = 0,
      this.requestsThisMonth = 0,
      this.avgApprovalTimeHours,
      this.approvalRate,
      final Map<String, int> byRequestType = const {},
      final Map<String, int> byActionType = const {},
      final Map<String, int> byPriority = const {}})
      : _byRequestType = byRequestType,
        _byActionType = byActionType,
        _byPriority = byPriority;

  factory _$ApprovalStatisticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApprovalStatisticsImplFromJson(json);

  @override
  @JsonKey()
  final int totalRequests;
  @override
  @JsonKey()
  final int pendingRequests;
  @override
  @JsonKey()
  final int underReviewRequests;
  @override
  @JsonKey()
  final int awaitingInfoRequests;
  @override
  @JsonKey()
  final int approvedRequests;
  @override
  @JsonKey()
  final int deniedRequests;
  @override
  @JsonKey()
  final int withdrawnRequests;
  @override
  @JsonKey()
  final int expiredRequests;
  @override
  @JsonKey()
  final int executedRequests;
  @override
  @JsonKey()
  final int failedRequests;
  @override
  @JsonKey()
  final int requestsToday;
  @override
  @JsonKey()
  final int requestsThisWeek;
  @override
  @JsonKey()
  final int requestsThisMonth;
  @override
  final double? avgApprovalTimeHours;
  @override
  final double? approvalRate;
  final Map<String, int> _byRequestType;
  @override
  @JsonKey()
  Map<String, int> get byRequestType {
    if (_byRequestType is EqualUnmodifiableMapView) return _byRequestType;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_byRequestType);
  }

  final Map<String, int> _byActionType;
  @override
  @JsonKey()
  Map<String, int> get byActionType {
    if (_byActionType is EqualUnmodifiableMapView) return _byActionType;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_byActionType);
  }

  final Map<String, int> _byPriority;
  @override
  @JsonKey()
  Map<String, int> get byPriority {
    if (_byPriority is EqualUnmodifiableMapView) return _byPriority;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_byPriority);
  }

  @override
  String toString() {
    return 'ApprovalStatistics(totalRequests: $totalRequests, pendingRequests: $pendingRequests, underReviewRequests: $underReviewRequests, awaitingInfoRequests: $awaitingInfoRequests, approvedRequests: $approvedRequests, deniedRequests: $deniedRequests, withdrawnRequests: $withdrawnRequests, expiredRequests: $expiredRequests, executedRequests: $executedRequests, failedRequests: $failedRequests, requestsToday: $requestsToday, requestsThisWeek: $requestsThisWeek, requestsThisMonth: $requestsThisMonth, avgApprovalTimeHours: $avgApprovalTimeHours, approvalRate: $approvalRate, byRequestType: $byRequestType, byActionType: $byActionType, byPriority: $byPriority)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApprovalStatisticsImpl &&
            (identical(other.totalRequests, totalRequests) ||
                other.totalRequests == totalRequests) &&
            (identical(other.pendingRequests, pendingRequests) ||
                other.pendingRequests == pendingRequests) &&
            (identical(other.underReviewRequests, underReviewRequests) ||
                other.underReviewRequests == underReviewRequests) &&
            (identical(other.awaitingInfoRequests, awaitingInfoRequests) ||
                other.awaitingInfoRequests == awaitingInfoRequests) &&
            (identical(other.approvedRequests, approvedRequests) ||
                other.approvedRequests == approvedRequests) &&
            (identical(other.deniedRequests, deniedRequests) ||
                other.deniedRequests == deniedRequests) &&
            (identical(other.withdrawnRequests, withdrawnRequests) ||
                other.withdrawnRequests == withdrawnRequests) &&
            (identical(other.expiredRequests, expiredRequests) ||
                other.expiredRequests == expiredRequests) &&
            (identical(other.executedRequests, executedRequests) ||
                other.executedRequests == executedRequests) &&
            (identical(other.failedRequests, failedRequests) ||
                other.failedRequests == failedRequests) &&
            (identical(other.requestsToday, requestsToday) ||
                other.requestsToday == requestsToday) &&
            (identical(other.requestsThisWeek, requestsThisWeek) ||
                other.requestsThisWeek == requestsThisWeek) &&
            (identical(other.requestsThisMonth, requestsThisMonth) ||
                other.requestsThisMonth == requestsThisMonth) &&
            (identical(other.avgApprovalTimeHours, avgApprovalTimeHours) ||
                other.avgApprovalTimeHours == avgApprovalTimeHours) &&
            (identical(other.approvalRate, approvalRate) ||
                other.approvalRate == approvalRate) &&
            const DeepCollectionEquality()
                .equals(other._byRequestType, _byRequestType) &&
            const DeepCollectionEquality()
                .equals(other._byActionType, _byActionType) &&
            const DeepCollectionEquality()
                .equals(other._byPriority, _byPriority));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalRequests,
      pendingRequests,
      underReviewRequests,
      awaitingInfoRequests,
      approvedRequests,
      deniedRequests,
      withdrawnRequests,
      expiredRequests,
      executedRequests,
      failedRequests,
      requestsToday,
      requestsThisWeek,
      requestsThisMonth,
      avgApprovalTimeHours,
      approvalRate,
      const DeepCollectionEquality().hash(_byRequestType),
      const DeepCollectionEquality().hash(_byActionType),
      const DeepCollectionEquality().hash(_byPriority));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ApprovalStatisticsImplCopyWith<_$ApprovalStatisticsImpl> get copyWith =>
      __$$ApprovalStatisticsImplCopyWithImpl<_$ApprovalStatisticsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApprovalStatisticsImplToJson(
      this,
    );
  }
}

abstract class _ApprovalStatistics implements ApprovalStatistics {
  const factory _ApprovalStatistics(
      {final int totalRequests,
      final int pendingRequests,
      final int underReviewRequests,
      final int awaitingInfoRequests,
      final int approvedRequests,
      final int deniedRequests,
      final int withdrawnRequests,
      final int expiredRequests,
      final int executedRequests,
      final int failedRequests,
      final int requestsToday,
      final int requestsThisWeek,
      final int requestsThisMonth,
      final double? avgApprovalTimeHours,
      final double? approvalRate,
      final Map<String, int> byRequestType,
      final Map<String, int> byActionType,
      final Map<String, int> byPriority}) = _$ApprovalStatisticsImpl;

  factory _ApprovalStatistics.fromJson(Map<String, dynamic> json) =
      _$ApprovalStatisticsImpl.fromJson;

  @override
  int get totalRequests;
  @override
  int get pendingRequests;
  @override
  int get underReviewRequests;
  @override
  int get awaitingInfoRequests;
  @override
  int get approvedRequests;
  @override
  int get deniedRequests;
  @override
  int get withdrawnRequests;
  @override
  int get expiredRequests;
  @override
  int get executedRequests;
  @override
  int get failedRequests;
  @override
  int get requestsToday;
  @override
  int get requestsThisWeek;
  @override
  int get requestsThisMonth;
  @override
  double? get avgApprovalTimeHours;
  @override
  double? get approvalRate;
  @override
  Map<String, int> get byRequestType;
  @override
  Map<String, int> get byActionType;
  @override
  Map<String, int> get byPriority;
  @override
  @JsonKey(ignore: true)
  _$$ApprovalStatisticsImplCopyWith<_$ApprovalStatisticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PendingApprovalItem _$PendingApprovalItemFromJson(Map<String, dynamic> json) {
  return _PendingApprovalItem.fromJson(json);
}

/// @nodoc
mixin _$PendingApprovalItem {
  String get id => throw _privateConstructorUsedError;
  String get requestNumber => throw _privateConstructorUsedError;
  String get requestType => throw _privateConstructorUsedError;
  String get actionType => throw _privateConstructorUsedError;
  String get priority => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get initiatedBy => throw _privateConstructorUsedError;
  String? get initiatorName => throw _privateConstructorUsedError;
  String get targetResourceType => throw _privateConstructorUsedError;
  int get currentApprovalLevel => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PendingApprovalItemCopyWith<PendingApprovalItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PendingApprovalItemCopyWith<$Res> {
  factory $PendingApprovalItemCopyWith(
          PendingApprovalItem value, $Res Function(PendingApprovalItem) then) =
      _$PendingApprovalItemCopyWithImpl<$Res, PendingApprovalItem>;
  @useResult
  $Res call(
      {String id,
      String requestNumber,
      String requestType,
      String actionType,
      String priority,
      String status,
      String initiatedBy,
      String? initiatorName,
      String targetResourceType,
      int currentApprovalLevel,
      DateTime createdAt,
      DateTime? expiresAt});
}

/// @nodoc
class _$PendingApprovalItemCopyWithImpl<$Res, $Val extends PendingApprovalItem>
    implements $PendingApprovalItemCopyWith<$Res> {
  _$PendingApprovalItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? requestNumber = null,
    Object? requestType = null,
    Object? actionType = null,
    Object? priority = null,
    Object? status = null,
    Object? initiatedBy = null,
    Object? initiatorName = freezed,
    Object? targetResourceType = null,
    Object? currentApprovalLevel = null,
    Object? createdAt = null,
    Object? expiresAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      requestNumber: null == requestNumber
          ? _value.requestNumber
          : requestNumber // ignore: cast_nullable_to_non_nullable
              as String,
      requestType: null == requestType
          ? _value.requestType
          : requestType // ignore: cast_nullable_to_non_nullable
              as String,
      actionType: null == actionType
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      initiatedBy: null == initiatedBy
          ? _value.initiatedBy
          : initiatedBy // ignore: cast_nullable_to_non_nullable
              as String,
      initiatorName: freezed == initiatorName
          ? _value.initiatorName
          : initiatorName // ignore: cast_nullable_to_non_nullable
              as String?,
      targetResourceType: null == targetResourceType
          ? _value.targetResourceType
          : targetResourceType // ignore: cast_nullable_to_non_nullable
              as String,
      currentApprovalLevel: null == currentApprovalLevel
          ? _value.currentApprovalLevel
          : currentApprovalLevel // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PendingApprovalItemImplCopyWith<$Res>
    implements $PendingApprovalItemCopyWith<$Res> {
  factory _$$PendingApprovalItemImplCopyWith(_$PendingApprovalItemImpl value,
          $Res Function(_$PendingApprovalItemImpl) then) =
      __$$PendingApprovalItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String requestNumber,
      String requestType,
      String actionType,
      String priority,
      String status,
      String initiatedBy,
      String? initiatorName,
      String targetResourceType,
      int currentApprovalLevel,
      DateTime createdAt,
      DateTime? expiresAt});
}

/// @nodoc
class __$$PendingApprovalItemImplCopyWithImpl<$Res>
    extends _$PendingApprovalItemCopyWithImpl<$Res, _$PendingApprovalItemImpl>
    implements _$$PendingApprovalItemImplCopyWith<$Res> {
  __$$PendingApprovalItemImplCopyWithImpl(_$PendingApprovalItemImpl _value,
      $Res Function(_$PendingApprovalItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? requestNumber = null,
    Object? requestType = null,
    Object? actionType = null,
    Object? priority = null,
    Object? status = null,
    Object? initiatedBy = null,
    Object? initiatorName = freezed,
    Object? targetResourceType = null,
    Object? currentApprovalLevel = null,
    Object? createdAt = null,
    Object? expiresAt = freezed,
  }) {
    return _then(_$PendingApprovalItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      requestNumber: null == requestNumber
          ? _value.requestNumber
          : requestNumber // ignore: cast_nullable_to_non_nullable
              as String,
      requestType: null == requestType
          ? _value.requestType
          : requestType // ignore: cast_nullable_to_non_nullable
              as String,
      actionType: null == actionType
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      initiatedBy: null == initiatedBy
          ? _value.initiatedBy
          : initiatedBy // ignore: cast_nullable_to_non_nullable
              as String,
      initiatorName: freezed == initiatorName
          ? _value.initiatorName
          : initiatorName // ignore: cast_nullable_to_non_nullable
              as String?,
      targetResourceType: null == targetResourceType
          ? _value.targetResourceType
          : targetResourceType // ignore: cast_nullable_to_non_nullable
              as String,
      currentApprovalLevel: null == currentApprovalLevel
          ? _value.currentApprovalLevel
          : currentApprovalLevel // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PendingApprovalItemImpl implements _PendingApprovalItem {
  const _$PendingApprovalItemImpl(
      {required this.id,
      required this.requestNumber,
      required this.requestType,
      required this.actionType,
      required this.priority,
      required this.status,
      required this.initiatedBy,
      this.initiatorName,
      required this.targetResourceType,
      required this.currentApprovalLevel,
      required this.createdAt,
      this.expiresAt});

  factory _$PendingApprovalItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$PendingApprovalItemImplFromJson(json);

  @override
  final String id;
  @override
  final String requestNumber;
  @override
  final String requestType;
  @override
  final String actionType;
  @override
  final String priority;
  @override
  final String status;
  @override
  final String initiatedBy;
  @override
  final String? initiatorName;
  @override
  final String targetResourceType;
  @override
  final int currentApprovalLevel;
  @override
  final DateTime createdAt;
  @override
  final DateTime? expiresAt;

  @override
  String toString() {
    return 'PendingApprovalItem(id: $id, requestNumber: $requestNumber, requestType: $requestType, actionType: $actionType, priority: $priority, status: $status, initiatedBy: $initiatedBy, initiatorName: $initiatorName, targetResourceType: $targetResourceType, currentApprovalLevel: $currentApprovalLevel, createdAt: $createdAt, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PendingApprovalItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.requestNumber, requestNumber) ||
                other.requestNumber == requestNumber) &&
            (identical(other.requestType, requestType) ||
                other.requestType == requestType) &&
            (identical(other.actionType, actionType) ||
                other.actionType == actionType) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.initiatedBy, initiatedBy) ||
                other.initiatedBy == initiatedBy) &&
            (identical(other.initiatorName, initiatorName) ||
                other.initiatorName == initiatorName) &&
            (identical(other.targetResourceType, targetResourceType) ||
                other.targetResourceType == targetResourceType) &&
            (identical(other.currentApprovalLevel, currentApprovalLevel) ||
                other.currentApprovalLevel == currentApprovalLevel) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      requestNumber,
      requestType,
      actionType,
      priority,
      status,
      initiatedBy,
      initiatorName,
      targetResourceType,
      currentApprovalLevel,
      createdAt,
      expiresAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PendingApprovalItemImplCopyWith<_$PendingApprovalItemImpl> get copyWith =>
      __$$PendingApprovalItemImplCopyWithImpl<_$PendingApprovalItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PendingApprovalItemImplToJson(
      this,
    );
  }
}

abstract class _PendingApprovalItem implements PendingApprovalItem {
  const factory _PendingApprovalItem(
      {required final String id,
      required final String requestNumber,
      required final String requestType,
      required final String actionType,
      required final String priority,
      required final String status,
      required final String initiatedBy,
      final String? initiatorName,
      required final String targetResourceType,
      required final int currentApprovalLevel,
      required final DateTime createdAt,
      final DateTime? expiresAt}) = _$PendingApprovalItemImpl;

  factory _PendingApprovalItem.fromJson(Map<String, dynamic> json) =
      _$PendingApprovalItemImpl.fromJson;

  @override
  String get id;
  @override
  String get requestNumber;
  @override
  String get requestType;
  @override
  String get actionType;
  @override
  String get priority;
  @override
  String get status;
  @override
  String get initiatedBy;
  @override
  String? get initiatorName;
  @override
  String get targetResourceType;
  @override
  int get currentApprovalLevel;
  @override
  DateTime get createdAt;
  @override
  DateTime? get expiresAt;
  @override
  @JsonKey(ignore: true)
  _$$PendingApprovalItemImplCopyWith<_$PendingApprovalItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MyPendingActionsResponse _$MyPendingActionsResponseFromJson(
    Map<String, dynamic> json) {
  return _MyPendingActionsResponse.fromJson(json);
}

/// @nodoc
mixin _$MyPendingActionsResponse {
  List<PendingApprovalItem> get pendingReviews =>
      throw _privateConstructorUsedError;
  List<PendingApprovalItem> get awaitingMyInfo =>
      throw _privateConstructorUsedError;
  List<PendingApprovalItem> get delegatedToMe =>
      throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MyPendingActionsResponseCopyWith<MyPendingActionsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MyPendingActionsResponseCopyWith<$Res> {
  factory $MyPendingActionsResponseCopyWith(MyPendingActionsResponse value,
          $Res Function(MyPendingActionsResponse) then) =
      _$MyPendingActionsResponseCopyWithImpl<$Res, MyPendingActionsResponse>;
  @useResult
  $Res call(
      {List<PendingApprovalItem> pendingReviews,
      List<PendingApprovalItem> awaitingMyInfo,
      List<PendingApprovalItem> delegatedToMe,
      int total});
}

/// @nodoc
class _$MyPendingActionsResponseCopyWithImpl<$Res,
        $Val extends MyPendingActionsResponse>
    implements $MyPendingActionsResponseCopyWith<$Res> {
  _$MyPendingActionsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pendingReviews = null,
    Object? awaitingMyInfo = null,
    Object? delegatedToMe = null,
    Object? total = null,
  }) {
    return _then(_value.copyWith(
      pendingReviews: null == pendingReviews
          ? _value.pendingReviews
          : pendingReviews // ignore: cast_nullable_to_non_nullable
              as List<PendingApprovalItem>,
      awaitingMyInfo: null == awaitingMyInfo
          ? _value.awaitingMyInfo
          : awaitingMyInfo // ignore: cast_nullable_to_non_nullable
              as List<PendingApprovalItem>,
      delegatedToMe: null == delegatedToMe
          ? _value.delegatedToMe
          : delegatedToMe // ignore: cast_nullable_to_non_nullable
              as List<PendingApprovalItem>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MyPendingActionsResponseImplCopyWith<$Res>
    implements $MyPendingActionsResponseCopyWith<$Res> {
  factory _$$MyPendingActionsResponseImplCopyWith(
          _$MyPendingActionsResponseImpl value,
          $Res Function(_$MyPendingActionsResponseImpl) then) =
      __$$MyPendingActionsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<PendingApprovalItem> pendingReviews,
      List<PendingApprovalItem> awaitingMyInfo,
      List<PendingApprovalItem> delegatedToMe,
      int total});
}

/// @nodoc
class __$$MyPendingActionsResponseImplCopyWithImpl<$Res>
    extends _$MyPendingActionsResponseCopyWithImpl<$Res,
        _$MyPendingActionsResponseImpl>
    implements _$$MyPendingActionsResponseImplCopyWith<$Res> {
  __$$MyPendingActionsResponseImplCopyWithImpl(
      _$MyPendingActionsResponseImpl _value,
      $Res Function(_$MyPendingActionsResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pendingReviews = null,
    Object? awaitingMyInfo = null,
    Object? delegatedToMe = null,
    Object? total = null,
  }) {
    return _then(_$MyPendingActionsResponseImpl(
      pendingReviews: null == pendingReviews
          ? _value._pendingReviews
          : pendingReviews // ignore: cast_nullable_to_non_nullable
              as List<PendingApprovalItem>,
      awaitingMyInfo: null == awaitingMyInfo
          ? _value._awaitingMyInfo
          : awaitingMyInfo // ignore: cast_nullable_to_non_nullable
              as List<PendingApprovalItem>,
      delegatedToMe: null == delegatedToMe
          ? _value._delegatedToMe
          : delegatedToMe // ignore: cast_nullable_to_non_nullable
              as List<PendingApprovalItem>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MyPendingActionsResponseImpl implements _MyPendingActionsResponse {
  const _$MyPendingActionsResponseImpl(
      {final List<PendingApprovalItem> pendingReviews = const [],
      final List<PendingApprovalItem> awaitingMyInfo = const [],
      final List<PendingApprovalItem> delegatedToMe = const [],
      this.total = 0})
      : _pendingReviews = pendingReviews,
        _awaitingMyInfo = awaitingMyInfo,
        _delegatedToMe = delegatedToMe;

  factory _$MyPendingActionsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$MyPendingActionsResponseImplFromJson(json);

  final List<PendingApprovalItem> _pendingReviews;
  @override
  @JsonKey()
  List<PendingApprovalItem> get pendingReviews {
    if (_pendingReviews is EqualUnmodifiableListView) return _pendingReviews;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pendingReviews);
  }

  final List<PendingApprovalItem> _awaitingMyInfo;
  @override
  @JsonKey()
  List<PendingApprovalItem> get awaitingMyInfo {
    if (_awaitingMyInfo is EqualUnmodifiableListView) return _awaitingMyInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_awaitingMyInfo);
  }

  final List<PendingApprovalItem> _delegatedToMe;
  @override
  @JsonKey()
  List<PendingApprovalItem> get delegatedToMe {
    if (_delegatedToMe is EqualUnmodifiableListView) return _delegatedToMe;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_delegatedToMe);
  }

  @override
  @JsonKey()
  final int total;

  @override
  String toString() {
    return 'MyPendingActionsResponse(pendingReviews: $pendingReviews, awaitingMyInfo: $awaitingMyInfo, delegatedToMe: $delegatedToMe, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MyPendingActionsResponseImpl &&
            const DeepCollectionEquality()
                .equals(other._pendingReviews, _pendingReviews) &&
            const DeepCollectionEquality()
                .equals(other._awaitingMyInfo, _awaitingMyInfo) &&
            const DeepCollectionEquality()
                .equals(other._delegatedToMe, _delegatedToMe) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_pendingReviews),
      const DeepCollectionEquality().hash(_awaitingMyInfo),
      const DeepCollectionEquality().hash(_delegatedToMe),
      total);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MyPendingActionsResponseImplCopyWith<_$MyPendingActionsResponseImpl>
      get copyWith => __$$MyPendingActionsResponseImplCopyWithImpl<
          _$MyPendingActionsResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MyPendingActionsResponseImplToJson(
      this,
    );
  }
}

abstract class _MyPendingActionsResponse implements MyPendingActionsResponse {
  const factory _MyPendingActionsResponse(
      {final List<PendingApprovalItem> pendingReviews,
      final List<PendingApprovalItem> awaitingMyInfo,
      final List<PendingApprovalItem> delegatedToMe,
      final int total}) = _$MyPendingActionsResponseImpl;

  factory _MyPendingActionsResponse.fromJson(Map<String, dynamic> json) =
      _$MyPendingActionsResponseImpl.fromJson;

  @override
  List<PendingApprovalItem> get pendingReviews;
  @override
  List<PendingApprovalItem> get awaitingMyInfo;
  @override
  List<PendingApprovalItem> get delegatedToMe;
  @override
  int get total;
  @override
  @JsonKey(ignore: true)
  _$$MyPendingActionsResponseImplCopyWith<_$MyPendingActionsResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ApprovalAuditLogEntry _$ApprovalAuditLogEntryFromJson(
    Map<String, dynamic> json) {
  return _ApprovalAuditLogEntry.fromJson(json);
}

/// @nodoc
mixin _$ApprovalAuditLogEntry {
  String get id => throw _privateConstructorUsedError;
  String get requestId => throw _privateConstructorUsedError;
  String get actorId => throw _privateConstructorUsedError;
  String get actorRole => throw _privateConstructorUsedError;
  String get eventType => throw _privateConstructorUsedError;
  String? get eventDescription => throw _privateConstructorUsedError;
  Map<String, dynamic>? get previousState => throw _privateConstructorUsedError;
  Map<String, dynamic>? get newState => throw _privateConstructorUsedError;
  String? get ipAddress => throw _privateConstructorUsedError;
  String? get userAgent => throw _privateConstructorUsedError;
  String? get sessionId => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  String? get actorName => throw _privateConstructorUsedError;
  String? get actorEmail => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ApprovalAuditLogEntryCopyWith<ApprovalAuditLogEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApprovalAuditLogEntryCopyWith<$Res> {
  factory $ApprovalAuditLogEntryCopyWith(ApprovalAuditLogEntry value,
          $Res Function(ApprovalAuditLogEntry) then) =
      _$ApprovalAuditLogEntryCopyWithImpl<$Res, ApprovalAuditLogEntry>;
  @useResult
  $Res call(
      {String id,
      String requestId,
      String actorId,
      String actorRole,
      String eventType,
      String? eventDescription,
      Map<String, dynamic>? previousState,
      Map<String, dynamic>? newState,
      String? ipAddress,
      String? userAgent,
      String? sessionId,
      DateTime timestamp,
      String? actorName,
      String? actorEmail});
}

/// @nodoc
class _$ApprovalAuditLogEntryCopyWithImpl<$Res,
        $Val extends ApprovalAuditLogEntry>
    implements $ApprovalAuditLogEntryCopyWith<$Res> {
  _$ApprovalAuditLogEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? requestId = null,
    Object? actorId = null,
    Object? actorRole = null,
    Object? eventType = null,
    Object? eventDescription = freezed,
    Object? previousState = freezed,
    Object? newState = freezed,
    Object? ipAddress = freezed,
    Object? userAgent = freezed,
    Object? sessionId = freezed,
    Object? timestamp = null,
    Object? actorName = freezed,
    Object? actorEmail = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      requestId: null == requestId
          ? _value.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String,
      actorId: null == actorId
          ? _value.actorId
          : actorId // ignore: cast_nullable_to_non_nullable
              as String,
      actorRole: null == actorRole
          ? _value.actorRole
          : actorRole // ignore: cast_nullable_to_non_nullable
              as String,
      eventType: null == eventType
          ? _value.eventType
          : eventType // ignore: cast_nullable_to_non_nullable
              as String,
      eventDescription: freezed == eventDescription
          ? _value.eventDescription
          : eventDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      previousState: freezed == previousState
          ? _value.previousState
          : previousState // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      newState: freezed == newState
          ? _value.newState
          : newState // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      ipAddress: freezed == ipAddress
          ? _value.ipAddress
          : ipAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      userAgent: freezed == userAgent
          ? _value.userAgent
          : userAgent // ignore: cast_nullable_to_non_nullable
              as String?,
      sessionId: freezed == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      actorName: freezed == actorName
          ? _value.actorName
          : actorName // ignore: cast_nullable_to_non_nullable
              as String?,
      actorEmail: freezed == actorEmail
          ? _value.actorEmail
          : actorEmail // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApprovalAuditLogEntryImplCopyWith<$Res>
    implements $ApprovalAuditLogEntryCopyWith<$Res> {
  factory _$$ApprovalAuditLogEntryImplCopyWith(
          _$ApprovalAuditLogEntryImpl value,
          $Res Function(_$ApprovalAuditLogEntryImpl) then) =
      __$$ApprovalAuditLogEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String requestId,
      String actorId,
      String actorRole,
      String eventType,
      String? eventDescription,
      Map<String, dynamic>? previousState,
      Map<String, dynamic>? newState,
      String? ipAddress,
      String? userAgent,
      String? sessionId,
      DateTime timestamp,
      String? actorName,
      String? actorEmail});
}

/// @nodoc
class __$$ApprovalAuditLogEntryImplCopyWithImpl<$Res>
    extends _$ApprovalAuditLogEntryCopyWithImpl<$Res,
        _$ApprovalAuditLogEntryImpl>
    implements _$$ApprovalAuditLogEntryImplCopyWith<$Res> {
  __$$ApprovalAuditLogEntryImplCopyWithImpl(_$ApprovalAuditLogEntryImpl _value,
      $Res Function(_$ApprovalAuditLogEntryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? requestId = null,
    Object? actorId = null,
    Object? actorRole = null,
    Object? eventType = null,
    Object? eventDescription = freezed,
    Object? previousState = freezed,
    Object? newState = freezed,
    Object? ipAddress = freezed,
    Object? userAgent = freezed,
    Object? sessionId = freezed,
    Object? timestamp = null,
    Object? actorName = freezed,
    Object? actorEmail = freezed,
  }) {
    return _then(_$ApprovalAuditLogEntryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      requestId: null == requestId
          ? _value.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String,
      actorId: null == actorId
          ? _value.actorId
          : actorId // ignore: cast_nullable_to_non_nullable
              as String,
      actorRole: null == actorRole
          ? _value.actorRole
          : actorRole // ignore: cast_nullable_to_non_nullable
              as String,
      eventType: null == eventType
          ? _value.eventType
          : eventType // ignore: cast_nullable_to_non_nullable
              as String,
      eventDescription: freezed == eventDescription
          ? _value.eventDescription
          : eventDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      previousState: freezed == previousState
          ? _value._previousState
          : previousState // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      newState: freezed == newState
          ? _value._newState
          : newState // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      ipAddress: freezed == ipAddress
          ? _value.ipAddress
          : ipAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      userAgent: freezed == userAgent
          ? _value.userAgent
          : userAgent // ignore: cast_nullable_to_non_nullable
              as String?,
      sessionId: freezed == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      actorName: freezed == actorName
          ? _value.actorName
          : actorName // ignore: cast_nullable_to_non_nullable
              as String?,
      actorEmail: freezed == actorEmail
          ? _value.actorEmail
          : actorEmail // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApprovalAuditLogEntryImpl implements _ApprovalAuditLogEntry {
  const _$ApprovalAuditLogEntryImpl(
      {required this.id,
      required this.requestId,
      required this.actorId,
      required this.actorRole,
      required this.eventType,
      this.eventDescription,
      final Map<String, dynamic>? previousState,
      final Map<String, dynamic>? newState,
      this.ipAddress,
      this.userAgent,
      this.sessionId,
      required this.timestamp,
      this.actorName,
      this.actorEmail})
      : _previousState = previousState,
        _newState = newState;

  factory _$ApprovalAuditLogEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApprovalAuditLogEntryImplFromJson(json);

  @override
  final String id;
  @override
  final String requestId;
  @override
  final String actorId;
  @override
  final String actorRole;
  @override
  final String eventType;
  @override
  final String? eventDescription;
  final Map<String, dynamic>? _previousState;
  @override
  Map<String, dynamic>? get previousState {
    final value = _previousState;
    if (value == null) return null;
    if (_previousState is EqualUnmodifiableMapView) return _previousState;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _newState;
  @override
  Map<String, dynamic>? get newState {
    final value = _newState;
    if (value == null) return null;
    if (_newState is EqualUnmodifiableMapView) return _newState;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? ipAddress;
  @override
  final String? userAgent;
  @override
  final String? sessionId;
  @override
  final DateTime timestamp;
  @override
  final String? actorName;
  @override
  final String? actorEmail;

  @override
  String toString() {
    return 'ApprovalAuditLogEntry(id: $id, requestId: $requestId, actorId: $actorId, actorRole: $actorRole, eventType: $eventType, eventDescription: $eventDescription, previousState: $previousState, newState: $newState, ipAddress: $ipAddress, userAgent: $userAgent, sessionId: $sessionId, timestamp: $timestamp, actorName: $actorName, actorEmail: $actorEmail)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApprovalAuditLogEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.actorId, actorId) || other.actorId == actorId) &&
            (identical(other.actorRole, actorRole) ||
                other.actorRole == actorRole) &&
            (identical(other.eventType, eventType) ||
                other.eventType == eventType) &&
            (identical(other.eventDescription, eventDescription) ||
                other.eventDescription == eventDescription) &&
            const DeepCollectionEquality()
                .equals(other._previousState, _previousState) &&
            const DeepCollectionEquality().equals(other._newState, _newState) &&
            (identical(other.ipAddress, ipAddress) ||
                other.ipAddress == ipAddress) &&
            (identical(other.userAgent, userAgent) ||
                other.userAgent == userAgent) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.actorName, actorName) ||
                other.actorName == actorName) &&
            (identical(other.actorEmail, actorEmail) ||
                other.actorEmail == actorEmail));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      requestId,
      actorId,
      actorRole,
      eventType,
      eventDescription,
      const DeepCollectionEquality().hash(_previousState),
      const DeepCollectionEquality().hash(_newState),
      ipAddress,
      userAgent,
      sessionId,
      timestamp,
      actorName,
      actorEmail);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ApprovalAuditLogEntryImplCopyWith<_$ApprovalAuditLogEntryImpl>
      get copyWith => __$$ApprovalAuditLogEntryImplCopyWithImpl<
          _$ApprovalAuditLogEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApprovalAuditLogEntryImplToJson(
      this,
    );
  }
}

abstract class _ApprovalAuditLogEntry implements ApprovalAuditLogEntry {
  const factory _ApprovalAuditLogEntry(
      {required final String id,
      required final String requestId,
      required final String actorId,
      required final String actorRole,
      required final String eventType,
      final String? eventDescription,
      final Map<String, dynamic>? previousState,
      final Map<String, dynamic>? newState,
      final String? ipAddress,
      final String? userAgent,
      final String? sessionId,
      required final DateTime timestamp,
      final String? actorName,
      final String? actorEmail}) = _$ApprovalAuditLogEntryImpl;

  factory _ApprovalAuditLogEntry.fromJson(Map<String, dynamic> json) =
      _$ApprovalAuditLogEntryImpl.fromJson;

  @override
  String get id;
  @override
  String get requestId;
  @override
  String get actorId;
  @override
  String get actorRole;
  @override
  String get eventType;
  @override
  String? get eventDescription;
  @override
  Map<String, dynamic>? get previousState;
  @override
  Map<String, dynamic>? get newState;
  @override
  String? get ipAddress;
  @override
  String? get userAgent;
  @override
  String? get sessionId;
  @override
  DateTime get timestamp;
  @override
  String? get actorName;
  @override
  String? get actorEmail;
  @override
  @JsonKey(ignore: true)
  _$$ApprovalAuditLogEntryImplCopyWith<_$ApprovalAuditLogEntryImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ApprovalAuditLogResponse _$ApprovalAuditLogResponseFromJson(
    Map<String, dynamic> json) {
  return _ApprovalAuditLogResponse.fromJson(json);
}

/// @nodoc
mixin _$ApprovalAuditLogResponse {
  List<ApprovalAuditLogEntry> get entries => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  int get pageSize => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ApprovalAuditLogResponseCopyWith<ApprovalAuditLogResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApprovalAuditLogResponseCopyWith<$Res> {
  factory $ApprovalAuditLogResponseCopyWith(ApprovalAuditLogResponse value,
          $Res Function(ApprovalAuditLogResponse) then) =
      _$ApprovalAuditLogResponseCopyWithImpl<$Res, ApprovalAuditLogResponse>;
  @useResult
  $Res call(
      {List<ApprovalAuditLogEntry> entries,
      int total,
      int page,
      int pageSize,
      bool hasMore});
}

/// @nodoc
class _$ApprovalAuditLogResponseCopyWithImpl<$Res,
        $Val extends ApprovalAuditLogResponse>
    implements $ApprovalAuditLogResponseCopyWith<$Res> {
  _$ApprovalAuditLogResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entries = null,
    Object? total = null,
    Object? page = null,
    Object? pageSize = null,
    Object? hasMore = null,
  }) {
    return _then(_value.copyWith(
      entries: null == entries
          ? _value.entries
          : entries // ignore: cast_nullable_to_non_nullable
              as List<ApprovalAuditLogEntry>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApprovalAuditLogResponseImplCopyWith<$Res>
    implements $ApprovalAuditLogResponseCopyWith<$Res> {
  factory _$$ApprovalAuditLogResponseImplCopyWith(
          _$ApprovalAuditLogResponseImpl value,
          $Res Function(_$ApprovalAuditLogResponseImpl) then) =
      __$$ApprovalAuditLogResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<ApprovalAuditLogEntry> entries,
      int total,
      int page,
      int pageSize,
      bool hasMore});
}

/// @nodoc
class __$$ApprovalAuditLogResponseImplCopyWithImpl<$Res>
    extends _$ApprovalAuditLogResponseCopyWithImpl<$Res,
        _$ApprovalAuditLogResponseImpl>
    implements _$$ApprovalAuditLogResponseImplCopyWith<$Res> {
  __$$ApprovalAuditLogResponseImplCopyWithImpl(
      _$ApprovalAuditLogResponseImpl _value,
      $Res Function(_$ApprovalAuditLogResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entries = null,
    Object? total = null,
    Object? page = null,
    Object? pageSize = null,
    Object? hasMore = null,
  }) {
    return _then(_$ApprovalAuditLogResponseImpl(
      entries: null == entries
          ? _value._entries
          : entries // ignore: cast_nullable_to_non_nullable
              as List<ApprovalAuditLogEntry>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
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
class _$ApprovalAuditLogResponseImpl implements _ApprovalAuditLogResponse {
  const _$ApprovalAuditLogResponseImpl(
      {required final List<ApprovalAuditLogEntry> entries,
      required this.total,
      required this.page,
      required this.pageSize,
      required this.hasMore})
      : _entries = entries;

  factory _$ApprovalAuditLogResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApprovalAuditLogResponseImplFromJson(json);

  final List<ApprovalAuditLogEntry> _entries;
  @override
  List<ApprovalAuditLogEntry> get entries {
    if (_entries is EqualUnmodifiableListView) return _entries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_entries);
  }

  @override
  final int total;
  @override
  final int page;
  @override
  final int pageSize;
  @override
  final bool hasMore;

  @override
  String toString() {
    return 'ApprovalAuditLogResponse(entries: $entries, total: $total, page: $page, pageSize: $pageSize, hasMore: $hasMore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApprovalAuditLogResponseImpl &&
            const DeepCollectionEquality().equals(other._entries, _entries) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_entries),
      total,
      page,
      pageSize,
      hasMore);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ApprovalAuditLogResponseImplCopyWith<_$ApprovalAuditLogResponseImpl>
      get copyWith => __$$ApprovalAuditLogResponseImplCopyWithImpl<
          _$ApprovalAuditLogResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApprovalAuditLogResponseImplToJson(
      this,
    );
  }
}

abstract class _ApprovalAuditLogResponse implements ApprovalAuditLogResponse {
  const factory _ApprovalAuditLogResponse(
      {required final List<ApprovalAuditLogEntry> entries,
      required final int total,
      required final int page,
      required final int pageSize,
      required final bool hasMore}) = _$ApprovalAuditLogResponseImpl;

  factory _ApprovalAuditLogResponse.fromJson(Map<String, dynamic> json) =
      _$ApprovalAuditLogResponseImpl.fromJson;

  @override
  List<ApprovalAuditLogEntry> get entries;
  @override
  int get total;
  @override
  int get page;
  @override
  int get pageSize;
  @override
  bool get hasMore;
  @override
  @JsonKey(ignore: true)
  _$$ApprovalAuditLogResponseImplCopyWith<_$ApprovalAuditLogResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

CreateApprovalRequest _$CreateApprovalRequestFromJson(
    Map<String, dynamic> json) {
  return _CreateApprovalRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateApprovalRequest {
  ApprovalRequestType get requestType => throw _privateConstructorUsedError;
  ApprovalActionType get actionType => throw _privateConstructorUsedError;
  String get targetResourceType => throw _privateConstructorUsedError;
  String? get targetResourceId => throw _privateConstructorUsedError;
  Map<String, dynamic>? get targetResourceSnapshot =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> get actionPayload => throw _privateConstructorUsedError;
  String get justification => throw _privateConstructorUsedError;
  ApprovalPriority get priority => throw _privateConstructorUsedError;
  String? get regionalScope => throw _privateConstructorUsedError;
  List<Map<String, String>> get attachments =>
      throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CreateApprovalRequestCopyWith<CreateApprovalRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateApprovalRequestCopyWith<$Res> {
  factory $CreateApprovalRequestCopyWith(CreateApprovalRequest value,
          $Res Function(CreateApprovalRequest) then) =
      _$CreateApprovalRequestCopyWithImpl<$Res, CreateApprovalRequest>;
  @useResult
  $Res call(
      {ApprovalRequestType requestType,
      ApprovalActionType actionType,
      String targetResourceType,
      String? targetResourceId,
      Map<String, dynamic>? targetResourceSnapshot,
      Map<String, dynamic> actionPayload,
      String justification,
      ApprovalPriority priority,
      String? regionalScope,
      List<Map<String, String>> attachments,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$CreateApprovalRequestCopyWithImpl<$Res,
        $Val extends CreateApprovalRequest>
    implements $CreateApprovalRequestCopyWith<$Res> {
  _$CreateApprovalRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requestType = null,
    Object? actionType = null,
    Object? targetResourceType = null,
    Object? targetResourceId = freezed,
    Object? targetResourceSnapshot = freezed,
    Object? actionPayload = null,
    Object? justification = null,
    Object? priority = null,
    Object? regionalScope = freezed,
    Object? attachments = null,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      requestType: null == requestType
          ? _value.requestType
          : requestType // ignore: cast_nullable_to_non_nullable
              as ApprovalRequestType,
      actionType: null == actionType
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as ApprovalActionType,
      targetResourceType: null == targetResourceType
          ? _value.targetResourceType
          : targetResourceType // ignore: cast_nullable_to_non_nullable
              as String,
      targetResourceId: freezed == targetResourceId
          ? _value.targetResourceId
          : targetResourceId // ignore: cast_nullable_to_non_nullable
              as String?,
      targetResourceSnapshot: freezed == targetResourceSnapshot
          ? _value.targetResourceSnapshot
          : targetResourceSnapshot // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      actionPayload: null == actionPayload
          ? _value.actionPayload
          : actionPayload // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      justification: null == justification
          ? _value.justification
          : justification // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as ApprovalPriority,
      regionalScope: freezed == regionalScope
          ? _value.regionalScope
          : regionalScope // ignore: cast_nullable_to_non_nullable
              as String?,
      attachments: null == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<Map<String, String>>,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateApprovalRequestImplCopyWith<$Res>
    implements $CreateApprovalRequestCopyWith<$Res> {
  factory _$$CreateApprovalRequestImplCopyWith(
          _$CreateApprovalRequestImpl value,
          $Res Function(_$CreateApprovalRequestImpl) then) =
      __$$CreateApprovalRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ApprovalRequestType requestType,
      ApprovalActionType actionType,
      String targetResourceType,
      String? targetResourceId,
      Map<String, dynamic>? targetResourceSnapshot,
      Map<String, dynamic> actionPayload,
      String justification,
      ApprovalPriority priority,
      String? regionalScope,
      List<Map<String, String>> attachments,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$CreateApprovalRequestImplCopyWithImpl<$Res>
    extends _$CreateApprovalRequestCopyWithImpl<$Res,
        _$CreateApprovalRequestImpl>
    implements _$$CreateApprovalRequestImplCopyWith<$Res> {
  __$$CreateApprovalRequestImplCopyWithImpl(_$CreateApprovalRequestImpl _value,
      $Res Function(_$CreateApprovalRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requestType = null,
    Object? actionType = null,
    Object? targetResourceType = null,
    Object? targetResourceId = freezed,
    Object? targetResourceSnapshot = freezed,
    Object? actionPayload = null,
    Object? justification = null,
    Object? priority = null,
    Object? regionalScope = freezed,
    Object? attachments = null,
    Object? metadata = freezed,
  }) {
    return _then(_$CreateApprovalRequestImpl(
      requestType: null == requestType
          ? _value.requestType
          : requestType // ignore: cast_nullable_to_non_nullable
              as ApprovalRequestType,
      actionType: null == actionType
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as ApprovalActionType,
      targetResourceType: null == targetResourceType
          ? _value.targetResourceType
          : targetResourceType // ignore: cast_nullable_to_non_nullable
              as String,
      targetResourceId: freezed == targetResourceId
          ? _value.targetResourceId
          : targetResourceId // ignore: cast_nullable_to_non_nullable
              as String?,
      targetResourceSnapshot: freezed == targetResourceSnapshot
          ? _value._targetResourceSnapshot
          : targetResourceSnapshot // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      actionPayload: null == actionPayload
          ? _value._actionPayload
          : actionPayload // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      justification: null == justification
          ? _value.justification
          : justification // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as ApprovalPriority,
      regionalScope: freezed == regionalScope
          ? _value.regionalScope
          : regionalScope // ignore: cast_nullable_to_non_nullable
              as String?,
      attachments: null == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<Map<String, String>>,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateApprovalRequestImpl implements _CreateApprovalRequest {
  const _$CreateApprovalRequestImpl(
      {required this.requestType,
      required this.actionType,
      required this.targetResourceType,
      this.targetResourceId,
      final Map<String, dynamic>? targetResourceSnapshot,
      final Map<String, dynamic> actionPayload = const {},
      required this.justification,
      this.priority = ApprovalPriority.normal,
      this.regionalScope,
      final List<Map<String, String>> attachments = const [],
      final Map<String, dynamic>? metadata})
      : _targetResourceSnapshot = targetResourceSnapshot,
        _actionPayload = actionPayload,
        _attachments = attachments,
        _metadata = metadata;

  factory _$CreateApprovalRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateApprovalRequestImplFromJson(json);

  @override
  final ApprovalRequestType requestType;
  @override
  final ApprovalActionType actionType;
  @override
  final String targetResourceType;
  @override
  final String? targetResourceId;
  final Map<String, dynamic>? _targetResourceSnapshot;
  @override
  Map<String, dynamic>? get targetResourceSnapshot {
    final value = _targetResourceSnapshot;
    if (value == null) return null;
    if (_targetResourceSnapshot is EqualUnmodifiableMapView)
      return _targetResourceSnapshot;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic> _actionPayload;
  @override
  @JsonKey()
  Map<String, dynamic> get actionPayload {
    if (_actionPayload is EqualUnmodifiableMapView) return _actionPayload;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_actionPayload);
  }

  @override
  final String justification;
  @override
  @JsonKey()
  final ApprovalPriority priority;
  @override
  final String? regionalScope;
  final List<Map<String, String>> _attachments;
  @override
  @JsonKey()
  List<Map<String, String>> get attachments {
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachments);
  }

  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'CreateApprovalRequest(requestType: $requestType, actionType: $actionType, targetResourceType: $targetResourceType, targetResourceId: $targetResourceId, targetResourceSnapshot: $targetResourceSnapshot, actionPayload: $actionPayload, justification: $justification, priority: $priority, regionalScope: $regionalScope, attachments: $attachments, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateApprovalRequestImpl &&
            (identical(other.requestType, requestType) ||
                other.requestType == requestType) &&
            (identical(other.actionType, actionType) ||
                other.actionType == actionType) &&
            (identical(other.targetResourceType, targetResourceType) ||
                other.targetResourceType == targetResourceType) &&
            (identical(other.targetResourceId, targetResourceId) ||
                other.targetResourceId == targetResourceId) &&
            const DeepCollectionEquality().equals(
                other._targetResourceSnapshot, _targetResourceSnapshot) &&
            const DeepCollectionEquality()
                .equals(other._actionPayload, _actionPayload) &&
            (identical(other.justification, justification) ||
                other.justification == justification) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.regionalScope, regionalScope) ||
                other.regionalScope == regionalScope) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      requestType,
      actionType,
      targetResourceType,
      targetResourceId,
      const DeepCollectionEquality().hash(_targetResourceSnapshot),
      const DeepCollectionEquality().hash(_actionPayload),
      justification,
      priority,
      regionalScope,
      const DeepCollectionEquality().hash(_attachments),
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateApprovalRequestImplCopyWith<_$CreateApprovalRequestImpl>
      get copyWith => __$$CreateApprovalRequestImplCopyWithImpl<
          _$CreateApprovalRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateApprovalRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateApprovalRequest implements CreateApprovalRequest {
  const factory _CreateApprovalRequest(
      {required final ApprovalRequestType requestType,
      required final ApprovalActionType actionType,
      required final String targetResourceType,
      final String? targetResourceId,
      final Map<String, dynamic>? targetResourceSnapshot,
      final Map<String, dynamic> actionPayload,
      required final String justification,
      final ApprovalPriority priority,
      final String? regionalScope,
      final List<Map<String, String>> attachments,
      final Map<String, dynamic>? metadata}) = _$CreateApprovalRequestImpl;

  factory _CreateApprovalRequest.fromJson(Map<String, dynamic> json) =
      _$CreateApprovalRequestImpl.fromJson;

  @override
  ApprovalRequestType get requestType;
  @override
  ApprovalActionType get actionType;
  @override
  String get targetResourceType;
  @override
  String? get targetResourceId;
  @override
  Map<String, dynamic>? get targetResourceSnapshot;
  @override
  Map<String, dynamic> get actionPayload;
  @override
  String get justification;
  @override
  ApprovalPriority get priority;
  @override
  String? get regionalScope;
  @override
  List<Map<String, String>> get attachments;
  @override
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(ignore: true)
  _$$CreateApprovalRequestImplCopyWith<_$CreateApprovalRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

UpdateApprovalRequest _$UpdateApprovalRequestFromJson(
    Map<String, dynamic> json) {
  return _UpdateApprovalRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateApprovalRequest {
  String? get justification => throw _privateConstructorUsedError;
  Map<String, dynamic>? get actionPayload => throw _privateConstructorUsedError;
  ApprovalPriority? get priority => throw _privateConstructorUsedError;
  List<Map<String, String>>? get attachments =>
      throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UpdateApprovalRequestCopyWith<UpdateApprovalRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateApprovalRequestCopyWith<$Res> {
  factory $UpdateApprovalRequestCopyWith(UpdateApprovalRequest value,
          $Res Function(UpdateApprovalRequest) then) =
      _$UpdateApprovalRequestCopyWithImpl<$Res, UpdateApprovalRequest>;
  @useResult
  $Res call(
      {String? justification,
      Map<String, dynamic>? actionPayload,
      ApprovalPriority? priority,
      List<Map<String, String>>? attachments,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$UpdateApprovalRequestCopyWithImpl<$Res,
        $Val extends UpdateApprovalRequest>
    implements $UpdateApprovalRequestCopyWith<$Res> {
  _$UpdateApprovalRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? justification = freezed,
    Object? actionPayload = freezed,
    Object? priority = freezed,
    Object? attachments = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      justification: freezed == justification
          ? _value.justification
          : justification // ignore: cast_nullable_to_non_nullable
              as String?,
      actionPayload: freezed == actionPayload
          ? _value.actionPayload
          : actionPayload // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      priority: freezed == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as ApprovalPriority?,
      attachments: freezed == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<Map<String, String>>?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateApprovalRequestImplCopyWith<$Res>
    implements $UpdateApprovalRequestCopyWith<$Res> {
  factory _$$UpdateApprovalRequestImplCopyWith(
          _$UpdateApprovalRequestImpl value,
          $Res Function(_$UpdateApprovalRequestImpl) then) =
      __$$UpdateApprovalRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? justification,
      Map<String, dynamic>? actionPayload,
      ApprovalPriority? priority,
      List<Map<String, String>>? attachments,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$UpdateApprovalRequestImplCopyWithImpl<$Res>
    extends _$UpdateApprovalRequestCopyWithImpl<$Res,
        _$UpdateApprovalRequestImpl>
    implements _$$UpdateApprovalRequestImplCopyWith<$Res> {
  __$$UpdateApprovalRequestImplCopyWithImpl(_$UpdateApprovalRequestImpl _value,
      $Res Function(_$UpdateApprovalRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? justification = freezed,
    Object? actionPayload = freezed,
    Object? priority = freezed,
    Object? attachments = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$UpdateApprovalRequestImpl(
      justification: freezed == justification
          ? _value.justification
          : justification // ignore: cast_nullable_to_non_nullable
              as String?,
      actionPayload: freezed == actionPayload
          ? _value._actionPayload
          : actionPayload // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      priority: freezed == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as ApprovalPriority?,
      attachments: freezed == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<Map<String, String>>?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateApprovalRequestImpl implements _UpdateApprovalRequest {
  const _$UpdateApprovalRequestImpl(
      {this.justification,
      final Map<String, dynamic>? actionPayload,
      this.priority,
      final List<Map<String, String>>? attachments,
      final Map<String, dynamic>? metadata})
      : _actionPayload = actionPayload,
        _attachments = attachments,
        _metadata = metadata;

  factory _$UpdateApprovalRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateApprovalRequestImplFromJson(json);

  @override
  final String? justification;
  final Map<String, dynamic>? _actionPayload;
  @override
  Map<String, dynamic>? get actionPayload {
    final value = _actionPayload;
    if (value == null) return null;
    if (_actionPayload is EqualUnmodifiableMapView) return _actionPayload;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final ApprovalPriority? priority;
  final List<Map<String, String>>? _attachments;
  @override
  List<Map<String, String>>? get attachments {
    final value = _attachments;
    if (value == null) return null;
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'UpdateApprovalRequest(justification: $justification, actionPayload: $actionPayload, priority: $priority, attachments: $attachments, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateApprovalRequestImpl &&
            (identical(other.justification, justification) ||
                other.justification == justification) &&
            const DeepCollectionEquality()
                .equals(other._actionPayload, _actionPayload) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      justification,
      const DeepCollectionEquality().hash(_actionPayload),
      priority,
      const DeepCollectionEquality().hash(_attachments),
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateApprovalRequestImplCopyWith<_$UpdateApprovalRequestImpl>
      get copyWith => __$$UpdateApprovalRequestImplCopyWithImpl<
          _$UpdateApprovalRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateApprovalRequestImplToJson(
      this,
    );
  }
}

abstract class _UpdateApprovalRequest implements UpdateApprovalRequest {
  const factory _UpdateApprovalRequest(
      {final String? justification,
      final Map<String, dynamic>? actionPayload,
      final ApprovalPriority? priority,
      final List<Map<String, String>>? attachments,
      final Map<String, dynamic>? metadata}) = _$UpdateApprovalRequestImpl;

  factory _UpdateApprovalRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateApprovalRequestImpl.fromJson;

  @override
  String? get justification;
  @override
  Map<String, dynamic>? get actionPayload;
  @override
  ApprovalPriority? get priority;
  @override
  List<Map<String, String>>? get attachments;
  @override
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(ignore: true)
  _$$UpdateApprovalRequestImplCopyWith<_$UpdateApprovalRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ApproveRequestData _$ApproveRequestDataFromJson(Map<String, dynamic> json) {
  return _ApproveRequestData.fromJson(json);
}

/// @nodoc
mixin _$ApproveRequestData {
  String? get notes => throw _privateConstructorUsedError;
  bool get mfaVerified => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ApproveRequestDataCopyWith<ApproveRequestData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApproveRequestDataCopyWith<$Res> {
  factory $ApproveRequestDataCopyWith(
          ApproveRequestData value, $Res Function(ApproveRequestData) then) =
      _$ApproveRequestDataCopyWithImpl<$Res, ApproveRequestData>;
  @useResult
  $Res call({String? notes, bool mfaVerified});
}

/// @nodoc
class _$ApproveRequestDataCopyWithImpl<$Res, $Val extends ApproveRequestData>
    implements $ApproveRequestDataCopyWith<$Res> {
  _$ApproveRequestDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notes = freezed,
    Object? mfaVerified = null,
  }) {
    return _then(_value.copyWith(
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      mfaVerified: null == mfaVerified
          ? _value.mfaVerified
          : mfaVerified // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApproveRequestDataImplCopyWith<$Res>
    implements $ApproveRequestDataCopyWith<$Res> {
  factory _$$ApproveRequestDataImplCopyWith(_$ApproveRequestDataImpl value,
          $Res Function(_$ApproveRequestDataImpl) then) =
      __$$ApproveRequestDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? notes, bool mfaVerified});
}

/// @nodoc
class __$$ApproveRequestDataImplCopyWithImpl<$Res>
    extends _$ApproveRequestDataCopyWithImpl<$Res, _$ApproveRequestDataImpl>
    implements _$$ApproveRequestDataImplCopyWith<$Res> {
  __$$ApproveRequestDataImplCopyWithImpl(_$ApproveRequestDataImpl _value,
      $Res Function(_$ApproveRequestDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notes = freezed,
    Object? mfaVerified = null,
  }) {
    return _then(_$ApproveRequestDataImpl(
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      mfaVerified: null == mfaVerified
          ? _value.mfaVerified
          : mfaVerified // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApproveRequestDataImpl implements _ApproveRequestData {
  const _$ApproveRequestDataImpl({this.notes, this.mfaVerified = false});

  factory _$ApproveRequestDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApproveRequestDataImplFromJson(json);

  @override
  final String? notes;
  @override
  @JsonKey()
  final bool mfaVerified;

  @override
  String toString() {
    return 'ApproveRequestData(notes: $notes, mfaVerified: $mfaVerified)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApproveRequestDataImpl &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.mfaVerified, mfaVerified) ||
                other.mfaVerified == mfaVerified));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, notes, mfaVerified);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ApproveRequestDataImplCopyWith<_$ApproveRequestDataImpl> get copyWith =>
      __$$ApproveRequestDataImplCopyWithImpl<_$ApproveRequestDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApproveRequestDataImplToJson(
      this,
    );
  }
}

abstract class _ApproveRequestData implements ApproveRequestData {
  const factory _ApproveRequestData(
      {final String? notes, final bool mfaVerified}) = _$ApproveRequestDataImpl;

  factory _ApproveRequestData.fromJson(Map<String, dynamic> json) =
      _$ApproveRequestDataImpl.fromJson;

  @override
  String? get notes;
  @override
  bool get mfaVerified;
  @override
  @JsonKey(ignore: true)
  _$$ApproveRequestDataImplCopyWith<_$ApproveRequestDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DenyRequestData _$DenyRequestDataFromJson(Map<String, dynamic> json) {
  return _DenyRequestData.fromJson(json);
}

/// @nodoc
mixin _$DenyRequestData {
  String get reason => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  bool get mfaVerified => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DenyRequestDataCopyWith<DenyRequestData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DenyRequestDataCopyWith<$Res> {
  factory $DenyRequestDataCopyWith(
          DenyRequestData value, $Res Function(DenyRequestData) then) =
      _$DenyRequestDataCopyWithImpl<$Res, DenyRequestData>;
  @useResult
  $Res call({String reason, String? notes, bool mfaVerified});
}

/// @nodoc
class _$DenyRequestDataCopyWithImpl<$Res, $Val extends DenyRequestData>
    implements $DenyRequestDataCopyWith<$Res> {
  _$DenyRequestDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reason = null,
    Object? notes = freezed,
    Object? mfaVerified = null,
  }) {
    return _then(_value.copyWith(
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      mfaVerified: null == mfaVerified
          ? _value.mfaVerified
          : mfaVerified // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DenyRequestDataImplCopyWith<$Res>
    implements $DenyRequestDataCopyWith<$Res> {
  factory _$$DenyRequestDataImplCopyWith(_$DenyRequestDataImpl value,
          $Res Function(_$DenyRequestDataImpl) then) =
      __$$DenyRequestDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String reason, String? notes, bool mfaVerified});
}

/// @nodoc
class __$$DenyRequestDataImplCopyWithImpl<$Res>
    extends _$DenyRequestDataCopyWithImpl<$Res, _$DenyRequestDataImpl>
    implements _$$DenyRequestDataImplCopyWith<$Res> {
  __$$DenyRequestDataImplCopyWithImpl(
      _$DenyRequestDataImpl _value, $Res Function(_$DenyRequestDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reason = null,
    Object? notes = freezed,
    Object? mfaVerified = null,
  }) {
    return _then(_$DenyRequestDataImpl(
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      mfaVerified: null == mfaVerified
          ? _value.mfaVerified
          : mfaVerified // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DenyRequestDataImpl implements _DenyRequestData {
  const _$DenyRequestDataImpl(
      {required this.reason, this.notes, this.mfaVerified = false});

  factory _$DenyRequestDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$DenyRequestDataImplFromJson(json);

  @override
  final String reason;
  @override
  final String? notes;
  @override
  @JsonKey()
  final bool mfaVerified;

  @override
  String toString() {
    return 'DenyRequestData(reason: $reason, notes: $notes, mfaVerified: $mfaVerified)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DenyRequestDataImpl &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.mfaVerified, mfaVerified) ||
                other.mfaVerified == mfaVerified));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, reason, notes, mfaVerified);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DenyRequestDataImplCopyWith<_$DenyRequestDataImpl> get copyWith =>
      __$$DenyRequestDataImplCopyWithImpl<_$DenyRequestDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DenyRequestDataImplToJson(
      this,
    );
  }
}

abstract class _DenyRequestData implements DenyRequestData {
  const factory _DenyRequestData(
      {required final String reason,
      final String? notes,
      final bool mfaVerified}) = _$DenyRequestDataImpl;

  factory _DenyRequestData.fromJson(Map<String, dynamic> json) =
      _$DenyRequestDataImpl.fromJson;

  @override
  String get reason;
  @override
  String? get notes;
  @override
  bool get mfaVerified;
  @override
  @JsonKey(ignore: true)
  _$$DenyRequestDataImplCopyWith<_$DenyRequestDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RequestInfoData _$RequestInfoDataFromJson(Map<String, dynamic> json) {
  return _RequestInfoData.fromJson(json);
}

/// @nodoc
mixin _$RequestInfoData {
  String get infoRequested => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RequestInfoDataCopyWith<RequestInfoData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RequestInfoDataCopyWith<$Res> {
  factory $RequestInfoDataCopyWith(
          RequestInfoData value, $Res Function(RequestInfoData) then) =
      _$RequestInfoDataCopyWithImpl<$Res, RequestInfoData>;
  @useResult
  $Res call({String infoRequested});
}

/// @nodoc
class _$RequestInfoDataCopyWithImpl<$Res, $Val extends RequestInfoData>
    implements $RequestInfoDataCopyWith<$Res> {
  _$RequestInfoDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? infoRequested = null,
  }) {
    return _then(_value.copyWith(
      infoRequested: null == infoRequested
          ? _value.infoRequested
          : infoRequested // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RequestInfoDataImplCopyWith<$Res>
    implements $RequestInfoDataCopyWith<$Res> {
  factory _$$RequestInfoDataImplCopyWith(_$RequestInfoDataImpl value,
          $Res Function(_$RequestInfoDataImpl) then) =
      __$$RequestInfoDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String infoRequested});
}

/// @nodoc
class __$$RequestInfoDataImplCopyWithImpl<$Res>
    extends _$RequestInfoDataCopyWithImpl<$Res, _$RequestInfoDataImpl>
    implements _$$RequestInfoDataImplCopyWith<$Res> {
  __$$RequestInfoDataImplCopyWithImpl(
      _$RequestInfoDataImpl _value, $Res Function(_$RequestInfoDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? infoRequested = null,
  }) {
    return _then(_$RequestInfoDataImpl(
      infoRequested: null == infoRequested
          ? _value.infoRequested
          : infoRequested // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RequestInfoDataImpl implements _RequestInfoData {
  const _$RequestInfoDataImpl({required this.infoRequested});

  factory _$RequestInfoDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$RequestInfoDataImplFromJson(json);

  @override
  final String infoRequested;

  @override
  String toString() {
    return 'RequestInfoData(infoRequested: $infoRequested)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RequestInfoDataImpl &&
            (identical(other.infoRequested, infoRequested) ||
                other.infoRequested == infoRequested));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, infoRequested);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RequestInfoDataImplCopyWith<_$RequestInfoDataImpl> get copyWith =>
      __$$RequestInfoDataImplCopyWithImpl<_$RequestInfoDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RequestInfoDataImplToJson(
      this,
    );
  }
}

abstract class _RequestInfoData implements RequestInfoData {
  const factory _RequestInfoData({required final String infoRequested}) =
      _$RequestInfoDataImpl;

  factory _RequestInfoData.fromJson(Map<String, dynamic> json) =
      _$RequestInfoDataImpl.fromJson;

  @override
  String get infoRequested;
  @override
  @JsonKey(ignore: true)
  _$$RequestInfoDataImplCopyWith<_$RequestInfoDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RespondInfoData _$RespondInfoDataFromJson(Map<String, dynamic> json) {
  return _RespondInfoData.fromJson(json);
}

/// @nodoc
mixin _$RespondInfoData {
  String get response => throw _privateConstructorUsedError;
  List<Map<String, String>> get attachments =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RespondInfoDataCopyWith<RespondInfoData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RespondInfoDataCopyWith<$Res> {
  factory $RespondInfoDataCopyWith(
          RespondInfoData value, $Res Function(RespondInfoData) then) =
      _$RespondInfoDataCopyWithImpl<$Res, RespondInfoData>;
  @useResult
  $Res call({String response, List<Map<String, String>> attachments});
}

/// @nodoc
class _$RespondInfoDataCopyWithImpl<$Res, $Val extends RespondInfoData>
    implements $RespondInfoDataCopyWith<$Res> {
  _$RespondInfoDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? response = null,
    Object? attachments = null,
  }) {
    return _then(_value.copyWith(
      response: null == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as String,
      attachments: null == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<Map<String, String>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RespondInfoDataImplCopyWith<$Res>
    implements $RespondInfoDataCopyWith<$Res> {
  factory _$$RespondInfoDataImplCopyWith(_$RespondInfoDataImpl value,
          $Res Function(_$RespondInfoDataImpl) then) =
      __$$RespondInfoDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String response, List<Map<String, String>> attachments});
}

/// @nodoc
class __$$RespondInfoDataImplCopyWithImpl<$Res>
    extends _$RespondInfoDataCopyWithImpl<$Res, _$RespondInfoDataImpl>
    implements _$$RespondInfoDataImplCopyWith<$Res> {
  __$$RespondInfoDataImplCopyWithImpl(
      _$RespondInfoDataImpl _value, $Res Function(_$RespondInfoDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? response = null,
    Object? attachments = null,
  }) {
    return _then(_$RespondInfoDataImpl(
      response: null == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as String,
      attachments: null == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<Map<String, String>>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RespondInfoDataImpl implements _RespondInfoData {
  const _$RespondInfoDataImpl(
      {required this.response,
      final List<Map<String, String>> attachments = const []})
      : _attachments = attachments;

  factory _$RespondInfoDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$RespondInfoDataImplFromJson(json);

  @override
  final String response;
  final List<Map<String, String>> _attachments;
  @override
  @JsonKey()
  List<Map<String, String>> get attachments {
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachments);
  }

  @override
  String toString() {
    return 'RespondInfoData(response: $response, attachments: $attachments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RespondInfoDataImpl &&
            (identical(other.response, response) ||
                other.response == response) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, response, const DeepCollectionEquality().hash(_attachments));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RespondInfoDataImplCopyWith<_$RespondInfoDataImpl> get copyWith =>
      __$$RespondInfoDataImplCopyWithImpl<_$RespondInfoDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RespondInfoDataImplToJson(
      this,
    );
  }
}

abstract class _RespondInfoData implements RespondInfoData {
  const factory _RespondInfoData(
      {required final String response,
      final List<Map<String, String>> attachments}) = _$RespondInfoDataImpl;

  factory _RespondInfoData.fromJson(Map<String, dynamic> json) =
      _$RespondInfoDataImpl.fromJson;

  @override
  String get response;
  @override
  List<Map<String, String>> get attachments;
  @override
  @JsonKey(ignore: true)
  _$$RespondInfoDataImplCopyWith<_$RespondInfoDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DelegateRequestData _$DelegateRequestDataFromJson(Map<String, dynamic> json) {
  return _DelegateRequestData.fromJson(json);
}

/// @nodoc
mixin _$DelegateRequestData {
  String get delegateTo => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DelegateRequestDataCopyWith<DelegateRequestData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DelegateRequestDataCopyWith<$Res> {
  factory $DelegateRequestDataCopyWith(
          DelegateRequestData value, $Res Function(DelegateRequestData) then) =
      _$DelegateRequestDataCopyWithImpl<$Res, DelegateRequestData>;
  @useResult
  $Res call({String delegateTo, String reason});
}

/// @nodoc
class _$DelegateRequestDataCopyWithImpl<$Res, $Val extends DelegateRequestData>
    implements $DelegateRequestDataCopyWith<$Res> {
  _$DelegateRequestDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? delegateTo = null,
    Object? reason = null,
  }) {
    return _then(_value.copyWith(
      delegateTo: null == delegateTo
          ? _value.delegateTo
          : delegateTo // ignore: cast_nullable_to_non_nullable
              as String,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DelegateRequestDataImplCopyWith<$Res>
    implements $DelegateRequestDataCopyWith<$Res> {
  factory _$$DelegateRequestDataImplCopyWith(_$DelegateRequestDataImpl value,
          $Res Function(_$DelegateRequestDataImpl) then) =
      __$$DelegateRequestDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String delegateTo, String reason});
}

/// @nodoc
class __$$DelegateRequestDataImplCopyWithImpl<$Res>
    extends _$DelegateRequestDataCopyWithImpl<$Res, _$DelegateRequestDataImpl>
    implements _$$DelegateRequestDataImplCopyWith<$Res> {
  __$$DelegateRequestDataImplCopyWithImpl(_$DelegateRequestDataImpl _value,
      $Res Function(_$DelegateRequestDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? delegateTo = null,
    Object? reason = null,
  }) {
    return _then(_$DelegateRequestDataImpl(
      delegateTo: null == delegateTo
          ? _value.delegateTo
          : delegateTo // ignore: cast_nullable_to_non_nullable
              as String,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DelegateRequestDataImpl implements _DelegateRequestData {
  const _$DelegateRequestDataImpl(
      {required this.delegateTo, required this.reason});

  factory _$DelegateRequestDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$DelegateRequestDataImplFromJson(json);

  @override
  final String delegateTo;
  @override
  final String reason;

  @override
  String toString() {
    return 'DelegateRequestData(delegateTo: $delegateTo, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DelegateRequestDataImpl &&
            (identical(other.delegateTo, delegateTo) ||
                other.delegateTo == delegateTo) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, delegateTo, reason);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DelegateRequestDataImplCopyWith<_$DelegateRequestDataImpl> get copyWith =>
      __$$DelegateRequestDataImplCopyWithImpl<_$DelegateRequestDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DelegateRequestDataImplToJson(
      this,
    );
  }
}

abstract class _DelegateRequestData implements DelegateRequestData {
  const factory _DelegateRequestData(
      {required final String delegateTo,
      required final String reason}) = _$DelegateRequestDataImpl;

  factory _DelegateRequestData.fromJson(Map<String, dynamic> json) =
      _$DelegateRequestDataImpl.fromJson;

  @override
  String get delegateTo;
  @override
  String get reason;
  @override
  @JsonKey(ignore: true)
  _$$DelegateRequestDataImplCopyWith<_$DelegateRequestDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EscalateRequestData _$EscalateRequestDataFromJson(Map<String, dynamic> json) {
  return _EscalateRequestData.fromJson(json);
}

/// @nodoc
mixin _$EscalateRequestData {
  String get reason => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EscalateRequestDataCopyWith<EscalateRequestData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EscalateRequestDataCopyWith<$Res> {
  factory $EscalateRequestDataCopyWith(
          EscalateRequestData value, $Res Function(EscalateRequestData) then) =
      _$EscalateRequestDataCopyWithImpl<$Res, EscalateRequestData>;
  @useResult
  $Res call({String reason});
}

/// @nodoc
class _$EscalateRequestDataCopyWithImpl<$Res, $Val extends EscalateRequestData>
    implements $EscalateRequestDataCopyWith<$Res> {
  _$EscalateRequestDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reason = null,
  }) {
    return _then(_value.copyWith(
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EscalateRequestDataImplCopyWith<$Res>
    implements $EscalateRequestDataCopyWith<$Res> {
  factory _$$EscalateRequestDataImplCopyWith(_$EscalateRequestDataImpl value,
          $Res Function(_$EscalateRequestDataImpl) then) =
      __$$EscalateRequestDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String reason});
}

/// @nodoc
class __$$EscalateRequestDataImplCopyWithImpl<$Res>
    extends _$EscalateRequestDataCopyWithImpl<$Res, _$EscalateRequestDataImpl>
    implements _$$EscalateRequestDataImplCopyWith<$Res> {
  __$$EscalateRequestDataImplCopyWithImpl(_$EscalateRequestDataImpl _value,
      $Res Function(_$EscalateRequestDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reason = null,
  }) {
    return _then(_$EscalateRequestDataImpl(
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EscalateRequestDataImpl implements _EscalateRequestData {
  const _$EscalateRequestDataImpl({required this.reason});

  factory _$EscalateRequestDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$EscalateRequestDataImplFromJson(json);

  @override
  final String reason;

  @override
  String toString() {
    return 'EscalateRequestData(reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EscalateRequestDataImpl &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, reason);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EscalateRequestDataImplCopyWith<_$EscalateRequestDataImpl> get copyWith =>
      __$$EscalateRequestDataImplCopyWithImpl<_$EscalateRequestDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EscalateRequestDataImplToJson(
      this,
    );
  }
}

abstract class _EscalateRequestData implements EscalateRequestData {
  const factory _EscalateRequestData({required final String reason}) =
      _$EscalateRequestDataImpl;

  factory _EscalateRequestData.fromJson(Map<String, dynamic> json) =
      _$EscalateRequestDataImpl.fromJson;

  @override
  String get reason;
  @override
  @JsonKey(ignore: true)
  _$$EscalateRequestDataImplCopyWith<_$EscalateRequestDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateCommentData _$CreateCommentDataFromJson(Map<String, dynamic> json) {
  return _CreateCommentData.fromJson(json);
}

/// @nodoc
mixin _$CreateCommentData {
  String get content => throw _privateConstructorUsedError;
  bool get isInternal => throw _privateConstructorUsedError;
  List<Map<String, String>> get attachments =>
      throw _privateConstructorUsedError;
  String? get parentCommentId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CreateCommentDataCopyWith<CreateCommentData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateCommentDataCopyWith<$Res> {
  factory $CreateCommentDataCopyWith(
          CreateCommentData value, $Res Function(CreateCommentData) then) =
      _$CreateCommentDataCopyWithImpl<$Res, CreateCommentData>;
  @useResult
  $Res call(
      {String content,
      bool isInternal,
      List<Map<String, String>> attachments,
      String? parentCommentId});
}

/// @nodoc
class _$CreateCommentDataCopyWithImpl<$Res, $Val extends CreateCommentData>
    implements $CreateCommentDataCopyWith<$Res> {
  _$CreateCommentDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? isInternal = null,
    Object? attachments = null,
    Object? parentCommentId = freezed,
  }) {
    return _then(_value.copyWith(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      isInternal: null == isInternal
          ? _value.isInternal
          : isInternal // ignore: cast_nullable_to_non_nullable
              as bool,
      attachments: null == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<Map<String, String>>,
      parentCommentId: freezed == parentCommentId
          ? _value.parentCommentId
          : parentCommentId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateCommentDataImplCopyWith<$Res>
    implements $CreateCommentDataCopyWith<$Res> {
  factory _$$CreateCommentDataImplCopyWith(_$CreateCommentDataImpl value,
          $Res Function(_$CreateCommentDataImpl) then) =
      __$$CreateCommentDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String content,
      bool isInternal,
      List<Map<String, String>> attachments,
      String? parentCommentId});
}

/// @nodoc
class __$$CreateCommentDataImplCopyWithImpl<$Res>
    extends _$CreateCommentDataCopyWithImpl<$Res, _$CreateCommentDataImpl>
    implements _$$CreateCommentDataImplCopyWith<$Res> {
  __$$CreateCommentDataImplCopyWithImpl(_$CreateCommentDataImpl _value,
      $Res Function(_$CreateCommentDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? isInternal = null,
    Object? attachments = null,
    Object? parentCommentId = freezed,
  }) {
    return _then(_$CreateCommentDataImpl(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      isInternal: null == isInternal
          ? _value.isInternal
          : isInternal // ignore: cast_nullable_to_non_nullable
              as bool,
      attachments: null == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<Map<String, String>>,
      parentCommentId: freezed == parentCommentId
          ? _value.parentCommentId
          : parentCommentId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateCommentDataImpl implements _CreateCommentData {
  const _$CreateCommentDataImpl(
      {required this.content,
      this.isInternal = false,
      final List<Map<String, String>> attachments = const [],
      this.parentCommentId})
      : _attachments = attachments;

  factory _$CreateCommentDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateCommentDataImplFromJson(json);

  @override
  final String content;
  @override
  @JsonKey()
  final bool isInternal;
  final List<Map<String, String>> _attachments;
  @override
  @JsonKey()
  List<Map<String, String>> get attachments {
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachments);
  }

  @override
  final String? parentCommentId;

  @override
  String toString() {
    return 'CreateCommentData(content: $content, isInternal: $isInternal, attachments: $attachments, parentCommentId: $parentCommentId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateCommentDataImpl &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.isInternal, isInternal) ||
                other.isInternal == isInternal) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments) &&
            (identical(other.parentCommentId, parentCommentId) ||
                other.parentCommentId == parentCommentId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, content, isInternal,
      const DeepCollectionEquality().hash(_attachments), parentCommentId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateCommentDataImplCopyWith<_$CreateCommentDataImpl> get copyWith =>
      __$$CreateCommentDataImplCopyWithImpl<_$CreateCommentDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateCommentDataImplToJson(
      this,
    );
  }
}

abstract class _CreateCommentData implements CreateCommentData {
  const factory _CreateCommentData(
      {required final String content,
      final bool isInternal,
      final List<Map<String, String>> attachments,
      final String? parentCommentId}) = _$CreateCommentDataImpl;

  factory _CreateCommentData.fromJson(Map<String, dynamic> json) =
      _$CreateCommentDataImpl.fromJson;

  @override
  String get content;
  @override
  bool get isInternal;
  @override
  List<Map<String, String>> get attachments;
  @override
  String? get parentCommentId;
  @override
  @JsonKey(ignore: true)
  _$$CreateCommentDataImplCopyWith<_$CreateCommentDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ApprovalRequestCreate _$ApprovalRequestCreateFromJson(
    Map<String, dynamic> json) {
  return _ApprovalRequestCreate.fromJson(json);
}

/// @nodoc
mixin _$ApprovalRequestCreate {
  String get requestType => throw _privateConstructorUsedError;
  String get actionType => throw _privateConstructorUsedError;
  String get targetResourceType => throw _privateConstructorUsedError;
  String? get targetResourceId => throw _privateConstructorUsedError;
  Map<String, dynamic>? get targetResourceSnapshot =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> get actionPayload => throw _privateConstructorUsedError;
  String get justification => throw _privateConstructorUsedError;
  String get priority => throw _privateConstructorUsedError;
  String? get regionalScope => throw _privateConstructorUsedError;
  List<Map<String, String>> get attachments =>
      throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ApprovalRequestCreateCopyWith<ApprovalRequestCreate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApprovalRequestCreateCopyWith<$Res> {
  factory $ApprovalRequestCreateCopyWith(ApprovalRequestCreate value,
          $Res Function(ApprovalRequestCreate) then) =
      _$ApprovalRequestCreateCopyWithImpl<$Res, ApprovalRequestCreate>;
  @useResult
  $Res call(
      {String requestType,
      String actionType,
      String targetResourceType,
      String? targetResourceId,
      Map<String, dynamic>? targetResourceSnapshot,
      Map<String, dynamic> actionPayload,
      String justification,
      String priority,
      String? regionalScope,
      List<Map<String, String>> attachments,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$ApprovalRequestCreateCopyWithImpl<$Res,
        $Val extends ApprovalRequestCreate>
    implements $ApprovalRequestCreateCopyWith<$Res> {
  _$ApprovalRequestCreateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requestType = null,
    Object? actionType = null,
    Object? targetResourceType = null,
    Object? targetResourceId = freezed,
    Object? targetResourceSnapshot = freezed,
    Object? actionPayload = null,
    Object? justification = null,
    Object? priority = null,
    Object? regionalScope = freezed,
    Object? attachments = null,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      requestType: null == requestType
          ? _value.requestType
          : requestType // ignore: cast_nullable_to_non_nullable
              as String,
      actionType: null == actionType
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as String,
      targetResourceType: null == targetResourceType
          ? _value.targetResourceType
          : targetResourceType // ignore: cast_nullable_to_non_nullable
              as String,
      targetResourceId: freezed == targetResourceId
          ? _value.targetResourceId
          : targetResourceId // ignore: cast_nullable_to_non_nullable
              as String?,
      targetResourceSnapshot: freezed == targetResourceSnapshot
          ? _value.targetResourceSnapshot
          : targetResourceSnapshot // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      actionPayload: null == actionPayload
          ? _value.actionPayload
          : actionPayload // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      justification: null == justification
          ? _value.justification
          : justification // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      regionalScope: freezed == regionalScope
          ? _value.regionalScope
          : regionalScope // ignore: cast_nullable_to_non_nullable
              as String?,
      attachments: null == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<Map<String, String>>,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApprovalRequestCreateImplCopyWith<$Res>
    implements $ApprovalRequestCreateCopyWith<$Res> {
  factory _$$ApprovalRequestCreateImplCopyWith(
          _$ApprovalRequestCreateImpl value,
          $Res Function(_$ApprovalRequestCreateImpl) then) =
      __$$ApprovalRequestCreateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String requestType,
      String actionType,
      String targetResourceType,
      String? targetResourceId,
      Map<String, dynamic>? targetResourceSnapshot,
      Map<String, dynamic> actionPayload,
      String justification,
      String priority,
      String? regionalScope,
      List<Map<String, String>> attachments,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$ApprovalRequestCreateImplCopyWithImpl<$Res>
    extends _$ApprovalRequestCreateCopyWithImpl<$Res,
        _$ApprovalRequestCreateImpl>
    implements _$$ApprovalRequestCreateImplCopyWith<$Res> {
  __$$ApprovalRequestCreateImplCopyWithImpl(_$ApprovalRequestCreateImpl _value,
      $Res Function(_$ApprovalRequestCreateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requestType = null,
    Object? actionType = null,
    Object? targetResourceType = null,
    Object? targetResourceId = freezed,
    Object? targetResourceSnapshot = freezed,
    Object? actionPayload = null,
    Object? justification = null,
    Object? priority = null,
    Object? regionalScope = freezed,
    Object? attachments = null,
    Object? metadata = freezed,
  }) {
    return _then(_$ApprovalRequestCreateImpl(
      requestType: null == requestType
          ? _value.requestType
          : requestType // ignore: cast_nullable_to_non_nullable
              as String,
      actionType: null == actionType
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as String,
      targetResourceType: null == targetResourceType
          ? _value.targetResourceType
          : targetResourceType // ignore: cast_nullable_to_non_nullable
              as String,
      targetResourceId: freezed == targetResourceId
          ? _value.targetResourceId
          : targetResourceId // ignore: cast_nullable_to_non_nullable
              as String?,
      targetResourceSnapshot: freezed == targetResourceSnapshot
          ? _value._targetResourceSnapshot
          : targetResourceSnapshot // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      actionPayload: null == actionPayload
          ? _value._actionPayload
          : actionPayload // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      justification: null == justification
          ? _value.justification
          : justification // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      regionalScope: freezed == regionalScope
          ? _value.regionalScope
          : regionalScope // ignore: cast_nullable_to_non_nullable
              as String?,
      attachments: null == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<Map<String, String>>,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApprovalRequestCreateImpl implements _ApprovalRequestCreate {
  const _$ApprovalRequestCreateImpl(
      {required this.requestType,
      required this.actionType,
      required this.targetResourceType,
      this.targetResourceId,
      final Map<String, dynamic>? targetResourceSnapshot,
      final Map<String, dynamic> actionPayload = const {},
      required this.justification,
      this.priority = 'normal',
      this.regionalScope,
      final List<Map<String, String>> attachments = const [],
      final Map<String, dynamic>? metadata})
      : _targetResourceSnapshot = targetResourceSnapshot,
        _actionPayload = actionPayload,
        _attachments = attachments,
        _metadata = metadata;

  factory _$ApprovalRequestCreateImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApprovalRequestCreateImplFromJson(json);

  @override
  final String requestType;
  @override
  final String actionType;
  @override
  final String targetResourceType;
  @override
  final String? targetResourceId;
  final Map<String, dynamic>? _targetResourceSnapshot;
  @override
  Map<String, dynamic>? get targetResourceSnapshot {
    final value = _targetResourceSnapshot;
    if (value == null) return null;
    if (_targetResourceSnapshot is EqualUnmodifiableMapView)
      return _targetResourceSnapshot;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic> _actionPayload;
  @override
  @JsonKey()
  Map<String, dynamic> get actionPayload {
    if (_actionPayload is EqualUnmodifiableMapView) return _actionPayload;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_actionPayload);
  }

  @override
  final String justification;
  @override
  @JsonKey()
  final String priority;
  @override
  final String? regionalScope;
  final List<Map<String, String>> _attachments;
  @override
  @JsonKey()
  List<Map<String, String>> get attachments {
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachments);
  }

  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ApprovalRequestCreate(requestType: $requestType, actionType: $actionType, targetResourceType: $targetResourceType, targetResourceId: $targetResourceId, targetResourceSnapshot: $targetResourceSnapshot, actionPayload: $actionPayload, justification: $justification, priority: $priority, regionalScope: $regionalScope, attachments: $attachments, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApprovalRequestCreateImpl &&
            (identical(other.requestType, requestType) ||
                other.requestType == requestType) &&
            (identical(other.actionType, actionType) ||
                other.actionType == actionType) &&
            (identical(other.targetResourceType, targetResourceType) ||
                other.targetResourceType == targetResourceType) &&
            (identical(other.targetResourceId, targetResourceId) ||
                other.targetResourceId == targetResourceId) &&
            const DeepCollectionEquality().equals(
                other._targetResourceSnapshot, _targetResourceSnapshot) &&
            const DeepCollectionEquality()
                .equals(other._actionPayload, _actionPayload) &&
            (identical(other.justification, justification) ||
                other.justification == justification) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.regionalScope, regionalScope) ||
                other.regionalScope == regionalScope) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      requestType,
      actionType,
      targetResourceType,
      targetResourceId,
      const DeepCollectionEquality().hash(_targetResourceSnapshot),
      const DeepCollectionEquality().hash(_actionPayload),
      justification,
      priority,
      regionalScope,
      const DeepCollectionEquality().hash(_attachments),
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ApprovalRequestCreateImplCopyWith<_$ApprovalRequestCreateImpl>
      get copyWith => __$$ApprovalRequestCreateImplCopyWithImpl<
          _$ApprovalRequestCreateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApprovalRequestCreateImplToJson(
      this,
    );
  }
}

abstract class _ApprovalRequestCreate implements ApprovalRequestCreate {
  const factory _ApprovalRequestCreate(
      {required final String requestType,
      required final String actionType,
      required final String targetResourceType,
      final String? targetResourceId,
      final Map<String, dynamic>? targetResourceSnapshot,
      final Map<String, dynamic> actionPayload,
      required final String justification,
      final String priority,
      final String? regionalScope,
      final List<Map<String, String>> attachments,
      final Map<String, dynamic>? metadata}) = _$ApprovalRequestCreateImpl;

  factory _ApprovalRequestCreate.fromJson(Map<String, dynamic> json) =
      _$ApprovalRequestCreateImpl.fromJson;

  @override
  String get requestType;
  @override
  String get actionType;
  @override
  String get targetResourceType;
  @override
  String? get targetResourceId;
  @override
  Map<String, dynamic>? get targetResourceSnapshot;
  @override
  Map<String, dynamic> get actionPayload;
  @override
  String get justification;
  @override
  String get priority;
  @override
  String? get regionalScope;
  @override
  List<Map<String, String>> get attachments;
  @override
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(ignore: true)
  _$$ApprovalRequestCreateImplCopyWith<_$ApprovalRequestCreateImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ApprovalRequestFilter _$ApprovalRequestFilterFromJson(
    Map<String, dynamic> json) {
  return _ApprovalRequestFilter.fromJson(json);
}

/// @nodoc
mixin _$ApprovalRequestFilter {
  List<ApprovalStatus>? get status => throw _privateConstructorUsedError;
  List<ApprovalRequestType>? get requestType =>
      throw _privateConstructorUsedError;
  List<ApprovalActionType>? get actionType =>
      throw _privateConstructorUsedError;
  List<ApprovalPriority>? get priority => throw _privateConstructorUsedError;
  String? get initiatedBy => throw _privateConstructorUsedError;
  String? get regionalScope => throw _privateConstructorUsedError;
  int? get currentApprovalLevel => throw _privateConstructorUsedError;
  DateTime? get fromDate => throw _privateConstructorUsedError;
  DateTime? get toDate => throw _privateConstructorUsedError;
  String? get search => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ApprovalRequestFilterCopyWith<ApprovalRequestFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApprovalRequestFilterCopyWith<$Res> {
  factory $ApprovalRequestFilterCopyWith(ApprovalRequestFilter value,
          $Res Function(ApprovalRequestFilter) then) =
      _$ApprovalRequestFilterCopyWithImpl<$Res, ApprovalRequestFilter>;
  @useResult
  $Res call(
      {List<ApprovalStatus>? status,
      List<ApprovalRequestType>? requestType,
      List<ApprovalActionType>? actionType,
      List<ApprovalPriority>? priority,
      String? initiatedBy,
      String? regionalScope,
      int? currentApprovalLevel,
      DateTime? fromDate,
      DateTime? toDate,
      String? search});
}

/// @nodoc
class _$ApprovalRequestFilterCopyWithImpl<$Res,
        $Val extends ApprovalRequestFilter>
    implements $ApprovalRequestFilterCopyWith<$Res> {
  _$ApprovalRequestFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? requestType = freezed,
    Object? actionType = freezed,
    Object? priority = freezed,
    Object? initiatedBy = freezed,
    Object? regionalScope = freezed,
    Object? currentApprovalLevel = freezed,
    Object? fromDate = freezed,
    Object? toDate = freezed,
    Object? search = freezed,
  }) {
    return _then(_value.copyWith(
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as List<ApprovalStatus>?,
      requestType: freezed == requestType
          ? _value.requestType
          : requestType // ignore: cast_nullable_to_non_nullable
              as List<ApprovalRequestType>?,
      actionType: freezed == actionType
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as List<ApprovalActionType>?,
      priority: freezed == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as List<ApprovalPriority>?,
      initiatedBy: freezed == initiatedBy
          ? _value.initiatedBy
          : initiatedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      regionalScope: freezed == regionalScope
          ? _value.regionalScope
          : regionalScope // ignore: cast_nullable_to_non_nullable
              as String?,
      currentApprovalLevel: freezed == currentApprovalLevel
          ? _value.currentApprovalLevel
          : currentApprovalLevel // ignore: cast_nullable_to_non_nullable
              as int?,
      fromDate: freezed == fromDate
          ? _value.fromDate
          : fromDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      toDate: freezed == toDate
          ? _value.toDate
          : toDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      search: freezed == search
          ? _value.search
          : search // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApprovalRequestFilterImplCopyWith<$Res>
    implements $ApprovalRequestFilterCopyWith<$Res> {
  factory _$$ApprovalRequestFilterImplCopyWith(
          _$ApprovalRequestFilterImpl value,
          $Res Function(_$ApprovalRequestFilterImpl) then) =
      __$$ApprovalRequestFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<ApprovalStatus>? status,
      List<ApprovalRequestType>? requestType,
      List<ApprovalActionType>? actionType,
      List<ApprovalPriority>? priority,
      String? initiatedBy,
      String? regionalScope,
      int? currentApprovalLevel,
      DateTime? fromDate,
      DateTime? toDate,
      String? search});
}

/// @nodoc
class __$$ApprovalRequestFilterImplCopyWithImpl<$Res>
    extends _$ApprovalRequestFilterCopyWithImpl<$Res,
        _$ApprovalRequestFilterImpl>
    implements _$$ApprovalRequestFilterImplCopyWith<$Res> {
  __$$ApprovalRequestFilterImplCopyWithImpl(_$ApprovalRequestFilterImpl _value,
      $Res Function(_$ApprovalRequestFilterImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? requestType = freezed,
    Object? actionType = freezed,
    Object? priority = freezed,
    Object? initiatedBy = freezed,
    Object? regionalScope = freezed,
    Object? currentApprovalLevel = freezed,
    Object? fromDate = freezed,
    Object? toDate = freezed,
    Object? search = freezed,
  }) {
    return _then(_$ApprovalRequestFilterImpl(
      status: freezed == status
          ? _value._status
          : status // ignore: cast_nullable_to_non_nullable
              as List<ApprovalStatus>?,
      requestType: freezed == requestType
          ? _value._requestType
          : requestType // ignore: cast_nullable_to_non_nullable
              as List<ApprovalRequestType>?,
      actionType: freezed == actionType
          ? _value._actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as List<ApprovalActionType>?,
      priority: freezed == priority
          ? _value._priority
          : priority // ignore: cast_nullable_to_non_nullable
              as List<ApprovalPriority>?,
      initiatedBy: freezed == initiatedBy
          ? _value.initiatedBy
          : initiatedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      regionalScope: freezed == regionalScope
          ? _value.regionalScope
          : regionalScope // ignore: cast_nullable_to_non_nullable
              as String?,
      currentApprovalLevel: freezed == currentApprovalLevel
          ? _value.currentApprovalLevel
          : currentApprovalLevel // ignore: cast_nullable_to_non_nullable
              as int?,
      fromDate: freezed == fromDate
          ? _value.fromDate
          : fromDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      toDate: freezed == toDate
          ? _value.toDate
          : toDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      search: freezed == search
          ? _value.search
          : search // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApprovalRequestFilterImpl implements _ApprovalRequestFilter {
  const _$ApprovalRequestFilterImpl(
      {final List<ApprovalStatus>? status,
      final List<ApprovalRequestType>? requestType,
      final List<ApprovalActionType>? actionType,
      final List<ApprovalPriority>? priority,
      this.initiatedBy,
      this.regionalScope,
      this.currentApprovalLevel,
      this.fromDate,
      this.toDate,
      this.search})
      : _status = status,
        _requestType = requestType,
        _actionType = actionType,
        _priority = priority;

  factory _$ApprovalRequestFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApprovalRequestFilterImplFromJson(json);

  final List<ApprovalStatus>? _status;
  @override
  List<ApprovalStatus>? get status {
    final value = _status;
    if (value == null) return null;
    if (_status is EqualUnmodifiableListView) return _status;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<ApprovalRequestType>? _requestType;
  @override
  List<ApprovalRequestType>? get requestType {
    final value = _requestType;
    if (value == null) return null;
    if (_requestType is EqualUnmodifiableListView) return _requestType;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<ApprovalActionType>? _actionType;
  @override
  List<ApprovalActionType>? get actionType {
    final value = _actionType;
    if (value == null) return null;
    if (_actionType is EqualUnmodifiableListView) return _actionType;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<ApprovalPriority>? _priority;
  @override
  List<ApprovalPriority>? get priority {
    final value = _priority;
    if (value == null) return null;
    if (_priority is EqualUnmodifiableListView) return _priority;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? initiatedBy;
  @override
  final String? regionalScope;
  @override
  final int? currentApprovalLevel;
  @override
  final DateTime? fromDate;
  @override
  final DateTime? toDate;
  @override
  final String? search;

  @override
  String toString() {
    return 'ApprovalRequestFilter(status: $status, requestType: $requestType, actionType: $actionType, priority: $priority, initiatedBy: $initiatedBy, regionalScope: $regionalScope, currentApprovalLevel: $currentApprovalLevel, fromDate: $fromDate, toDate: $toDate, search: $search)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApprovalRequestFilterImpl &&
            const DeepCollectionEquality().equals(other._status, _status) &&
            const DeepCollectionEquality()
                .equals(other._requestType, _requestType) &&
            const DeepCollectionEquality()
                .equals(other._actionType, _actionType) &&
            const DeepCollectionEquality().equals(other._priority, _priority) &&
            (identical(other.initiatedBy, initiatedBy) ||
                other.initiatedBy == initiatedBy) &&
            (identical(other.regionalScope, regionalScope) ||
                other.regionalScope == regionalScope) &&
            (identical(other.currentApprovalLevel, currentApprovalLevel) ||
                other.currentApprovalLevel == currentApprovalLevel) &&
            (identical(other.fromDate, fromDate) ||
                other.fromDate == fromDate) &&
            (identical(other.toDate, toDate) || other.toDate == toDate) &&
            (identical(other.search, search) || other.search == search));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_status),
      const DeepCollectionEquality().hash(_requestType),
      const DeepCollectionEquality().hash(_actionType),
      const DeepCollectionEquality().hash(_priority),
      initiatedBy,
      regionalScope,
      currentApprovalLevel,
      fromDate,
      toDate,
      search);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ApprovalRequestFilterImplCopyWith<_$ApprovalRequestFilterImpl>
      get copyWith => __$$ApprovalRequestFilterImplCopyWithImpl<
          _$ApprovalRequestFilterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApprovalRequestFilterImplToJson(
      this,
    );
  }
}

abstract class _ApprovalRequestFilter implements ApprovalRequestFilter {
  const factory _ApprovalRequestFilter(
      {final List<ApprovalStatus>? status,
      final List<ApprovalRequestType>? requestType,
      final List<ApprovalActionType>? actionType,
      final List<ApprovalPriority>? priority,
      final String? initiatedBy,
      final String? regionalScope,
      final int? currentApprovalLevel,
      final DateTime? fromDate,
      final DateTime? toDate,
      final String? search}) = _$ApprovalRequestFilterImpl;

  factory _ApprovalRequestFilter.fromJson(Map<String, dynamic> json) =
      _$ApprovalRequestFilterImpl.fromJson;

  @override
  List<ApprovalStatus>? get status;
  @override
  List<ApprovalRequestType>? get requestType;
  @override
  List<ApprovalActionType>? get actionType;
  @override
  List<ApprovalPriority>? get priority;
  @override
  String? get initiatedBy;
  @override
  String? get regionalScope;
  @override
  int? get currentApprovalLevel;
  @override
  DateTime? get fromDate;
  @override
  DateTime? get toDate;
  @override
  String? get search;
  @override
  @JsonKey(ignore: true)
  _$$ApprovalRequestFilterImplCopyWith<_$ApprovalRequestFilterImpl>
      get copyWith => throw _privateConstructorUsedError;
}
