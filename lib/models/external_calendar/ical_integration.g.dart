// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ical_integration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ICalIntegrationImpl _$$ICalIntegrationImplFromJson(
        Map<String, dynamic> json) =>
    _$ICalIntegrationImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      icalName: json['icalName'] as String,
      icalUrl: json['icalUrl'] as String,
      icalType: $enumDecode(_$ICalTypeEnumMap, json['icalType']),
      shareType: $enumDecode(_$ICalShareTypeEnumMap, json['shareType']),
      lastSyncedAt: json['lastSyncedAt'] == null
          ? null
          : DateTime.parse(json['lastSyncedAt'] as String),
      syncStatus: $enumDecodeNullable(_$SyncStatusEnumMap, json['syncStatus']),
      syncErrorMessage: json['syncErrorMessage'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ICalIntegrationImplToJson(
        _$ICalIntegrationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'icalName': instance.icalName,
      'icalUrl': instance.icalUrl,
      'icalType': _$ICalTypeEnumMap[instance.icalType]!,
      'shareType': _$ICalShareTypeEnumMap[instance.shareType]!,
      'lastSyncedAt': instance.lastSyncedAt?.toIso8601String(),
      'syncStatus': _$SyncStatusEnumMap[instance.syncStatus],
      'syncErrorMessage': instance.syncErrorMessage,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$ICalTypeEnumMap = {
  ICalType.unknown: 'unknown',
  ICalType.google: 'google',
  ICalType.icloud: 'icloud',
  ICalType.outlook: 'outlook',
};

const _$ICalShareTypeEnumMap = {
  ICalShareType.off: 'off',
  ICalShareType.busy: 'busy',
  ICalShareType.full: 'full',
};

const _$SyncStatusEnumMap = {
  SyncStatus.pending: 'pending',
  SyncStatus.success: 'success',
  SyncStatus.failed: 'failed',
  SyncStatus.never: 'never',
};
