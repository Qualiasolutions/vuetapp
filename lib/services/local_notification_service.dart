import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_vibrate/flutter_vibrate.dart'; // Commented out due to namespace issues
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vuet_app/models/notification_model.dart';
import 'package:vuet_app/utils/logger.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Service for managing device-level notifications (sound, vibration, etc.)
class LocalNotificationService extends ChangeNotifier {
  // Singleton instance
  static LocalNotificationService? _instance;

  // Flutter local notifications plugin
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Settings
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  // Getters
  bool get soundEnabled => _soundEnabled;
  bool get vibrationEnabled => _vibrationEnabled;

  // Constructor
  LocalNotificationService._();

  /// Factory constructor for singleton access
  factory LocalNotificationService() {
    _instance ??= LocalNotificationService._();
    return _instance!;
  }

  /// Initialize the local notification service
  Future<void> initialize() async {
    // Skip initialization on web platform
    if (kIsWeb) {
      debugPrint('LocalNotificationService: Skipping initialization on web platform');
      await _loadSettings(); // Still load settings from SharedPreferences
      return;
    }

    // Initialize timezone data
    tz.initializeTimeZones();
    // Set the local location
    // final StringcurrentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
    // tz.setLocalLocation(tz.getLocation(currentTimeZone));
    // Using a default or a common one if FlutterNativeTimezone is not available/used
    // For simplicity, let's assume a common default if specific local timezone is not critical for stub.
    // This might need to be made more robust based on app requirements.
    try {
        final String localTimeZoneName = tz.local.name; // Default to system's local if available
        tz.setLocalLocation(tz.getLocation(localTimeZoneName));
    } catch (e) {
        log("Failed to set local timezone automatically, defaulting to UTC: $e", error: e);
        tz.setLocalLocation(tz.getLocation('Etc/UTC'));
    }

    // Load settings from shared preferences
    await _loadSettings();

    // Initialize the notification plugin
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
    
    // Request notification permissions
    await _requestPermissions();
  }

  /// Request notification permissions
  Future<void> _requestPermissions() async {
    if (!kIsWeb) { // Add kIsWeb check
      if (Platform.isIOS) {
        await _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            );
      } else if (Platform.isAndroid) {
        await _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission();
      }
    }
  }

  /// Load notification settings from shared preferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _soundEnabled = prefs.getBool('notification_sound_enabled') ?? true;
    _vibrationEnabled = prefs.getBool('notification_vibration_enabled') ?? true;
    notifyListeners();
  }

  /// Save notification settings to shared preferences
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notification_sound_enabled', _soundEnabled);
    await prefs.setBool('notification_vibration_enabled', _vibrationEnabled);
  }

  /// Toggle sound notifications
  Future<void> toggleSound(bool value) async {
    _soundEnabled = value;
    await _saveSettings();
    notifyListeners();
  }

  /// Toggle vibration notifications
  Future<void> toggleVibration(bool value) async {
    _vibrationEnabled = value;
    await _saveSettings();
    notifyListeners();
  }

  /// Notification tapped callback
  void _onNotificationTapped(NotificationResponse details) {
    // Handle notification tap - can be used to navigate to task details, etc.
    debugPrint('Notification tapped: ${details.payload}');
    // Navigation logic would be implemented here
  }

  /// Show a notification
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
    String importance = NotificationModel.importanceNormal,
  }) async {
    // Skip showing notifications on web platform
    if (kIsWeb) {
      debugPrint('LocalNotificationService: Skipping showNotification on web platform');
      return;
    }

    // Configure sound and vibration based on importance
    await _configureChannels();
    
    final androidDetails = AndroidNotificationDetails(
      'vuet_notifications_${importance.toLowerCase()}',
      'Vuet ${importance.capitalize()} Notifications',
      channelDescription: '${importance.capitalize()} priority notifications from Vuet',
      importance: _getImportanceLevel(importance),
      priority: _getPriorityLevel(importance),
      enableVibration: _vibrationEnabled,
      playSound: _soundEnabled,
    );
    
    final iosDetails = DarwinNotificationDetails(
      presentSound: _soundEnabled,
      presentBadge: true,
      presentAlert: true,
    );
    
    final platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    // Show the notification
    await _flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      platformDetails,
      payload: payload,
    );
    
    // Vibrate if enabled - temporarily disabled due to flutter_vibrate package issues
    if (_vibrationEnabled) {
      // _vibrate(importance);  // Commented out due to flutter_vibrate package issues
      debugPrint('Vibration functionality temporarily disabled');
    }
  }

  /// Configure notification channels
  Future<void> _configureChannels() async {
    // Skip configuring channels on web platform
    if (kIsWeb) {
      return;
    }

    // Create different channels for different notification priorities
    if (Platform.isAndroid) {
      // High priority channel
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(
            const AndroidNotificationChannel(
              'vuet_notifications_high',
              'Vuet High Notifications',
              description: 'High priority notifications from Vuet',
              importance: Importance.high,
            ),
          );
      
      // Normal priority channel  
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(
            const AndroidNotificationChannel(
              'vuet_notifications_normal',
              'Vuet Normal Notifications',
              description: 'Normal priority notifications from Vuet',
              importance: Importance.defaultImportance,
            ),
          );
      
      // Low priority channel
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(
            const AndroidNotificationChannel(
              'vuet_notifications_low',
              'Vuet Low Notifications',
              description: 'Low priority notifications from Vuet',
              importance: Importance.low,
            ),
          );
    }
  }

  /// Get Android importance level from string
  Importance _getImportanceLevel(String importance) {
    switch (importance) {
      case NotificationModel.importanceHigh:
        return Importance.high;
      case NotificationModel.importanceNormal:
        return Importance.defaultImportance;
      case NotificationModel.importanceLow:
        return Importance.low;
      default:
        return Importance.defaultImportance;
    }
  }

  /// Get Android priority level from string
  Priority _getPriorityLevel(String importance) {
    switch (importance) {
      case NotificationModel.importanceHigh:
        return Priority.high;
      case NotificationModel.importanceNormal:
        return Priority.defaultPriority;
      case NotificationModel.importanceLow:
        return Priority.low;
      default:
        return Priority.defaultPriority;
    }
  }

  /// Schedule a notification for a future time
  Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    String importance = NotificationModel.importanceNormal,
  }) async {
    // Skip scheduling notifications on web platform
    if (kIsWeb) {
      debugPrint('LocalNotificationService: Skipping scheduleNotification on web platform');
      return;
    }

    // Configure sound and vibration based on importance
    await _configureChannels();
    
    final androidDetails = AndroidNotificationDetails(
      'vuet_notifications_${importance.toLowerCase()}',
      'Vuet ${importance.capitalize()} Notifications',
      channelDescription: '${importance.capitalize()} priority notifications from Vuet',
      importance: _getImportanceLevel(importance),
      priority: _getPriorityLevel(importance),
      enableVibration: _vibrationEnabled,
      playSound: _soundEnabled,
    );
    
    final iosDetails = DarwinNotificationDetails(
      presentSound: _soundEnabled,
      presentBadge: true,
      presentAlert: true,
    );
    
    final platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    // Schedule the notification
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      DateTime.now().millisecondsSinceEpoch.remainder(100000), // Unique ID for the notification
      title,
      body,
      convertToTZDateTime(scheduledDate), // Use the corrected conversion method
      platformDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      // uiLocalNotificationDateInterpretation has been removed for iOS in later versions,
      // the interpretation is handled by the TZDateTime object itself.
      payload: payload,
    );
  }

  /// Cancel a scheduled notification
  Future<void> cancelNotification(int notificationId) async {
    // Skip canceling notifications on web platform
    if (kIsWeb) {
      debugPrint('LocalNotificationService: Skipping cancelNotification on web platform');
      return;
    }

    try {
      await _flutterLocalNotificationsPlugin.cancel(notificationId);
      debugPrint('Notification with ID $notificationId canceled');
    } catch (e) {
      debugPrint('Error canceling notification: $e');
    }
  }

  /// Convert DateTime to TZDateTime for scheduling
  tz.TZDateTime convertToTZDateTime(DateTime scheduledDate) {
    // Ensure timezone database is initialized
    // tz.initializeTimeZones(); // Already done in initialize()
    // tz.setLocalLocation(tz.getLocation('America/Detroit')); // Example, ensure this is set correctly

    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledTZDate = tz.TZDateTime.from(scheduledDate, tz.local);

    // If scheduled time is in the past, schedule for the next minute to avoid issues
    // Or handle as per specific app logic (e.g., schedule for next day at same time)
    if (scheduledTZDate.isBefore(now)) {
        // This logic might need to be more sophisticated based on requirements
        // For a simple reminder, scheduling it a minute from now if it's past due might be one approach.
        // Or, if it's a specific date/time reminder that's passed, perhaps it shouldn't be scheduled.
        // For now, let's adjust it to be at least a few seconds in the future from 'now'
        // to ensure it's a valid schedule time if the original time was very close to 'now' or slightly past.
        log("Scheduled date for notification was in the past. Adjusting to be in the near future.");
        // return now.add(const Duration(seconds: 5)); // Simple adjustment
        // Let's try to keep the original time but on the next valid occurrence if it's for today but past
        // Or if it's a past date, this example just schedules it for a minute from now.
        // This part depends heavily on the desired behavior for past due reminders.
        
        // A safer bet for generic scheduling of a past due item is to schedule it "soon"
        // Or to decide based on policy (e.g. if more than X time past, don't schedule)
        // For this fix, we ensure it's at least 'now' or slightly after.
        if (scheduledTZDate.isBefore(now)) {
             // If it's for today but earlier, or a past day.
             // Let's try to schedule it for the same time tomorrow if it's a daily type thing,
             // or just default to "now + 5 seconds" if that logic is too complex for here.
             // For simplicity, if in past, make it 5 seconds from now.
             return now.add(const Duration(seconds: 10));
        }
    }
    return scheduledTZDate;
  }

  // Helper method _nextInstanceOfTime is replaced by convertToTZDateTime
  // And the TZDateTime stub is removed.

  // static dynamic get _local => 
  //     tz.TZDateTime.now(tz.local); // This was part of the stub, not needed directly here.
}

/// Extension to capitalize the first letter of a string
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
