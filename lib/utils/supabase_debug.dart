import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vuet_app/utils/logger.dart';

class SupabaseDebug {
  static Future<void> debugSupabaseConnection() async {
    try {
      final client = Supabase.instance.client;
      
      log('🔍 Debugging Supabase Connection', name: 'SupabaseDebug');
      log('Supabase client initialized: ${client.toString()}', name: 'SupabaseDebug');
      
      // Check auth state
      final currentUser = client.auth.currentUser;
      log('Current user: ${currentUser?.id ?? "Not authenticated"}', name: 'SupabaseDebug');
      
      // Test a simple query that should work without authentication
      try {
        final response = await client
            .from('entity_categories')
            .select('id')
            .limit(1);
        log('✅ Query successful: ${response.length} results', name: 'SupabaseDebug');
      } catch (queryError) {
        log('❌ Query failed: $queryError', name: 'SupabaseDebug');
        
        // Let's check the raw headers being sent
        try {
          final headers = client.headers;
          log('Request headers: $headers', name: 'SupabaseDebug');
        } catch (headerError) {
          log('Failed to get headers: $headerError', name: 'SupabaseDebug');
        }
      }
      
    } catch (error, stackTrace) {
      log('❌ Debug failed: $error', name: 'SupabaseDebug', error: error, stackTrace: stackTrace);
    }
  }
  
  static Future<bool> isSupabaseClientValid() async {
    try {
      final client = Supabase.instance.client;
      
      // Try a simple health check
      await client.from('entity_categories').select('id').limit(1);
      log('✅ Supabase client validation successful', name: 'SupabaseDebug');
      return true;
    } catch (e) {
      log('❌ Supabase client validation failed: $e', name: 'SupabaseDebug');
      return false;
    }
  }
}
