import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';

/// Service to handle connection retries with exponential backoff
class ConnectionRetryService {
  static const int _maxRetries = 3;
  static const Duration _baseDelay = Duration(seconds: 1);
  static const Duration _maxDelay = Duration(seconds: 30);

  /// Executes a function with retry logic and exponential backoff
  static Future<T> executeWithRetry<T>({
    required Future<T> Function() operation,
    required String operationName,
    int maxRetries = _maxRetries,
    Duration baseDelay = _baseDelay,
    bool Function(dynamic error)? shouldRetry,
  }) async {
    int attempts = 0;
    Duration currentDelay = baseDelay;

    while (attempts < maxRetries) {
      attempts++;
      
      try {
        debugPrint('$operationName: Attempt $attempts/$maxRetries');
        
        if (attempts > 1) {
          debugPrint('$operationName: Waiting ${currentDelay.inMilliseconds}ms before retry...');
          await Future.delayed(currentDelay);
        }

        final result = await operation();
        
        if (attempts > 1) {
          debugPrint('$operationName: Succeeded on attempt $attempts');
        }
        
        return result;
      } catch (error) {
        debugPrint('$operationName: Error on attempt $attempts: $error');
        
        // Check if we should retry this error
        final shouldRetryError = shouldRetry?.call(error) ?? _shouldRetryByDefault(error);
        
        if (attempts >= maxRetries || !shouldRetryError) {
          debugPrint('$operationName: Max retries reached or non-retryable error');
          rethrow;
        }
        
        // Calculate next delay with exponential backoff and jitter
        currentDelay = _calculateNextDelay(currentDelay, attempts);
      }
    }

    throw Exception('$operationName: Unexpected end of retry loop');
  }

  /// Default retry logic for common errors
  static bool _shouldRetryByDefault(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    // Retry on timeout and connection errors
    if (errorString.contains('timeout') ||
        errorString.contains('504') ||
        errorString.contains('gateway timeout') ||
        errorString.contains('connection refused') ||
        errorString.contains('socketexception') ||
        errorString.contains('network error') ||
        errorString.contains('connection reset') ||
        errorString.contains('connection aborted')) {
      return true;
    }
    
    // Don't retry on authentication errors
    if (errorString.contains('invalid credentials') ||
        errorString.contains('email already exists') ||
        errorString.contains('weak password') ||
        errorString.contains('invalid email')) {
      return false;
    }
    
    // Retry on database constraint errors (might be timing related)
    if (errorString.contains('foreign key constraint') ||
        errorString.contains('no rows found') ||
        errorString.contains('not found')) {
      return true;
    }
    
    // Default to retry for unknown errors
    return true;
  }

  /// Calculate next delay with exponential backoff and jitter
  static Duration _calculateNextDelay(Duration currentDelay, int attempt) {
    // Exponential backoff: delay * 2^attempt
    final exponentialDelay = Duration(
      milliseconds: currentDelay.inMilliseconds * pow(2, attempt - 1).toInt(),
    );
    
    // Cap at maximum delay
    final cappedDelay = exponentialDelay > _maxDelay ? _maxDelay : exponentialDelay;
    
    // Add jitter (random factor between 0.5 and 1.5)
    final jitter = 0.5 + Random().nextDouble();
    final finalDelay = Duration(
      milliseconds: (cappedDelay.inMilliseconds * jitter).toInt(),
    );
    
    return finalDelay;
  }

  /// Specific retry logic for Supabase auth operations
  static bool shouldRetryAuthOperation(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    // Always retry timeouts and connection issues
    if (errorString.contains('timeout') ||
        errorString.contains('504') ||
        errorString.contains('gateway timeout') ||
        errorString.contains('connection') ||
        errorString.contains('network')) {
      return true;
    }
    
    // Retry database-related errors that might be temporary
    if (errorString.contains('foreign key constraint') ||
        errorString.contains('no rows found') ||
        errorString.contains('profile not found') ||
        errorString.contains('trigger')) {
      return true;
    }
    
    // Don't retry user input errors
    if (errorString.contains('invalid credentials') ||
        errorString.contains('email already exists') ||
        errorString.contains('weak password') ||
        errorString.contains('invalid email')) {
      return false;
    }
    
    // Default to retry for auth operations
    return true;
  }

  /// Specific retry logic for database operations
  static bool shouldRetryDatabaseOperation(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    // Always retry timeouts and connection issues
    if (errorString.contains('timeout') ||
        errorString.contains('504') ||
        errorString.contains('gateway timeout') ||
        errorString.contains('connection') ||
        errorString.contains('network')) {
      return true;
    }
    
    // Retry temporary database issues
    if (errorString.contains('lock') ||
        errorString.contains('deadlock') ||
        errorString.contains('busy') ||
        errorString.contains('temporary')) {
      return true;
    }
    
    // Don't retry constraint violations (usually permanent)
    if (errorString.contains('duplicate key') ||
        errorString.contains('unique constraint') ||
        errorString.contains('check constraint')) {
      return false;
    }
    
    // Default to retry
    return true;
  }
}
