// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timeblock_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TimeblockModel _$TimeblockModelFromJson(Map<String, dynamic> json) {
  return _TimeblockModel.fromJson(json);
}

/// @nodoc
mixin _$TimeblockModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  int get dayOfWeek =>
      throw _privateConstructorUsedError; // 1 for Monday, 7 for Sunday
  String get startTime => throw _privateConstructorUsedError; // HH:mm:ss format
  String get endTime => throw _privateConstructorUsedError; // HH:mm:ss format
  String? get color =>
      throw _privateConstructorUsedError; // Hex color code e.g., #RRGGBB
  String? get description => throw _privateConstructorUsedError;

  /// Activity type for categorization (work, exercise, personal, etc.)
  String? get activityType => throw _privateConstructorUsedError;

  /// ID of the routine this timeblock is linked to (if applicable)
  String? get linkedRoutineId => throw _privateConstructorUsedError;

  /// ID of the task this timeblock is linked to (if applicable)
  String? get linkedTaskId => throw _privateConstructorUsedError;

  /// Whether this timeblock should sync with external calendar
  bool get syncWithCalendar => throw _privateConstructorUsedError;

  /// External calendar event ID (for bidirectional sync)
  String? get externalCalendarEventId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this TimeblockModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TimeblockModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimeblockModelCopyWith<TimeblockModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimeblockModelCopyWith<$Res> {
  factory $TimeblockModelCopyWith(
          TimeblockModel value, $Res Function(TimeblockModel) then) =
      _$TimeblockModelCopyWithImpl<$Res, TimeblockModel>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String? title,
      int dayOfWeek,
      String startTime,
      String endTime,
      String? color,
      String? description,
      String? activityType,
      String? linkedRoutineId,
      String? linkedTaskId,
      bool syncWithCalendar,
      String? externalCalendarEventId,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$TimeblockModelCopyWithImpl<$Res, $Val extends TimeblockModel>
    implements $TimeblockModelCopyWith<$Res> {
  _$TimeblockModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimeblockModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = freezed,
    Object? dayOfWeek = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? color = freezed,
    Object? description = freezed,
    Object? activityType = freezed,
    Object? linkedRoutineId = freezed,
    Object? linkedTaskId = freezed,
    Object? syncWithCalendar = null,
    Object? externalCalendarEventId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      dayOfWeek: null == dayOfWeek
          ? _value.dayOfWeek
          : dayOfWeek // ignore: cast_nullable_to_non_nullable
              as int,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      activityType: freezed == activityType
          ? _value.activityType
          : activityType // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedRoutineId: freezed == linkedRoutineId
          ? _value.linkedRoutineId
          : linkedRoutineId // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedTaskId: freezed == linkedTaskId
          ? _value.linkedTaskId
          : linkedTaskId // ignore: cast_nullable_to_non_nullable
              as String?,
      syncWithCalendar: null == syncWithCalendar
          ? _value.syncWithCalendar
          : syncWithCalendar // ignore: cast_nullable_to_non_nullable
              as bool,
      externalCalendarEventId: freezed == externalCalendarEventId
          ? _value.externalCalendarEventId
          : externalCalendarEventId // ignore: cast_nullable_to_non_nullable
              as String?,
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
abstract class _$$TimeblockModelImplCopyWith<$Res>
    implements $TimeblockModelCopyWith<$Res> {
  factory _$$TimeblockModelImplCopyWith(_$TimeblockModelImpl value,
          $Res Function(_$TimeblockModelImpl) then) =
      __$$TimeblockModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String? title,
      int dayOfWeek,
      String startTime,
      String endTime,
      String? color,
      String? description,
      String? activityType,
      String? linkedRoutineId,
      String? linkedTaskId,
      bool syncWithCalendar,
      String? externalCalendarEventId,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$TimeblockModelImplCopyWithImpl<$Res>
    extends _$TimeblockModelCopyWithImpl<$Res, _$TimeblockModelImpl>
    implements _$$TimeblockModelImplCopyWith<$Res> {
  __$$TimeblockModelImplCopyWithImpl(
      _$TimeblockModelImpl _value, $Res Function(_$TimeblockModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of TimeblockModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = freezed,
    Object? dayOfWeek = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? color = freezed,
    Object? description = freezed,
    Object? activityType = freezed,
    Object? linkedRoutineId = freezed,
    Object? linkedTaskId = freezed,
    Object? syncWithCalendar = null,
    Object? externalCalendarEventId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$TimeblockModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      dayOfWeek: null == dayOfWeek
          ? _value.dayOfWeek
          : dayOfWeek // ignore: cast_nullable_to_non_nullable
              as int,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      activityType: freezed == activityType
          ? _value.activityType
          : activityType // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedRoutineId: freezed == linkedRoutineId
          ? _value.linkedRoutineId
          : linkedRoutineId // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedTaskId: freezed == linkedTaskId
          ? _value.linkedTaskId
          : linkedTaskId // ignore: cast_nullable_to_non_nullable
              as String?,
      syncWithCalendar: null == syncWithCalendar
          ? _value.syncWithCalendar
          : syncWithCalendar // ignore: cast_nullable_to_non_nullable
              as bool,
      externalCalendarEventId: freezed == externalCalendarEventId
          ? _value.externalCalendarEventId
          : externalCalendarEventId // ignore: cast_nullable_to_non_nullable
              as String?,
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
class _$TimeblockModelImpl implements _TimeblockModel {
  const _$TimeblockModelImpl(
      {required this.id,
      required this.userId,
      this.title,
      required this.dayOfWeek,
      required this.startTime,
      required this.endTime,
      this.color,
      this.description,
      this.activityType,
      this.linkedRoutineId,
      this.linkedTaskId,
      this.syncWithCalendar = false,
      this.externalCalendarEventId,
      required this.createdAt,
      required this.updatedAt});

  factory _$TimeblockModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimeblockModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String? title;
  @override
  final int dayOfWeek;
// 1 for Monday, 7 for Sunday
  @override
  final String startTime;
// HH:mm:ss format
  @override
  final String endTime;
// HH:mm:ss format
  @override
  final String? color;
// Hex color code e.g., #RRGGBB
  @override
  final String? description;

  /// Activity type for categorization (work, exercise, personal, etc.)
  @override
  final String? activityType;

  /// ID of the routine this timeblock is linked to (if applicable)
  @override
  final String? linkedRoutineId;

  /// ID of the task this timeblock is linked to (if applicable)
  @override
  final String? linkedTaskId;

  /// Whether this timeblock should sync with external calendar
  @override
  @JsonKey()
  final bool syncWithCalendar;

  /// External calendar event ID (for bidirectional sync)
  @override
  final String? externalCalendarEventId;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'TimeblockModel(id: $id, userId: $userId, title: $title, dayOfWeek: $dayOfWeek, startTime: $startTime, endTime: $endTime, color: $color, description: $description, activityType: $activityType, linkedRoutineId: $linkedRoutineId, linkedTaskId: $linkedTaskId, syncWithCalendar: $syncWithCalendar, externalCalendarEventId: $externalCalendarEventId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimeblockModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.dayOfWeek, dayOfWeek) ||
                other.dayOfWeek == dayOfWeek) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.activityType, activityType) ||
                other.activityType == activityType) &&
            (identical(other.linkedRoutineId, linkedRoutineId) ||
                other.linkedRoutineId == linkedRoutineId) &&
            (identical(other.linkedTaskId, linkedTaskId) ||
                other.linkedTaskId == linkedTaskId) &&
            (identical(other.syncWithCalendar, syncWithCalendar) ||
                other.syncWithCalendar == syncWithCalendar) &&
            (identical(
                    other.externalCalendarEventId, externalCalendarEventId) ||
                other.externalCalendarEventId == externalCalendarEventId) &&
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
      userId,
      title,
      dayOfWeek,
      startTime,
      endTime,
      color,
      description,
      activityType,
      linkedRoutineId,
      linkedTaskId,
      syncWithCalendar,
      externalCalendarEventId,
      createdAt,
      updatedAt);

  /// Create a copy of TimeblockModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimeblockModelImplCopyWith<_$TimeblockModelImpl> get copyWith =>
      __$$TimeblockModelImplCopyWithImpl<_$TimeblockModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TimeblockModelImplToJson(
      this,
    );
  }
}

abstract class _TimeblockModel implements TimeblockModel {
  const factory _TimeblockModel(
      {required final String id,
      required final String userId,
      final String? title,
      required final int dayOfWeek,
      required final String startTime,
      required final String endTime,
      final String? color,
      final String? description,
      final String? activityType,
      final String? linkedRoutineId,
      final String? linkedTaskId,
      final bool syncWithCalendar,
      final String? externalCalendarEventId,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$TimeblockModelImpl;

  factory _TimeblockModel.fromJson(Map<String, dynamic> json) =
      _$TimeblockModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String? get title;
  @override
  int get dayOfWeek; // 1 for Monday, 7 for Sunday
  @override
  String get startTime; // HH:mm:ss format
  @override
  String get endTime; // HH:mm:ss format
  @override
  String? get color; // Hex color code e.g., #RRGGBB
  @override
  String? get description;

  /// Activity type for categorization (work, exercise, personal, etc.)
  @override
  String? get activityType;

  /// ID of the routine this timeblock is linked to (if applicable)
  @override
  String? get linkedRoutineId;

  /// ID of the task this timeblock is linked to (if applicable)
  @override
  String? get linkedTaskId;

  /// Whether this timeblock should sync with external calendar
  @override
  bool get syncWithCalendar;

  /// External calendar event ID (for bidirectional sync)
  @override
  String? get externalCalendarEventId;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of TimeblockModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimeblockModelImplCopyWith<_$TimeblockModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
