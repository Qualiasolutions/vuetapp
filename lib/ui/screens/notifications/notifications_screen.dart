import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/notification_model.dart';
// Import the correct provider from the service file
import 'package:vuet_app/services/notification_service.dart' show notificationServiceProvider; 
import 'package:intl/intl.dart'; // For date formatting

// Provider for just the unread count, to avoid rebuilding widgets that only need the count
final unreadNotificationCountProvider = Provider<int>((ref) {
  // Watch the globally defined notificationServiceProvider
  return ref.watch(notificationServiceProvider).unreadCount;
});

// Provider for the list of notifications
final notificationsListProvider = Provider<List<NotificationModel>>((ref) {
  // Watch the globally defined notificationServiceProvider
  return ref.watch(notificationServiceProvider).notifications;
});

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key}); // Changed Key? key to super.key

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsListProvider);
    final notificationService = ref.watch(notificationServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (notifications.any((n) => !n.isRead))
            TextButton(
              onPressed: () async {
                await notificationService.markAllAsRead();
                // No action needed after markAllAsRead, so no context usage
              },
              child: const Text('Mark All Read', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Text(
                'No notifications yet.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return ListTile(
                  leading: Icon(
                    _getIconForNotificationType(notification.type),
                    color: notification.isRead ? Colors.grey : Theme.of(context).primaryColor,
                  ),
                  title: Text(
                    notification.message,
                    style: TextStyle(
                      fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${DateFormat.yMMMd().add_jm().format(notification.createdAt.toLocal())} (${notification.categoryDisplayName})',
                  ),
                  trailing: notification.isRead
                      ? null
                      : const Icon(Icons.circle, color: Colors.blueAccent, size: 12),
                  onTap: () async {
                    // TODO: Implement navigation based on notification type/metadata
                    // e.g., navigate to task detail if taskId is present
                    debugPrint('Notification tapped: ${notification.id}, type: ${notification.type}, taskId: ${notification.taskId}');
                    if (!notification.isRead) {
                      await notificationService.markAsRead(notification.id);
                    }
                  },
                  onLongPress: () { // Example: Delete on long press
                    showDialog(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                              title: const Text('Delete Notification?'),
                              content: Text(notification.message),
                              actions: [
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () => Navigator.of(dialogContext).pop(),
                                ),
                                TextButton(
                                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                  onPressed: () async {
                                    await notificationService.deleteNotification(notification.id);
                                    if (dialogContext.mounted) { // Guard against async gap
                                      Navigator.of(dialogContext).pop();
                                    }
                                  },
                                ),
                              ],
                            ));
                  },
                );
              },
            ),
    );
  }

  IconData _getIconForNotificationType(String type) {
    // Using a simplified version of NotificationModel.iconForType
    switch (type) {
      case NotificationModel.typeTaskShared: return Icons.share;
      case NotificationModel.typeTaskUpdated: return Icons.edit_note;
      case NotificationModel.typeTaskCommented: return Icons.comment_outlined;
      case NotificationModel.typeTaskCompleted: return Icons.check_circle_outline;
      case NotificationModel.typeTaskReminder: return Icons.alarm;
      case NotificationModel.typeTaskMention: return Icons.alternate_email;
      case NotificationModel.typeTaskDeadlineApproaching: return Icons.schedule_outlined;
      case NotificationModel.typeSystemAnnouncement: return Icons.campaign_outlined;
      default: return Icons.notifications_outlined;
    }
  }
}
