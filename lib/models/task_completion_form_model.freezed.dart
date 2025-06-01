// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_completion_form_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TaskCompletionFormModel _$TaskCompletionFormModelFromJson(
    Map<String, dynamic> json) {
  return _TaskCompletionFormModel.fromJson(json);
}

/// @nodoc
mixin _$TaskCompletionFormModel {
  /// Unique identifier for the completion form
  String get id => throw _privateConstructorUsedError;

  /// ID of the task this completion form is for
  String get taskId => throw _privateConstructorUsedError;

  /// When the completion was recorded
  DateTime get completionDateTime => throw _privateConstructorUsedError;

  /// Recurrence index for recurring tasks (null for non-recurring)
  int? get recurrenceIndex => throw _privateConstructorUsedError;

  /// Whether to ignore this completion (for rescheduling)
  bool get ignore => throw _privateConstructorUsedError;

  /// Whether the task is fully complete
  bool get complete => throw _privateConstructorUsedError;

  /// Whether this is a partial completion
  bool get partial => throw _privateConstructorUsedError;

  /// User who completed the task
  String get completedByUserId => throw _privateConstructorUsedError;

  /// Optional notes about the completion
  String? get notes => throw _privateConstructorUsedError;

  /// Optional rescheduled date (if task was rescheduled instead of completed)
  DateTime? get rescheduledDate => throw _privateConstructorUsedError;

  /// Type of completion (complete, reschedule, partial, etc.)
  TaskCompletionType get completionType => throw _privateConstructorUsedError;

  /// Additional completion data (for specialized completion forms)
  Map<String, dynamic>? get additionalData =>
      throw _privateConstructorUsedError;

  /// Creation timestamp
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Last update timestamp
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this TaskCompletionFormModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskCompletionFormModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskCompletionFormModelCopyWith<TaskCompletionFormModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskCompletionFormModelCopyWith<$Res> {
  factory $TaskCompletionFormModelCopyWith(TaskCompletionFormModel value,
          $Res Function(TaskCompletionFormModel) then) =
      _$TaskCompletionFormModelCopyWithImpl<$Res, TaskCompletionFormModel>;
  @useResult
  $Res call(
      {String id,
      String taskId,
      DateTime completionDateTime,
      int? recurrenceIndex,
      bool ignore,
      bool complete,
      bool partial,
      String completedByUserId,
      String? notes,
      DateTime? rescheduledDate,
      TaskCompletionType completionType,
      Map<String, dynamic>? additionalData,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$TaskCompletionFormModelCopyWithImpl<$Res,
        $Val extends TaskCompletionFormModel>
    implements $TaskCompletionFormModelCopyWith<$Res> {
  _$TaskCompletionFormModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskCompletionFormModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? taskId = null,
    Object? completionDateTime = null,
    Object? recurrenceIndex = freezed,
    Object? ignore = null,
    Object? complete = null,
    Object? partial = null,
    Object? completedByUserId = null,
    Object? notes = freezed,
    Object? rescheduledDate = freezed,
    Object? completionType = null,
    Object? additionalData = freezed,
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
      completionDateTime: null == completionDateTime
          ? _value.completionDateTime
          : completionDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      recurrenceIndex: freezed == recurrenceIndex
          ? _value.recurrenceIndex
          : recurrenceIndex // ignore: cast_nullable_to_non_nullable
              as int?,
      ignore: null == ignore
          ? _value.ignore
          : ignore // ignore: cast_nullable_to_non_nullable
              as bool,
      complete: null == complete
          ? _value.complete
          : complete // ignore: cast_nullable_to_non_nullable
              as bool,
      partial: null == partial
          ? _value.partial
          : partial // ignore: cast_nullable_to_non_nullable
              as bool,
      completedByUserId: null == completedByUserId
          ? _value.completedByUserId
          : completedByUserId // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      rescheduledDate: freezed == rescheduledDate
          ? _value.rescheduledDate
          : rescheduledDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completionType: null == completionType
          ? _value.completionType
          : completionType // ignore: cast_nullable_to_non_nullable
              as TaskCompletionType,
      additionalData: freezed == additionalData
          ? _value.additionalData
          : additionalData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
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
abstract class _$$TaskCompletionFormModelImplCopyWith<$Res>
    implements $TaskCompletionFormModelCopyWith<$Res> {
  factory _$$TaskCompletionFormModelImplCopyWith(
          _$TaskCompletionFormModelImpl value,
          $Res Function(_$TaskCompletionFormModelImpl) then) =
      __$$TaskCompletionFormModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String taskId,
      DateTime completionDateTime,
      int? recurrenceIndex,
      bool ignore,
      bool complete,
      bool partial,
      String completedByUserId,
      String? notes,
      DateTime? rescheduledDate,
      TaskCompletionType completionType,
      Map<String, dynamic>? additionalData,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$TaskCompletionFormModelImplCopyWithImpl<$Res>
    extends _$TaskCompletionFormModelCopyWithImpl<$Res,
        _$TaskCompletionFormModelImpl>
    implements _$$TaskCompletionFormModelImplCopyWith<$Res> {
  __$$TaskCompletionFormModelImplCopyWithImpl(
      _$TaskCompletionFormModelImpl _value,
      $Res Function(_$TaskCompletionFormModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of TaskCompletionFormModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? taskId = null,
    Object? completionDateTime = null,
    Object? recurrenceIndex = freezed,
    Object? ignore = null,
    Object? complete = null,
    Object? partial = null,
    Object? completedByUserId = null,
    Object? notes = freezed,
    Object? rescheduledDate = freezed,
    Object? completionType = null,
    Object? additionalData = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$TaskCompletionFormModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      taskId: null == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String,
      completionDateTime: null == completionDateTime
          ? _value.completionDateTime
          : completionDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      recurrenceIndex: freezed == recurrenceIndex
          ? _value.recurrenceIndex
          : recurrenceIndex // ignore: cast_nullable_to_non_nullable
              as int?,
      ignore: null == ignore
          ? _value.ignore
          : ignore // ignore: cast_nullable_to_non_nullable
              as bool,
      complete: null == complete
          ? _value.complete
          : complete // ignore: cast_nullable_to_non_nullable
              as bool,
      partial: null == partial
          ? _value.partial
          : partial // ignore: cast_nullable_to_non_nullable
              as bool,
      completedByUserId: null == completedByUserId
          ? _value.completedByUserId
          : completedByUserId // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      rescheduledDate: freezed == rescheduledDate
          ? _value.rescheduledDate
          : rescheduledDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completionType: null == completionType
          ? _value.completionType
          : completionType // ignore: cast_nullable_to_non_nullable
              as TaskCompletionType,
      additionalData: freezed == additionalData
          ? _value._additionalData
          : additionalData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
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
class _$TaskCompletionFormModelImpl implements _TaskCompletionFormModel {
  const _$TaskCompletionFormModelImpl(
      {required this.id,
      required this.taskId,
      required this.completionDateTime,
      this.recurrenceIndex,
      this.ignore = false,
      this.complete = true,
      this.partial = false,
      required this.completedByUserId,
      this.notes,
      this.rescheduledDate,
      this.completionType = TaskCompletionType.complete,
      final Map<String, dynamic>? additionalData,
      required this.createdAt,
      required this.updatedAt})
      : _additionalData = additionalData;

  factory _$TaskCompletionFormModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskCompletionFormModelImplFromJson(json);

  /// Unique identifier for the completion form
  @override
  final String id;

  /// ID of the task this completion form is for
  @override
  final String taskId;

  /// When the completion was recorded
  @override
  final DateTime completionDateTime;

  /// Recurrence index for recurring tasks (null for non-recurring)
  @override
  final int? recurrenceIndex;

  /// Whether to ignore this completion (for rescheduling)
  @override
  @JsonKey()
  final bool ignore;

  /// Whether the task is fully complete
  @override
  @JsonKey()
  final bool complete;

  /// Whether this is a partial completion
  @override
  @JsonKey()
  final bool partial;

  /// User who completed the task
  @override
  final String completedByUserId;

  /// Optional notes about the completion
  @override
  final String? notes;

  /// Optional rescheduled date (if task was rescheduled instead of completed)
  @override
  final DateTime? rescheduledDate;

  /// Type of completion (complete, reschedule, partial, etc.)
  @override
  @JsonKey()
  final TaskCompletionType completionType;

  /// Additional completion data (for specialized completion forms)
  final Map<String, dynamic>? _additionalData;

  /// Additional completion data (for specialized completion forms)
  @override
  Map<String, dynamic>? get additionalData {
    final value = _additionalData;
    if (value == null) return null;
    if (_additionalData is EqualUnmodifiableMapView) return _additionalData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Creation timestamp
  @override
  final DateTime createdAt;

  /// Last update timestamp
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'TaskCompletionFormModel(id: $id, taskId: $taskId, completionDateTime: $completionDateTime, recurrenceIndex: $recurrenceIndex, ignore: $ignore, complete: $complete, partial: $partial, completedByUserId: $completedByUserId, notes: $notes, rescheduledDate: $rescheduledDate, completionType: $completionType, additionalData: $additionalData, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskCompletionFormModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.completionDateTime, completionDateTime) ||
                other.completionDateTime == completionDateTime) &&
            (identical(other.recurrenceIndex, recurrenceIndex) ||
                other.recurrenceIndex == recurrenceIndex) &&
            (identical(other.ignore, ignore) || other.ignore == ignore) &&
            (identical(other.complete, complete) ||
                other.complete == complete) &&
            (identical(other.partial, partial) || other.partial == partial) &&
            (identical(other.completedByUserId, completedByUserId) ||
                other.completedByUserId == completedByUserId) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.rescheduledDate, rescheduledDate) ||
                other.rescheduledDate == rescheduledDate) &&
            (identical(other.completionType, completionType) ||
                other.completionType == completionType) &&
            const DeepCollectionEquality()
                .equals(other._additionalData, _additionalData) &&
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
      completionDateTime,
      recurrenceIndex,
      ignore,
      complete,
      partial,
      completedByUserId,
      notes,
      rescheduledDate,
      completionType,
      const DeepCollectionEquality().hash(_additionalData),
      createdAt,
      updatedAt);

  /// Create a copy of TaskCompletionFormModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskCompletionFormModelImplCopyWith<_$TaskCompletionFormModelImpl>
      get copyWith => __$$TaskCompletionFormModelImplCopyWithImpl<
          _$TaskCompletionFormModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskCompletionFormModelImplToJson(
      this,
    );
  }
}

abstract class _TaskCompletionFormModel implements TaskCompletionFormModel {
  const factory _TaskCompletionFormModel(
      {required final String id,
      required final String taskId,
      required final DateTime completionDateTime,
      final int? recurrenceIndex,
      final bool ignore,
      final bool complete,
      final bool partial,
      required final String completedByUserId,
      final String? notes,
      final DateTime? rescheduledDate,
      final TaskCompletionType completionType,
      final Map<String, dynamic>? additionalData,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$TaskCompletionFormModelImpl;

  factory _TaskCompletionFormModel.fromJson(Map<String, dynamic> json) =
      _$TaskCompletionFormModelImpl.fromJson;

  /// Unique identifier for the completion form
  @override
  String get id;

  /// ID of the task this completion form is for
  @override
  String get taskId;

  /// When the completion was recorded
  @override
  DateTime get completionDateTime;

  /// Recurrence index for recurring tasks (null for non-recurring)
  @override
  int? get recurrenceIndex;

  /// Whether to ignore this completion (for rescheduling)
  @override
  bool get ignore;

  /// Whether the task is fully complete
  @override
  bool get complete;

  /// Whether this is a partial completion
  @override
  bool get partial;

  /// User who completed the task
  @override
  String get completedByUserId;

  /// Optional notes about the completion
  @override
  String? get notes;

  /// Optional rescheduled date (if task was rescheduled instead of completed)
  @override
  DateTime? get rescheduledDate;

  /// Type of completion (complete, reschedule, partial, etc.)
  @override
  TaskCompletionType get completionType;

  /// Additional completion data (for specialized completion forms)
  @override
  Map<String, dynamic>? get additionalData;

  /// Creation timestamp
  @override
  DateTime get createdAt;

  /// Last update timestamp
  @override
  DateTime get updatedAt;

  /// Create a copy of TaskCompletionFormModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskCompletionFormModelImplCopyWith<_$TaskCompletionFormModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

TaskRescheduleModel _$TaskRescheduleModelFromJson(Map<String, dynamic> json) {
  return _TaskRescheduleModel.fromJson(json);
}

/// @nodoc
mixin _$TaskRescheduleModel {
  /// Original due date
  DateTime get originalDueDate => throw _privateConstructorUsedError;

  /// New due date
  DateTime get newDueDate => throw _privateConstructorUsedError;

  /// Reason for rescheduling
  String? get reason => throw _privateConstructorUsedError;

  /// Whether to reschedule future recurrences
  bool get rescheduleRecurring => throw _privateConstructorUsedError;

  /// Type of reschedule (specific occurrence vs entire task)
  RescheduleType get rescheduleType => throw _privateConstructorUsedError;

  /// Serializes this TaskRescheduleModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskRescheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskRescheduleModelCopyWith<TaskRescheduleModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskRescheduleModelCopyWith<$Res> {
  factory $TaskRescheduleModelCopyWith(
          TaskRescheduleModel value, $Res Function(TaskRescheduleModel) then) =
      _$TaskRescheduleModelCopyWithImpl<$Res, TaskRescheduleModel>;
  @useResult
  $Res call(
      {DateTime originalDueDate,
      DateTime newDueDate,
      String? reason,
      bool rescheduleRecurring,
      RescheduleType rescheduleType});
}

/// @nodoc
class _$TaskRescheduleModelCopyWithImpl<$Res, $Val extends TaskRescheduleModel>
    implements $TaskRescheduleModelCopyWith<$Res> {
  _$TaskRescheduleModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskRescheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? originalDueDate = null,
    Object? newDueDate = null,
    Object? reason = freezed,
    Object? rescheduleRecurring = null,
    Object? rescheduleType = null,
  }) {
    return _then(_value.copyWith(
      originalDueDate: null == originalDueDate
          ? _value.originalDueDate
          : originalDueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      newDueDate: null == newDueDate
          ? _value.newDueDate
          : newDueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      rescheduleRecurring: null == rescheduleRecurring
          ? _value.rescheduleRecurring
          : rescheduleRecurring // ignore: cast_nullable_to_non_nullable
              as bool,
      rescheduleType: null == rescheduleType
          ? _value.rescheduleType
          : rescheduleType // ignore: cast_nullable_to_non_nullable
              as RescheduleType,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaskRescheduleModelImplCopyWith<$Res>
    implements $TaskRescheduleModelCopyWith<$Res> {
  factory _$$TaskRescheduleModelImplCopyWith(_$TaskRescheduleModelImpl value,
          $Res Function(_$TaskRescheduleModelImpl) then) =
      __$$TaskRescheduleModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime originalDueDate,
      DateTime newDueDate,
      String? reason,
      bool rescheduleRecurring,
      RescheduleType rescheduleType});
}

/// @nodoc
class __$$TaskRescheduleModelImplCopyWithImpl<$Res>
    extends _$TaskRescheduleModelCopyWithImpl<$Res, _$TaskRescheduleModelImpl>
    implements _$$TaskRescheduleModelImplCopyWith<$Res> {
  __$$TaskRescheduleModelImplCopyWithImpl(_$TaskRescheduleModelImpl _value,
      $Res Function(_$TaskRescheduleModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of TaskRescheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? originalDueDate = null,
    Object? newDueDate = null,
    Object? reason = freezed,
    Object? rescheduleRecurring = null,
    Object? rescheduleType = null,
  }) {
    return _then(_$TaskRescheduleModelImpl(
      originalDueDate: null == originalDueDate
          ? _value.originalDueDate
          : originalDueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      newDueDate: null == newDueDate
          ? _value.newDueDate
          : newDueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      rescheduleRecurring: null == rescheduleRecurring
          ? _value.rescheduleRecurring
          : rescheduleRecurring // ignore: cast_nullable_to_non_nullable
              as bool,
      rescheduleType: null == rescheduleType
          ? _value.rescheduleType
          : rescheduleType // ignore: cast_nullable_to_non_nullable
              as RescheduleType,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskRescheduleModelImpl implements _TaskRescheduleModel {
  const _$TaskRescheduleModelImpl(
      {required this.originalDueDate,
      required this.newDueDate,
      this.reason,
      this.rescheduleRecurring = false,
      this.rescheduleType = RescheduleType.singleOccurrence});

  factory _$TaskRescheduleModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskRescheduleModelImplFromJson(json);

  /// Original due date
  @override
  final DateTime originalDueDate;

  /// New due date
  @override
  final DateTime newDueDate;

  /// Reason for rescheduling
  @override
  final String? reason;

  /// Whether to reschedule future recurrences
  @override
  @JsonKey()
  final bool rescheduleRecurring;

  /// Type of reschedule (specific occurrence vs entire task)
  @override
  @JsonKey()
  final RescheduleType rescheduleType;

  @override
  String toString() {
    return 'TaskRescheduleModel(originalDueDate: $originalDueDate, newDueDate: $newDueDate, reason: $reason, rescheduleRecurring: $rescheduleRecurring, rescheduleType: $rescheduleType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskRescheduleModelImpl &&
            (identical(other.originalDueDate, originalDueDate) ||
                other.originalDueDate == originalDueDate) &&
            (identical(other.newDueDate, newDueDate) ||
                other.newDueDate == newDueDate) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.rescheduleRecurring, rescheduleRecurring) ||
                other.rescheduleRecurring == rescheduleRecurring) &&
            (identical(other.rescheduleType, rescheduleType) ||
                other.rescheduleType == rescheduleType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, originalDueDate, newDueDate,
      reason, rescheduleRecurring, rescheduleType);

  /// Create a copy of TaskRescheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskRescheduleModelImplCopyWith<_$TaskRescheduleModelImpl> get copyWith =>
      __$$TaskRescheduleModelImplCopyWithImpl<_$TaskRescheduleModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskRescheduleModelImplToJson(
      this,
    );
  }
}

abstract class _TaskRescheduleModel implements TaskRescheduleModel {
  const factory _TaskRescheduleModel(
      {required final DateTime originalDueDate,
      required final DateTime newDueDate,
      final String? reason,
      final bool rescheduleRecurring,
      final RescheduleType rescheduleType}) = _$TaskRescheduleModelImpl;

  factory _TaskRescheduleModel.fromJson(Map<String, dynamic> json) =
      _$TaskRescheduleModelImpl.fromJson;

  /// Original due date
  @override
  DateTime get originalDueDate;

  /// New due date
  @override
  DateTime get newDueDate;

  /// Reason for rescheduling
  @override
  String? get reason;

  /// Whether to reschedule future recurrences
  @override
  bool get rescheduleRecurring;

  /// Type of reschedule (specific occurrence vs entire task)
  @override
  RescheduleType get rescheduleType;

  /// Create a copy of TaskRescheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskRescheduleModelImplCopyWith<_$TaskRescheduleModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
