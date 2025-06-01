import 'package:supabase_flutter/supabase_flutter.dart';

/// Helper class for authentication-related operations
class AuthHelper {
  /// Private constructor to prevent instantiation
  AuthHelper._();
  
  /// Get the current user's ID
  static Future<String> getCurrentUserId() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw Exception('User is not authenticated');
    }
    return user.id;
  }

  /// Validates an email string
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Validates a password string
  /// 
  /// Password must be at least 8 characters and contain at least:
  /// - One uppercase letter
  /// - One lowercase letter
  /// - One number
  static bool isStrongPassword(String password) {
    if (password.length < 8) return false;
    
    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasNumber = password.contains(RegExp(r'[0-9]'));
    
    return hasUppercase && hasLowercase && hasNumber;
  }
  
  /// Validates password and returns error message or null if valid
  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password is required';
    }
    
    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }
    
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    
    if (!password.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    
    return null; // Password is valid
  }

  /// Get a user-friendly error message from an exception
  static String getErrorMessage(dynamic error) {
    if (error is AuthException) {
      // Handle Supabase Auth errors
      return _processAuthError(error);
    } else if (error is PostgrestException) {
      // Handle Supabase Database errors
      return _processPostgrestError(error);
    } else if (error is Exception) {
      // Handle generic exceptions
      return error.toString().replaceAll('Exception: ', '');
    } else {
      // Fallback for unknown error types
      return 'An unexpected error occurred. Please try again.';
    }
  }

  /// Process Supabase Auth errors and return user-friendly messages
  static String _processAuthError(AuthException error) {
    final message = error.message.toLowerCase();
    
    // Account existence checks
    if (message.contains('user already registered')) {
      return 'An account with this email already exists. Please log in instead.';
    }
    
    // Invalid credentials
    if (message.contains('invalid login credentials')) {
      return 'Incorrect email or password. Please try again.';
    }
    
    // Email confirmation
    if (message.contains('email not confirmed')) {
      return 'Please confirm your email address before logging in.';
    }
    
    // Password reset
    if (message.contains('recovery')) {
      return 'Password reset link sent to your email. Please check your inbox.';
    }
    
    // Network-related errors
    if (message.contains('network') || message.contains('connection')) {
      return 'Network error. Please check your internet connection and try again.';
    }
    
    // Return the original message if no specific case is matched
    return error.message;
  }

  /// Process Supabase Database errors and return user-friendly messages
  static String _processPostgrestError(PostgrestException error) {
    final message = error.message.toLowerCase();
    
    // Foreign key violations
    if (message.contains('foreign key constraint')) {
      return 'This operation references data that doesn\'t exist.';
    }
    
    // Unique constraint violations
    if (message.contains('unique constraint')) {
      return 'This data already exists. Please use a unique value.';
    }
    
    // Permission errors
    if (message.contains('permission denied')) {
      return 'You don\'t have permission to perform this action.';
    }
    
    // Return the original message if no specific case is matched
    return error.message;
  }
}
