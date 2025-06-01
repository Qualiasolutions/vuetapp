// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ical_integration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ICalIntegration _$ICalIntegrationFromJson(Map<String, dynamic> json) {
  return _ICalIntegration.fromJson(json);
}

/// @nodoc
mixin _$ICalIntegration {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get icalName => throw _privateConstructorUsedError;
  String get icalUrl =>
      throw _privateConstructorUsedError; // URL used for syncing
  ICalType get icalType => throw _privateConstructorUsedError;
  ICalShareType get shareType => throw _privateConstructorUsedError;
  DateTime? get lastSyncedAt => throw _privateConstructorUsedError;
  SyncStatus? get syncStatus => throw _privateConstructorUsedError;
  String? get syncErrorMessage => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ICalIntegration to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ICalIntegration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ICalIntegrationCopyWith<ICalIntegration> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ICalIntegrationCopyWith<$Res> {
  factory $ICalIntegrationCopyWith(
          ICalIntegration value, $Res Function(ICalIntegration) then) =
      _$ICalIntegrationCopyWithImpl<$Res, ICalIntegration>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String icalName,
      String icalUrl,
      ICalType icalType,
      ICalShareType shareType,
      DateTime? lastSyncedAt,
      SyncStatus? syncStatus,
      String? syncErrorMessage,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$ICalIntegrationCopyWithImpl<$Res, $Val extends ICalIntegration>
    implements $ICalIntegrationCopyWith<$Res> {
  _$ICalIntegrationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ICalIntegration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? icalName = null,
    Object? icalUrl = null,
    Object? icalType = null,
    Object? shareType = null,
    Object? lastSyncedAt = freezed,
    Object? syncStatus = freezed,
    Object? syncErrorMessage = freezed,
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
      icalName: null == icalName
          ? _value.icalName
          : icalName // ignore: cast_nullable_to_non_nullable
              as String,
      icalUrl: null == icalUrl
          ? _value.icalUrl
          : icalUrl // ignore: cast_nullable_to_non_nullable
              as String,
      icalType: null == icalType
          ? _value.icalType
          : icalType // ignore: cast_nullable_to_non_nullable
              as ICalType,
      shareType: null == shareType
          ? _value.shareType
          : shareType // ignore: cast_nullable_to_non_nullable
              as ICalShareType,
      lastSyncedAt: freezed == lastSyncedAt
          ? _value.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      syncStatus: freezed == syncStatus
          ? _value.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as SyncStatus?,
      syncErrorMessage: freezed == syncErrorMessage
          ? _value.syncErrorMessage
          : syncErrorMessage // ignore: cast_nullable_to_non_nullable
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
abstract class _$$ICalIntegrationImplCopyWith<$Res>
    implements $ICalIntegrationCopyWith<$Res> {
  factory _$$ICalIntegrationImplCopyWith(_$ICalIntegrationImpl value,
          $Res Function(_$ICalIntegrationImpl) then) =
      __$$ICalIntegrationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String icalName,
      String icalUrl,
      ICalType icalType,
      ICalShareType shareType,
      DateTime? lastSyncedAt,
      SyncStatus? syncStatus,
      String? syncErrorMessage,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$ICalIntegrationImplCopyWithImpl<$Res>
    extends _$ICalIntegrationCopyWithImpl<$Res, _$ICalIntegrationImpl>
    implements _$$ICalIntegrationImplCopyWith<$Res> {
  __$$ICalIntegrationImplCopyWithImpl(
      _$ICalIntegrationImpl _value, $Res Function(_$ICalIntegrationImpl) _then)
      : super(_value, _then);

  /// Create a copy of ICalIntegration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? icalName = null,
    Object? icalUrl = null,
    Object? icalType = null,
    Object? shareType = null,
    Object? lastSyncedAt = freezed,
    Object? syncStatus = freezed,
    Object? syncErrorMessage = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ICalIntegrationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      icalName: null == icalName
          ? _value.icalName
          : icalName // ignore: cast_nullable_to_non_nullable
              as String,
      icalUrl: null == icalUrl
          ? _value.icalUrl
          : icalUrl // ignore: cast_nullable_to_non_nullable
              as String,
      icalType: null == icalType
          ? _value.icalType
          : icalType // ignore: cast_nullable_to_non_nullable
              as ICalType,
      shareType: null == shareType
          ? _value.shareType
          : shareType // ignore: cast_nullable_to_non_nullable
              as ICalShareType,
      lastSyncedAt: freezed == lastSyncedAt
          ? _value.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      syncStatus: freezed == syncStatus
          ? _value.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as SyncStatus?,
      syncErrorMessage: freezed == syncErrorMessage
          ? _value.syncErrorMessage
          : syncErrorMessage // ignore: cast_nullable_to_non_nullable
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
class _$ICalIntegrationImpl implements _ICalIntegration {
  const _$ICalIntegrationImpl(
      {required this.id,
      required this.userId,
      required this.icalName,
      required this.icalUrl,
      required this.icalType,
      required this.shareType,
      this.lastSyncedAt,
      this.syncStatus,
      this.syncErrorMessage,
      required this.createdAt,
      required this.updatedAt});

  factory _$ICalIntegrationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ICalIntegrationImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String icalName;
  @override
  final String icalUrl;
// URL used for syncing
  @override
  final ICalType icalType;
  @override
  final ICalShareType shareType;
  @override
  final DateTime? lastSyncedAt;
  @override
  final SyncStatus? syncStatus;
  @override
  final String? syncErrorMessage;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ICalIntegration(id: $id, userId: $userId, icalName: $icalName, icalUrl: $icalUrl, icalType: $icalType, shareType: $shareType, lastSyncedAt: $lastSyncedAt, syncStatus: $syncStatus, syncErrorMessage: $syncErrorMessage, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ICalIntegrationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.icalName, icalName) ||
                other.icalName == icalName) &&
            (identical(other.icalUrl, icalUrl) || other.icalUrl == icalUrl) &&
            (identical(other.icalType, icalType) ||
                other.icalType == icalType) &&
            (identical(other.shareType, shareType) ||
                other.shareType == shareType) &&
            (identical(other.lastSyncedAt, lastSyncedAt) ||
                other.lastSyncedAt == lastSyncedAt) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus) &&
            (identical(other.syncErrorMessage, syncErrorMessage) ||
                other.syncErrorMessage == syncErrorMessage) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      icalName,
      icalUrl,
      icalType,
      shareType,
      lastSyncedAt,
      syncStatus,
      syncErrorMessage,
      createdAt,
      updatedAt);

  /// Create a copy of ICalIntegration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ICalIntegrationImplCopyWith<_$ICalIntegrationImpl> get copyWith =>
      __$$ICalIntegrationImplCopyWithImpl<_$ICalIntegrationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ICalIntegrationImplToJson(
      this,
    );
  }
}

abstract class _ICalIntegration implements ICalIntegration {
  const factory _ICalIntegration(
      {required final String id,
      required final String userId,
      required final String icalName,
      required final String icalUrl,
      required final ICalType icalType,
      required final ICalShareType shareType,
      final DateTime? lastSyncedAt,
      final SyncStatus? syncStatus,
      final String? syncErrorMessage,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$ICalIntegrationImpl;

  factory _ICalIntegration.fromJson(Map<String, dynamic> json) =
      _$ICalIntegrationImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get icalName;
  @override
  String get icalUrl; // URL used for syncing
  @override
  ICalType get icalType;
  @override
  ICalShareType get shareType;
  @override
  DateTime? get lastSyncedAt;
  @override
  SyncStatus? get syncStatus;
  @override
  String? get syncErrorMessage;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of ICalIntegration
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ICalIntegrationImplCopyWith<_$ICalIntegrationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
