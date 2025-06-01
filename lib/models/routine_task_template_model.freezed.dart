// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'routine_task_template_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RoutineTaskTemplateModel _$RoutineTaskTemplateModelFromJson(
    Map<String, dynamic> json) {
  return _RoutineTaskTemplateModel.fromJson(json);
}

/// @nodoc
mixin _$RoutineTaskTemplateModel {
  String get id => throw _privateConstructorUsedError;
  String get routineId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  int? get estimatedDurationMinutes => throw _privateConstructorUsedError;
  String? get categoryId => throw _privateConstructorUsedError;
  TaskPriority? get priority => throw _privateConstructorUsedError;
  int get orderInRoutine => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this RoutineTaskTemplateModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RoutineTaskTemplateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoutineTaskTemplateModelCopyWith<RoutineTaskTemplateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoutineTaskTemplateModelCopyWith<$Res> {
  factory $RoutineTaskTemplateModelCopyWith(RoutineTaskTemplateModel value,
          $Res Function(RoutineTaskTemplateModel) then) =
      _$RoutineTaskTemplateModelCopyWithImpl<$Res, RoutineTaskTemplateModel>;
  @useResult
  $Res call(
      {String id,
      String routineId,
      String userId,
      String title,
      String? description,
      int? estimatedDurationMinutes,
      String? categoryId,
      TaskPriority? priority,
      int orderInRoutine,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$RoutineTaskTemplateModelCopyWithImpl<$Res,
        $Val extends RoutineTaskTemplateModel>
    implements $RoutineTaskTemplateModelCopyWith<$Res> {
  _$RoutineTaskTemplateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RoutineTaskTemplateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? routineId = null,
    Object? userId = null,
    Object? title = null,
    Object? description = freezed,
    Object? estimatedDurationMinutes = freezed,
    Object? categoryId = freezed,
    Object? priority = freezed,
    Object? orderInRoutine = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      routineId: null == routineId
          ? _value.routineId
          : routineId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      estimatedDurationMinutes: freezed == estimatedDurationMinutes
          ? _value.estimatedDurationMinutes
          : estimatedDurationMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      priority: freezed == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as TaskPriority?,
      orderInRoutine: null == orderInRoutine
          ? _value.orderInRoutine
          : orderInRoutine // ignore: cast_nullable_to_non_nullable
              as int,
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
abstract class _$$RoutineTaskTemplateModelImplCopyWith<$Res>
    implements $RoutineTaskTemplateModelCopyWith<$Res> {
  factory _$$RoutineTaskTemplateModelImplCopyWith(
          _$RoutineTaskTemplateModelImpl value,
          $Res Function(_$RoutineTaskTemplateModelImpl) then) =
      __$$RoutineTaskTemplateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String routineId,
      String userId,
      String title,
      String? description,
      int? estimatedDurationMinutes,
      String? categoryId,
      TaskPriority? priority,
      int orderInRoutine,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$RoutineTaskTemplateModelImplCopyWithImpl<$Res>
    extends _$RoutineTaskTemplateModelCopyWithImpl<$Res,
        _$RoutineTaskTemplateModelImpl>
    implements _$$RoutineTaskTemplateModelImplCopyWith<$Res> {
  __$$RoutineTaskTemplateModelImplCopyWithImpl(
      _$RoutineTaskTemplateModelImpl _value,
      $Res Function(_$RoutineTaskTemplateModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of RoutineTaskTemplateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? routineId = null,
    Object? userId = null,
    Object? title = null,
    Object? description = freezed,
    Object? estimatedDurationMinutes = freezed,
    Object? categoryId = freezed,
    Object? priority = freezed,
    Object? orderInRoutine = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$RoutineTaskTemplateModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      routineId: null == routineId
          ? _value.routineId
          : routineId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      estimatedDurationMinutes: freezed == estimatedDurationMinutes
          ? _value.estimatedDurationMinutes
          : estimatedDurationMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      priority: freezed == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as TaskPriority?,
      orderInRoutine: null == orderInRoutine
          ? _value.orderInRoutine
          : orderInRoutine // ignore: cast_nullable_to_non_nullable
              as int,
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
class _$RoutineTaskTemplateModelImpl implements _RoutineTaskTemplateModel {
  const _$RoutineTaskTemplateModelImpl(
      {required this.id,
      required this.routineId,
      required this.userId,
      required this.title,
      this.description,
      this.estimatedDurationMinutes,
      this.categoryId,
      this.priority,
      this.orderInRoutine = 0,
      this.createdAt,
      this.updatedAt});

  factory _$RoutineTaskTemplateModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoutineTaskTemplateModelImplFromJson(json);

  @override
  final String id;
  @override
  final String routineId;
  @override
  final String userId;
  @override
  final String title;
  @override
  final String? description;
  @override
  final int? estimatedDurationMinutes;
  @override
  final String? categoryId;
  @override
  final TaskPriority? priority;
  @override
  @JsonKey()
  final int orderInRoutine;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'RoutineTaskTemplateModel(id: $id, routineId: $routineId, userId: $userId, title: $title, description: $description, estimatedDurationMinutes: $estimatedDurationMinutes, categoryId: $categoryId, priority: $priority, orderInRoutine: $orderInRoutine, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoutineTaskTemplateModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.routineId, routineId) ||
                other.routineId == routineId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(
                    other.estimatedDurationMinutes, estimatedDurationMinutes) ||
                other.estimatedDurationMinutes == estimatedDurationMinutes) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.orderInRoutine, orderInRoutine) ||
                other.orderInRoutine == orderInRoutine) &&
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
      routineId,
      userId,
      title,
      description,
      estimatedDurationMinutes,
      categoryId,
      priority,
      orderInRoutine,
      createdAt,
      updatedAt);

  /// Create a copy of RoutineTaskTemplateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoutineTaskTemplateModelImplCopyWith<_$RoutineTaskTemplateModelImpl>
      get copyWith => __$$RoutineTaskTemplateModelImplCopyWithImpl<
          _$RoutineTaskTemplateModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoutineTaskTemplateModelImplToJson(
      this,
    );
  }
}

abstract class _RoutineTaskTemplateModel implements RoutineTaskTemplateModel {
  const factory _RoutineTaskTemplateModel(
      {required final String id,
      required final String routineId,
      required final String userId,
      required final String title,
      final String? description,
      final int? estimatedDurationMinutes,
      final String? categoryId,
      final TaskPriority? priority,
      final int orderInRoutine,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$RoutineTaskTemplateModelImpl;

  factory _RoutineTaskTemplateModel.fromJson(Map<String, dynamic> json) =
      _$RoutineTaskTemplateModelImpl.fromJson;

  @override
  String get id;
  @override
  String get routineId;
  @override
  String get userId;
  @override
  String get title;
  @override
  String? get description;
  @override
  int? get estimatedDurationMinutes;
  @override
  String? get categoryId;
  @override
  TaskPriority? get priority;
  @override
  int get orderInRoutine;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of RoutineTaskTemplateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoutineTaskTemplateModelImplCopyWith<_$RoutineTaskTemplateModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
