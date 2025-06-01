// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ical_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ICalEvent _$ICalEventFromJson(Map<String, dynamic> json) {
  return _ICalEvent.fromJson(json);
}

/// @nodoc
mixin _$ICalEvent {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get icalIntegrationId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  DateTime get startDateTime => throw _privateConstructorUsedError;
  DateTime get endDateTime => throw _privateConstructorUsedError;
  String? get rrule =>
      throw _privateConstructorUsedError; // iCalendar RRULE string for recurrence
  String? get originalEventId =>
      throw _privateConstructorUsedError; // UID from the iCal event, for updates/deletions
  DateTime? get originalEventStartTime =>
      throw _privateConstructorUsedError; // DTSTART from the iCal event, for updates of recurring events
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ICalEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ICalEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ICalEventCopyWith<ICalEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ICalEventCopyWith<$Res> {
  factory $ICalEventCopyWith(ICalEvent value, $Res Function(ICalEvent) then) =
      _$ICalEventCopyWithImpl<$Res, ICalEvent>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String icalIntegrationId,
      String title,
      DateTime startDateTime,
      DateTime endDateTime,
      String? rrule,
      String? originalEventId,
      DateTime? originalEventStartTime,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$ICalEventCopyWithImpl<$Res, $Val extends ICalEvent>
    implements $ICalEventCopyWith<$Res> {
  _$ICalEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ICalEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? icalIntegrationId = null,
    Object? title = null,
    Object? startDateTime = null,
    Object? endDateTime = null,
    Object? rrule = freezed,
    Object? originalEventId = freezed,
    Object? originalEventStartTime = freezed,
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
      icalIntegrationId: null == icalIntegrationId
          ? _value.icalIntegrationId
          : icalIntegrationId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      startDateTime: null == startDateTime
          ? _value.startDateTime
          : startDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDateTime: null == endDateTime
          ? _value.endDateTime
          : endDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      rrule: freezed == rrule
          ? _value.rrule
          : rrule // ignore: cast_nullable_to_non_nullable
              as String?,
      originalEventId: freezed == originalEventId
          ? _value.originalEventId
          : originalEventId // ignore: cast_nullable_to_non_nullable
              as String?,
      originalEventStartTime: freezed == originalEventStartTime
          ? _value.originalEventStartTime
          : originalEventStartTime // ignore: cast_nullable_to_non_nullable
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
abstract class _$$ICalEventImplCopyWith<$Res>
    implements $ICalEventCopyWith<$Res> {
  factory _$$ICalEventImplCopyWith(
          _$ICalEventImpl value, $Res Function(_$ICalEventImpl) then) =
      __$$ICalEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String icalIntegrationId,
      String title,
      DateTime startDateTime,
      DateTime endDateTime,
      String? rrule,
      String? originalEventId,
      DateTime? originalEventStartTime,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$ICalEventImplCopyWithImpl<$Res>
    extends _$ICalEventCopyWithImpl<$Res, _$ICalEventImpl>
    implements _$$ICalEventImplCopyWith<$Res> {
  __$$ICalEventImplCopyWithImpl(
      _$ICalEventImpl _value, $Res Function(_$ICalEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of ICalEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? icalIntegrationId = null,
    Object? title = null,
    Object? startDateTime = null,
    Object? endDateTime = null,
    Object? rrule = freezed,
    Object? originalEventId = freezed,
    Object? originalEventStartTime = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ICalEventImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      icalIntegrationId: null == icalIntegrationId
          ? _value.icalIntegrationId
          : icalIntegrationId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      startDateTime: null == startDateTime
          ? _value.startDateTime
          : startDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDateTime: null == endDateTime
          ? _value.endDateTime
          : endDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      rrule: freezed == rrule
          ? _value.rrule
          : rrule // ignore: cast_nullable_to_non_nullable
              as String?,
      originalEventId: freezed == originalEventId
          ? _value.originalEventId
          : originalEventId // ignore: cast_nullable_to_non_nullable
              as String?,
      originalEventStartTime: freezed == originalEventStartTime
          ? _value.originalEventStartTime
          : originalEventStartTime // ignore: cast_nullable_to_non_nullable
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
class _$ICalEventImpl implements _ICalEvent {
  const _$ICalEventImpl(
      {required this.id,
      required this.userId,
      required this.icalIntegrationId,
      required this.title,
      required this.startDateTime,
      required this.endDateTime,
      this.rrule,
      this.originalEventId,
      this.originalEventStartTime,
      required this.createdAt,
      required this.updatedAt});

  factory _$ICalEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$ICalEventImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String icalIntegrationId;
  @override
  final String title;
  @override
  final DateTime startDateTime;
  @override
  final DateTime endDateTime;
  @override
  final String? rrule;
// iCalendar RRULE string for recurrence
  @override
  final String? originalEventId;
// UID from the iCal event, for updates/deletions
  @override
  final DateTime? originalEventStartTime;
// DTSTART from the iCal event, for updates of recurring events
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ICalEvent(id: $id, userId: $userId, icalIntegrationId: $icalIntegrationId, title: $title, startDateTime: $startDateTime, endDateTime: $endDateTime, rrule: $rrule, originalEventId: $originalEventId, originalEventStartTime: $originalEventStartTime, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ICalEventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.icalIntegrationId, icalIntegrationId) ||
                other.icalIntegrationId == icalIntegrationId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.startDateTime, startDateTime) ||
                other.startDateTime == startDateTime) &&
            (identical(other.endDateTime, endDateTime) ||
                other.endDateTime == endDateTime) &&
            (identical(other.rrule, rrule) || other.rrule == rrule) &&
            (identical(other.originalEventId, originalEventId) ||
                other.originalEventId == originalEventId) &&
            (identical(other.originalEventStartTime, originalEventStartTime) ||
                other.originalEventStartTime == originalEventStartTime) &&
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
      icalIntegrationId,
      title,
      startDateTime,
      endDateTime,
      rrule,
      originalEventId,
      originalEventStartTime,
      createdAt,
      updatedAt);

  /// Create a copy of ICalEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ICalEventImplCopyWith<_$ICalEventImpl> get copyWith =>
      __$$ICalEventImplCopyWithImpl<_$ICalEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ICalEventImplToJson(
      this,
    );
  }
}

abstract class _ICalEvent implements ICalEvent {
  const factory _ICalEvent(
      {required final String id,
      required final String userId,
      required final String icalIntegrationId,
      required final String title,
      required final DateTime startDateTime,
      required final DateTime endDateTime,
      final String? rrule,
      final String? originalEventId,
      final DateTime? originalEventStartTime,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$ICalEventImpl;

  factory _ICalEvent.fromJson(Map<String, dynamic> json) =
      _$ICalEventImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get icalIntegrationId;
  @override
  String get title;
  @override
  DateTime get startDateTime;
  @override
  DateTime get endDateTime;
  @override
  String? get rrule; // iCalendar RRULE string for recurrence
  @override
  String? get originalEventId; // UID from the iCal event, for updates/deletions
  @override
  DateTime?
      get originalEventStartTime; // DTSTART from the iCal event, for updates of recurring events
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of ICalEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ICalEventImplCopyWith<_$ICalEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
