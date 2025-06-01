import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/alerts_models.dart';
import 'package:vuet_app/repositories/alert_repository.dart';
import 'package:vuet_app/repositories/implementations/supabase_alert_repository.dart';

part 'alert_providers.g.dart';

/// Provider for alert repository
@riverpod
AlertRepository alertRepository(Ref ref) {
  return SupabaseAlertRepository();
}

/// Provider for all user alerts
@riverpod
Future<List<AlertModel>> userAlerts(Ref ref) async {
  final repository = ref.watch(alertRepositoryProvider);
  return repository.getUserAlerts();
}

/// Provider for all user action alerts
@riverpod
Future<List<ActionAlertModel>> userActionAlerts(Ref ref) async {
  final repository = ref.watch(alertRepositoryProvider);
  return repository.getUserActionAlerts();
}

/// Provider for organized alerts data
@riverpod
Future<AlertsData> alertsData(Ref ref) async {
  final repository = ref.watch(alertRepositoryProvider);
  return repository.getAlertsData();
}

/// Provider for alerts for a specific task
@riverpod
Future<List<AlertModel>> alertsForTask(Ref ref, String taskId) async {
  final repository = ref.watch(alertRepositoryProvider);
  return repository.getAlertsForTask(taskId);
}

/// Provider for action alerts for a specific action
@riverpod
Future<List<ActionAlertModel>> actionAlertsForAction(Ref ref, String actionId) async {
  final repository = ref.watch(alertRepositoryProvider);
  return repository.getActionAlertsForAction(actionId);
}

/// Provider to check if user has unread alerts
@riverpod
Future<bool> hasUnreadAlerts(Ref ref) async {
  final repository = ref.watch(alertRepositoryProvider);
  return repository.hasUnreadAlerts();
}

/// Provider for unread alert count
@riverpod
Future<int> unreadAlertCount(Ref ref) async {
  final repository = ref.watch(alertRepositoryProvider);
  return repository.getUnreadAlertCount();
}

/// Provider for managing alert operations
@riverpod
class AlertManager extends _$AlertManager {
  @override
  AsyncValue<AlertModel?> build() {
    return const AsyncValue.data(null);
  }

  /// Create a new alert
  Future<void> createAlert(AlertModel alert) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(alertRepositoryProvider);
      final result = await repository.createAlert(alert);
      
      state = AsyncValue.data(result);
      
      // Invalidate related providers
      ref.invalidate(userAlertsProvider);
      ref.invalidate(alertsDataProvider);
      ref.invalidate(alertsForTaskProvider(alert.taskId));
      ref.invalidate(hasUnreadAlertsProvider);
      ref.invalidate(unreadAlertCountProvider);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Update an existing alert
  Future<void> updateAlert(AlertModel alert) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(alertRepositoryProvider);
      final result = await repository.updateAlert(alert);
      
      state = AsyncValue.data(result);
      
      // Invalidate related providers
      ref.invalidate(userAlertsProvider);
      ref.invalidate(alertsDataProvider);
      ref.invalidate(alertsForTaskProvider(alert.taskId));
      ref.invalidate(hasUnreadAlertsProvider);
      ref.invalidate(unreadAlertCountProvider);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Delete an alert
  Future<void> deleteAlert(String alertId, String taskId) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(alertRepositoryProvider);
      await repository.deleteAlert(alertId);
      
      state = const AsyncValue.data(null);
      
      // Invalidate related providers
      ref.invalidate(userAlertsProvider);
      ref.invalidate(alertsDataProvider);
      ref.invalidate(alertsForTaskProvider(taskId));
      ref.invalidate(hasUnreadAlertsProvider);
      ref.invalidate(unreadAlertCountProvider);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Mark an alert as read
  Future<void> markAlertRead(String alertId) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(alertRepositoryProvider);
      final result = await repository.markAlertRead(alertId);
      
      state = AsyncValue.data(result);
      
      // Invalidate related providers
      ref.invalidate(userAlertsProvider);
      ref.invalidate(alertsDataProvider);
      ref.invalidate(alertsForTaskProvider(result.taskId));
      ref.invalidate(hasUnreadAlertsProvider);
      ref.invalidate(unreadAlertCountProvider);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Create multiple alerts in batch
  Future<void> createAlertsInBatch(List<AlertModel> alerts) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(alertRepositoryProvider);
      await repository.createAlertsInBatch(alerts);
      
      state = const AsyncValue.data(null);
      
      // Invalidate related providers
      ref.invalidate(userAlertsProvider);
      ref.invalidate(alertsDataProvider);
      ref.invalidate(hasUnreadAlertsProvider);
      ref.invalidate(unreadAlertCountProvider);
      
      // Invalidate alerts for affected tasks
      for (final alert in alerts) {
        ref.invalidate(alertsForTaskProvider(alert.taskId));
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Delete all alerts for a task
  Future<void> deleteAlertsForTask(String taskId) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(alertRepositoryProvider);
      await repository.deleteAlertsForTask(taskId);
      
      state = const AsyncValue.data(null);
      
      // Invalidate related providers
      ref.invalidate(userAlertsProvider);
      ref.invalidate(alertsDataProvider);
      ref.invalidate(alertsForTaskProvider(taskId));
      ref.invalidate(hasUnreadAlertsProvider);
      ref.invalidate(unreadAlertCountProvider);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Provider for managing action alert operations
@riverpod
class ActionAlertManager extends _$ActionAlertManager {
  @override
  AsyncValue<ActionAlertModel?> build() {
    return const AsyncValue.data(null);
  }

  /// Create a new action alert
  Future<void> createActionAlert(ActionAlertModel actionAlert) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(alertRepositoryProvider);
      final result = await repository.createActionAlert(actionAlert);
      
      state = AsyncValue.data(result);
      
      // Invalidate related providers
      ref.invalidate(userActionAlertsProvider);
      ref.invalidate(alertsDataProvider);
      ref.invalidate(actionAlertsForActionProvider(actionAlert.actionId));
      ref.invalidate(hasUnreadAlertsProvider);
      ref.invalidate(unreadAlertCountProvider);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Update an existing action alert
  Future<void> updateActionAlert(ActionAlertModel actionAlert) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(alertRepositoryProvider);
      final result = await repository.updateActionAlert(actionAlert);
      
      state = AsyncValue.data(result);
      
      // Invalidate related providers
      ref.invalidate(userActionAlertsProvider);
      ref.invalidate(alertsDataProvider);
      ref.invalidate(actionAlertsForActionProvider(actionAlert.actionId));
      ref.invalidate(hasUnreadAlertsProvider);
      ref.invalidate(unreadAlertCountProvider);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Delete an action alert
  Future<void> deleteActionAlert(String actionAlertId, String actionId) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(alertRepositoryProvider);
      await repository.deleteActionAlert(actionAlertId);
      
      state = const AsyncValue.data(null);
      
      // Invalidate related providers
      ref.invalidate(userActionAlertsProvider);
      ref.invalidate(alertsDataProvider);
      ref.invalidate(actionAlertsForActionProvider(actionId));
      ref.invalidate(hasUnreadAlertsProvider);
      ref.invalidate(unreadAlertCountProvider);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Mark an action alert as read
  Future<void> markActionAlertRead(String actionAlertId) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(alertRepositoryProvider);
      final result = await repository.markActionAlertRead(actionAlertId);
      
      state = AsyncValue.data(result);
      
      // Invalidate related providers
      ref.invalidate(userActionAlertsProvider);
      ref.invalidate(alertsDataProvider);
      ref.invalidate(actionAlertsForActionProvider(result.actionId));
      ref.invalidate(hasUnreadAlertsProvider);
      ref.invalidate(unreadAlertCountProvider);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Create multiple action alerts in batch
  Future<void> createActionAlertsInBatch(List<ActionAlertModel> actionAlerts) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(alertRepositoryProvider);
      await repository.createActionAlertsInBatch(actionAlerts);
      
      state = const AsyncValue.data(null);
      
      // Invalidate related providers
      ref.invalidate(userActionAlertsProvider);
      ref.invalidate(alertsDataProvider);
      ref.invalidate(hasUnreadAlertsProvider);
      ref.invalidate(unreadAlertCountProvider);
      
      // Invalidate action alerts for affected actions
      for (final actionAlert in actionAlerts) {
        ref.invalidate(actionAlertsForActionProvider(actionAlert.actionId));
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Delete all action alerts for an action
  Future<void> deleteActionAlertsForAction(String actionId) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(alertRepositoryProvider);
      await repository.deleteActionAlertsForAction(actionId);
      
      state = const AsyncValue.data(null);
      
      // Invalidate related providers
      ref.invalidate(userActionAlertsProvider);
      ref.invalidate(alertsDataProvider);
      ref.invalidate(actionAlertsForActionProvider(actionId));
      ref.invalidate(hasUnreadAlertsProvider);
      ref.invalidate(unreadAlertCountProvider);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Provider for global alert operations
@riverpod
class GlobalAlertManager extends _$GlobalAlertManager {
  @override
  AsyncValue<bool> build() {
    return const AsyncValue.data(false);
  }

  /// Mark all alerts as read
  Future<void> markAllAlertsRead() async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(alertRepositoryProvider);
      await repository.markAllAlertsRead();
      
      state = const AsyncValue.data(true);
      
      // Invalidate all alert-related providers
      ref.invalidate(userAlertsProvider);
      ref.invalidate(userActionAlertsProvider);
      ref.invalidate(alertsDataProvider);
      ref.invalidate(hasUnreadAlertsProvider);
      ref.invalidate(unreadAlertCountProvider);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Provider to watch for alert changes and auto-refresh
@riverpod
Stream<AlertsData> alertsStream(Ref ref) async* {
  // This would typically connect to a real-time stream
  // For now, we'll refresh every 30 seconds
  while (true) {
    yield await ref.read(alertsDataProvider.future);
    await Future.delayed(const Duration(seconds: 30));
  }
} 