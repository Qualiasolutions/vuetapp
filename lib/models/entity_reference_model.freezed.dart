// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'entity_reference_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EntityReferenceModel _$EntityReferenceModelFromJson(Map<String, dynamic> json) {
  return _EntityReferenceModel.fromJson(json);
}

/// @nodoc
mixin _$EntityReferenceModel {
  String get id => throw _privateConstructorUsedError;
  String get entityId => throw _privateConstructorUsedError;
  String get referenceId => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this EntityReferenceModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EntityReferenceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EntityReferenceModelCopyWith<EntityReferenceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EntityReferenceModelCopyWith<$Res> {
  factory $EntityReferenceModelCopyWith(EntityReferenceModel value,
          $Res Function(EntityReferenceModel) then) =
      _$EntityReferenceModelCopyWithImpl<$Res, EntityReferenceModel>;
  @useResult
  $Res call(
      {String id, String entityId, String referenceId, DateTime? createdAt});
}

/// @nodoc
class _$EntityReferenceModelCopyWithImpl<$Res,
        $Val extends EntityReferenceModel>
    implements $EntityReferenceModelCopyWith<$Res> {
  _$EntityReferenceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EntityReferenceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? entityId = null,
    Object? referenceId = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      entityId: null == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String,
      referenceId: null == referenceId
          ? _value.referenceId
          : referenceId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EntityReferenceModelImplCopyWith<$Res>
    implements $EntityReferenceModelCopyWith<$Res> {
  factory _$$EntityReferenceModelImplCopyWith(_$EntityReferenceModelImpl value,
          $Res Function(_$EntityReferenceModelImpl) then) =
      __$$EntityReferenceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id, String entityId, String referenceId, DateTime? createdAt});
}

/// @nodoc
class __$$EntityReferenceModelImplCopyWithImpl<$Res>
    extends _$EntityReferenceModelCopyWithImpl<$Res, _$EntityReferenceModelImpl>
    implements _$$EntityReferenceModelImplCopyWith<$Res> {
  __$$EntityReferenceModelImplCopyWithImpl(_$EntityReferenceModelImpl _value,
      $Res Function(_$EntityReferenceModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of EntityReferenceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? entityId = null,
    Object? referenceId = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$EntityReferenceModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      entityId: null == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String,
      referenceId: null == referenceId
          ? _value.referenceId
          : referenceId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EntityReferenceModelImpl implements _EntityReferenceModel {
  const _$EntityReferenceModelImpl(
      {required this.id,
      required this.entityId,
      required this.referenceId,
      this.createdAt});

  factory _$EntityReferenceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EntityReferenceModelImplFromJson(json);

  @override
  final String id;
  @override
  final String entityId;
  @override
  final String referenceId;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'EntityReferenceModel(id: $id, entityId: $entityId, referenceId: $referenceId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EntityReferenceModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.referenceId, referenceId) ||
                other.referenceId == referenceId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, entityId, referenceId, createdAt);

  /// Create a copy of EntityReferenceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EntityReferenceModelImplCopyWith<_$EntityReferenceModelImpl>
      get copyWith =>
          __$$EntityReferenceModelImplCopyWithImpl<_$EntityReferenceModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EntityReferenceModelImplToJson(
      this,
    );
  }
}

abstract class _EntityReferenceModel implements EntityReferenceModel {
  const factory _EntityReferenceModel(
      {required final String id,
      required final String entityId,
      required final String referenceId,
      final DateTime? createdAt}) = _$EntityReferenceModelImpl;

  factory _EntityReferenceModel.fromJson(Map<String, dynamic> json) =
      _$EntityReferenceModelImpl.fromJson;

  @override
  String get id;
  @override
  String get entityId;
  @override
  String get referenceId;
  @override
  DateTime? get createdAt;

  /// Create a copy of EntityReferenceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EntityReferenceModelImplCopyWith<_$EntityReferenceModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
