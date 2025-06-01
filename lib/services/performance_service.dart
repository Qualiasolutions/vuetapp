import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';

/// Service for performance monitoring, crash reporting, and analytics using Supabase
class PerformanceService {
  static final PerformanceService _instance = PerformanceService._internal();
  factory PerformanceService() => _instance;
  PerformanceService._internal();

  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
    ),
  );

  static SupabaseClient? _supabase;
  static final Map<String, Stopwatch> _traces = {};
  static bool _isUserAuthenticated = false; // Added to track auth state

  /// Initialize performance monitoring services
  static Future<void> initialize() async {
    try {
      // Get Supabase client
      _supabase = Supabase.instance.client;

      // Listen to auth changes
      _supabase?.auth.onAuthStateChange.listen((data) {
        final AuthChangeEvent event = data.event;
        _isUserAuthenticated = event == AuthChangeEvent.signedIn || event == AuthChangeEvent.tokenRefreshed || event == AuthChangeEvent.userUpdated;
        if (_isUserAuthenticated && _supabase?.auth.currentUser != null) {
          _logger.i('User authenticated: ${_supabase!.auth.currentUser!.id}');
          setUserId(_supabase!.auth.currentUser!.id); // Set user ID on auth
        } else if (event == AuthChangeEvent.signedOut) {
          _logger.i('User signed out');
        }
      });
      // Check initial auth state
      _isUserAuthenticated = _supabase?.auth.currentUser != null;
      if (_isUserAuthenticated && _supabase?.auth.currentUser != null) { // Ensure currentUser is not null before accessing id
         setUserId(_supabase!.auth.currentUser!.id);
      }


      // Set up error handling
      if (!kDebugMode) {
        FlutterError.onError = (details) {
          recordError(details.exception, details.stack, fatal: true);
        };
        PlatformDispatcher.instance.onError = (error, stack) {
          recordError(error, stack, fatal: true);
          return true;
        };
      }

      _logger.i('Performance monitoring initialized successfully with Supabase');
    } catch (e, stackTrace) {
      _logger.e('Failed to initialize performance monitoring', error: e, stackTrace: stackTrace);
    }
  }

  /// Log a custom performance event to Supabase
  static Future<void> logCustomEvent(String eventName, Map<String, Object>? parameters) async {
    // Delay events if user is not authenticated, except for specific early events
    if (!_isUserAuthenticated && eventName != 'app_open' && eventName != 'memory_usage' && eventName != 'screen_view' /* Add other allowed early events */) {
      // Optionally queue these events to be sent after authentication
      _logger.d('User not authenticated. Event $eventName deferred or skipped.');
      return;
    }

    try {
      if (_supabase != null) {
        await _supabase!.from('performance_events').insert({
          'event_name': eventName,
          'parameters': parameters,
          'timestamp': DateTime.now().toIso8601String(),
          // Use currentUser?.id, which will be null if not authenticated
          // RLS policies will determine if this is allowed
          'user_id': _supabase!.auth.currentUser?.id,
        });
        // Log success only if the insert was successful
        _logger.d('Custom event logged successfully: $eventName');
      } else {
        _logger.w('Supabase client not available. Failed to log custom event: $eventName');
      }
    } catch (e) {
      _logger.w('Failed to log custom event: $eventName', error: e);
    }
  }

  /// Start a performance trace
  static String? startTrace(String traceName) {
    try {
      final stopwatch = Stopwatch()..start();
      _traces[traceName] = stopwatch;
      _logger.d('Started performance trace: $traceName');
      return traceName;
    } catch (e) {
      _logger.w('Failed to start trace: $traceName', error: e);
      return null;
    }
  }

  /// Stop a performance trace
  static Future<void> stopTrace(String? traceName) async {
    if (traceName == null) return;
    
    try {
      final stopwatch = _traces.remove(traceName);
      if (stopwatch != null) {
        stopwatch.stop();
        // Log success only if the insert was successful (handled in logCustomEvent)
        await logCustomEvent('performance_trace', {
          'trace_name': traceName,
          'duration_ms': stopwatch.elapsedMilliseconds,
        });
      }
      // No separate success log here, rely on logCustomEvent's logging
    } catch (e) {
      _logger.w('Failed to stop trace: $traceName', error: e);
    }
  }

  /// Log screen view
  static Future<void> logScreenView(String screenName, String screenClass) async {
    // This event can often happen before full auth, RLS should allow user_id to be null
    await logCustomEvent('screen_view', {
      'screen_name': screenName,
      'screen_class': screenClass,
    });
    // No separate success log here, rely on logCustomEvent's logging
  }

  /// Log app open event
  static Future<void> logAppOpen() async {
    // This event happens early, RLS should allow user_id to be null
    await logCustomEvent('app_open', {
      'timestamp': DateTime.now().toIso8601String(),
    });
    // No separate success log here, rely on logCustomEvent's logging
  }

  /// Log user property
  static Future<void> setUserProperty(String name, String value) async {
    if (!_isUserAuthenticated || _supabase?.auth.currentUser == null) {
       _logger.d('User not authenticated. Set user property $name deferred or skipped.');
       return;
    }
    try {
      if (_supabase != null) {
        await _supabase!.from('user_properties').upsert({
          'user_id': _supabase!.auth.currentUser!.id, // Assumes user is authenticated
          'property_name': name,
          'property_value': value,
          'updated_at': DateTime.now().toIso8601String(),
        });
        _logger.d('User property set successfully: $name = $value');
      } else {
         _logger.w('Supabase client not available. Failed to set user property: $name');
      }
    } catch (e) {
      _logger.w('Failed to set user property: $name', error: e);
    }
  }

  /// Record a non-fatal error
  static Future<void> recordError(dynamic exception, StackTrace? stackTrace, {bool fatal = false}) async {
    try {
      if (_supabase != null) {
        await _supabase!.from('error_logs').insert({
          'error_message': exception.toString(),
          'stack_trace': stackTrace?.toString(),
          'is_fatal': fatal,
          'timestamp': DateTime.now().toIso8601String(),
          'user_id': _supabase!.auth.currentUser?.id, // Can be null
        });
        _logger.e('Error recorded successfully', error: exception, stackTrace: stackTrace);
      } else {
        _logger.w('Supabase client not available. Failed to record error');
      }
    } catch (e) {
      _logger.w('Failed to record error to Supabase', error: e);
    }
  }

  /// Set user identifier for crash reporting (and general performance tracking)
  static Future<void> setUserId(String userId) async {
    // This method is now called internally on auth state change.
    // It could also be used to log an event if needed, but primary use is for associating future events.
    _logger.i('User ID set in PerformanceService: $userId');
    // Example: Log an event that user has been identified
    await logCustomEvent('user_identified', {
       'user_id_set_for_tracking': userId,
     });
  }

  /// Add custom key-value data to crash reports
  static Future<void> setCustomKey(String key, Object value) async {
    // This event might need user context or not, depending on the key
    await logCustomEvent('custom_data_set', { // Changed event name for clarity
      'key': key,
      'value': value,
    });
    // No separate success log here, rely on logCustomEvent's logging
  }

  /// Log performance metrics for database operations
  static Future<T> trackDatabaseOperation<T>(
    String operationName,
    Future<T> Function() operation,
  ) async {
    final trace = startTrace('db_$operationName');
    final stopwatch = Stopwatch()..start();
    
    try {
      final result = await operation();
      stopwatch.stop();
      
      await logCustomEvent('database_operation_success', {
        'operation': operationName,
        'duration_ms': stopwatch.elapsedMilliseconds,
      });
      
      return result;
    } catch (e, stackTrace) {
      stopwatch.stop();
      
      await recordError(e, stackTrace); // recordError now logs its own success/failure
      await logCustomEvent('database_operation_error', {
        'operation': operationName,
        'duration_ms': stopwatch.elapsedMilliseconds,
        'error': e.toString(),
      });
      
      rethrow;
    } finally {
      await stopTrace(trace); // stopTrace uses logCustomEvent
    }
  }

  /// Log performance metrics for network operations
  static Future<T> trackNetworkOperation<T>(
    String operationName,
    Future<T> Function() operation,
  ) async {
    final trace = startTrace('network_$operationName');
    final stopwatch = Stopwatch()..start();
    
    try {
      final result = await operation();
      stopwatch.stop();
      
      await logCustomEvent('network_operation_success', {
        'operation': operationName,
        'duration_ms': stopwatch.elapsedMilliseconds,
      });
      
      return result;
    } catch (e, stackTrace) {
      stopwatch.stop();
      
      await recordError(e, stackTrace); // recordError now logs its own success/failure
      await logCustomEvent('network_operation_error', {
        'operation': operationName,
        'duration_ms': stopwatch.elapsedMilliseconds,
        'error': e.toString(),
      });
      
      rethrow;
    } finally {
      await stopTrace(trace); // stopTrace uses logCustomEvent
    }
  }

  /// Get memory usage information
  static Map<String, dynamic> getMemoryInfo() {
    // ... (keep existing getMemoryInfo implementation)
    if (kIsWeb) {
      return {
        'platform': 'web', 
        'memory_info': 'not_available_on_web',
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
    
    try {
      return {
        'platform': 'mobile',
        'memory_info': 'available_on_mobile_only', // Placeholder
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  /// Log memory usage
  static Future<void> logMemoryUsage(String context) async {
    final memoryInfo = getMemoryInfo();
    // This event can happen early, RLS should allow user_id to be null
    await logCustomEvent('memory_usage', {
      'context': context,
      ...memoryInfo,
    });
    // No separate success log here, rely on logCustomEvent's logging
  }
}
