// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'career_entities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CareerGoalImpl _$$CareerGoalImplFromJson(Map<String, dynamic> json) =>
    _$CareerGoalImpl(
      id: json['id'] as String?,
      userId: json['user_id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      targetDate: json['target_date'] == null
          ? null
          : DateTime.parse(json['target_date'] as String),
      status: json['status'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      resourceType: json['resourceType'] as String? ?? 'CareerGoal',
    );

Map<String, dynamic> _$$CareerGoalImplToJson(_$CareerGoalImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'title': instance.title,
      'description': instance.description,
      'target_date': instance.targetDate?.toIso8601String(),
      'status': instance.status,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'resourceType': instance.resourceType,
    };

_$EmployeeImpl _$$EmployeeImplFromJson(Map<String, dynamic> json) =>
    _$EmployeeImpl(
      id: json['id'] as String?,
      userId: json['user_id'] as String?,
      companyName: json['company_name'] as String,
      jobTitle: json['job_title'] as String,
      startDate: json['start_date'] == null
          ? null
          : DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
      isCurrentJob: json['is_current_job'] as bool? ?? true,
      responsibilities: json['responsibilities'] as String?,
      managerName: json['manager_name'] as String?,
      managerEmail: json['manager_email'] as String?,
      nextReviewDate: json['next_review_date'] == null
          ? null
          : DateTime.parse(json['next_review_date'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      resourceType: json['resourceType'] as String? ?? 'Employee',
    );

Map<String, dynamic> _$$EmployeeImplToJson(_$EmployeeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'company_name': instance.companyName,
      'job_title': instance.jobTitle,
      'start_date': instance.startDate?.toIso8601String(),
      'end_date': instance.endDate?.toIso8601String(),
      'is_current_job': instance.isCurrentJob,
      'responsibilities': instance.responsibilities,
      'manager_name': instance.managerName,
      'manager_email': instance.managerEmail,
      'next_review_date': instance.nextReviewDate?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'resourceType': instance.resourceType,
    };
