import 'package:flutter_test/flutter_test.dart';
import 'package:vuet_app/services/performance_service.dart';
import 'package:vuet_app/utils/database_optimizer.dart';

void main() {
  group('Performance Optimization Tests', () {
    setUpAll(() async {
      // Initialize performance service for testing
      await PerformanceService.initialize();
    });

    test('Database optimizer cache functionality', () async {
      // Test cache functionality
      const cacheKey = 'test_key';
      const testData = 'test_data';
      
      // Clear cache first
      DatabaseOptimizer.clearCache();
      
      // Execute operation with caching enabled
      final result1 = await DatabaseOptimizer.executeWithTracking(
        'test_operation',
        () async {
          await Future.delayed(const Duration(milliseconds: 100));
          return testData;
        },
        enableCache: true,
        cacheKey: cacheKey,
      );
      
      expect(result1, equals(testData));
      
      // Second call should use cache (faster)
      final stopwatch = Stopwatch()..start();
      final result2 = await DatabaseOptimizer.executeWithTracking(
        'test_operation',
        () async {
          await Future.delayed(const Duration(milliseconds: 100));
          return testData;
        },
        enableCache: true,
        cacheKey: cacheKey,
      );
      stopwatch.stop();
      
      expect(result2, equals(testData));
      // Cache should make it faster (less than 50ms instead of 100ms)
      expect(stopwatch.elapsedMilliseconds, lessThan(50));
      
      // Verify cache stats
      final stats = DatabaseOptimizer.getCacheStats();
      expect(stats['valid_entries'], equals(1));
      expect(stats['cache_keys'], contains(cacheKey));
    });

    test('Batch operations functionality', () async {
      final operations = List.generate(10, (index) => () async {
        await Future.delayed(const Duration(milliseconds: 10));
        return 'result_$index';
      });
      
      final stopwatch = Stopwatch()..start();
      final results = await DatabaseOptimizer.executeBatch(
        'test_batch',
        operations,
        batchSize: 5,
      );
      stopwatch.stop();
      
      expect(results.length, equals(10));
      expect(results[0], equals('result_0'));
      expect(results[9], equals('result_9'));
      
      // Batch processing should be more efficient than sequential
      // (batched operations run in parallel within each batch)
      expect(stopwatch.elapsedMilliseconds, lessThan(150));
    });

    test('Paginated query builder', () {
      final query = DatabaseOptimizer.buildPaginatedQuery(
        baseQuery: 'SELECT * FROM lists',
        offset: 20,
        limit: 10,
        orderBy: 'created_at',
        ascending: false,
      );
      
      expect(query['query'], contains('ORDER BY created_at DESC'));
      expect(query['query'], contains('LIMIT \$limit'));
      expect(query['query'], contains('OFFSET \$offset'));
      expect(query['params']['limit'], equals(10));
      expect(query['params']['offset'], equals(20));
    });

    test('WHERE clause builder', () {
      final whereClause = DatabaseOptimizer.buildWhereClause(
        userId: 'user123',
        categoryId: 'cat456',
        startDate: DateTime(2023, 1, 1),
        endDate: DateTime(2023, 12, 31),
        customFilters: {'status': 'active', 'type': 'personal'},
      );
      
      expect(whereClause['whereClause'], contains('user_id = \$user_id'));
      expect(whereClause['whereClause'], contains('category_id = \$category_id'));
      expect(whereClause['whereClause'], contains('created_at >= \$start_date'));
      expect(whereClause['whereClause'], contains('created_at <= \$end_date'));
      expect(whereClause['whereClause'], contains('status = \$status'));
      expect(whereClause['whereClause'], contains('type = \$type'));
      
      expect(whereClause['params']['user_id'], equals('user123'));
      expect(whereClause['params']['category_id'], equals('cat456'));
      expect(whereClause['params']['status'], equals('active'));
      expect(whereClause['params']['type'], equals('personal'));
    });

    test('Memory info retrieval', () {
      final memoryInfo = PerformanceService.getMemoryInfo();
      
      expect(memoryInfo, isA<Map<String, dynamic>>());
      expect(memoryInfo.keys, isNotEmpty);
      
      // Should contain either memory info or platform info
      if (memoryInfo.containsKey('platform')) {
        expect(memoryInfo['platform'], equals('web'));
      } else {
        expect(memoryInfo.keys, contains('rss_bytes'));
        expect(memoryInfo.keys, contains('rss_mb'));
      }
    });

    test('Recommended database indexes', () {
      final indexes = DatabaseOptimizer.getRecommendedIndexes();
      
      expect(indexes, isNotEmpty);
      expect(indexes.length, greaterThan(10));
      
      // Check for key indexes
      expect(indexes.any((index) => index.contains('idx_tasks_user_id')), isTrue);
      expect(indexes.any((index) => index.contains('idx_lists_user_id')), isTrue);
      expect(indexes.any((index) => index.contains('idx_tasks_created_at')), isTrue);
      expect(indexes.any((index) => index.contains('idx_tasks_user_status')), isTrue);
    });

    test('Performance service memory logging', () async {
      // This test verifies that memory logging doesn't crash
      await PerformanceService.logMemoryUsage('test_context');
      
      // Should complete without throwing
      expect(true, isTrue);
    });

    test('Performance service error recording', () async {
      const testError = 'Test error for monitoring';
      final testStackTrace = StackTrace.current;
      
      // This should not throw an exception
      await PerformanceService.recordError(
        testError,
        testStackTrace,
        fatal: false,
      );
      
      expect(true, isTrue);
    });

    test('Connection pool manager', () {
      // Test connection pool functionality
      expect(ConnectionPoolManager.canCreateConnection(), isTrue);
      
      // Simulate connection creation
      ConnectionPoolManager.onConnectionCreated();
      final stats1 = ConnectionPoolManager.getStats();
      expect(stats1['active_connections'], equals(1));
      
      // Create more connections
      for (int i = 0; i < 5; i++) {
        ConnectionPoolManager.onConnectionCreated();
      }
      
      final stats2 = ConnectionPoolManager.getStats();
      expect(stats2['active_connections'], equals(6));
      expect(stats2['available_connections'], equals(4));
      
      // Close connections
      ConnectionPoolManager.onConnectionClosed();
      ConnectionPoolManager.onConnectionClosed();
      
      final stats3 = ConnectionPoolManager.getStats();
      expect(stats3['active_connections'], equals(4));
      expect(stats3['available_connections'], equals(6));
    });

    tearDown(() {
      // Clean up after each test
      DatabaseOptimizer.clearCache();
    });
  });
}
