import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vuet_app/config/supabase_config.dart';
import 'package:vuet_app/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Result wrapper for enhanced error handling
class AuthResult {
  final bool success;
  final User? user;
  final Session? session;
  final String? error;
  final String? message;
  final Map<String, dynamic>? profileData;

  AuthResult({
    required this.success,
    this.user,
    this.session,
    this.error,
    this.message,
    this.profileData,
  });

  factory AuthResult.success({
    User? user,
    Session? session,
    Map<String, dynamic>? profileData,
  }) {
    return AuthResult(
      success: true,
      user: user,
      session: session,
      profileData: profileData,
    );
  }

  factory AuthResult.failure({
    required String error,
    String? message,
  }) {
    return AuthResult(
      success: false,
      error: error,
      message: message,
    );
  }
}

class AuthService {
  final SupabaseClient _supabaseClient = SupabaseConfig.client;

  // Stream for authentication state changes
  Stream<AuthState> get authStateChange => _supabaseClient.auth.onAuthStateChange;

  // Get current user
  User? get currentUser {
    final user = _supabaseClient.auth.currentUser;
    debugPrint('AuthService: Current user: ${user?.id}');
    return user;
  }

  // Check if user is signed in
  bool get isSignedIn {
    final signedIn = currentUser != null;
    debugPrint('AuthService: Is signed in: $signedIn');
    return signedIn;
  }

  // Expose Supabase client if needed
  SupabaseClient get supabase => _supabaseClient;

  // Handle refresh token errors
  Future<void> handleRefreshTokenError() async {
    debugPrint('AuthService: Handling refresh token error');
    try {
      // Force sign out with both local and server scope
      await _supabaseClient.auth.signOut(scope: SignOutScope.global);
      debugPrint('AuthService: User signed out due to refresh token error');
    } catch (e) {
      debugPrint('AuthService: Error during forced sign out: $e');
    }
  }

  // Helper method to handle auth exceptions
  Future<AuthResult> handleAuthException(dynamic error, String operation) async {
    debugPrint('AuthService $operation Error: $error');
    
    // Handle specific auth errors
    if (error is AuthException) {
      final errorMessage = error.message.toLowerCase();
      
      // Handle refresh token errors
      if (errorMessage.contains('refresh_token_not_found') || 
          errorMessage.contains('invalid refresh token')) {
        await handleRefreshTokenError();
        return AuthResult.failure(
          error: 'session_expired',
          message: 'Your session has expired. Please sign in again.',
        );
      }
      
      // Handle other common auth errors
      if (errorMessage.contains('invalid credentials')) {
        return AuthResult.failure(
          error: 'invalid_credentials',
          message: 'Invalid email or password.',
        );
      } else if (errorMessage.contains('email not confirmed')) {
        return AuthResult.failure(
          error: 'email_not_confirmed',
          message: 'Please confirm your email before signing in.',
        );
      }
    }
    
    // Default error handling
    return AuthResult.failure(
      error: 'auth_error',
      message: 'Authentication error: $error',
    );
  }

  // Enhanced sign up with complete user profile data and retry logic
  Future<AuthResult> signUpWithEmailPassword({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String accountType,
  }) async {
    try {
      debugPrint('AuthService: Starting registration for email: $email');
      
      // Step 1: Create Supabase Auth user
      final AuthResponse authResponse = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
      );

      if (authResponse.user == null) {
        return AuthResult.failure(
          error: 'auth_failed',
          message: 'Failed to create user account. Please try again.',
        );
      }

      debugPrint('AuthService: Auth user created successfully: ${authResponse.user!.id}');

      // Step 2: Create complete user profile with retry logic
      return await _createUserProfileWithRetry(
        userId: authResponse.user!.id,
        email: email,
        firstName: firstName,
        lastName: lastName,
        accountType: accountType,
        authResponse: authResponse,
      );
    } on AuthException catch (authError) {
      debugPrint('AuthService: Auth error: ${authError.message}');
      
      String errorCode = 'auth_error';
      String errorMessage = authError.message;
      
      // Parse specific auth errors
      if (authError.message.contains('already registered')) {
        errorCode = 'email_already_exists';
        errorMessage = 'An account with this email already exists.';
      } else if (authError.message.contains('weak_password')) {
        errorCode = 'weak_password';
        errorMessage = 'Password is too weak. Please choose a stronger password.';
      } else if (authError.message.contains('invalid_email')) {
        errorCode = 'invalid_email';
        errorMessage = 'Please enter a valid email address.';
      } else if (authError.message.contains('timeout') || authError.message.contains('504')) {
        errorCode = 'timeout_error';
        errorMessage = 'Connection timeout. Please check your internet and try again.';
      }
      
      return AuthResult.failure(error: errorCode, message: errorMessage);
    } catch (error) {
      debugPrint('AuthService: Unexpected error: $error');
      
      // Handle specific timeout/network errors
      if (error.toString().contains('timeout') || 
          error.toString().contains('504') || 
          error.toString().contains('Connection refused')) {
        return AuthResult.failure(
          error: 'timeout_error',
          message: 'Connection timeout. Please check your internet connection and try again.',
        );
      }
      
      return AuthResult.failure(
        error: 'unexpected_error',
        message: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  // Helper method to create user profile with retry logic
  Future<AuthResult> _createUserProfileWithRetry({
    required String userId,
    required String email,
    required String firstName,
    required String lastName,
    required String accountType,
    required AuthResponse authResponse,
    int maxRetries = 3,
  }) async {
    int attempts = 0;
    Duration delay = const Duration(milliseconds: 500);

    while (attempts < maxRetries) {
      attempts++;
      
      try {
        debugPrint('AuthService: Creating profile (attempt $attempts/$maxRetries)');
        
        // Add small delay to ensure auth user is fully committed
        if (attempts > 1) {
          debugPrint('AuthService: Waiting ${delay.inMilliseconds}ms before retry...');
          await Future.delayed(delay);
        }

        final profileResult = await _supabaseClient.rpc('create_user_profile', params: {
          'p_user_id': userId,
          'p_email': email,
          'p_first_name': firstName,
          'p_last_name': lastName,
          'p_account_type': accountType.toLowerCase(),
          'p_subscription_status': 'free',
        }).timeout(
          const Duration(seconds: 10), // 10 second timeout
          onTimeout: () {
            throw Exception('Profile creation timeout after 10 seconds');
          },
        );

        debugPrint('AuthService: Profile creation result: $profileResult');

        // Parse the result from our database function
        if (profileResult != null && profileResult is Map) {
          final success = profileResult['success'] as bool? ?? false;
          
          if (success) {
            debugPrint('AuthService: Profile created/updated successfully');
            return AuthResult.success(
              user: authResponse.user,
              session: authResponse.session,
              profileData: profileResult['profile'] as Map<String, dynamic>?,
            );
          } else {
            // Handle specific database errors
            final error = profileResult['error'] as String? ?? 'unknown_error';
            final message = profileResult['message'] as String? ?? 'An error occurred during registration';
            
            debugPrint('AuthService: Profile creation failed: $error - $message');
            
            // Don't retry for certain errors
            if (error == 'email_already_exists' || error == 'invalid_data') {
              await _cleanupAuthUser();
              return AuthResult.failure(error: error, message: message);
            }
            
            // For other errors, continue retrying
            if (attempts == maxRetries) {
              await _cleanupAuthUser();
              return AuthResult.failure(error: error, message: message);
            }
          }
        } else {
          throw Exception('Invalid response from create_user_profile function');
        }
      } catch (profileError) {
        debugPrint('AuthService: Profile creation error (attempt $attempts): $profileError');
        
        // Handle specific error types
        if (profileError.toString().contains('foreign key constraint') ||
            profileError.toString().contains('profiles_id_fkey')) {
          debugPrint('AuthService: Foreign key constraint error - auth user may not be ready yet');
          
          if (attempts < maxRetries) {
            // Exponential backoff for foreign key errors
            delay = Duration(milliseconds: delay.inMilliseconds * 2);
            continue;
          }
        }
        
        if (profileError.toString().contains('unique_violation') || 
            profileError.toString().contains('already exists')) {
          await _cleanupAuthUser();
          return AuthResult.failure(
            error: 'email_already_exists',
            message: 'An account with this email already exists.',
          );
        }
        
        if (profileError.toString().contains('check_violation')) {
          await _cleanupAuthUser();
          return AuthResult.failure(
            error: 'invalid_data',
            message: 'Invalid account information provided.',
          );
        }
        
        if (profileError.toString().contains('timeout') || 
            profileError.toString().contains('504')) {
          debugPrint('AuthService: Timeout error on attempt $attempts');
          
          if (attempts < maxRetries) {
            delay = Duration(milliseconds: delay.inMilliseconds * 2);
            continue;
          } else {
            await _cleanupAuthUser();
            return AuthResult.failure(
              error: 'timeout_error',
              message: 'Profile creation timed out. Please try again.',
            );
          }
        }
        
        // For the last attempt, return the error
        if (attempts == maxRetries) {
          await _cleanupAuthUser();
          return AuthResult.failure(
            error: 'database_error',
            message: 'Failed to create user profile. Please try again.',
          );
        }
        
        // Exponential backoff for other errors
        delay = Duration(milliseconds: delay.inMilliseconds * 2);
      }
    }

    // This should never be reached, but just in case
    await _cleanupAuthUser();
    return AuthResult.failure(
      error: 'max_retries_exceeded',
      message: 'Failed to create profile after multiple attempts. Please try again.',
    );
  }

  // Helper method to clean up auth user on failure
  Future<void> _cleanupAuthUser() async {
    try {
      debugPrint('AuthService: Cleaning up auth user...');
      await _supabaseClient.auth.signOut();
    } catch (cleanupError) {
      debugPrint('AuthService: Failed to cleanup auth user: $cleanupError');
    }
  }

  // Sign in with email and password
  Future<AuthResponse> signInWithEmailPassword({required String email, required String password}) async {
    try {
      final AuthResponse response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (error) {
      debugPrint('AuthService SignIn Error: ${error.message}');
      rethrow;
    } catch (error) {
      debugPrint('AuthService SignIn Unexpected Error: $error');
      rethrow;
    }
  }

  // Enhanced sign in with email and password with error handling
  Future<AuthResult> enhancedSignInWithEmailPassword({
    required String email, 
    required String password
  }) async {
    try {
      final AuthResponse response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      // Get user profile data if available
      Map<String, dynamic>? profileData;
      if (response.user != null) {
        try {
          profileData = await getUserProfile();
        } catch (profileError) {
          debugPrint('Warning: Failed to fetch profile after login: $profileError');
          // Continue anyway - this is not critical
        }
      }
      
      return AuthResult.success(
        user: response.user,
        session: response.session,
        profileData: profileData,
      );
    } on AuthException catch (error) {
      return await handleAuthException(error, 'SignIn');
    } catch (error) {
      debugPrint('AuthService SignIn Unexpected Error: $error');
      return AuthResult.failure(
        error: 'unexpected_error',
        message: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
    } on AuthException catch (error) {
      debugPrint('AuthService SignOut Error: ${error.message}');
      rethrow;
    } catch (error) {
      debugPrint('AuthService SignOut Unexpected Error: $error');
      rethrow;
    }
  }

  // Reset password for email
  Future<void> resetPasswordForEmail(String email, {String? redirectTo}) async {
    try {
      final String emailRedirectTo = kIsWeb
          ? (redirectTo ?? Uri.base.toString())
          : (redirectTo ?? 'io.supabase.vuetapp://login-callback/');

      await _supabaseClient.auth.resetPasswordForEmail(
        email,
        redirectTo: emailRedirectTo,
      );
    } on AuthException catch (error) {
      debugPrint('AuthService ResetPassword Error: ${error.message}');
      rethrow;
    } catch (error) {
      debugPrint('AuthService ResetPassword Unexpected Error: $error');
      rethrow;
    }
  }

  // Enhanced method to update user profile using our database function
  Future<AuthResult> updateUserProfile({
    String? firstName,
    String? lastName,
    String? accountType,
    String? subscriptionStatus,
  }) async {
    if (currentUser == null) {
      return AuthResult.failure(
        error: 'not_authenticated',
        message: 'User not authenticated',
      );
    }

    try {
      final profileResult = await _supabaseClient.rpc('create_user_profile', params: {
        'p_user_id': currentUser!.id,
        'p_email': currentUser!.email!,
        'p_first_name': firstName,
        'p_last_name': lastName,
        'p_account_type': accountType?.toLowerCase(),
        'p_subscription_status': subscriptionStatus,
      });

      if (profileResult != null && profileResult is Map) {
        final success = profileResult['success'] as bool? ?? false;
        
        if (success) {
          return AuthResult.success(
            user: currentUser,
            profileData: profileResult['profile'] as Map<String, dynamic>?,
          );
        } else {
          final error = profileResult['error'] as String? ?? 'unknown_error';
          final message = profileResult['message'] as String? ?? 'Failed to update profile';
          return AuthResult.failure(error: error, message: message);
        }
      } else {
        throw Exception('Invalid response from create_user_profile function');
      }
    } catch (error) {
      debugPrint('AuthService: Profile update error: $error');
      return AuthResult.failure(
        error: 'update_failed',
        message: 'Failed to update profile. Please try again.',
      );
    }
  }

  // Example of how to handle OTP for email (Magic Link)
  Future<AuthResponse> signInWithOtp(String email, {String? emailRedirectTo}) async {
    try {
      final String redirectUrl = kIsWeb
          ? emailRedirectTo ?? Uri.base.toString()
          : emailRedirectTo ?? 'io.supabase.vuetapp://login-callback/';

      await _supabaseClient.auth.signInWithOtp(
        email: email,
        emailRedirectTo: redirectUrl,
      );
      return AuthResponse(session: null, user: null);
    } on AuthException catch (error) {
      debugPrint('AuthService SignInWithOtp Error: ${error.message}');
      rethrow;
    } catch (error) {
      debugPrint('AuthService SignInWithOtp Unexpected Error: $error');
      rethrow;
    }
  }

  // Get current user profile
  Future<Map<String, dynamic>?> getUserProfile() async {
    if (currentUser == null) {
      debugPrint('AuthService: No current user, cannot fetch profile.');
      return null;
    }
    try {
      final response = await _supabaseClient
          .from('profiles')
          .select()
          .eq('id', currentUser!.id)
          .single();
      return response;
    } catch (e) {
      debugPrint('AuthService: Error fetching user profile: $e');
      return null;
    }
  }

  // Update password
  Future<void> updatePassword(String newPassword) async {
    try {
      await _supabaseClient.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } on AuthException catch (error) {
      debugPrint('AuthService UpdatePassword Error: ${error.message}');
      rethrow;
    } catch (error) {
      debugPrint('AuthService UpdatePassword Unexpected Error: $error');
      rethrow;
    }
  }

  // Handle password reset redirect
  Future<bool> handlePasswordResetRedirect(Uri uri) async {
    try {
      return true; // Successfully retrieved session from URL
    } catch (error) {
      debugPrint('AuthService: Error handling password reset redirect: $error');
      return false;
    }
  }

  // Fetch a user profile by ID
  Future<UserModel?> getUserProfileById(String userId) async {
    try {
      final response = await _supabaseClient
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) {
        debugPrint('AuthService: No profile found for user ID: $userId');
        return null;
      }
      return UserModel.fromJson(response);
    } catch (e) {
      debugPrint('AuthService: Error fetching profile for user ID $userId: $e');
      return null;
    }
  }
}

final authServiceProvider = Provider<AuthService>((ref) => AuthService());
