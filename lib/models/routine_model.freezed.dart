// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'routine_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RoutineModel _$RoutineModelFromJson(Map<String, dynamic> json) {
  return _RoutineModel.fromJson(json);
}

/// @nodoc
mixin _$RoutineModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get name =>
      throw _privateConstructorUsedError; // Simple day-of-week pattern like React app
  bool get monday => throw _privateConstructorUsedError;
  bool get tuesday => throw _privateConstructorUsedError;
  bool get wednesday => throw _privateConstructorUsedError;
  bool get thursday => throw _privateConstructorUsedError;
  bool get friday => throw _privateConstructorUsedError;
  bool get saturday => throw _privateConstructorUsedError;
  bool get sunday =>
      throw _privateConstructorUsedError; // Simple start/end times
  String get startTime => throw _privateConstructorUsedError; // "HH:mm" format
  String get endTime => throw _privateConstructorUsedError; // "HH:mm" format
// Family members (like React app)
  List<String> get members =>
      throw _privateConstructorUsedError; // User IDs of family members
// Optional fields
  String? get description => throw _privateConstructorUsedError;
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
      String name,
      bool monday,
      bool tuesday,
      bool wednesday,
      bool thursday,
      bool friday,
      bool saturday,
      bool sunday,
      String startTime,
      String endTime,
      List<String> members,
      String? description,
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
    Object? name = null,
    Object? monday = null,
    Object? tuesday = null,
    Object? wednesday = null,
    Object? thursday = null,
    Object? friday = null,
    Object? saturday = null,
    Object? sunday = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? members = null,
    Object? description = freezed,
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
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
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
      members: null == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<String>,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
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
      String name,
      bool monday,
      bool tuesday,
      bool wednesday,
      bool thursday,
      bool friday,
      bool saturday,
      bool sunday,
      String startTime,
      String endTime,
      List<String> members,
      String? description,
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
    Object? name = null,
    Object? monday = null,
    Object? tuesday = null,
    Object? wednesday = null,
    Object? thursday = null,
    Object? friday = null,
    Object? saturday = null,
    Object? sunday = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? members = null,
    Object? description = freezed,
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
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
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
      members: null == members
          ? _value._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<String>,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
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
class _$RoutineModelImpl implements _RoutineModel {
  const _$RoutineModelImpl(
      {required this.id,
      required this.userId,
      required this.name,
      this.monday = false,
      this.tuesday = false,
      this.wednesday = false,
      this.thursday = false,
      this.friday = false,
      this.saturday = false,
      this.sunday = false,
      required this.startTime,
      required this.endTime,
      final List<String> members = const [],
      this.description,
      this.createdAt,
      this.updatedAt})
      : _members = members;

  factory _$RoutineModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoutineModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String name;
// Simple day-of-week pattern like React app
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
// Simple start/end times
  @override
  final String startTime;
// "HH:mm" format
  @override
  final String endTime;
// "HH:mm" format
// Family members (like React app)
  final List<String> _members;
// "HH:mm" format
// Family members (like React app)
  @override
  @JsonKey()
  List<String> get members {
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
  }

// User IDs of family members
// Optional fields
  @override
  final String? description;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'RoutineModel(id: $id, userId: $userId, name: $name, monday: $monday, tuesday: $tuesday, wednesday: $wednesday, thursday: $thursday, friday: $friday, saturday: $saturday, sunday: $sunday, startTime: $startTime, endTime: $endTime, members: $members, description: $description, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoutineModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
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
            const DeepCollectionEquality().equals(other._members, _members) &&
            (identical(other.description, description) ||
                other.description == description) &&
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
      monday,
      tuesday,
      wednesday,
      thursday,
      friday,
      saturday,
      sunday,
      startTime,
      endTime,
      const DeepCollectionEquality().hash(_members),
      description,
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
      required final String name,
      final bool monday,
      final bool tuesday,
      final bool wednesday,
      final bool thursday,
      final bool friday,
      final bool saturday,
      final bool sunday,
      required final String startTime,
      required final String endTime,
      final List<String> members,
      final String? description,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$RoutineModelImpl;

  factory _RoutineModel.fromJson(Map<String, dynamic> json) =
      _$RoutineModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get name; // Simple day-of-week pattern like React app
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
  bool get sunday; // Simple start/end times
  @override
  String get startTime; // "HH:mm" format
  @override
  String get endTime; // "HH:mm" format
// Family members (like React app)
  @override
  List<String> get members; // User IDs of family members
// Optional fields
  @override
  String? get description;
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
