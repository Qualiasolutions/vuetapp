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
  String get startTime =>
      throw _privateConstructorUsedError; // Format: "HH:mm:ss"
  String get endTime =>
      throw _privateConstructorUsedError; // Format: "HH:mm:ss"
  String? get color =>
      throw _privateConstructorUsedError; // Hex color code e.g., #RRGGBB
  String? get description => throw _privateConstructorUsedError;
  String? get activityType => throw _privateConstructorUsedError;
  String? get linkedRoutineId => throw _privateConstructorUsedError;
  String? get linkedTaskId => throw _privateConstructorUsedError;
  bool get syncWithCalendar => throw _privateConstructorUsedError;
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
// Format: "HH:mm:ss"
  @override
  final String endTime;
// Format: "HH:mm:ss"
  @override
  final String? color;
// Hex color code e.g., #RRGGBB
  @override
  final String? description;
  @override
  final String? activityType;
  @override
  final String? linkedRoutineId;
  @override
  final String? linkedTaskId;
  @override
  @JsonKey()
  final bool syncWithCalendar;
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
  String get startTime; // Format: "HH:mm:ss"
  @override
  String get endTime; // Format: "HH:mm:ss"
  @override
  String? get color; // Hex color code e.g., #RRGGBB
  @override
  String? get description;
  @override
  String? get activityType;
  @override
  String? get linkedRoutineId;
  @override
  String? get linkedTaskId;
  @override
  bool get syncWithCalendar;
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

RoutineModel _$RoutineModelFromJson(Map<String, dynamic> json) {
  return _RoutineModel.fromJson(json);
}

/// @nodoc
mixin _$RoutineModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get color =>
      throw _privateConstructorUsedError; // Days of the week (boolean for each day)
  bool get monday => throw _privateConstructorUsedError;
  bool get tuesday => throw _privateConstructorUsedError;
  bool get wednesday => throw _privateConstructorUsedError;
  bool get thursday => throw _privateConstructorUsedError;
  bool get friday => throw _privateConstructorUsedError;
  bool get saturday => throw _privateConstructorUsedError;
  bool get sunday => throw _privateConstructorUsedError;
  String get startTime => throw _privateConstructorUsedError; // Format: "HH:mm"
  String get endTime => throw _privateConstructorUsedError; // Format: "HH:mm"
  bool get isActive => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this RoutineModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RoutineModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoutineModelCopyWith<RoutineModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoutineModelCopyWith<$Res> {
  factory $RoutineModelCopyWith(
          RoutineModel value, $Res Function(RoutineModel) then) =
      _$RoutineModelCopyWithImpl<$Res, RoutineModel>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String title,
      String? description,
      String? color,
      bool monday,
      bool tuesday,
      bool wednesday,
      bool thursday,
      bool friday,
      bool saturday,
      bool sunday,
      String startTime,
      String endTime,
      bool isActive,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$RoutineModelCopyWithImpl<$Res, $Val extends RoutineModel>
    implements $RoutineModelCopyWith<$Res> {
  _$RoutineModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RoutineModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? description = freezed,
    Object? color = freezed,
    Object? monday = null,
    Object? tuesday = null,
    Object? wednesday = null,
    Object? thursday = null,
    Object? friday = null,
    Object? saturday = null,
    Object? sunday = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      monday: null == monday
          ? _value.monday
          : monday // ignore: cast_nullable_to_non_nullable
              as bool,
      tuesday: null == tuesday
          ? _value.tuesday
          : tuesday // ignore: cast_nullable_to_non_nullable
              as bool,
      wednesday: null == wednesday
          ? _value.wednesday
          : wednesday // ignore: cast_nullable_to_non_nullable
              as bool,
      thursday: null == thursday
          ? _value.thursday
          : thursday // ignore: cast_nullable_to_non_nullable
              as bool,
      friday: null == friday
          ? _value.friday
          : friday // ignore: cast_nullable_to_non_nullable
              as bool,
      saturday: null == saturday
          ? _value.saturday
          : saturday // ignore: cast_nullable_to_non_nullable
              as bool,
      sunday: null == sunday
          ? _value.sunday
          : sunday // ignore: cast_nullable_to_non_nullable
              as bool,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
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
abstract class _$$RoutineModelImplCopyWith<$Res>
    implements $RoutineModelCopyWith<$Res> {
  factory _$$RoutineModelImplCopyWith(
          _$RoutineModelImpl value, $Res Function(_$RoutineModelImpl) then) =
      __$$RoutineModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String title,
      String? description,
      String? color,
      bool monday,
      bool tuesday,
      bool wednesday,
      bool thursday,
      bool friday,
      bool saturday,
      bool sunday,
      String startTime,
      String endTime,
      bool isActive,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$RoutineModelImplCopyWithImpl<$Res>
    extends _$RoutineModelCopyWithImpl<$Res, _$RoutineModelImpl>
    implements _$$RoutineModelImplCopyWith<$Res> {
  __$$RoutineModelImplCopyWithImpl(
      _$RoutineModelImpl _value, $Res Function(_$RoutineModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of RoutineModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? description = freezed,
    Object? color = freezed,
    Object? monday = null,
    Object? tuesday = null,
    Object? wednesday = null,
    Object? thursday = null,
    Object? friday = null,
    Object? saturday = null,
    Object? sunday = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$RoutineModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
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
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      monday: null == monday
          ? _value.monday
          : monday // ignore: cast_nullable_to_non_nullable
              as bool,
      tuesday: null == tuesday
          ? _value.tuesday
          : tuesday // ignore: cast_nullable_to_non_nullable
              as bool,
      wednesday: null == wednesday
          ? _value.wednesday
          : wednesday // ignore: cast_nullable_to_non_nullable
              as bool,
      thursday: null == thursday
          ? _value.thursday
          : thursday // ignore: cast_nullable_to_non_nullable
              as bool,
      friday: null == friday
          ? _value.friday
          : friday // ignore: cast_nullable_to_non_nullable
              as bool,
      saturday: null == saturday
          ? _value.saturday
          : saturday // ignore: cast_nullable_to_non_nullable
              as bool,
      sunday: null == sunday
          ? _value.sunday
          : sunday // ignore: cast_nullable_to_non_nullable
              as bool,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
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
class _$RoutineModelImpl implements _RoutineModel {
  const _$RoutineModelImpl(
      {required this.id,
      required this.userId,
      required this.title,
      this.description,
      this.color,
      this.monday = false,
      this.tuesday = false,
      this.wednesday = false,
      this.thursday = false,
      this.friday = false,
      this.saturday = false,
      this.sunday = false,
      required this.startTime,
      required this.endTime,
      this.isActive = true,
      this.createdAt,
      this.updatedAt});

  factory _$RoutineModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoutineModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String title;
  @override
  final String? description;
  @override
  final String? color;
// Days of the week (boolean for each day)
  @override
  @JsonKey()
  final bool monday;
  @override
  @JsonKey()
  final bool tuesday;
  @override
  @JsonKey()
  final bool wednesday;
  @override
  @JsonKey()
  final bool thursday;
  @override
  @JsonKey()
  final bool friday;
  @override
  @JsonKey()
  final bool saturday;
  @override
  @JsonKey()
  final bool sunday;
  @override
  final String startTime;
// Format: "HH:mm"
  @override
  final String endTime;
// Format: "HH:mm"
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'RoutineModel(id: $id, userId: $userId, title: $title, description: $description, color: $color, monday: $monday, tuesday: $tuesday, wednesday: $wednesday, thursday: $thursday, friday: $friday, saturday: $saturday, sunday: $sunday, startTime: $startTime, endTime: $endTime, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoutineModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.monday, monday) || other.monday == monday) &&
            (identical(other.tuesday, tuesday) || other.tuesday == tuesday) &&
            (identical(other.wednesday, wednesday) ||
                other.wednesday == wednesday) &&
            (identical(other.thursday, thursday) ||
                other.thursday == thursday) &&
            (identical(other.friday, friday) || other.friday == friday) &&
            (identical(other.saturday, saturday) ||
                other.saturday == saturday) &&
            (identical(other.sunday, sunday) || other.sunday == sunday) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
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
      userId,
      title,
      description,
      color,
      monday,
      tuesday,
      wednesday,
      thursday,
      friday,
      saturday,
      sunday,
      startTime,
      endTime,
      isActive,
      createdAt,
      updatedAt);

  /// Create a copy of RoutineModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoutineModelImplCopyWith<_$RoutineModelImpl> get copyWith =>
      __$$RoutineModelImplCopyWithImpl<_$RoutineModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoutineModelImplToJson(
      this,
    );
  }
}

abstract class _RoutineModel implements RoutineModel {
  const factory _RoutineModel(
      {required final String id,
      required final String userId,
      required final String title,
      final String? description,
      final String? color,
      final bool monday,
      final bool tuesday,
      final bool wednesday,
      final bool thursday,
      final bool friday,
      final bool saturday,
      final bool sunday,
      required final String startTime,
      required final String endTime,
      final bool isActive,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$RoutineModelImpl;

  factory _RoutineModel.fromJson(Map<String, dynamic> json) =
      _$RoutineModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get title;
  @override
  String? get description;
  @override
  String? get color; // Days of the week (boolean for each day)
  @override
  bool get monday;
  @override
  bool get tuesday;
  @override
  bool get wednesday;
  @override
  bool get thursday;
  @override
  bool get friday;
  @override
  bool get saturday;
  @override
  bool get sunday;
  @override
  String get startTime; // Format: "HH:mm"
  @override
  String get endTime; // Format: "HH:mm"
  @override
  bool get isActive;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of RoutineModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoutineModelImplCopyWith<_$RoutineModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
