// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppUserModelImpl _$$AppUserModelImplFromJson(Map<String, dynamic> json) =>
    _$AppUserModelImpl(
      id: json['id'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      professionalEmail: json['professional_email'] as String?,
      professionalPhone: json['professional_phone'] as String?,
      accountType: json['account_type'] as String? ?? 'personal',
      subscriptionStatus: json['subscription_status'] as String? ?? 'free',
      onboardingCompleted: json['onboarding_completed'] as bool? ?? false,
      dateOfBirth: json['date_of_birth'] == null
          ? null
          : DateTime.parse(json['date_of_birth'] as String),
      memberColor: json['member_color'] as String? ?? '#0066cc',
      familyId: json['family_id'] as String?,
      familyRole: json['family_role'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$AppUserModelImplToJson(_$AppUserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'phone': instance.phone,
      'avatar_url': instance.avatarUrl,
      'professional_email': instance.professionalEmail,
      'professional_phone': instance.professionalPhone,
      'account_type': instance.accountType,
      'subscription_status': instance.subscriptionStatus,
      'onboarding_completed': instance.onboardingCompleted,
      'date_of_birth': instance.dateOfBirth?.toIso8601String(),
      'member_color': instance.memberColor,
      'family_id': instance.familyId,
      'family_role': instance.familyRole,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
