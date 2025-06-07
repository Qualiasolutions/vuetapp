// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'education_entities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SchoolImpl _$$SchoolImplFromJson(Map<String, dynamic> json) => _$SchoolImpl(
      id: json['id'] as String,
      entityType: json['entityType'] as String? ?? 'School',
      name: json['name'] as String,
      address: json['address'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      email: json['email'] as String?,
      website: json['website'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      ownerId: json['ownerId'] as String?,
    );

Map<String, dynamic> _$$SchoolImplToJson(_$SchoolImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'entityType': instance.entityType,
      'name': instance.name,
      'address': instance.address,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'website': instance.website,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'ownerId': instance.ownerId,
    };

_$StudentImpl _$$StudentImplFromJson(Map<String, dynamic> json) =>
    _$StudentImpl(
      id: json['id'] as String,
      entityType: json['entityType'] as String? ?? 'Student',
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String?,
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      schoolId: json['schoolId'] as String?,
      gradeLevel: json['gradeLevel'] as String?,
      studentIdNumber: json['studentIdNumber'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      ownerId: json['ownerId'] as String?,
    );

Map<String, dynamic> _$$StudentImplToJson(_$StudentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'entityType': instance.entityType,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'schoolId': instance.schoolId,
      'gradeLevel': instance.gradeLevel,
      'studentIdNumber': instance.studentIdNumber,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'ownerId': instance.ownerId,
    };

_$AcademicPlanImpl _$$AcademicPlanImplFromJson(Map<String, dynamic> json) =>
    _$AcademicPlanImpl(
      id: json['id'] as String,
      entityType: json['entityType'] as String? ?? 'AcademicPlan',
      studentId: json['studentId'] as String?,
      planName: json['planName'] as String,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      description: json['description'] as String?,
      goals:
          (json['goals'] as List<dynamic>?)?.map((e) => e as String).toList(),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      ownerId: json['ownerId'] as String?,
    );

Map<String, dynamic> _$$AcademicPlanImplToJson(_$AcademicPlanImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'entityType': instance.entityType,
      'studentId': instance.studentId,
      'planName': instance.planName,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'description': instance.description,
      'goals': instance.goals,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'ownerId': instance.ownerId,
    };

_$SchoolTermImpl _$$SchoolTermImplFromJson(Map<String, dynamic> json) =>
    _$SchoolTermImpl(
      id: json['id'] as String,
      entityType: json['entityType'] as String? ?? 'SchoolTerm',
      schoolId: json['schoolId'] as String?,
      termName: json['termName'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      description: json['description'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      ownerId: json['ownerId'] as String?,
    );

Map<String, dynamic> _$$SchoolTermImplToJson(_$SchoolTermImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'entityType': instance.entityType,
      'schoolId': instance.schoolId,
      'termName': instance.termName,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'description': instance.description,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'ownerId': instance.ownerId,
    };

_$SchoolBreakImpl _$$SchoolBreakImplFromJson(Map<String, dynamic> json) =>
    _$SchoolBreakImpl(
      id: json['id'] as String,
      entityType: json['entityType'] as String? ?? 'SchoolBreak',
      schoolId: json['schoolId'] as String?,
      breakName: json['breakName'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      description: json['description'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      ownerId: json['ownerId'] as String?,
    );

Map<String, dynamic> _$$SchoolBreakImplToJson(_$SchoolBreakImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'entityType': instance.entityType,
      'schoolId': instance.schoolId,
      'breakName': instance.breakName,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'description': instance.description,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'ownerId': instance.ownerId,
    };
