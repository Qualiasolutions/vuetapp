import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vuet_app/models/alerts_models.dart';
import 'package:vuet_app/repositories/alert_repository.dart';

part 'supabase_alert_repository.g.dart';

@riverpod
AlertRepository alertRepository(Ref ref) {
  return SupabaseAlertRepository();
}

/// Supabase implementation of AlertRepository
class SupabaseAlertRepository implements AlertRepository {
  final SupabaseClient _supabase = Supabase.instance.client;
  
  static const String _alertsTable = 'alerts';
  static const String _actionAlertsTable = 'action_alerts';

  /// Get current user ID
  String get _currentUserId {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }
    return userId;
  }

  @override
  Future<List<AlertModel>> getUserAlerts() async {
    try {
      final response = await _supabase
          .from(_alertsTable)
          .select()
          .eq('user_id', _currentUserId)
          .order('created_at', ascending: false);
      
      return response.map((json) => AlertModel.fromJson(json)).toList();
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch user alerts: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error fetching user alerts: $e');
    }
  }

  @override
  Future<List<ActionAlertModel>> getUserActionAlerts() async {
    try {
      final response = await _supabase
          .from(_actionAlertsTable)
          .select()
          .eq('user_id', _currentUserId)
          .order('created_at', ascending: false);
      
      return response.map((json) => ActionAlertModel.fromJson(json)).toList();
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch user action alerts: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error fetching user action alerts: $e');
    }
  }

  @override
  Future<AlertsData> getAlertsData() async {
    try {
      final alerts = await getUserAlerts();
      final actionAlerts = await getUserActionAlerts();
      
      // Organize alerts by ID and task ID
      final Map<String, AlertModel> alertsById = {};
      final Map<String, List<String>> alertsByTaskId = {};
      
      for (final alert in alerts) {
        alertsById[alert.id] = alert;
        
        final taskAlerts = alertsByTaskId[alert.taskId] ?? [];
        taskAlerts.add(alert.id);
        alertsByTaskId[alert.taskId] = taskAlerts;
      }
      
      // Organize action alerts by ID and action ID
      final Map<String, ActionAlertModel> actionAlertsById = {};
      final Map<String, List<String>> actionAlertsByActionId = {};
      
      for (final actionAlert in actionAlerts) {
        actionAlertsById[actionAlert.id] = actionAlert;
        
        final actionAlertsList = actionAlertsByActionId[actionAlert.actionId] ?? [];
        actionAlertsList.add(actionAlert.id);
        actionAlertsByActionId[actionAlert.actionId] = actionAlertsList;
      }
      
      // Check for unread alerts
      final hasUnreadAlerts = alerts.any((alert) => !alert.read) || 
                             actionAlerts.any((actionAlert) => !actionAlert.read);
      
      return AlertsData(
        alertsById: alertsById,
        alertsByTaskId: alertsByTaskId,
        actionAlertsById: actionAlertsById,
        actionAlertsByActionId: actionAlertsByActionId,
        hasUnreadAlerts: hasUnreadAlerts,
      );
    } catch (e) {
      throw Exception('Failed to get alerts data: $e');
    }
  }

  @override
  Future<List<AlertModel>> getAlertsForTask(String taskId) async {
    try {
      final response = await _supabase
          .from(_alertsTable)
          .select()
          .eq('user_id', _currentUserId)
          .eq('task_id', taskId)
          .order('created_at', ascending: false);
      
      return response.map((json) => AlertModel.fromJson(json)).toList();
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch alerts for task: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error fetching alerts for task: $e');
    }
  }

  @override
  Future<List<ActionAlertModel>> getActionAlertsForAction(String actionId) async {
    try {
      final response = await _supabase
          .from(_actionAlertsTable)
          .select()
          .eq('user_id', _currentUserId)
          .eq('action_id', actionId)
          .order('created_at', ascending: false);
      
      return response.map((json) => ActionAlertModel.fromJson(json)).toList();
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch action alerts for action: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error fetching action alerts for action: $e');
    }
  }

  @override
  Future<AlertModel> createAlert(AlertModel alert) async {
    try {
      final data = alert.toJson()
        ..remove('id')
        ..['user_id'] = _currentUserId;
      
      final response = await _supabase
          .from(_alertsTable)
          .insert(data)
          .select()
          .single();
      
      return AlertModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Failed to create alert: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error creating alert: $e');
    }
  }

  @override
  Future<ActionAlertModel> createActionAlert(ActionAlertModel actionAlert) async {
    try {
      final data = actionAlert.toJson()
        ..remove('id')
        ..['user_id'] = _currentUserId;
      
      final response = await _supabase
          .from(_actionAlertsTable)
          .insert(data)
          .select()
          .single();
      
      return ActionAlertModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Failed to create action alert: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error creating action alert: $e');
    }
  }

  @override
  Future<AlertModel> updateAlert(AlertModel alert) async {
    try {
      final updateData = alert.toJson()
        ..remove('id')
        ..remove('created_at')
        ..remove('user_id'); // Don't allow changing user
      
      final response = await _supabase
          .from(_alertsTable)
          .update(updateData)
          .eq('id', alert.id)
          .eq('user_id', _currentUserId)
          .select()
          .single();
      
      return AlertModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Failed to update alert: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error updating alert: $e');
    }
  }

  @override
  Future<ActionAlertModel> updateActionAlert(ActionAlertModel actionAlert) async {
    try {
      final updateData = actionAlert.toJson()
        ..remove('id')
        ..remove('created_at')
        ..remove('user_id'); // Don't allow changing user
      
      final response = await _supabase
          .from(_actionAlertsTable)
          .update(updateData)
          .eq('id', actionAlert.id)
          .eq('user_id', _currentUserId)
          .select()
          .single();
      
      return ActionAlertModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Failed to update action alert: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error updating action alert: $e');
    }
  }

  @override
  Future<void> deleteAlert(String alertId) async {
    try {
      await _supabase
          .from(_alertsTable)
          .delete()
          .eq('id', alertId)
          .eq('user_id', _currentUserId);
    } on PostgrestException catch (e) {
      throw Exception('Failed to delete alert: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error deleting alert: $e');
    }
  }

  @override
  Future<void> deleteActionAlert(String actionAlertId) async {
    try {
      await _supabase
          .from(_actionAlertsTable)
          .delete()
          .eq('id', actionAlertId)
          .eq('user_id', _currentUserId);
    } on PostgrestException catch (e) {
      throw Exception('Failed to delete action alert: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error deleting action alert: $e');
    }
  }

  @override
  Future<void> markAllAlertsRead() async {
    try {
      // Mark all alerts as read
      await _supabase
          .from(_alertsTable)
          .update({'read': true})
          .eq('user_id', _currentUserId)
          .eq('read', false);
      
      // Mark all action alerts as read
      await _supabase
          .from(_actionAlertsTable)
          .update({'read': true})
          .eq('user_id', _currentUserId)
          .eq('read', false);
    } on PostgrestException catch (e) {
      throw Exception('Failed to mark all alerts read: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error marking all alerts read: $e');
    }
  }

  @override
  Future<AlertModel> markAlertRead(String alertId) async {
    try {
      final response = await _supabase
          .from(_alertsTable)
          .update({'read': true})
          .eq('id', alertId)
          .eq('user_id', _currentUserId)
          .select()
          .single();
      
      return AlertModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Failed to mark alert read: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error marking alert read: $e');
    }
  }

  @override
  Future<ActionAlertModel> markActionAlertRead(String actionAlertId) async {
    try {
      final response = await _supabase
          .from(_actionAlertsTable)
          .update({'read': true})
          .eq('id', actionAlertId)
          .eq('user_id', _currentUserId)
          .select()
          .single();
      
      return ActionAlertModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Failed to mark action alert read: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error marking action alert read: $e');
    }
  }

  @override
  Future<bool> hasUnreadAlerts() async {
    try {
      // Check for unread alerts
      final alertsResponse = await _supabase
          .from(_alertsTable)
          .select('id')
          .eq('user_id', _currentUserId)
          .eq('read', false)
          .limit(1);
      
      if (alertsResponse.isNotEmpty) {
        return true;
      }
      
      // Check for unread action alerts
      final actionAlertsResponse = await _supabase
          .from(_actionAlertsTable)
          .select('id')
          .eq('user_id', _currentUserId)
          .eq('read', false)
          .limit(1);
      
      return actionAlertsResponse.isNotEmpty;
    } on PostgrestException catch (e) {
      throw Exception('Failed to check unread alerts: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error checking unread alerts: $e');
    }
  }

  @override
  Future<int> getUnreadAlertCount() async {
    try {
      // Count unread alerts
      final alertsResponse = await _supabase
          .from(_alertsTable)
          .select('id')
          .eq('user_id', _currentUserId)
          .eq('read', false);
      
      // Count unread action alerts
      final actionAlertsResponse = await _supabase
          .from(_actionAlertsTable)
          .select('id')
          .eq('user_id', _currentUserId)
          .eq('read', false);
      
      return alertsResponse.length + actionAlertsResponse.length;
    } on PostgrestException catch (e) {
      throw Exception('Failed to get unread alert count: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting unread alert count: $e');
    }
  }

  @override
  Future<void> deleteAlertsForTask(String taskId) async {
    try {
      await _supabase
          .from(_alertsTable)
          .delete()
          .eq('task_id', taskId)
          .eq('user_id', _currentUserId);
    } on PostgrestException catch (e) {
      throw Exception('Failed to delete alerts for task: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error deleting alerts for task: $e');
    }
  }

  @override
  Future<void> deleteActionAlertsForAction(String actionId) async {
    try {
      await _supabase
          .from(_actionAlertsTable)
          .delete()
          .eq('action_id', actionId)
          .eq('user_id', _currentUserId);
    } on PostgrestException catch (e) {
      throw Exception('Failed to delete action alerts for action: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error deleting action alerts for action: $e');
    }
  }

  @override
  Future<List<AlertModel>> createAlertsInBatch(List<AlertModel> alerts) async {
    try {
      final dataList = alerts.map((alert) {
        final data = alert.toJson()
          ..remove('id')
          ..['user_id'] = _currentUserId;
        return data;
      }).toList();
      
      final response = await _supabase
          .from(_alertsTable)
          .insert(dataList)
          .select();
      
      return response.map((json) => AlertModel.fromJson(json)).toList();
    } on PostgrestException catch (e) {
      throw Exception('Failed to create alerts in batch: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error creating alerts in batch: $e');
    }
  }

  @override
  Future<List<ActionAlertModel>> createActionAlertsInBatch(List<ActionAlertModel> actionAlerts) async {
    try {
      final dataList = actionAlerts.map((actionAlert) {
        final data = actionAlert.toJson()
          ..remove('id')
          ..['user_id'] = _currentUserId;
        return data;
      }).toList();
      
      final response = await _supabase
          .from(_actionAlertsTable)
          .insert(dataList)
          .select();
      
      return response.map((json) => ActionAlertModel.fromJson(json)).toList();
    } on PostgrestException catch (e) {
      throw Exception('Failed to create action alerts in batch: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error creating action alerts in batch: $e');
    }
  }
} 