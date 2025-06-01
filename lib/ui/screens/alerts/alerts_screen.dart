import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/alerts_models.dart';
import 'package:vuet_app/providers/alert_providers.dart';
import 'package:vuet_app/ui/components/alerts/alert_card.dart';
import 'package:vuet_app/ui/components/alerts/action_alert_card.dart';

/// Screen for displaying and managing user alerts
class AlertsScreen extends ConsumerStatefulWidget {
  const AlertsScreen({super.key});

  @override
  ConsumerState<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends ConsumerState<AlertsScreen> {
  @override
  void initState() {
    super.initState();
    // Auto-mark alerts as read when user enters the screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _markAllAlertsRead();
    });
  }

  Future<void> _markAllAlertsRead() async {
    final hasUnread = await ref.read(hasUnreadAlertsProvider.future);
    if (hasUnread) {
      ref.read(globalAlertManagerProvider.notifier).markAllAlertsRead();
    }
  }

  @override
  Widget build(BuildContext context) {
    final alertsDataAsync = ref.watch(alertsDataProvider);
    final unreadCountAsync = ref.watch(unreadAlertCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Alerts'),
            const SizedBox(width: 8),
            unreadCountAsync.when(
              data: (count) => count > 0
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        count.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_email_read),
            onPressed: () {
              ref.read(globalAlertManagerProvider.notifier).markAllAlertsRead();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All alerts marked as read'),
                ),
              );
            },
            tooltip: 'Mark all as read',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(alertsDataProvider);
              ref.invalidate(unreadAlertCountProvider);
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: alertsDataAsync.when(
        data: (alertsData) => _buildAlertsList(alertsData),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _buildErrorState(error, stackTrace),
      ),
    );
  }

  Widget _buildAlertsList(AlertsData alertsData) {
    final hasAlerts = alertsData.alertsById.isNotEmpty || 
                     alertsData.actionAlertsById.isNotEmpty;

    if (!hasAlerts) {
      return _buildEmptyState();
    }

    // Combine alerts and action alerts for display
    final allItems = <AlertListItem>[];
    
    // Add regular alerts
    for (final taskId in alertsData.alertsByTaskId.keys) {
      allItems.add(AlertListItem.task(taskId: taskId));
    }
    
    // Add action alerts
    for (final actionId in alertsData.actionAlertsByActionId.keys) {
      allItems.add(AlertListItem.action(actionId: actionId));
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(alertsDataProvider);
        ref.invalidate(unreadAlertCountProvider);
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: allItems.length,
        itemBuilder: (context, index) {
          final item = allItems[index];
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: item.when(
              task: (taskId) => TaskAlertsSection(taskId: taskId),
              action: (actionId) => ActionAlertsSection(actionId: actionId),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No alerts',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up! No alerts to review.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error, StackTrace stackTrace) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading alerts',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.red[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.red[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.invalidate(alertsDataProvider);
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

/// Union type for alert list items
sealed class AlertListItem {
  const AlertListItem();
  
  const factory AlertListItem.task({required String taskId}) = TaskAlertItem;
  const factory AlertListItem.action({required String actionId}) = ActionAlertItem;
  
  T when<T>({
    required T Function(String taskId) task,
    required T Function(String actionId) action,
  }) {
    return switch (this) {
      TaskAlertItem(taskId: final taskId) => task(taskId),
      ActionAlertItem(actionId: final actionId) => action(actionId),
    };
  }
}

class TaskAlertItem extends AlertListItem {
  final String taskId;
  
  const TaskAlertItem({required this.taskId});
}

class ActionAlertItem extends AlertListItem {
  final String actionId;
  
  const ActionAlertItem({required this.actionId});
}

/// Widget for displaying alerts for a specific task
class TaskAlertsSection extends ConsumerWidget {
  final String taskId;

  const TaskAlertsSection({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alertsAsync = ref.watch(alertsForTaskProvider(taskId));

    return alertsAsync.when(
      data: (alerts) {
        if (alerts.isEmpty) return const SizedBox.shrink();
        
        return Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.task, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Task Alerts',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        alerts.length.toString(),
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              ...alerts.map((alert) => AlertCard(alert: alert)),
            ],
          ),
        );
      },
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, _) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Error loading task alerts: $error'),
        ),
      ),
    );
  }
}

/// Widget for displaying action alerts for a specific action
class ActionAlertsSection extends ConsumerWidget {
  final String actionId;

  const ActionAlertsSection({super.key, required this.actionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actionAlertsAsync = ref.watch(actionAlertsForActionProvider(actionId));

    return actionAlertsAsync.when(
      data: (actionAlerts) {
        if (actionAlerts.isEmpty) return const SizedBox.shrink();
        
        return Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.play_arrow, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Action Alerts',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        actionAlerts.length.toString(),
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              ...actionAlerts.map((actionAlert) => ActionAlertCard(actionAlert: actionAlert)),
            ],
          ),
        );
      },
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, _) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Error loading action alerts: $error'),
        ),
      ),
    );
  }
} 