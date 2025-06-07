// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pet_entities.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Pet _$PetFromJson(Map<String, dynamic> json) {
  return _Pet.fromJson(json);
}

/// @nodoc
mixin _$Pet {
  int? get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError; // Dog, Cat, Bird, etc.
  String? get breed => throw _privateConstructorUsedError;
  DateTime? get dob => throw _privateConstructorUsedError;
  String? get microchipNumber => throw _privateConstructorUsedError;
  int? get vetId => throw _privateConstructorUsedError; // Links to Vet entity
  String? get notes => throw _privateConstructorUsedError;
  String get resourceType => throw _privateConstructorUsedError;

  /// Serializes this Pet to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Pet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PetCopyWith<Pet> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PetCopyWith<$Res> {
  factory $PetCopyWith(Pet value, $Res Function(Pet) then) =
      _$PetCopyWithImpl<$Res, Pet>;
  @useResult
  $Res call(
      {int? id,
      String name,
      String type,
      String? breed,
      DateTime? dob,
      String? microchipNumber,
      int? vetId,
      String? notes,
      String resourceType});
}

/// @nodoc
class _$PetCopyWithImpl<$Res, $Val extends Pet> implements $PetCopyWith<$Res> {
  _$PetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Pet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? type = null,
    Object? breed = freezed,
    Object? dob = freezed,
    Object? microchipNumber = freezed,
    Object? vetId = freezed,
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      breed: freezed == breed
          ? _value.breed
          : breed // ignore: cast_nullable_to_non_nullable
              as String?,
      dob: freezed == dob
          ? _value.dob
          : dob // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      microchipNumber: freezed == microchipNumber
          ? _value.microchipNumber
          : microchipNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      vetId: freezed == vetId
          ? _value.vetId
          : vetId // ignore: cast_nullable_to_non_nullable
              as int?,
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
abstract class _$$PetImplCopyWith<$Res> implements $PetCopyWith<$Res> {
  factory _$$PetImplCopyWith(_$PetImpl value, $Res Function(_$PetImpl) then) =
      __$$PetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String name,
      String type,
      String? breed,
      DateTime? dob,
      String? microchipNumber,
      int? vetId,
      String? notes,
      String resourceType});
}

/// @nodoc
class __$$PetImplCopyWithImpl<$Res> extends _$PetCopyWithImpl<$Res, _$PetImpl>
    implements _$$PetImplCopyWith<$Res> {
  __$$PetImplCopyWithImpl(_$PetImpl _value, $Res Function(_$PetImpl) _then)
      : super(_value, _then);

  /// Create a copy of Pet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? type = null,
    Object? breed = freezed,
    Object? dob = freezed,
    Object? microchipNumber = freezed,
    Object? vetId = freezed,
    Object? notes = freezed,
    Object? resourceType = null,
  }) {
    return _then(_$PetImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      breed: freezed == breed
          ? _value.breed
          : breed // ignore: cast_nullable_to_non_nullable
              as String?,
      dob: freezed == dob
          ? _value.dob
          : dob // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      microchipNumber: freezed == microchipNumber
          ? _value.microchipNumber
          : microchipNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      vetId: freezed == vetId
          ? _value.vetId
          : vetId // ignore: cast_nullable_to_non_nullable
              as int?,
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
class _$PetImpl implements _Pet {
  const _$PetImpl(
      {this.id,
      required this.name,
      required this.type,
      this.breed,
      this.dob,
      this.microchipNumber,
      this.vetId,
      this.notes,
      this.resourceType = 'Pet'});

  factory _$PetImpl.fromJson(Map<String, dynamic> json) =>
      _$$PetImplFromJson(json);

  @override
  final int? id;
  @override
  final String name;
  @override
  final String type;
// Dog, Cat, Bird, etc.
  @override
  final String? breed;
  @override
  final DateTime? dob;
  @override
  final String? microchipNumber;
  @override
  final int? vetId;
// Links to Vet entity
  @override
  final String? notes;
  @override
  @JsonKey()
  final String resourceType;

  @override
  String toString() {
    return 'Pet(id: $id, name: $name, type: $type, breed: $breed, dob: $dob, microchipNumber: $microchipNumber, vetId: $vetId, notes: $notes, resourceType: $resourceType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PetImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.breed, breed) || other.breed == breed) &&
            (identical(other.dob, dob) || other.dob == dob) &&
            (identical(other.microchipNumber, microchipNumber) ||
                other.microchipNumber == microchipNumber) &&
            (identical(other.vetId, vetId) || other.vetId == vetId) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.resourceType, resourceType) ||
                other.resourceType == resourceType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, type, breed, dob,
      microchipNumber, vetId, notes, resourceType);

  /// Create a copy of Pet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PetImplCopyWith<_$PetImpl> get copyWith =>
      __$$PetImplCopyWithImpl<_$PetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PetImplToJson(
      this,
    );
  }
}

abstract class _Pet implements Pet {
  const factory _Pet(
      {final int? id,
      required final String name,
      required final String type,
      final String? breed,
      final DateTime? dob,
      final String? microchipNumber,
      final int? vetId,
      final String? notes,
      final String resourceType}) = _$PetImpl;

  factory _Pet.fromJson(Map<String, dynamic> json) = _$PetImpl.fromJson;

  @override
  int? get id;
  @override
  String get name;
  @override
  String get type; // Dog, Cat, Bird, etc.
  @override
  String? get breed;
  @override
  DateTime? get dob;
  @override
  String? get microchipNumber;
  @override
  int? get vetId; // Links to Vet entity
  @override
  String? get notes;
  @override
  String get resourceType;

  /// Create a copy of Pet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PetImplCopyWith<_$PetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Vet _$VetFromJson(Map<String, dynamic> json) {
  return _Vet.fromJson(json);
}

/// @nodoc
mixin _$Vet {
  int? get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String get resourceType => throw _privateConstructorUsedError;

  /// Serializes this Vet to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Vet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VetCopyWith<Vet> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VetCopyWith<$Res> {
  factory $VetCopyWith(Vet value, $Res Function(Vet) then) =
      _$VetCopyWithImpl<$Res, Vet>;
  @useResult
  $Res call(
      {int? id,
      String name,
      String? phone,
      String? address,
      String? email,
      String? notes,
      String resourceType});
}

/// @nodoc
class _$VetCopyWithImpl<$Res, $Val extends Vet> implements $VetCopyWith<$Res> {
  _$VetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Vet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? phone = freezed,
    Object? address = freezed,
    Object? email = freezed,
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
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
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
abstract class _$$VetImplCopyWith<$Res> implements $VetCopyWith<$Res> {
  factory _$$VetImplCopyWith(_$VetImpl value, $Res Function(_$VetImpl) then) =
      __$$VetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String name,
      String? phone,
      String? address,
      String? email,
      String? notes,
      String resourceType});
}

/// @nodoc
class __$$VetImplCopyWithImpl<$Res> extends _$VetCopyWithImpl<$Res, _$VetImpl>
    implements _$$VetImplCopyWith<$Res> {
  __$$VetImplCopyWithImpl(_$VetImpl _value, $Res Function(_$VetImpl) _then)
      : super(_value, _then);

  /// Create a copy of Vet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? phone = freezed,
    Object? address = freezed,
    Object? email = freezed,
    Object? notes = freezed,
    Object? resourceType = null,
  }) {
    return _then(_$VetImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
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
class _$VetImpl implements _Vet {
  const _$VetImpl(
      {this.id,
      required this.name,
      this.phone,
      this.address,
      this.email,
      this.notes,
      this.resourceType = 'Vet'});

  factory _$VetImpl.fromJson(Map<String, dynamic> json) =>
      _$$VetImplFromJson(json);

  @override
  final int? id;
  @override
  final String name;
  @override
  final String? phone;
  @override
  final String? address;
  @override
  final String? email;
  @override
  final String? notes;
  @override
  @JsonKey()
  final String resourceType;

  @override
  String toString() {
    return 'Vet(id: $id, name: $name, phone: $phone, address: $address, email: $email, notes: $notes, resourceType: $resourceType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VetImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.resourceType, resourceType) ||
                other.resourceType == resourceType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, phone, address, email, notes, resourceType);

  /// Create a copy of Vet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VetImplCopyWith<_$VetImpl> get copyWith =>
      __$$VetImplCopyWithImpl<_$VetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VetImplToJson(
      this,
    );
  }
}

abstract class _Vet implements Vet {
  const factory _Vet(
      {final int? id,
      required final String name,
      final String? phone,
      final String? address,
      final String? email,
      final String? notes,
      final String resourceType}) = _$VetImpl;

  factory _Vet.fromJson(Map<String, dynamic> json) = _$VetImpl.fromJson;

  @override
  int? get id;
  @override
  String get name;
  @override
  String? get phone;
  @override
  String? get address;
  @override
  String? get email;
  @override
  String? get notes;
  @override
  String get resourceType;

  /// Create a copy of Vet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VetImplCopyWith<_$VetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PetAppointment _$PetAppointmentFromJson(Map<String, dynamic> json) {
  return _PetAppointment.fromJson(json);
}

/// @nodoc
mixin _$PetAppointment {
  int? get id => throw _privateConstructorUsedError;
  int get petId => throw _privateConstructorUsedError;
  int get vetId => throw _privateConstructorUsedError;
  DateTime get appointmentDatetime => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // Checkup, Vaccination, Surgery, etc.
  String? get notes => throw _privateConstructorUsedError;
  String get resourceType => throw _privateConstructorUsedError;

  /// Serializes this PetAppointment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PetAppointment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PetAppointmentCopyWith<PetAppointment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PetAppointmentCopyWith<$Res> {
  factory $PetAppointmentCopyWith(
          PetAppointment value, $Res Function(PetAppointment) then) =
      _$PetAppointmentCopyWithImpl<$Res, PetAppointment>;
  @useResult
  $Res call(
      {int? id,
      int petId,
      int vetId,
      DateTime appointmentDatetime,
      String type,
      String? notes,
      String resourceType});
}

/// @nodoc
class _$PetAppointmentCopyWithImpl<$Res, $Val extends PetAppointment>
    implements $PetAppointmentCopyWith<$Res> {
  _$PetAppointmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PetAppointment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? petId = null,
    Object? vetId = null,
    Object? appointmentDatetime = null,
    Object? type = null,
    Object? notes = freezed,
    Object? resourceType = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      petId: null == petId
          ? _value.petId
          : petId // ignore: cast_nullable_to_non_nullable
              as int,
      vetId: null == vetId
          ? _value.vetId
          : vetId // ignore: cast_nullable_to_non_nullable
              as int,
      appointmentDatetime: null == appointmentDatetime
          ? _value.appointmentDatetime
          : appointmentDatetime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
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
abstract class _$$PetAppointmentImplCopyWith<$Res>
    implements $PetAppointmentCopyWith<$Res> {
  factory _$$PetAppointmentImplCopyWith(_$PetAppointmentImpl value,
          $Res Function(_$PetAppointmentImpl) then) =
      __$$PetAppointmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      int petId,
      int vetId,
      DateTime appointmentDatetime,
      String type,
      String? notes,
      String resourceType});
}

/// @nodoc
class __$$PetAppointmentImplCopyWithImpl<$Res>
    extends _$PetAppointmentCopyWithImpl<$Res, _$PetAppointmentImpl>
    implements _$$PetAppointmentImplCopyWith<$Res> {
  __$$PetAppointmentImplCopyWithImpl(
      _$PetAppointmentImpl _value, $Res Function(_$PetAppointmentImpl) _then)
      : super(_value, _then);

  /// Create a copy of PetAppointment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? petId = null,
    Object? vetId = null,
    Object? appointmentDatetime = null,
    Object? type = null,
    Object? notes = freezed,
    Object? resourceType = null,
  }) {
    return _then(_$PetAppointmentImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      petId: null == petId
          ? _value.petId
          : petId // ignore: cast_nullable_to_non_nullable
              as int,
      vetId: null == vetId
          ? _value.vetId
          : vetId // ignore: cast_nullable_to_non_nullable
              as int,
      appointmentDatetime: null == appointmentDatetime
          ? _value.appointmentDatetime
          : appointmentDatetime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
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
class _$PetAppointmentImpl implements _PetAppointment {
  const _$PetAppointmentImpl(
      {this.id,
      required this.petId,
      required this.vetId,
      required this.appointmentDatetime,
      required this.type,
      this.notes,
      this.resourceType = 'PetAppointment'});

  factory _$PetAppointmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$PetAppointmentImplFromJson(json);

  @override
  final int? id;
  @override
  final int petId;
  @override
  final int vetId;
  @override
  final DateTime appointmentDatetime;
  @override
  final String type;
// Checkup, Vaccination, Surgery, etc.
  @override
  final String? notes;
  @override
  @JsonKey()
  final String resourceType;

  @override
  String toString() {
    return 'PetAppointment(id: $id, petId: $petId, vetId: $vetId, appointmentDatetime: $appointmentDatetime, type: $type, notes: $notes, resourceType: $resourceType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PetAppointmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.petId, petId) || other.petId == petId) &&
            (identical(other.vetId, vetId) || other.vetId == vetId) &&
            (identical(other.appointmentDatetime, appointmentDatetime) ||
                other.appointmentDatetime == appointmentDatetime) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.resourceType, resourceType) ||
                other.resourceType == resourceType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, petId, vetId,
      appointmentDatetime, type, notes, resourceType);

  /// Create a copy of PetAppointment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PetAppointmentImplCopyWith<_$PetAppointmentImpl> get copyWith =>
      __$$PetAppointmentImplCopyWithImpl<_$PetAppointmentImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PetAppointmentImplToJson(
      this,
    );
  }
}

abstract class _PetAppointment implements PetAppointment {
  const factory _PetAppointment(
      {final int? id,
      required final int petId,
      required final int vetId,
      required final DateTime appointmentDatetime,
      required final String type,
      final String? notes,
      final String resourceType}) = _$PetAppointmentImpl;

  factory _PetAppointment.fromJson(Map<String, dynamic> json) =
      _$PetAppointmentImpl.fromJson;

  @override
  int? get id;
  @override
  int get petId;
  @override
  int get vetId;
  @override
  DateTime get appointmentDatetime;
  @override
  String get type; // Checkup, Vaccination, Surgery, etc.
  @override
  String? get notes;
  @override
  String get resourceType;

  /// Create a copy of PetAppointment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PetAppointmentImplCopyWith<_$PetAppointmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PetWalker _$PetWalkerFromJson(Map<String, dynamic> json) {
  return _PetWalker.fromJson(json);
}

/// @nodoc
mixin _$PetWalker {
  int? get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  double? get hourlyRate => throw _privateConstructorUsedError;
  String? get availability => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String get resourceType => throw _privateConstructorUsedError;

  /// Serializes this PetWalker to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PetWalker
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PetWalkerCopyWith<PetWalker> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PetWalkerCopyWith<$Res> {
  factory $PetWalkerCopyWith(PetWalker value, $Res Function(PetWalker) then) =
      _$PetWalkerCopyWithImpl<$Res, PetWalker>;
  @useResult
  $Res call(
      {int? id,
      String name,
      String? phone,
      String? email,
      double? hourlyRate,
      String? availability,
      String? notes,
      String resourceType});
}

/// @nodoc
class _$PetWalkerCopyWithImpl<$Res, $Val extends PetWalker>
    implements $PetWalkerCopyWith<$Res> {
  _$PetWalkerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PetWalker
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? phone = freezed,
    Object? email = freezed,
    Object? hourlyRate = freezed,
    Object? availability = freezed,
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
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      hourlyRate: freezed == hourlyRate
          ? _value.hourlyRate
          : hourlyRate // ignore: cast_nullable_to_non_nullable
              as double?,
      availability: freezed == availability
          ? _value.availability
          : availability // ignore: cast_nullable_to_non_nullable
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
abstract class _$$PetWalkerImplCopyWith<$Res>
    implements $PetWalkerCopyWith<$Res> {
  factory _$$PetWalkerImplCopyWith(
          _$PetWalkerImpl value, $Res Function(_$PetWalkerImpl) then) =
      __$$PetWalkerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String name,
      String? phone,
      String? email,
      double? hourlyRate,
      String? availability,
      String? notes,
      String resourceType});
}

/// @nodoc
class __$$PetWalkerImplCopyWithImpl<$Res>
    extends _$PetWalkerCopyWithImpl<$Res, _$PetWalkerImpl>
    implements _$$PetWalkerImplCopyWith<$Res> {
  __$$PetWalkerImplCopyWithImpl(
      _$PetWalkerImpl _value, $Res Function(_$PetWalkerImpl) _then)
      : super(_value, _then);

  /// Create a copy of PetWalker
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? phone = freezed,
    Object? email = freezed,
    Object? hourlyRate = freezed,
    Object? availability = freezed,
    Object? notes = freezed,
    Object? resourceType = null,
  }) {
    return _then(_$PetWalkerImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      hourlyRate: freezed == hourlyRate
          ? _value.hourlyRate
          : hourlyRate // ignore: cast_nullable_to_non_nullable
              as double?,
      availability: freezed == availability
          ? _value.availability
          : availability // ignore: cast_nullable_to_non_nullable
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
class _$PetWalkerImpl implements _PetWalker {
  const _$PetWalkerImpl(
      {this.id,
      required this.name,
      this.phone,
      this.email,
      this.hourlyRate,
      this.availability,
      this.notes,
      this.resourceType = 'PetWalker'});

  factory _$PetWalkerImpl.fromJson(Map<String, dynamic> json) =>
      _$$PetWalkerImplFromJson(json);

  @override
  final int? id;
  @override
  final String name;
  @override
  final String? phone;
  @override
  final String? email;
  @override
  final double? hourlyRate;
  @override
  final String? availability;
  @override
  final String? notes;
  @override
  @JsonKey()
  final String resourceType;

  @override
  String toString() {
    return 'PetWalker(id: $id, name: $name, phone: $phone, email: $email, hourlyRate: $hourlyRate, availability: $availability, notes: $notes, resourceType: $resourceType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PetWalkerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.hourlyRate, hourlyRate) ||
                other.hourlyRate == hourlyRate) &&
            (identical(other.availability, availability) ||
                other.availability == availability) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.resourceType, resourceType) ||
                other.resourceType == resourceType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, phone, email,
      hourlyRate, availability, notes, resourceType);

  /// Create a copy of PetWalker
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PetWalkerImplCopyWith<_$PetWalkerImpl> get copyWith =>
      __$$PetWalkerImplCopyWithImpl<_$PetWalkerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PetWalkerImplToJson(
      this,
    );
  }
}

abstract class _PetWalker implements PetWalker {
  const factory _PetWalker(
      {final int? id,
      required final String name,
      final String? phone,
      final String? email,
      final double? hourlyRate,
      final String? availability,
      final String? notes,
      final String resourceType}) = _$PetWalkerImpl;

  factory _PetWalker.fromJson(Map<String, dynamic> json) =
      _$PetWalkerImpl.fromJson;

  @override
  int? get id;
  @override
  String get name;
  @override
  String? get phone;
  @override
  String? get email;
  @override
  double? get hourlyRate;
  @override
  String? get availability;
  @override
  String? get notes;
  @override
  String get resourceType;

  /// Create a copy of PetWalker
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PetWalkerImplCopyWith<_$PetWalkerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PetGroomer _$PetGroomerFromJson(Map<String, dynamic> json) {
  return _PetGroomer.fromJson(json);
}

/// @nodoc
mixin _$PetGroomer {
  int? get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get services =>
      throw _privateConstructorUsedError; // Bathing, Nail trimming, Hair cutting, etc.
  String? get notes => throw _privateConstructorUsedError;
  String get resourceType => throw _privateConstructorUsedError;

  /// Serializes this PetGroomer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PetGroomer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PetGroomerCopyWith<PetGroomer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PetGroomerCopyWith<$Res> {
  factory $PetGroomerCopyWith(
          PetGroomer value, $Res Function(PetGroomer) then) =
      _$PetGroomerCopyWithImpl<$Res, PetGroomer>;
  @useResult
  $Res call(
      {int? id,
      String name,
      String? phone,
      String? address,
      String? email,
      String? services,
      String? notes,
      String resourceType});
}

/// @nodoc
class _$PetGroomerCopyWithImpl<$Res, $Val extends PetGroomer>
    implements $PetGroomerCopyWith<$Res> {
  _$PetGroomerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PetGroomer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? phone = freezed,
    Object? address = freezed,
    Object? email = freezed,
    Object? services = freezed,
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
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      services: freezed == services
          ? _value.services
          : services // ignore: cast_nullable_to_non_nullable
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
abstract class _$$PetGroomerImplCopyWith<$Res>
    implements $PetGroomerCopyWith<$Res> {
  factory _$$PetGroomerImplCopyWith(
          _$PetGroomerImpl value, $Res Function(_$PetGroomerImpl) then) =
      __$$PetGroomerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String name,
      String? phone,
      String? address,
      String? email,
      String? services,
      String? notes,
      String resourceType});
}

/// @nodoc
class __$$PetGroomerImplCopyWithImpl<$Res>
    extends _$PetGroomerCopyWithImpl<$Res, _$PetGroomerImpl>
    implements _$$PetGroomerImplCopyWith<$Res> {
  __$$PetGroomerImplCopyWithImpl(
      _$PetGroomerImpl _value, $Res Function(_$PetGroomerImpl) _then)
      : super(_value, _then);

  /// Create a copy of PetGroomer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? phone = freezed,
    Object? address = freezed,
    Object? email = freezed,
    Object? services = freezed,
    Object? notes = freezed,
    Object? resourceType = null,
  }) {
    return _then(_$PetGroomerImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      services: freezed == services
          ? _value.services
          : services // ignore: cast_nullable_to_non_nullable
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
class _$PetGroomerImpl implements _PetGroomer {
  const _$PetGroomerImpl(
      {this.id,
      required this.name,
      this.phone,
      this.address,
      this.email,
      this.services,
      this.notes,
      this.resourceType = 'PetGroomer'});

  factory _$PetGroomerImpl.fromJson(Map<String, dynamic> json) =>
      _$$PetGroomerImplFromJson(json);

  @override
  final int? id;
  @override
  final String name;
  @override
  final String? phone;
  @override
  final String? address;
  @override
  final String? email;
  @override
  final String? services;
// Bathing, Nail trimming, Hair cutting, etc.
  @override
  final String? notes;
  @override
  @JsonKey()
  final String resourceType;

  @override
  String toString() {
    return 'PetGroomer(id: $id, name: $name, phone: $phone, address: $address, email: $email, services: $services, notes: $notes, resourceType: $resourceType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PetGroomerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.services, services) ||
                other.services == services) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.resourceType, resourceType) ||
                other.resourceType == resourceType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, phone, address, email,
      services, notes, resourceType);

  /// Create a copy of PetGroomer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PetGroomerImplCopyWith<_$PetGroomerImpl> get copyWith =>
      __$$PetGroomerImplCopyWithImpl<_$PetGroomerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PetGroomerImplToJson(
      this,
    );
  }
}

abstract class _PetGroomer implements PetGroomer {
  const factory _PetGroomer(
      {final int? id,
      required final String name,
      final String? phone,
      final String? address,
      final String? email,
      final String? services,
      final String? notes,
      final String resourceType}) = _$PetGroomerImpl;

  factory _PetGroomer.fromJson(Map<String, dynamic> json) =
      _$PetGroomerImpl.fromJson;

  @override
  int? get id;
  @override
  String get name;
  @override
  String? get phone;
  @override
  String? get address;
  @override
  String? get email;
  @override
  String? get services; // Bathing, Nail trimming, Hair cutting, etc.
  @override
  String? get notes;
  @override
  String get resourceType;

  /// Create a copy of PetGroomer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PetGroomerImplCopyWith<_$PetGroomerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PetSitter _$PetSitterFromJson(Map<String, dynamic> json) {
  return _PetSitter.fromJson(json);
}

/// @nodoc
mixin _$PetSitter {
  int? get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  double? get dailyRate => throw _privateConstructorUsedError;
  String? get availability => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String get resourceType => throw _privateConstructorUsedError;

  /// Serializes this PetSitter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PetSitter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PetSitterCopyWith<PetSitter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PetSitterCopyWith<$Res> {
  factory $PetSitterCopyWith(PetSitter value, $Res Function(PetSitter) then) =
      _$PetSitterCopyWithImpl<$Res, PetSitter>;
  @useResult
  $Res call(
      {int? id,
      String name,
      String? phone,
      String? email,
      String? address,
      double? dailyRate,
      String? availability,
      String? notes,
      String resourceType});
}

/// @nodoc
class _$PetSitterCopyWithImpl<$Res, $Val extends PetSitter>
    implements $PetSitterCopyWith<$Res> {
  _$PetSitterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PetSitter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? phone = freezed,
    Object? email = freezed,
    Object? address = freezed,
    Object? dailyRate = freezed,
    Object? availability = freezed,
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
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      dailyRate: freezed == dailyRate
          ? _value.dailyRate
          : dailyRate // ignore: cast_nullable_to_non_nullable
              as double?,
      availability: freezed == availability
          ? _value.availability
          : availability // ignore: cast_nullable_to_non_nullable
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
abstract class _$$PetSitterImplCopyWith<$Res>
    implements $PetSitterCopyWith<$Res> {
  factory _$$PetSitterImplCopyWith(
          _$PetSitterImpl value, $Res Function(_$PetSitterImpl) then) =
      __$$PetSitterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String name,
      String? phone,
      String? email,
      String? address,
      double? dailyRate,
      String? availability,
      String? notes,
      String resourceType});
}

/// @nodoc
class __$$PetSitterImplCopyWithImpl<$Res>
    extends _$PetSitterCopyWithImpl<$Res, _$PetSitterImpl>
    implements _$$PetSitterImplCopyWith<$Res> {
  __$$PetSitterImplCopyWithImpl(
      _$PetSitterImpl _value, $Res Function(_$PetSitterImpl) _then)
      : super(_value, _then);

  /// Create a copy of PetSitter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? phone = freezed,
    Object? email = freezed,
    Object? address = freezed,
    Object? dailyRate = freezed,
    Object? availability = freezed,
    Object? notes = freezed,
    Object? resourceType = null,
  }) {
    return _then(_$PetSitterImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      dailyRate: freezed == dailyRate
          ? _value.dailyRate
          : dailyRate // ignore: cast_nullable_to_non_nullable
              as double?,
      availability: freezed == availability
          ? _value.availability
          : availability // ignore: cast_nullable_to_non_nullable
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
class _$PetSitterImpl implements _PetSitter {
  const _$PetSitterImpl(
      {this.id,
      required this.name,
      this.phone,
      this.email,
      this.address,
      this.dailyRate,
      this.availability,
      this.notes,
      this.resourceType = 'PetSitter'});

  factory _$PetSitterImpl.fromJson(Map<String, dynamic> json) =>
      _$$PetSitterImplFromJson(json);

  @override
  final int? id;
  @override
  final String name;
  @override
  final String? phone;
  @override
  final String? email;
  @override
  final String? address;
  @override
  final double? dailyRate;
  @override
  final String? availability;
  @override
  final String? notes;
  @override
  @JsonKey()
  final String resourceType;

  @override
  String toString() {
    return 'PetSitter(id: $id, name: $name, phone: $phone, email: $email, address: $address, dailyRate: $dailyRate, availability: $availability, notes: $notes, resourceType: $resourceType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PetSitterImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.dailyRate, dailyRate) ||
                other.dailyRate == dailyRate) &&
            (identical(other.availability, availability) ||
                other.availability == availability) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.resourceType, resourceType) ||
                other.resourceType == resourceType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, phone, email, address,
      dailyRate, availability, notes, resourceType);

  /// Create a copy of PetSitter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PetSitterImplCopyWith<_$PetSitterImpl> get copyWith =>
      __$$PetSitterImplCopyWithImpl<_$PetSitterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PetSitterImplToJson(
      this,
    );
  }
}

abstract class _PetSitter implements PetSitter {
  const factory _PetSitter(
      {final int? id,
      required final String name,
      final String? phone,
      final String? email,
      final String? address,
      final double? dailyRate,
      final String? availability,
      final String? notes,
      final String resourceType}) = _$PetSitterImpl;

  factory _PetSitter.fromJson(Map<String, dynamic> json) =
      _$PetSitterImpl.fromJson;

  @override
  int? get id;
  @override
  String get name;
  @override
  String? get phone;
  @override
  String? get email;
  @override
  String? get address;
  @override
  double? get dailyRate;
  @override
  String? get availability;
  @override
  String? get notes;
  @override
  String get resourceType;

  /// Create a copy of PetSitter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PetSitterImplCopyWith<_$PetSitterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
