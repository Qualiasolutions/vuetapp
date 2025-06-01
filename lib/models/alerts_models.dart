import 'package:freezed_annotation/freezed_annotation.dart';

part 'alerts_models.freezed.dart';
part 'alerts_models.g.dart';

/// Alert model representing task placement alerts
@freezed
class AlertModel with _$AlertModel {
  const factory AlertModel({
    /// Unique identifier for the alert
    required String id,
    
    /// ID of the task this alert is for
    required String taskId,
    
    /// ID of the user this alert belongs to
    required String userId,
    
    /// Type of alert
    required AlertType type,
    
    /// Whether the alert has been read
    @Default(false) bool read,
    
    /// Optional additional data for the alert
    Map<String, dynamic>? additionalData,
    
    /// Creation timestamp
    required DateTime createdAt,
    
    /// Last update timestamp
    required DateTime updatedAt,
  }) = _AlertModel;

  factory AlertModel.fromJson(Map<String, dynamic> json) =>
      _$AlertModelFromJson(json);
}

/// Action alert model representing task action placement alerts
@freezed
class ActionAlertModel with _$ActionAlertModel {
  const factory ActionAlertModel({
    /// Unique identifier for the action alert
    required String id,
    
    /// ID of the task action this alert is for
    required String actionId,
    
    /// ID of the user this alert belongs to
    required String userId,
    
    /// Type of alert
    required AlertType type,
    
    /// Whether the alert has been read
    @Default(false) bool read,
    
    /// Optional additional data for the alert
    Map<String, dynamic>? additionalData,
    
    /// Creation timestamp
    required DateTime createdAt,
    
    /// Last update timestamp
    required DateTime updatedAt,
  }) = _ActionAlertModel;

  factory ActionAlertModel.fromJson(Map<String, dynamic> json) =>
      _$ActionAlertModelFromJson(json);
}

/// Enum for different types of alerts
enum AlertType {
  /// Task limit has been exceeded for a day
  taskLimitExceeded,
  
  /// Task conflicts with another task
  taskConflict,
  
  /// Task is scheduled on an unpreferred day
  unpreferredDay,
  
  /// Task is scheduled on a blocked day
  blockedDay,
}

/// Extension to convert AlertType to string for backend compatibility
extension AlertTypeExtension on AlertType {
  String get value {
    switch (this) {
      case AlertType.taskLimitExceeded:
        return 'TASK_LIMIT_EXCEEDED';
      case AlertType.taskConflict:
        return 'TASK_CONFLICT';
      case AlertType.unpreferredDay:
        return 'UNPREFERRED_DAY';
      case AlertType.blockedDay:
        return 'BLOCKED_DAY';
    }
  }
  
  String get displayName {
    switch (this) {
      case AlertType.taskLimitExceeded:
        return 'Task limit exceeded';
      case AlertType.taskConflict:
        return 'Task conflict';
      case AlertType.unpreferredDay:
        return 'Unpreferred day';
      case AlertType.blockedDay:
        return 'Blocked day';
    }
  }
}

/// Extension to create AlertType from string
extension AlertTypeFromString on String {
  AlertType get toAlertType {
    switch (this) {
      case 'TASK_LIMIT_EXCEEDED':
        return AlertType.taskLimitExceeded;
      case 'TASK_CONFLICT':
        return AlertType.taskConflict;
      case 'UNPREFERRED_DAY':
        return AlertType.unpreferredDay;
      case 'BLOCKED_DAY':
        return AlertType.blockedDay;
      default:
        throw ArgumentError('Unknown alert type: $this');
    }
  }
}

/// Combined model for organizing alerts data
@freezed
class AlertsData with _$AlertsData {
  const factory AlertsData({
    /// Map of alert ID to alert
    @Default({}) Map<String, AlertModel> alertsById,
    
    /// Map of task ID to list of alert IDs
    @Default({}) Map<String, List<String>> alertsByTaskId,
    
    /// Map of action alert ID to action alert
    @Default({}) Map<String, ActionAlertModel> actionAlertsById,
    
    /// Map of action ID to list of action alert IDs
    @Default({}) Map<String, List<String>> actionAlertsByActionId,
    
    /// Whether there are any unread alerts
    @Default(false) bool hasUnreadAlerts,
  }) = _AlertsData;

  factory AlertsData.fromJson(Map<String, dynamic> json) =>
      _$AlertsDataFromJson(json);
} 