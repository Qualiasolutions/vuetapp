// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transport_entities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CarImpl _$$CarImplFromJson(Map<String, dynamic> json) => _$CarImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      make: json['make'] as String,
      model: json['model'] as String,
      registration: json['registration'] as String,
      motDueDate: json['motDueDate'] == null
          ? null
          : DateTime.parse(json['motDueDate'] as String),
      insuranceDueDate: json['insuranceDueDate'] == null
          ? null
          : DateTime.parse(json['insuranceDueDate'] as String),
      serviceDueDate: json['serviceDueDate'] == null
          ? null
          : DateTime.parse(json['serviceDueDate'] as String),
      taxDueDate: json['taxDueDate'] == null
          ? null
          : DateTime.parse(json['taxDueDate'] as String),
      warrantyDueDate: json['warrantyDueDate'] == null
          ? null
          : DateTime.parse(json['warrantyDueDate'] as String),
      notes: json['notes'] as String?,
      resourceType: json['resourceType'] as String? ?? 'Car',
    );

Map<String, dynamic> _$$CarImplToJson(_$CarImpl instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'make': instance.make,
      'model': instance.model,
      'registration': instance.registration,
      'motDueDate': instance.motDueDate?.toIso8601String(),
      'insuranceDueDate': instance.insuranceDueDate?.toIso8601String(),
      'serviceDueDate': instance.serviceDueDate?.toIso8601String(),
      'taxDueDate': instance.taxDueDate?.toIso8601String(),
      'warrantyDueDate': instance.warrantyDueDate?.toIso8601String(),
      'notes': instance.notes,
      'resourceType': instance.resourceType,
    };

_$PublicTransportImpl _$$PublicTransportImplFromJson(
        Map<String, dynamic> json) =>
    _$PublicTransportImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      transportType: json['transportType'] as String,
      routeNumber: json['routeNumber'] as String?,
      operator: json['operator'] as String?,
      notes: json['notes'] as String?,
      resourceType: json['resourceType'] as String? ?? 'PublicTransport',
    );

Map<String, dynamic> _$$PublicTransportImplToJson(
        _$PublicTransportImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'transportType': instance.transportType,
      'routeNumber': instance.routeNumber,
      'operator': instance.operator,
      'notes': instance.notes,
      'resourceType': instance.resourceType,
    };

_$TrainBusFerryImpl _$$TrainBusFerryImplFromJson(Map<String, dynamic> json) =>
    _$TrainBusFerryImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      transportType: json['transportType'] as String,
      operator: json['operator'] as String?,
      routeNumber: json['routeNumber'] as String?,
      departureStation: json['departureStation'] as String?,
      arrivalStation: json['arrivalStation'] as String?,
      departureTime: json['departureTime'] == null
          ? null
          : DateTime.parse(json['departureTime'] as String),
      arrivalTime: json['arrivalTime'] == null
          ? null
          : DateTime.parse(json['arrivalTime'] as String),
      notes: json['notes'] as String?,
      resourceType: json['resourceType'] as String? ?? 'TrainBusFerry',
    );

Map<String, dynamic> _$$TrainBusFerryImplToJson(_$TrainBusFerryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'transportType': instance.transportType,
      'operator': instance.operator,
      'routeNumber': instance.routeNumber,
      'departureStation': instance.departureStation,
      'arrivalStation': instance.arrivalStation,
      'departureTime': instance.departureTime?.toIso8601String(),
      'arrivalTime': instance.arrivalTime?.toIso8601String(),
      'notes': instance.notes,
      'resourceType': instance.resourceType,
    };

_$RentalCarImpl _$$RentalCarImplFromJson(Map<String, dynamic> json) =>
    _$RentalCarImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      rentalCompany: json['rentalCompany'] as String,
      make: json['make'] as String?,
      model: json['model'] as String?,
      registration: json['registration'] as String?,
      pickupDate: json['pickupDate'] == null
          ? null
          : DateTime.parse(json['pickupDate'] as String),
      returnDate: json['returnDate'] == null
          ? null
          : DateTime.parse(json['returnDate'] as String),
      pickupLocation: json['pickupLocation'] as String?,
      returnLocation: json['returnLocation'] as String?,
      totalCost: (json['totalCost'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
      resourceType: json['resourceType'] as String? ?? 'RentalCar',
    );

Map<String, dynamic> _$$RentalCarImplToJson(_$RentalCarImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'rentalCompany': instance.rentalCompany,
      'make': instance.make,
      'model': instance.model,
      'registration': instance.registration,
      'pickupDate': instance.pickupDate?.toIso8601String(),
      'returnDate': instance.returnDate?.toIso8601String(),
      'pickupLocation': instance.pickupLocation,
      'returnLocation': instance.returnLocation,
      'totalCost': instance.totalCost,
      'notes': instance.notes,
      'resourceType': instance.resourceType,
    };
