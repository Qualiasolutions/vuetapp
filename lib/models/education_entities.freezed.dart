// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'education_entities.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

School _$SchoolFromJson(Map<String, dynamic> json) {
  return _School.fromJson(json);
}

/// @nodoc
mixin _$School {
  String get id =>
      throw _privateConstructorUsedError; // Corresponds to entities.id
  String get entityType => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get phoneNumber => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get website =>
      throw _privateConstructorUsedError; // Specific fields from school_entities table
// Assuming owner_id, created_at, updated_at are handled by the generic entity or repository
  String? get notes =>
      throw _privateConstructorUsedError; // from entities table
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String? get ownerId => throw _privateConstructorUsedError;

  /// Serializes this School to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of School
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SchoolCopyWith<School> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SchoolCopyWith<$Res> {
  factory $SchoolCopyWith(School value, $Res Function(School) then) =
      _$SchoolCopyWithImpl<$Res, School>;
  @useResult
  $Res call(
      {String id,
      String entityType,
      String name,
      String? address,
      String? phoneNumber,
      String? email,
      String? website,
      String? notes,
      DateTime createdAt,
      DateTime updatedAt,
      String? ownerId});
}

/// @nodoc
class _$SchoolCopyWithImpl<$Res, $Val extends School>
    implements $SchoolCopyWith<$Res> {
  _$SchoolCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of School
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? entityType = null,
    Object? name = null,
    Object? address = freezed,
    Object? phoneNumber = freezed,
    Object? email = freezed,
    Object? website = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? ownerId = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      entityType: null == entityType
          ? _value.entityType
          : entityType // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      ownerId: freezed == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SchoolImplCopyWith<$Res> implements $SchoolCopyWith<$Res> {
  factory _$$SchoolImplCopyWith(
          _$SchoolImpl value, $Res Function(_$SchoolImpl) then) =
      __$$SchoolImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String entityType,
      String name,
      String? address,
      String? phoneNumber,
      String? email,
      String? website,
      String? notes,
      DateTime createdAt,
      DateTime updatedAt,
      String? ownerId});
}

/// @nodoc
class __$$SchoolImplCopyWithImpl<$Res>
    extends _$SchoolCopyWithImpl<$Res, _$SchoolImpl>
    implements _$$SchoolImplCopyWith<$Res> {
  __$$SchoolImplCopyWithImpl(
      _$SchoolImpl _value, $Res Function(_$SchoolImpl) _then)
      : super(_value, _then);

  /// Create a copy of School
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? entityType = null,
    Object? name = null,
    Object? address = freezed,
    Object? phoneNumber = freezed,
    Object? email = freezed,
    Object? website = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? ownerId = freezed,
  }) {
    return _then(_$SchoolImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      entityType: null == entityType
          ? _value.entityType
          : entityType // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      ownerId: freezed == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SchoolImpl implements _School {
  const _$SchoolImpl(
      {required this.id,
      this.entityType = 'School',
      required this.name,
      this.address,
      this.phoneNumber,
      this.email,
      this.website,
      this.notes,
      required this.createdAt,
      required this.updatedAt,
      this.ownerId});

  factory _$SchoolImpl.fromJson(Map<String, dynamic> json) =>
      _$$SchoolImplFromJson(json);

  @override
  final String id;
// Corresponds to entities.id
  @override
  @JsonKey()
  final String entityType;
  @override
  final String name;
  @override
  final String? address;
  @override
  final String? phoneNumber;
  @override
  final String? email;
  @override
  final String? website;
// Specific fields from school_entities table
// Assuming owner_id, created_at, updated_at are handled by the generic entity or repository
  @override
  final String? notes;
// from entities table
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String? ownerId;

  @override
  String toString() {
    return 'School(id: $id, entityType: $entityType, name: $name, address: $address, phoneNumber: $phoneNumber, email: $email, website: $website, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, ownerId: $ownerId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SchoolImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.website, website) || other.website == website) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, entityType, name, address,
      phoneNumber, email, website, notes, createdAt, updatedAt, ownerId);

  /// Create a copy of School
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SchoolImplCopyWith<_$SchoolImpl> get copyWith =>
      __$$SchoolImplCopyWithImpl<_$SchoolImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SchoolImplToJson(
      this,
    );
  }
}

abstract class _School implements School {
  const factory _School(
      {required final String id,
      final String entityType,
      required final String name,
      final String? address,
      final String? phoneNumber,
      final String? email,
      final String? website,
      final String? notes,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final String? ownerId}) = _$SchoolImpl;

  factory _School.fromJson(Map<String, dynamic> json) = _$SchoolImpl.fromJson;

  @override
  String get id; // Corresponds to entities.id
  @override
  String get entityType;
  @override
  String get name;
  @override
  String? get address;
  @override
  String? get phoneNumber;
  @override
  String? get email;
  @override
  String? get website; // Specific fields from school_entities table
// Assuming owner_id, created_at, updated_at are handled by the generic entity or repository
  @override
  String? get notes; // from entities table
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  String? get ownerId;

  /// Create a copy of School
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SchoolImplCopyWith<_$SchoolImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Student _$StudentFromJson(Map<String, dynamic> json) {
  return _Student.fromJson(json);
}

/// @nodoc
mixin _$Student {
  String get id =>
      throw _privateConstructorUsedError; // Corresponds to entities.id
  String get entityType => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String? get lastName => throw _privateConstructorUsedError;
  DateTime? get dateOfBirth => throw _privateConstructorUsedError;
  String? get schoolId =>
      throw _privateConstructorUsedError; // FK to entities.id of a School entity
  String? get gradeLevel => throw _privateConstructorUsedError;
  String? get studentIdNumber =>
      throw _privateConstructorUsedError; // Specific fields from student_entities table
  String? get notes =>
      throw _privateConstructorUsedError; // from entities table
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String? get ownerId => throw _privateConstructorUsedError;

  /// Serializes this Student to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Student
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StudentCopyWith<Student> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StudentCopyWith<$Res> {
  factory $StudentCopyWith(Student value, $Res Function(Student) then) =
      _$StudentCopyWithImpl<$Res, Student>;
  @useResult
  $Res call(
      {String id,
      String entityType,
      String firstName,
      String? lastName,
      DateTime? dateOfBirth,
      String? schoolId,
      String? gradeLevel,
      String? studentIdNumber,
      String? notes,
      DateTime createdAt,
      DateTime updatedAt,
      String? ownerId});
}

/// @nodoc
class _$StudentCopyWithImpl<$Res, $Val extends Student>
    implements $StudentCopyWith<$Res> {
  _$StudentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Student
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? entityType = null,
    Object? firstName = null,
    Object? lastName = freezed,
    Object? dateOfBirth = freezed,
    Object? schoolId = freezed,
    Object? gradeLevel = freezed,
    Object? studentIdNumber = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? ownerId = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      entityType: null == entityType
          ? _value.entityType
          : entityType // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      dateOfBirth: freezed == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      schoolId: freezed == schoolId
          ? _value.schoolId
          : schoolId // ignore: cast_nullable_to_non_nullable
              as String?,
      gradeLevel: freezed == gradeLevel
          ? _value.gradeLevel
          : gradeLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      studentIdNumber: freezed == studentIdNumber
          ? _value.studentIdNumber
          : studentIdNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      ownerId: freezed == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StudentImplCopyWith<$Res> implements $StudentCopyWith<$Res> {
  factory _$$StudentImplCopyWith(
          _$StudentImpl value, $Res Function(_$StudentImpl) then) =
      __$$StudentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String entityType,
      String firstName,
      String? lastName,
      DateTime? dateOfBirth,
      String? schoolId,
      String? gradeLevel,
      String? studentIdNumber,
      String? notes,
      DateTime createdAt,
      DateTime updatedAt,
      String? ownerId});
}

/// @nodoc
class __$$StudentImplCopyWithImpl<$Res>
    extends _$StudentCopyWithImpl<$Res, _$StudentImpl>
    implements _$$StudentImplCopyWith<$Res> {
  __$$StudentImplCopyWithImpl(
      _$StudentImpl _value, $Res Function(_$StudentImpl) _then)
      : super(_value, _then);

  /// Create a copy of Student
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? entityType = null,
    Object? firstName = null,
    Object? lastName = freezed,
    Object? dateOfBirth = freezed,
    Object? schoolId = freezed,
    Object? gradeLevel = freezed,
    Object? studentIdNumber = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? ownerId = freezed,
  }) {
    return _then(_$StudentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      entityType: null == entityType
          ? _value.entityType
          : entityType // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      dateOfBirth: freezed == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      schoolId: freezed == schoolId
          ? _value.schoolId
          : schoolId // ignore: cast_nullable_to_non_nullable
              as String?,
      gradeLevel: freezed == gradeLevel
          ? _value.gradeLevel
          : gradeLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      studentIdNumber: freezed == studentIdNumber
          ? _value.studentIdNumber
          : studentIdNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      ownerId: freezed == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StudentImpl implements _Student {
  const _$StudentImpl(
      {required this.id,
      this.entityType = 'Student',
      required this.firstName,
      this.lastName,
      this.dateOfBirth,
      this.schoolId,
      this.gradeLevel,
      this.studentIdNumber,
      this.notes,
      required this.createdAt,
      required this.updatedAt,
      this.ownerId});

  factory _$StudentImpl.fromJson(Map<String, dynamic> json) =>
      _$$StudentImplFromJson(json);

  @override
  final String id;
// Corresponds to entities.id
  @override
  @JsonKey()
  final String entityType;
  @override
  final String firstName;
  @override
  final String? lastName;
  @override
  final DateTime? dateOfBirth;
  @override
  final String? schoolId;
// FK to entities.id of a School entity
  @override
  final String? gradeLevel;
  @override
  final String? studentIdNumber;
// Specific fields from student_entities table
  @override
  final String? notes;
// from entities table
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String? ownerId;

  @override
  String toString() {
    return 'Student(id: $id, entityType: $entityType, firstName: $firstName, lastName: $lastName, dateOfBirth: $dateOfBirth, schoolId: $schoolId, gradeLevel: $gradeLevel, studentIdNumber: $studentIdNumber, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, ownerId: $ownerId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StudentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth) &&
            (identical(other.schoolId, schoolId) ||
                other.schoolId == schoolId) &&
            (identical(other.gradeLevel, gradeLevel) ||
                other.gradeLevel == gradeLevel) &&
            (identical(other.studentIdNumber, studentIdNumber) ||
                other.studentIdNumber == studentIdNumber) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      entityType,
      firstName,
      lastName,
      dateOfBirth,
      schoolId,
      gradeLevel,
      studentIdNumber,
      notes,
      createdAt,
      updatedAt,
      ownerId);

  /// Create a copy of Student
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StudentImplCopyWith<_$StudentImpl> get copyWith =>
      __$$StudentImplCopyWithImpl<_$StudentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StudentImplToJson(
      this,
    );
  }
}

abstract class _Student implements Student {
  const factory _Student(
      {required final String id,
      final String entityType,
      required final String firstName,
      final String? lastName,
      final DateTime? dateOfBirth,
      final String? schoolId,
      final String? gradeLevel,
      final String? studentIdNumber,
      final String? notes,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final String? ownerId}) = _$StudentImpl;

  factory _Student.fromJson(Map<String, dynamic> json) = _$StudentImpl.fromJson;

  @override
  String get id; // Corresponds to entities.id
  @override
  String get entityType;
  @override
  String get firstName;
  @override
  String? get lastName;
  @override
  DateTime? get dateOfBirth;
  @override
  String? get schoolId; // FK to entities.id of a School entity
  @override
  String? get gradeLevel;
  @override
  String? get studentIdNumber; // Specific fields from student_entities table
  @override
  String? get notes; // from entities table
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  String? get ownerId;

  /// Create a copy of Student
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StudentImplCopyWith<_$StudentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AcademicPlan _$AcademicPlanFromJson(Map<String, dynamic> json) {
  return _AcademicPlan.fromJson(json);
}

/// @nodoc
mixin _$AcademicPlan {
  String get id =>
      throw _privateConstructorUsedError; // Corresponds to entities.id
  String get entityType => throw _privateConstructorUsedError;
  String? get studentId =>
      throw _privateConstructorUsedError; // FK to entities.id of a Student entity
  String get planName => throw _privateConstructorUsedError;
  DateTime? get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<String>? get goals =>
      throw _privateConstructorUsedError; // Simplified from JSONB for now
// Specific fields from academic_plan_entities table
  String? get notes =>
      throw _privateConstructorUsedError; // from entities table
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String? get ownerId => throw _privateConstructorUsedError;

  /// Serializes this AcademicPlan to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AcademicPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AcademicPlanCopyWith<AcademicPlan> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AcademicPlanCopyWith<$Res> {
  factory $AcademicPlanCopyWith(
          AcademicPlan value, $Res Function(AcademicPlan) then) =
      _$AcademicPlanCopyWithImpl<$Res, AcademicPlan>;
  @useResult
  $Res call(
      {String id,
      String entityType,
      String? studentId,
      String planName,
      DateTime? startDate,
      DateTime? endDate,
      String? description,
      List<String>? goals,
      String? notes,
      DateTime createdAt,
      DateTime updatedAt,
      String? ownerId});
}

/// @nodoc
class _$AcademicPlanCopyWithImpl<$Res, $Val extends AcademicPlan>
    implements $AcademicPlanCopyWith<$Res> {
  _$AcademicPlanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AcademicPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? entityType = null,
    Object? studentId = freezed,
    Object? planName = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? description = freezed,
    Object? goals = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? ownerId = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      entityType: null == entityType
          ? _value.entityType
          : entityType // ignore: cast_nullable_to_non_nullable
              as String,
      studentId: freezed == studentId
          ? _value.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String?,
      planName: null == planName
          ? _value.planName
          : planName // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      goals: freezed == goals
          ? _value.goals
          : goals // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      ownerId: freezed == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AcademicPlanImplCopyWith<$Res>
    implements $AcademicPlanCopyWith<$Res> {
  factory _$$AcademicPlanImplCopyWith(
          _$AcademicPlanImpl value, $Res Function(_$AcademicPlanImpl) then) =
      __$$AcademicPlanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String entityType,
      String? studentId,
      String planName,
      DateTime? startDate,
      DateTime? endDate,
      String? description,
      List<String>? goals,
      String? notes,
      DateTime createdAt,
      DateTime updatedAt,
      String? ownerId});
}

/// @nodoc
class __$$AcademicPlanImplCopyWithImpl<$Res>
    extends _$AcademicPlanCopyWithImpl<$Res, _$AcademicPlanImpl>
    implements _$$AcademicPlanImplCopyWith<$Res> {
  __$$AcademicPlanImplCopyWithImpl(
      _$AcademicPlanImpl _value, $Res Function(_$AcademicPlanImpl) _then)
      : super(_value, _then);

  /// Create a copy of AcademicPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? entityType = null,
    Object? studentId = freezed,
    Object? planName = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? description = freezed,
    Object? goals = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? ownerId = freezed,
  }) {
    return _then(_$AcademicPlanImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      entityType: null == entityType
          ? _value.entityType
          : entityType // ignore: cast_nullable_to_non_nullable
              as String,
      studentId: freezed == studentId
          ? _value.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String?,
      planName: null == planName
          ? _value.planName
          : planName // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      goals: freezed == goals
          ? _value._goals
          : goals // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      ownerId: freezed == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AcademicPlanImpl implements _AcademicPlan {
  const _$AcademicPlanImpl(
      {required this.id,
      this.entityType = 'AcademicPlan',
      this.studentId,
      required this.planName,
      this.startDate,
      this.endDate,
      this.description,
      final List<String>? goals,
      this.notes,
      required this.createdAt,
      required this.updatedAt,
      this.ownerId})
      : _goals = goals;

  factory _$AcademicPlanImpl.fromJson(Map<String, dynamic> json) =>
      _$$AcademicPlanImplFromJson(json);

  @override
  final String id;
// Corresponds to entities.id
  @override
  @JsonKey()
  final String entityType;
  @override
  final String? studentId;
// FK to entities.id of a Student entity
  @override
  final String planName;
  @override
  final DateTime? startDate;
  @override
  final DateTime? endDate;
  @override
  final String? description;
  final List<String>? _goals;
  @override
  List<String>? get goals {
    final value = _goals;
    if (value == null) return null;
    if (_goals is EqualUnmodifiableListView) return _goals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// Simplified from JSONB for now
// Specific fields from academic_plan_entities table
  @override
  final String? notes;
// from entities table
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String? ownerId;

  @override
  String toString() {
    return 'AcademicPlan(id: $id, entityType: $entityType, studentId: $studentId, planName: $planName, startDate: $startDate, endDate: $endDate, description: $description, goals: $goals, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, ownerId: $ownerId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AcademicPlanImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.planName, planName) ||
                other.planName == planName) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._goals, _goals) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      entityType,
      studentId,
      planName,
      startDate,
      endDate,
      description,
      const DeepCollectionEquality().hash(_goals),
      notes,
      createdAt,
      updatedAt,
      ownerId);

  /// Create a copy of AcademicPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AcademicPlanImplCopyWith<_$AcademicPlanImpl> get copyWith =>
      __$$AcademicPlanImplCopyWithImpl<_$AcademicPlanImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AcademicPlanImplToJson(
      this,
    );
  }
}

abstract class _AcademicPlan implements AcademicPlan {
  const factory _AcademicPlan(
      {required final String id,
      final String entityType,
      final String? studentId,
      required final String planName,
      final DateTime? startDate,
      final DateTime? endDate,
      final String? description,
      final List<String>? goals,
      final String? notes,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final String? ownerId}) = _$AcademicPlanImpl;

  factory _AcademicPlan.fromJson(Map<String, dynamic> json) =
      _$AcademicPlanImpl.fromJson;

  @override
  String get id; // Corresponds to entities.id
  @override
  String get entityType;
  @override
  String? get studentId; // FK to entities.id of a Student entity
  @override
  String get planName;
  @override
  DateTime? get startDate;
  @override
  DateTime? get endDate;
  @override
  String? get description;
  @override
  List<String>? get goals; // Simplified from JSONB for now
// Specific fields from academic_plan_entities table
  @override
  String? get notes; // from entities table
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  String? get ownerId;

  /// Create a copy of AcademicPlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AcademicPlanImplCopyWith<_$AcademicPlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SchoolTerm _$SchoolTermFromJson(Map<String, dynamic> json) {
  return _SchoolTerm.fromJson(json);
}

/// @nodoc
mixin _$SchoolTerm {
  String get id =>
      throw _privateConstructorUsedError; // Corresponds to entities.id
  String get entityType => throw _privateConstructorUsedError;
  String? get schoolId =>
      throw _privateConstructorUsedError; // FK to entities.id of a School entity
  String get termName => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  String? get description =>
      throw _privateConstructorUsedError; // Specific fields from school_term_entities table
  String? get notes =>
      throw _privateConstructorUsedError; // from entities table
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String? get ownerId => throw _privateConstructorUsedError;

  /// Serializes this SchoolTerm to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SchoolTerm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SchoolTermCopyWith<SchoolTerm> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SchoolTermCopyWith<$Res> {
  factory $SchoolTermCopyWith(
          SchoolTerm value, $Res Function(SchoolTerm) then) =
      _$SchoolTermCopyWithImpl<$Res, SchoolTerm>;
  @useResult
  $Res call(
      {String id,
      String entityType,
      String? schoolId,
      String termName,
      DateTime startDate,
      DateTime endDate,
      String? description,
      String? notes,
      DateTime createdAt,
      DateTime updatedAt,
      String? ownerId});
}

/// @nodoc
class _$SchoolTermCopyWithImpl<$Res, $Val extends SchoolTerm>
    implements $SchoolTermCopyWith<$Res> {
  _$SchoolTermCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SchoolTerm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? entityType = null,
    Object? schoolId = freezed,
    Object? termName = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? description = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? ownerId = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      entityType: null == entityType
          ? _value.entityType
          : entityType // ignore: cast_nullable_to_non_nullable
              as String,
      schoolId: freezed == schoolId
          ? _value.schoolId
          : schoolId // ignore: cast_nullable_to_non_nullable
              as String?,
      termName: null == termName
          ? _value.termName
          : termName // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      ownerId: freezed == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SchoolTermImplCopyWith<$Res>
    implements $SchoolTermCopyWith<$Res> {
  factory _$$SchoolTermImplCopyWith(
          _$SchoolTermImpl value, $Res Function(_$SchoolTermImpl) then) =
      __$$SchoolTermImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String entityType,
      String? schoolId,
      String termName,
      DateTime startDate,
      DateTime endDate,
      String? description,
      String? notes,
      DateTime createdAt,
      DateTime updatedAt,
      String? ownerId});
}

/// @nodoc
class __$$SchoolTermImplCopyWithImpl<$Res>
    extends _$SchoolTermCopyWithImpl<$Res, _$SchoolTermImpl>
    implements _$$SchoolTermImplCopyWith<$Res> {
  __$$SchoolTermImplCopyWithImpl(
      _$SchoolTermImpl _value, $Res Function(_$SchoolTermImpl) _then)
      : super(_value, _then);

  /// Create a copy of SchoolTerm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? entityType = null,
    Object? schoolId = freezed,
    Object? termName = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? description = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? ownerId = freezed,
  }) {
    return _then(_$SchoolTermImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      entityType: null == entityType
          ? _value.entityType
          : entityType // ignore: cast_nullable_to_non_nullable
              as String,
      schoolId: freezed == schoolId
          ? _value.schoolId
          : schoolId // ignore: cast_nullable_to_non_nullable
              as String?,
      termName: null == termName
          ? _value.termName
          : termName // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      ownerId: freezed == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SchoolTermImpl implements _SchoolTerm {
  const _$SchoolTermImpl(
      {required this.id,
      this.entityType = 'SchoolTerm',
      this.schoolId,
      required this.termName,
      required this.startDate,
      required this.endDate,
      this.description,
      this.notes,
      required this.createdAt,
      required this.updatedAt,
      this.ownerId});

  factory _$SchoolTermImpl.fromJson(Map<String, dynamic> json) =>
      _$$SchoolTermImplFromJson(json);

  @override
  final String id;
// Corresponds to entities.id
  @override
  @JsonKey()
  final String entityType;
  @override
  final String? schoolId;
// FK to entities.id of a School entity
  @override
  final String termName;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final String? description;
// Specific fields from school_term_entities table
  @override
  final String? notes;
// from entities table
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String? ownerId;

  @override
  String toString() {
    return 'SchoolTerm(id: $id, entityType: $entityType, schoolId: $schoolId, termName: $termName, startDate: $startDate, endDate: $endDate, description: $description, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, ownerId: $ownerId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SchoolTermImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.schoolId, schoolId) ||
                other.schoolId == schoolId) &&
            (identical(other.termName, termName) ||
                other.termName == termName) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      entityType,
      schoolId,
      termName,
      startDate,
      endDate,
      description,
      notes,
      createdAt,
      updatedAt,
      ownerId);

  /// Create a copy of SchoolTerm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SchoolTermImplCopyWith<_$SchoolTermImpl> get copyWith =>
      __$$SchoolTermImplCopyWithImpl<_$SchoolTermImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SchoolTermImplToJson(
      this,
    );
  }
}

abstract class _SchoolTerm implements SchoolTerm {
  const factory _SchoolTerm(
      {required final String id,
      final String entityType,
      final String? schoolId,
      required final String termName,
      required final DateTime startDate,
      required final DateTime endDate,
      final String? description,
      final String? notes,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final String? ownerId}) = _$SchoolTermImpl;

  factory _SchoolTerm.fromJson(Map<String, dynamic> json) =
      _$SchoolTermImpl.fromJson;

  @override
  String get id; // Corresponds to entities.id
  @override
  String get entityType;
  @override
  String? get schoolId; // FK to entities.id of a School entity
  @override
  String get termName;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  String? get description; // Specific fields from school_term_entities table
  @override
  String? get notes; // from entities table
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  String? get ownerId;

  /// Create a copy of SchoolTerm
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SchoolTermImplCopyWith<_$SchoolTermImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SchoolBreak _$SchoolBreakFromJson(Map<String, dynamic> json) {
  return _SchoolBreak.fromJson(json);
}

/// @nodoc
mixin _$SchoolBreak {
  String get id =>
      throw _privateConstructorUsedError; // Corresponds to entities.id
  String get entityType => throw _privateConstructorUsedError;
  String? get schoolId =>
      throw _privateConstructorUsedError; // FK to entities.id of a School entity (or could be linked to term)
  String get breakName => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  String? get description =>
      throw _privateConstructorUsedError; // Specific fields from school_break_entities table
  String? get notes =>
      throw _privateConstructorUsedError; // from entities table
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String? get ownerId => throw _privateConstructorUsedError;

  /// Serializes this SchoolBreak to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SchoolBreak
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SchoolBreakCopyWith<SchoolBreak> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SchoolBreakCopyWith<$Res> {
  factory $SchoolBreakCopyWith(
          SchoolBreak value, $Res Function(SchoolBreak) then) =
      _$SchoolBreakCopyWithImpl<$Res, SchoolBreak>;
  @useResult
  $Res call(
      {String id,
      String entityType,
      String? schoolId,
      String breakName,
      DateTime startDate,
      DateTime endDate,
      String? description,
      String? notes,
      DateTime createdAt,
      DateTime updatedAt,
      String? ownerId});
}

/// @nodoc
class _$SchoolBreakCopyWithImpl<$Res, $Val extends SchoolBreak>
    implements $SchoolBreakCopyWith<$Res> {
  _$SchoolBreakCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SchoolBreak
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? entityType = null,
    Object? schoolId = freezed,
    Object? breakName = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? description = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? ownerId = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      entityType: null == entityType
          ? _value.entityType
          : entityType // ignore: cast_nullable_to_non_nullable
              as String,
      schoolId: freezed == schoolId
          ? _value.schoolId
          : schoolId // ignore: cast_nullable_to_non_nullable
              as String?,
      breakName: null == breakName
          ? _value.breakName
          : breakName // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      ownerId: freezed == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SchoolBreakImplCopyWith<$Res>
    implements $SchoolBreakCopyWith<$Res> {
  factory _$$SchoolBreakImplCopyWith(
          _$SchoolBreakImpl value, $Res Function(_$SchoolBreakImpl) then) =
      __$$SchoolBreakImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String entityType,
      String? schoolId,
      String breakName,
      DateTime startDate,
      DateTime endDate,
      String? description,
      String? notes,
      DateTime createdAt,
      DateTime updatedAt,
      String? ownerId});
}

/// @nodoc
class __$$SchoolBreakImplCopyWithImpl<$Res>
    extends _$SchoolBreakCopyWithImpl<$Res, _$SchoolBreakImpl>
    implements _$$SchoolBreakImplCopyWith<$Res> {
  __$$SchoolBreakImplCopyWithImpl(
      _$SchoolBreakImpl _value, $Res Function(_$SchoolBreakImpl) _then)
      : super(_value, _then);

  /// Create a copy of SchoolBreak
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? entityType = null,
    Object? schoolId = freezed,
    Object? breakName = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? description = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? ownerId = freezed,
  }) {
    return _then(_$SchoolBreakImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      entityType: null == entityType
          ? _value.entityType
          : entityType // ignore: cast_nullable_to_non_nullable
              as String,
      schoolId: freezed == schoolId
          ? _value.schoolId
          : schoolId // ignore: cast_nullable_to_non_nullable
              as String?,
      breakName: null == breakName
          ? _value.breakName
          : breakName // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      ownerId: freezed == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SchoolBreakImpl implements _SchoolBreak {
  const _$SchoolBreakImpl(
      {required this.id,
      this.entityType = 'SchoolBreak',
      this.schoolId,
      required this.breakName,
      required this.startDate,
      required this.endDate,
      this.description,
      this.notes,
      required this.createdAt,
      required this.updatedAt,
      this.ownerId});

  factory _$SchoolBreakImpl.fromJson(Map<String, dynamic> json) =>
      _$$SchoolBreakImplFromJson(json);

  @override
  final String id;
// Corresponds to entities.id
  @override
  @JsonKey()
  final String entityType;
  @override
  final String? schoolId;
// FK to entities.id of a School entity (or could be linked to term)
  @override
  final String breakName;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final String? description;
// Specific fields from school_break_entities table
  @override
  final String? notes;
// from entities table
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String? ownerId;

  @override
  String toString() {
    return 'SchoolBreak(id: $id, entityType: $entityType, schoolId: $schoolId, breakName: $breakName, startDate: $startDate, endDate: $endDate, description: $description, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, ownerId: $ownerId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SchoolBreakImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.schoolId, schoolId) ||
                other.schoolId == schoolId) &&
            (identical(other.breakName, breakName) ||
                other.breakName == breakName) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      entityType,
      schoolId,
      breakName,
      startDate,
      endDate,
      description,
      notes,
      createdAt,
      updatedAt,
      ownerId);

  /// Create a copy of SchoolBreak
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SchoolBreakImplCopyWith<_$SchoolBreakImpl> get copyWith =>
      __$$SchoolBreakImplCopyWithImpl<_$SchoolBreakImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SchoolBreakImplToJson(
      this,
    );
  }
}

abstract class _SchoolBreak implements SchoolBreak {
  const factory _SchoolBreak(
      {required final String id,
      final String entityType,
      final String? schoolId,
      required final String breakName,
      required final DateTime startDate,
      required final DateTime endDate,
      final String? description,
      final String? notes,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final String? ownerId}) = _$SchoolBreakImpl;

  factory _SchoolBreak.fromJson(Map<String, dynamic> json) =
      _$SchoolBreakImpl.fromJson;

  @override
  String get id; // Corresponds to entities.id
  @override
  String get entityType;
  @override
  String?
      get schoolId; // FK to entities.id of a School entity (or could be linked to term)
  @override
  String get breakName;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  String? get description; // Specific fields from school_break_entities table
  @override
  String? get notes; // from entities table
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  String? get ownerId;

  /// Create a copy of SchoolBreak
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SchoolBreakImplCopyWith<_$SchoolBreakImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
