// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'family_invitation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FamilyInvitationModel _$FamilyInvitationModelFromJson(
    Map<String, dynamic> json) {
  return _FamilyInvitationModel.fromJson(json);
}

/// @nodoc
mixin _$FamilyInvitationModel {
  /// Unique ID of the invitation
  String get id => throw _privateConstructorUsedError;

  /// ID of the user who sent the invitation
  String get inviterId => throw _privateConstructorUsedError;

  /// Email address of the invitee
  String get inviteeEmail => throw _privateConstructorUsedError;

  /// ID of the family this invitation is for
  String get familyId => throw _privateConstructorUsedError;

  /// When the invitation was created
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// When the invitation expires
  DateTime get expiresAt => throw _privateConstructorUsedError;

  /// Status of the invitation
  FamilyInvitationStatus get status => throw _privateConstructorUsedError;

  /// Optional message from the inviter
  String? get message => throw _privateConstructorUsedError;

  /// Details about the inviter (populated when needed)
  String? get inviterName => throw _privateConstructorUsedError;
  String? get inviterEmail => throw _privateConstructorUsedError;

  /// Details about the family (populated when needed)
  String? get familyName => throw _privateConstructorUsedError;
  String? get familyImageUrl => throw _privateConstructorUsedError;

  /// When the invitation was responded to (accepted/declined)
  DateTime? get respondedAt => throw _privateConstructorUsedError;

  /// Serializes this FamilyInvitationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FamilyInvitationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FamilyInvitationModelCopyWith<FamilyInvitationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FamilyInvitationModelCopyWith<$Res> {
  factory $FamilyInvitationModelCopyWith(FamilyInvitationModel value,
          $Res Function(FamilyInvitationModel) then) =
      _$FamilyInvitationModelCopyWithImpl<$Res, FamilyInvitationModel>;
  @useResult
  $Res call(
      {String id,
      String inviterId,
      String inviteeEmail,
      String familyId,
      DateTime createdAt,
      DateTime expiresAt,
      FamilyInvitationStatus status,
      String? message,
      String? inviterName,
      String? inviterEmail,
      String? familyName,
      String? familyImageUrl,
      DateTime? respondedAt});
}

/// @nodoc
class _$FamilyInvitationModelCopyWithImpl<$Res,
        $Val extends FamilyInvitationModel>
    implements $FamilyInvitationModelCopyWith<$Res> {
  _$FamilyInvitationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FamilyInvitationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? inviterId = null,
    Object? inviteeEmail = null,
    Object? familyId = null,
    Object? createdAt = null,
    Object? expiresAt = null,
    Object? status = null,
    Object? message = freezed,
    Object? inviterName = freezed,
    Object? inviterEmail = freezed,
    Object? familyName = freezed,
    Object? familyImageUrl = freezed,
    Object? respondedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      inviterId: null == inviterId
          ? _value.inviterId
          : inviterId // ignore: cast_nullable_to_non_nullable
              as String,
      inviteeEmail: null == inviteeEmail
          ? _value.inviteeEmail
          : inviteeEmail // ignore: cast_nullable_to_non_nullable
              as String,
      familyId: null == familyId
          ? _value.familyId
          : familyId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as FamilyInvitationStatus,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      inviterName: freezed == inviterName
          ? _value.inviterName
          : inviterName // ignore: cast_nullable_to_non_nullable
              as String?,
      inviterEmail: freezed == inviterEmail
          ? _value.inviterEmail
          : inviterEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      familyName: freezed == familyName
          ? _value.familyName
          : familyName // ignore: cast_nullable_to_non_nullable
              as String?,
      familyImageUrl: freezed == familyImageUrl
          ? _value.familyImageUrl
          : familyImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      respondedAt: freezed == respondedAt
          ? _value.respondedAt
          : respondedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FamilyInvitationModelImplCopyWith<$Res>
    implements $FamilyInvitationModelCopyWith<$Res> {
  factory _$$FamilyInvitationModelImplCopyWith(
          _$FamilyInvitationModelImpl value,
          $Res Function(_$FamilyInvitationModelImpl) then) =
      __$$FamilyInvitationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String inviterId,
      String inviteeEmail,
      String familyId,
      DateTime createdAt,
      DateTime expiresAt,
      FamilyInvitationStatus status,
      String? message,
      String? inviterName,
      String? inviterEmail,
      String? familyName,
      String? familyImageUrl,
      DateTime? respondedAt});
}

/// @nodoc
class __$$FamilyInvitationModelImplCopyWithImpl<$Res>
    extends _$FamilyInvitationModelCopyWithImpl<$Res,
        _$FamilyInvitationModelImpl>
    implements _$$FamilyInvitationModelImplCopyWith<$Res> {
  __$$FamilyInvitationModelImplCopyWithImpl(_$FamilyInvitationModelImpl _value,
      $Res Function(_$FamilyInvitationModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of FamilyInvitationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? inviterId = null,
    Object? inviteeEmail = null,
    Object? familyId = null,
    Object? createdAt = null,
    Object? expiresAt = null,
    Object? status = null,
    Object? message = freezed,
    Object? inviterName = freezed,
    Object? inviterEmail = freezed,
    Object? familyName = freezed,
    Object? familyImageUrl = freezed,
    Object? respondedAt = freezed,
  }) {
    return _then(_$FamilyInvitationModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      inviterId: null == inviterId
          ? _value.inviterId
          : inviterId // ignore: cast_nullable_to_non_nullable
              as String,
      inviteeEmail: null == inviteeEmail
          ? _value.inviteeEmail
          : inviteeEmail // ignore: cast_nullable_to_non_nullable
              as String,
      familyId: null == familyId
          ? _value.familyId
          : familyId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as FamilyInvitationStatus,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      inviterName: freezed == inviterName
          ? _value.inviterName
          : inviterName // ignore: cast_nullable_to_non_nullable
              as String?,
      inviterEmail: freezed == inviterEmail
          ? _value.inviterEmail
          : inviterEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      familyName: freezed == familyName
          ? _value.familyName
          : familyName // ignore: cast_nullable_to_non_nullable
              as String?,
      familyImageUrl: freezed == familyImageUrl
          ? _value.familyImageUrl
          : familyImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      respondedAt: freezed == respondedAt
          ? _value.respondedAt
          : respondedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FamilyInvitationModelImpl implements _FamilyInvitationModel {
  const _$FamilyInvitationModelImpl(
      {required this.id,
      required this.inviterId,
      required this.inviteeEmail,
      required this.familyId,
      required this.createdAt,
      required this.expiresAt,
      this.status = FamilyInvitationStatus.pending,
      this.message,
      this.inviterName,
      this.inviterEmail,
      this.familyName,
      this.familyImageUrl,
      this.respondedAt});

  factory _$FamilyInvitationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FamilyInvitationModelImplFromJson(json);

  /// Unique ID of the invitation
  @override
  final String id;

  /// ID of the user who sent the invitation
  @override
  final String inviterId;

  /// Email address of the invitee
  @override
  final String inviteeEmail;

  /// ID of the family this invitation is for
  @override
  final String familyId;

  /// When the invitation was created
  @override
  final DateTime createdAt;

  /// When the invitation expires
  @override
  final DateTime expiresAt;

  /// Status of the invitation
  @override
  @JsonKey()
  final FamilyInvitationStatus status;

  /// Optional message from the inviter
  @override
  final String? message;

  /// Details about the inviter (populated when needed)
  @override
  final String? inviterName;
  @override
  final String? inviterEmail;

  /// Details about the family (populated when needed)
  @override
  final String? familyName;
  @override
  final String? familyImageUrl;

  /// When the invitation was responded to (accepted/declined)
  @override
  final DateTime? respondedAt;

  @override
  String toString() {
    return 'FamilyInvitationModel(id: $id, inviterId: $inviterId, inviteeEmail: $inviteeEmail, familyId: $familyId, createdAt: $createdAt, expiresAt: $expiresAt, status: $status, message: $message, inviterName: $inviterName, inviterEmail: $inviterEmail, familyName: $familyName, familyImageUrl: $familyImageUrl, respondedAt: $respondedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FamilyInvitationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.inviterId, inviterId) ||
                other.inviterId == inviterId) &&
            (identical(other.inviteeEmail, inviteeEmail) ||
                other.inviteeEmail == inviteeEmail) &&
            (identical(other.familyId, familyId) ||
                other.familyId == familyId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.inviterName, inviterName) ||
                other.inviterName == inviterName) &&
            (identical(other.inviterEmail, inviterEmail) ||
                other.inviterEmail == inviterEmail) &&
            (identical(other.familyName, familyName) ||
                other.familyName == familyName) &&
            (identical(other.familyImageUrl, familyImageUrl) ||
                other.familyImageUrl == familyImageUrl) &&
            (identical(other.respondedAt, respondedAt) ||
                other.respondedAt == respondedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      inviterId,
      inviteeEmail,
      familyId,
      createdAt,
      expiresAt,
      status,
      message,
      inviterName,
      inviterEmail,
      familyName,
      familyImageUrl,
      respondedAt);

  /// Create a copy of FamilyInvitationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FamilyInvitationModelImplCopyWith<_$FamilyInvitationModelImpl>
      get copyWith => __$$FamilyInvitationModelImplCopyWithImpl<
          _$FamilyInvitationModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FamilyInvitationModelImplToJson(
      this,
    );
  }
}

abstract class _FamilyInvitationModel implements FamilyInvitationModel {
  const factory _FamilyInvitationModel(
      {required final String id,
      required final String inviterId,
      required final String inviteeEmail,
      required final String familyId,
      required final DateTime createdAt,
      required final DateTime expiresAt,
      final FamilyInvitationStatus status,
      final String? message,
      final String? inviterName,
      final String? inviterEmail,
      final String? familyName,
      final String? familyImageUrl,
      final DateTime? respondedAt}) = _$FamilyInvitationModelImpl;

  factory _FamilyInvitationModel.fromJson(Map<String, dynamic> json) =
      _$FamilyInvitationModelImpl.fromJson;

  /// Unique ID of the invitation
  @override
  String get id;

  /// ID of the user who sent the invitation
  @override
  String get inviterId;

  /// Email address of the invitee
  @override
  String get inviteeEmail;

  /// ID of the family this invitation is for
  @override
  String get familyId;

  /// When the invitation was created
  @override
  DateTime get createdAt;

  /// When the invitation expires
  @override
  DateTime get expiresAt;

  /// Status of the invitation
  @override
  FamilyInvitationStatus get status;

  /// Optional message from the inviter
  @override
  String? get message;

  /// Details about the inviter (populated when needed)
  @override
  String? get inviterName;
  @override
  String? get inviterEmail;

  /// Details about the family (populated when needed)
  @override
  String? get familyName;
  @override
  String? get familyImageUrl;

  /// When the invitation was responded to (accepted/declined)
  @override
  DateTime? get respondedAt;

  /// Create a copy of FamilyInvitationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FamilyInvitationModelImplCopyWith<_$FamilyInvitationModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
