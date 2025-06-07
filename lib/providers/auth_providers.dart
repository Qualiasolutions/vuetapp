import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vuet_app/services/supabase_auth_service.dart';

/// Provider for the Supabase Client
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Provider for the Supabase AuthService
final supabaseAuthServiceProvider = Provider<SupabaseAuthService>((ref) {
  return SupabaseAuthService();
});

/// Provider that exposes the Supabase AuthState stream.
/// This can be used to listen to login/logout events and get the current user.
final authStateChangesProvider = StreamProvider<AuthState>((ref) {
  final authService = ref.watch(supabaseAuthServiceProvider);
  return authService.authStateChanges;
});

/// Provider that exposes the current Supabase User object.
/// Returns null if the user is not logged in.
final currentUserProvider = Provider<User?>((ref) {
  // Watch the authStateChangesProvider. When it emits a new User,
  // this provider will rebuild and return the current user.
  final authState = ref.watch(authStateChangesProvider);
  return authState.when(
    data: (state) => state.session?.user,
    loading: () => null, 
    error: (_, __) => null,
  );
});

/// Provider that exposes whether the user is signed in
final isSignedInProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user != null;
});

/// Provider for user profile data from Supabase
final userProfileProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final authService = ref.watch(supabaseAuthServiceProvider);
  return await authService.getUserProfile();
});

// Backward compatibility providers (for existing code that might reference the old names)
final authServiceProvider = Provider<SupabaseAuthService>((ref) {
  return ref.watch(supabaseAuthServiceProvider);
});

// Legacy provider names for backward compatibility
final firebaseAuthServiceProvider = Provider<SupabaseAuthService>((ref) {
  return ref.watch(supabaseAuthServiceProvider);
});
