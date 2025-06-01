import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:vuet_app/services/performance_service.dart';

/// Database optimization utilities for improved performance
class DatabaseOptimizer {
  static const int _defaultBatchSize = 50;
  static const Duration _defaultCacheTimeout = Duration(minutes: 5);
  
  // Cache for frequently accessed data
  static final Map<String, _CacheEntry> _cache = {};
  
  /// Execute a database operation with performance tracking
  static Future<T> executeWithTracking<T>(
    String operationName,
    Future<T> Function() operation, {
    bool enableCache = false,
    String? cacheKey,
    Duration? cacheDuration,
  }) async {
    // Check cache first if enabled
    if (enableCache && cacheKey != null) {
      final cachedResult = _getFromCache<T>(cacheKey);
      if (cachedResult != null) {
        return cachedResult;
      }
    }

    // Execute with performance tracking
    final result = await PerformanceService.trackDatabaseOperation(
      operationName,
      operation,
    );

    // Cache result if enabled
    if (enableCache && cacheKey != null) {
      _setCache(
        cacheKey, 
        result, 
        cacheDuration ?? _defaultCacheTimeout,
      );
    }

    return result;
  }

  /// Execute batch operations for better performance
  static Future<List<T>> executeBatch<T>(
    String operationName,
    List<Future<T> Function()> operations, {
    int? batchSize,
  }) async {
    final effectiveBatchSize = batchSize ?? _defaultBatchSize;
    final results = <T>[];
    
    for (int i = 0; i < operations.length; i += effectiveBatchSize) {
      final batch = operations.skip(i).take(effectiveBatchSize);
      
      final batchResults = await PerformanceService.trackDatabaseOperation(
        '${operationName}_batch_${i ~/ effectiveBatchSize}',
        () async {
          final futures = batch.map((op) => op()).toList();
          return await Future.wait(futures);
        },
      );
      
      results.addAll(batchResults);
    }
    
    return results;
  }

  /// Optimize SELECT queries with pagination
  static Map<String, dynamic> buildPaginatedQuery({
    required String baseQuery,
    int? offset,
    int? limit,
    String? orderBy,
    bool ascending = true,
  }) {
    String query = baseQuery;
    final params = <String, dynamic>{};
    
    // Add ordering
    if (orderBy != null) {
      query += ' ORDER BY $orderBy ${ascending ? 'ASC' : 'DESC'}';
    }
    
    // Add pagination
    if (limit != null) {
      query += ' LIMIT \$limit';
      params['limit'] = limit;
      
      if (offset != null && offset > 0) {
        query += ' OFFSET \$offset';
        params['offset'] = offset;
      }
    }
    
    return {
      'query': query,
      'params': params,
    };
  }

  /// Build optimized WHERE clause with indexed columns
  static Map<String, dynamic> buildWhereClause({
    String? userId,
    String? categoryId,
    String? entityId,
    DateTime? startDate,
    DateTime? endDate,
    Map<String, dynamic>? customFilters,
  }) {
    final conditions = <String>[];
    final params = <String, dynamic>{};
    
    // Add user filter (should be indexed)
    if (userId != null) {
      conditions.add('user_id = \$user_id');
      params['user_id'] = userId;
    }
    
    // Add category filter
    if (categoryId != null) {
      conditions.add('category_id = \$category_id');
      params['category_id'] = categoryId;
    }
    
    // Add entity filter
    if (entityId != null) {
      conditions.add('entity_id = \$entity_id');
      params['entity_id'] = entityId;
    }
    
    // Add date range filter (should be indexed)
    if (startDate != null) {
      conditions.add('created_at >= \$start_date');
      params['start_date'] = startDate.toIso8601String();
    }
    
    if (endDate != null) {
      conditions.add('created_at <= \$end_date');
      params['end_date'] = endDate.toIso8601String();
    }
    
    // Add custom filters
    if (customFilters != null) {
      customFilters.forEach((key, value) {
        if (value != null) {
          conditions.add('$key = \$$key');
          params[key] = value;
        }
      });
    }
    
    return {
      'whereClause': conditions.isNotEmpty ? 'WHERE ${conditions.join(' AND ')}' : '',
      'params': params,
    };
  }

  /// Get cached data
  static T? _getFromCache<T>(String key) {
    final entry = _cache[key];
    if (entry == null) return null;
    
    if (DateTime.now().isAfter(entry.expiry)) {
      _cache.remove(key);
      return null;
    }
    
    return entry.data as T?;
  }

  /// Set data in cache
  static void _setCache<T>(String key, T data, Duration duration) {
    _cache[key] = _CacheEntry(
      data: data,
      expiry: DateTime.now().add(duration),
    );
  }

  /// Clear cache
  static void clearCache([String? key]) {
    if (key != null) {
      _cache.remove(key);
    } else {
      _cache.clear();
    }
  }

  /// Get cache statistics
  static Map<String, dynamic> getCacheStats() {
    final now = DateTime.now();
    final validEntries = _cache.values.where((entry) => now.isBefore(entry.expiry)).length;
    
    return {
      'total_entries': _cache.length,
      'valid_entries': validEntries,
      'expired_entries': _cache.length - validEntries,
      'cache_keys': _cache.keys.toList(),
    };
  }

  /// Preload frequently accessed data
  static Future<void> preloadCommonData(String userId) async {
    try {
      // This would be called after user login to preload common data
      await PerformanceService.logCustomEvent('cache_preload_started', {
        'user_id': userId,
      });
      
      // Preload operations would go here
      // For example: categories, recent tasks, etc.
      
      await PerformanceService.logCustomEvent('cache_preload_completed', {
        'user_id': userId,
        'cache_entries': _cache.length,
      });
    } catch (e) {
      await PerformanceService.recordError(e, StackTrace.current);
    }
  }

  /// Optimize database indexes (for development/migration purposes)
  static List<String> getRecommendedIndexes() {
    return [
      // User-based queries (most common)
      'CREATE INDEX IF NOT EXISTS idx_tasks_user_id ON tasks(user_id);',
      'CREATE INDEX IF NOT EXISTS idx_lists_user_id ON lists(user_id);',
      'CREATE INDEX IF NOT EXISTS idx_entities_user_id ON entities(user_id);',
      'CREATE INDEX IF NOT EXISTS idx_timeblocks_user_id ON timeblocks(user_id);',
      'CREATE INDEX IF NOT EXISTS idx_routines_user_id ON routines(user_id);',
      
      // Date-based queries
      'CREATE INDEX IF NOT EXISTS idx_tasks_created_at ON tasks(created_at);',
      'CREATE INDEX IF NOT EXISTS idx_tasks_due_date ON tasks(due_date);',
      'CREATE INDEX IF NOT EXISTS idx_tasks_start_datetime ON tasks(start_datetime);',
      
      // Status-based queries
      'CREATE INDEX IF NOT EXISTS idx_tasks_completed ON tasks(completed);',
      'CREATE INDEX IF NOT EXISTS idx_tasks_status ON tasks(status);',
      
      // Composite indexes for common query patterns
      'CREATE INDEX IF NOT EXISTS idx_tasks_user_status ON tasks(user_id, completed);',
      'CREATE INDEX IF NOT EXISTS idx_tasks_user_date ON tasks(user_id, created_at);',
      'CREATE INDEX IF NOT EXISTS idx_lists_user_type ON lists(user_id, list_type);',
      
      // Foreign key indexes
      'CREATE INDEX IF NOT EXISTS idx_tasks_list_id ON tasks(list_id);',
      'CREATE INDEX IF NOT EXISTS idx_tasks_entity_id ON tasks(entity_id);',
      'CREATE INDEX IF NOT EXISTS idx_list_items_list_id ON list_items(list_id);',
      'CREATE INDEX IF NOT EXISTS idx_routine_tasks_routine_id ON routine_task_templates(routine_id);',
    ];
  }

  /// Monitor slow queries (for development)
  static Future<void> logSlowQuery(String query, Duration duration) async {
    if (kDebugMode && duration.inMilliseconds > 1000) {
      await PerformanceService.logCustomEvent('slow_query_detected', {
        'query': query.length > 100 ? '${query.substring(0, 100)}...' : query,
        'duration_ms': duration.inMilliseconds,
      });
    }
  }
}

/// Internal cache entry class
class _CacheEntry {
  final dynamic data;
  final DateTime expiry;
  
  _CacheEntry({
    required this.data,
    required this.expiry,
  });
}

/// Query optimization hints
class QueryHints {
  static const String useIndex = '/*+ USE_INDEX */';
  static const String forceIndex = '/*+ FORCE_INDEX */';
  static const String noCache = '/*+ NO_CACHE */';
  static const String smallResult = '/*+ SQL_SMALL_RESULT */';
  static const String bigResult = '/*+ SQL_BIG_RESULT */';
}

/// Connection pool manager for optimal database connections
class ConnectionPoolManager {
  static int _activeConnections = 0;
  static const int _maxConnections = 10;
  
  static bool canCreateConnection() {
    return _activeConnections < _maxConnections;
  }
  
  static void onConnectionCreated() {
    _activeConnections++;
  }
  
  static void onConnectionClosed() {
    if (_activeConnections > 0) {
      _activeConnections--;
    }
  }
  
  static Map<String, dynamic> getStats() {
    return {
      'active_connections': _activeConnections,
      'max_connections': _maxConnections,
      'available_connections': _maxConnections - _activeConnections,
    };
  }
}
