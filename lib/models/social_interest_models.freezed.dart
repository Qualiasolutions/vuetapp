// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'social_interest_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Hobby _$HobbyFromJson(Map<String, dynamic> json) {
  return _Hobby.fromJson(json);
}

/// @nodoc
mixin _$Hobby {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get frequency => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_engaged_date')
  DateTime? get lastEngagedDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Hobby to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Hobby
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HobbyCopyWith<Hobby> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HobbyCopyWith<$Res> {
  factory $HobbyCopyWith(Hobby value, $Res Function(Hobby) then) =
      _$HobbyCopyWithImpl<$Res, Hobby>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String name,
      String? description,
      String? frequency,
      @JsonKey(name: 'last_engaged_date') DateTime? lastEngagedDate,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$HobbyCopyWithImpl<$Res, $Val extends Hobby>
    implements $HobbyCopyWith<$Res> {
  _$HobbyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Hobby
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? description = freezed,
    Object? frequency = freezed,
    Object? lastEngagedDate = freezed,
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
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      frequency: freezed == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as String?,
      lastEngagedDate: freezed == lastEngagedDate
          ? _value.lastEngagedDate
          : lastEngagedDate // ignore: cast_nullable_to_non_nullable
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
abstract class _$$HobbyImplCopyWith<$Res> implements $HobbyCopyWith<$Res> {
  factory _$$HobbyImplCopyWith(
          _$HobbyImpl value, $Res Function(_$HobbyImpl) then) =
      __$$HobbyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String name,
      String? description,
      String? frequency,
      @JsonKey(name: 'last_engaged_date') DateTime? lastEngagedDate,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$HobbyImplCopyWithImpl<$Res>
    extends _$HobbyCopyWithImpl<$Res, _$HobbyImpl>
    implements _$$HobbyImplCopyWith<$Res> {
  __$$HobbyImplCopyWithImpl(
      _$HobbyImpl _value, $Res Function(_$HobbyImpl) _then)
      : super(_value, _then);

  /// Create a copy of Hobby
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? description = freezed,
    Object? frequency = freezed,
    Object? lastEngagedDate = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$HobbyImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      frequency: freezed == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as String?,
      lastEngagedDate: freezed == lastEngagedDate
          ? _value.lastEngagedDate
          : lastEngagedDate // ignore: cast_nullable_to_non_nullable
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
class _$HobbyImpl implements _Hobby {
  const _$HobbyImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      required this.name,
      this.description,
      this.frequency,
      @JsonKey(name: 'last_engaged_date') this.lastEngagedDate,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt});

  factory _$HobbyImpl.fromJson(Map<String, dynamic> json) =>
      _$$HobbyImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? frequency;
  @override
  @JsonKey(name: 'last_engaged_date')
  final DateTime? lastEngagedDate;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Hobby(id: $id, userId: $userId, name: $name, description: $description, frequency: $frequency, lastEngagedDate: $lastEngagedDate, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HobbyImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            (identical(other.lastEngagedDate, lastEngagedDate) ||
                other.lastEngagedDate == lastEngagedDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, name, description,
      frequency, lastEngagedDate, createdAt, updatedAt);

  /// Create a copy of Hobby
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HobbyImplCopyWith<_$HobbyImpl> get copyWith =>
      __$$HobbyImplCopyWithImpl<_$HobbyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HobbyImplToJson(
      this,
    );
  }
}

abstract class _Hobby implements Hobby {
  const factory _Hobby(
          {required final String id,
          @JsonKey(name: 'user_id') required final String userId,
          required final String name,
          final String? description,
          final String? frequency,
          @JsonKey(name: 'last_engaged_date') final DateTime? lastEngagedDate,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt}) =
      _$HobbyImpl;

  factory _Hobby.fromJson(Map<String, dynamic> json) = _$HobbyImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get name;
  @override
  String? get description;
  @override
  String? get frequency;
  @override
  @JsonKey(name: 'last_engaged_date')
  DateTime? get lastEngagedDate;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of Hobby
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HobbyImplCopyWith<_$HobbyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SocialPlan _$SocialPlanFromJson(Map<String, dynamic> json) {
  return _SocialPlan.fromJson(json);
}

/// @nodoc
mixin _$SocialPlan {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'plan_date')
  DateTime get planDate =>
      throw _privateConstructorUsedError; // Storing time as String for simplicity with TIME type from Supabase, can be parsed.
// Alternatively, use a custom converter or combine with planDate into a DateTime.
  @JsonKey(name: 'plan_time')
  String? get planTime => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'with_contacts')
  dynamic get withContacts =>
      throw _privateConstructorUsedError; // JSONB can be Map or List
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this SocialPlan to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SocialPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SocialPlanCopyWith<SocialPlan> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SocialPlanCopyWith<$Res> {
  factory $SocialPlanCopyWith(
          SocialPlan value, $Res Function(SocialPlan) then) =
      _$SocialPlanCopyWithImpl<$Res, SocialPlan>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String title,
      String? description,
      @JsonKey(name: 'plan_date') DateTime planDate,
      @JsonKey(name: 'plan_time') String? planTime,
      String? location,
      String? status,
      @JsonKey(name: 'with_contacts') dynamic withContacts,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$SocialPlanCopyWithImpl<$Res, $Val extends SocialPlan>
    implements $SocialPlanCopyWith<$Res> {
  _$SocialPlanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SocialPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? description = freezed,
    Object? planDate = null,
    Object? planTime = freezed,
    Object? location = freezed,
    Object? status = freezed,
    Object? withContacts = freezed,
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
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      planDate: null == planDate
          ? _value.planDate
          : planDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      planTime: freezed == planTime
          ? _value.planTime
          : planTime // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      withContacts: freezed == withContacts
          ? _value.withContacts
          : withContacts // ignore: cast_nullable_to_non_nullable
              as dynamic,
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
abstract class _$$SocialPlanImplCopyWith<$Res>
    implements $SocialPlanCopyWith<$Res> {
  factory _$$SocialPlanImplCopyWith(
          _$SocialPlanImpl value, $Res Function(_$SocialPlanImpl) then) =
      __$$SocialPlanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String title,
      String? description,
      @JsonKey(name: 'plan_date') DateTime planDate,
      @JsonKey(name: 'plan_time') String? planTime,
      String? location,
      String? status,
      @JsonKey(name: 'with_contacts') dynamic withContacts,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$SocialPlanImplCopyWithImpl<$Res>
    extends _$SocialPlanCopyWithImpl<$Res, _$SocialPlanImpl>
    implements _$$SocialPlanImplCopyWith<$Res> {
  __$$SocialPlanImplCopyWithImpl(
      _$SocialPlanImpl _value, $Res Function(_$SocialPlanImpl) _then)
      : super(_value, _then);

  /// Create a copy of SocialPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? description = freezed,
    Object? planDate = null,
    Object? planTime = freezed,
    Object? location = freezed,
    Object? status = freezed,
    Object? withContacts = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$SocialPlanImpl(
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
      planDate: null == planDate
          ? _value.planDate
          : planDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      planTime: freezed == planTime
          ? _value.planTime
          : planTime // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      withContacts: freezed == withContacts
          ? _value.withContacts
          : withContacts // ignore: cast_nullable_to_non_nullable
              as dynamic,
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
class _$SocialPlanImpl implements _SocialPlan {
  const _$SocialPlanImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      required this.title,
      this.description,
      @JsonKey(name: 'plan_date') required this.planDate,
      @JsonKey(name: 'plan_time') this.planTime,
      this.location,
      this.status,
      @JsonKey(name: 'with_contacts') this.withContacts,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt});

  factory _$SocialPlanImpl.fromJson(Map<String, dynamic> json) =>
      _$$SocialPlanImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String title;
  @override
  final String? description;
  @override
  @JsonKey(name: 'plan_date')
  final DateTime planDate;
// Storing time as String for simplicity with TIME type from Supabase, can be parsed.
// Alternatively, use a custom converter or combine with planDate into a DateTime.
  @override
  @JsonKey(name: 'plan_time')
  final String? planTime;
  @override
  final String? location;
  @override
  final String? status;
  @override
  @JsonKey(name: 'with_contacts')
  final dynamic withContacts;
// JSONB can be Map or List
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'SocialPlan(id: $id, userId: $userId, title: $title, description: $description, planDate: $planDate, planTime: $planTime, location: $location, status: $status, withContacts: $withContacts, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SocialPlanImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.planDate, planDate) ||
                other.planDate == planDate) &&
            (identical(other.planTime, planTime) ||
                other.planTime == planTime) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other.withContacts, withContacts) &&
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
      planDate,
      planTime,
      location,
      status,
      const DeepCollectionEquality().hash(withContacts),
      createdAt,
      updatedAt);

  /// Create a copy of SocialPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SocialPlanImplCopyWith<_$SocialPlanImpl> get copyWith =>
      __$$SocialPlanImplCopyWithImpl<_$SocialPlanImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SocialPlanImplToJson(
      this,
    );
  }
}

abstract class _SocialPlan implements SocialPlan {
  const factory _SocialPlan(
          {required final String id,
          @JsonKey(name: 'user_id') required final String userId,
          required final String title,
          final String? description,
          @JsonKey(name: 'plan_date') required final DateTime planDate,
          @JsonKey(name: 'plan_time') final String? planTime,
          final String? location,
          final String? status,
          @JsonKey(name: 'with_contacts') final dynamic withContacts,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt}) =
      _$SocialPlanImpl;

  factory _SocialPlan.fromJson(Map<String, dynamic> json) =
      _$SocialPlanImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get title;
  @override
  String? get description;
  @override
  @JsonKey(name: 'plan_date')
  DateTime
      get planDate; // Storing time as String for simplicity with TIME type from Supabase, can be parsed.
// Alternatively, use a custom converter or combine with planDate into a DateTime.
  @override
  @JsonKey(name: 'plan_time')
  String? get planTime;
  @override
  String? get location;
  @override
  String? get status;
  @override
  @JsonKey(name: 'with_contacts')
  dynamic get withContacts; // JSONB can be Map or List
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of SocialPlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SocialPlanImplCopyWith<_$SocialPlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SocialEvent _$SocialEventFromJson(Map<String, dynamic> json) {
  return _SocialEvent.fromJson(json);
}

/// @nodoc
mixin _$SocialEvent {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_datetime')
  DateTime get startDatetime => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_datetime')
  DateTime? get endDatetime => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_name')
  String? get locationName => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_address')
  String? get locationAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_public', defaultValue: false)
  bool get isPublic => throw _privateConstructorUsedError;
  String? get organizer => throw _privateConstructorUsedError;
  @JsonKey(name: 'website_url')
  String? get websiteUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this SocialEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SocialEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SocialEventCopyWith<SocialEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SocialEventCopyWith<$Res> {
  factory $SocialEventCopyWith(
          SocialEvent value, $Res Function(SocialEvent) then) =
      _$SocialEventCopyWithImpl<$Res, SocialEvent>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String name,
      String? description,
      @JsonKey(name: 'start_datetime') DateTime startDatetime,
      @JsonKey(name: 'end_datetime') DateTime? endDatetime,
      @JsonKey(name: 'location_name') String? locationName,
      @JsonKey(name: 'location_address') String? locationAddress,
      @JsonKey(name: 'is_public', defaultValue: false) bool isPublic,
      String? organizer,
      @JsonKey(name: 'website_url') String? websiteUrl,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$SocialEventCopyWithImpl<$Res, $Val extends SocialEvent>
    implements $SocialEventCopyWith<$Res> {
  _$SocialEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SocialEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? description = freezed,
    Object? startDatetime = null,
    Object? endDatetime = freezed,
    Object? locationName = freezed,
    Object? locationAddress = freezed,
    Object? isPublic = null,
    Object? organizer = freezed,
    Object? websiteUrl = freezed,
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
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      startDatetime: null == startDatetime
          ? _value.startDatetime
          : startDatetime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDatetime: freezed == endDatetime
          ? _value.endDatetime
          : endDatetime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      locationName: freezed == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String?,
      locationAddress: freezed == locationAddress
          ? _value.locationAddress
          : locationAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      organizer: freezed == organizer
          ? _value.organizer
          : organizer // ignore: cast_nullable_to_non_nullable
              as String?,
      websiteUrl: freezed == websiteUrl
          ? _value.websiteUrl
          : websiteUrl // ignore: cast_nullable_to_non_nullable
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
abstract class _$$SocialEventImplCopyWith<$Res>
    implements $SocialEventCopyWith<$Res> {
  factory _$$SocialEventImplCopyWith(
          _$SocialEventImpl value, $Res Function(_$SocialEventImpl) then) =
      __$$SocialEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String name,
      String? description,
      @JsonKey(name: 'start_datetime') DateTime startDatetime,
      @JsonKey(name: 'end_datetime') DateTime? endDatetime,
      @JsonKey(name: 'location_name') String? locationName,
      @JsonKey(name: 'location_address') String? locationAddress,
      @JsonKey(name: 'is_public', defaultValue: false) bool isPublic,
      String? organizer,
      @JsonKey(name: 'website_url') String? websiteUrl,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$SocialEventImplCopyWithImpl<$Res>
    extends _$SocialEventCopyWithImpl<$Res, _$SocialEventImpl>
    implements _$$SocialEventImplCopyWith<$Res> {
  __$$SocialEventImplCopyWithImpl(
      _$SocialEventImpl _value, $Res Function(_$SocialEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of SocialEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? description = freezed,
    Object? startDatetime = null,
    Object? endDatetime = freezed,
    Object? locationName = freezed,
    Object? locationAddress = freezed,
    Object? isPublic = null,
    Object? organizer = freezed,
    Object? websiteUrl = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$SocialEventImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      startDatetime: null == startDatetime
          ? _value.startDatetime
          : startDatetime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDatetime: freezed == endDatetime
          ? _value.endDatetime
          : endDatetime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      locationName: freezed == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String?,
      locationAddress: freezed == locationAddress
          ? _value.locationAddress
          : locationAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      organizer: freezed == organizer
          ? _value.organizer
          : organizer // ignore: cast_nullable_to_non_nullable
              as String?,
      websiteUrl: freezed == websiteUrl
          ? _value.websiteUrl
          : websiteUrl // ignore: cast_nullable_to_non_nullable
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
class _$SocialEventImpl implements _SocialEvent {
  const _$SocialEventImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      required this.name,
      this.description,
      @JsonKey(name: 'start_datetime') required this.startDatetime,
      @JsonKey(name: 'end_datetime') this.endDatetime,
      @JsonKey(name: 'location_name') this.locationName,
      @JsonKey(name: 'location_address') this.locationAddress,
      @JsonKey(name: 'is_public', defaultValue: false) required this.isPublic,
      this.organizer,
      @JsonKey(name: 'website_url') this.websiteUrl,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt});

  factory _$SocialEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$SocialEventImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey(name: 'start_datetime')
  final DateTime startDatetime;
  @override
  @JsonKey(name: 'end_datetime')
  final DateTime? endDatetime;
  @override
  @JsonKey(name: 'location_name')
  final String? locationName;
  @override
  @JsonKey(name: 'location_address')
  final String? locationAddress;
  @override
  @JsonKey(name: 'is_public', defaultValue: false)
  final bool isPublic;
  @override
  final String? organizer;
  @override
  @JsonKey(name: 'website_url')
  final String? websiteUrl;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'SocialEvent(id: $id, userId: $userId, name: $name, description: $description, startDatetime: $startDatetime, endDatetime: $endDatetime, locationName: $locationName, locationAddress: $locationAddress, isPublic: $isPublic, organizer: $organizer, websiteUrl: $websiteUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SocialEventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.startDatetime, startDatetime) ||
                other.startDatetime == startDatetime) &&
            (identical(other.endDatetime, endDatetime) ||
                other.endDatetime == endDatetime) &&
            (identical(other.locationName, locationName) ||
                other.locationName == locationName) &&
            (identical(other.locationAddress, locationAddress) ||
                other.locationAddress == locationAddress) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic) &&
            (identical(other.organizer, organizer) ||
                other.organizer == organizer) &&
            (identical(other.websiteUrl, websiteUrl) ||
                other.websiteUrl == websiteUrl) &&
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
      name,
      description,
      startDatetime,
      endDatetime,
      locationName,
      locationAddress,
      isPublic,
      organizer,
      websiteUrl,
      createdAt,
      updatedAt);

  /// Create a copy of SocialEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SocialEventImplCopyWith<_$SocialEventImpl> get copyWith =>
      __$$SocialEventImplCopyWithImpl<_$SocialEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SocialEventImplToJson(
      this,
    );
  }
}

abstract class _SocialEvent implements SocialEvent {
  const factory _SocialEvent(
      {required final String id,
      @JsonKey(name: 'user_id') required final String userId,
      required final String name,
      final String? description,
      @JsonKey(name: 'start_datetime') required final DateTime startDatetime,
      @JsonKey(name: 'end_datetime') final DateTime? endDatetime,
      @JsonKey(name: 'location_name') final String? locationName,
      @JsonKey(name: 'location_address') final String? locationAddress,
      @JsonKey(name: 'is_public', defaultValue: false)
      required final bool isPublic,
      final String? organizer,
      @JsonKey(name: 'website_url') final String? websiteUrl,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at')
      required final DateTime updatedAt}) = _$SocialEventImpl;

  factory _SocialEvent.fromJson(Map<String, dynamic> json) =
      _$SocialEventImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get name;
  @override
  String? get description;
  @override
  @JsonKey(name: 'start_datetime')
  DateTime get startDatetime;
  @override
  @JsonKey(name: 'end_datetime')
  DateTime? get endDatetime;
  @override
  @JsonKey(name: 'location_name')
  String? get locationName;
  @override
  @JsonKey(name: 'location_address')
  String? get locationAddress;
  @override
  @JsonKey(name: 'is_public', defaultValue: false)
  bool get isPublic;
  @override
  String? get organizer;
  @override
  @JsonKey(name: 'website_url')
  String? get websiteUrl;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of SocialEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SocialEventImplCopyWith<_$SocialEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
