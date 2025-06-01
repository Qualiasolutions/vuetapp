import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/notification_model.dart';
import 'package:vuet_app/services/notification_service.dart';
import 'package:vuet_app/ui/theme/app_theme.dart';

/// Widget for displaying a single notification in a list
class NotificationListItem extends ConsumerWidget {
  /// The notification model to display
  final NotificationModel notification;
  
  /// Callback when notification is tapped
  final Function(NotificationModel) onTap;
  
  /// Constructor
  const NotificationListItem({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final notificationService = ref.read(notificationServiceProvider);
    
    return Dismissible(
      key: Key(notification.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        notificationService.deleteNotification(notification.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Notification deleted'),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () {
                // Can't actually undo, just show a message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cannot undo this action')),
                );
              },
            ),
          ),
        );
      },
      child: InkWell(
        onTap: () {
          if (!notification.isRead) {
            notificationService.markAsRead(notification.id);
          }
          onTap(notification);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: _getBackgroundColor(notification),
            border: Border(
              bottom: BorderSide(
                color: theme.dividerColor.withValues(alpha: 0.3),
                width: 1.0,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notification Icon
              Stack(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getNotificationColor(notification),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getNotificationIcon(notification.type),
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  if (notification.importance == NotificationModel.importanceHigh)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              
              // Notification Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      _getNotificationTitle(notification.type),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: notification.isRead 
                            ? FontWeight.normal 
                            : FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    
                    // Message
                    Text(
                      notification.message,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    
                    // Time
                    Text(
                      notification.timeAgo,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Unread indicator
              if (!notification.isRead)
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: AppTheme.notificationUnreadColor,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Get notification icon based on type
  IconData _getNotificationIcon(String type) {
    switch (type) {
      case NotificationModel.typeTaskShared:
        return Icons.share;
      case NotificationModel.typeTaskUpdated:
        return Icons.edit;
      case NotificationModel.typeTaskCommented:
        return Icons.comment;
      case NotificationModel.typeTaskCompleted:
        return Icons.check_circle;
      case NotificationModel.typeTaskReminder:
        return Icons.alarm;
      default:
        return Icons.notifications;
    }
  }
  
  /// Get notification color based on type and importance
  Color _getNotificationColor(NotificationModel notification) {
    // High importance has different coloring
    if (notification.importance == NotificationModel.importanceHigh) {
      switch (notification.type) {
        case NotificationModel.typeTaskReminder:
          return Colors.orange;
        default:
          return AppTheme.primary.withValues(alpha: 0.9);
      }
    }
    
    // Normal importance follows standard colors
    switch (notification.type) {
      case NotificationModel.typeTaskShared:
        return AppTheme.shareColor;
      case NotificationModel.typeTaskUpdated:
        return AppTheme.updateColor;
      case NotificationModel.typeTaskCommented:
        return AppTheme.commentColor;
      case NotificationModel.typeTaskCompleted:
        return AppTheme.successColor;
      case NotificationModel.typeTaskReminder:
        return Colors.amber;
      default:
        return AppTheme.primaryColor;
    }
  }
  
  /// Get background color based on notification state and importance
  Color? _getBackgroundColor(NotificationModel notification) {
    if (notification.isRead) {
      return null; // Use default background for read notifications
    }
    
    // Unread notifications have different background based on importance
    switch (notification.importance) {
      case NotificationModel.importanceHigh:
        return Colors.redAccent.withValues(alpha: 0.1);
      case NotificationModel.importanceNormal:
        return AppTheme.notificationUnreadColor.withValues(alpha: 0.1);
      case NotificationModel.importanceLow:
        return AppTheme.notificationUnreadColor.withValues(alpha: 0.05);
      default:
        return AppTheme.notificationUnreadColor.withValues(alpha: 0.1);
    }
  }
  
  /// Get notification title based on type
  String _getNotificationTitle(String type) {
    switch (type) {
      case NotificationModel.typeTaskShared:
        return 'Task Shared';
      case NotificationModel.typeTaskUpdated:
        return 'Task Updated';
      case NotificationModel.typeTaskCommented:
        return 'New Comment';
      case NotificationModel.typeTaskCompleted:
        return 'Task Completed';
      case NotificationModel.typeTaskReminder:
        return 'Task Reminder';
      default:
        return 'Notification';
    }
  }
}
