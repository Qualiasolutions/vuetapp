import 'package:vuet_app/models/alerts_models.dart';

/// Abstract repository interface for alerts
abstract class AlertRepository {
  /// Get all alerts for the current user
  Future<List<AlertModel>> getUserAlerts();
  
  /// Get all action alerts for the current user
  Future<List<ActionAlertModel>> getUserActionAlerts();
  
  /// Get alerts organized as AlertsData structure
  Future<AlertsData> getAlertsData();
  
  /// Get alerts for a specific task
  Future<List<AlertModel>> getAlertsForTask(String taskId);
  
  /// Get action alerts for a specific action
  Future<List<ActionAlertModel>> getActionAlertsForAction(String actionId);
  
  /// Create a new alert
  Future<AlertModel> createAlert(AlertModel alert);
  
  /// Create a new action alert
  Future<ActionAlertModel> createActionAlert(ActionAlertModel actionAlert);
  
  /// Update an existing alert
  Future<AlertModel> updateAlert(AlertModel alert);
  
  /// Update an existing action alert
  Future<ActionAlertModel> updateActionAlert(ActionAlertModel actionAlert);
  
  /// Delete an alert by ID
  Future<void> deleteAlert(String alertId);
  
  /// Delete an action alert by ID
  Future<void> deleteActionAlert(String actionAlertId);
  
  /// Mark all alerts as read for the current user
  Future<void> markAllAlertsRead();
  
  /// Mark a specific alert as read
  Future<AlertModel> markAlertRead(String alertId);
  
  /// Mark a specific action alert as read
  Future<ActionAlertModel> markActionAlertRead(String actionAlertId);
  
  /// Check if there are any unread alerts
  Future<bool> hasUnreadAlerts();
  
  /// Get count of unread alerts
  Future<int> getUnreadAlertCount();
  
  /// Delete all alerts for a specific task (when task is deleted)
  Future<void> deleteAlertsForTask(String taskId);
  
  /// Delete all action alerts for a specific action (when action is deleted)
  Future<void> deleteActionAlertsForAction(String actionId);
  
  /// Create multiple alerts in batch
  Future<List<AlertModel>> createAlertsInBatch(List<AlertModel> alerts);
  
  /// Create multiple action alerts in batch
  Future<List<ActionAlertModel>> createActionAlertsInBatch(List<ActionAlertModel> actionAlerts);
} 