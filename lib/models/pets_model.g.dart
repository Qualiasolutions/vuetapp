// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pets_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PetImpl _$$PetImplFromJson(Map<String, dynamic> json) => _$PetImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      species: $enumDecodeNullable(_$PetSpeciesEnumMap, json['species']),
      dob: json['dob'] == null ? null : DateTime.parse(json['dob'] as String),
      vaccinationDue: json['vaccination_due'] == null
          ? null
          : DateTime.parse(json['vaccination_due'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$PetImplToJson(_$PetImpl instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'name': instance.name,
      'species': _$PetSpeciesEnumMap[instance.species],
      'dob': instance.dob?.toIso8601String(),
      'vaccination_due': instance.vaccinationDue?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$PetSpeciesEnumMap = {
  PetSpecies.cat: 'cat',
  PetSpecies.dog: 'dog',
  PetSpecies.other: 'other',
};

_$PetAppointmentImpl _$$PetAppointmentImplFromJson(Map<String, dynamic> json) =>
    _$PetAppointmentImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      petId: json['pet_id'] as String,
      title: json['title'] as String,
      startDatetime: DateTime.parse(json['start_datetime'] as String),
      endDatetime: DateTime.parse(json['end_datetime'] as String),
      notes: json['notes'] as String?,
      location: json['location'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$PetAppointmentImplToJson(
        _$PetAppointmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'pet_id': instance.petId,
      'title': instance.title,
      'start_datetime': instance.startDatetime.toIso8601String(),
      'end_datetime': instance.endDatetime.toIso8601String(),
      'notes': instance.notes,
      'location': instance.location,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
