// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_interests_entities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContactImpl _$$ContactImplFromJson(Map<String, dynamic> json) =>
    _$ContactImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      birthday: json['birthday'] == null
          ? null
          : DateTime.parse(json['birthday'] as String),
      relationship: json['relationship'] as String?,
      company: json['company'] as String?,
      jobTitle: json['jobTitle'] as String?,
      notes: json['notes'] as String?,
      resourceType: json['resourceType'] as String? ?? 'Contact',
    );

Map<String, dynamic> _$$ContactImplToJson(_$ContactImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'address': instance.address,
      'birthday': instance.birthday?.toIso8601String(),
      'relationship': instance.relationship,
      'company': instance.company,
      'jobTitle': instance.jobTitle,
      'notes': instance.notes,
      'resourceType': instance.resourceType,
    };

_$EventImpl _$$EventImplFromJson(Map<String, dynamic> json) => _$EventImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      eventType: json['eventType'] as String,
      date: DateTime.parse(json['date'] as String),
      time: json['time'] as String?,
      location: json['location'] as String?,
      organizer: json['organizer'] as String?,
      attendees: json['attendees'] as String?,
      description: json['description'] as String?,
      notes: json['notes'] as String?,
      resourceType: json['resourceType'] as String? ?? 'Event',
    );

Map<String, dynamic> _$$EventImplToJson(_$EventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'eventType': instance.eventType,
      'date': instance.date.toIso8601String(),
      'time': instance.time,
      'location': instance.location,
      'organizer': instance.organizer,
      'attendees': instance.attendees,
      'description': instance.description,
      'notes': instance.notes,
      'resourceType': instance.resourceType,
    };

_$GroupImpl _$$GroupImplFromJson(Map<String, dynamic> json) => _$GroupImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      groupType: json['groupType'] as String,
      description: json['description'] as String?,
      meetingFrequency: json['meetingFrequency'] as String?,
      meetingLocation: json['meetingLocation'] as String?,
      contactPerson: json['contactPerson'] as String?,
      contactPhone: json['contactPhone'] as String?,
      contactEmail: json['contactEmail'] as String?,
      notes: json['notes'] as String?,
      resourceType: json['resourceType'] as String? ?? 'Group',
    );

Map<String, dynamic> _$$GroupImplToJson(_$GroupImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'groupType': instance.groupType,
      'description': instance.description,
      'meetingFrequency': instance.meetingFrequency,
      'meetingLocation': instance.meetingLocation,
      'contactPerson': instance.contactPerson,
      'contactPhone': instance.contactPhone,
      'contactEmail': instance.contactEmail,
      'notes': instance.notes,
      'resourceType': instance.resourceType,
    };

_$SocialActivityImpl _$$SocialActivityImplFromJson(Map<String, dynamic> json) =>
    _$SocialActivityImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      activityType: json['activityType'] as String,
      description: json['description'] as String?,
      frequency: json['frequency'] as String?,
      location: json['location'] as String?,
      equipment: json['equipment'] as String?,
      cost: (json['cost'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
      resourceType: json['resourceType'] as String? ?? 'SocialActivity',
    );

Map<String, dynamic> _$$SocialActivityImplToJson(
        _$SocialActivityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'activityType': instance.activityType,
      'description': instance.description,
      'frequency': instance.frequency,
      'location': instance.location,
      'equipment': instance.equipment,
      'cost': instance.cost,
      'notes': instance.notes,
      'resourceType': instance.resourceType,
    };

_$SocialGatheringImpl _$$SocialGatheringImplFromJson(
        Map<String, dynamic> json) =>
    _$SocialGatheringImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      gatheringType: json['gatheringType'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      location: json['location'] as String?,
      hostName: json['hostName'] as String?,
      expectedAttendees: (json['expectedAttendees'] as num?)?.toInt(),
      theme: json['theme'] as String?,
      notes: json['notes'] as String?,
      resourceType: json['resourceType'] as String? ?? 'SocialGathering',
    );

Map<String, dynamic> _$$SocialGatheringImplToJson(
        _$SocialGatheringImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'gatheringType': instance.gatheringType,
      'dateTime': instance.dateTime.toIso8601String(),
      'location': instance.location,
      'hostName': instance.hostName,
      'expectedAttendees': instance.expectedAttendees,
      'theme': instance.theme,
      'notes': instance.notes,
      'resourceType': instance.resourceType,
    };
