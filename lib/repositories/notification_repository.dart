import 'package:vuet_app/models/notification_model.dart';

/// Repository interface for notification operations
abstract class NotificationRepository {
  /// Get all notifications for the current user
  Future<List<NotificationModel>> getNotifications();

  /// Get unread notifications count for the current user
  Future<int> getUnreadCount();

  /// Mark a notification as read
  /// Returns true if successful
  Future<bool> markAsRead(String notificationId);

  /// Mark all notifications as read
  /// Returns the number of notifications marked as read
  Future<int> markAllAsRead();

  /// Delete a notification
  /// Returns true if successful
  Future<bool> deleteNotification(String notificationId);

  /// Get a stream of notifications for the current user
  /// Used for real-time updates
  Stream<List<NotificationModel>> getNotificationsStream();

  /// Create a new notification for a specific user
  /// Returns the created notification
  Future<NotificationModel> createNotification({
    required String userId,
    required String type,
    required String message,
    Map<String, dynamic>? metadata,
    String? taskId,
    String importance = NotificationModel.importanceNormal,
    String category = NotificationModel.categoryGeneral,
  });

  /// Send a test notification (for development purposes)
  /// Returns the created notification
  Future<NotificationModel> sendTestNotification({
    required String message,
    String type = NotificationModel.typeTaskUpdated,
    String importance = NotificationModel.importanceNormal,
  });
  
  /// Get a notification by ID
  /// Returns the notification, or null if not found
  Future<NotificationModel?> getById(String id);

  /// Update an existing notification
  /// Returns true if successful
  Future<bool> updateNotification(NotificationModel notification);

  /// Delete all notifications for the current user
  /// Returns the number of notifications deleted
  Future<int> deleteAllNotifications();
}
