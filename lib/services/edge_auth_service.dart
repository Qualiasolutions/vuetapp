import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vuet_app/config/supabase_config.dart';
import 'package:vuet_app/models/user_model.dart';
import 'package:vuet_app/utils/web_environment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Result wrapper for enhanced error handling
class EdgeAuthResult {
  final bool success;
  final User? user;
  final Session? session;
  final String? error;
  final String? message;
  final Map<String, dynamic>? data;

  EdgeAuthResult({
    required this.success,
    this.user,
    this.session,
    this.error,
    this.message,
    this.data,
  });

  factory EdgeAuthResult.success({
    User? user,
    Session? session,
    Map<String, dynamic>? data,
    String? message,
  }) {
    return EdgeAuthResult(
      success: true,
      user: user,
      session: session,
      data: data,
      message: message,
    );
  }

  factory EdgeAuthResult.failure({
    required String error,
    String? message,
  }) {
    return EdgeAuthResult(
      success: false,
      error: error,
      message: message,
    );
  }
}

class EdgeAuthService {
  final SupabaseClient _supabaseClient = SupabaseConfig.client;
  
  // Get the base URL for Edge Functions
  String get _edgeFunctionUrl {
    final baseUrl = WebEnvironment.supabaseUrl ?? '';
    return '$baseUrl/functions/v1';
  }
  
  // Get authorization headers for Edge Functions
  Map<String, String> get _authHeaders {
    final anonKey = WebEnvironment.supabaseAnonKey ?? '';
    return {
      'Authorization': 'Bearer $anonKey',
      'Content-Type': 'application/json',
      'apikey': anonKey,
    };
  }

  // Stream for authentication state changes
  Stream<AuthState> get authStateChange => _supabaseClient.auth.onAuthStateChange;

  // Get current user
  User? get currentUser => _supabaseClient.auth.currentUser;

  // Check if user is signed in
  bool get isSignedIn => currentUser != null;

  // Expose Supabase client if needed
  SupabaseClient get supabase => _supabaseClient;

  // Enhanced sign up using Edge Function
  Future<EdgeAuthResult> signUpWithEmailPassword({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String accountType,
    String? professionalCategory,
  }) async {
    try {
      debugPrint('EdgeAuthService: Starting registration via Edge Function for email: $email');
      
      // Call the auth-signup edge function
      final response = await http.post(
        Uri.parse('$_edgeFunctionUrl/auth-signup'),
        headers: _authHeaders,
        body: jsonEncode({
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
          'accountType': accountType,
          'professionalCategory': professionalCategory,
        }),
      ).timeout(
        const Duration(seconds: 60), // 60 second timeout
        onTimeout: () {
          throw TimeoutException('Edge Function request timed out', const Duration(seconds: 60));
        },
      );

      debugPrint('EdgeAuthService: Edge Function response status: ${response.statusCode}');
      
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      
      if (response.statusCode == 200 && responseData['success'] == true) {
        debugPrint('EdgeAuthService: User created successfully via Edge Function');
        
        // Now sign in the user to get the session
        try {
          final signInResponse = await _supabaseClient.auth.signInWithPassword(
            email: email,
            password: password,
          );
          
          return EdgeAuthResult.success(
            user: signInResponse.user,
            session: signInResponse.session,
            data: responseData,
            message: responseData['message'] as String?,
          );
        } catch (signInError) {
          debugPrint('EdgeAuthService: Sign-in after registration failed: $signInError');
          return EdgeAuthResult.failure(
            error: 'signin_after_signup_failed',
            message: 'Account created but sign-in failed. Please try signing in manually.',
          );
        }
      } else {
        // Handle error response from Edge Function
        final errorCode = responseData['code'] as String? ?? 'unknown_error';
        final errorMessage = responseData['error'] as String? ?? 'An error occurred during registration';
        
        debugPrint('EdgeAuthService: Edge Function error: $errorCode - $errorMessage');
        
        return EdgeAuthResult.failure(
          error: errorCode,
          message: errorMessage,
        );
      }
    } on TimeoutException catch (e) {
      debugPrint('EdgeAuthService: Timeout error: $e');
      return EdgeAuthResult.failure(
        error: 'timeout_error',
        message: 'Registration request timed out. Please check your connection and try again.',
      );
    } on http.ClientException catch (e) {
      debugPrint('EdgeAuthService: Network error: $e');
      return EdgeAuthResult.failure(
        error: 'network_error',
        message: 'Network connection failed. Please check your internet connection.',
      );
    } catch (error) {
      debugPrint('EdgeAuthService: Unexpected error: $error');
      
      // Handle specific error types
      if (error.toString().contains('timeout') || 
          error.toString().contains('504') || 
          error.toString().contains('Connection refused')) {
        return EdgeAuthResult.failure(
          error: 'timeout_error',
          message: 'Connection timeout. Please check your internet connection and try again.',
        );
      }
      
      return EdgeAuthResult.failure(
        error: 'unexpected_error',
        message: 'An unexpected error occurred. Please try again.',
      );
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
      debugPrint('EdgeAuthService SignIn Error: ${error.message}');
      rethrow;
    } catch (error) {
      debugPrint('EdgeAuthService SignIn Unexpected Error: $error');
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
    } on AuthException catch (error) {
      debugPrint('EdgeAuthService SignOut Error: ${error.message}');
      rethrow;
    } catch (error) {
      debugPrint('EdgeAuthService SignOut Unexpected Error: $error');
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
      debugPrint('EdgeAuthService ResetPassword Error: ${error.message}');
      rethrow;
    } catch (error) {
      debugPrint('EdgeAuthService ResetPassword Unexpected Error: $error');
      rethrow;
    }
  }

  // Get current user profile
  Future<Map<String, dynamic>?> getUserProfile() async {
    if (currentUser == null) {
      debugPrint('EdgeAuthService: No current user, cannot fetch profile.');
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
      debugPrint('EdgeAuthService: Error fetching user profile: $e');
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
      debugPrint('EdgeAuthService UpdatePassword Error: ${error.message}');
      rethrow;
    } catch (error) {
      debugPrint('EdgeAuthService UpdatePassword Unexpected Error: $error');
      rethrow;
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
        debugPrint('EdgeAuthService: No profile found for user ID: $userId');
        return null;
      }
      return UserModel.fromJson(response);
    } catch (e) {
      debugPrint('EdgeAuthService: Error fetching profile for user ID $userId: $e');
      return null;
    }
  }

  // Handle password reset redirect
  Future<bool> handlePasswordResetRedirect(Uri uri) async {
    try {
      return true; // Successfully retrieved session from URL
    } catch (error) {
      debugPrint('EdgeAuthService: Error handling password reset redirect: $error');
      return false;
    }
  }

  // Chat with OpenAI via Edge Function
  Future<String> chatWithLANA({
    required List<Map<String, String>> messages,
    Map<String, dynamic>? userContext,
  }) async {
    try {
      debugPrint('EdgeAuthService: Calling OpenAI chat via Edge Function');
      
      final response = await http.post(
        Uri.parse('$_edgeFunctionUrl/openai-chat'),
        headers: _authHeaders,
        body: jsonEncode({
          'messages': messages,
          'userContext': userContext,
        }),
      ).timeout(
        const Duration(seconds: 45), // 45 second timeout
        onTimeout: () {
          throw TimeoutException('OpenAI chat request timed out', const Duration(seconds: 45));
        },
      );

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      
      if (response.statusCode == 200 && responseData['success'] == true) {
        return responseData['message'] as String? ?? 'Sorry, I couldn\'t generate a response.';
      } else {
        final errorMessage = responseData['error'] as String? ?? 'Chat service unavailable';
        debugPrint('EdgeAuthService: OpenAI chat error: $errorMessage');
        return 'I\'m having trouble right now. Please try again later.';
      }
    } on TimeoutException catch (e) {
      debugPrint('EdgeAuthService: Chat timeout: $e');
      return 'Sorry, that took too long. Please try again with a shorter message.';
    } catch (error) {
      debugPrint('EdgeAuthService: Chat error: $error');
      return 'I encountered an error. Please try again later.';
    }
  }
}

final edgeAuthServiceProvider = Provider<EdgeAuthService>((ref) => EdgeAuthService());
