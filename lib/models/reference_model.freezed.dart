// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reference_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReferenceModel _$ReferenceModelFromJson(Map<String, dynamic> json) {
  return _ReferenceModel.fromJson(json);
}

/// @nodoc
mixin _$ReferenceModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get groupId => throw _privateConstructorUsedError;
  String? get value => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ReferenceModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReferenceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReferenceModelCopyWith<ReferenceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReferenceModelCopyWith<$Res> {
  factory $ReferenceModelCopyWith(
          ReferenceModel value, $Res Function(ReferenceModel) then) =
      _$ReferenceModelCopyWithImpl<$Res, ReferenceModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? groupId,
      String? value,
      String? type,
      String? icon,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$ReferenceModelCopyWithImpl<$Res, $Val extends ReferenceModel>
    implements $ReferenceModelCopyWith<$Res> {
  _$ReferenceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReferenceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? groupId = freezed,
    Object? value = freezed,
    Object? type = freezed,
    Object? icon = freezed,
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
      groupId: freezed == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
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
abstract class _$$ReferenceModelImplCopyWith<$Res>
    implements $ReferenceModelCopyWith<$Res> {
  factory _$$ReferenceModelImplCopyWith(_$ReferenceModelImpl value,
          $Res Function(_$ReferenceModelImpl) then) =
      __$$ReferenceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? groupId,
      String? value,
      String? type,
      String? icon,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$ReferenceModelImplCopyWithImpl<$Res>
    extends _$ReferenceModelCopyWithImpl<$Res, _$ReferenceModelImpl>
    implements _$$ReferenceModelImplCopyWith<$Res> {
  __$$ReferenceModelImplCopyWithImpl(
      _$ReferenceModelImpl _value, $Res Function(_$ReferenceModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReferenceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? groupId = freezed,
    Object? value = freezed,
    Object? type = freezed,
    Object? icon = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ReferenceModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      groupId: freezed == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
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
class _$ReferenceModelImpl implements _ReferenceModel {
  const _$ReferenceModelImpl(
      {required this.id,
      required this.name,
      this.groupId,
      this.value,
      this.type,
      this.icon,
      this.createdAt,
      this.updatedAt});

  factory _$ReferenceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReferenceModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? groupId;
  @override
  final String? value;
  @override
  final String? type;
  @override
  final String? icon;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ReferenceModel(id: $id, name: $name, groupId: $groupId, value: $value, type: $type, icon: $icon, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReferenceModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, groupId, value, type, icon, createdAt, updatedAt);

  /// Create a copy of ReferenceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReferenceModelImplCopyWith<_$ReferenceModelImpl> get copyWith =>
      __$$ReferenceModelImplCopyWithImpl<_$ReferenceModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReferenceModelImplToJson(
      this,
    );
  }
}

abstract class _ReferenceModel implements ReferenceModel {
  const factory _ReferenceModel(
      {required final String id,
      required final String name,
      final String? groupId,
      final String? value,
      final String? type,
      final String? icon,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$ReferenceModelImpl;

  factory _ReferenceModel.fromJson(Map<String, dynamic> json) =
      _$ReferenceModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get groupId;
  @override
  String? get value;
  @override
  String? get type;
  @override
  String? get icon;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of ReferenceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReferenceModelImplCopyWith<_$ReferenceModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
