// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_stats_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HomeStats {
  int get activeUsers => throw _privateConstructorUsedError;
  int get institutions => throw _privateConstructorUsedError;
  int get countries => throw _privateConstructorUsedError;
  int get universities => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HomeStatsCopyWith<HomeStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeStatsCopyWith<$Res> {
  factory $HomeStatsCopyWith(HomeStats value, $Res Function(HomeStats) then) =
      _$HomeStatsCopyWithImpl<$Res, HomeStats>;
  @useResult
  $Res call(
      {int activeUsers,
      int institutions,
      int countries,
      int universities,
      bool isLoading,
      String? error});
}

/// @nodoc
class _$HomeStatsCopyWithImpl<$Res, $Val extends HomeStats>
    implements $HomeStatsCopyWith<$Res> {
  _$HomeStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activeUsers = null,
    Object? institutions = null,
    Object? countries = null,
    Object? universities = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      activeUsers: null == activeUsers
          ? _value.activeUsers
          : activeUsers // ignore: cast_nullable_to_non_nullable
              as int,
      institutions: null == institutions
          ? _value.institutions
          : institutions // ignore: cast_nullable_to_non_nullable
              as int,
      countries: null == countries
          ? _value.countries
          : countries // ignore: cast_nullable_to_non_nullable
              as int,
      universities: null == universities
          ? _value.universities
          : universities // ignore: cast_nullable_to_non_nullable
              as int,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HomeStatsImplCopyWith<$Res>
    implements $HomeStatsCopyWith<$Res> {
  factory _$$HomeStatsImplCopyWith(
          _$HomeStatsImpl value, $Res Function(_$HomeStatsImpl) then) =
      __$$HomeStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int activeUsers,
      int institutions,
      int countries,
      int universities,
      bool isLoading,
      String? error});
}

/// @nodoc
class __$$HomeStatsImplCopyWithImpl<$Res>
    extends _$HomeStatsCopyWithImpl<$Res, _$HomeStatsImpl>
    implements _$$HomeStatsImplCopyWith<$Res> {
  __$$HomeStatsImplCopyWithImpl(
      _$HomeStatsImpl _value, $Res Function(_$HomeStatsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activeUsers = null,
    Object? institutions = null,
    Object? countries = null,
    Object? universities = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_$HomeStatsImpl(
      activeUsers: null == activeUsers
          ? _value.activeUsers
          : activeUsers // ignore: cast_nullable_to_non_nullable
              as int,
      institutions: null == institutions
          ? _value.institutions
          : institutions // ignore: cast_nullable_to_non_nullable
              as int,
      countries: null == countries
          ? _value.countries
          : countries // ignore: cast_nullable_to_non_nullable
              as int,
      universities: null == universities
          ? _value.universities
          : universities // ignore: cast_nullable_to_non_nullable
              as int,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$HomeStatsImpl implements _HomeStats {
  const _$HomeStatsImpl(
      {this.activeUsers = 0,
      this.institutions = 0,
      this.countries = 0,
      this.universities = 0,
      this.isLoading = false,
      this.error});

  @override
  @JsonKey()
  final int activeUsers;
  @override
  @JsonKey()
  final int institutions;
  @override
  @JsonKey()
  final int countries;
  @override
  @JsonKey()
  final int universities;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;

  @override
  String toString() {
    return 'HomeStats(activeUsers: $activeUsers, institutions: $institutions, countries: $countries, universities: $universities, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeStatsImpl &&
            (identical(other.activeUsers, activeUsers) ||
                other.activeUsers == activeUsers) &&
            (identical(other.institutions, institutions) ||
                other.institutions == institutions) &&
            (identical(other.countries, countries) ||
                other.countries == countries) &&
            (identical(other.universities, universities) ||
                other.universities == universities) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, activeUsers, institutions,
      countries, universities, isLoading, error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeStatsImplCopyWith<_$HomeStatsImpl> get copyWith =>
      __$$HomeStatsImplCopyWithImpl<_$HomeStatsImpl>(this, _$identity);
}

abstract class _HomeStats implements HomeStats {
  const factory _HomeStats(
      {final int activeUsers,
      final int institutions,
      final int countries,
      final int universities,
      final bool isLoading,
      final String? error}) = _$HomeStatsImpl;

  @override
  int get activeUsers;
  @override
  int get institutions;
  @override
  int get countries;
  @override
  int get universities;
  @override
  bool get isLoading;
  @override
  String? get error;
  @override
  @JsonKey(ignore: true)
  _$$HomeStatsImplCopyWith<_$HomeStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
