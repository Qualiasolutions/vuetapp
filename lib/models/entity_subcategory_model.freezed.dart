// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'entity_subcategory_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EntitySubcategoryModel _$EntitySubcategoryModelFromJson(
    Map<String, dynamic> json) {
  return _EntitySubcategoryModel.fromJson(json);
}

/// @nodoc
mixin _$EntitySubcategoryModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_id')
  String get categoryId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'display_name')
  String get displayName => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  @JsonKey(name: 'tag_name')
  String? get tagName => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  @JsonKey(name: 'entity_types')
  List<String> get entityTypeIds => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this EntitySubcategoryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EntitySubcategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EntitySubcategoryModelCopyWith<EntitySubcategoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EntitySubcategoryModelCopyWith<$Res> {
  factory $EntitySubcategoryModelCopyWith(EntitySubcategoryModel value,
          $Res Function(EntitySubcategoryModel) then) =
      _$EntitySubcategoryModelCopyWithImpl<$Res, EntitySubcategoryModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'category_id') String categoryId,
      String name,
      @JsonKey(name: 'display_name') String displayName,
      String? icon,
      @JsonKey(name: 'tag_name') String? tagName,
      String? color,
      @JsonKey(name: 'entity_types') List<String> entityTypeIds,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$EntitySubcategoryModelCopyWithImpl<$Res,
        $Val extends EntitySubcategoryModel>
    implements $EntitySubcategoryModelCopyWith<$Res> {
  _$EntitySubcategoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EntitySubcategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? categoryId = null,
    Object? name = null,
    Object? displayName = null,
    Object? icon = freezed,
    Object? tagName = freezed,
    Object? color = freezed,
    Object? entityTypeIds = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      tagName: freezed == tagName
          ? _value.tagName
          : tagName // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      entityTypeIds: null == entityTypeIds
          ? _value.entityTypeIds
          : entityTypeIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
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
abstract class _$$EntitySubcategoryModelImplCopyWith<$Res>
    implements $EntitySubcategoryModelCopyWith<$Res> {
  factory _$$EntitySubcategoryModelImplCopyWith(
          _$EntitySubcategoryModelImpl value,
          $Res Function(_$EntitySubcategoryModelImpl) then) =
      __$$EntitySubcategoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'category_id') String categoryId,
      String name,
      @JsonKey(name: 'display_name') String displayName,
      String? icon,
      @JsonKey(name: 'tag_name') String? tagName,
      String? color,
      @JsonKey(name: 'entity_types') List<String> entityTypeIds,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$EntitySubcategoryModelImplCopyWithImpl<$Res>
    extends _$EntitySubcategoryModelCopyWithImpl<$Res,
        _$EntitySubcategoryModelImpl>
    implements _$$EntitySubcategoryModelImplCopyWith<$Res> {
  __$$EntitySubcategoryModelImplCopyWithImpl(
      _$EntitySubcategoryModelImpl _value,
      $Res Function(_$EntitySubcategoryModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of EntitySubcategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? categoryId = null,
    Object? name = null,
    Object? displayName = null,
    Object? icon = freezed,
    Object? tagName = freezed,
    Object? color = freezed,
    Object? entityTypeIds = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$EntitySubcategoryModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      tagName: freezed == tagName
          ? _value.tagName
          : tagName // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      entityTypeIds: null == entityTypeIds
          ? _value._entityTypeIds
          : entityTypeIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
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
class _$EntitySubcategoryModelImpl implements _EntitySubcategoryModel {
  const _$EntitySubcategoryModelImpl(
      {required this.id,
      @JsonKey(name: 'category_id') required this.categoryId,
      required this.name,
      @JsonKey(name: 'display_name') required this.displayName,
      this.icon,
      @JsonKey(name: 'tag_name') this.tagName,
      this.color,
      @JsonKey(name: 'entity_types') required final List<String> entityTypeIds,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt})
      : _entityTypeIds = entityTypeIds;

  factory _$EntitySubcategoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EntitySubcategoryModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'category_id')
  final String categoryId;
  @override
  final String name;
  @override
  @JsonKey(name: 'display_name')
  final String displayName;
  @override
  final String? icon;
  @override
  @JsonKey(name: 'tag_name')
  final String? tagName;
  @override
  final String? color;
  final List<String> _entityTypeIds;
  @override
  @JsonKey(name: 'entity_types')
  List<String> get entityTypeIds {
    if (_entityTypeIds is EqualUnmodifiableListView) return _entityTypeIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_entityTypeIds);
  }

  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'EntitySubcategoryModel(id: $id, categoryId: $categoryId, name: $name, displayName: $displayName, icon: $icon, tagName: $tagName, color: $color, entityTypeIds: $entityTypeIds, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EntitySubcategoryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.tagName, tagName) || other.tagName == tagName) &&
            (identical(other.color, color) || other.color == color) &&
            const DeepCollectionEquality()
                .equals(other._entityTypeIds, _entityTypeIds) &&
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
      categoryId,
      name,
      displayName,
      icon,
      tagName,
      color,
      const DeepCollectionEquality().hash(_entityTypeIds),
      createdAt,
      updatedAt);

  /// Create a copy of EntitySubcategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EntitySubcategoryModelImplCopyWith<_$EntitySubcategoryModelImpl>
      get copyWith => __$$EntitySubcategoryModelImplCopyWithImpl<
          _$EntitySubcategoryModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EntitySubcategoryModelImplToJson(
      this,
    );
  }
}

abstract class _EntitySubcategoryModel implements EntitySubcategoryModel {
  const factory _EntitySubcategoryModel(
      {required final String id,
      @JsonKey(name: 'category_id') required final String categoryId,
      required final String name,
      @JsonKey(name: 'display_name') required final String displayName,
      final String? icon,
      @JsonKey(name: 'tag_name') final String? tagName,
      final String? color,
      @JsonKey(name: 'entity_types') required final List<String> entityTypeIds,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at')
      final DateTime? updatedAt}) = _$EntitySubcategoryModelImpl;

  factory _EntitySubcategoryModel.fromJson(Map<String, dynamic> json) =
      _$EntitySubcategoryModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'category_id')
  String get categoryId;
  @override
  String get name;
  @override
  @JsonKey(name: 'display_name')
  String get displayName;
  @override
  String? get icon;
  @override
  @JsonKey(name: 'tag_name')
  String? get tagName;
  @override
  String? get color;
  @override
  @JsonKey(name: 'entity_types')
  List<String> get entityTypeIds;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of EntitySubcategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EntitySubcategoryModelImplCopyWith<_$EntitySubcategoryModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
