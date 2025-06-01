import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/app_user_model.dart';
import 'package:vuet_app/repositories/supabase_user_repository.dart';
import 'package:vuet_app/repositories/user_repository.dart';
import 'package:vuet_app/services/user_details_service.dart';
import 'package:vuet_app/providers/auth_providers.dart'; // Import auth_providers

/// Provider for the UserDetailsService
/// Note: Use backticks around content with angle brackets, or replace `<` with `<` and `>` with `>`
final userDetailsServiceProvider = ChangeNotifierProvider<UserDetailsService>((ref) {
  return UserDetailsService();
});

// ignore: unintended_html_in_doc_comment
/// Provider for the user's premium status - returns a Future<bool>
final userIsPremiumProvider = FutureProvider<bool>((ref) async {
  // Use ref.read instead of ref.watch to avoid modifying state during initialization
  final userDetailsService = ref.read(userDetailsServiceProvider);
  
  // Add a small delay to ensure we're not in initialization phase
  await Future.microtask(() {});
  
  return await userDetailsService.checkPremiumStatus();
});

// ignore: unintended_html_in_doc_comment
/// Provider for the user's details - returns a Future<Map<String, dynamic>?>
final userDetailsProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  // Use ref.read instead of ref.watch to avoid modifying state during initialization
  final userDetailsService = ref.read(userDetailsServiceProvider);
  
  // Add a small delay to ensure we're not in initialization phase
  await Future.microtask(() {});
  
  return await userDetailsService.fetchUserDetails();
});

/// Provider for the user's current error state
final userDetailsErrorProvider = Provider<String?>((ref) {
  final userDetailsService = ref.watch(userDetailsServiceProvider);
  return userDetailsService.error;
});

/// Provider for the user's loading state
final userDetailsLoadingProvider = Provider<bool>((ref) {
  final userDetailsService = ref.watch(userDetailsServiceProvider);
  return userDetailsService.isLoading;
});

/// Provider for the user repository
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return SupabaseUserRepository();
});

/// Provider for the current user (AppUserModel)
final currentUserModelProvider = FutureProvider<AppUserModel?>((ref) async {
  // Watch the Supabase User from auth_providers
  final supabaseUser = ref.watch(currentUserProvider);

  if (supabaseUser == null) {
    return null;
  }
  final repository = ref.read(userRepositoryProvider);
  return await repository.getCurrentUser(); // Assuming this fetches UserModel based on authenticated user
});

/// Provider to fetch a user profile by their ID
final userProfileProviderFamily = FutureProvider.autoDispose.family<AppUserModel?, String?>((ref, userId) async {
  if (userId == null || userId.isEmpty) {
    return null;
  }
  final repository = ref.read(userRepositoryProvider);
  return await repository.getUserById(userId);
});

/// Provider for checking if a user has a premium subscription
final isPremiumUserProvider = FutureProvider.autoDispose.family<bool, String>((ref, userId) {
  final repository = ref.read(userRepositoryProvider);
  return repository.isPremiumUser(userId);
});

/// Provider for getting a user's subscription details
final userSubscriptionProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, String>((ref, userId) {
  final repository = ref.read(userRepositoryProvider);
  return repository.getUserSubscription(userId);
});

// Removed duplicate familyMembersProvider definition
