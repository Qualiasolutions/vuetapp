import 'package:flutter/foundation.dart';

/// Firebase Performance Monitoring Configuration
/// Configures performance monitoring for web deployment
class FirebasePerformanceConfig {
  static const bool _isProduction = kReleaseMode;
  
  /// Enable performance monitoring in production
  static bool get isPerformanceMonitoringEnabled => _isProduction;
  
  /// Performance monitoring settings
  static const Map<String, dynamic> performanceSettings = {
    'dataCollectionEnabled': true,
    'instrumentationEnabled': true,
    'automaticResourceTracking': true,
    'automaticHttpRequestTracking': true,
  };
  
  /// Custom performance traces to monitor
  static const List<String> customTraces = [
    'app_startup',
    'user_authentication',
    'entity_list_load',
    'entity_detail_load',
    'supabase_query',
    'lana_ai_response',
    'navigation_transition',
  ];
  
  /// Network request patterns to monitor
  static const List<String> monitoredNetworkPatterns = [
    'supabase.co',
    'api.openai.com',
    'googleapis.com',
  ];
  
  /// Performance thresholds (in milliseconds)
  static const Map<String, int> performanceThresholds = {
    'app_startup': 3000,
    'page_load': 2000,
    'api_response': 1500,
    'navigation': 500,
  };
  
  /// Initialize performance monitoring
  static Future<void> initialize() async {
    if (!isPerformanceMonitoringEnabled) return;
    
    try {
      // Performance monitoring initialization would go here
      // This is a placeholder for actual Firebase Performance SDK integration
      if (kDebugMode) {
        print('🔥 Firebase Performance Monitoring initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Failed to initialize Firebase Performance: $e');
      }
    }
  }
  
  /// Start a custom trace
  static void startTrace(String traceName) {
    if (!isPerformanceMonitoringEnabled) return;
    
    try {
      // Custom trace start logic would go here
      if (kDebugMode) {
        print('📊 Started trace: $traceName');
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Failed to start trace $traceName: $e');
      }
    }
  }
  
  /// Stop a custom trace
  static void stopTrace(String traceName) {
    if (!isPerformanceMonitoringEnabled) return;
    
    try {
      // Custom trace stop logic would go here
      if (kDebugMode) {
        print('📊 Stopped trace: $traceName');
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Failed to stop trace $traceName: $e');
      }
    }
  }
  
  /// Record a custom metric
  static void recordMetric(String metricName, int value) {
    if (!isPerformanceMonitoringEnabled) return;
    
    try {
      // Custom metric recording logic would go here
      if (kDebugMode) {
        print('📈 Recorded metric: $metricName = $value');
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Failed to record metric $metricName: $e');
      }
    }
  }
}

/// Performance monitoring mixin for screens
mixin PerformanceMonitoringMixin {
  String get screenName;
  
  void startScreenTrace() {
    FirebasePerformanceConfig.startTrace('${screenName}_load');
  }
  
  void stopScreenTrace() {
    FirebasePerformanceConfig.stopTrace('${screenName}_load');
  }
  
  void recordScreenMetric(String metric, int value) {
    FirebasePerformanceConfig.recordMetric('${screenName}_$metric', value);
  }
}
