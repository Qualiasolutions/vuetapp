import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Base class for all Supabase repositories with enhanced debugging and error handling
abstract class BaseSupabaseRepository {
  final SupabaseClient _client;

  BaseSupabaseRepository(this._client);

  /// Get the Supabase client with validation
  SupabaseClient get client {
    _validateClient();
    return _client;
  }

  /// Validate that the client is properly configured
  void _validateClient() {
    if (!_client.auth.headers.containsKey('apikey')) {
      debugPrint('❌ Supabase client missing API key in headers');
      debugPrint('Available headers: ${_client.auth.headers.keys.toList()}');
      throw Exception('Supabase client not properly configured - missing API key');
    }
    
    // Debug current auth state
    final user = _client.auth.currentUser;
    debugPrint('🔍 Repository validation - User: ${user?.id ?? 'NO USER'}');
    debugPrint('🔍 Auth headers: ${_client.auth.headers.keys.toList()}');
  }

  /// Execute a query with enhanced error handling and debugging
  Future<T> executeQuery<T>(
    String operation,
    Future<T> Function() query,
  ) async {
    try {
      debugPrint('🚀 Executing $operation');
      _validateClient();
      
      final result = await query();
      debugPrint('✅ $operation completed successfully');
      return result;
    } catch (error, stackTrace) {
      debugPrint('❌ $operation failed: $error');
      debugPrint('Stack trace: $stackTrace');
      
      // Check for specific API key errors
      if (error.toString().contains('No API key found') || 
          error.toString().contains('406')) {
        debugPrint('🔑 API key error detected - checking client configuration');
        _validateClient();
      }
      
      rethrow;
    }
  }

  /// Get a table query with validation
  PostgrestQueryBuilder from(String table) {
    _validateClient();
    return _client.from(table);
  }

  /// Get current user ID with validation
  String getCurrentUserId() {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('No authenticated user found');
    }
    return user.id;
  }

  /// Check if user is authenticated
  bool get isAuthenticated => _client.auth.currentUser != null;
}
