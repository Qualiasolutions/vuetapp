import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb; // Import kIsWeb
import 'package:flutter/material.dart';
// import 'package:uni_links/uni_links.dart'; // Commented out due to namespace issues
import 'package:vuet_app/services/supabase_auth_service.dart';

/// Handles deep links for authentication and other app features
class DeepLinkHandler {
  /// Stream subscription for deep links
  static StreamSubscription? _deepLinkSubscription;
  
  /// Flag to prevent handling the same link multiple times
  static final bool _initialLinkHandled = false;

  /// Initialize deep link handling
  static Future<void> initialize(BuildContext? context, SupabaseAuthService authService) async {
    // Handle any initial link that may have opened the app
    await _handleInitialLink(context, authService);
    
    // Set up subscription for future deep links, only if not on web
    if (!kIsWeb) {
      // Commented out due to uni_links package issues
      /*
      _deepLinkSubscription = linkStream.listen((String? link) {
        _handleLink(link, context, authService);
      }, onError: (error) {
        debugPrint('Deep link error: $error');
      });
      */
      debugPrint('Deep link handling is temporarily disabled');
    }
  }

  /// Handle the initial link that may have opened the app
  static Future<void> _handleInitialLink(BuildContext? context, SupabaseAuthService authService) async {
    try {
      if (_initialLinkHandled) return;
      
      // Commented out due to uni_links package issues
      /*
      final initialLink = await getInitialLink();
      if (initialLink != null) {
        _initialLinkHandled = true;
        await _handleLink(initialLink, context, authService);
      }
      */
      debugPrint('Initial deep link handling is temporarily disabled');
    } catch (e) {
      debugPrint('Error handling initial deep link: $e');
    }
  }

  // Removed unused _handleLink method


  /// Dispose the deep link handler
  static void dispose() {
    _deepLinkSubscription?.cancel();
    _deepLinkSubscription = null;
  }
}
