import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vuet_app/utils/web_environment.dart';

/// Configuration class for Supabase integration
class SupabaseConfig {
  /// Private constructor to prevent instantiation
  SupabaseConfig._();

  /// Initialize Supabase with environment variables
  static Future<void> initialize({bool isProduction = false}) async {
    // dotenv.load() is now called in main.dart

    // Get Supabase URL and anon key from the appropriate source (web or .env file)
    String? supabaseUrl;
    String? supabaseAnonKey;
    
    debugPrint('🔧 Initializing Supabase...');
    debugPrint('Platform: ${kIsWeb ? 'Web' : 'Mobile'}');
    debugPrint('Production mode: $isProduction');
    debugPrint('kReleaseMode: $kReleaseMode');
    
    if (kIsWeb) {
      // For web, try to get from WebEnvironment (which checks multiple sources)
      supabaseUrl = WebEnvironment.supabaseUrl;
      supabaseAnonKey = WebEnvironment.supabaseAnonKey;
      debugPrint('Web environment URL: ${supabaseUrl != null ? 'available' : 'not available'}');
      if (supabaseUrl != null) debugPrint('Web URL: ${supabaseUrl.substring(0, 40)}...');
      debugPrint('Web environment key: ${supabaseAnonKey != null ? 'available' : 'not available'}');
      if (supabaseAnonKey != null) debugPrint('Web Key: ${supabaseAnonKey.substring(0, 20)}...');
    } else {
      // For mobile, get from dotenv
      supabaseUrl = dotenv.env['SUPABASE_URL'];
      supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];
      debugPrint('Mobile dotenv URL: ${supabaseUrl != null ? 'available' : 'not available'}');
      debugPrint('Mobile dotenv key: ${supabaseAnonKey != null ? 'available' : 'not available'}');
    }

    // Validate that the URL and anon key exist
    if (supabaseUrl == null || supabaseAnonKey == null) {
      final errorMsg = 'Supabase configuration error:\n'
          '- URL: ${supabaseUrl == null ? "MISSING" : "✓ Found"}\n'
          '- Anon Key: ${supabaseAnonKey == null ? "MISSING" : "✓ Found"}\n'
          '- Platform: ${kIsWeb ? "Web" : "Mobile"}\n'
          '- Production: $isProduction\n'
          'Check your environment files and web/env.js';
      
      debugPrint('❌ $errorMsg');
      throw Exception(errorMsg);
    }

    try {
      // Initialize Supabase client with optimized settings
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
        debug: !isProduction, // Debug logs for dev, not for prod
        authOptions: const FlutterAuthClientOptions(
          authFlowType: AuthFlowType.pkce,
          autoRefreshToken: true,
        ),
        realtimeClientOptions: const RealtimeClientOptions(
          logLevel: RealtimeLogLevel.info,
          timeout: Duration(seconds: 30),
        ),
        postgrestOptions: const PostgrestClientOptions(
          schema: 'public',
        ),
        storageOptions: const StorageClientOptions(
          retryAttempts: 3, // Add retry for storage operations
        ),
      );
      
      debugPrint('✅ Supabase initialized successfully');
      debugPrint('URL: ${supabaseUrl.substring(0, 30)}...');
      
      // Test the connection with timeout
      final client = Supabase.instance.client;
      debugPrint('Client ready: ${client.auth.currentUser?.id ?? 'No user'}');
      
      // Optimize connection settings for auth operations
      try {
        await client.rpc('optimize_auth_connection_settings').timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            debugPrint('⚠️ Connection optimization timeout - continuing anyway');
            return null;
          },
        );
        debugPrint('✅ Connection settings optimized');
      } catch (optimizeError) {
        debugPrint('⚠️ Failed to optimize connection settings: $optimizeError');
        // Continue anyway - this is not critical
      }
      
    } catch (error, stackTrace) {
      debugPrint('❌ Supabase initialization failed: $error');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Get the Supabase client instance
  static SupabaseClient get client => Supabase.instance.client;

  /// Dispose of Supabase resources (call when app is shutting down)
  static void dispose() {
    Supabase.instance.dispose();
  }
}
