// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_entities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BirthdayImpl _$$BirthdayImplFromJson(Map<String, dynamic> json) =>
    _$BirthdayImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      dob: DateTime.parse(json['dob'] as String),
      knownYear: json['knownYear'] as bool? ?? true,
      notes: json['notes'] as String?,
      resourceType: json['resourceType'] as String? ?? 'Birthday',
    );

Map<String, dynamic> _$$BirthdayImplToJson(_$BirthdayImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'dob': instance.dob.toIso8601String(),
      'knownYear': instance.knownYear,
      'notes': instance.notes,
      'resourceType': instance.resourceType,
    };

_$AnniversaryImpl _$$AnniversaryImplFromJson(Map<String, dynamic> json) =>
    _$AnniversaryImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      date: DateTime.parse(json['date'] as String),
      knownYear: json['knownYear'] as bool? ?? true,
      notes: json['notes'] as String?,
      resourceType: json['resourceType'] as String? ?? 'Anniversary',
    );

Map<String, dynamic> _$$AnniversaryImplToJson(_$AnniversaryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'date': instance.date.toIso8601String(),
      'knownYear': instance.knownYear,
      'notes': instance.notes,
      'resourceType': instance.resourceType,
    };

_$PatientImpl _$$PatientImplFromJson(Map<String, dynamic> json) =>
    _$PatientImpl(
      id: (json['id'] as num?)?.toInt(),
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      medicalNumber: json['medicalNumber'] as String?,
      notes: json['notes'] as String?,
      resourceType: json['resourceType'] as String? ?? 'Patient',
    );

Map<String, dynamic> _$$PatientImplToJson(_$PatientImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'medicalNumber': instance.medicalNumber,
      'notes': instance.notes,
      'resourceType': instance.resourceType,
    };

_$AppointmentImpl _$$AppointmentImplFromJson(Map<String, dynamic> json) =>
    _$AppointmentImpl(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String,
      startDatetime: DateTime.parse(json['startDatetime'] as String),
      endDatetime: DateTime.parse(json['endDatetime'] as String),
      location: json['location'] as String?,
      notes: json['notes'] as String?,
      patientIds: (json['patientIds'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      resourceType: json['resourceType'] as String? ?? 'Appointment',
    );

Map<String, dynamic> _$$AppointmentImplToJson(_$AppointmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'startDatetime': instance.startDatetime.toIso8601String(),
      'endDatetime': instance.endDatetime.toIso8601String(),
      'location': instance.location,
      'notes': instance.notes,
      'patientIds': instance.patientIds,
      'resourceType': instance.resourceType,
    };

_$FamilyMemberImpl _$$FamilyMemberImplFromJson(Map<String, dynamic> json) =>
    _$FamilyMemberImpl(
      id: (json['id'] as num?)?.toInt(),
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      relationship: json['relationship'] as String?,
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      phoneNumber: json['phoneNumber'] as String?,
      email: json['email'] as String?,
      notes: json['notes'] as String?,
      resourceType: json['resourceType'] as String? ?? 'FamilyMember',
    );

Map<String, dynamic> _$$FamilyMemberImplToJson(_$FamilyMemberImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'relationship': instance.relationship,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'notes': instance.notes,
      'resourceType': instance.resourceType,
    };
