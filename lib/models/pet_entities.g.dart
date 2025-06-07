// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_entities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PetImpl _$$PetImplFromJson(Map<String, dynamic> json) => _$PetImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      type: json['type'] as String,
      breed: json['breed'] as String?,
      dob: json['dob'] == null ? null : DateTime.parse(json['dob'] as String),
      microchipNumber: json['microchipNumber'] as String?,
      vetId: (json['vetId'] as num?)?.toInt(),
      notes: json['notes'] as String?,
      resourceType: json['resourceType'] as String? ?? 'Pet',
    );

Map<String, dynamic> _$$PetImplToJson(_$PetImpl instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'breed': instance.breed,
      'dob': instance.dob?.toIso8601String(),
      'microchipNumber': instance.microchipNumber,
      'vetId': instance.vetId,
      'notes': instance.notes,
      'resourceType': instance.resourceType,
    };

_$VetImpl _$$VetImplFromJson(Map<String, dynamic> json) => _$VetImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      email: json['email'] as String?,
      notes: json['notes'] as String?,
      resourceType: json['resourceType'] as String? ?? 'Vet',
    );

Map<String, dynamic> _$$VetImplToJson(_$VetImpl instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'address': instance.address,
      'email': instance.email,
      'notes': instance.notes,
      'resourceType': instance.resourceType,
    };

_$PetAppointmentImpl _$$PetAppointmentImplFromJson(Map<String, dynamic> json) =>
    _$PetAppointmentImpl(
      id: (json['id'] as num?)?.toInt(),
      petId: (json['petId'] as num).toInt(),
      vetId: (json['vetId'] as num).toInt(),
      appointmentDatetime:
          DateTime.parse(json['appointmentDatetime'] as String),
      type: json['type'] as String,
      notes: json['notes'] as String?,
      resourceType: json['resourceType'] as String? ?? 'PetAppointment',
    );

Map<String, dynamic> _$$PetAppointmentImplToJson(
        _$PetAppointmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'petId': instance.petId,
      'vetId': instance.vetId,
      'appointmentDatetime': instance.appointmentDatetime.toIso8601String(),
      'type': instance.type,
      'notes': instance.notes,
      'resourceType': instance.resourceType,
    };

_$PetWalkerImpl _$$PetWalkerImplFromJson(Map<String, dynamic> json) =>
    _$PetWalkerImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      hourlyRate: (json['hourlyRate'] as num?)?.toDouble(),
      availability: json['availability'] as String?,
      notes: json['notes'] as String?,
      resourceType: json['resourceType'] as String? ?? 'PetWalker',
    );

Map<String, dynamic> _$$PetWalkerImplToJson(_$PetWalkerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'hourlyRate': instance.hourlyRate,
      'availability': instance.availability,
      'notes': instance.notes,
      'resourceType': instance.resourceType,
    };

_$PetGroomerImpl _$$PetGroomerImplFromJson(Map<String, dynamic> json) =>
    _$PetGroomerImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      email: json['email'] as String?,
      services: json['services'] as String?,
      notes: json['notes'] as String?,
      resourceType: json['resourceType'] as String? ?? 'PetGroomer',
    );

Map<String, dynamic> _$$PetGroomerImplToJson(_$PetGroomerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'address': instance.address,
      'email': instance.email,
      'services': instance.services,
      'notes': instance.notes,
      'resourceType': instance.resourceType,
    };

_$PetSitterImpl _$$PetSitterImplFromJson(Map<String, dynamic> json) =>
    _$PetSitterImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      dailyRate: (json['dailyRate'] as num?)?.toDouble(),
      availability: json['availability'] as String?,
      notes: json['notes'] as String?,
      resourceType: json['resourceType'] as String? ?? 'PetSitter',
    );

Map<String, dynamic> _$$PetSitterImplToJson(_$PetSitterImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'address': instance.address,
      'dailyRate': instance.dailyRate,
      'availability': instance.availability,
      'notes': instance.notes,
      'resourceType': instance.resourceType,
    };
