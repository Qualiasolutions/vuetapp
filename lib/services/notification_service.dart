import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Added Riverpod
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vuet_app/models/notification_model.dart';
import 'package:vuet_app/repositories/notification_repository.dart';
import 'package:vuet_app/repositories/supabase_notification_repository.dart';
import 'package:vuet_app/services/auth_service.dart';
import 'package:vuet_app/services/local_notification_service.dart';
// For supabaseNotificationRepositoryProvider

/// Service for managing notifications in the application
class NotificationService extends ChangeNotifier {
  /// Singleton instance
  // static NotificationService? _instance; // Removed

  /// Repository for notification operations
  final NotificationRepository _repository;

  /// Local notification service for device notifications
  final LocalNotificationService _localNotificationService;

  /// AuthService instance
  final AuthService _authService;

  /// Stream subscription for real-time notifications
  StreamSubscription<List<NotificationModel>>? _notificationsSubscription;

  /// Current notifications list
  List<NotificationModel> _notifications = [];

  /// Unread notifications count
  int _unreadCount = 0;
  
  /// User notification preferences
  Map<String, bool> _notificationPreferences = {};

  /// Default notification preferences
  static const Map<String, bool> _defaultPreferences = {
    'enable_all': true,
    'task_shared': true,
    'task_updated': true,
    'task_commented': true,
    'task_completed': true,
    'task_reminder': true,
    'task_mention': true,
    'task_deadline_approaching': true,
    'system_announcement': true,
    'enable_sound': true,
    'enable_vibration': true,
    'quiet_hours_enabled': false,
    'group_notifications': true,
  };

  /// Quiet hours settings
  String _quietHoursStart = '22:00'; // 10:00 PM
  String _quietHoursEnd = '07:00'; // 7:00 AM
  bool _inQuietHours = false;
  Timer? _quietHoursTimer;

  /// Getter for notifications
  List<NotificationModel> get notifications => _notifications;

  /// Getter for unread count
  int get unreadCount => _unreadCount;
  
  /// Getter for notification preferences
  Map<String, bool> get notificationPreferences => _notificationPreferences;
  
  /// Getter for quiet hours status
  bool get inQuietHours => _inQuietHours;

  /// Getter for quiet hours start time
  String get quietHoursStart => _quietHoursStart;
  
  /// Getter for quiet hours end time
  String get quietHoursEnd => _quietHoursEnd;
  
  /// Getter for sound enabled
  bool get isSoundEnabled => _notificationPreferences['enable_sound'] ?? true;
  
  /// Getter for vibration enabled
  bool get isVibrationEnabled => _notificationPreferences['enable_vibration'] ?? true;

  /// Toggle notification sound
  Future<void> toggleNotificationSound(bool value) async {
    await updateNotificationPreference('enable_sound', value);
  }
  
  /// Toggle notification vibration
  Future<void> toggleNotificationVibration(bool value) async {
    await updateNotificationPreference('enable_vibration', value);
  }

  /// Private constructor
  NotificationService._({
    required NotificationRepository repository,
    LocalNotificationService? localNotificationService,
    required AuthService authService,
  })  : _repository = repository,
        _localNotificationService = localNotificationService ?? LocalNotificationService(),
        _authService = authService {
    // Initialize with default preferences
    _notificationPreferences = Map.from(_defaultPreferences);
  }

  /// Factory constructor for singleton access
  // factory NotificationService({  // Commenting out direct factory, will use Riverpod
  //   NotificationRepository? repository,
  //   LocalNotificationService? localNotificationService,
  // }) {
  //   _instance ??= NotificationService._(
  //     repository: repository,
  //     localNotificationService: localNotificationService,
  //   );
  //   return _instance!;
  // }

  /// Initialize the notification service
  Future<void> initialize() async {
    // Start listening for auth changes
    // Using a type check to ensure AuthService is a ChangeNotifier
    // This listener setup might need to be re-evaluated with Riverpod,
    // as services are typically stateless or manage state via Riverpod's mechanisms.
    // For now, keeping it to see if it integrates.
    // if (AuthService is ChangeNotifier) { // AuthService is static, direct calls are fine
    //   (AuthService as ChangeNotifier).addListener(_handleAuthStateChange); // This won't work as AuthService is not a ChangeNotifier instance
    // }
    // A better way to handle auth changes with Riverpod would be to watch an auth state provider.
    
    // Initialize local notification service
    await _localNotificationService.initialize();
    
    // Load user preferences
    await _loadNotificationPreferences();
    
    // Setup quiet hours timer
    _setupQuietHoursTimer();
    
    // If already signed in, initialize notifications
    if (_authService.isSignedIn) { // Changed
      await _initializeNotifications();
    }

    // Listen to auth state changes from AuthService
    // This is a common pattern but ensure AuthService.authStateChange is correctly providing distinct events
    // or consider using a more Riverpod-idiomatic way to react to auth state.
    _authService.authStateChange.listen((authState) {
      _handleAuthStateChange();
    });
  }

  /// Handle auth state changes
  /// This method will be called if AuthService state changes.
  /// With Riverpod, this might be triggered by watching an authProvider.
  void _handleAuthStateChange() {
    if (_authService.isSignedIn) { // Changed
      _initializeNotifications();
      _loadNotificationPreferences(); // Load user-specific preferences
    } else {
      _clearNotifications();
      // Reset to default preferences
      _notificationPreferences = Map.from(_defaultPreferences);
      _saveNotificationPreferences();
    }
  }

  /// Initialize notifications
  Future<void> _initializeNotifications() async {
    await _loadNotifications();
    await _loadUnreadCount();
    _setupRealtimeSubscription();
  }

  /// Clear notifications when signed out
  void _clearNotifications() {
    _cancelSubscription();
    _notifications = [];
    _unreadCount = 0;
    notifyListeners();
  }

  /// Load notifications from repository
  Future<void> _loadNotifications() async {
    try {
      final notifications = await _repository.getNotifications();
      _processNotifications(notifications);
    } catch (e) {
      debugPrint('Error loading notifications: $e');
    }
  }

  /// Load unread notifications count
  Future<void> _loadUnreadCount() async {
    try {
      _unreadCount = await _repository.getUnreadCount();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading unread count: $e');
    }
  }

  /// Setup real-time subscription for notifications
  void _setupRealtimeSubscription() {
    _cancelSubscription();

    _notificationsSubscription = _repository
        .getNotificationsStream()
        .listen((notifications) {
      _processNotifications(notifications);
    });
  }
  
  /// Process notifications from repository
  void _processNotifications(List<NotificationModel> notifications) {
    // Find new notifications (ones that weren't in the previous list)
    final newNotifications = notifications.where((notification) =>
        !_notifications.any((old) => old.id == notification.id) &&
        !_shouldFilterNotification(notification) &&
        !notification.isSnoozed
    ).toList();
    
    // Apply filtering based on user preferences
    final filteredNotifications = notifications.where(
      (notification) => !_shouldFilterNotification(notification)
    ).toList();
    
    // Group notifications if needed
    final processedNotifications = _notificationPreferences['group_notifications'] == true
        ? _groupNotifications(filteredNotifications)
        : filteredNotifications;
    
    // Show local notifications for new ones if not in quiet hours
    if (!_inQuietHours) {
      for (final notification in newNotifications) {
        _showLocalNotification(notification);
      }
    }
    
    _notifications = processedNotifications;
    // Calculate unread count from notifications
    _unreadCount = processedNotifications.where((n) => !n.isRead).length;
    notifyListeners();
  }
  
  /// Group notifications by task and type
  List<NotificationModel> _groupNotifications(List<NotificationModel> notifications) {
    if (notifications.isEmpty) return notifications;
    
    // First, separate notifications that shouldn't be grouped
    final nonGroupableTypes = [
      NotificationModel.typeSystemAnnouncement,
      NotificationModel.typeTaskReminder,
      NotificationModel.typeTaskMention,
    ];
    
    final nonGroupable = notifications
        .where((n) => nonGroupableTypes.contains(n.type) || n.groupId != null)
        .toList();
        
    final groupable = notifications
        .where((n) => !nonGroupableTypes.contains(n.type) && n.groupId == null)
        .toList();
    
    // Group by task and type
    final groupedMap = <String, List<NotificationModel>>{};
    
    for (final notification in groupable) {
      if (notification.taskId == null) continue;
      
      final key = '${notification.taskId}_${notification.type}';
      if (!groupedMap.containsKey(key)) {
        groupedMap[key] = [];
      }
      groupedMap[key]!.add(notification);
    }
    
    // Create group representatives
    final groupRepresentatives = <NotificationModel>[];
    
    groupedMap.forEach((key, groupNotifications) {
      // If only one notification in group, no need to group
      if (groupNotifications.length <= 1) {
        groupRepresentatives.addAll(groupNotifications);
        return;
      }
      
      // Sort by created date (newest first)
      groupNotifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      // Use the newest notification as the representative
      final newest = groupNotifications.first;
      final count = groupNotifications.length;
      
      // Create a new grouped notification
      final groupId = 'group_${newest.taskId}_${newest.type}_${DateTime.now().millisecondsSinceEpoch}';
      
      final representative = NotificationModel(
        userId: newest.userId,
        taskId: newest.taskId,
        groupId: groupId,
        type: newest.type,
        message: 'You have $count notifications about "${newest.metadata['taskTitle'] ?? 'a task'}"',
        isRead: groupNotifications.every((n) => n.isRead),
        createdAt: newest.createdAt,
        metadata: {
          ...newest.metadata,
          'groupedCount': count,
          'groupedIds': groupNotifications.map((n) => n.id).toList(),
        },
        importance: newest.importance,
        category: newest.category,
      );
      
      groupRepresentatives.add(representative);
    });
    
    // Combine non-groupable with group representatives and sort
    final result = [...nonGroupable, ...groupRepresentatives];
    result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    return result;
  }
  
  /// Load notification preferences from shared preferences
  Future<void> _loadNotificationPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = _authService.currentUser?.id;
      
      if (userId != null && userId.isNotEmpty) {
        final prefString = prefs.getString('notification_preferences_$userId');
        if (prefString != null) {
          final Map<String, dynamic> loadedPrefs = jsonDecode(prefString);
          // Convert dynamic values to bool
          _notificationPreferences = loadedPrefs.map((key, value) => 
              MapEntry(key, value is bool ? value : (value == 'true')));
        }
        
        // Load quiet hours settings
        _quietHoursStart = prefs.getString('quiet_hours_start_$userId') ?? _quietHoursStart;
        _quietHoursEnd = prefs.getString('quiet_hours_end_$userId') ?? _quietHoursEnd;
      }
      
      // Ensure all default keys exist
      _defaultPreferences.forEach((key, defaultValue) {
        _notificationPreferences.putIfAbsent(key, () => defaultValue);
      });
      
      // Update notification service settings
      _updateLocalNotificationSettings();
      
      // Check if we're in quiet hours
      _checkQuietHoursStatus();
      
    } catch (e) {
      debugPrint('Error loading notification preferences: $e');
      // Use defaults if there's an error
      _notificationPreferences = Map.from(_defaultPreferences);
    }
  }

  /// Save notification preferences to shared preferences
  Future<void> _saveNotificationPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = _authService.currentUser?.id;
      
      if (userId != null && userId.isNotEmpty) {
        final prefString = jsonEncode(_notificationPreferences);
        await prefs.setString('notification_preferences_$userId', prefString);
        
        // Save quiet hours settings
        await prefs.setString('quiet_hours_start_$userId', _quietHoursStart);
        await prefs.setString('quiet_hours_end_$userId', _quietHoursEnd);
      }
      
      // Update notification service settings
      _updateLocalNotificationSettings();
      
      // Check if quiet hours status changed
      _checkQuietHoursStatus();
      
    } catch (e) {
      debugPrint('Error saving notification preferences: $e');
    }
  }

  /// Update a specific notification preference
  Future<void> updateNotificationPreference(String key, bool value) async {
    // Apply specific logic, e.g., if 'enable_all' is toggled
    if (key == 'enable_all') {
      _notificationPreferences['enable_all'] = value;
      // If 'enable_all' is false, disable all individual notification types
      // If true, you might want to revert to their previous state or a default enabled state
      // For simplicity, let's just set 'enable_all'. Finer control can be added.
      // if (!value) {
      //   _defaultPreferences.keys.forEach((k) {
      //     if (k != 'enable_all' && k != 'enable_sound' && k != 'enable_vibration' && k != 'quiet_hours_enabled' && k != 'group_notifications') {
      //       _notificationPreferences[k] = false;
      //     }
      //   });
      // }
    } else {
      _notificationPreferences[key] = value;
    }
    
      await _saveNotificationPreferences();
      notifyListeners();
  }
  
  /// Update quiet hours settings
  Future<void> updateQuietHours(String start, String end) async {
    _quietHoursStart = start;
    _quietHoursEnd = end;
    await _saveNotificationPreferences();
    _checkQuietHoursStatus();
    notifyListeners();
  }

  /// Update local notification settings based on preferences
  void _updateLocalNotificationSettings() {
    _localNotificationService.toggleSound(_notificationPreferences['enable_sound'] ?? true);
    _localNotificationService.toggleVibration(_notificationPreferences['enable_vibration'] ?? true);
  }

  /// Check if we're currently in quiet hours
  void _checkQuietHoursStatus() {
    final quietHoursEnabled = _notificationPreferences['quiet_hours_enabled'] ?? false;
    if (!quietHoursEnabled) {
      _inQuietHours = false;
      return;
    }

    final now = DateTime.now();
    final startParts = _quietHoursStart.split(':').map(int.parse).toList();
    final endParts = _quietHoursEnd.split(':').map(int.parse).toList();
    
    final start = TimeOfDay(hour: startParts[0], minute: startParts[1]);
    final end = TimeOfDay(hour: endParts[0], minute: endParts[1]);
    
    final currentTime = TimeOfDay(hour: now.hour, minute: now.minute);
    
    // Check if current time is between start and end
    // Overnight case (e.g., 10:00 PM to 7:00 AM)
    if (start.hour > end.hour || (start.hour == end.hour && start.minute > end.minute)) {
      _inQuietHours = _isTimeAfterOrEqual(currentTime, start) || _isTimeBefore(currentTime, end);
    } else {
      // Same day case
      _inQuietHours = _isTimeAfterOrEqual(currentTime, start) && _isTimeBefore(currentTime, end);
    }
    
    notifyListeners();
  }
  
  /// Helper method to compare TimeOfDay values
  bool _isTimeAfterOrEqual(TimeOfDay time, TimeOfDay reference) {
    return time.hour > reference.hour || 
           (time.hour == reference.hour && time.minute >= reference.minute);
  }
  
  /// Helper method to compare TimeOfDay values
  bool _isTimeBefore(TimeOfDay time, TimeOfDay reference) {
    return time.hour < reference.hour || 
           (time.hour == reference.hour && time.minute < reference.minute);
  }
  
  /// Setup a timer to check quiet hours status
  void _setupQuietHoursTimer() {
    // Cancel existing timer if any
    _quietHoursTimer?.cancel();
    
    // Check immediately
    _checkQuietHoursStatus();
    
    // Schedule a check every minute
    _quietHoursTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _checkQuietHoursStatus();
    });
  }
  
  /// Check if a notification should be filtered based on preferences
  bool _shouldFilterNotification(NotificationModel notification) {
    // If all notifications are disabled, filter out
    if (_notificationPreferences['enable_all'] == false) {
      return true;
    }
    
    // Check specific notification type preference
    final typeKey = notification.type.toLowerCase();
    return _notificationPreferences[typeKey] == false;
  }
  
  /// Check if we should skip creating a notification of a specific type
  bool _shouldSkipNotificationType(String type) {
    // If all notifications are disabled, skip
    if (_notificationPreferences['enable_all'] == false) {
      return true;
    }
    
    // Convert type to preference key
    final typeKey = type.toLowerCase();
    return _notificationPreferences[typeKey] == false;
  }
  
  /// Show a local notification for a new notification
  void _showLocalNotification(NotificationModel notification) {
    // Skip if notification should be filtered, is read or if we're in quiet hours
    if (notification.isRead || 
        _shouldFilterNotification(notification) || 
        _inQuietHours ||
        notification.isSnoozed) {
      return;
    }
    
    _localNotificationService.showNotification(
      title: _getNotificationTitle(notification.type),
      body: notification.message,
      payload: notification.id,
      importance: notification.importance,
    );
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
      case NotificationModel.typeTaskMention:
        return 'You Were Mentioned';
      case NotificationModel.typeTaskDeadlineApproaching:
        return 'Task Deadline Approaching';
      case NotificationModel.typeSystemAnnouncement:
        return 'System Announcement';
      default:
        return 'Notification';
    }
  }

  /// Cancel subscription
  void _cancelSubscription() {
    _notificationsSubscription?.cancel();
    _notificationsSubscription = null;
  }

  /// Mark a notification as read
  Future<bool> markAsRead(String notificationId) async {
    try {
      // Check if this is a grouped notification
      final notification = _notifications.firstWhere(
        (n) => n.id == notificationId,
        orElse: () => NotificationModel(userId: '', type: '', message: ''),
      );
      
      // If this is a grouped notification, mark all notifications in the group as read
      if (notification.groupId != null && notification.metadata.containsKey('groupedIds')) {
        final groupedIds = List<String>.from(notification.metadata['groupedIds']);
        bool allSuccess = true;
        
        for (final id in groupedIds) {
          final success = await _repository.markAsRead(id);
          if (!success) {
            allSuccess = false;
          }
        }
        
        // Refresh notifications after bulk update
        await _loadNotifications();
        return allSuccess;
      } else {
        // Regular notification
        final success = await _repository.markAsRead(notificationId);
        if (success) {
          // Update local state optimistically
          final index = _notifications.indexWhere((n) => n.id == notificationId);
          if (index >= 0) {
            _notifications[index] = _notifications[index].copyWith(isRead: true);
            _unreadCount = _unreadCount > 0 ? _unreadCount - 1 : 0;
            notifyListeners();
          }
        }
        return success;
      }
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
      return false;
    }
  }

  /// Mark all notifications as read
  Future<int> markAllAsRead() async {
    try {
      final count = await _repository.markAllAsRead();
      if (count > 0) {
        // Update local state optimistically
        _notifications = _notifications
            .map((n) => n.copyWith(isRead: true))
            .toList();
        _unreadCount = 0;
        notifyListeners();
      }
      return count;
    } catch (e) {
      debugPrint('Error marking all notifications as read: $e');
      return 0;
    }
  }

  /// Snooze a notification until a specific time
  Future<bool> snoozeNotification(String notificationId, DateTime until) async {
    try {
      // Find the notification
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index < 0) return false;
      
      final notification = _notifications[index];
      
      // Check if this is a grouped notification
      if (notification.groupId != null && notification.metadata.containsKey('groupedIds')) {
        final groupedIds = List<String>.from(notification.metadata['groupedIds']);
        bool allSuccess = true;
        
        for (final id in groupedIds) {
          // Update each notification in the group in the repository
          final notificationToUpdate = await _repository.getById(id);
          if (notificationToUpdate != null) {
            final updated = notificationToUpdate.copyWith(snoozedUntil: until);
            final success = await _repository.updateNotification(updated);
            if (!success) {
              allSuccess = false;
            }
          }
        }
        
        // Refresh notifications after bulk update
        await _loadNotifications();
        return allSuccess;
      } else {
        // Regular notification - update in repository
        final updated = notification.copyWith(snoozedUntil: until);
        final success = await _repository.updateNotification(updated);
        
        if (success) {
          // Update local state optimistically
          _notifications[index] = updated;
          notifyListeners();
        }
        
        return success;
      }
    } catch (e) {
      debugPrint('Error snoozing notification: $e');
      return false;
    }
  }

  /// Cancel snooze for a notification
  Future<bool> cancelSnooze(String notificationId) async {
    try {
      // Find the notification
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index < 0) return false;
      
      final notification = _notifications[index];
      
      // Check if this is a grouped notification
      if (notification.groupId != null && notification.metadata.containsKey('groupedIds')) {
        final groupedIds = List<String>.from(notification.metadata['groupedIds']);
        bool allSuccess = true;
        
        for (final id in groupedIds) {
          // Update each notification in the group in the repository
          final notificationToUpdate = await _repository.getById(id);
          if (notificationToUpdate != null) {
            final updated = notificationToUpdate.copyWith(snoozedUntil: null);
            final success = await _repository.updateNotification(updated);
            if (!success) {
              allSuccess = false;
            }
          }
        }
        
        // Refresh notifications after bulk update
        await _loadNotifications();
        return allSuccess;
      } else {
        // Regular notification - update in repository
        final updated = notification.copyWith(snoozedUntil: null);
        final success = await _repository.updateNotification(updated);
        
        if (success) {
          // Update local state optimistically
          _notifications[index] = updated;
          notifyListeners();
        }
        
        return success;
      }
    } catch (e) {
      debugPrint('Error canceling snooze: $e');
      return false;
    }
  }

  /// Delete a notification
  Future<bool> deleteNotification(String notificationId) async {
    try {
      // Check if this is a grouped notification
      final notification = _notifications.firstWhere(
        (n) => n.id == notificationId,
        orElse: () => NotificationModel(userId: '', type: '', message: ''),
      );
      
      // If this is a grouped notification, delete all notifications in the group
      if (notification.groupId != null && notification.metadata.containsKey('groupedIds')) {
        final groupedIds = List<String>.from(notification.metadata['groupedIds']);
        bool allSuccess = true;
        
        for (final id in groupedIds) {
          final success = await _repository.deleteNotification(id);
          if (!success) {
            allSuccess = false;
          }
        }
        
        // Refresh notifications after bulk delete
        await _loadNotifications();
        return allSuccess;
      } else {
        // Regular notification
        final success = await _repository.deleteNotification(notificationId);
        if (success) {
          // Update local state optimistically
          final wasUnread = _notifications
              .firstWhere((n) => n.id == notificationId, orElse: () => 
                  NotificationModel(
                      userId: '', type: '', message: '', isRead: true))
              .isRead == false;
              
          _notifications.removeWhere((n) => n.id == notificationId);
          
          if (wasUnread) {
            _unreadCount = _unreadCount > 0 ? _unreadCount - 1 : 0;
          }
          
          notifyListeners();
        }
        return success;
      }
    } catch (e) {
      debugPrint('Error deleting notification: $e');
      return false;
    }
  }

  /// Delete all notifications
  Future<int> deleteAllNotifications() async {
    try {
      final count = await _repository.deleteAllNotifications();
      if (count > 0) {
        // Update local state
        _notifications = [];
        _unreadCount = 0;
        notifyListeners();
      }
      return count;
    } catch (e) {
      debugPrint('Error deleting all notifications: $e');
      return 0;
    }
  }

  /// Get notifications related to a specific task
  List<NotificationModel> getNotificationsForTask(String taskId) {
    return _notifications
        .where((notification) => notification.taskId == taskId)
        .toList();
  }
  
  /// Get notifications by category
  List<NotificationModel> getNotificationsByCategory(String category) {
    return _notifications
        .where((notification) => notification.category == category)
        .toList();
  }
  
  /// Create a notification for a task that has been shared with a user
  Future<NotificationModel?> createTaskSharedNotification({
    required String userId,
    required String taskId,
    required String taskTitle,
  }) async {
    try {
      // Skip if this type of notification is disabled
      if (_shouldSkipNotificationType(NotificationModel.typeTaskShared)) {
        return null;
      }
      
      final message = 'Task "$taskTitle" has been shared with you';
      
      final notification = await _repository.createNotification(
        userId: userId,
        type: NotificationModel.typeTaskShared,
        message: message,
        metadata: {
          'taskId': taskId,
          'taskTitle': taskTitle,
        },
        taskId: taskId,
        importance: NotificationModel.importanceHigh,
        category: NotificationModel.categoryTask,
      );
      
      return notification;
    } catch (e) {
      debugPrint('Error creating task shared notification: $e');
      return null;
    }
  }
  
  /// Create a notification for a task that has been updated
  Future<List<NotificationModel>> createTaskUpdatedNotifications({
    required String taskId,
    required String taskTitle,
    required String updatedByUserId,
    required List<String> sharedWithUserIds,
    String? updateDetails,
  }) async {
    try {
      // Skip if this type of notification is disabled
      if (_shouldSkipNotificationType(NotificationModel.typeTaskUpdated)) {
        return [];
      }
      
      final results = <NotificationModel>[];
      final message = updateDetails != null 
          ? 'Task "$taskTitle" was updated: $updateDetails' 
          : 'Task "$taskTitle" was updated';
      
      // Determine importance based on update type
      String importance = NotificationModel.importanceNormal;
      if (updateDetails != null) {
        if (updateDetails.contains('status changed to completed') || 
            updateDetails.contains('due date') ||
            updateDetails.contains('priority changed to high')) {
          importance = NotificationModel.importanceHigh;
        }
      }
      
      // Send notifications to all users the task is shared with
      for (final userId in sharedWithUserIds) {
        // Don't notify the user who made the update
        if (userId == updatedByUserId) continue;
        
        final notification = await _repository.createNotification(
          userId: userId,
          type: NotificationModel.typeTaskUpdated,
          message: message,
          metadata: {
            'taskId': taskId,
            'taskTitle': taskTitle,
            'updatedBy': updatedByUserId,
            if (updateDetails != null) 'updateDetails': updateDetails,
          },
          taskId: taskId,
          importance: importance,
          category: NotificationModel.categoryTask,
        );
        
        results.add(notification);
            }
      
      return results;
    } catch (e) {
      debugPrint('Error creating task updated notifications: $e');
      return [];
    }
  }

  // Format a date for display in notifications
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Create a notification for a task reminder
  Future<NotificationModel?> createTaskReminderNotification({
    required String userId,
    required String taskId,
    required String taskTitle,
    required DateTime dueDate,
  }) async {
    try {
      if (_shouldSkipNotificationType(NotificationModel.typeTaskReminder)) {
        return null;
      }
      // Assuming _formatDate is available in this class
      final message = 'Reminder for task "$taskTitle" due on ${_formatDate(dueDate)}';
      final notification = await _repository.createNotification(
        userId: userId,
        type: NotificationModel.typeTaskReminder,
        message: message,
        metadata: {
          'taskId': taskId,
          'taskTitle': taskTitle,
          'dueDate': dueDate.toIso8601String(),
        },
        taskId: taskId,
        importance: NotificationModel.importanceHigh,
        category: NotificationModel.categoryTask,
      );

      // The conversion to TZDateTime and local scheduling will be handled separately
      // if errors arise related to local_notification_service.scheduleNotification.
      // For now, let's assume dueDate can be passed directly or is handled by local service.
      // final tzDueDate = _localNotificationService.convertToTZDateTime(dueDate);
      // if (tzDueDate != null) { 
      // This is a temporary simplification to ensure the method is added correctly.
      // We will address the TZDateTime later if the error persists.
      try {
          await _localNotificationService.scheduleNotification(
              title: _getNotificationTitle(NotificationModel.typeTaskReminder),
              body: message,
              scheduledDate: dueDate,
              payload: notification.id,
          );
      } catch (e) {
          debugPrint("Error scheduling local notification for reminder: $e. TZDateTime might be required.");
      }
      // } else {
      //     debugPrint("Failed to convert dueDate to TZDateTime for local scheduling.");
      // }
          return notification;
    } catch (e) {
      debugPrint('Error creating task reminder notification: $e');
      return null;
    }
  }
  
  // Create a notification for a comment on a task
  Future<NotificationModel?> createTaskCommentNotification({
    required String userId,
    required String taskId,
    required String taskTitle,
    required String commentedByUserId,
    required String commentText,
  }) async {
    try {
      // Skip if this type of notification is disabled
      if (_shouldSkipNotificationType(NotificationModel.typeTaskCommented)) {
        return null;
      }
      
      // Truncate comment if too long
      final truncatedComment = commentText.length > 100
          ? '${commentText.substring(0, 97)}...'
          : commentText;
      
      // Format message
      final message = 'New comment on task "$taskTitle": "$truncatedComment"';
      
      final notification = await _repository.createNotification(
        userId: userId,
        type: NotificationModel.typeTaskCommented,
        message: message,
        metadata: {
          'taskId': taskId,
          'taskTitle': taskTitle,
          'commentedByUserId': commentedByUserId,
          'commentText': truncatedComment,
        },
        taskId: taskId,
        importance: NotificationModel.importanceNormal,
        category: NotificationModel.categoryTask,
      );
      
      return notification;
    } catch (e) {
      debugPrint('Error creating task comment notification: $e');
      return null;
    }
  }

  /// Schedule a notification to be delivered at a specific time
  /// This method delegates to the LocalNotificationService
  Future<void> scheduleNotification({
    required String title, 
    required String body, 
    required DateTime scheduledDate, 
    String? payload
  }) async {
    try {
      await _localNotificationService.scheduleNotification(
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        payload: payload,
      );
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
    }
  }

  /// Cancel a scheduled notification
  /// This method delegates to the LocalNotificationService
  Future<void> cancelNotification(int notificationId) async {
    try {
      await _localNotificationService.cancelNotification(notificationId);
    } catch (e) {
      debugPrint('Error canceling notification: $e');
    }
  }
}

// Riverpod provider for NotificationService
final notificationServiceProvider = ChangeNotifierProvider<NotificationService>((ref) {
  final authService = ref.watch(authServiceProvider);
  final notificationRepository = ref.watch(supabaseNotificationRepositoryProvider); // Changed
  final service = NotificationService._(
    authService: authService,
    repository: notificationRepository, // Changed
  );
  service.initialize(); // Initialize after creation
  return service;
});
