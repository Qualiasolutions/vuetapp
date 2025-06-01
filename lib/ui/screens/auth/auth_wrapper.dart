import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/providers/auth_providers.dart';
import 'package:vuet_app/ui/screens/auth/auth_navigator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vuet_app/services/auth_service.dart' as auth_service;

/// A wrapper component that handles authentication state
/// and redirects to either the main app or authentication screens
class AuthWrapper extends ConsumerStatefulWidget {
  /// The main app widget to show when authenticated
  final Widget child;

  /// Constructor
  const AuthWrapper({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends ConsumerState<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    
    // Listen for specific auth errors, including refresh token errors
    Future.microtask(() {
      final authService = ref.read(authServiceProvider);
      // Access the Supabase client through the service
      Supabase.instance.client.auth.onAuthStateChange.listen((state) {
        _handleAuthStateChange(state);
      });
    });
  }
  
  // Handle auth state changes
  void _handleAuthStateChange(AuthState state) {
    // Supabase doesn't have a tokenRefreshFailure event, so check for signedOut event
    // and examine if there's an active error in the session
    if (state.event == AuthChangeEvent.signedOut) {
      // User was signed out, potentially due to refresh token error
      // We'll rely on the error handler in the build method
    }
  }
  
  // Handle refresh token errors
  Future<void> _handleRefreshTokenError() async {
    if (!mounted) return;
    
    final authService = ref.read(authServiceProvider);
    
    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Your session has expired. Please sign in again.'),
        backgroundColor: Colors.red,
      ),
    );
    
    // Get the auth service from the provider - this gives us access to our custom handleRefreshTokenError method
    final auth_service.AuthService auth = ref.read(auth_service.authServiceProvider);
    // Force sign out
    await auth.handleRefreshTokenError();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateChangesProvider);
    
    return authState.when(
      data: (state) {
        final user = state.session?.user;
        
        // No need to check for tokenRefreshFailure as it doesn't exist in Supabase
        // Instead we'll rely on the error handler for token issues
        
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: user != null ? widget.child : const AuthNavigator(),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) {
        // Check for refresh token errors in the error message
        if (error is AuthException && 
           (error.message.contains('refresh_token_not_found') || 
            error.message.contains('invalid refresh token'))) {
          // Handle this specific error
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _handleRefreshTokenError();
          });
        }
        
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 64,
                ),
                const SizedBox(height: 16),
                Text(
                  'Authentication Error',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Error: $error',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(authStateChangesProvider);
                  },
                  child: const Text('Retry'),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () async {
                    // Force sign out and go to login
                    final authService = ref.read(authServiceProvider);
                    await authService.signOut();
                  },
                  child: const Text('Sign Out & Login Again'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
