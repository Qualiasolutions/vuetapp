import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/alerts_models.dart';
import 'package:vuet_app/providers/alert_providers.dart';

/// Card component for displaying individual action alerts
class ActionAlertCard extends ConsumerWidget {
  final ActionAlertModel actionAlert;

  const ActionAlertCard({super.key, required this.actionAlert});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: _getAlertColor(actionAlert.type),
            width: 4,
          ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getAlertColor(actionAlert.type).withValues(alpha: 0.1),
          child: Icon(
            _getAlertIcon(actionAlert.type),
            color: _getAlertColor(actionAlert.type),
            size: 20,
          ),
        ),
        title: Text(
          '${actionAlert.type.displayName} (Action)',
          style: TextStyle(
            fontWeight: actionAlert.read ? FontWeight.normal : FontWeight.w600,
            color: actionAlert.read ? Colors.grey[600] : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (actionAlert.additionalData != null && actionAlert.additionalData!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                _getAlertDescription(actionAlert),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
            const SizedBox(height: 4),
            Text(
              _formatDateTime(actionAlert.createdAt),
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
            if (!actionAlert.read)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) => _handleMenuAction(context, ref, value),
              itemBuilder: (context) => [
                if (!actionAlert.read)
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
        onTap: actionAlert.read ? null : () => _markAsRead(ref),
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

  String _getAlertDescription(ActionAlertModel actionAlert) {
    // Extract meaningful description from additional data
    final data = actionAlert.additionalData;
    if (data == null) return '';

    switch (actionAlert.type) {
      case AlertType.taskLimitExceeded:
        return 'Action limit of ${data['limit'] ?? 'unknown'} exceeded';
      case AlertType.taskConflict:
        return 'Action conflicts with ${data['conflictingActionTitle'] ?? 'another action'}';
      case AlertType.unpreferredDay:
        return 'Action scheduled on ${data['dayOfWeek'] ?? 'unpreferred day'}';
      case AlertType.blockedDay:
        return 'Action scheduled on ${data['blockedDate'] ?? 'blocked day'}';
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
    ref.read(actionAlertManagerProvider.notifier).markActionAlertRead(actionAlert.id);
  }

  void _handleMenuAction(BuildContext context, WidgetRef ref, String action) {
    switch (action) {
      case 'mark_read':
        _markAsRead(ref);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Action alert marked as read')),
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
        title: const Text('Delete Action Alert'),
        content: const Text('Are you sure you want to delete this action alert? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(actionAlertManagerProvider.notifier).deleteActionAlert(actionAlert.id, actionAlert.actionId);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Action alert deleted')),
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