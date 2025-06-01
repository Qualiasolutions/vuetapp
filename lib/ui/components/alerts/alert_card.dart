import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/alerts_models.dart';
import 'package:vuet_app/providers/alert_providers.dart';

/// Card component for displaying individual task alerts
class AlertCard extends ConsumerWidget {
  final AlertModel alert;

  const AlertCard({super.key, required this.alert});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: _getAlertColor(alert.type),
            width: 4,
          ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getAlertColor(alert.type).withValues(alpha: 0.1),
          child: Icon(
            _getAlertIcon(alert.type),
            color: _getAlertColor(alert.type),
            size: 20,
          ),
        ),
        title: Text(
          alert.type.displayName,
          style: TextStyle(
            fontWeight: alert.read ? FontWeight.normal : FontWeight.w600,
            color: alert.read ? Colors.grey[600] : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (alert.additionalData != null && alert.additionalData!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                _getAlertDescription(alert),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
            const SizedBox(height: 4),
            Text(
              _formatDateTime(alert.createdAt),
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!alert.read)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) => _handleMenuAction(context, ref, value),
              itemBuilder: (context) => [
                if (!alert.read)
                  const PopupMenuItem(
                    value: 'mark_read',
                    child: ListTile(
                      leading: Icon(Icons.mark_email_read),
                      title: Text('Mark as read'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                const PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete, color: Colors.red),
                    title: Text('Delete', style: TextStyle(color: Colors.red)),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: alert.read ? null : () => _markAsRead(ref),
      ),
    );
  }

  Color _getAlertColor(AlertType type) {
    switch (type) {
      case AlertType.taskLimitExceeded:
        return Colors.red;
      case AlertType.taskConflict:
        return Colors.orange;
      case AlertType.unpreferredDay:
        return Colors.amber;
      case AlertType.blockedDay:
        return Colors.purple;
    }
  }

  IconData _getAlertIcon(AlertType type) {
    switch (type) {
      case AlertType.taskLimitExceeded:
        return Icons.warning;
      case AlertType.taskConflict:
        return Icons.sync_problem;
      case AlertType.unpreferredDay:
        return Icons.event_busy;
      case AlertType.blockedDay:
        return Icons.block;
    }
  }

  String _getAlertDescription(AlertModel alert) {
    // Extract meaningful description from additional data
    final data = alert.additionalData;
    if (data == null) return '';

    switch (alert.type) {
      case AlertType.taskLimitExceeded:
        return 'Task limit of ${data['limit'] ?? 'unknown'} exceeded';
      case AlertType.taskConflict:
        return 'Conflicts with ${data['conflictingTaskTitle'] ?? 'another task'}';
      case AlertType.unpreferredDay:
        return 'Scheduled on ${data['dayOfWeek'] ?? 'unpreferred day'}';
      case AlertType.blockedDay:
        return 'Scheduled on ${data['blockedDate'] ?? 'blocked day'}';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  void _markAsRead(WidgetRef ref) {
    ref.read(alertManagerProvider.notifier).markAlertRead(alert.id);
  }

  void _handleMenuAction(BuildContext context, WidgetRef ref, String action) {
    switch (action) {
      case 'mark_read':
        _markAsRead(ref);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Alert marked as read')),
        );
        break;
      case 'delete':
        _showDeleteConfirmation(context, ref);
        break;
    }
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Alert'),
        content: const Text('Are you sure you want to delete this alert? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(alertManagerProvider.notifier).deleteAlert(alert.id, alert.taskId);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Alert deleted')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
} 