import 'package:uuid/uuid.dart';

/// Model representing a notification in the application
class NotificationModel {
  final String id;
  final String userId;
  final String? taskId;
  final String? groupId;  // For grouping related notifications
  final String type;
  final String message;
  final bool isRead;
  final DateTime createdAt;
  final DateTime? snoozedUntil;  // For snooze functionality
  final Map<String, dynamic> metadata;
  final String importance;
  final String category;  // For categorization and filtering

  NotificationModel({
    String? id,
    required this.userId,
    this.taskId,
    this.groupId,
    required this.type,
    required this.message,
    this.isRead = false,
    DateTime? createdAt,
    this.snoozedUntil,
    Map<String, dynamic>? metadata,
    this.importance = 'normal',
    this.category = 'general',
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        metadata = metadata ?? {};

  /// Valid notification types
  static const String typeTaskShared = 'task_shared';
  static const String typeTaskUpdated = 'task_updated';
  static const String typeTaskCommented = 'task_commented';
  static const String typeTaskCompleted = 'task_completed';
  static const String typeTaskReminder = 'task_reminder';
  static const String typeTaskMention = 'task_mention';  // For @mentions in comments
  static const String typeTaskDeadlineApproaching = 'task_deadline_approaching';
  static const String typeSystemAnnouncement = 'system_announcement';

  /// Notification categories
  static const String categoryTask = 'task';
  static const String categoryComment = 'comment';
  static const String categoryReminder = 'reminder';
  static const String categorySystem = 'system';
  static const String categoryGeneral = 'general';

  /// Notification importance levels
  static const String importanceHigh = 'high';
  static const String importanceNormal = 'normal';
  static const String importanceLow = 'low';
  static const String importanceCritical = 'critical';  // For urgent notifications

  /// Creates a copy of this model with given fields replaced with the new values
  NotificationModel copyWith({
    String? id,
    String? userId,
    String? taskId,
    String? groupId,
    String? type,
    String? message,
    bool? isRead,
    DateTime? createdAt,
    DateTime? snoozedUntil,
    Map<String, dynamic>? metadata,
    String? importance,
    String? category,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      taskId: taskId ?? this.taskId,
      groupId: groupId ?? this.groupId,
      type: type ?? this.type,
      message: message ?? this.message,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      snoozedUntil: snoozedUntil ?? this.snoozedUntil,
      metadata: metadata ?? this.metadata,
      importance: importance ?? this.importance,
      category: category ?? this.category,
    );
  }

  /// Converts model to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile_id': userId, // Changed 'user_id' to 'profile_id'
      'task_id': taskId,
      'group_id': groupId, // This field does not exist in the DB schema for 'notifications'
      'type': type,
      'message': message,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
      'snoozed_until': snoozedUntil?.toIso8601String(), // This field does not exist in the DB schema
      'metadata': metadata,
      'importance': importance, // This field does not exist in the DB schema
      // 'category': category, // Removed as it's not in the DB schema
    };
  }

  /// Creates model from JSON map
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      userId: json['profile_id'] ?? json['user_id'], // Prefer 'profile_id', fallback to 'user_id' for compatibility
      taskId: json['task_id'],
      groupId: json['group_id'],
      type: json['type'],
      message: json['message'],
      isRead: json['is_read'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      snoozedUntil: json['snoozed_until'] != null
          ? DateTime.parse(json['snoozed_until'])
          : null,
      metadata: json['metadata'] ?? {},
      importance: json['importance'] ?? 'normal',
      category: json['category'] ?? 'general',
    );
  }

  /// Returns notification icon based on type
  String get iconForType {
    switch (type) {
      case typeTaskShared:
        return 'share';
      case typeTaskUpdated:
        return 'edit';
      case typeTaskCommented:
        return 'comment';
      case typeTaskCompleted:
        return 'check_circle';
      case typeTaskMention:
        return 'alternate_email';
      case typeTaskDeadlineApproaching:
        return 'schedule';
      case typeSystemAnnouncement:
        return 'campaign';
      default:
        return 'notifications';
    }
  }

  /// Returns true if this notification is related to a task
  bool get isTaskRelated => taskId != null;

  /// Returns true if this notification is snoozed
  bool get isSnoozed => snoozedUntil != null && snoozedUntil!.isAfter(DateTime.now());

  /// Returns true if this notification is part of a group
  bool get isGrouped => groupId != null;

  /// Returns the notification color based on importance
  String get colorForImportance {
    switch (importance) {
      case importanceCritical:
        return 'red';
      case importanceHigh:
        return 'orange';
      case importanceNormal:
        return 'blue';
      case importanceLow:
        return 'grey';
      default:
        return 'blue';
    }
  }

  /// Returns category display name
  String get categoryDisplayName {
    switch (category) {
      case categoryTask:
        return 'Task';
      case categoryComment:
        return 'Comment';
      case categoryReminder:
        return 'Reminder';
      case categorySystem:
        return 'System';
      default:
        return 'General';
    }
  }

  /// Returns a formatted relative time string (e.g. "2 hours ago")
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 7) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
