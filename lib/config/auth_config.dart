import 'package:flutter/foundation.dart';

/// Configuration class for authentication services
class AuthConfig {
  /// Private constructor to prevent instantiation
  AuthConfig._();

  /// Google OAuth Client ID for web
  static const String googleWebClientId = '518781259229-k97n0bsbnojdpdvpcsto59lp2nu19ukk.apps.googleusercontent.com';
  
  /// Google OAuth Client Secret
  static const String googleClientSecret = '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';

  /// Callback URL for OAuth providers
  static const String supabaseCallbackUrl = 'https://xrloafqzfdzewdoawysh.supabase.co/auth/v1/callback';

  /// Deep link scheme for mobile
  static const String deepLinkScheme = 'io.supabase.vuetapp';
  
  /// Deep link host for auth callbacks
  static const String deepLinkHost = 'login-callback';
  
  /// Get the appropriate redirect URL based on platform
  static String get oAuthRedirectUrl {
    if (kIsWeb) {
      return supabaseCallbackUrl;
    } else {
      return '$deepLinkScheme://$deepLinkHost/';
    }
  }
} 