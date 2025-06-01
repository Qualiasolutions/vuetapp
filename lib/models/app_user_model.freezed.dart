// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AppUserModel _$AppUserModelFromJson(Map<String, dynamic> json) {
  return _AppUserModel.fromJson(json);
}

/// @nodoc
mixin _$AppUserModel {
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'first_name')
  String? get firstName => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_name')
  String? get lastName => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError; // Stays 'email'
  String? get phone => throw _privateConstructorUsedError; // Stays 'phone'
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'professional_email')
  String? get professionalEmail => throw _privateConstructorUsedError;
  @JsonKey(name: 'professional_phone')
  String? get professionalPhone =>
      throw _privateConstructorUsedError; // Added JsonKey
  @JsonKey(name: 'account_type')
  String get accountType => throw _privateConstructorUsedError;
  @JsonKey(name: 'subscription_status')
  String get subscriptionStatus =>
      throw _privateConstructorUsedError; // Added JsonKey and snake_case
  @JsonKey(name: 'onboarding_completed')
  bool get onboardingCompleted =>
      throw _privateConstructorUsedError; // Added JsonKey and snake_case
  @JsonKey(name: 'date_of_birth')
  DateTime? get dateOfBirth =>
      throw _privateConstructorUsedError; // Added JsonKey and snake_case
  @JsonKey(name: 'member_color')
  String get memberColor => throw _privateConstructorUsedError;
  @JsonKey(name: 'family_id')
  String? get familyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'family_role')
  String? get familyRole =>
      throw _privateConstructorUsedError; // Added JsonKey and snake_case
  @JsonKey(name: 'created_at')
  DateTime get createdAt =>
      throw _privateConstructorUsedError; // Added JsonKey and snake_case
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this AppUserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppUserModelCopyWith<AppUserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppUserModelCopyWith<$Res> {
  factory $AppUserModelCopyWith(
          AppUserModel value, $Res Function(AppUserModel) then) =
      _$AppUserModelCopyWithImpl<$Res, AppUserModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'first_name') String? firstName,
      @JsonKey(name: 'last_name') String? lastName,
      String? email,
      String? phone,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      @JsonKey(name: 'professional_email') String? professionalEmail,
      @JsonKey(name: 'professional_phone') String? professionalPhone,
      @JsonKey(name: 'account_type') String accountType,
      @JsonKey(name: 'subscription_status') String subscriptionStatus,
      @JsonKey(name: 'onboarding_completed') bool onboardingCompleted,
      @JsonKey(name: 'date_of_birth') DateTime? dateOfBirth,
      @JsonKey(name: 'member_color') String memberColor,
      @JsonKey(name: 'family_id') String? familyId,
      @JsonKey(name: 'family_role') String? familyRole,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$AppUserModelCopyWithImpl<$Res, $Val extends AppUserModel>
    implements $AppUserModelCopyWith<$Res> {
  _$AppUserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? avatarUrl = freezed,
    Object? professionalEmail = freezed,
    Object? professionalPhone = freezed,
    Object? accountType = null,
    Object? subscriptionStatus = null,
    Object? onboardingCompleted = null,
    Object? dateOfBirth = freezed,
    Object? memberColor = null,
    Object? familyId = freezed,
    Object? familyRole = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      professionalEmail: freezed == professionalEmail
          ? _value.professionalEmail
          : professionalEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      professionalPhone: freezed == professionalPhone
          ? _value.professionalPhone
          : professionalPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      accountType: null == accountType
          ? _value.accountType
          : accountType // ignore: cast_nullable_to_non_nullable
              as String,
      subscriptionStatus: null == subscriptionStatus
          ? _value.subscriptionStatus
          : subscriptionStatus // ignore: cast_nullable_to_non_nullable
              as String,
      onboardingCompleted: null == onboardingCompleted
          ? _value.onboardingCompleted
          : onboardingCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      dateOfBirth: freezed == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      memberColor: null == memberColor
          ? _value.memberColor
          : memberColor // ignore: cast_nullable_to_non_nullable
              as String,
      familyId: freezed == familyId
          ? _value.familyId
          : familyId // ignore: cast_nullable_to_non_nullable
              as String?,
      familyRole: freezed == familyRole
          ? _value.familyRole
          : familyRole // ignore: cast_nullable_to_non_nullable
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
abstract class _$$AppUserModelImplCopyWith<$Res>
    implements $AppUserModelCopyWith<$Res> {
  factory _$$AppUserModelImplCopyWith(
          _$AppUserModelImpl value, $Res Function(_$AppUserModelImpl) then) =
      __$$AppUserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'first_name') String? firstName,
      @JsonKey(name: 'last_name') String? lastName,
      String? email,
      String? phone,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      @JsonKey(name: 'professional_email') String? professionalEmail,
      @JsonKey(name: 'professional_phone') String? professionalPhone,
      @JsonKey(name: 'account_type') String accountType,
      @JsonKey(name: 'subscription_status') String subscriptionStatus,
      @JsonKey(name: 'onboarding_completed') bool onboardingCompleted,
      @JsonKey(name: 'date_of_birth') DateTime? dateOfBirth,
      @JsonKey(name: 'member_color') String memberColor,
      @JsonKey(name: 'family_id') String? familyId,
      @JsonKey(name: 'family_role') String? familyRole,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$AppUserModelImplCopyWithImpl<$Res>
    extends _$AppUserModelCopyWithImpl<$Res, _$AppUserModelImpl>
    implements _$$AppUserModelImplCopyWith<$Res> {
  __$$AppUserModelImplCopyWithImpl(
      _$AppUserModelImpl _value, $Res Function(_$AppUserModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? avatarUrl = freezed,
    Object? professionalEmail = freezed,
    Object? professionalPhone = freezed,
    Object? accountType = null,
    Object? subscriptionStatus = null,
    Object? onboardingCompleted = null,
    Object? dateOfBirth = freezed,
    Object? memberColor = null,
    Object? familyId = freezed,
    Object? familyRole = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$AppUserModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      professionalEmail: freezed == professionalEmail
          ? _value.professionalEmail
          : professionalEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      professionalPhone: freezed == professionalPhone
          ? _value.professionalPhone
          : professionalPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      accountType: null == accountType
          ? _value.accountType
          : accountType // ignore: cast_nullable_to_non_nullable
              as String,
      subscriptionStatus: null == subscriptionStatus
          ? _value.subscriptionStatus
          : subscriptionStatus // ignore: cast_nullable_to_non_nullable
              as String,
      onboardingCompleted: null == onboardingCompleted
          ? _value.onboardingCompleted
          : onboardingCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      dateOfBirth: freezed == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      memberColor: null == memberColor
          ? _value.memberColor
          : memberColor // ignore: cast_nullable_to_non_nullable
              as String,
      familyId: freezed == familyId
          ? _value.familyId
          : familyId // ignore: cast_nullable_to_non_nullable
              as String?,
      familyRole: freezed == familyRole
          ? _value.familyRole
          : familyRole // ignore: cast_nullable_to_non_nullable
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
class _$AppUserModelImpl implements _AppUserModel {
  const _$AppUserModelImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'first_name') this.firstName,
      @JsonKey(name: 'last_name') this.lastName,
      this.email,
      this.phone,
      @JsonKey(name: 'avatar_url') this.avatarUrl,
      @JsonKey(name: 'professional_email') this.professionalEmail,
      @JsonKey(name: 'professional_phone') this.professionalPhone,
      @JsonKey(name: 'account_type') this.accountType = 'personal',
      @JsonKey(name: 'subscription_status') this.subscriptionStatus = 'free',
      @JsonKey(name: 'onboarding_completed') this.onboardingCompleted = false,
      @JsonKey(name: 'date_of_birth') this.dateOfBirth,
      @JsonKey(name: 'member_color') this.memberColor = '#0066cc',
      @JsonKey(name: 'family_id') this.familyId,
      @JsonKey(name: 'family_role') this.familyRole,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt});

  factory _$AppUserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppUserModelImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final String id;
  @override
  @JsonKey(name: 'first_name')
  final String? firstName;
  @override
  @JsonKey(name: 'last_name')
  final String? lastName;
  @override
  final String? email;
// Stays 'email'
  @override
  final String? phone;
// Stays 'phone'
  @override
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  @override
  @JsonKey(name: 'professional_email')
  final String? professionalEmail;
  @override
  @JsonKey(name: 'professional_phone')
  final String? professionalPhone;
// Added JsonKey
  @override
  @JsonKey(name: 'account_type')
  final String accountType;
  @override
  @JsonKey(name: 'subscription_status')
  final String subscriptionStatus;
// Added JsonKey and snake_case
  @override
  @JsonKey(name: 'onboarding_completed')
  final bool onboardingCompleted;
// Added JsonKey and snake_case
  @override
  @JsonKey(name: 'date_of_birth')
  final DateTime? dateOfBirth;
// Added JsonKey and snake_case
  @override
  @JsonKey(name: 'member_color')
  final String memberColor;
  @override
  @JsonKey(name: 'family_id')
  final String? familyId;
  @override
  @JsonKey(name: 'family_role')
  final String? familyRole;
// Added JsonKey and snake_case
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
// Added JsonKey and snake_case
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'AppUserModel(id: $id, firstName: $firstName, lastName: $lastName, email: $email, phone: $phone, avatarUrl: $avatarUrl, professionalEmail: $professionalEmail, professionalPhone: $professionalPhone, accountType: $accountType, subscriptionStatus: $subscriptionStatus, onboardingCompleted: $onboardingCompleted, dateOfBirth: $dateOfBirth, memberColor: $memberColor, familyId: $familyId, familyRole: $familyRole, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppUserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.professionalEmail, professionalEmail) ||
                other.professionalEmail == professionalEmail) &&
            (identical(other.professionalPhone, professionalPhone) ||
                other.professionalPhone == professionalPhone) &&
            (identical(other.accountType, accountType) ||
                other.accountType == accountType) &&
            (identical(other.subscriptionStatus, subscriptionStatus) ||
                other.subscriptionStatus == subscriptionStatus) &&
            (identical(other.onboardingCompleted, onboardingCompleted) ||
                other.onboardingCompleted == onboardingCompleted) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth) &&
            (identical(other.memberColor, memberColor) ||
                other.memberColor == memberColor) &&
            (identical(other.familyId, familyId) ||
                other.familyId == familyId) &&
            (identical(other.familyRole, familyRole) ||
                other.familyRole == familyRole) &&
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
      firstName,
      lastName,
      email,
      phone,
      avatarUrl,
      professionalEmail,
      professionalPhone,
      accountType,
      subscriptionStatus,
      onboardingCompleted,
      dateOfBirth,
      memberColor,
      familyId,
      familyRole,
      createdAt,
      updatedAt);

  /// Create a copy of AppUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppUserModelImplCopyWith<_$AppUserModelImpl> get copyWith =>
      __$$AppUserModelImplCopyWithImpl<_$AppUserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppUserModelImplToJson(
      this,
    );
  }
}

abstract class _AppUserModel implements AppUserModel {
  const factory _AppUserModel(
          {@JsonKey(name: 'id') required final String id,
          @JsonKey(name: 'first_name') final String? firstName,
          @JsonKey(name: 'last_name') final String? lastName,
          final String? email,
          final String? phone,
          @JsonKey(name: 'avatar_url') final String? avatarUrl,
          @JsonKey(name: 'professional_email') final String? professionalEmail,
          @JsonKey(name: 'professional_phone') final String? professionalPhone,
          @JsonKey(name: 'account_type') final String accountType,
          @JsonKey(name: 'subscription_status') final String subscriptionStatus,
          @JsonKey(name: 'onboarding_completed') final bool onboardingCompleted,
          @JsonKey(name: 'date_of_birth') final DateTime? dateOfBirth,
          @JsonKey(name: 'member_color') final String memberColor,
          @JsonKey(name: 'family_id') final String? familyId,
          @JsonKey(name: 'family_role') final String? familyRole,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt}) =
      _$AppUserModelImpl;

  factory _AppUserModel.fromJson(Map<String, dynamic> json) =
      _$AppUserModelImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  String get id;
  @override
  @JsonKey(name: 'first_name')
  String? get firstName;
  @override
  @JsonKey(name: 'last_name')
  String? get lastName;
  @override
  String? get email; // Stays 'email'
  @override
  String? get phone; // Stays 'phone'
  @override
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl;
  @override
  @JsonKey(name: 'professional_email')
  String? get professionalEmail;
  @override
  @JsonKey(name: 'professional_phone')
  String? get professionalPhone; // Added JsonKey
  @override
  @JsonKey(name: 'account_type')
  String get accountType;
  @override
  @JsonKey(name: 'subscription_status')
  String get subscriptionStatus; // Added JsonKey and snake_case
  @override
  @JsonKey(name: 'onboarding_completed')
  bool get onboardingCompleted; // Added JsonKey and snake_case
  @override
  @JsonKey(name: 'date_of_birth')
  DateTime? get dateOfBirth; // Added JsonKey and snake_case
  @override
  @JsonKey(name: 'member_color')
  String get memberColor;
  @override
  @JsonKey(name: 'family_id')
  String? get familyId;
  @override
  @JsonKey(name: 'family_role')
  String? get familyRole; // Added JsonKey and snake_case
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt; // Added JsonKey and snake_case
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of AppUserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppUserModelImplCopyWith<_$AppUserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
