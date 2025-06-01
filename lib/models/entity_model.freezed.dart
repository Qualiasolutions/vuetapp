// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'entity_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BaseEntityModel _$BaseEntityModelFromJson(Map<String, dynamic> json) {
  return _BaseEntityModel.fromJson(json);
}

/// @nodoc
mixin _$BaseEntityModel {
  String? get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId =>
      throw _privateConstructorUsedError; // Corrected to user_id
  @JsonKey(name: 'app_category_id')
  int? get appCategoryId =>
      throw _privateConstructorUsedError; // Changed from categoryId, type to int?
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get parentId => throw _privateConstructorUsedError;
  @JsonKey(name: 'entity_type_id')
  EntitySubtype get subtype => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  bool? get isHidden => throw _privateConstructorUsedError;
  @JsonKey(name: 'attributes')
  Map<String, dynamic>? get customFields => throw _privateConstructorUsedError;
  List<String>? get attachments => throw _privateConstructorUsedError;
  DateTime? get dueDate => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;

  /// Serializes this BaseEntityModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BaseEntityModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BaseEntityModelCopyWith<BaseEntityModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BaseEntityModelCopyWith<$Res> {
  factory $BaseEntityModelCopyWith(
          BaseEntityModel value, $Res Function(BaseEntityModel) then) =
      _$BaseEntityModelCopyWithImpl<$Res, BaseEntityModel>;
  @useResult
  $Res call(
      {String? id,
      String name,
      String? description,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'app_category_id') int? appCategoryId,
      String? imageUrl,
      String? parentId,
      @JsonKey(name: 'entity_type_id') EntitySubtype subtype,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      bool? isHidden,
      @JsonKey(name: 'attributes') Map<String, dynamic>? customFields,
      List<String>? attachments,
      DateTime? dueDate,
      String? status});
}

/// @nodoc
class _$BaseEntityModelCopyWithImpl<$Res, $Val extends BaseEntityModel>
    implements $BaseEntityModelCopyWith<$Res> {
  _$BaseEntityModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BaseEntityModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? description = freezed,
    Object? userId = null,
    Object? appCategoryId = freezed,
    Object? imageUrl = freezed,
    Object? parentId = freezed,
    Object? subtype = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? isHidden = freezed,
    Object? customFields = freezed,
    Object? attachments = freezed,
    Object? dueDate = freezed,
    Object? status = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      appCategoryId: freezed == appCategoryId
          ? _value.appCategoryId
          : appCategoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      subtype: null == subtype
          ? _value.subtype
          : subtype // ignore: cast_nullable_to_non_nullable
              as EntitySubtype,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isHidden: freezed == isHidden
          ? _value.isHidden
          : isHidden // ignore: cast_nullable_to_non_nullable
              as bool?,
      customFields: freezed == customFields
          ? _value.customFields
          : customFields // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      attachments: freezed == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BaseEntityModelImplCopyWith<$Res>
    implements $BaseEntityModelCopyWith<$Res> {
  factory _$$BaseEntityModelImplCopyWith(_$BaseEntityModelImpl value,
          $Res Function(_$BaseEntityModelImpl) then) =
      __$$BaseEntityModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String name,
      String? description,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'app_category_id') int? appCategoryId,
      String? imageUrl,
      String? parentId,
      @JsonKey(name: 'entity_type_id') EntitySubtype subtype,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      bool? isHidden,
      @JsonKey(name: 'attributes') Map<String, dynamic>? customFields,
      List<String>? attachments,
      DateTime? dueDate,
      String? status});
}

/// @nodoc
class __$$BaseEntityModelImplCopyWithImpl<$Res>
    extends _$BaseEntityModelCopyWithImpl<$Res, _$BaseEntityModelImpl>
    implements _$$BaseEntityModelImplCopyWith<$Res> {
  __$$BaseEntityModelImplCopyWithImpl(
      _$BaseEntityModelImpl _value, $Res Function(_$BaseEntityModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of BaseEntityModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? description = freezed,
    Object? userId = null,
    Object? appCategoryId = freezed,
    Object? imageUrl = freezed,
    Object? parentId = freezed,
    Object? subtype = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? isHidden = freezed,
    Object? customFields = freezed,
    Object? attachments = freezed,
    Object? dueDate = freezed,
    Object? status = freezed,
  }) {
    return _then(_$BaseEntityModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      appCategoryId: freezed == appCategoryId
          ? _value.appCategoryId
          : appCategoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      subtype: null == subtype
          ? _value.subtype
          : subtype // ignore: cast_nullable_to_non_nullable
              as EntitySubtype,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isHidden: freezed == isHidden
          ? _value.isHidden
          : isHidden // ignore: cast_nullable_to_non_nullable
              as bool?,
      customFields: freezed == customFields
          ? _value._customFields
          : customFields // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      attachments: freezed == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BaseEntityModelImpl implements _BaseEntityModel {
  const _$BaseEntityModelImpl(
      {this.id,
      required this.name,
      this.description,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'app_category_id') this.appCategoryId,
      this.imageUrl,
      this.parentId,
      @JsonKey(name: 'entity_type_id') required this.subtype,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      this.isHidden,
      @JsonKey(name: 'attributes') final Map<String, dynamic>? customFields,
      final List<String>? attachments,
      this.dueDate,
      this.status})
      : _customFields = customFields,
        _attachments = attachments;

  factory _$BaseEntityModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BaseEntityModelImplFromJson(json);

  @override
  final String? id;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
// Corrected to user_id
  @override
  @JsonKey(name: 'app_category_id')
  final int? appCategoryId;
// Changed from categoryId, type to int?
  @override
  final String? imageUrl;
  @override
  final String? parentId;
  @override
  @JsonKey(name: 'entity_type_id')
  final EntitySubtype subtype;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @override
  final bool? isHidden;
  final Map<String, dynamic>? _customFields;
  @override
  @JsonKey(name: 'attributes')
  Map<String, dynamic>? get customFields {
    final value = _customFields;
    if (value == null) return null;
    if (_customFields is EqualUnmodifiableMapView) return _customFields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<String>? _attachments;
  @override
  List<String>? get attachments {
    final value = _attachments;
    if (value == null) return null;
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime? dueDate;
  @override
  final String? status;

  @override
  String toString() {
    return 'BaseEntityModel(id: $id, name: $name, description: $description, userId: $userId, appCategoryId: $appCategoryId, imageUrl: $imageUrl, parentId: $parentId, subtype: $subtype, createdAt: $createdAt, updatedAt: $updatedAt, isHidden: $isHidden, customFields: $customFields, attachments: $attachments, dueDate: $dueDate, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BaseEntityModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.appCategoryId, appCategoryId) ||
                other.appCategoryId == appCategoryId) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.subtype, subtype) || other.subtype == subtype) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isHidden, isHidden) ||
                other.isHidden == isHidden) &&
            const DeepCollectionEquality()
                .equals(other._customFields, _customFields) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      userId,
      appCategoryId,
      imageUrl,
      parentId,
      subtype,
      createdAt,
      updatedAt,
      isHidden,
      const DeepCollectionEquality().hash(_customFields),
      const DeepCollectionEquality().hash(_attachments),
      dueDate,
      status);

  /// Create a copy of BaseEntityModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BaseEntityModelImplCopyWith<_$BaseEntityModelImpl> get copyWith =>
      __$$BaseEntityModelImplCopyWithImpl<_$BaseEntityModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BaseEntityModelImplToJson(
      this,
    );
  }
}

abstract class _BaseEntityModel implements BaseEntityModel {
  const factory _BaseEntityModel(
      {final String? id,
      required final String name,
      final String? description,
      @JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'app_category_id') final int? appCategoryId,
      final String? imageUrl,
      final String? parentId,
      @JsonKey(name: 'entity_type_id') required final EntitySubtype subtype,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at') final DateTime? updatedAt,
      final bool? isHidden,
      @JsonKey(name: 'attributes') final Map<String, dynamic>? customFields,
      final List<String>? attachments,
      final DateTime? dueDate,
      final String? status}) = _$BaseEntityModelImpl;

  factory _BaseEntityModel.fromJson(Map<String, dynamic> json) =
      _$BaseEntityModelImpl.fromJson;

  @override
  String? get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  @JsonKey(name: 'user_id')
  String get userId; // Corrected to user_id
  @override
  @JsonKey(name: 'app_category_id')
  int? get appCategoryId; // Changed from categoryId, type to int?
  @override
  String? get imageUrl;
  @override
  String? get parentId;
  @override
  @JsonKey(name: 'entity_type_id')
  EntitySubtype get subtype;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  bool? get isHidden;
  @override
  @JsonKey(name: 'attributes')
  Map<String, dynamic>? get customFields;
  @override
  List<String>? get attachments;
  @override
  DateTime? get dueDate;
  @override
  String? get status;

  /// Create a copy of BaseEntityModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BaseEntityModelImplCopyWith<_$BaseEntityModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
