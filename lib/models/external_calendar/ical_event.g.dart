// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ical_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ICalEventImpl _$$ICalEventImplFromJson(Map<String, dynamic> json) =>
    _$ICalEventImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      icalIntegrationId: json['icalIntegrationId'] as String,
      title: json['title'] as String,
      startDateTime: DateTime.parse(json['startDateTime'] as String),
      endDateTime: DateTime.parse(json['endDateTime'] as String),
      rrule: json['rrule'] as String?,
      originalEventId: json['originalEventId'] as String?,
      originalEventStartTime: json['originalEventStartTime'] == null
          ? null
          : DateTime.parse(json['originalEventStartTime'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ICalEventImplToJson(_$ICalEventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'icalIntegrationId': instance.icalIntegrationId,
      'title': instance.title,
      'startDateTime': instance.startDateTime.toIso8601String(),
      'endDateTime': instance.endDateTime.toIso8601String(),
      'rrule': instance.rrule,
      'originalEventId': instance.originalEventId,
      'originalEventStartTime':
          instance.originalEventStartTime?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
