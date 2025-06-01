import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vuet_app/config/supabase_config.dart';
import 'package:vuet_app/models/user_model.dart';

// Result wrapper for enhanced error handling
class SupabaseAuthResult {
  final bool success;
  final User? supabaseUser;
  final String? error;
  final String? message;
  final Map<String, dynamic>? profileData;

  SupabaseAuthResult({
    required this.success,
    this.supabaseUser,
    this.error,
    this.message,
    this.profileData,
  });

  factory SupabaseAuthResult.success({
    User? supabaseUser,
    Map<String, dynamic>? profileData,
  }) {
    return SupabaseAuthResult(
      success: true,
      supabaseUser: supabaseUser,
      profileData: profileData,
    );
  }

  factory SupabaseAuthResult.failure({
    required String error,
    String? message,
  }) {
    return SupabaseAuthResult(
      success: false,
      error: error,
      message: message,
    );
  }
}

class SupabaseAuthService {
  final SupabaseClient _supabaseClient = SupabaseConfig.client;

  // Stream for authentication state changes
  Stream<AuthState> get authStateChanges => _supabaseClient.auth.onAuthStateChange;

  // Get current user
  User? get currentUser => _supabaseClient.auth.currentUser;

  // Check if user is signed in
  bool get isSignedIn => currentUser != null;

  // Enhanced sign up with complete user profile data and fixed logic
  Future<SupabaseAuthResult> signUpWithEmailPassword({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String accountType, // 'personal' or 'professional'
  }) async {
    try {
      debugPrint('SupabaseAuthService: Starting registration for email: $email');
      
      final AuthResponse authResponse = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
        // Passing initial data that might be used by a trigger if one still exists,
        // but our primary profile creation will be via the Edge Function.
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'account_type': accountType.toLowerCase(),
        },
      ).timeout(
        const Duration(seconds: 45),
        onTimeout: () {
          throw Exception('Signup timeout after 45 seconds. Please try again.');
        },
      );

      final user = authResponse.user;
      if (user == null) {
        return SupabaseAuthResult.failure(
          error: 'auth_failed',
          message: 'Failed to create Supabase auth user. Please try again.',
        );
      }

      debugPrint('SupabaseAuthService: Supabase auth user created successfully: ${user.id}');

      // Step 2: Call Edge Function to create/verify the profile
      int attempts = 0;
      Map<String, dynamic>? profileData;
      bool profileEnsured = false;

      while (attempts < 3 && !profileEnsured) {
        attempts++;
        try {
          debugPrint('SupabaseAuthService: Attempting to create/ensure profile via Edge Function (attempt $attempts)');
          final FunctionResponse response = await _supabaseClient.functions.invoke(
            'create_user_profile_on_signup', // Slug of the deployed Edge Function
            method: HttpMethod.post,
            body: {
              'user_id': user.id,
              'email': user.email,
              'first_name': firstName,
              'last_name': lastName,
              // Add any other initial profile fields the Edge Function might expect
              // 'account_type': accountType.toLowerCase(), // Example if function handles it
            },
          ).timeout(const Duration(seconds: 20)); // Timeout for the function call

          if (response.status == 200 || response.status == 201) {
            debugPrint('SupabaseAuthService: Profile created/ensured successfully for user: ${user.id}. Status: ${response.status}');
            profileData = response.data as Map<String, dynamic>?;
            profileEnsured = true;
          } else {
            debugPrint('SupabaseAuthService: Profile creation/ensure Edge Function call failed attempt $attempts. Status: ${response.status}, Error: ${response.data}');
            if (attempts >= 3) {
              return SupabaseAuthResult.failure(
                error: 'profile_creation_failed',
                message: 'Failed to create user profile after $attempts attempts. Error: ${response.data}',
              );
            }
            await Future.delayed(Duration(seconds: attempts)); // Wait 1, then 2 seconds
          }
        } catch (e) {
          debugPrint('SupabaseAuthService: Exception during profile creation/ensure Edge Function call, attempt $attempts for user ${user.id}: $e');
          if (attempts >= 3) {
            return SupabaseAuthResult.failure(
              error: 'profile_creation_exception',
              message: 'Critical: Profile creation failed after $attempts attempts. Exception: $e',
            );
          }
          await Future.delayed(Duration(seconds: attempts)); // Wait 1, then 2 seconds
        }
      }

      if (!profileEnsured || profileData == null) {
         // This case should ideally be covered by the loop's exit conditions
        debugPrint('SupabaseAuthService: Profile not ensured after loop for user ${user.id}');
        return SupabaseAuthResult.failure(
          error: 'profile_not_ensured',
          message: 'User profile could not be reliably created or verified.',
        );
      }
      
      return SupabaseAuthResult.success(
        supabaseUser: user,
        profileData: profileData,
      );

    } on TimeoutException catch (timeoutError) {
      debugPrint('SupabaseAuthService: Signup timeout: $timeoutError');
      return SupabaseAuthResult.failure(
        error: 'timeout_error',
        message: 'Signup is taking longer than expected. Please check your internet connection and try again.',
      );
    } on AuthException catch (authError) {
      debugPrint('SupabaseAuthService: Auth error: ${authError.message}');
      
      String errorCode = 'auth_error';
      String errorMessage = authError.message;
      
      // Parse specific auth errors
      if (authError.message.toLowerCase().contains('email') && 
          authError.message.toLowerCase().contains('already')) {
        errorCode = 'email_already_exists';
        errorMessage = 'An account with this email already exists.';
      } else if (authError.message.toLowerCase().contains('password')) {
        errorCode = 'weak_password';
        errorMessage = 'Password is too weak. Please choose a stronger password.';
      } else if (authError.message.toLowerCase().contains('invalid')) {
        errorCode = 'invalid_email';
        errorMessage = 'Please enter a valid email address.';
      } else if (authError.message.contains('timeout') || 
                 authError.message.contains('504') || 
                 authError.message.contains('Gateway timeout')) {
        errorCode = 'timeout_error';
        errorMessage = 'Server timeout. This may be due to high server load. Please try again in a few moments.';
      }
      
      return SupabaseAuthResult.failure(error: errorCode, message: errorMessage);
    } catch (error) {
      debugPrint('SupabaseAuthService: Unexpected error: $error');
      
      // Handle specific timeout/network errors
      if (error.toString().contains('timeout') || 
          error.toString().contains('504') || 
          error.toString().contains('Gateway timeout') ||
          error.toString().contains('Connection refused') ||
          error.toString().contains('SocketException')) {
        return SupabaseAuthResult.failure(
          error: 'timeout_error',
          message: 'Connection timeout. This may be due to server load or network issues. Please try again.',
        );
      }
      
      return SupabaseAuthResult.failure(
        error: 'unexpected_error',
        message: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  // Helper method to verify profile was created by the trigger (no manual updates)
  // THIS METHOD IS NO LONGER USED AND WILL BE REMOVED.
  /*
  Future<SupabaseAuthResult> _verifyUserProfileAfterSignup({
    required String userId,
    required User user,
    int maxRetries = 3,
  }) async {
    // ... old code ...
  }
  */

  // Sign in with email and password
  Future<SupabaseAuthResult> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse authResponse = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      ).timeout(
        const Duration(seconds: 30), // Extended timeout for signin
        onTimeout: () {
          throw Exception('Signin timeout after 30 seconds. Please try again.');
        },
      );

      if (authResponse.user != null) {
        // Get user profile data from Supabase with timeout
        final profileData = await getUserProfile();
        return SupabaseAuthResult.success(
          supabaseUser: authResponse.user,
          profileData: profileData,
        );
      } else {
        return SupabaseAuthResult.failure(
          error: 'auth_failed',
          message: 'Failed to sign in. Please try again.',
        );
      }
    } on TimeoutException catch (timeoutError) {
      debugPrint('SupabaseAuthService: Signin timeout: $timeoutError');
      return SupabaseAuthResult.failure(
        error: 'timeout_error',
        message: 'Signin is taking longer than expected. Please check your internet connection and try again.',
      );
    } on AuthException catch (authError) {
      debugPrint('SupabaseAuthService SignIn Error: ${authError.message}');
      
      String errorCode = 'auth_error';
      String errorMessage = authError.message;
      
      if (authError.message.toLowerCase().contains('credentials')) {
        errorCode = 'invalid_credentials';
        errorMessage = 'Invalid email or password.';
      } else if (authError.message.toLowerCase().contains('email')) {
        errorCode = 'invalid_email';
        errorMessage = 'Please enter a valid email address.';
      } else if (authError.message.contains('timeout') || 
                 authError.message.contains('504') || 
                 authError.message.contains('Gateway timeout')) {
        errorCode = 'timeout_error';
        errorMessage = 'Server timeout. Please try again in a few moments.';
      }
      
      return SupabaseAuthResult.failure(error: errorCode, message: errorMessage);
    } catch (error) {
      debugPrint('SupabaseAuthService SignIn Unexpected Error: $error');
      
      // Handle specific timeout/network errors
      if (error.toString().contains('timeout') || 
          error.toString().contains('504') || 
          error.toString().contains('Gateway timeout') ||
          error.toString().contains('Connection refused') ||
          error.toString().contains('SocketException')) {
        return SupabaseAuthResult.failure(
          error: 'timeout_error',
          message: 'Connection timeout. Please check your internet connection and try again.',
        );
      }
      
      return SupabaseAuthResult.failure(
        error: 'unexpected_error',
        message: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
    } catch (error) {
      debugPrint('SupabaseAuthService SignOut Error: $error');
      rethrow;
    }
  }

  // Reset password for email
  Future<void> resetPasswordForEmail(String email) async {
    try {
      await _supabaseClient.auth.resetPasswordForEmail(email);
    } on AuthException catch (error) {
      debugPrint('SupabaseAuthService ResetPassword Error: ${error.message}');
      rethrow;
    } catch (error) {
      debugPrint('SupabaseAuthService ResetPassword Unexpected Error: $error');
      rethrow;
    }
  }

  // Update password
  Future<void> updatePassword(String newPassword) async {
    try {
      await _supabaseClient.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } on AuthException catch (error) {
      debugPrint('SupabaseAuthService UpdatePassword Error: ${error.message}');
      rethrow;
    } catch (error) {
      debugPrint('SupabaseAuthService UpdatePassword Unexpected Error: $error');
      rethrow;
    }
  }

  // Get current user profile from Supabase using Supabase user ID
  Future<Map<String, dynamic>?> getUserProfile() async {
    if (currentUser == null) {
      debugPrint('SupabaseAuthService: No current user, cannot fetch profile.');
      return null;
    }
    try {
      final response = await _supabaseClient
          .from('profiles')
          .select()
          .eq('id', currentUser!.id)
          .maybeSingle();
      return response;
    } catch (e) {
      debugPrint('SupabaseAuthService: Error fetching user profile: $e');
      return null;
    }
  }

  // Fetch a user profile by Supabase user ID
  Future<UserModel?> getUserProfileById(String supabaseUserId) async {
    try {
      final response = await _supabaseClient
          .from('profiles')
          .select()
          .eq('id', supabaseUserId)
          .maybeSingle();

      if (response == null) {
        debugPrint('SupabaseAuthService: No profile found for Supabase user ID: $supabaseUserId');
        return null;
      }
      return UserModel.fromJson(response);
    } catch (e) {
      debugPrint('SupabaseAuthService: Error fetching profile for Supabase user ID $supabaseUserId: $e');
      return null;
    }
  }

  // Enhanced method to update user profile
  Future<SupabaseAuthResult> updateUserProfile({
    String? firstName,
    String? lastName,
    String? accountType,
    String? subscriptionStatus,
    String? phone,
    String? professionalEmail,
    String? professionalPhone,
    DateTime? dateOfBirth,
    String? memberColor,
  }) async {
    if (currentUser == null) {
      return SupabaseAuthResult.failure(
        error: 'not_authenticated',
        message: 'User not authenticated',
      );
    }

    try {
      // Prepare update data, only including non-null values
      final Map<String, dynamic> updateData = {};
      
      if (firstName != null) updateData['first_name'] = firstName;
      if (lastName != null) updateData['last_name'] = lastName;
      if (accountType != null) updateData['account_type'] = accountType.toLowerCase();
      if (subscriptionStatus != null) updateData['subscription_status'] = subscriptionStatus;
      if (phone != null) updateData['phone'] = phone;
      if (professionalEmail != null) updateData['professional_email'] = professionalEmail;
      if (professionalPhone != null) updateData['professional_phone'] = professionalPhone;
      if (dateOfBirth != null) updateData['date_of_birth'] = dateOfBirth.toIso8601String().split('T')[0];
      if (memberColor != null) updateData['member_color'] = memberColor;
      
      updateData['updated_at'] = DateTime.now().toIso8601String();

      final updatedProfile = await _supabaseClient
          .from('profiles')
          .update(updateData)
          .eq('id', currentUser!.id)
          .select()
          .single();
      
      return SupabaseAuthResult.success(
        supabaseUser: currentUser,
        profileData: updatedProfile,
      );
    } catch (error) {
      debugPrint('SupabaseAuthService: Profile update error: $error');
      return SupabaseAuthResult.failure(
        error: 'update_failed',
        message: 'Failed to update profile. Please try again.',
      );
    }
  }

  // Check if user's email is confirmed
  bool get isEmailConfirmed => currentUser?.emailConfirmedAt != null;

  // Resend email confirmation
  Future<void> resendEmailConfirmation() async {
    if (currentUser?.email != null) {
      try {
        await _supabaseClient.auth.resend(
          type: OtpType.signup,
          email: currentUser!.email!,
        );
      } on AuthException catch (error) {
        debugPrint('SupabaseAuthService ResendConfirmation Error: ${error.message}');
        rethrow;
      }
    }
  }
}
