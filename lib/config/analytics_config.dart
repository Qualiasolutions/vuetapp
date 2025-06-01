import 'package:flutter/foundation.dart';

/// Analytics Configuration for Vuet App
/// Handles user engagement tracking and app analytics
class AnalyticsConfig {
  static const bool _isProduction = kReleaseMode;
  
  /// Enable analytics in production
  static bool get isAnalyticsEnabled => _isProduction;
  
  /// Analytics events to track
  static const Map<String, String> events = {
    // User Authentication
    'user_login': 'user_login',
    'user_logout': 'user_logout',
    'user_signup': 'user_signup',
    
    // Navigation Events
    'screen_view': 'screen_view',
    'navigation_action': 'navigation_action',
    
    // Entity Management
    'entity_created': 'entity_created',
    'entity_updated': 'entity_updated',
    'entity_deleted': 'entity_deleted',
    'entity_viewed': 'entity_viewed',
    
    // Category Usage
    'category_accessed': 'category_accessed',
    'subcategory_accessed': 'subcategory_accessed',
    
    // LANA AI Usage
    'lana_chat_started': 'lana_chat_started',
    'lana_message_sent': 'lana_message_sent',
    'lana_response_received': 'lana_response_received',
    
    // Task Management
    'task_created': 'task_created',
    'task_completed': 'task_completed',
    'list_created': 'list_created',
    
    // Performance Events
    'app_startup_time': 'app_startup_time',
    'page_load_time': 'page_load_time',
    'api_response_time': 'api_response_time',
    
    // Error Events
    'error_occurred': 'error_occurred',
    'crash_reported': 'crash_reported',
  };
  
  /// User properties to track
  static const Map<String, String> userProperties = {
    'user_type': 'user_type', // free, premium
    'app_version': 'app_version',
    'platform': 'platform',
    'device_type': 'device_type',
    'preferred_language': 'preferred_language',
    'signup_date': 'signup_date',
    'last_active': 'last_active',
  };
  
  /// Custom dimensions for detailed tracking
  static const Map<String, String> customDimensions = {
    'entity_category': 'entity_category',
    'entity_type': 'entity_type',
    'screen_name': 'screen_name',
    'feature_used': 'feature_used',
    'error_type': 'error_type',
    'performance_metric': 'performance_metric',
  };
  
  /// Initialize analytics
  static Future<void> initialize() async {
    if (!isAnalyticsEnabled) return;
    
    try {
      // Analytics initialization would go here
      // This is a placeholder for actual Firebase Analytics SDK integration
      if (kDebugMode) {
        print('📊 Analytics initialized');
      }
      
      // Set default user properties
      await setUserProperty('platform', 'web');
      await setUserProperty('app_version', '1.0.0');
      
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Failed to initialize Analytics: $e');
      }
    }
  }
  
  /// Log an event
  static Future<void> logEvent(String eventName, {Map<String, dynamic>? parameters}) async {
    if (!isAnalyticsEnabled) return;
    
    try {
      // Event logging logic would go here
      if (kDebugMode) {
        print('📈 Event logged: $eventName ${parameters != null ? 'with parameters: $parameters' : ''}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Failed to log event $eventName: $e');
      }
    }
  }
  
  /// Set user property
  static Future<void> setUserProperty(String name, String value) async {
    if (!isAnalyticsEnabled) return;
    
    try {
      // User property setting logic would go here
      if (kDebugMode) {
        print('👤 User property set: $name = $value');
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Failed to set user property $name: $e');
      }
    }
  }
  
  /// Log screen view
  static Future<void> logScreenView(String screenName, {String? screenClass}) async {
    await logEvent(events['screen_view']!, parameters: {
      'screen_name': screenName,
      'screen_class': screenClass ?? screenName,
    });
  }
  
  /// Log user authentication
  static Future<void> logUserAuth(String action, {String? method}) async {
    await logEvent(events['user_$action']!, parameters: {
      'method': method ?? 'email',
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  /// Log entity operations
  static Future<void> logEntityOperation(String operation, String entityType, String category) async {
    await logEvent(events['entity_$operation']!, parameters: {
      'entity_type': entityType,
      'category': category,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  /// Log LANA AI usage
  static Future<void> logLanaUsage(String action, {Map<String, dynamic>? additionalData}) async {
    final parameters = <String, dynamic>{
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    if (additionalData != null) {
      parameters.addAll(additionalData);
    }
    
    await logEvent(events['lana_$action']!, parameters: parameters);
  }
  
  /// Log performance metrics
  static Future<void> logPerformanceMetric(String metricName, int value, {String? category}) async {
    await logEvent(events['${metricName}_time']!, parameters: {
      'metric_name': metricName,
      'value': value,
      'category': category,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  /// Log errors
  static Future<void> logError(String errorType, String errorMessage, {String? stackTrace}) async {
    await logEvent(events['error_occurred']!, parameters: {
      'error_type': errorType,
      'error_message': errorMessage,
      'stack_trace': stackTrace,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  /// Set user ID for tracking
  static Future<void> setUserId(String userId) async {
    if (!isAnalyticsEnabled) return;
    
    try {
      // User ID setting logic would go here
      if (kDebugMode) {
        print('👤 User ID set: $userId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Failed to set user ID: $e');
      }
    }
  }
}

/// Analytics mixin for screens
mixin AnalyticsMixin {
  String get screenName;
  String? get screenClass => null;
  
  void logScreenView() {
    AnalyticsConfig.logScreenView(screenName, screenClass: screenClass);
  }
  
  void logScreenAction(String action, {Map<String, dynamic>? parameters}) {
    final params = <String, dynamic>{
      'screen_name': screenName,
      'action': action,
    };
    
    if (parameters != null) {
      params.addAll(parameters);
    }
    
    AnalyticsConfig.logEvent('screen_action', parameters: params);
  }
}
