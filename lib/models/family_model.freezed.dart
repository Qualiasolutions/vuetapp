// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'family_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FamilyModel _$FamilyModelFromJson(Map<String, dynamic> json) {
  return _FamilyModel.fromJson(json);
}

/// @nodoc
mixin _$FamilyModel {
  /// Unique ID of the family
  String get id => throw _privateConstructorUsedError;

  /// Name of the family group
  String get name => throw _privateConstructorUsedError;

  /// URL to the family's profile image
  String? get imageUrl => throw _privateConstructorUsedError;

  /// ID of the user who owns/created this family
  String get ownerId => throw _privateConstructorUsedError;

  /// Family settings and preferences
  Map<String, dynamic> get settings => throw _privateConstructorUsedError;

  /// When the family was created
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// When the family was last updated
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// List of family members (populated when needed)
  List<FamilyMemberModel> get members => throw _privateConstructorUsedError;

  /// Serializes this FamilyModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FamilyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FamilyModelCopyWith<FamilyModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FamilyModelCopyWith<$Res> {
  factory $FamilyModelCopyWith(
          FamilyModel value, $Res Function(FamilyModel) then) =
      _$FamilyModelCopyWithImpl<$Res, FamilyModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? imageUrl,
      String ownerId,
      Map<String, dynamic> settings,
      DateTime createdAt,
      DateTime updatedAt,
      List<FamilyMemberModel> members});
}

/// @nodoc
class _$FamilyModelCopyWithImpl<$Res, $Val extends FamilyModel>
    implements $FamilyModelCopyWith<$Res> {
  _$FamilyModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FamilyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? imageUrl = freezed,
    Object? ownerId = null,
    Object? settings = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? members = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      members: null == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<FamilyMemberModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FamilyModelImplCopyWith<$Res>
    implements $FamilyModelCopyWith<$Res> {
  factory _$$FamilyModelImplCopyWith(
          _$FamilyModelImpl value, $Res Function(_$FamilyModelImpl) then) =
      __$$FamilyModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? imageUrl,
      String ownerId,
      Map<String, dynamic> settings,
      DateTime createdAt,
      DateTime updatedAt,
      List<FamilyMemberModel> members});
}

/// @nodoc
class __$$FamilyModelImplCopyWithImpl<$Res>
    extends _$FamilyModelCopyWithImpl<$Res, _$FamilyModelImpl>
    implements _$$FamilyModelImplCopyWith<$Res> {
  __$$FamilyModelImplCopyWithImpl(
      _$FamilyModelImpl _value, $Res Function(_$FamilyModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of FamilyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? imageUrl = freezed,
    Object? ownerId = null,
    Object? settings = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? members = null,
  }) {
    return _then(_$FamilyModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      settings: null == settings
          ? _value._settings
          : settings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      members: null == members
          ? _value._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<FamilyMemberModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FamilyModelImpl implements _FamilyModel {
  const _$FamilyModelImpl(
      {required this.id,
      required this.name,
      this.imageUrl,
      required this.ownerId,
      final Map<String, dynamic> settings = const {},
      required this.createdAt,
      required this.updatedAt,
      final List<FamilyMemberModel> members = const []})
      : _settings = settings,
        _members = members;

  factory _$FamilyModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FamilyModelImplFromJson(json);

  /// Unique ID of the family
  @override
  final String id;

  /// Name of the family group
  @override
  final String name;

  /// URL to the family's profile image
  @override
  final String? imageUrl;

  /// ID of the user who owns/created this family
  @override
  final String ownerId;

  /// Family settings and preferences
  final Map<String, dynamic> _settings;

  /// Family settings and preferences
  @override
  @JsonKey()
  Map<String, dynamic> get settings {
    if (_settings is EqualUnmodifiableMapView) return _settings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_settings);
  }

  /// When the family was created
  @override
  final DateTime createdAt;

  /// When the family was last updated
  @override
  final DateTime updatedAt;

  /// List of family members (populated when needed)
  final List<FamilyMemberModel> _members;

  /// List of family members (populated when needed)
  @override
  @JsonKey()
  List<FamilyMemberModel> get members {
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
  }

  @override
  String toString() {
    return 'FamilyModel(id: $id, name: $name, imageUrl: $imageUrl, ownerId: $ownerId, settings: $settings, createdAt: $createdAt, updatedAt: $updatedAt, members: $members)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FamilyModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            const DeepCollectionEquality().equals(other._settings, _settings) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._members, _members));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      imageUrl,
      ownerId,
      const DeepCollectionEquality().hash(_settings),
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_members));

  /// Create a copy of FamilyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FamilyModelImplCopyWith<_$FamilyModelImpl> get copyWith =>
      __$$FamilyModelImplCopyWithImpl<_$FamilyModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FamilyModelImplToJson(
      this,
    );
  }
}

abstract class _FamilyModel implements FamilyModel {
  const factory _FamilyModel(
      {required final String id,
      required final String name,
      final String? imageUrl,
      required final String ownerId,
      final Map<String, dynamic> settings,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final List<FamilyMemberModel> members}) = _$FamilyModelImpl;

  factory _FamilyModel.fromJson(Map<String, dynamic> json) =
      _$FamilyModelImpl.fromJson;

  /// Unique ID of the family
  @override
  String get id;

  /// Name of the family group
  @override
  String get name;

  /// URL to the family's profile image
  @override
  String? get imageUrl;

  /// ID of the user who owns/created this family
  @override
  String get ownerId;

  /// Family settings and preferences
  @override
  Map<String, dynamic> get settings;

  /// When the family was created
  @override
  DateTime get createdAt;

  /// When the family was last updated
  @override
  DateTime get updatedAt;

  /// List of family members (populated when needed)
  @override
  List<FamilyMemberModel> get members;

  /// Create a copy of FamilyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FamilyModelImplCopyWith<_$FamilyModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FamilyMemberModel _$FamilyMemberModelFromJson(Map<String, dynamic> json) {
  return _FamilyMemberModel.fromJson(json);
}

/// @nodoc
mixin _$FamilyMemberModel {
  /// User ID of the family member
  String get userId => throw _privateConstructorUsedError;

  /// Family ID this member belongs to
  String get familyId => throw _privateConstructorUsedError;

  /// Role of the member in the family
  FamilyRole get role => throw _privateConstructorUsedError;

  /// Color assigned to this member for visual identification
  String get memberColor => throw _privateConstructorUsedError;

  /// When this user joined the family
  DateTime get joinedAt => throw _privateConstructorUsedError;

  /// User details (populated when needed)
  String? get firstName => throw _privateConstructorUsedError;
  String? get lastName => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get profileImageUrl => throw _privateConstructorUsedError;

  /// Whether this member is currently active
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this FamilyMemberModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FamilyMemberModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FamilyMemberModelCopyWith<FamilyMemberModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FamilyMemberModelCopyWith<$Res> {
  factory $FamilyMemberModelCopyWith(
          FamilyMemberModel value, $Res Function(FamilyMemberModel) then) =
      _$FamilyMemberModelCopyWithImpl<$Res, FamilyMemberModel>;
  @useResult
  $Res call(
      {String userId,
      String familyId,
      FamilyRole role,
      String memberColor,
      DateTime joinedAt,
      String? firstName,
      String? lastName,
      String? email,
      String? profileImageUrl,
      bool isActive});
}

/// @nodoc
class _$FamilyMemberModelCopyWithImpl<$Res, $Val extends FamilyMemberModel>
    implements $FamilyMemberModelCopyWith<$Res> {
  _$FamilyMemberModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FamilyMemberModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? familyId = null,
    Object? role = null,
    Object? memberColor = null,
    Object? joinedAt = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? email = freezed,
    Object? profileImageUrl = freezed,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      familyId: null == familyId
          ? _value.familyId
          : familyId // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as FamilyRole,
      memberColor: null == memberColor
          ? _value.memberColor
          : memberColor // ignore: cast_nullable_to_non_nullable
              as String,
      joinedAt: null == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
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
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FamilyMemberModelImplCopyWith<$Res>
    implements $FamilyMemberModelCopyWith<$Res> {
  factory _$$FamilyMemberModelImplCopyWith(_$FamilyMemberModelImpl value,
          $Res Function(_$FamilyMemberModelImpl) then) =
      __$$FamilyMemberModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String familyId,
      FamilyRole role,
      String memberColor,
      DateTime joinedAt,
      String? firstName,
      String? lastName,
      String? email,
      String? profileImageUrl,
      bool isActive});
}

/// @nodoc
class __$$FamilyMemberModelImplCopyWithImpl<$Res>
    extends _$FamilyMemberModelCopyWithImpl<$Res, _$FamilyMemberModelImpl>
    implements _$$FamilyMemberModelImplCopyWith<$Res> {
  __$$FamilyMemberModelImplCopyWithImpl(_$FamilyMemberModelImpl _value,
      $Res Function(_$FamilyMemberModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of FamilyMemberModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? familyId = null,
    Object? role = null,
    Object? memberColor = null,
    Object? joinedAt = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? email = freezed,
    Object? profileImageUrl = freezed,
    Object? isActive = null,
  }) {
    return _then(_$FamilyMemberModelImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      familyId: null == familyId
          ? _value.familyId
          : familyId // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as FamilyRole,
      memberColor: null == memberColor
          ? _value.memberColor
          : memberColor // ignore: cast_nullable_to_non_nullable
              as String,
      joinedAt: null == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
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
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FamilyMemberModelImpl implements _FamilyMemberModel {
  const _$FamilyMemberModelImpl(
      {required this.userId,
      required this.familyId,
      this.role = FamilyRole.member,
      this.memberColor = '#0066cc',
      required this.joinedAt,
      this.firstName,
      this.lastName,
      this.email,
      this.profileImageUrl,
      this.isActive = true});

  factory _$FamilyMemberModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FamilyMemberModelImplFromJson(json);

  /// User ID of the family member
  @override
  final String userId;

  /// Family ID this member belongs to
  @override
  final String familyId;

  /// Role of the member in the family
  @override
  @JsonKey()
  final FamilyRole role;

  /// Color assigned to this member for visual identification
  @override
  @JsonKey()
  final String memberColor;

  /// When this user joined the family
  @override
  final DateTime joinedAt;

  /// User details (populated when needed)
  @override
  final String? firstName;
  @override
  final String? lastName;
  @override
  final String? email;
  @override
  final String? profileImageUrl;

  /// Whether this member is currently active
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'FamilyMemberModel(userId: $userId, familyId: $familyId, role: $role, memberColor: $memberColor, joinedAt: $joinedAt, firstName: $firstName, lastName: $lastName, email: $email, profileImageUrl: $profileImageUrl, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FamilyMemberModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.familyId, familyId) ||
                other.familyId == familyId) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.memberColor, memberColor) ||
                other.memberColor == memberColor) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      familyId,
      role,
      memberColor,
      joinedAt,
      firstName,
      lastName,
      email,
      profileImageUrl,
      isActive);

  /// Create a copy of FamilyMemberModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FamilyMemberModelImplCopyWith<_$FamilyMemberModelImpl> get copyWith =>
      __$$FamilyMemberModelImplCopyWithImpl<_$FamilyMemberModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FamilyMemberModelImplToJson(
      this,
    );
  }
}

abstract class _FamilyMemberModel implements FamilyMemberModel {
  const factory _FamilyMemberModel(
      {required final String userId,
      required final String familyId,
      final FamilyRole role,
      final String memberColor,
      required final DateTime joinedAt,
      final String? firstName,
      final String? lastName,
      final String? email,
      final String? profileImageUrl,
      final bool isActive}) = _$FamilyMemberModelImpl;

  factory _FamilyMemberModel.fromJson(Map<String, dynamic> json) =
      _$FamilyMemberModelImpl.fromJson;

  /// User ID of the family member
  @override
  String get userId;

  /// Family ID this member belongs to
  @override
  String get familyId;

  /// Role of the member in the family
  @override
  FamilyRole get role;

  /// Color assigned to this member for visual identification
  @override
  String get memberColor;

  /// When this user joined the family
  @override
  DateTime get joinedAt;

  /// User details (populated when needed)
  @override
  String? get firstName;
  @override
  String? get lastName;
  @override
  String? get email;
  @override
  String? get profileImageUrl;

  /// Whether this member is currently active
  @override
  bool get isActive;

  /// Create a copy of FamilyMemberModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FamilyMemberModelImplCopyWith<_$FamilyMemberModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
