import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Utility class for handling errors throughout the application
class ErrorHandler {
  /// Private constructor to prevent instantiation
  ErrorHandler._();

  /// Handles an error by logging it and optionally showing a user-friendly message
  /// 
  /// Parameters:
  /// - [context]: Context in which the error occurred (e.g., "Login", "Task creation")
  /// - [error]: The error object
  /// - [stackTrace]: Optional stack trace
  /// - [showUserMessage]: Whether to show a user-friendly message (default: false)
  static void handleError(
    String context,
    dynamic error, [
    StackTrace? stackTrace,
    bool showUserMessage = false,
  ]) {
    // Log the error
    logError(context, error, stackTrace);
    
    // If needed, show a user-friendly message
    if (showUserMessage) {
      final message = getUserFriendlyMessage(error);
      // This could dispatch to a global error handling UI mechanism
      // For now, we're just logging it
      debugPrint('USER MESSAGE: $message');
    }
  }

  /// Logs an error to the console and potentially to an error reporting service
  /// 
  /// Parameters:
  /// - [context]: Context in which the error occurred
  /// - [error]: The error object
  /// - [stackTrace]: Optional stack trace
  static void logError(
    String context,
    dynamic error, [
    StackTrace? stackTrace,
  ]) {
    final errorMessage = error.toString();
    final trace = stackTrace ?? StackTrace.current;
    
    // Log to console in debug mode
    if (kDebugMode) {
      print('ERROR in $context: $errorMessage');
      print('Stack trace: $trace');
    }
    
    // TODO: In production, send to error reporting service like Firebase Crashlytics
    // if (!kDebugMode) {
    //   FirebaseCrashlytics.instance.recordError(
    //     error,
    //     trace,
    //     reason: context,
    //   );
    // }
  }

  /// Converts a technical error to a user-friendly message
  /// 
  /// Parameters:
  /// - [error]: The error object
  /// 
  /// Returns a user-friendly error message
  static String getUserFriendlyMessage(dynamic error) {
    // Handle specific error types
    if (error is TimeoutException) {
      return 'The operation timed out. Please check your internet connection and try again.';
    } else if (error is SocketException) {
      return 'Network error. Please check your internet connection and try again.';
    } else if (error is AuthException) {
      return _handleAuthError(error);
    } else if (error is PostgrestException) {
      return _handleDatabaseError(error);
    } else if (error is FormatException) {
      return 'Invalid data format. Please check your input and try again.';
    } else if (error is Exception) {
      // Generic exception handling
      final message = error.toString().toLowerCase();
      
      if (message.contains('permission') || message.contains('access')) {
        return 'You don\'t have permission to perform this action.';
      } else if (message.contains('not found') || message.contains('404')) {
        return 'The requested resource was not found.';
      } else if (message.contains('already exists') || message.contains('duplicate')) {
        return 'This item already exists.';
      } else if (message.contains('validation') || message.contains('invalid')) {
        return 'Please check your input and try again.';
      }
    }
    
    // Default generic message
    return 'An unexpected error occurred. Please try again later.';
  }

  /// Handles authentication-specific errors
  /// 
  /// Parameters:
  /// - [error]: The authentication error
  /// 
  /// Returns a user-friendly error message
  static String _handleAuthError(AuthException error) {
    final message = error.message.toLowerCase();
    
    if (message.contains('invalid login credentials')) {
      return 'Invalid email or password. Please check your credentials and try again.';
    } else if (message.contains('email not confirmed')) {
      return 'Please confirm your email address before logging in.';
    } else if (message.contains('too many requests')) {
      return 'Too many attempts. Please try again later.';
    } else if (message.contains('weak password')) {
      return 'Your password is too weak. Please choose a stronger password.';
    } else if (message.contains('email already in use')) {
      return 'This email is already registered. Please use a different email or try logging in.';
    }
    
    return 'Authentication error. Please try again.';
  }

  /// Handles database-specific errors
  /// 
  /// Parameters:
  /// - [error]: The database error
  /// 
  /// Returns a user-friendly error message
  static String _handleDatabaseError(PostgrestException error) {
    final message = error.message.toLowerCase();
    final code = error.code;
    
    if (code == '23505' || message.contains('unique constraint')) {
      return 'This item already exists.';
    } else if (code == '23503' || message.contains('foreign key constraint')) {
      return 'This action cannot be completed because the item is being used elsewhere.';
    } else if (code == '42P01' || message.contains('relation') && message.contains('does not exist')) {
      return 'Database configuration error. Please contact support.';
    } else if (code == '42501' || message.contains('permission denied')) {
      return 'You don\'t have permission to perform this action.';
    }
    
    return 'Database error. Please try again later.';
  }

  /// Determines if an error should be reported to the user
  /// 
  /// Parameters:
  /// - [error]: The error object
  /// 
  /// Returns true if the error should be shown to the user
  static bool shouldShowToUser(dynamic error) {
    // Don't show system or internal errors to users
    if (error is AssertionError) return false;
    if (error.toString().contains('INTERNAL_ERROR')) return false;
    
    // Show network, auth, and validation errors
    if (error is TimeoutException) return true;
    if (error is SocketException) return true;
    if (error is AuthException) return true;
    if (error is FormatException) return true;
    
    // For database errors, only show certain types
    if (error is PostgrestException) {
      final code = error.code;
      // Show constraint violations and permission errors
      return code == '23505' || code == '23503' || code == '42501';
    }
    
    // By default, don't show errors to users
    return false;
  }
}
