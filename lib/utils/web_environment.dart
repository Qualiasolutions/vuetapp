import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode, kReleaseMode, debugPrint;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'web_environment_stub.dart' if (dart.library.js) 'web_environment_web.dart';

/// A utility class for accessing environment variables in Flutter web
class WebEnvironment {
  /// Returns an environment variable from various sources in order of preference:
  /// 1. JavaScript window.flutterWebEnvironment (set by env.js) - Web only
  /// 2. dotenv loaded environment variables
  /// 3. Fallback value provided (optional)
  static String? getEnv(String key, {String? fallback}) {
    // For web platform, try to access JavaScript environment
    if (kIsWeb) {
      final webEnvValue = getWebEnv(key);
      if (webEnvValue != null) {
        return webEnvValue;
      }
    }
    
    // Fallback to dotenv
    final envValue = dotenv.env[key];
    if (envValue != null && envValue.isNotEmpty) {
      if (kDebugMode) {
        debugPrint('✅ Found $key in dotenv: ${envValue.substring(0, (envValue.length).clamp(0, 20))}...');
      }
      return envValue;
    }
    
    // Final fallback
    if (kDebugMode && fallback != null) {
      debugPrint('⚠️ Using fallback for $key: $fallback');
    }
    return fallback;
  }

  /// Check if we're in production mode based on web environment
  static bool get isProduction {
    if (kIsWeb) {
      final envFlag = getEnv('FLUTTER_ENV');
      return envFlag == 'production' || kReleaseMode;
    }
    return kReleaseMode;
  }

  /// Gets Supabase URL considering all environment sources
  static String? get supabaseUrl => getEnv('SUPABASE_URL');
  
  /// Gets Supabase anonymous key considering all environment sources
  static String? get supabaseAnonKey => getEnv('SUPABASE_ANON_KEY');
  
  /// Gets OpenAI API key considering all environment sources
  static String? get openaiApiKey => getEnv('OPENAI_API_KEY');
  
  /// Gets OpenAI Assistant ID considering all environment sources
  static String? get openaiAssistantId => getEnv('OPENAI_ASSISTANT_ID');
  
  /// Gets reCAPTCHA site key considering all environment sources
  static String? get recaptchaSiteKey => getEnv('RECAPTCHA_SITE_KEY');
  
  /// Gets reCAPTCHA secret key considering all environment sources
  static String? get recaptchaSecretKey => getEnv('RECAPTCHA_SECRET_KEY');
}
