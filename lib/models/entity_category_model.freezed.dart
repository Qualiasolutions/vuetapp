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

EntityCategory _$EntityCategoryFromJson(Map<String, dynamic> json) {
  return _EntityCategory.fromJson(json);
}

/// @nodoc
mixin _$EntityCategory {
  String get id => throw _privateConstructorUsedError; // UUID from Supabase
  String get name =>
      throw _privateConstructorUsedError; // Internal name, e.g., "pets", "social_interests"
  String get displayName =>
      throw _privateConstructorUsedError; // User-facing name, e.g., "My Pets"
  String? get iconName =>
      throw _privateConstructorUsedError; // String identifier for Flutter Icon
  String? get colorHex =>
      throw _privateConstructorUsedError; // Hex color string, e.g., "#FF5733"
  int get sortOrder => throw _privateConstructorUsedError;
  bool get isDisplayedOnGrid => throw _privateConstructorUsedError;
  int? get appCategoryIntId =>
      throw _privateConstructorUsedError; // Legacy integer ID
  String? get parentId =>
      throw _privateConstructorUsedError; // For hierarchical categories
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this EntityCategory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EntityCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EntityCategoryCopyWith<EntityCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EntityCategoryCopyWith<$Res> {
  factory $EntityCategoryCopyWith(
          EntityCategory value, $Res Function(EntityCategory) then) =
      _$EntityCategoryCopyWithImpl<$Res, EntityCategory>;
  @useResult
  $Res call(
      {String id,
      String name,
      String displayName,
      String? iconName,
      String? colorHex,
      int sortOrder,
      bool isDisplayedOnGrid,
      int? appCategoryIntId,
      String? parentId,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$EntityCategoryCopyWithImpl<$Res, $Val extends EntityCategory>
    implements $EntityCategoryCopyWith<$Res> {
  _$EntityCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EntityCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? displayName = null,
    Object? iconName = freezed,
    Object? colorHex = freezed,
    Object? sortOrder = null,
    Object? isDisplayedOnGrid = null,
    Object? appCategoryIntId = freezed,
    Object? parentId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      iconName: freezed == iconName
          ? _value.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String?,
      colorHex: freezed == colorHex
          ? _value.colorHex
          : colorHex // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isDisplayedOnGrid: null == isDisplayedOnGrid
          ? _value.isDisplayedOnGrid
          : isDisplayedOnGrid // ignore: cast_nullable_to_non_nullable
              as bool,
      appCategoryIntId: freezed == appCategoryIntId
          ? _value.appCategoryIntId
          : appCategoryIntId // ignore: cast_nullable_to_non_nullable
              as int?,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EntityCategoryImplCopyWith<$Res>
    implements $EntityCategoryCopyWith<$Res> {
  factory _$$EntityCategoryImplCopyWith(_$EntityCategoryImpl value,
          $Res Function(_$EntityCategoryImpl) then) =
      __$$EntityCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String displayName,
      String? iconName,
      String? colorHex,
      int sortOrder,
      bool isDisplayedOnGrid,
      int? appCategoryIntId,
      String? parentId,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$EntityCategoryImplCopyWithImpl<$Res>
    extends _$EntityCategoryCopyWithImpl<$Res, _$EntityCategoryImpl>
    implements _$$EntityCategoryImplCopyWith<$Res> {
  __$$EntityCategoryImplCopyWithImpl(
      _$EntityCategoryImpl _value, $Res Function(_$EntityCategoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of EntityCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? displayName = null,
    Object? iconName = freezed,
    Object? colorHex = freezed,
    Object? sortOrder = null,
    Object? isDisplayedOnGrid = null,
    Object? appCategoryIntId = freezed,
    Object? parentId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$EntityCategoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      iconName: freezed == iconName
          ? _value.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String?,
      colorHex: freezed == colorHex
          ? _value.colorHex
          : colorHex // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isDisplayedOnGrid: null == isDisplayedOnGrid
          ? _value.isDisplayedOnGrid
          : isDisplayedOnGrid // ignore: cast_nullable_to_non_nullable
              as bool,
      appCategoryIntId: freezed == appCategoryIntId
          ? _value.appCategoryIntId
          : appCategoryIntId // ignore: cast_nullable_to_non_nullable
              as int?,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EntityCategoryImpl implements _EntityCategory {
  const _$EntityCategoryImpl(
      {required this.id,
      required this.name,
      required this.displayName,
      this.iconName,
      this.colorHex,
      this.sortOrder = 0,
      this.isDisplayedOnGrid = true,
      this.appCategoryIntId,
      this.parentId,
      this.createdAt,
      this.updatedAt});

  factory _$EntityCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$EntityCategoryImplFromJson(json);

  @override
  final String id;
// UUID from Supabase
  @override
  final String name;
// Internal name, e.g., "pets", "social_interests"
  @override
  final String displayName;
// User-facing name, e.g., "My Pets"
  @override
  final String? iconName;
// String identifier for Flutter Icon
  @override
  final String? colorHex;
// Hex color string, e.g., "#FF5733"
  @override
  @JsonKey()
  final int sortOrder;
  @override
  @JsonKey()
  final bool isDisplayedOnGrid;
  @override
  final int? appCategoryIntId;
// Legacy integer ID
  @override
  final String? parentId;
// For hierarchical categories
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'EntityCategory(id: $id, name: $name, displayName: $displayName, iconName: $iconName, colorHex: $colorHex, sortOrder: $sortOrder, isDisplayedOnGrid: $isDisplayedOnGrid, appCategoryIntId: $appCategoryIntId, parentId: $parentId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EntityCategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.iconName, iconName) ||
                other.iconName == iconName) &&
            (identical(other.colorHex, colorHex) ||
                other.colorHex == colorHex) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.isDisplayedOnGrid, isDisplayedOnGrid) ||
                other.isDisplayedOnGrid == isDisplayedOnGrid) &&
            (identical(other.appCategoryIntId, appCategoryIntId) ||
                other.appCategoryIntId == appCategoryIntId) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
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
      name,
      displayName,
      iconName,
      colorHex,
      sortOrder,
      isDisplayedOnGrid,
      appCategoryIntId,
      parentId,
      createdAt,
      updatedAt);

  /// Create a copy of EntityCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EntityCategoryImplCopyWith<_$EntityCategoryImpl> get copyWith =>
      __$$EntityCategoryImplCopyWithImpl<_$EntityCategoryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EntityCategoryImplToJson(
      this,
    );
  }
}

abstract class _EntityCategory implements EntityCategory {
  const factory _EntityCategory(
      {required final String id,
      required final String name,
      required final String displayName,
      final String? iconName,
      final String? colorHex,
      final int sortOrder,
      final bool isDisplayedOnGrid,
      final int? appCategoryIntId,
      final String? parentId,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$EntityCategoryImpl;

  factory _EntityCategory.fromJson(Map<String, dynamic> json) =
      _$EntityCategoryImpl.fromJson;

  @override
  String get id; // UUID from Supabase
  @override
  String get name; // Internal name, e.g., "pets", "social_interests"
  @override
  String get displayName; // User-facing name, e.g., "My Pets"
  @override
  String? get iconName; // String identifier for Flutter Icon
  @override
  String? get colorHex; // Hex color string, e.g., "#FF5733"
  @override
  int get sortOrder;
  @override
  bool get isDisplayedOnGrid;
  @override
  int? get appCategoryIntId; // Legacy integer ID
  @override
  String? get parentId; // For hierarchical categories
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of EntityCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EntityCategoryImplCopyWith<_$EntityCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
