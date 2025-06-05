// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'advanced_task_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BaseTask _$BaseTaskFromJson(Map<String, dynamic> json) {
  return _BaseTask.fromJson(json);
}

/// @nodoc
mixin _$BaseTask {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get assignedTo => throw _privateConstructorUsedError;
  String? get categoryId => throw _privateConstructorUsedError;
  String? get entityId => throw _privateConstructorUsedError;
  String? get parentTaskId => throw _privateConstructorUsedError;
  String? get routineId => throw _privateConstructorUsedError;
  String? get routineInstanceId => throw _privateConstructorUsedError;
  bool get isGeneratedFromRoutine => throw _privateConstructorUsedError;
  TaskType? get taskType => throw _privateConstructorUsedError;
  String? get taskSubtype => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  Map<String, dynamic>? get typeSpecificData =>
      throw _privateConstructorUsedError;
  TaskSchedulingType get schedulingType => throw _privateConstructorUsedError;
  String get priority => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  bool get isRecurring => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;

  /// Serializes this BaseTask to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BaseTask
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BaseTaskCopyWith<BaseTask> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BaseTaskCopyWith<$Res> {
  factory $BaseTaskCopyWith(BaseTask value, $Res Function(BaseTask) then) =
      _$BaseTaskCopyWithImpl<$Res, BaseTask>;
  @useResult
  $Res call(
      {String id,
      String title,
      String? description,
      String userId,
      String? assignedTo,
      String? categoryId,
      String? entityId,
      String? parentTaskId,
      String? routineId,
      String? routineInstanceId,
      bool isGeneratedFromRoutine,
      TaskType? taskType,
      String? taskSubtype,
      String? location,
      Map<String, dynamic>? typeSpecificData,
      TaskSchedulingType schedulingType,
      String priority,
      String status,
      bool isCompleted,
      DateTime? completedAt,
      bool isRecurring,
      List<String>? tags,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? deletedAt});
}

/// @nodoc
class _$BaseTaskCopyWithImpl<$Res, $Val extends BaseTask>
    implements $BaseTaskCopyWith<$Res> {
  _$BaseTaskCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BaseTask
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? userId = null,
    Object? assignedTo = freezed,
    Object? categoryId = freezed,
    Object? entityId = freezed,
    Object? parentTaskId = freezed,
    Object? routineId = freezed,
    Object? routineInstanceId = freezed,
    Object? isGeneratedFromRoutine = null,
    Object? taskType = freezed,
    Object? taskSubtype = freezed,
    Object? location = freezed,
    Object? typeSpecificData = freezed,
    Object? schedulingType = null,
    Object? priority = null,
    Object? status = null,
    Object? isCompleted = null,
    Object? completedAt = freezed,
    Object? isRecurring = null,
    Object? tags = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      assignedTo: freezed == assignedTo
          ? _value.assignedTo
          : assignedTo // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      entityId: freezed == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String?,
      parentTaskId: freezed == parentTaskId
          ? _value.parentTaskId
          : parentTaskId // ignore: cast_nullable_to_non_nullable
              as String?,
      routineId: freezed == routineId
          ? _value.routineId
          : routineId // ignore: cast_nullable_to_non_nullable
              as String?,
      routineInstanceId: freezed == routineInstanceId
          ? _value.routineInstanceId
          : routineInstanceId // ignore: cast_nullable_to_non_nullable
              as String?,
      isGeneratedFromRoutine: null == isGeneratedFromRoutine
          ? _value.isGeneratedFromRoutine
          : isGeneratedFromRoutine // ignore: cast_nullable_to_non_nullable
              as bool,
      taskType: freezed == taskType
          ? _value.taskType
          : taskType // ignore: cast_nullable_to_non_nullable
              as TaskType?,
      taskSubtype: freezed == taskSubtype
          ? _value.taskSubtype
          : taskSubtype // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      typeSpecificData: freezed == typeSpecificData
          ? _value.typeSpecificData
          : typeSpecificData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      schedulingType: null == schedulingType
          ? _value.schedulingType
          : schedulingType // ignore: cast_nullable_to_non_nullable
              as TaskSchedulingType,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isRecurring: null == isRecurring
          ? _value.isRecurring
          : isRecurring // ignore: cast_nullable_to_non_nullable
              as bool,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BaseTaskImplCopyWith<$Res>
    implements $BaseTaskCopyWith<$Res> {
  factory _$$BaseTaskImplCopyWith(
          _$BaseTaskImpl value, $Res Function(_$BaseTaskImpl) then) =
      __$$BaseTaskImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String? description,
      String userId,
      String? assignedTo,
      String? categoryId,
      String? entityId,
      String? parentTaskId,
      String? routineId,
      String? routineInstanceId,
      bool isGeneratedFromRoutine,
      TaskType? taskType,
      String? taskSubtype,
      String? location,
      Map<String, dynamic>? typeSpecificData,
      TaskSchedulingType schedulingType,
      String priority,
      String status,
      bool isCompleted,
      DateTime? completedAt,
      bool isRecurring,
      List<String>? tags,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? deletedAt});
}

/// @nodoc
class __$$BaseTaskImplCopyWithImpl<$Res>
    extends _$BaseTaskCopyWithImpl<$Res, _$BaseTaskImpl>
    implements _$$BaseTaskImplCopyWith<$Res> {
  __$$BaseTaskImplCopyWithImpl(
      _$BaseTaskImpl _value, $Res Function(_$BaseTaskImpl) _then)
      : super(_value, _then);

  /// Create a copy of BaseTask
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? userId = null,
    Object? assignedTo = freezed,
    Object? categoryId = freezed,
    Object? entityId = freezed,
    Object? parentTaskId = freezed,
    Object? routineId = freezed,
    Object? routineInstanceId = freezed,
    Object? isGeneratedFromRoutine = null,
    Object? taskType = freezed,
    Object? taskSubtype = freezed,
    Object? location = freezed,
    Object? typeSpecificData = freezed,
    Object? schedulingType = null,
    Object? priority = null,
    Object? status = null,
    Object? isCompleted = null,
    Object? completedAt = freezed,
    Object? isRecurring = null,
    Object? tags = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
  }) {
    return _then(_$BaseTaskImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      assignedTo: freezed == assignedTo
          ? _value.assignedTo
          : assignedTo // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      entityId: freezed == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String?,
      parentTaskId: freezed == parentTaskId
          ? _value.parentTaskId
          : parentTaskId // ignore: cast_nullable_to_non_nullable
              as String?,
      routineId: freezed == routineId
          ? _value.routineId
          : routineId // ignore: cast_nullable_to_non_nullable
              as String?,
      routineInstanceId: freezed == routineInstanceId
          ? _value.routineInstanceId
          : routineInstanceId // ignore: cast_nullable_to_non_nullable
              as String?,
      isGeneratedFromRoutine: null == isGeneratedFromRoutine
          ? _value.isGeneratedFromRoutine
          : isGeneratedFromRoutine // ignore: cast_nullable_to_non_nullable
              as bool,
      taskType: freezed == taskType
          ? _value.taskType
          : taskType // ignore: cast_nullable_to_non_nullable
              as TaskType?,
      taskSubtype: freezed == taskSubtype
          ? _value.taskSubtype
          : taskSubtype // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      typeSpecificData: freezed == typeSpecificData
          ? _value._typeSpecificData
          : typeSpecificData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      schedulingType: null == schedulingType
          ? _value.schedulingType
          : schedulingType // ignore: cast_nullable_to_non_nullable
              as TaskSchedulingType,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isRecurring: null == isRecurring
          ? _value.isRecurring
          : isRecurring // ignore: cast_nullable_to_non_nullable
              as bool,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BaseTaskImpl implements _BaseTask {
  const _$BaseTaskImpl(
      {required this.id,
      required this.title,
      this.description,
      required this.userId,
      this.assignedTo,
      this.categoryId,
      this.entityId,
      this.parentTaskId,
      this.routineId,
      this.routineInstanceId,
      this.isGeneratedFromRoutine = false,
      this.taskType,
      this.taskSubtype,
      this.location,
      final Map<String, dynamic>? typeSpecificData,
      required this.schedulingType,
      this.priority = 'medium',
      this.status = 'pending',
      this.isCompleted = false,
      this.completedAt,
      this.isRecurring = false,
      final List<String>? tags,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt})
      : _typeSpecificData = typeSpecificData,
        _tags = tags;

  factory _$BaseTaskImpl.fromJson(Map<String, dynamic> json) =>
      _$$BaseTaskImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? description;
  @override
  final String userId;
  @override
  final String? assignedTo;
  @override
  final String? categoryId;
  @override
  final String? entityId;
  @override
  final String? parentTaskId;
  @override
  final String? routineId;
  @override
  final String? routineInstanceId;
  @override
  @JsonKey()
  final bool isGeneratedFromRoutine;
  @override
  final TaskType? taskType;
  @override
  final String? taskSubtype;
  @override
  final String? location;
  final Map<String, dynamic>? _typeSpecificData;
  @override
  Map<String, dynamic>? get typeSpecificData {
    final value = _typeSpecificData;
    if (value == null) return null;
    if (_typeSpecificData is EqualUnmodifiableMapView) return _typeSpecificData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final TaskSchedulingType schedulingType;
  @override
  @JsonKey()
  final String priority;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final bool isCompleted;
  @override
  final DateTime? completedAt;
  @override
  @JsonKey()
  final bool isRecurring;
  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final DateTime? deletedAt;

  @override
  String toString() {
    return 'BaseTask(id: $id, title: $title, description: $description, userId: $userId, assignedTo: $assignedTo, categoryId: $categoryId, entityId: $entityId, parentTaskId: $parentTaskId, routineId: $routineId, routineInstanceId: $routineInstanceId, isGeneratedFromRoutine: $isGeneratedFromRoutine, taskType: $taskType, taskSubtype: $taskSubtype, location: $location, typeSpecificData: $typeSpecificData, schedulingType: $schedulingType, priority: $priority, status: $status, isCompleted: $isCompleted, completedAt: $completedAt, isRecurring: $isRecurring, tags: $tags, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BaseTaskImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.assignedTo, assignedTo) ||
                other.assignedTo == assignedTo) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.parentTaskId, parentTaskId) ||
                other.parentTaskId == parentTaskId) &&
            (identical(other.routineId, routineId) ||
                other.routineId == routineId) &&
            (identical(other.routineInstanceId, routineInstanceId) ||
                other.routineInstanceId == routineInstanceId) &&
            (identical(other.isGeneratedFromRoutine, isGeneratedFromRoutine) ||
                other.isGeneratedFromRoutine == isGeneratedFromRoutine) &&
            (identical(other.taskType, taskType) ||
                other.taskType == taskType) &&
            (identical(other.taskSubtype, taskSubtype) ||
                other.taskSubtype == taskSubtype) &&
            (identical(other.location, location) ||
                other.location == location) &&
            const DeepCollectionEquality()
                .equals(other._typeSpecificData, _typeSpecificData) &&
            (identical(other.schedulingType, schedulingType) ||
                other.schedulingType == schedulingType) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.isRecurring, isRecurring) ||
                other.isRecurring == isRecurring) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        title,
        description,
        userId,
        assignedTo,
        categoryId,
        entityId,
        parentTaskId,
        routineId,
        routineInstanceId,
        isGeneratedFromRoutine,
        taskType,
        taskSubtype,
        location,
        const DeepCollectionEquality().hash(_typeSpecificData),
        schedulingType,
        priority,
        status,
        isCompleted,
        completedAt,
        isRecurring,
        const DeepCollectionEquality().hash(_tags),
        createdAt,
        updatedAt,
        deletedAt
      ]);

  /// Create a copy of BaseTask
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BaseTaskImplCopyWith<_$BaseTaskImpl> get copyWith =>
      __$$BaseTaskImplCopyWithImpl<_$BaseTaskImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BaseTaskImplToJson(
      this,
    );
  }
}

abstract class _BaseTask implements BaseTask {
  const factory _BaseTask(
      {required final String id,
      required final String title,
      final String? description,
      required final String userId,
      final String? assignedTo,
      final String? categoryId,
      final String? entityId,
      final String? parentTaskId,
      final String? routineId,
      final String? routineInstanceId,
      final bool isGeneratedFromRoutine,
      final TaskType? taskType,
      final String? taskSubtype,
      final String? location,
      final Map<String, dynamic>? typeSpecificData,
      required final TaskSchedulingType schedulingType,
      final String priority,
      final String status,
      final bool isCompleted,
      final DateTime? completedAt,
      final bool isRecurring,
      final List<String>? tags,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final DateTime? deletedAt}) = _$BaseTaskImpl;

  factory _BaseTask.fromJson(Map<String, dynamic> json) =
      _$BaseTaskImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get description;
  @override
  String get userId;
  @override
  String? get assignedTo;
  @override
  String? get categoryId;
  @override
  String? get entityId;
  @override
  String? get parentTaskId;
  @override
  String? get routineId;
  @override
  String? get routineInstanceId;
  @override
  bool get isGeneratedFromRoutine;
  @override
  TaskType? get taskType;
  @override
  String? get taskSubtype;
  @override
  String? get location;
  @override
  Map<String, dynamic>? get typeSpecificData;
  @override
  TaskSchedulingType get schedulingType;
  @override
  String get priority;
  @override
  String get status;
  @override
  bool get isCompleted;
  @override
  DateTime? get completedAt;
  @override
  bool get isRecurring;
  @override
  List<String>? get tags;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  DateTime? get deletedAt;

  /// Create a copy of BaseTask
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BaseTaskImplCopyWith<_$BaseTaskImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FlexibleTask _$FlexibleTaskFromJson(Map<String, dynamic> json) {
  return _FlexibleTask.fromJson(json);
}

/// @nodoc
mixin _$FlexibleTask {
  /// Base task fields
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get assignedTo => throw _privateConstructorUsedError;
  String? get categoryId => throw _privateConstructorUsedError;
  String? get entityId => throw _privateConstructorUsedError;
  String? get parentTaskId => throw _privateConstructorUsedError;
  String? get routineId => throw _privateConstructorUsedError;
  String? get routineInstanceId => throw _privateConstructorUsedError;
  bool get isGeneratedFromRoutine => throw _privateConstructorUsedError;
  TaskType? get taskType => throw _privateConstructorUsedError;
  String? get taskSubtype => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  Map<String, dynamic>? get typeSpecificData =>
      throw _privateConstructorUsedError;
  String get priority => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  bool get isRecurring => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;

  /// FlexibleTask-specific fields
  DateTime? get earliestActionDate => throw _privateConstructorUsedError;
  DateTime? get dueDate => throw _privateConstructorUsedError;
  int get duration => throw _privateConstructorUsedError; // Duration in minutes
  TaskUrgency get urgency => throw _privateConstructorUsedError;

  /// Scheduling metadata
  DateTime? get scheduledStartTime => throw _privateConstructorUsedError;
  DateTime? get scheduledEndTime => throw _privateConstructorUsedError;
  bool get isScheduled => throw _privateConstructorUsedError;

  /// Serializes this FlexibleTask to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FlexibleTask
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FlexibleTaskCopyWith<FlexibleTask> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FlexibleTaskCopyWith<$Res> {
  factory $FlexibleTaskCopyWith(
          FlexibleTask value, $Res Function(FlexibleTask) then) =
      _$FlexibleTaskCopyWithImpl<$Res, FlexibleTask>;
  @useResult
  $Res call(
      {String id,
      String title,
      String? description,
      String userId,
      String? assignedTo,
      String? categoryId,
      String? entityId,
      String? parentTaskId,
      String? routineId,
      String? routineInstanceId,
      bool isGeneratedFromRoutine,
      TaskType? taskType,
      String? taskSubtype,
      String? location,
      Map<String, dynamic>? typeSpecificData,
      String priority,
      String status,
      bool isCompleted,
      DateTime? completedAt,
      bool isRecurring,
      List<String>? tags,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? deletedAt,
      DateTime? earliestActionDate,
      DateTime? dueDate,
      int duration,
      TaskUrgency urgency,
      DateTime? scheduledStartTime,
      DateTime? scheduledEndTime,
      bool isScheduled});
}

/// @nodoc
class _$FlexibleTaskCopyWithImpl<$Res, $Val extends FlexibleTask>
    implements $FlexibleTaskCopyWith<$Res> {
  _$FlexibleTaskCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FlexibleTask
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? userId = null,
    Object? assignedTo = freezed,
    Object? categoryId = freezed,
    Object? entityId = freezed,
    Object? parentTaskId = freezed,
    Object? routineId = freezed,
    Object? routineInstanceId = freezed,
    Object? isGeneratedFromRoutine = null,
    Object? taskType = freezed,
    Object? taskSubtype = freezed,
    Object? location = freezed,
    Object? typeSpecificData = freezed,
    Object? priority = null,
    Object? status = null,
    Object? isCompleted = null,
    Object? completedAt = freezed,
    Object? isRecurring = null,
    Object? tags = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
    Object? earliestActionDate = freezed,
    Object? dueDate = freezed,
    Object? duration = null,
    Object? urgency = null,
    Object? scheduledStartTime = freezed,
    Object? scheduledEndTime = freezed,
    Object? isScheduled = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      assignedTo: freezed == assignedTo
          ? _value.assignedTo
          : assignedTo // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      entityId: freezed == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String?,
      parentTaskId: freezed == parentTaskId
          ? _value.parentTaskId
          : parentTaskId // ignore: cast_nullable_to_non_nullable
              as String?,
      routineId: freezed == routineId
          ? _value.routineId
          : routineId // ignore: cast_nullable_to_non_nullable
              as String?,
      routineInstanceId: freezed == routineInstanceId
          ? _value.routineInstanceId
          : routineInstanceId // ignore: cast_nullable_to_non_nullable
              as String?,
      isGeneratedFromRoutine: null == isGeneratedFromRoutine
          ? _value.isGeneratedFromRoutine
          : isGeneratedFromRoutine // ignore: cast_nullable_to_non_nullable
              as bool,
      taskType: freezed == taskType
          ? _value.taskType
          : taskType // ignore: cast_nullable_to_non_nullable
              as TaskType?,
      taskSubtype: freezed == taskSubtype
          ? _value.taskSubtype
          : taskSubtype // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      typeSpecificData: freezed == typeSpecificData
          ? _value.typeSpecificData
          : typeSpecificData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isRecurring: null == isRecurring
          ? _value.isRecurring
          : isRecurring // ignore: cast_nullable_to_non_nullable
              as bool,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      earliestActionDate: freezed == earliestActionDate
          ? _value.earliestActionDate
          : earliestActionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      urgency: null == urgency
          ? _value.urgency
          : urgency // ignore: cast_nullable_to_non_nullable
              as TaskUrgency,
      scheduledStartTime: freezed == scheduledStartTime
          ? _value.scheduledStartTime
          : scheduledStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      scheduledEndTime: freezed == scheduledEndTime
          ? _value.scheduledEndTime
          : scheduledEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isScheduled: null == isScheduled
          ? _value.isScheduled
          : isScheduled // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FlexibleTaskImplCopyWith<$Res>
    implements $FlexibleTaskCopyWith<$Res> {
  factory _$$FlexibleTaskImplCopyWith(
          _$FlexibleTaskImpl value, $Res Function(_$FlexibleTaskImpl) then) =
      __$$FlexibleTaskImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String? description,
      String userId,
      String? assignedTo,
      String? categoryId,
      String? entityId,
      String? parentTaskId,
      String? routineId,
      String? routineInstanceId,
      bool isGeneratedFromRoutine,
      TaskType? taskType,
      String? taskSubtype,
      String? location,
      Map<String, dynamic>? typeSpecificData,
      String priority,
      String status,
      bool isCompleted,
      DateTime? completedAt,
      bool isRecurring,
      List<String>? tags,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? deletedAt,
      DateTime? earliestActionDate,
      DateTime? dueDate,
      int duration,
      TaskUrgency urgency,
      DateTime? scheduledStartTime,
      DateTime? scheduledEndTime,
      bool isScheduled});
}

/// @nodoc
class __$$FlexibleTaskImplCopyWithImpl<$Res>
    extends _$FlexibleTaskCopyWithImpl<$Res, _$FlexibleTaskImpl>
    implements _$$FlexibleTaskImplCopyWith<$Res> {
  __$$FlexibleTaskImplCopyWithImpl(
      _$FlexibleTaskImpl _value, $Res Function(_$FlexibleTaskImpl) _then)
      : super(_value, _then);

  /// Create a copy of FlexibleTask
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? userId = null,
    Object? assignedTo = freezed,
    Object? categoryId = freezed,
    Object? entityId = freezed,
    Object? parentTaskId = freezed,
    Object? routineId = freezed,
    Object? routineInstanceId = freezed,
    Object? isGeneratedFromRoutine = null,
    Object? taskType = freezed,
    Object? taskSubtype = freezed,
    Object? location = freezed,
    Object? typeSpecificData = freezed,
    Object? priority = null,
    Object? status = null,
    Object? isCompleted = null,
    Object? completedAt = freezed,
    Object? isRecurring = null,
    Object? tags = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
    Object? earliestActionDate = freezed,
    Object? dueDate = freezed,
    Object? duration = null,
    Object? urgency = null,
    Object? scheduledStartTime = freezed,
    Object? scheduledEndTime = freezed,
    Object? isScheduled = null,
  }) {
    return _then(_$FlexibleTaskImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      assignedTo: freezed == assignedTo
          ? _value.assignedTo
          : assignedTo // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      entityId: freezed == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String?,
      parentTaskId: freezed == parentTaskId
          ? _value.parentTaskId
          : parentTaskId // ignore: cast_nullable_to_non_nullable
              as String?,
      routineId: freezed == routineId
          ? _value.routineId
          : routineId // ignore: cast_nullable_to_non_nullable
              as String?,
      routineInstanceId: freezed == routineInstanceId
          ? _value.routineInstanceId
          : routineInstanceId // ignore: cast_nullable_to_non_nullable
              as String?,
      isGeneratedFromRoutine: null == isGeneratedFromRoutine
          ? _value.isGeneratedFromRoutine
          : isGeneratedFromRoutine // ignore: cast_nullable_to_non_nullable
              as bool,
      taskType: freezed == taskType
          ? _value.taskType
          : taskType // ignore: cast_nullable_to_non_nullable
              as TaskType?,
      taskSubtype: freezed == taskSubtype
          ? _value.taskSubtype
          : taskSubtype // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      typeSpecificData: freezed == typeSpecificData
          ? _value._typeSpecificData
          : typeSpecificData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isRecurring: null == isRecurring
          ? _value.isRecurring
          : isRecurring // ignore: cast_nullable_to_non_nullable
              as bool,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      earliestActionDate: freezed == earliestActionDate
          ? _value.earliestActionDate
          : earliestActionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      urgency: null == urgency
          ? _value.urgency
          : urgency // ignore: cast_nullable_to_non_nullable
              as TaskUrgency,
      scheduledStartTime: freezed == scheduledStartTime
          ? _value.scheduledStartTime
          : scheduledStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      scheduledEndTime: freezed == scheduledEndTime
          ? _value.scheduledEndTime
          : scheduledEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isScheduled: null == isScheduled
          ? _value.isScheduled
          : isScheduled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FlexibleTaskImpl implements _FlexibleTask {
  const _$FlexibleTaskImpl(
      {required this.id,
      required this.title,
      this.description,
      required this.userId,
      this.assignedTo,
      this.categoryId,
      this.entityId,
      this.parentTaskId,
      this.routineId,
      this.routineInstanceId,
      this.isGeneratedFromRoutine = false,
      this.taskType,
      this.taskSubtype,
      this.location,
      final Map<String, dynamic>? typeSpecificData,
      this.priority = 'medium',
      this.status = 'pending',
      this.isCompleted = false,
      this.completedAt,
      this.isRecurring = false,
      final List<String>? tags,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      this.earliestActionDate,
      this.dueDate,
      required this.duration,
      this.urgency = TaskUrgency.medium,
      this.scheduledStartTime,
      this.scheduledEndTime,
      this.isScheduled = false})
      : _typeSpecificData = typeSpecificData,
        _tags = tags;

  factory _$FlexibleTaskImpl.fromJson(Map<String, dynamic> json) =>
      _$$FlexibleTaskImplFromJson(json);

  /// Base task fields
  @override
  final String id;
  @override
  final String title;
  @override
  final String? description;
  @override
  final String userId;
  @override
  final String? assignedTo;
  @override
  final String? categoryId;
  @override
  final String? entityId;
  @override
  final String? parentTaskId;
  @override
  final String? routineId;
  @override
  final String? routineInstanceId;
  @override
  @JsonKey()
  final bool isGeneratedFromRoutine;
  @override
  final TaskType? taskType;
  @override
  final String? taskSubtype;
  @override
  final String? location;
  final Map<String, dynamic>? _typeSpecificData;
  @override
  Map<String, dynamic>? get typeSpecificData {
    final value = _typeSpecificData;
    if (value == null) return null;
    if (_typeSpecificData is EqualUnmodifiableMapView) return _typeSpecificData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  final String priority;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final bool isCompleted;
  @override
  final DateTime? completedAt;
  @override
  @JsonKey()
  final bool isRecurring;
  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final DateTime? deletedAt;

  /// FlexibleTask-specific fields
  @override
  final DateTime? earliestActionDate;
  @override
  final DateTime? dueDate;
  @override
  final int duration;
// Duration in minutes
  @override
  @JsonKey()
  final TaskUrgency urgency;

  /// Scheduling metadata
  @override
  final DateTime? scheduledStartTime;
  @override
  final DateTime? scheduledEndTime;
  @override
  @JsonKey()
  final bool isScheduled;

  @override
  String toString() {
    return 'FlexibleTask(id: $id, title: $title, description: $description, userId: $userId, assignedTo: $assignedTo, categoryId: $categoryId, entityId: $entityId, parentTaskId: $parentTaskId, routineId: $routineId, routineInstanceId: $routineInstanceId, isGeneratedFromRoutine: $isGeneratedFromRoutine, taskType: $taskType, taskSubtype: $taskSubtype, location: $location, typeSpecificData: $typeSpecificData, priority: $priority, status: $status, isCompleted: $isCompleted, completedAt: $completedAt, isRecurring: $isRecurring, tags: $tags, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, earliestActionDate: $earliestActionDate, dueDate: $dueDate, duration: $duration, urgency: $urgency, scheduledStartTime: $scheduledStartTime, scheduledEndTime: $scheduledEndTime, isScheduled: $isScheduled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FlexibleTaskImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.assignedTo, assignedTo) ||
                other.assignedTo == assignedTo) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.parentTaskId, parentTaskId) ||
                other.parentTaskId == parentTaskId) &&
            (identical(other.routineId, routineId) ||
                other.routineId == routineId) &&
            (identical(other.routineInstanceId, routineInstanceId) ||
                other.routineInstanceId == routineInstanceId) &&
            (identical(other.isGeneratedFromRoutine, isGeneratedFromRoutine) ||
                other.isGeneratedFromRoutine == isGeneratedFromRoutine) &&
            (identical(other.taskType, taskType) ||
                other.taskType == taskType) &&
            (identical(other.taskSubtype, taskSubtype) ||
                other.taskSubtype == taskSubtype) &&
            (identical(other.location, location) ||
                other.location == location) &&
            const DeepCollectionEquality()
                .equals(other._typeSpecificData, _typeSpecificData) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.isRecurring, isRecurring) ||
                other.isRecurring == isRecurring) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.earliestActionDate, earliestActionDate) ||
                other.earliestActionDate == earliestActionDate) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.urgency, urgency) || other.urgency == urgency) &&
            (identical(other.scheduledStartTime, scheduledStartTime) ||
                other.scheduledStartTime == scheduledStartTime) &&
            (identical(other.scheduledEndTime, scheduledEndTime) ||
                other.scheduledEndTime == scheduledEndTime) &&
            (identical(other.isScheduled, isScheduled) ||
                other.isScheduled == isScheduled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        title,
        description,
        userId,
        assignedTo,
        categoryId,
        entityId,
        parentTaskId,
        routineId,
        routineInstanceId,
        isGeneratedFromRoutine,
        taskType,
        taskSubtype,
        location,
        const DeepCollectionEquality().hash(_typeSpecificData),
        priority,
        status,
        isCompleted,
        completedAt,
        isRecurring,
        const DeepCollectionEquality().hash(_tags),
        createdAt,
        updatedAt,
        deletedAt,
        earliestActionDate,
        dueDate,
        duration,
        urgency,
        scheduledStartTime,
        scheduledEndTime,
        isScheduled
      ]);

  /// Create a copy of FlexibleTask
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FlexibleTaskImplCopyWith<_$FlexibleTaskImpl> get copyWith =>
      __$$FlexibleTaskImplCopyWithImpl<_$FlexibleTaskImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FlexibleTaskImplToJson(
      this,
    );
  }
}

abstract class _FlexibleTask implements FlexibleTask {
  const factory _FlexibleTask(
      {required final String id,
      required final String title,
      final String? description,
      required final String userId,
      final String? assignedTo,
      final String? categoryId,
      final String? entityId,
      final String? parentTaskId,
      final String? routineId,
      final String? routineInstanceId,
      final bool isGeneratedFromRoutine,
      final TaskType? taskType,
      final String? taskSubtype,
      final String? location,
      final Map<String, dynamic>? typeSpecificData,
      final String priority,
      final String status,
      final bool isCompleted,
      final DateTime? completedAt,
      final bool isRecurring,
      final List<String>? tags,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final DateTime? deletedAt,
      final DateTime? earliestActionDate,
      final DateTime? dueDate,
      required final int duration,
      final TaskUrgency urgency,
      final DateTime? scheduledStartTime,
      final DateTime? scheduledEndTime,
      final bool isScheduled}) = _$FlexibleTaskImpl;

  factory _FlexibleTask.fromJson(Map<String, dynamic> json) =
      _$FlexibleTaskImpl.fromJson;

  /// Base task fields
  @override
  String get id;
  @override
  String get title;
  @override
  String? get description;
  @override
  String get userId;
  @override
  String? get assignedTo;
  @override
  String? get categoryId;
  @override
  String? get entityId;
  @override
  String? get parentTaskId;
  @override
  String? get routineId;
  @override
  String? get routineInstanceId;
  @override
  bool get isGeneratedFromRoutine;
  @override
  TaskType? get taskType;
  @override
  String? get taskSubtype;
  @override
  String? get location;
  @override
  Map<String, dynamic>? get typeSpecificData;
  @override
  String get priority;
  @override
  String get status;
  @override
  bool get isCompleted;
  @override
  DateTime? get completedAt;
  @override
  bool get isRecurring;
  @override
  List<String>? get tags;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  DateTime? get deletedAt;

  /// FlexibleTask-specific fields
  @override
  DateTime? get earliestActionDate;
  @override
  DateTime? get dueDate;
  @override
  int get duration; // Duration in minutes
  @override
  TaskUrgency get urgency;

  /// Scheduling metadata
  @override
  DateTime? get scheduledStartTime;
  @override
  DateTime? get scheduledEndTime;
  @override
  bool get isScheduled;

  /// Create a copy of FlexibleTask
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FlexibleTaskImplCopyWith<_$FlexibleTaskImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FixedTask _$FixedTaskFromJson(Map<String, dynamic> json) {
  return _FixedTask.fromJson(json);
}

/// @nodoc
mixin _$FixedTask {
  /// Base task fields
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get assignedTo => throw _privateConstructorUsedError;
  String? get categoryId => throw _privateConstructorUsedError;
  String? get entityId => throw _privateConstructorUsedError;
  String? get parentTaskId => throw _privateConstructorUsedError;
  String? get routineId => throw _privateConstructorUsedError;
  String? get routineInstanceId => throw _privateConstructorUsedError;
  bool get isGeneratedFromRoutine => throw _privateConstructorUsedError;
  TaskType? get taskType => throw _privateConstructorUsedError;
  String? get taskSubtype => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  Map<String, dynamic>? get typeSpecificData =>
      throw _privateConstructorUsedError;
  String get priority => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  bool get isRecurring => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;

  /// FixedTask-specific fields
  DateTime? get startDateTime => throw _privateConstructorUsedError;
  DateTime? get endDateTime => throw _privateConstructorUsedError;
  String? get startTimezone => throw _privateConstructorUsedError;
  String? get endTimezone => throw _privateConstructorUsedError;
  DateTime? get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  DateTime? get date => throw _privateConstructorUsedError;
  int? get duration => throw _privateConstructorUsedError;

  /// Serializes this FixedTask to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FixedTask
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FixedTaskCopyWith<FixedTask> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FixedTaskCopyWith<$Res> {
  factory $FixedTaskCopyWith(FixedTask value, $Res Function(FixedTask) then) =
      _$FixedTaskCopyWithImpl<$Res, FixedTask>;
  @useResult
  $Res call(
      {String id,
      String title,
      String? description,
      String userId,
      String? assignedTo,
      String? categoryId,
      String? entityId,
      String? parentTaskId,
      String? routineId,
      String? routineInstanceId,
      bool isGeneratedFromRoutine,
      TaskType? taskType,
      String? taskSubtype,
      String? location,
      Map<String, dynamic>? typeSpecificData,
      String priority,
      String status,
      bool isCompleted,
      DateTime? completedAt,
      bool isRecurring,
      List<String>? tags,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? deletedAt,
      DateTime? startDateTime,
      DateTime? endDateTime,
      String? startTimezone,
      String? endTimezone,
      DateTime? startDate,
      DateTime? endDate,
      DateTime? date,
      int? duration});
}

/// @nodoc
class _$FixedTaskCopyWithImpl<$Res, $Val extends FixedTask>
    implements $FixedTaskCopyWith<$Res> {
  _$FixedTaskCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FixedTask
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? userId = null,
    Object? assignedTo = freezed,
    Object? categoryId = freezed,
    Object? entityId = freezed,
    Object? parentTaskId = freezed,
    Object? routineId = freezed,
    Object? routineInstanceId = freezed,
    Object? isGeneratedFromRoutine = null,
    Object? taskType = freezed,
    Object? taskSubtype = freezed,
    Object? location = freezed,
    Object? typeSpecificData = freezed,
    Object? priority = null,
    Object? status = null,
    Object? isCompleted = null,
    Object? completedAt = freezed,
    Object? isRecurring = null,
    Object? tags = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
    Object? startDateTime = freezed,
    Object? endDateTime = freezed,
    Object? startTimezone = freezed,
    Object? endTimezone = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? date = freezed,
    Object? duration = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      assignedTo: freezed == assignedTo
          ? _value.assignedTo
          : assignedTo // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      entityId: freezed == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String?,
      parentTaskId: freezed == parentTaskId
          ? _value.parentTaskId
          : parentTaskId // ignore: cast_nullable_to_non_nullable
              as String?,
      routineId: freezed == routineId
          ? _value.routineId
          : routineId // ignore: cast_nullable_to_non_nullable
              as String?,
      routineInstanceId: freezed == routineInstanceId
          ? _value.routineInstanceId
          : routineInstanceId // ignore: cast_nullable_to_non_nullable
              as String?,
      isGeneratedFromRoutine: null == isGeneratedFromRoutine
          ? _value.isGeneratedFromRoutine
          : isGeneratedFromRoutine // ignore: cast_nullable_to_non_nullable
              as bool,
      taskType: freezed == taskType
          ? _value.taskType
          : taskType // ignore: cast_nullable_to_non_nullable
              as TaskType?,
      taskSubtype: freezed == taskSubtype
          ? _value.taskSubtype
          : taskSubtype // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      typeSpecificData: freezed == typeSpecificData
          ? _value.typeSpecificData
          : typeSpecificData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isRecurring: null == isRecurring
          ? _value.isRecurring
          : isRecurring // ignore: cast_nullable_to_non_nullable
              as bool,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      startDateTime: freezed == startDateTime
          ? _value.startDateTime
          : startDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDateTime: freezed == endDateTime
          ? _value.endDateTime
          : endDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      startTimezone: freezed == startTimezone
          ? _value.startTimezone
          : startTimezone // ignore: cast_nullable_to_non_nullable
              as String?,
      endTimezone: freezed == endTimezone
          ? _value.endTimezone
          : endTimezone // ignore: cast_nullable_to_non_nullable
              as String?,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FixedTaskImplCopyWith<$Res>
    implements $FixedTaskCopyWith<$Res> {
  factory _$$FixedTaskImplCopyWith(
          _$FixedTaskImpl value, $Res Function(_$FixedTaskImpl) then) =
      __$$FixedTaskImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String? description,
      String userId,
      String? assignedTo,
      String? categoryId,
      String? entityId,
      String? parentTaskId,
      String? routineId,
      String? routineInstanceId,
      bool isGeneratedFromRoutine,
      TaskType? taskType,
      String? taskSubtype,
      String? location,
      Map<String, dynamic>? typeSpecificData,
      String priority,
      String status,
      bool isCompleted,
      DateTime? completedAt,
      bool isRecurring,
      List<String>? tags,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? deletedAt,
      DateTime? startDateTime,
      DateTime? endDateTime,
      String? startTimezone,
      String? endTimezone,
      DateTime? startDate,
      DateTime? endDate,
      DateTime? date,
      int? duration});
}

/// @nodoc
class __$$FixedTaskImplCopyWithImpl<$Res>
    extends _$FixedTaskCopyWithImpl<$Res, _$FixedTaskImpl>
    implements _$$FixedTaskImplCopyWith<$Res> {
  __$$FixedTaskImplCopyWithImpl(
      _$FixedTaskImpl _value, $Res Function(_$FixedTaskImpl) _then)
      : super(_value, _then);

  /// Create a copy of FixedTask
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? userId = null,
    Object? assignedTo = freezed,
    Object? categoryId = freezed,
    Object? entityId = freezed,
    Object? parentTaskId = freezed,
    Object? routineId = freezed,
    Object? routineInstanceId = freezed,
    Object? isGeneratedFromRoutine = null,
    Object? taskType = freezed,
    Object? taskSubtype = freezed,
    Object? location = freezed,
    Object? typeSpecificData = freezed,
    Object? priority = null,
    Object? status = null,
    Object? isCompleted = null,
    Object? completedAt = freezed,
    Object? isRecurring = null,
    Object? tags = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
    Object? startDateTime = freezed,
    Object? endDateTime = freezed,
    Object? startTimezone = freezed,
    Object? endTimezone = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? date = freezed,
    Object? duration = freezed,
  }) {
    return _then(_$FixedTaskImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      assignedTo: freezed == assignedTo
          ? _value.assignedTo
          : assignedTo // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      entityId: freezed == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String?,
      parentTaskId: freezed == parentTaskId
          ? _value.parentTaskId
          : parentTaskId // ignore: cast_nullable_to_non_nullable
              as String?,
      routineId: freezed == routineId
          ? _value.routineId
          : routineId // ignore: cast_nullable_to_non_nullable
              as String?,
      routineInstanceId: freezed == routineInstanceId
          ? _value.routineInstanceId
          : routineInstanceId // ignore: cast_nullable_to_non_nullable
              as String?,
      isGeneratedFromRoutine: null == isGeneratedFromRoutine
          ? _value.isGeneratedFromRoutine
          : isGeneratedFromRoutine // ignore: cast_nullable_to_non_nullable
              as bool,
      taskType: freezed == taskType
          ? _value.taskType
          : taskType // ignore: cast_nullable_to_non_nullable
              as TaskType?,
      taskSubtype: freezed == taskSubtype
          ? _value.taskSubtype
          : taskSubtype // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      typeSpecificData: freezed == typeSpecificData
          ? _value._typeSpecificData
          : typeSpecificData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isRecurring: null == isRecurring
          ? _value.isRecurring
          : isRecurring // ignore: cast_nullable_to_non_nullable
              as bool,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      startDateTime: freezed == startDateTime
          ? _value.startDateTime
          : startDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDateTime: freezed == endDateTime
          ? _value.endDateTime
          : endDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      startTimezone: freezed == startTimezone
          ? _value.startTimezone
          : startTimezone // ignore: cast_nullable_to_non_nullable
              as String?,
      endTimezone: freezed == endTimezone
          ? _value.endTimezone
          : endTimezone // ignore: cast_nullable_to_non_nullable
              as String?,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FixedTaskImpl implements _FixedTask {
  const _$FixedTaskImpl(
      {required this.id,
      required this.title,
      this.description,
      required this.userId,
      this.assignedTo,
      this.categoryId,
      this.entityId,
      this.parentTaskId,
      this.routineId,
      this.routineInstanceId,
      this.isGeneratedFromRoutine = false,
      this.taskType,
      this.taskSubtype,
      this.location,
      final Map<String, dynamic>? typeSpecificData,
      this.priority = 'medium',
      this.status = 'pending',
      this.isCompleted = false,
      this.completedAt,
      this.isRecurring = false,
      final List<String>? tags,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      this.startDateTime,
      this.endDateTime,
      this.startTimezone,
      this.endTimezone,
      this.startDate,
      this.endDate,
      this.date,
      this.duration})
      : _typeSpecificData = typeSpecificData,
        _tags = tags;

  factory _$FixedTaskImpl.fromJson(Map<String, dynamic> json) =>
      _$$FixedTaskImplFromJson(json);

  /// Base task fields
  @override
  final String id;
  @override
  final String title;
  @override
  final String? description;
  @override
  final String userId;
  @override
  final String? assignedTo;
  @override
  final String? categoryId;
  @override
  final String? entityId;
  @override
  final String? parentTaskId;
  @override
  final String? routineId;
  @override
  final String? routineInstanceId;
  @override
  @JsonKey()
  final bool isGeneratedFromRoutine;
  @override
  final TaskType? taskType;
  @override
  final String? taskSubtype;
  @override
  final String? location;
  final Map<String, dynamic>? _typeSpecificData;
  @override
  Map<String, dynamic>? get typeSpecificData {
    final value = _typeSpecificData;
    if (value == null) return null;
    if (_typeSpecificData is EqualUnmodifiableMapView) return _typeSpecificData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  final String priority;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final bool isCompleted;
  @override
  final DateTime? completedAt;
  @override
  @JsonKey()
  final bool isRecurring;
  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final DateTime? deletedAt;

  /// FixedTask-specific fields
  @override
  final DateTime? startDateTime;
  @override
  final DateTime? endDateTime;
  @override
  final String? startTimezone;
  @override
  final String? endTimezone;
  @override
  final DateTime? startDate;
  @override
  final DateTime? endDate;
  @override
  final DateTime? date;
  @override
  final int? duration;

  @override
  String toString() {
    return 'FixedTask(id: $id, title: $title, description: $description, userId: $userId, assignedTo: $assignedTo, categoryId: $categoryId, entityId: $entityId, parentTaskId: $parentTaskId, routineId: $routineId, routineInstanceId: $routineInstanceId, isGeneratedFromRoutine: $isGeneratedFromRoutine, taskType: $taskType, taskSubtype: $taskSubtype, location: $location, typeSpecificData: $typeSpecificData, priority: $priority, status: $status, isCompleted: $isCompleted, completedAt: $completedAt, isRecurring: $isRecurring, tags: $tags, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, startDateTime: $startDateTime, endDateTime: $endDateTime, startTimezone: $startTimezone, endTimezone: $endTimezone, startDate: $startDate, endDate: $endDate, date: $date, duration: $duration)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FixedTaskImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.assignedTo, assignedTo) ||
                other.assignedTo == assignedTo) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.parentTaskId, parentTaskId) ||
                other.parentTaskId == parentTaskId) &&
            (identical(other.routineId, routineId) ||
                other.routineId == routineId) &&
            (identical(other.routineInstanceId, routineInstanceId) ||
                other.routineInstanceId == routineInstanceId) &&
            (identical(other.isGeneratedFromRoutine, isGeneratedFromRoutine) ||
                other.isGeneratedFromRoutine == isGeneratedFromRoutine) &&
            (identical(other.taskType, taskType) ||
                other.taskType == taskType) &&
            (identical(other.taskSubtype, taskSubtype) ||
                other.taskSubtype == taskSubtype) &&
            (identical(other.location, location) ||
                other.location == location) &&
            const DeepCollectionEquality()
                .equals(other._typeSpecificData, _typeSpecificData) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.isRecurring, isRecurring) ||
                other.isRecurring == isRecurring) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.startDateTime, startDateTime) ||
                other.startDateTime == startDateTime) &&
            (identical(other.endDateTime, endDateTime) ||
                other.endDateTime == endDateTime) &&
            (identical(other.startTimezone, startTimezone) ||
                other.startTimezone == startTimezone) &&
            (identical(other.endTimezone, endTimezone) ||
                other.endTimezone == endTimezone) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        title,
        description,
        userId,
        assignedTo,
        categoryId,
        entityId,
        parentTaskId,
        routineId,
        routineInstanceId,
        isGeneratedFromRoutine,
        taskType,
        taskSubtype,
        location,
        const DeepCollectionEquality().hash(_typeSpecificData),
        priority,
        status,
        isCompleted,
        completedAt,
        isRecurring,
        const DeepCollectionEquality().hash(_tags),
        createdAt,
        updatedAt,
        deletedAt,
        startDateTime,
        endDateTime,
        startTimezone,
        endTimezone,
        startDate,
        endDate,
        date,
        duration
      ]);

  /// Create a copy of FixedTask
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FixedTaskImplCopyWith<_$FixedTaskImpl> get copyWith =>
      __$$FixedTaskImplCopyWithImpl<_$FixedTaskImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FixedTaskImplToJson(
      this,
    );
  }
}

abstract class _FixedTask implements FixedTask {
  const factory _FixedTask(
      {required final String id,
      required final String title,
      final String? description,
      required final String userId,
      final String? assignedTo,
      final String? categoryId,
      final String? entityId,
      final String? parentTaskId,
      final String? routineId,
      final String? routineInstanceId,
      final bool isGeneratedFromRoutine,
      final TaskType? taskType,
      final String? taskSubtype,
      final String? location,
      final Map<String, dynamic>? typeSpecificData,
      final String priority,
      final String status,
      final bool isCompleted,
      final DateTime? completedAt,
      final bool isRecurring,
      final List<String>? tags,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final DateTime? deletedAt,
      final DateTime? startDateTime,
      final DateTime? endDateTime,
      final String? startTimezone,
      final String? endTimezone,
      final DateTime? startDate,
      final DateTime? endDate,
      final DateTime? date,
      final int? duration}) = _$FixedTaskImpl;

  factory _FixedTask.fromJson(Map<String, dynamic> json) =
      _$FixedTaskImpl.fromJson;

  /// Base task fields
  @override
  String get id;
  @override
  String get title;
  @override
  String? get description;
  @override
  String get userId;
  @override
  String? get assignedTo;
  @override
  String? get categoryId;
  @override
  String? get entityId;
  @override
  String? get parentTaskId;
  @override
  String? get routineId;
  @override
  String? get routineInstanceId;
  @override
  bool get isGeneratedFromRoutine;
  @override
  TaskType? get taskType;
  @override
  String? get taskSubtype;
  @override
  String? get location;
  @override
  Map<String, dynamic>? get typeSpecificData;
  @override
  String get priority;
  @override
  String get status;
  @override
  bool get isCompleted;
  @override
  DateTime? get completedAt;
  @override
  bool get isRecurring;
  @override
  List<String>? get tags;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  DateTime? get deletedAt;

  /// FixedTask-specific fields
  @override
  DateTime? get startDateTime;
  @override
  DateTime? get endDateTime;
  @override
  String? get startTimezone;
  @override
  String? get endTimezone;
  @override
  DateTime? get startDate;
  @override
  DateTime? get endDate;
  @override
  DateTime? get date;
  @override
  int? get duration;

  /// Create a copy of FixedTask
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FixedTaskImplCopyWith<_$FixedTaskImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Recurrence _$RecurrenceFromJson(Map<String, dynamic> json) {
  return _Recurrence.fromJson(json);
}

/// @nodoc
mixin _$Recurrence {
  String get id => throw _privateConstructorUsedError;
  String get taskId => throw _privateConstructorUsedError;
  RecurrenceType get recurrenceType => throw _privateConstructorUsedError;
  int get intervalLength => throw _privateConstructorUsedError;
  DateTime? get earliestOccurrence => throw _privateConstructorUsedError;
  DateTime? get latestOccurrence => throw _privateConstructorUsedError;
  Map<String, dynamic>? get recurrenceData =>
      throw _privateConstructorUsedError; // Additional recurrence configuration
  bool get isActive => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Recurrence to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Recurrence
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecurrenceCopyWith<Recurrence> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecurrenceCopyWith<$Res> {
  factory $RecurrenceCopyWith(
          Recurrence value, $Res Function(Recurrence) then) =
      _$RecurrenceCopyWithImpl<$Res, Recurrence>;
  @useResult
  $Res call(
      {String id,
      String taskId,
      RecurrenceType recurrenceType,
      int intervalLength,
      DateTime? earliestOccurrence,
      DateTime? latestOccurrence,
      Map<String, dynamic>? recurrenceData,
      bool isActive,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$RecurrenceCopyWithImpl<$Res, $Val extends Recurrence>
    implements $RecurrenceCopyWith<$Res> {
  _$RecurrenceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Recurrence
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? taskId = null,
    Object? recurrenceType = null,
    Object? intervalLength = null,
    Object? earliestOccurrence = freezed,
    Object? latestOccurrence = freezed,
    Object? recurrenceData = freezed,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      taskId: null == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String,
      recurrenceType: null == recurrenceType
          ? _value.recurrenceType
          : recurrenceType // ignore: cast_nullable_to_non_nullable
              as RecurrenceType,
      intervalLength: null == intervalLength
          ? _value.intervalLength
          : intervalLength // ignore: cast_nullable_to_non_nullable
              as int,
      earliestOccurrence: freezed == earliestOccurrence
          ? _value.earliestOccurrence
          : earliestOccurrence // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      latestOccurrence: freezed == latestOccurrence
          ? _value.latestOccurrence
          : latestOccurrence // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      recurrenceData: freezed == recurrenceData
          ? _value.recurrenceData
          : recurrenceData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
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
abstract class _$$RecurrenceImplCopyWith<$Res>
    implements $RecurrenceCopyWith<$Res> {
  factory _$$RecurrenceImplCopyWith(
          _$RecurrenceImpl value, $Res Function(_$RecurrenceImpl) then) =
      __$$RecurrenceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String taskId,
      RecurrenceType recurrenceType,
      int intervalLength,
      DateTime? earliestOccurrence,
      DateTime? latestOccurrence,
      Map<String, dynamic>? recurrenceData,
      bool isActive,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$RecurrenceImplCopyWithImpl<$Res>
    extends _$RecurrenceCopyWithImpl<$Res, _$RecurrenceImpl>
    implements _$$RecurrenceImplCopyWith<$Res> {
  __$$RecurrenceImplCopyWithImpl(
      _$RecurrenceImpl _value, $Res Function(_$RecurrenceImpl) _then)
      : super(_value, _then);

  /// Create a copy of Recurrence
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? taskId = null,
    Object? recurrenceType = null,
    Object? intervalLength = null,
    Object? earliestOccurrence = freezed,
    Object? latestOccurrence = freezed,
    Object? recurrenceData = freezed,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$RecurrenceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      taskId: null == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String,
      recurrenceType: null == recurrenceType
          ? _value.recurrenceType
          : recurrenceType // ignore: cast_nullable_to_non_nullable
              as RecurrenceType,
      intervalLength: null == intervalLength
          ? _value.intervalLength
          : intervalLength // ignore: cast_nullable_to_non_nullable
              as int,
      earliestOccurrence: freezed == earliestOccurrence
          ? _value.earliestOccurrence
          : earliestOccurrence // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      latestOccurrence: freezed == latestOccurrence
          ? _value.latestOccurrence
          : latestOccurrence // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      recurrenceData: freezed == recurrenceData
          ? _value._recurrenceData
          : recurrenceData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
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
class _$RecurrenceImpl implements _Recurrence {
  const _$RecurrenceImpl(
      {required this.id,
      required this.taskId,
      required this.recurrenceType,
      this.intervalLength = 1,
      this.earliestOccurrence,
      this.latestOccurrence,
      final Map<String, dynamic>? recurrenceData,
      this.isActive = true,
      required this.createdAt,
      required this.updatedAt})
      : _recurrenceData = recurrenceData;

  factory _$RecurrenceImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecurrenceImplFromJson(json);

  @override
  final String id;
  @override
  final String taskId;
  @override
  final RecurrenceType recurrenceType;
  @override
  @JsonKey()
  final int intervalLength;
  @override
  final DateTime? earliestOccurrence;
  @override
  final DateTime? latestOccurrence;
  final Map<String, dynamic>? _recurrenceData;
  @override
  Map<String, dynamic>? get recurrenceData {
    final value = _recurrenceData;
    if (value == null) return null;
    if (_recurrenceData is EqualUnmodifiableMapView) return _recurrenceData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

// Additional recurrence configuration
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Recurrence(id: $id, taskId: $taskId, recurrenceType: $recurrenceType, intervalLength: $intervalLength, earliestOccurrence: $earliestOccurrence, latestOccurrence: $latestOccurrence, recurrenceData: $recurrenceData, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecurrenceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.recurrenceType, recurrenceType) ||
                other.recurrenceType == recurrenceType) &&
            (identical(other.intervalLength, intervalLength) ||
                other.intervalLength == intervalLength) &&
            (identical(other.earliestOccurrence, earliestOccurrence) ||
                other.earliestOccurrence == earliestOccurrence) &&
            (identical(other.latestOccurrence, latestOccurrence) ||
                other.latestOccurrence == latestOccurrence) &&
            const DeepCollectionEquality()
                .equals(other._recurrenceData, _recurrenceData) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
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
      taskId,
      recurrenceType,
      intervalLength,
      earliestOccurrence,
      latestOccurrence,
      const DeepCollectionEquality().hash(_recurrenceData),
      isActive,
      createdAt,
      updatedAt);

  /// Create a copy of Recurrence
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecurrenceImplCopyWith<_$RecurrenceImpl> get copyWith =>
      __$$RecurrenceImplCopyWithImpl<_$RecurrenceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecurrenceImplToJson(
      this,
    );
  }
}

abstract class _Recurrence implements Recurrence {
  const factory _Recurrence(
      {required final String id,
      required final String taskId,
      required final RecurrenceType recurrenceType,
      final int intervalLength,
      final DateTime? earliestOccurrence,
      final DateTime? latestOccurrence,
      final Map<String, dynamic>? recurrenceData,
      final bool isActive,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$RecurrenceImpl;

  factory _Recurrence.fromJson(Map<String, dynamic> json) =
      _$RecurrenceImpl.fromJson;

  @override
  String get id;
  @override
  String get taskId;
  @override
  RecurrenceType get recurrenceType;
  @override
  int get intervalLength;
  @override
  DateTime? get earliestOccurrence;
  @override
  DateTime? get latestOccurrence;
  @override
  Map<String, dynamic>?
      get recurrenceData; // Additional recurrence configuration
  @override
  bool get isActive;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of Recurrence
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecurrenceImplCopyWith<_$RecurrenceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TaskAction _$TaskActionFromJson(Map<String, dynamic> json) {
  return _TaskAction.fromJson(json);
}

/// @nodoc
mixin _$TaskAction {
  String get id => throw _privateConstructorUsedError;
  String get taskId => throw _privateConstructorUsedError;
  Duration get actionTimedelta =>
      throw _privateConstructorUsedError; // Time before task to execute action
  String? get description => throw _privateConstructorUsedError;
  String? get actionType =>
      throw _privateConstructorUsedError; // 'reminder', 'notification', 'preparation', etc.
  Map<String, dynamic>? get actionData => throw _privateConstructorUsedError;
  bool get isEnabled => throw _privateConstructorUsedError;
  DateTime? get lastExecuted => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this TaskAction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskActionCopyWith<TaskAction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskActionCopyWith<$Res> {
  factory $TaskActionCopyWith(
          TaskAction value, $Res Function(TaskAction) then) =
      _$TaskActionCopyWithImpl<$Res, TaskAction>;
  @useResult
  $Res call(
      {String id,
      String taskId,
      Duration actionTimedelta,
      String? description,
      String? actionType,
      Map<String, dynamic>? actionData,
      bool isEnabled,
      DateTime? lastExecuted,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$TaskActionCopyWithImpl<$Res, $Val extends TaskAction>
    implements $TaskActionCopyWith<$Res> {
  _$TaskActionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? taskId = null,
    Object? actionTimedelta = null,
    Object? description = freezed,
    Object? actionType = freezed,
    Object? actionData = freezed,
    Object? isEnabled = null,
    Object? lastExecuted = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      taskId: null == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String,
      actionTimedelta: null == actionTimedelta
          ? _value.actionTimedelta
          : actionTimedelta // ignore: cast_nullable_to_non_nullable
              as Duration,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      actionType: freezed == actionType
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as String?,
      actionData: freezed == actionData
          ? _value.actionData
          : actionData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      lastExecuted: freezed == lastExecuted
          ? _value.lastExecuted
          : lastExecuted // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
abstract class _$$TaskActionImplCopyWith<$Res>
    implements $TaskActionCopyWith<$Res> {
  factory _$$TaskActionImplCopyWith(
          _$TaskActionImpl value, $Res Function(_$TaskActionImpl) then) =
      __$$TaskActionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String taskId,
      Duration actionTimedelta,
      String? description,
      String? actionType,
      Map<String, dynamic>? actionData,
      bool isEnabled,
      DateTime? lastExecuted,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$TaskActionImplCopyWithImpl<$Res>
    extends _$TaskActionCopyWithImpl<$Res, _$TaskActionImpl>
    implements _$$TaskActionImplCopyWith<$Res> {
  __$$TaskActionImplCopyWithImpl(
      _$TaskActionImpl _value, $Res Function(_$TaskActionImpl) _then)
      : super(_value, _then);

  /// Create a copy of TaskAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? taskId = null,
    Object? actionTimedelta = null,
    Object? description = freezed,
    Object? actionType = freezed,
    Object? actionData = freezed,
    Object? isEnabled = null,
    Object? lastExecuted = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$TaskActionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      taskId: null == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String,
      actionTimedelta: null == actionTimedelta
          ? _value.actionTimedelta
          : actionTimedelta // ignore: cast_nullable_to_non_nullable
              as Duration,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      actionType: freezed == actionType
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as String?,
      actionData: freezed == actionData
          ? _value._actionData
          : actionData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      lastExecuted: freezed == lastExecuted
          ? _value.lastExecuted
          : lastExecuted // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
class _$TaskActionImpl implements _TaskAction {
  const _$TaskActionImpl(
      {required this.id,
      required this.taskId,
      required this.actionTimedelta,
      this.description,
      this.actionType,
      final Map<String, dynamic>? actionData,
      this.isEnabled = true,
      this.lastExecuted,
      required this.createdAt,
      required this.updatedAt})
      : _actionData = actionData;

  factory _$TaskActionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskActionImplFromJson(json);

  @override
  final String id;
  @override
  final String taskId;
  @override
  final Duration actionTimedelta;
// Time before task to execute action
  @override
  final String? description;
  @override
  final String? actionType;
// 'reminder', 'notification', 'preparation', etc.
  final Map<String, dynamic>? _actionData;
// 'reminder', 'notification', 'preparation', etc.
  @override
  Map<String, dynamic>? get actionData {
    final value = _actionData;
    if (value == null) return null;
    if (_actionData is EqualUnmodifiableMapView) return _actionData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  final bool isEnabled;
  @override
  final DateTime? lastExecuted;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'TaskAction(id: $id, taskId: $taskId, actionTimedelta: $actionTimedelta, description: $description, actionType: $actionType, actionData: $actionData, isEnabled: $isEnabled, lastExecuted: $lastExecuted, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskActionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.actionTimedelta, actionTimedelta) ||
                other.actionTimedelta == actionTimedelta) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.actionType, actionType) ||
                other.actionType == actionType) &&
            const DeepCollectionEquality()
                .equals(other._actionData, _actionData) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled) &&
            (identical(other.lastExecuted, lastExecuted) ||
                other.lastExecuted == lastExecuted) &&
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
      taskId,
      actionTimedelta,
      description,
      actionType,
      const DeepCollectionEquality().hash(_actionData),
      isEnabled,
      lastExecuted,
      createdAt,
      updatedAt);

  /// Create a copy of TaskAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskActionImplCopyWith<_$TaskActionImpl> get copyWith =>
      __$$TaskActionImplCopyWithImpl<_$TaskActionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskActionImplToJson(
      this,
    );
  }
}

abstract class _TaskAction implements TaskAction {
  const factory _TaskAction(
      {required final String id,
      required final String taskId,
      required final Duration actionTimedelta,
      final String? description,
      final String? actionType,
      final Map<String, dynamic>? actionData,
      final bool isEnabled,
      final DateTime? lastExecuted,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$TaskActionImpl;

  factory _TaskAction.fromJson(Map<String, dynamic> json) =
      _$TaskActionImpl.fromJson;

  @override
  String get id;
  @override
  String get taskId;
  @override
  Duration get actionTimedelta; // Time before task to execute action
  @override
  String? get description;
  @override
  String? get actionType; // 'reminder', 'notification', 'preparation', etc.
  @override
  Map<String, dynamic>? get actionData;
  @override
  bool get isEnabled;
  @override
  DateTime? get lastExecuted;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of TaskAction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskActionImplCopyWith<_$TaskActionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TaskReminder _$TaskReminderFromJson(Map<String, dynamic> json) {
  return _TaskReminder.fromJson(json);
}

/// @nodoc
mixin _$TaskReminder {
  String get id => throw _privateConstructorUsedError;
  String get taskId => throw _privateConstructorUsedError;
  Duration get timedelta =>
      throw _privateConstructorUsedError; // Time before task to send reminder
  String get reminderType =>
      throw _privateConstructorUsedError; // 'default', 'email', 'push', 'sms'
  String? get message => throw _privateConstructorUsedError;
  bool get isEnabled => throw _privateConstructorUsedError;
  DateTime? get lastSent => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this TaskReminder to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskReminder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskReminderCopyWith<TaskReminder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskReminderCopyWith<$Res> {
  factory $TaskReminderCopyWith(
          TaskReminder value, $Res Function(TaskReminder) then) =
      _$TaskReminderCopyWithImpl<$Res, TaskReminder>;
  @useResult
  $Res call(
      {String id,
      String taskId,
      Duration timedelta,
      String reminderType,
      String? message,
      bool isEnabled,
      DateTime? lastSent,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$TaskReminderCopyWithImpl<$Res, $Val extends TaskReminder>
    implements $TaskReminderCopyWith<$Res> {
  _$TaskReminderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskReminder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? taskId = null,
    Object? timedelta = null,
    Object? reminderType = null,
    Object? message = freezed,
    Object? isEnabled = null,
    Object? lastSent = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      taskId: null == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String,
      timedelta: null == timedelta
          ? _value.timedelta
          : timedelta // ignore: cast_nullable_to_non_nullable
              as Duration,
      reminderType: null == reminderType
          ? _value.reminderType
          : reminderType // ignore: cast_nullable_to_non_nullable
              as String,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      lastSent: freezed == lastSent
          ? _value.lastSent
          : lastSent // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
abstract class _$$TaskReminderImplCopyWith<$Res>
    implements $TaskReminderCopyWith<$Res> {
  factory _$$TaskReminderImplCopyWith(
          _$TaskReminderImpl value, $Res Function(_$TaskReminderImpl) then) =
      __$$TaskReminderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String taskId,
      Duration timedelta,
      String reminderType,
      String? message,
      bool isEnabled,
      DateTime? lastSent,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$TaskReminderImplCopyWithImpl<$Res>
    extends _$TaskReminderCopyWithImpl<$Res, _$TaskReminderImpl>
    implements _$$TaskReminderImplCopyWith<$Res> {
  __$$TaskReminderImplCopyWithImpl(
      _$TaskReminderImpl _value, $Res Function(_$TaskReminderImpl) _then)
      : super(_value, _then);

  /// Create a copy of TaskReminder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? taskId = null,
    Object? timedelta = null,
    Object? reminderType = null,
    Object? message = freezed,
    Object? isEnabled = null,
    Object? lastSent = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$TaskReminderImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      taskId: null == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String,
      timedelta: null == timedelta
          ? _value.timedelta
          : timedelta // ignore: cast_nullable_to_non_nullable
              as Duration,
      reminderType: null == reminderType
          ? _value.reminderType
          : reminderType // ignore: cast_nullable_to_non_nullable
              as String,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      lastSent: freezed == lastSent
          ? _value.lastSent
          : lastSent // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
class _$TaskReminderImpl implements _TaskReminder {
  const _$TaskReminderImpl(
      {required this.id,
      required this.taskId,
      required this.timedelta,
      this.reminderType = 'default',
      this.message,
      this.isEnabled = true,
      this.lastSent,
      required this.createdAt,
      required this.updatedAt});

  factory _$TaskReminderImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskReminderImplFromJson(json);

  @override
  final String id;
  @override
  final String taskId;
  @override
  final Duration timedelta;
// Time before task to send reminder
  @override
  @JsonKey()
  final String reminderType;
// 'default', 'email', 'push', 'sms'
  @override
  final String? message;
  @override
  @JsonKey()
  final bool isEnabled;
  @override
  final DateTime? lastSent;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'TaskReminder(id: $id, taskId: $taskId, timedelta: $timedelta, reminderType: $reminderType, message: $message, isEnabled: $isEnabled, lastSent: $lastSent, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskReminderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.timedelta, timedelta) ||
                other.timedelta == timedelta) &&
            (identical(other.reminderType, reminderType) ||
                other.reminderType == reminderType) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled) &&
            (identical(other.lastSent, lastSent) ||
                other.lastSent == lastSent) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, taskId, timedelta,
      reminderType, message, isEnabled, lastSent, createdAt, updatedAt);

  /// Create a copy of TaskReminder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskReminderImplCopyWith<_$TaskReminderImpl> get copyWith =>
      __$$TaskReminderImplCopyWithImpl<_$TaskReminderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskReminderImplToJson(
      this,
    );
  }
}

abstract class _TaskReminder implements TaskReminder {
  const factory _TaskReminder(
      {required final String id,
      required final String taskId,
      required final Duration timedelta,
      final String reminderType,
      final String? message,
      final bool isEnabled,
      final DateTime? lastSent,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$TaskReminderImpl;

  factory _TaskReminder.fromJson(Map<String, dynamic> json) =
      _$TaskReminderImpl.fromJson;

  @override
  String get id;
  @override
  String get taskId;
  @override
  Duration get timedelta; // Time before task to send reminder
  @override
  String get reminderType; // 'default', 'email', 'push', 'sms'
  @override
  String? get message;
  @override
  bool get isEnabled;
  @override
  DateTime? get lastSent;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of TaskReminder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskReminderImplCopyWith<_$TaskReminderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TaskEntity _$TaskEntityFromJson(Map<String, dynamic> json) {
  return _TaskEntity.fromJson(json);
}

/// @nodoc
mixin _$TaskEntity {
  String get taskId => throw _privateConstructorUsedError;
  String get entityId => throw _privateConstructorUsedError;
  String? get relationshipType =>
      throw _privateConstructorUsedError; // 'primary', 'secondary', 'related'
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this TaskEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskEntityCopyWith<TaskEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskEntityCopyWith<$Res> {
  factory $TaskEntityCopyWith(
          TaskEntity value, $Res Function(TaskEntity) then) =
      _$TaskEntityCopyWithImpl<$Res, TaskEntity>;
  @useResult
  $Res call(
      {String taskId,
      String entityId,
      String? relationshipType,
      DateTime createdAt});
}

/// @nodoc
class _$TaskEntityCopyWithImpl<$Res, $Val extends TaskEntity>
    implements $TaskEntityCopyWith<$Res> {
  _$TaskEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? taskId = null,
    Object? entityId = null,
    Object? relationshipType = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      taskId: null == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String,
      entityId: null == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String,
      relationshipType: freezed == relationshipType
          ? _value.relationshipType
          : relationshipType // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaskEntityImplCopyWith<$Res>
    implements $TaskEntityCopyWith<$Res> {
  factory _$$TaskEntityImplCopyWith(
          _$TaskEntityImpl value, $Res Function(_$TaskEntityImpl) then) =
      __$$TaskEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String taskId,
      String entityId,
      String? relationshipType,
      DateTime createdAt});
}

/// @nodoc
class __$$TaskEntityImplCopyWithImpl<$Res>
    extends _$TaskEntityCopyWithImpl<$Res, _$TaskEntityImpl>
    implements _$$TaskEntityImplCopyWith<$Res> {
  __$$TaskEntityImplCopyWithImpl(
      _$TaskEntityImpl _value, $Res Function(_$TaskEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of TaskEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? taskId = null,
    Object? entityId = null,
    Object? relationshipType = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$TaskEntityImpl(
      taskId: null == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String,
      entityId: null == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String,
      relationshipType: freezed == relationshipType
          ? _value.relationshipType
          : relationshipType // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskEntityImpl implements _TaskEntity {
  const _$TaskEntityImpl(
      {required this.taskId,
      required this.entityId,
      this.relationshipType,
      required this.createdAt});

  factory _$TaskEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskEntityImplFromJson(json);

  @override
  final String taskId;
  @override
  final String entityId;
  @override
  final String? relationshipType;
// 'primary', 'secondary', 'related'
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'TaskEntity(taskId: $taskId, entityId: $entityId, relationshipType: $relationshipType, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskEntityImpl &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.relationshipType, relationshipType) ||
                other.relationshipType == relationshipType) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, taskId, entityId, relationshipType, createdAt);

  /// Create a copy of TaskEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskEntityImplCopyWith<_$TaskEntityImpl> get copyWith =>
      __$$TaskEntityImplCopyWithImpl<_$TaskEntityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskEntityImplToJson(
      this,
    );
  }
}

abstract class _TaskEntity implements TaskEntity {
  const factory _TaskEntity(
      {required final String taskId,
      required final String entityId,
      final String? relationshipType,
      required final DateTime createdAt}) = _$TaskEntityImpl;

  factory _TaskEntity.fromJson(Map<String, dynamic> json) =
      _$TaskEntityImpl.fromJson;

  @override
  String get taskId;
  @override
  String get entityId;
  @override
  String? get relationshipType; // 'primary', 'secondary', 'related'
  @override
  DateTime get createdAt;

  /// Create a copy of TaskEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskEntityImplCopyWith<_$TaskEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AdvancedTask _$AdvancedTaskFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'flexible':
      return AdvancedFlexibleTask.fromJson(json);
    case 'fixed':
      return AdvancedFixedTask.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'AdvancedTask',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$AdvancedTask {
  Object get task => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(FlexibleTask task) flexible,
    required TResult Function(FixedTask task) fixed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(FlexibleTask task)? flexible,
    TResult? Function(FixedTask task)? fixed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(FlexibleTask task)? flexible,
    TResult Function(FixedTask task)? fixed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AdvancedFlexibleTask value) flexible,
    required TResult Function(AdvancedFixedTask value) fixed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AdvancedFlexibleTask value)? flexible,
    TResult? Function(AdvancedFixedTask value)? fixed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AdvancedFlexibleTask value)? flexible,
    TResult Function(AdvancedFixedTask value)? fixed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this AdvancedTask to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdvancedTaskCopyWith<$Res> {
  factory $AdvancedTaskCopyWith(
          AdvancedTask value, $Res Function(AdvancedTask) then) =
      _$AdvancedTaskCopyWithImpl<$Res, AdvancedTask>;
}

/// @nodoc
class _$AdvancedTaskCopyWithImpl<$Res, $Val extends AdvancedTask>
    implements $AdvancedTaskCopyWith<$Res> {
  _$AdvancedTaskCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AdvancedTask
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$AdvancedFlexibleTaskImplCopyWith<$Res> {
  factory _$$AdvancedFlexibleTaskImplCopyWith(_$AdvancedFlexibleTaskImpl value,
          $Res Function(_$AdvancedFlexibleTaskImpl) then) =
      __$$AdvancedFlexibleTaskImplCopyWithImpl<$Res>;
  @useResult
  $Res call({FlexibleTask task});

  $FlexibleTaskCopyWith<$Res> get task;
}

/// @nodoc
class __$$AdvancedFlexibleTaskImplCopyWithImpl<$Res>
    extends _$AdvancedTaskCopyWithImpl<$Res, _$AdvancedFlexibleTaskImpl>
    implements _$$AdvancedFlexibleTaskImplCopyWith<$Res> {
  __$$AdvancedFlexibleTaskImplCopyWithImpl(_$AdvancedFlexibleTaskImpl _value,
      $Res Function(_$AdvancedFlexibleTaskImpl) _then)
      : super(_value, _then);

  /// Create a copy of AdvancedTask
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? task = null,
  }) {
    return _then(_$AdvancedFlexibleTaskImpl(
      null == task
          ? _value.task
          : task // ignore: cast_nullable_to_non_nullable
              as FlexibleTask,
    ));
  }

  /// Create a copy of AdvancedTask
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FlexibleTaskCopyWith<$Res> get task {
    return $FlexibleTaskCopyWith<$Res>(_value.task, (value) {
      return _then(_value.copyWith(task: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$AdvancedFlexibleTaskImpl implements AdvancedFlexibleTask {
  const _$AdvancedFlexibleTaskImpl(this.task, {final String? $type})
      : $type = $type ?? 'flexible';

  factory _$AdvancedFlexibleTaskImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdvancedFlexibleTaskImplFromJson(json);

  @override
  final FlexibleTask task;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'AdvancedTask.flexible(task: $task)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdvancedFlexibleTaskImpl &&
            (identical(other.task, task) || other.task == task));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, task);

  /// Create a copy of AdvancedTask
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AdvancedFlexibleTaskImplCopyWith<_$AdvancedFlexibleTaskImpl>
      get copyWith =>
          __$$AdvancedFlexibleTaskImplCopyWithImpl<_$AdvancedFlexibleTaskImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(FlexibleTask task) flexible,
    required TResult Function(FixedTask task) fixed,
  }) {
    return flexible(task);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(FlexibleTask task)? flexible,
    TResult? Function(FixedTask task)? fixed,
  }) {
    return flexible?.call(task);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(FlexibleTask task)? flexible,
    TResult Function(FixedTask task)? fixed,
    required TResult orElse(),
  }) {
    if (flexible != null) {
      return flexible(task);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AdvancedFlexibleTask value) flexible,
    required TResult Function(AdvancedFixedTask value) fixed,
  }) {
    return flexible(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AdvancedFlexibleTask value)? flexible,
    TResult? Function(AdvancedFixedTask value)? fixed,
  }) {
    return flexible?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AdvancedFlexibleTask value)? flexible,
    TResult Function(AdvancedFixedTask value)? fixed,
    required TResult orElse(),
  }) {
    if (flexible != null) {
      return flexible(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AdvancedFlexibleTaskImplToJson(
      this,
    );
  }
}

abstract class AdvancedFlexibleTask implements AdvancedTask {
  const factory AdvancedFlexibleTask(final FlexibleTask task) =
      _$AdvancedFlexibleTaskImpl;

  factory AdvancedFlexibleTask.fromJson(Map<String, dynamic> json) =
      _$AdvancedFlexibleTaskImpl.fromJson;

  @override
  FlexibleTask get task;

  /// Create a copy of AdvancedTask
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AdvancedFlexibleTaskImplCopyWith<_$AdvancedFlexibleTaskImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AdvancedFixedTaskImplCopyWith<$Res> {
  factory _$$AdvancedFixedTaskImplCopyWith(_$AdvancedFixedTaskImpl value,
          $Res Function(_$AdvancedFixedTaskImpl) then) =
      __$$AdvancedFixedTaskImplCopyWithImpl<$Res>;
  @useResult
  $Res call({FixedTask task});

  $FixedTaskCopyWith<$Res> get task;
}

/// @nodoc
class __$$AdvancedFixedTaskImplCopyWithImpl<$Res>
    extends _$AdvancedTaskCopyWithImpl<$Res, _$AdvancedFixedTaskImpl>
    implements _$$AdvancedFixedTaskImplCopyWith<$Res> {
  __$$AdvancedFixedTaskImplCopyWithImpl(_$AdvancedFixedTaskImpl _value,
      $Res Function(_$AdvancedFixedTaskImpl) _then)
      : super(_value, _then);

  /// Create a copy of AdvancedTask
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? task = null,
  }) {
    return _then(_$AdvancedFixedTaskImpl(
      null == task
          ? _value.task
          : task // ignore: cast_nullable_to_non_nullable
              as FixedTask,
    ));
  }

  /// Create a copy of AdvancedTask
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FixedTaskCopyWith<$Res> get task {
    return $FixedTaskCopyWith<$Res>(_value.task, (value) {
      return _then(_value.copyWith(task: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$AdvancedFixedTaskImpl implements AdvancedFixedTask {
  const _$AdvancedFixedTaskImpl(this.task, {final String? $type})
      : $type = $type ?? 'fixed';

  factory _$AdvancedFixedTaskImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdvancedFixedTaskImplFromJson(json);

  @override
  final FixedTask task;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'AdvancedTask.fixed(task: $task)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdvancedFixedTaskImpl &&
            (identical(other.task, task) || other.task == task));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, task);

  /// Create a copy of AdvancedTask
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AdvancedFixedTaskImplCopyWith<_$AdvancedFixedTaskImpl> get copyWith =>
      __$$AdvancedFixedTaskImplCopyWithImpl<_$AdvancedFixedTaskImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(FlexibleTask task) flexible,
    required TResult Function(FixedTask task) fixed,
  }) {
    return fixed(task);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(FlexibleTask task)? flexible,
    TResult? Function(FixedTask task)? fixed,
  }) {
    return fixed?.call(task);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(FlexibleTask task)? flexible,
    TResult Function(FixedTask task)? fixed,
    required TResult orElse(),
  }) {
    if (fixed != null) {
      return fixed(task);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AdvancedFlexibleTask value) flexible,
    required TResult Function(AdvancedFixedTask value) fixed,
  }) {
    return fixed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AdvancedFlexibleTask value)? flexible,
    TResult? Function(AdvancedFixedTask value)? fixed,
  }) {
    return fixed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AdvancedFlexibleTask value)? flexible,
    TResult Function(AdvancedFixedTask value)? fixed,
    required TResult orElse(),
  }) {
    if (fixed != null) {
      return fixed(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AdvancedFixedTaskImplToJson(
      this,
    );
  }
}

abstract class AdvancedFixedTask implements AdvancedTask {
  const factory AdvancedFixedTask(final FixedTask task) =
      _$AdvancedFixedTaskImpl;

  factory AdvancedFixedTask.fromJson(Map<String, dynamic> json) =
      _$AdvancedFixedTaskImpl.fromJson;

  @override
  FixedTask get task;

  /// Create a copy of AdvancedTask
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AdvancedFixedTaskImplCopyWith<_$AdvancedFixedTaskImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
