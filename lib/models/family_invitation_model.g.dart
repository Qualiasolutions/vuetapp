// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_invitation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FamilyInvitationModelImpl _$$FamilyInvitationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$FamilyInvitationModelImpl(
      id: json['id'] as String,
      inviterId: json['inviterId'] as String,
      inviteeEmail: json['inviteeEmail'] as String,
      familyId: json['familyId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      status: $enumDecodeNullable(
              _$FamilyInvitationStatusEnumMap, json['status']) ??
          FamilyInvitationStatus.pending,
      message: json['message'] as String?,
      inviterName: json['inviterName'] as String?,
      inviterEmail: json['inviterEmail'] as String?,
      familyName: json['familyName'] as String?,
      familyImageUrl: json['familyImageUrl'] as String?,
      respondedAt: json['respondedAt'] == null
          ? null
          : DateTime.parse(json['respondedAt'] as String),
    );

Map<String, dynamic> _$$FamilyInvitationModelImplToJson(
        _$FamilyInvitationModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'inviterId': instance.inviterId,
      'inviteeEmail': instance.inviteeEmail,
      'familyId': instance.familyId,
      'createdAt': instance.createdAt.toIso8601String(),
      'expiresAt': instance.expiresAt.toIso8601String(),
      'status': _$FamilyInvitationStatusEnumMap[instance.status]!,
      'message': instance.message,
      'inviterName': instance.inviterName,
      'inviterEmail': instance.inviterEmail,
      'familyName': instance.familyName,
      'familyImageUrl': instance.familyImageUrl,
      'respondedAt': instance.respondedAt?.toIso8601String(),
    };

const _$FamilyInvitationStatusEnumMap = {
  FamilyInvitationStatus.pending: 'pending',
  FamilyInvitationStatus.accepted: 'accepted',
  FamilyInvitationStatus.declined: 'declined',
  FamilyInvitationStatus.cancelled: 'cancelled',
  FamilyInvitationStatus.expired: 'expired',
};
