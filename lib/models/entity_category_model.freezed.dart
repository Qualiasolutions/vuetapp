// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'entity_category_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EntityCategoryModel _$EntityCategoryModelFromJson(Map<String, dynamic> json) {
  return _EntityCategoryModel.fromJson(json);
}

/// @nodoc
mixin _$EntityCategoryModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner_id')
  String? get ownerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  int? get priority => throw _privateConstructorUsedError;
  DateTime? get lastAccessedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_professional')
  bool get isProfessional => throw _privateConstructorUsedError;
  String? get parentId =>
      throw _privateConstructorUsedError; // New field for hierarchy
// Add the integer appCategoryId, assuming it can be fetched from the database
// If the database column name is different, adjust the @JsonKey accordingly.
// For example, if the column is 'int_id', use @JsonKey(name: 'int_id') int? appCategoryId,
  int? get appCategoryId => throw _privateConstructorUsedError;

  /// Serializes this EntityCategoryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EntityCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EntityCategoryModelCopyWith<EntityCategoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EntityCategoryModelCopyWith<$Res> {
  factory $EntityCategoryModelCopyWith(
          EntityCategoryModel value, $Res Function(EntityCategoryModel) then) =
      _$EntityCategoryModelCopyWithImpl<$Res, EntityCategoryModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      String? icon,
      @JsonKey(name: 'owner_id') String? ownerId,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      String? color,
      int? priority,
      DateTime? lastAccessedAt,
      @JsonKey(name: 'is_professional') bool isProfessional,
      String? parentId,
      int? appCategoryId});
}

/// @nodoc
class _$EntityCategoryModelCopyWithImpl<$Res, $Val extends EntityCategoryModel>
    implements $EntityCategoryModelCopyWith<$Res> {
  _$EntityCategoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EntityCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? icon = freezed,
    Object? ownerId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? color = freezed,
    Object? priority = freezed,
    Object? lastAccessedAt = freezed,
    Object? isProfessional = null,
    Object? parentId = freezed,
    Object? appCategoryId = freezed,
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
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerId: freezed == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      priority: freezed == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int?,
      lastAccessedAt: freezed == lastAccessedAt
          ? _value.lastAccessedAt
          : lastAccessedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isProfessional: null == isProfessional
          ? _value.isProfessional
          : isProfessional // ignore: cast_nullable_to_non_nullable
              as bool,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      appCategoryId: freezed == appCategoryId
          ? _value.appCategoryId
          : appCategoryId // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EntityCategoryModelImplCopyWith<$Res>
    implements $EntityCategoryModelCopyWith<$Res> {
  factory _$$EntityCategoryModelImplCopyWith(_$EntityCategoryModelImpl value,
          $Res Function(_$EntityCategoryModelImpl) then) =
      __$$EntityCategoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      String? icon,
      @JsonKey(name: 'owner_id') String? ownerId,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      String? color,
      int? priority,
      DateTime? lastAccessedAt,
      @JsonKey(name: 'is_professional') bool isProfessional,
      String? parentId,
      int? appCategoryId});
}

/// @nodoc
class __$$EntityCategoryModelImplCopyWithImpl<$Res>
    extends _$EntityCategoryModelCopyWithImpl<$Res, _$EntityCategoryModelImpl>
    implements _$$EntityCategoryModelImplCopyWith<$Res> {
  __$$EntityCategoryModelImplCopyWithImpl(_$EntityCategoryModelImpl _value,
      $Res Function(_$EntityCategoryModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of EntityCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? icon = freezed,
    Object? ownerId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? color = freezed,
    Object? priority = freezed,
    Object? lastAccessedAt = freezed,
    Object? isProfessional = null,
    Object? parentId = freezed,
    Object? appCategoryId = freezed,
  }) {
    return _then(_$EntityCategoryModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerId: freezed == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      priority: freezed == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int?,
      lastAccessedAt: freezed == lastAccessedAt
          ? _value.lastAccessedAt
          : lastAccessedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isProfessional: null == isProfessional
          ? _value.isProfessional
          : isProfessional // ignore: cast_nullable_to_non_nullable
              as bool,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      appCategoryId: freezed == appCategoryId
          ? _value.appCategoryId
          : appCategoryId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EntityCategoryModelImpl implements _EntityCategoryModel {
  const _$EntityCategoryModelImpl(
      {required this.id,
      required this.name,
      this.description,
      this.icon,
      @JsonKey(name: 'owner_id') this.ownerId,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      this.color,
      this.priority,
      this.lastAccessedAt,
      @JsonKey(name: 'is_professional') this.isProfessional = false,
      this.parentId,
      this.appCategoryId});

  factory _$EntityCategoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EntityCategoryModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? icon;
  @override
  @JsonKey(name: 'owner_id')
  final String? ownerId;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @override
  final String? color;
  @override
  final int? priority;
  @override
  final DateTime? lastAccessedAt;
  @override
  @JsonKey(name: 'is_professional')
  final bool isProfessional;
  @override
  final String? parentId;
// New field for hierarchy
// Add the integer appCategoryId, assuming it can be fetched from the database
// If the database column name is different, adjust the @JsonKey accordingly.
// For example, if the column is 'int_id', use @JsonKey(name: 'int_id') int? appCategoryId,
  @override
  final int? appCategoryId;

  @override
  String toString() {
    return 'EntityCategoryModel(id: $id, name: $name, description: $description, icon: $icon, ownerId: $ownerId, createdAt: $createdAt, updatedAt: $updatedAt, color: $color, priority: $priority, lastAccessedAt: $lastAccessedAt, isProfessional: $isProfessional, parentId: $parentId, appCategoryId: $appCategoryId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EntityCategoryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.lastAccessedAt, lastAccessedAt) ||
                other.lastAccessedAt == lastAccessedAt) &&
            (identical(other.isProfessional, isProfessional) ||
                other.isProfessional == isProfessional) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.appCategoryId, appCategoryId) ||
                other.appCategoryId == appCategoryId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      icon,
      ownerId,
      createdAt,
      updatedAt,
      color,
      priority,
      lastAccessedAt,
      isProfessional,
      parentId,
      appCategoryId);

  /// Create a copy of EntityCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EntityCategoryModelImplCopyWith<_$EntityCategoryModelImpl> get copyWith =>
      __$$EntityCategoryModelImplCopyWithImpl<_$EntityCategoryModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EntityCategoryModelImplToJson(
      this,
    );
  }
}

abstract class _EntityCategoryModel implements EntityCategoryModel {
  const factory _EntityCategoryModel(
      {required final String id,
      required final String name,
      final String? description,
      final String? icon,
      @JsonKey(name: 'owner_id') final String? ownerId,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at') final DateTime? updatedAt,
      final String? color,
      final int? priority,
      final DateTime? lastAccessedAt,
      @JsonKey(name: 'is_professional') final bool isProfessional,
      final String? parentId,
      final int? appCategoryId}) = _$EntityCategoryModelImpl;

  factory _EntityCategoryModel.fromJson(Map<String, dynamic> json) =
      _$EntityCategoryModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  String? get icon;
  @override
  @JsonKey(name: 'owner_id')
  String? get ownerId;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  String? get color;
  @override
  int? get priority;
  @override
  DateTime? get lastAccessedAt;
  @override
  @JsonKey(name: 'is_professional')
  bool get isProfessional;
  @override
  String? get parentId; // New field for hierarchy
// Add the integer appCategoryId, assuming it can be fetched from the database
// If the database column name is different, adjust the @JsonKey accordingly.
// For example, if the column is 'int_id', use @JsonKey(name: 'int_id') int? appCategoryId,
  @override
  int? get appCategoryId;

  /// Create a copy of EntityCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EntityCategoryModelImplCopyWith<_$EntityCategoryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
