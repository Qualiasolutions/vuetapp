// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transport_entities.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Car _$CarFromJson(Map<String, dynamic> json) {
  return _Car.fromJson(json);
}

/// @nodoc
mixin _$Car {
  int? get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get make => throw _privateConstructorUsedError;
  String get model => throw _privateConstructorUsedError;
  String get registration => throw _privateConstructorUsedError;
  DateTime? get motDueDate => throw _privateConstructorUsedError;
  DateTime? get insuranceDueDate => throw _privateConstructorUsedError;
  DateTime? get serviceDueDate => throw _privateConstructorUsedError;
  DateTime? get taxDueDate => throw _privateConstructorUsedError;
  DateTime? get warrantyDueDate => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String get resourceType => throw _privateConstructorUsedError;

  /// Serializes this Car to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Car
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CarCopyWith<Car> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CarCopyWith<$Res> {
  factory $CarCopyWith(Car value, $Res Function(Car) then) =
      _$CarCopyWithImpl<$Res, Car>;
  @useResult
  $Res call(
      {int? id,
      String name,
      String make,
      String model,
      String registration,
      DateTime? motDueDate,
      DateTime? insuranceDueDate,
      DateTime? serviceDueDate,
      DateTime? taxDueDate,
      DateTime? warrantyDueDate,
      String? notes,
      String resourceType});
}

/// @nodoc
class _$CarCopyWithImpl<$Res, $Val extends Car> implements $CarCopyWith<$Res> {
  _$CarCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Car
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? make = null,
    Object? model = null,
    Object? registration = null,
    Object? motDueDate = freezed,
    Object? insuranceDueDate = freezed,
    Object? serviceDueDate = freezed,
    Object? taxDueDate = freezed,
    Object? warrantyDueDate = freezed,
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
      make: null == make
          ? _value.make
          : make // ignore: cast_nullable_to_non_nullable
              as String,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      registration: null == registration
          ? _value.registration
          : registration // ignore: cast_nullable_to_non_nullable
              as String,
      motDueDate: freezed == motDueDate
          ? _value.motDueDate
          : motDueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      insuranceDueDate: freezed == insuranceDueDate
          ? _value.insuranceDueDate
          : insuranceDueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      serviceDueDate: freezed == serviceDueDate
          ? _value.serviceDueDate
          : serviceDueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      taxDueDate: freezed == taxDueDate
          ? _value.taxDueDate
          : taxDueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      warrantyDueDate: freezed == warrantyDueDate
          ? _value.warrantyDueDate
          : warrantyDueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
abstract class _$$CarImplCopyWith<$Res> implements $CarCopyWith<$Res> {
  factory _$$CarImplCopyWith(_$CarImpl value, $Res Function(_$CarImpl) then) =
      __$$CarImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String name,
      String make,
      String model,
      String registration,
      DateTime? motDueDate,
      DateTime? insuranceDueDate,
      DateTime? serviceDueDate,
      DateTime? taxDueDate,
      DateTime? warrantyDueDate,
      String? notes,
      String resourceType});
}

/// @nodoc
class __$$CarImplCopyWithImpl<$Res> extends _$CarCopyWithImpl<$Res, _$CarImpl>
    implements _$$CarImplCopyWith<$Res> {
  __$$CarImplCopyWithImpl(_$CarImpl _value, $Res Function(_$CarImpl) _then)
      : super(_value, _then);

  /// Create a copy of Car
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? make = null,
    Object? model = null,
    Object? registration = null,
    Object? motDueDate = freezed,
    Object? insuranceDueDate = freezed,
    Object? serviceDueDate = freezed,
    Object? taxDueDate = freezed,
    Object? warrantyDueDate = freezed,
    Object? notes = freezed,
    Object? resourceType = null,
  }) {
    return _then(_$CarImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      make: null == make
          ? _value.make
          : make // ignore: cast_nullable_to_non_nullable
              as String,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      registration: null == registration
          ? _value.registration
          : registration // ignore: cast_nullable_to_non_nullable
              as String,
      motDueDate: freezed == motDueDate
          ? _value.motDueDate
          : motDueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      insuranceDueDate: freezed == insuranceDueDate
          ? _value.insuranceDueDate
          : insuranceDueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      serviceDueDate: freezed == serviceDueDate
          ? _value.serviceDueDate
          : serviceDueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      taxDueDate: freezed == taxDueDate
          ? _value.taxDueDate
          : taxDueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      warrantyDueDate: freezed == warrantyDueDate
          ? _value.warrantyDueDate
          : warrantyDueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
class _$CarImpl implements _Car {
  const _$CarImpl(
      {this.id,
      required this.name,
      required this.make,
      required this.model,
      required this.registration,
      this.motDueDate,
      this.insuranceDueDate,
      this.serviceDueDate,
      this.taxDueDate,
      this.warrantyDueDate,
      this.notes,
      this.resourceType = 'Car'});

  factory _$CarImpl.fromJson(Map<String, dynamic> json) =>
      _$$CarImplFromJson(json);

  @override
  final int? id;
  @override
  final String name;
  @override
  final String make;
  @override
  final String model;
  @override
  final String registration;
  @override
  final DateTime? motDueDate;
  @override
  final DateTime? insuranceDueDate;
  @override
  final DateTime? serviceDueDate;
  @override
  final DateTime? taxDueDate;
  @override
  final DateTime? warrantyDueDate;
  @override
  final String? notes;
  @override
  @JsonKey()
  final String resourceType;

  @override
  String toString() {
    return 'Car(id: $id, name: $name, make: $make, model: $model, registration: $registration, motDueDate: $motDueDate, insuranceDueDate: $insuranceDueDate, serviceDueDate: $serviceDueDate, taxDueDate: $taxDueDate, warrantyDueDate: $warrantyDueDate, notes: $notes, resourceType: $resourceType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CarImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.make, make) || other.make == make) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.registration, registration) ||
                other.registration == registration) &&
            (identical(other.motDueDate, motDueDate) ||
                other.motDueDate == motDueDate) &&
            (identical(other.insuranceDueDate, insuranceDueDate) ||
                other.insuranceDueDate == insuranceDueDate) &&
            (identical(other.serviceDueDate, serviceDueDate) ||
                other.serviceDueDate == serviceDueDate) &&
            (identical(other.taxDueDate, taxDueDate) ||
                other.taxDueDate == taxDueDate) &&
            (identical(other.warrantyDueDate, warrantyDueDate) ||
                other.warrantyDueDate == warrantyDueDate) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.resourceType, resourceType) ||
                other.resourceType == resourceType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      make,
      model,
      registration,
      motDueDate,
      insuranceDueDate,
      serviceDueDate,
      taxDueDate,
      warrantyDueDate,
      notes,
      resourceType);

  /// Create a copy of Car
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CarImplCopyWith<_$CarImpl> get copyWith =>
      __$$CarImplCopyWithImpl<_$CarImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CarImplToJson(
      this,
    );
  }
}

abstract class _Car implements Car {
  const factory _Car(
      {final int? id,
      required final String name,
      required final String make,
      required final String model,
      required final String registration,
      final DateTime? motDueDate,
      final DateTime? insuranceDueDate,
      final DateTime? serviceDueDate,
      final DateTime? taxDueDate,
      final DateTime? warrantyDueDate,
      final String? notes,
      final String resourceType}) = _$CarImpl;

  factory _Car.fromJson(Map<String, dynamic> json) = _$CarImpl.fromJson;

  @override
  int? get id;
  @override
  String get name;
  @override
  String get make;
  @override
  String get model;
  @override
  String get registration;
  @override
  DateTime? get motDueDate;
  @override
  DateTime? get insuranceDueDate;
  @override
  DateTime? get serviceDueDate;
  @override
  DateTime? get taxDueDate;
  @override
  DateTime? get warrantyDueDate;
  @override
  String? get notes;
  @override
  String get resourceType;

  /// Create a copy of Car
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CarImplCopyWith<_$CarImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PublicTransport _$PublicTransportFromJson(Map<String, dynamic> json) {
  return _PublicTransport.fromJson(json);
}

/// @nodoc
mixin _$PublicTransport {
  int? get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get transportType =>
      throw _privateConstructorUsedError; // Bus, Metro, Tram, etc.
  String? get routeNumber => throw _privateConstructorUsedError;
  String? get operator => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String get resourceType => throw _privateConstructorUsedError;

  /// Serializes this PublicTransport to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PublicTransport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PublicTransportCopyWith<PublicTransport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PublicTransportCopyWith<$Res> {
  factory $PublicTransportCopyWith(
          PublicTransport value, $Res Function(PublicTransport) then) =
      _$PublicTransportCopyWithImpl<$Res, PublicTransport>;
  @useResult
  $Res call(
      {int? id,
      String name,
      String transportType,
      String? routeNumber,
      String? operator,
      String? notes,
      String resourceType});
}

/// @nodoc
class _$PublicTransportCopyWithImpl<$Res, $Val extends PublicTransport>
    implements $PublicTransportCopyWith<$Res> {
  _$PublicTransportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PublicTransport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? transportType = null,
    Object? routeNumber = freezed,
    Object? operator = freezed,
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
      transportType: null == transportType
          ? _value.transportType
          : transportType // ignore: cast_nullable_to_non_nullable
              as String,
      routeNumber: freezed == routeNumber
          ? _value.routeNumber
          : routeNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      operator: freezed == operator
          ? _value.operator
          : operator // ignore: cast_nullable_to_non_nullable
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
abstract class _$$PublicTransportImplCopyWith<$Res>
    implements $PublicTransportCopyWith<$Res> {
  factory _$$PublicTransportImplCopyWith(_$PublicTransportImpl value,
          $Res Function(_$PublicTransportImpl) then) =
      __$$PublicTransportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String name,
      String transportType,
      String? routeNumber,
      String? operator,
      String? notes,
      String resourceType});
}

/// @nodoc
class __$$PublicTransportImplCopyWithImpl<$Res>
    extends _$PublicTransportCopyWithImpl<$Res, _$PublicTransportImpl>
    implements _$$PublicTransportImplCopyWith<$Res> {
  __$$PublicTransportImplCopyWithImpl(
      _$PublicTransportImpl _value, $Res Function(_$PublicTransportImpl) _then)
      : super(_value, _then);

  /// Create a copy of PublicTransport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? transportType = null,
    Object? routeNumber = freezed,
    Object? operator = freezed,
    Object? notes = freezed,
    Object? resourceType = null,
  }) {
    return _then(_$PublicTransportImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      transportType: null == transportType
          ? _value.transportType
          : transportType // ignore: cast_nullable_to_non_nullable
              as String,
      routeNumber: freezed == routeNumber
          ? _value.routeNumber
          : routeNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      operator: freezed == operator
          ? _value.operator
          : operator // ignore: cast_nullable_to_non_nullable
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
class _$PublicTransportImpl implements _PublicTransport {
  const _$PublicTransportImpl(
      {this.id,
      required this.name,
      required this.transportType,
      this.routeNumber,
      this.operator,
      this.notes,
      this.resourceType = 'PublicTransport'});

  factory _$PublicTransportImpl.fromJson(Map<String, dynamic> json) =>
      _$$PublicTransportImplFromJson(json);

  @override
  final int? id;
  @override
  final String name;
  @override
  final String transportType;
// Bus, Metro, Tram, etc.
  @override
  final String? routeNumber;
  @override
  final String? operator;
  @override
  final String? notes;
  @override
  @JsonKey()
  final String resourceType;

  @override
  String toString() {
    return 'PublicTransport(id: $id, name: $name, transportType: $transportType, routeNumber: $routeNumber, operator: $operator, notes: $notes, resourceType: $resourceType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PublicTransportImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.transportType, transportType) ||
                other.transportType == transportType) &&
            (identical(other.routeNumber, routeNumber) ||
                other.routeNumber == routeNumber) &&
            (identical(other.operator, operator) ||
                other.operator == operator) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.resourceType, resourceType) ||
                other.resourceType == resourceType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, transportType,
      routeNumber, operator, notes, resourceType);

  /// Create a copy of PublicTransport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PublicTransportImplCopyWith<_$PublicTransportImpl> get copyWith =>
      __$$PublicTransportImplCopyWithImpl<_$PublicTransportImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PublicTransportImplToJson(
      this,
    );
  }
}

abstract class _PublicTransport implements PublicTransport {
  const factory _PublicTransport(
      {final int? id,
      required final String name,
      required final String transportType,
      final String? routeNumber,
      final String? operator,
      final String? notes,
      final String resourceType}) = _$PublicTransportImpl;

  factory _PublicTransport.fromJson(Map<String, dynamic> json) =
      _$PublicTransportImpl.fromJson;

  @override
  int? get id;
  @override
  String get name;
  @override
  String get transportType; // Bus, Metro, Tram, etc.
  @override
  String? get routeNumber;
  @override
  String? get operator;
  @override
  String? get notes;
  @override
  String get resourceType;

  /// Create a copy of PublicTransport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PublicTransportImplCopyWith<_$PublicTransportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TrainBusFerry _$TrainBusFerryFromJson(Map<String, dynamic> json) {
  return _TrainBusFerry.fromJson(json);
}

/// @nodoc
mixin _$TrainBusFerry {
  int? get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get transportType =>
      throw _privateConstructorUsedError; // Train, Bus, Ferry
  String? get operator => throw _privateConstructorUsedError;
  String? get routeNumber => throw _privateConstructorUsedError;
  String? get departureStation => throw _privateConstructorUsedError;
  String? get arrivalStation => throw _privateConstructorUsedError;
  DateTime? get departureTime => throw _privateConstructorUsedError;
  DateTime? get arrivalTime => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String get resourceType => throw _privateConstructorUsedError;

  /// Serializes this TrainBusFerry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TrainBusFerry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrainBusFerryCopyWith<TrainBusFerry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrainBusFerryCopyWith<$Res> {
  factory $TrainBusFerryCopyWith(
          TrainBusFerry value, $Res Function(TrainBusFerry) then) =
      _$TrainBusFerryCopyWithImpl<$Res, TrainBusFerry>;
  @useResult
  $Res call(
      {int? id,
      String name,
      String transportType,
      String? operator,
      String? routeNumber,
      String? departureStation,
      String? arrivalStation,
      DateTime? departureTime,
      DateTime? arrivalTime,
      String? notes,
      String resourceType});
}

/// @nodoc
class _$TrainBusFerryCopyWithImpl<$Res, $Val extends TrainBusFerry>
    implements $TrainBusFerryCopyWith<$Res> {
  _$TrainBusFerryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrainBusFerry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? transportType = null,
    Object? operator = freezed,
    Object? routeNumber = freezed,
    Object? departureStation = freezed,
    Object? arrivalStation = freezed,
    Object? departureTime = freezed,
    Object? arrivalTime = freezed,
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
      transportType: null == transportType
          ? _value.transportType
          : transportType // ignore: cast_nullable_to_non_nullable
              as String,
      operator: freezed == operator
          ? _value.operator
          : operator // ignore: cast_nullable_to_non_nullable
              as String?,
      routeNumber: freezed == routeNumber
          ? _value.routeNumber
          : routeNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      departureStation: freezed == departureStation
          ? _value.departureStation
          : departureStation // ignore: cast_nullable_to_non_nullable
              as String?,
      arrivalStation: freezed == arrivalStation
          ? _value.arrivalStation
          : arrivalStation // ignore: cast_nullable_to_non_nullable
              as String?,
      departureTime: freezed == departureTime
          ? _value.departureTime
          : departureTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      arrivalTime: freezed == arrivalTime
          ? _value.arrivalTime
          : arrivalTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
abstract class _$$TrainBusFerryImplCopyWith<$Res>
    implements $TrainBusFerryCopyWith<$Res> {
  factory _$$TrainBusFerryImplCopyWith(
          _$TrainBusFerryImpl value, $Res Function(_$TrainBusFerryImpl) then) =
      __$$TrainBusFerryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String name,
      String transportType,
      String? operator,
      String? routeNumber,
      String? departureStation,
      String? arrivalStation,
      DateTime? departureTime,
      DateTime? arrivalTime,
      String? notes,
      String resourceType});
}

/// @nodoc
class __$$TrainBusFerryImplCopyWithImpl<$Res>
    extends _$TrainBusFerryCopyWithImpl<$Res, _$TrainBusFerryImpl>
    implements _$$TrainBusFerryImplCopyWith<$Res> {
  __$$TrainBusFerryImplCopyWithImpl(
      _$TrainBusFerryImpl _value, $Res Function(_$TrainBusFerryImpl) _then)
      : super(_value, _then);

  /// Create a copy of TrainBusFerry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? transportType = null,
    Object? operator = freezed,
    Object? routeNumber = freezed,
    Object? departureStation = freezed,
    Object? arrivalStation = freezed,
    Object? departureTime = freezed,
    Object? arrivalTime = freezed,
    Object? notes = freezed,
    Object? resourceType = null,
  }) {
    return _then(_$TrainBusFerryImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      transportType: null == transportType
          ? _value.transportType
          : transportType // ignore: cast_nullable_to_non_nullable
              as String,
      operator: freezed == operator
          ? _value.operator
          : operator // ignore: cast_nullable_to_non_nullable
              as String?,
      routeNumber: freezed == routeNumber
          ? _value.routeNumber
          : routeNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      departureStation: freezed == departureStation
          ? _value.departureStation
          : departureStation // ignore: cast_nullable_to_non_nullable
              as String?,
      arrivalStation: freezed == arrivalStation
          ? _value.arrivalStation
          : arrivalStation // ignore: cast_nullable_to_non_nullable
              as String?,
      departureTime: freezed == departureTime
          ? _value.departureTime
          : departureTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      arrivalTime: freezed == arrivalTime
          ? _value.arrivalTime
          : arrivalTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
class _$TrainBusFerryImpl implements _TrainBusFerry {
  const _$TrainBusFerryImpl(
      {this.id,
      required this.name,
      required this.transportType,
      this.operator,
      this.routeNumber,
      this.departureStation,
      this.arrivalStation,
      this.departureTime,
      this.arrivalTime,
      this.notes,
      this.resourceType = 'TrainBusFerry'});

  factory _$TrainBusFerryImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrainBusFerryImplFromJson(json);

  @override
  final int? id;
  @override
  final String name;
  @override
  final String transportType;
// Train, Bus, Ferry
  @override
  final String? operator;
  @override
  final String? routeNumber;
  @override
  final String? departureStation;
  @override
  final String? arrivalStation;
  @override
  final DateTime? departureTime;
  @override
  final DateTime? arrivalTime;
  @override
  final String? notes;
  @override
  @JsonKey()
  final String resourceType;

  @override
  String toString() {
    return 'TrainBusFerry(id: $id, name: $name, transportType: $transportType, operator: $operator, routeNumber: $routeNumber, departureStation: $departureStation, arrivalStation: $arrivalStation, departureTime: $departureTime, arrivalTime: $arrivalTime, notes: $notes, resourceType: $resourceType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrainBusFerryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.transportType, transportType) ||
                other.transportType == transportType) &&
            (identical(other.operator, operator) ||
                other.operator == operator) &&
            (identical(other.routeNumber, routeNumber) ||
                other.routeNumber == routeNumber) &&
            (identical(other.departureStation, departureStation) ||
                other.departureStation == departureStation) &&
            (identical(other.arrivalStation, arrivalStation) ||
                other.arrivalStation == arrivalStation) &&
            (identical(other.departureTime, departureTime) ||
                other.departureTime == departureTime) &&
            (identical(other.arrivalTime, arrivalTime) ||
                other.arrivalTime == arrivalTime) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.resourceType, resourceType) ||
                other.resourceType == resourceType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      transportType,
      operator,
      routeNumber,
      departureStation,
      arrivalStation,
      departureTime,
      arrivalTime,
      notes,
      resourceType);

  /// Create a copy of TrainBusFerry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrainBusFerryImplCopyWith<_$TrainBusFerryImpl> get copyWith =>
      __$$TrainBusFerryImplCopyWithImpl<_$TrainBusFerryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TrainBusFerryImplToJson(
      this,
    );
  }
}

abstract class _TrainBusFerry implements TrainBusFerry {
  const factory _TrainBusFerry(
      {final int? id,
      required final String name,
      required final String transportType,
      final String? operator,
      final String? routeNumber,
      final String? departureStation,
      final String? arrivalStation,
      final DateTime? departureTime,
      final DateTime? arrivalTime,
      final String? notes,
      final String resourceType}) = _$TrainBusFerryImpl;

  factory _TrainBusFerry.fromJson(Map<String, dynamic> json) =
      _$TrainBusFerryImpl.fromJson;

  @override
  int? get id;
  @override
  String get name;
  @override
  String get transportType; // Train, Bus, Ferry
  @override
  String? get operator;
  @override
  String? get routeNumber;
  @override
  String? get departureStation;
  @override
  String? get arrivalStation;
  @override
  DateTime? get departureTime;
  @override
  DateTime? get arrivalTime;
  @override
  String? get notes;
  @override
  String get resourceType;

  /// Create a copy of TrainBusFerry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrainBusFerryImplCopyWith<_$TrainBusFerryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RentalCar _$RentalCarFromJson(Map<String, dynamic> json) {
  return _RentalCar.fromJson(json);
}

/// @nodoc
mixin _$RentalCar {
  int? get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get rentalCompany => throw _privateConstructorUsedError;
  String? get make => throw _privateConstructorUsedError;
  String? get model => throw _privateConstructorUsedError;
  String? get registration => throw _privateConstructorUsedError;
  DateTime? get pickupDate => throw _privateConstructorUsedError;
  DateTime? get returnDate => throw _privateConstructorUsedError;
  String? get pickupLocation => throw _privateConstructorUsedError;
  String? get returnLocation => throw _privateConstructorUsedError;
  double? get totalCost => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String get resourceType => throw _privateConstructorUsedError;

  /// Serializes this RentalCar to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RentalCar
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RentalCarCopyWith<RentalCar> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RentalCarCopyWith<$Res> {
  factory $RentalCarCopyWith(RentalCar value, $Res Function(RentalCar) then) =
      _$RentalCarCopyWithImpl<$Res, RentalCar>;
  @useResult
  $Res call(
      {int? id,
      String name,
      String rentalCompany,
      String? make,
      String? model,
      String? registration,
      DateTime? pickupDate,
      DateTime? returnDate,
      String? pickupLocation,
      String? returnLocation,
      double? totalCost,
      String? notes,
      String resourceType});
}

/// @nodoc
class _$RentalCarCopyWithImpl<$Res, $Val extends RentalCar>
    implements $RentalCarCopyWith<$Res> {
  _$RentalCarCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RentalCar
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? rentalCompany = null,
    Object? make = freezed,
    Object? model = freezed,
    Object? registration = freezed,
    Object? pickupDate = freezed,
    Object? returnDate = freezed,
    Object? pickupLocation = freezed,
    Object? returnLocation = freezed,
    Object? totalCost = freezed,
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
      rentalCompany: null == rentalCompany
          ? _value.rentalCompany
          : rentalCompany // ignore: cast_nullable_to_non_nullable
              as String,
      make: freezed == make
          ? _value.make
          : make // ignore: cast_nullable_to_non_nullable
              as String?,
      model: freezed == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String?,
      registration: freezed == registration
          ? _value.registration
          : registration // ignore: cast_nullable_to_non_nullable
              as String?,
      pickupDate: freezed == pickupDate
          ? _value.pickupDate
          : pickupDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      returnDate: freezed == returnDate
          ? _value.returnDate
          : returnDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      pickupLocation: freezed == pickupLocation
          ? _value.pickupLocation
          : pickupLocation // ignore: cast_nullable_to_non_nullable
              as String?,
      returnLocation: freezed == returnLocation
          ? _value.returnLocation
          : returnLocation // ignore: cast_nullable_to_non_nullable
              as String?,
      totalCost: freezed == totalCost
          ? _value.totalCost
          : totalCost // ignore: cast_nullable_to_non_nullable
              as double?,
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
abstract class _$$RentalCarImplCopyWith<$Res>
    implements $RentalCarCopyWith<$Res> {
  factory _$$RentalCarImplCopyWith(
          _$RentalCarImpl value, $Res Function(_$RentalCarImpl) then) =
      __$$RentalCarImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String name,
      String rentalCompany,
      String? make,
      String? model,
      String? registration,
      DateTime? pickupDate,
      DateTime? returnDate,
      String? pickupLocation,
      String? returnLocation,
      double? totalCost,
      String? notes,
      String resourceType});
}

/// @nodoc
class __$$RentalCarImplCopyWithImpl<$Res>
    extends _$RentalCarCopyWithImpl<$Res, _$RentalCarImpl>
    implements _$$RentalCarImplCopyWith<$Res> {
  __$$RentalCarImplCopyWithImpl(
      _$RentalCarImpl _value, $Res Function(_$RentalCarImpl) _then)
      : super(_value, _then);

  /// Create a copy of RentalCar
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? rentalCompany = null,
    Object? make = freezed,
    Object? model = freezed,
    Object? registration = freezed,
    Object? pickupDate = freezed,
    Object? returnDate = freezed,
    Object? pickupLocation = freezed,
    Object? returnLocation = freezed,
    Object? totalCost = freezed,
    Object? notes = freezed,
    Object? resourceType = null,
  }) {
    return _then(_$RentalCarImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      rentalCompany: null == rentalCompany
          ? _value.rentalCompany
          : rentalCompany // ignore: cast_nullable_to_non_nullable
              as String,
      make: freezed == make
          ? _value.make
          : make // ignore: cast_nullable_to_non_nullable
              as String?,
      model: freezed == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String?,
      registration: freezed == registration
          ? _value.registration
          : registration // ignore: cast_nullable_to_non_nullable
              as String?,
      pickupDate: freezed == pickupDate
          ? _value.pickupDate
          : pickupDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      returnDate: freezed == returnDate
          ? _value.returnDate
          : returnDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      pickupLocation: freezed == pickupLocation
          ? _value.pickupLocation
          : pickupLocation // ignore: cast_nullable_to_non_nullable
              as String?,
      returnLocation: freezed == returnLocation
          ? _value.returnLocation
          : returnLocation // ignore: cast_nullable_to_non_nullable
              as String?,
      totalCost: freezed == totalCost
          ? _value.totalCost
          : totalCost // ignore: cast_nullable_to_non_nullable
              as double?,
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
class _$RentalCarImpl implements _RentalCar {
  const _$RentalCarImpl(
      {this.id,
      required this.name,
      required this.rentalCompany,
      this.make,
      this.model,
      this.registration,
      this.pickupDate,
      this.returnDate,
      this.pickupLocation,
      this.returnLocation,
      this.totalCost,
      this.notes,
      this.resourceType = 'RentalCar'});

  factory _$RentalCarImpl.fromJson(Map<String, dynamic> json) =>
      _$$RentalCarImplFromJson(json);

  @override
  final int? id;
  @override
  final String name;
  @override
  final String rentalCompany;
  @override
  final String? make;
  @override
  final String? model;
  @override
  final String? registration;
  @override
  final DateTime? pickupDate;
  @override
  final DateTime? returnDate;
  @override
  final String? pickupLocation;
  @override
  final String? returnLocation;
  @override
  final double? totalCost;
  @override
  final String? notes;
  @override
  @JsonKey()
  final String resourceType;

  @override
  String toString() {
    return 'RentalCar(id: $id, name: $name, rentalCompany: $rentalCompany, make: $make, model: $model, registration: $registration, pickupDate: $pickupDate, returnDate: $returnDate, pickupLocation: $pickupLocation, returnLocation: $returnLocation, totalCost: $totalCost, notes: $notes, resourceType: $resourceType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RentalCarImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.rentalCompany, rentalCompany) ||
                other.rentalCompany == rentalCompany) &&
            (identical(other.make, make) || other.make == make) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.registration, registration) ||
                other.registration == registration) &&
            (identical(other.pickupDate, pickupDate) ||
                other.pickupDate == pickupDate) &&
            (identical(other.returnDate, returnDate) ||
                other.returnDate == returnDate) &&
            (identical(other.pickupLocation, pickupLocation) ||
                other.pickupLocation == pickupLocation) &&
            (identical(other.returnLocation, returnLocation) ||
                other.returnLocation == returnLocation) &&
            (identical(other.totalCost, totalCost) ||
                other.totalCost == totalCost) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.resourceType, resourceType) ||
                other.resourceType == resourceType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      rentalCompany,
      make,
      model,
      registration,
      pickupDate,
      returnDate,
      pickupLocation,
      returnLocation,
      totalCost,
      notes,
      resourceType);

  /// Create a copy of RentalCar
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RentalCarImplCopyWith<_$RentalCarImpl> get copyWith =>
      __$$RentalCarImplCopyWithImpl<_$RentalCarImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RentalCarImplToJson(
      this,
    );
  }
}

abstract class _RentalCar implements RentalCar {
  const factory _RentalCar(
      {final int? id,
      required final String name,
      required final String rentalCompany,
      final String? make,
      final String? model,
      final String? registration,
      final DateTime? pickupDate,
      final DateTime? returnDate,
      final String? pickupLocation,
      final String? returnLocation,
      final double? totalCost,
      final String? notes,
      final String resourceType}) = _$RentalCarImpl;

  factory _RentalCar.fromJson(Map<String, dynamic> json) =
      _$RentalCarImpl.fromJson;

  @override
  int? get id;
  @override
  String get name;
  @override
  String get rentalCompany;
  @override
  String? get make;
  @override
  String? get model;
  @override
  String? get registration;
  @override
  DateTime? get pickupDate;
  @override
  DateTime? get returnDate;
  @override
  String? get pickupLocation;
  @override
  String? get returnLocation;
  @override
  double? get totalCost;
  @override
  String? get notes;
  @override
  String get resourceType;

  /// Create a copy of RentalCar
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RentalCarImplCopyWith<_$RentalCarImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
