// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FamilyModelImpl _$$FamilyModelImplFromJson(Map<String, dynamic> json) =>
    _$FamilyModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String?,
      ownerId: json['ownerId'] as String,
      settings: json['settings'] as Map<String, dynamic>? ?? const {},
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      members: (json['members'] as List<dynamic>?)
              ?.map(
                  (e) => FamilyMemberModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$FamilyModelImplToJson(_$FamilyModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'ownerId': instance.ownerId,
      'settings': instance.settings,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'members': instance.members,
    };

_$FamilyMemberModelImpl _$$FamilyMemberModelImplFromJson(
        Map<String, dynamic> json) =>
    _$FamilyMemberModelImpl(
      userId: json['userId'] as String,
      familyId: json['familyId'] as String,
      role: $enumDecodeNullable(_$FamilyRoleEnumMap, json['role']) ??
          FamilyRole.member,
      memberColor: json['memberColor'] as String? ?? '#0066cc',
      joinedAt: DateTime.parse(json['joined_at'] as String),
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$FamilyMemberModelImplToJson(
        _$FamilyMemberModelImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'familyId': instance.familyId,
      'role': _$FamilyRoleEnumMap[instance.role]!,
      'memberColor': instance.memberColor,
      'joined_at': instance.joinedAt.toIso8601String(),
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'profileImageUrl': instance.profileImageUrl,
      'isActive': instance.isActive,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$FamilyRoleEnumMap = {
  FamilyRole.owner: 'owner',
  FamilyRole.admin: 'admin',
  FamilyRole.member: 'member',
};
