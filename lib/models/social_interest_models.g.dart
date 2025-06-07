// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_interest_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HobbyImpl _$$HobbyImplFromJson(Map<String, dynamic> json) => _$HobbyImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      frequency: json['frequency'] as String?,
      lastEngagedDate: json['last_engaged_date'] == null
          ? null
          : DateTime.parse(json['last_engaged_date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$HobbyImplToJson(_$HobbyImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'name': instance.name,
      'description': instance.description,
      'frequency': instance.frequency,
      'last_engaged_date': instance.lastEngagedDate?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_$SocialPlanImpl _$$SocialPlanImplFromJson(Map<String, dynamic> json) =>
    _$SocialPlanImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      planDate: DateTime.parse(json['plan_date'] as String),
      planTime: json['plan_time'] as String?,
      location: json['location'] as String?,
      status: json['status'] as String?,
      withContacts: json['with_contacts'],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$SocialPlanImplToJson(_$SocialPlanImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'title': instance.title,
      'description': instance.description,
      'plan_date': instance.planDate.toIso8601String(),
      'plan_time': instance.planTime,
      'location': instance.location,
      'status': instance.status,
      'with_contacts': instance.withContacts,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_$SocialEventImpl _$$SocialEventImplFromJson(Map<String, dynamic> json) =>
    _$SocialEventImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      startDatetime: DateTime.parse(json['start_datetime'] as String),
      endDatetime: json['end_datetime'] == null
          ? null
          : DateTime.parse(json['end_datetime'] as String),
      locationName: json['location_name'] as String?,
      locationAddress: json['location_address'] as String?,
      isPublic: json['is_public'] as bool? ?? false,
      organizer: json['organizer'] as String?,
      websiteUrl: json['website_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$SocialEventImplToJson(_$SocialEventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'name': instance.name,
      'description': instance.description,
      'start_datetime': instance.startDatetime.toIso8601String(),
      'end_datetime': instance.endDatetime?.toIso8601String(),
      'location_name': instance.locationName,
      'location_address': instance.locationAddress,
      'is_public': instance.isPublic,
      'organizer': instance.organizer,
      'website_url': instance.websiteUrl,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
