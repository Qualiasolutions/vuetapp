// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'family_entities.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Birthday _$BirthdayFromJson(Map<String, dynamic> json) {
  return _Birthday.fromJson(json);
}

/// @nodoc
mixin _$Birthday {
  int? get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  DateTime get dob => throw _privateConstructorUsedError;
  bool get knownYear => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String get resourceType => throw _privateConstructorUsedError;

  /// Serializes this Birthday to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Birthday
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BirthdayCopyWith<Birthday> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BirthdayCopyWith<$Res> {
  factory $BirthdayCopyWith(Birthday value, $Res Function(Birthday) then) =
      _$BirthdayCopyWithImpl<$Res, Birthday>;
  @useResult
  $Res call(
      {int? id,
      String name,
      DateTime dob,
      bool knownYear,
      String? notes,
      String resourceType});
}

/// @nodoc
class _$BirthdayCopyWithImpl<$Res, $Val extends Birthday>
    implements $BirthdayCopyWith<$Res> {
  _$BirthdayCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Birthday
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? dob = null,
    Object? knownYear = null,
    Object? notes = freezed,
    Object? resourceType = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      dob: null == dob
          ? _value.dob
          : dob // ignore: cast_nullable_to_non_nullable
              as DateTime,
      knownYear: null == knownYear
          ? _value.knownYear
          : knownYear // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      resourceType: null == resourceType
          ? _value.resourceType
          : resourceType // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BirthdayImplCopyWith<$Res>
    implements $BirthdayCopyWith<$Res> {
  factory _$$BirthdayImplCopyWith(
          _$BirthdayImpl value, $Res Function(_$BirthdayImpl) then) =
      __$$BirthdayImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String name,
      DateTime dob,
      bool knownYear,
      String? notes,
      String resourceType});
}

/// @nodoc
class __$$BirthdayImplCopyWithImpl<$Res>
    extends _$BirthdayCopyWithImpl<$Res, _$BirthdayImpl>
    implements _$$BirthdayImplCopyWith<$Res> {
  __$$BirthdayImplCopyWithImpl(
      _$BirthdayImpl _value, $Res Function(_$BirthdayImpl) _then)
      : super(_value, _then);

  /// Create a copy of Birthday
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? dob = null,
    Object? knownYear = null,
    Object? notes = freezed,
    Object? resourceType = null,
  }) {
    return _then(_$BirthdayImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      dob: null == dob
          ? _value.dob
          : dob // ignore: cast_nullable_to_non_nullable
              as DateTime,
      knownYear: null == knownYear
          ? _value.knownYear
          : knownYear // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      resourceType: null == resourceType
          ? _value.resourceType
          : resourceType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BirthdayImpl implements _Birthday {
  const _$BirthdayImpl(
      {this.id,
      required this.name,
      required this.dob,
      this.knownYear = true,
      this.notes,
      this.resourceType = 'Birthday'});

  factory _$BirthdayImpl.fromJson(Map<String, dynamic> json) =>
      _$$BirthdayImplFromJson(json);

  @override
  final int? id;
  @override
  final String name;
  @override
  final DateTime dob;
  @override
  @JsonKey()
  final bool knownYear;
  @override
  final String? notes;
  @override
  @JsonKey()
  final String resourceType;

  @override
  String toString() {
    return 'Birthday(id: $id, name: $name, dob: $dob, knownYear: $knownYear, notes: $notes, resourceType: $resourceType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BirthdayImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.dob, dob) || other.dob == dob) &&
            (identical(other.knownYear, knownYear) ||
                other.knownYear == knownYear) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.resourceType, resourceType) ||
                other.resourceType == resourceType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, dob, knownYear, notes, resourceType);

  /// Create a copy of Birthday
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BirthdayImplCopyWith<_$BirthdayImpl> get copyWith =>
      __$$BirthdayImplCopyWithImpl<_$BirthdayImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BirthdayImplToJson(
      this,
    );
  }
}

abstract class _Birthday implements Birthday {
  const factory _Birthday(
      {final int? id,
      required final String name,
      required final DateTime dob,
      final bool knownYear,
      final String? notes,
      final String resourceType}) = _$BirthdayImpl;

  factory _Birthday.fromJson(Map<String, dynamic> json) =
      _$BirthdayImpl.fromJson;

  @override
  int? get id;
  @override
  String get name;
  @override
  DateTime get dob;
  @override
  bool get knownYear;
  @override
  String? get notes;
  @override
  String get resourceType;

  /// Create a copy of Birthday
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BirthdayImplCopyWith<_$BirthdayImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Anniversary _$AnniversaryFromJson(Map<String, dynamic> json) {
  return _Anniversary.fromJson(json);
}

/// @nodoc
mixin _$Anniversary {
  int? get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  bool get knownYear => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String get resourceType => throw _privateConstructorUsedError;

  /// Serializes this Anniversary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Anniversary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnniversaryCopyWith<Anniversary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnniversaryCopyWith<$Res> {
  factory $AnniversaryCopyWith(
          Anniversary value, $Res Function(Anniversary) then) =
      _$AnniversaryCopyWithImpl<$Res, Anniversary>;
  @useResult
  $Res call(
      {int? id,
      String name,
      DateTime date,
      bool knownYear,
      String? notes,
      String resourceType});
}

/// @nodoc
class _$AnniversaryCopyWithImpl<$Res, $Val extends Anniversary>
    implements $AnniversaryCopyWith<$Res> {
  _$AnniversaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Anniversary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? date = null,
    Object? knownYear = null,
    Object? notes = freezed,
    Object? resourceType = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      knownYear: null == knownYear
          ? _value.knownYear
          : knownYear // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      resourceType: null == resourceType
          ? _value.resourceType
          : resourceType // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AnniversaryImplCopyWith<$Res>
    implements $AnniversaryCopyWith<$Res> {
  factory _$$AnniversaryImplCopyWith(
          _$AnniversaryImpl value, $Res Function(_$AnniversaryImpl) then) =
      __$$AnniversaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String name,
      DateTime date,
      bool knownYear,
      String? notes,
      String resourceType});
}

/// @nodoc
class __$$AnniversaryImplCopyWithImpl<$Res>
    extends _$AnniversaryCopyWithImpl<$Res, _$AnniversaryImpl>
    implements _$$AnniversaryImplCopyWith<$Res> {
  __$$AnniversaryImplCopyWithImpl(
      _$AnniversaryImpl _value, $Res Function(_$AnniversaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of Anniversary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? date = null,
    Object? knownYear = null,
    Object? notes = freezed,
    Object? resourceType = null,
  }) {
    return _then(_$AnniversaryImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      knownYear: null == knownYear
          ? _value.knownYear
          : knownYear // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      resourceType: null == resourceType
          ? _value.resourceType
          : resourceType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AnniversaryImpl implements _Anniversary {
  const _$AnniversaryImpl(
      {this.id,
      required this.name,
      required this.date,
      this.knownYear = true,
      this.notes,
      this.resourceType = 'Anniversary'});

  factory _$AnniversaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnniversaryImplFromJson(json);

  @override
  final int? id;
  @override
  final String name;
  @override
  final DateTime date;
  @override
  @JsonKey()
  final bool knownYear;
  @override
  final String? notes;
  @override
  @JsonKey()
  final String resourceType;

  @override
  String toString() {
    return 'Anniversary(id: $id, name: $name, date: $date, knownYear: $knownYear, notes: $notes, resourceType: $resourceType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnniversaryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.knownYear, knownYear) ||
                other.knownYear == knownYear) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.resourceType, resourceType) ||
                other.resourceType == resourceType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, date, knownYear, notes, resourceType);

  /// Create a copy of Anniversary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnniversaryImplCopyWith<_$AnniversaryImpl> get copyWith =>
      __$$AnniversaryImplCopyWithImpl<_$AnniversaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnniversaryImplToJson(
      this,
    );
  }
}

abstract class _Anniversary implements Anniversary {
  const factory _Anniversary(
      {final int? id,
      required final String name,
      required final DateTime date,
      final bool knownYear,
      final String? notes,
      final String resourceType}) = _$AnniversaryImpl;

  factory _Anniversary.fromJson(Map<String, dynamic> json) =
      _$AnniversaryImpl.fromJson;

  @override
  int? get id;
  @override
  String get name;
  @override
  DateTime get date;
  @override
  bool get knownYear;
  @override
  String? get notes;
  @override
  String get resourceType;

  /// Create a copy of Anniversary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnniversaryImplCopyWith<_$AnniversaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Patient _$PatientFromJson(Map<String, dynamic> json) {
  return _Patient.fromJson(json);
}

/// @nodoc
mixin _$Patient {
  int? get id => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String? get medicalNumber => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String get resourceType => throw _privateConstructorUsedError;

  /// Serializes this Patient to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Patient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PatientCopyWith<Patient> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PatientCopyWith<$Res> {
  factory $PatientCopyWith(Patient value, $Res Function(Patient) then) =
      _$PatientCopyWithImpl<$Res, Patient>;
  @useResult
  $Res call(
      {int? id,
      String firstName,
      String lastName,
      String? medicalNumber,
      String? notes,
      String resourceType});
}

/// @nodoc
class _$PatientCopyWithImpl<$Res, $Val extends Patient>
    implements $PatientCopyWith<$Res> {
  _$PatientCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Patient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? firstName = null,
    Object? lastName = null,
    Object? medicalNumber = freezed,
    Object? notes = freezed,
    Object? resourceType = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      medicalNumber: freezed == medicalNumber
          ? _value.medicalNumber
          : medicalNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      resourceType: null == resourceType
          ? _value.resourceType
          : resourceType // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PatientImplCopyWith<$Res> implements $PatientCopyWith<$Res> {
  factory _$$PatientImplCopyWith(
          _$PatientImpl value, $Res Function(_$PatientImpl) then) =
      __$$PatientImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String firstName,
      String lastName,
      String? medicalNumber,
      String? notes,
      String resourceType});
}

/// @nodoc
class __$$PatientImplCopyWithImpl<$Res>
    extends _$PatientCopyWithImpl<$Res, _$PatientImpl>
    implements _$$PatientImplCopyWith<$Res> {
  __$$PatientImplCopyWithImpl(
      _$PatientImpl _value, $Res Function(_$PatientImpl) _then)
      : super(_value, _then);

  /// Create a copy of Patient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? firstName = null,
    Object? lastName = null,
    Object? medicalNumber = freezed,
    Object? notes = freezed,
    Object? resourceType = null,
  }) {
    return _then(_$PatientImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      medicalNumber: freezed == medicalNumber
          ? _value.medicalNumber
          : medicalNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      resourceType: null == resourceType
          ? _value.resourceType
          : resourceType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PatientImpl implements _Patient {
  const _$PatientImpl(
      {this.id,
      required this.firstName,
      required this.lastName,
      this.medicalNumber,
      this.notes,
      this.resourceType = 'Patient'});

  factory _$PatientImpl.fromJson(Map<String, dynamic> json) =>
      _$$PatientImplFromJson(json);

  @override
  final int? id;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String? medicalNumber;
  @override
  final String? notes;
  @override
  @JsonKey()
  final String resourceType;

  @override
  String toString() {
    return 'Patient(id: $id, firstName: $firstName, lastName: $lastName, medicalNumber: $medicalNumber, notes: $notes, resourceType: $resourceType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PatientImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.medicalNumber, medicalNumber) ||
                other.medicalNumber == medicalNumber) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.resourceType, resourceType) ||
                other.resourceType == resourceType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, firstName, lastName, medicalNumber, notes, resourceType);

  /// Create a copy of Patient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PatientImplCopyWith<_$PatientImpl> get copyWith =>
      __$$PatientImplCopyWithImpl<_$PatientImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PatientImplToJson(
      this,
    );
  }
}

abstract class _Patient implements Patient {
  const factory _Patient(
      {final int? id,
      required final String firstName,
      required final String lastName,
      final String? medicalNumber,
      final String? notes,
      final String resourceType}) = _$PatientImpl;

  factory _Patient.fromJson(Map<String, dynamic> json) = _$PatientImpl.fromJson;

  @override
  int? get id;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String? get medicalNumber;
  @override
  String? get notes;
  @override
  String get resourceType;

  /// Create a copy of Patient
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PatientImplCopyWith<_$PatientImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Appointment _$AppointmentFromJson(Map<String, dynamic> json) {
  return _Appointment.fromJson(json);
}

/// @nodoc
mixin _$Appointment {
  int? get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  DateTime get startDatetime => throw _privateConstructorUsedError;
  DateTime get endDatetime => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  List<int>? get patientIds =>
      throw _privateConstructorUsedError; // Links to Patient entities
  String get resourceType => throw _privateConstructorUsedError;

  /// Serializes this Appointment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Appointment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppointmentCopyWith<Appointment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppointmentCopyWith<$Res> {
  factory $AppointmentCopyWith(
          Appointment value, $Res Function(Appointment) then) =
      _$AppointmentCopyWithImpl<$Res, Appointment>;
  @useResult
  $Res call(
      {int? id,
      String title,
      DateTime startDatetime,
      DateTime endDatetime,
      String? location,
      String? notes,
      List<int>? patientIds,
      String resourceType});
}

/// @nodoc
class _$AppointmentCopyWithImpl<$Res, $Val extends Appointment>
    implements $AppointmentCopyWith<$Res> {
  _$AppointmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Appointment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = null,
    Object? startDatetime = null,
    Object? endDatetime = null,
    Object? location = freezed,
    Object? notes = freezed,
    Object? patientIds = freezed,
    Object? resourceType = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      startDatetime: null == startDatetime
          ? _value.startDatetime
          : startDatetime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDatetime: null == endDatetime
          ? _value.endDatetime
          : endDatetime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      patientIds: freezed == patientIds
          ? _value.patientIds
          : patientIds // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      resourceType: null == resourceType
          ? _value.resourceType
          : resourceType // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppointmentImplCopyWith<$Res>
    implements $AppointmentCopyWith<$Res> {
  factory _$$AppointmentImplCopyWith(
          _$AppointmentImpl value, $Res Function(_$AppointmentImpl) then) =
      __$$AppointmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String title,
      DateTime startDatetime,
      DateTime endDatetime,
      String? location,
      String? notes,
      List<int>? patientIds,
      String resourceType});
}

/// @nodoc
class __$$AppointmentImplCopyWithImpl<$Res>
    extends _$AppointmentCopyWithImpl<$Res, _$AppointmentImpl>
    implements _$$AppointmentImplCopyWith<$Res> {
  __$$AppointmentImplCopyWithImpl(
      _$AppointmentImpl _value, $Res Function(_$AppointmentImpl) _then)
      : super(_value, _then);

  /// Create a copy of Appointment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = null,
    Object? startDatetime = null,
    Object? endDatetime = null,
    Object? location = freezed,
    Object? notes = freezed,
    Object? patientIds = freezed,
    Object? resourceType = null,
  }) {
    return _then(_$AppointmentImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      startDatetime: null == startDatetime
          ? _value.startDatetime
          : startDatetime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDatetime: null == endDatetime
          ? _value.endDatetime
          : endDatetime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      patientIds: freezed == patientIds
          ? _value._patientIds
          : patientIds // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      resourceType: null == resourceType
          ? _value.resourceType
          : resourceType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppointmentImpl implements _Appointment {
  const _$AppointmentImpl(
      {this.id,
      required this.title,
      required this.startDatetime,
      required this.endDatetime,
      this.location,
      this.notes,
      final List<int>? patientIds,
      this.resourceType = 'Appointment'})
      : _patientIds = patientIds;

  factory _$AppointmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppointmentImplFromJson(json);

  @override
  final int? id;
  @override
  final String title;
  @override
  final DateTime startDatetime;
  @override
  final DateTime endDatetime;
  @override
  final String? location;
  @override
  final String? notes;
  final List<int>? _patientIds;
  @override
  List<int>? get patientIds {
    final value = _patientIds;
    if (value == null) return null;
    if (_patientIds is EqualUnmodifiableListView) return _patientIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// Links to Patient entities
  @override
  @JsonKey()
  final String resourceType;

  @override
  String toString() {
    return 'Appointment(id: $id, title: $title, startDatetime: $startDatetime, endDatetime: $endDatetime, location: $location, notes: $notes, patientIds: $patientIds, resourceType: $resourceType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppointmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.startDatetime, startDatetime) ||
                other.startDatetime == startDatetime) &&
            (identical(other.endDatetime, endDatetime) ||
                other.endDatetime == endDatetime) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality()
                .equals(other._patientIds, _patientIds) &&
            (identical(other.resourceType, resourceType) ||
                other.resourceType == resourceType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      startDatetime,
      endDatetime,
      location,
      notes,
      const DeepCollectionEquality().hash(_patientIds),
      resourceType);

  /// Create a copy of Appointment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppointmentImplCopyWith<_$AppointmentImpl> get copyWith =>
      __$$AppointmentImplCopyWithImpl<_$AppointmentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppointmentImplToJson(
      this,
    );
  }
}

abstract class _Appointment implements Appointment {
  const factory _Appointment(
      {final int? id,
      required final String title,
      required final DateTime startDatetime,
      required final DateTime endDatetime,
      final String? location,
      final String? notes,
      final List<int>? patientIds,
      final String resourceType}) = _$AppointmentImpl;

  factory _Appointment.fromJson(Map<String, dynamic> json) =
      _$AppointmentImpl.fromJson;

  @override
  int? get id;
  @override
  String get title;
  @override
  DateTime get startDatetime;
  @override
  DateTime get endDatetime;
  @override
  String? get location;
  @override
  String? get notes;
  @override
  List<int>? get patientIds; // Links to Patient entities
  @override
  String get resourceType;

  /// Create a copy of Appointment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppointmentImplCopyWith<_$AppointmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FamilyMember _$FamilyMemberFromJson(Map<String, dynamic> json) {
  return _FamilyMember.fromJson(json);
}

/// @nodoc
mixin _$FamilyMember {
  int? get id => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String? get relationship => throw _privateConstructorUsedError;
  DateTime? get dateOfBirth => throw _privateConstructorUsedError;
  String? get phoneNumber => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String get resourceType => throw _privateConstructorUsedError;

  /// Serializes this FamilyMember to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FamilyMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FamilyMemberCopyWith<FamilyMember> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FamilyMemberCopyWith<$Res> {
  factory $FamilyMemberCopyWith(
          FamilyMember value, $Res Function(FamilyMember) then) =
      _$FamilyMemberCopyWithImpl<$Res, FamilyMember>;
  @useResult
  $Res call(
      {int? id,
      String firstName,
      String lastName,
      String? relationship,
      DateTime? dateOfBirth,
      String? phoneNumber,
      String? email,
      String? notes,
      String resourceType});
}

/// @nodoc
class _$FamilyMemberCopyWithImpl<$Res, $Val extends FamilyMember>
    implements $FamilyMemberCopyWith<$Res> {
  _$FamilyMemberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FamilyMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? firstName = null,
    Object? lastName = null,
    Object? relationship = freezed,
    Object? dateOfBirth = freezed,
    Object? phoneNumber = freezed,
    Object? email = freezed,
    Object? notes = freezed,
    Object? resourceType = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      relationship: freezed == relationship
          ? _value.relationship
          : relationship // ignore: cast_nullable_to_non_nullable
              as String?,
      dateOfBirth: freezed == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      resourceType: null == resourceType
          ? _value.resourceType
          : resourceType // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FamilyMemberImplCopyWith<$Res>
    implements $FamilyMemberCopyWith<$Res> {
  factory _$$FamilyMemberImplCopyWith(
          _$FamilyMemberImpl value, $Res Function(_$FamilyMemberImpl) then) =
      __$$FamilyMemberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String firstName,
      String lastName,
      String? relationship,
      DateTime? dateOfBirth,
      String? phoneNumber,
      String? email,
      String? notes,
      String resourceType});
}

/// @nodoc
class __$$FamilyMemberImplCopyWithImpl<$Res>
    extends _$FamilyMemberCopyWithImpl<$Res, _$FamilyMemberImpl>
    implements _$$FamilyMemberImplCopyWith<$Res> {
  __$$FamilyMemberImplCopyWithImpl(
      _$FamilyMemberImpl _value, $Res Function(_$FamilyMemberImpl) _then)
      : super(_value, _then);

  /// Create a copy of FamilyMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? firstName = null,
    Object? lastName = null,
    Object? relationship = freezed,
    Object? dateOfBirth = freezed,
    Object? phoneNumber = freezed,
    Object? email = freezed,
    Object? notes = freezed,
    Object? resourceType = null,
  }) {
    return _then(_$FamilyMemberImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      relationship: freezed == relationship
          ? _value.relationship
          : relationship // ignore: cast_nullable_to_non_nullable
              as String?,
      dateOfBirth: freezed == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      resourceType: null == resourceType
          ? _value.resourceType
          : resourceType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FamilyMemberImpl implements _FamilyMember {
  const _$FamilyMemberImpl(
      {this.id,
      required this.firstName,
      required this.lastName,
      this.relationship,
      this.dateOfBirth,
      this.phoneNumber,
      this.email,
      this.notes,
      this.resourceType = 'FamilyMember'});

  factory _$FamilyMemberImpl.fromJson(Map<String, dynamic> json) =>
      _$$FamilyMemberImplFromJson(json);

  @override
  final int? id;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String? relationship;
  @override
  final DateTime? dateOfBirth;
  @override
  final String? phoneNumber;
  @override
  final String? email;
  @override
  final String? notes;
  @override
  @JsonKey()
  final String resourceType;

  @override
  String toString() {
    return 'FamilyMember(id: $id, firstName: $firstName, lastName: $lastName, relationship: $relationship, dateOfBirth: $dateOfBirth, phoneNumber: $phoneNumber, email: $email, notes: $notes, resourceType: $resourceType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FamilyMemberImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.relationship, relationship) ||
                other.relationship == relationship) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.resourceType, resourceType) ||
                other.resourceType == resourceType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, firstName, lastName,
      relationship, dateOfBirth, phoneNumber, email, notes, resourceType);

  /// Create a copy of FamilyMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FamilyMemberImplCopyWith<_$FamilyMemberImpl> get copyWith =>
      __$$FamilyMemberImplCopyWithImpl<_$FamilyMemberImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FamilyMemberImplToJson(
      this,
    );
  }
}

abstract class _FamilyMember implements FamilyMember {
  const factory _FamilyMember(
      {final int? id,
      required final String firstName,
      required final String lastName,
      final String? relationship,
      final DateTime? dateOfBirth,
      final String? phoneNumber,
      final String? email,
      final String? notes,
      final String resourceType}) = _$FamilyMemberImpl;

  factory _FamilyMember.fromJson(Map<String, dynamic> json) =
      _$FamilyMemberImpl.fromJson;

  @override
  int? get id;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String? get relationship;
  @override
  DateTime? get dateOfBirth;
  @override
  String? get phoneNumber;
  @override
  String? get email;
  @override
  String? get notes;
  @override
  String get resourceType;

  /// Create a copy of FamilyMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FamilyMemberImplCopyWith<_$FamilyMemberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
