// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reference_group_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReferenceGroupModel _$ReferenceGroupModelFromJson(Map<String, dynamic> json) {
  return _ReferenceGroupModel.fromJson(json);
}

/// @nodoc
mixin _$ReferenceGroupModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ReferenceGroupModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReferenceGroupModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReferenceGroupModelCopyWith<ReferenceGroupModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReferenceGroupModelCopyWith<$Res> {
  factory $ReferenceGroupModelCopyWith(
          ReferenceGroupModel value, $Res Function(ReferenceGroupModel) then) =
      _$ReferenceGroupModelCopyWithImpl<$Res, ReferenceGroupModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      String? createdBy,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$ReferenceGroupModelCopyWithImpl<$Res, $Val extends ReferenceGroupModel>
    implements $ReferenceGroupModelCopyWith<$Res> {
  _$ReferenceGroupModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReferenceGroupModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? createdBy = freezed,
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
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
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
abstract class _$$ReferenceGroupModelImplCopyWith<$Res>
    implements $ReferenceGroupModelCopyWith<$Res> {
  factory _$$ReferenceGroupModelImplCopyWith(_$ReferenceGroupModelImpl value,
          $Res Function(_$ReferenceGroupModelImpl) then) =
      __$$ReferenceGroupModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      String? createdBy,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$ReferenceGroupModelImplCopyWithImpl<$Res>
    extends _$ReferenceGroupModelCopyWithImpl<$Res, _$ReferenceGroupModelImpl>
    implements _$$ReferenceGroupModelImplCopyWith<$Res> {
  __$$ReferenceGroupModelImplCopyWithImpl(_$ReferenceGroupModelImpl _value,
      $Res Function(_$ReferenceGroupModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReferenceGroupModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? createdBy = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ReferenceGroupModelImpl(
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
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
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
class _$ReferenceGroupModelImpl implements _ReferenceGroupModel {
  const _$ReferenceGroupModelImpl(
      {required this.id,
      required this.name,
      this.description,
      this.createdBy,
      this.createdAt,
      this.updatedAt});

  factory _$ReferenceGroupModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReferenceGroupModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? createdBy;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ReferenceGroupModel(id: $id, name: $name, description: $description, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReferenceGroupModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, description, createdBy, createdAt, updatedAt);

  /// Create a copy of ReferenceGroupModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReferenceGroupModelImplCopyWith<_$ReferenceGroupModelImpl> get copyWith =>
      __$$ReferenceGroupModelImplCopyWithImpl<_$ReferenceGroupModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReferenceGroupModelImplToJson(
      this,
    );
  }
}

abstract class _ReferenceGroupModel implements ReferenceGroupModel {
  const factory _ReferenceGroupModel(
      {required final String id,
      required final String name,
      final String? description,
      final String? createdBy,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$ReferenceGroupModelImpl;

  factory _ReferenceGroupModel.fromJson(Map<String, dynamic> json) =
      _$ReferenceGroupModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  String? get createdBy;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of ReferenceGroupModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReferenceGroupModelImplCopyWith<_$ReferenceGroupModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
