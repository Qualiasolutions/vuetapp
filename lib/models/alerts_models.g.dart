// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alerts_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AlertModelImpl _$$AlertModelImplFromJson(Map<String, dynamic> json) =>
    _$AlertModelImpl(
      id: json['id'] as String,
      taskId: json['taskId'] as String,
      userId: json['userId'] as String,
      type: $enumDecode(_$AlertTypeEnumMap, json['type']),
      read: json['read'] as bool? ?? false,
      additionalData: json['additionalData'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$AlertModelImplToJson(_$AlertModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'taskId': instance.taskId,
      'userId': instance.userId,
      'type': _$AlertTypeEnumMap[instance.type]!,
      'read': instance.read,
      'additionalData': instance.additionalData,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$AlertTypeEnumMap = {
  AlertType.taskLimitExceeded: 'taskLimitExceeded',
  AlertType.taskConflict: 'taskConflict',
  AlertType.unpreferredDay: 'unpreferredDay',
  AlertType.blockedDay: 'blockedDay',
};

_$ActionAlertModelImpl _$$ActionAlertModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ActionAlertModelImpl(
      id: json['id'] as String,
      actionId: json['actionId'] as String,
      userId: json['userId'] as String,
      type: $enumDecode(_$AlertTypeEnumMap, json['type']),
      read: json['read'] as bool? ?? false,
      additionalData: json['additionalData'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ActionAlertModelImplToJson(
        _$ActionAlertModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'actionId': instance.actionId,
      'userId': instance.userId,
      'type': _$AlertTypeEnumMap[instance.type]!,
      'read': instance.read,
      'additionalData': instance.additionalData,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$AlertsDataImpl _$$AlertsDataImplFromJson(Map<String, dynamic> json) =>
    _$AlertsDataImpl(
      alertsById: (json['alertsById'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, AlertModel.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      alertsByTaskId: (json['alertsByTaskId'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k, (e as List<dynamic>).map((e) => e as String).toList()),
          ) ??
          const {},
      actionAlertsById:
          (json['actionAlertsById'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(
                    k, ActionAlertModel.fromJson(e as Map<String, dynamic>)),
              ) ??
              const {},
      actionAlertsByActionId:
          (json['actionAlertsByActionId'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(
                    k, (e as List<dynamic>).map((e) => e as String).toList()),
              ) ??
              const {},
      hasUnreadAlerts: json['hasUnreadAlerts'] as bool? ?? false,
    );

Map<String, dynamic> _$$AlertsDataImplToJson(_$AlertsDataImpl instance) =>
    <String, dynamic>{
      'alertsById': instance.alertsById,
      'alertsByTaskId': instance.alertsByTaskId,
      'actionAlertsById': instance.actionAlertsById,
      'actionAlertsByActionId': instance.actionAlertsByActionId,
      'hasUnreadAlerts': instance.hasUnreadAlerts,
    };
