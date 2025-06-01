import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart'; // Added for kDebugMode
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Centralized realtime subscription manager to prevent subscription leaks
class RealtimeSubscriptionManager {
  static final RealtimeSubscriptionManager _instance = RealtimeSubscriptionManager._internal();
  factory RealtimeSubscriptionManager() => _instance;
  RealtimeSubscriptionManager._internal();

  final Map<String, StreamSubscription> _subscriptions = {};
  final Map<String, StreamController> _controllers = {};
  final SupabaseClient _client = Supabase.instance.client;

  /// Get or create a shared stream for a table
  Stream<List<Map<String, dynamic>>> getTableStream(
    String tableName, {
    String? filter,
    String? filterValue,
    List<String>? primaryKey,
  }) {
    final key = _buildKey(tableName, filter, filterValue);
    
    if (_controllers.containsKey(key)) {
      return _controllers[key]!.stream.cast<List<Map<String, dynamic>>>();
    }

    final controller = StreamController<List<Map<String, dynamic>>>.broadcast();
    _controllers[key] = controller;

    // Create subscription
    final baseQuery = _client.from(tableName).stream(primaryKey: primaryKey ?? ['id']);
    
    final query = (filter != null && filterValue != null) 
        ? baseQuery.eq(filter, filterValue)
        : baseQuery;

    final subscription = query.listen(
      (data) {
        if (!controller.isClosed) {
          controller.add(data);
        }
      },
      onError: (error) {
        if (kDebugMode) {
          developer.log('Realtime error for $key: $error');
        }
        if (!controller.isClosed) {
          controller.addError(error);
        }
      },
    );

    _subscriptions[key] = subscription;

    // Clean up when no listeners
    controller.onCancel = () {
      _cleanupSubscription(key);
    };

    return controller.stream.cast<List<Map<String, dynamic>>>();
  }

  /// Build unique key for subscription
  String _buildKey(String tableName, String? filter, String? filterValue) {
    return '$tableName${filter != null ? '_$filter' : ''}${filterValue != null ? '_$filterValue' : ''}';
  }

  /// Clean up specific subscription
  void _cleanupSubscription(String key) {
    _subscriptions[key]?.cancel();
    _subscriptions.remove(key);
    
    final controller = _controllers[key];
    if (controller != null && !controller.isClosed) {
      controller.close();
    }
    _controllers.remove(key);
    
    // if (kDebugMode) { // Already commented out, but good practice if it were active
    //   developer.log('Cleaned up subscription: $key');
    // }
  }

  /// Clean up all subscriptions
  void dispose() {
    for (final subscription in _subscriptions.values) {
      subscription.cancel();
    }
    _subscriptions.clear();

    for (final controller in _controllers.values) {
      if (!controller.isClosed) {
        controller.close();
      }
    }
    _controllers.clear();
    
    if (kDebugMode) {
      developer.log('Disposed all realtime subscriptions');
    }
  }

  /// Get subscription count for monitoring
  int get activeSubscriptionCount => _subscriptions.length;
}

/// Provider for the subscription manager
final realtimeSubscriptionManagerProvider = Provider<RealtimeSubscriptionManager>((ref) {
  final manager = RealtimeSubscriptionManager();
  
  // Clean up when provider is disposed
  ref.onDispose(() {
    manager.dispose();
  });
  
  return manager;
});
