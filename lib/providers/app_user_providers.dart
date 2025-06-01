import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/app_user_model.dart';
import 'package:vuet_app/repositories/app_user_repository.dart';
import 'package:vuet_app/repositories/user_repository.dart';
import 'package:vuet_app/services/user_details_service.dart';
import 'package:vuet_app/providers/auth_providers.dart';

/// Provider for the UserDetailsService
final userDetailsServiceProvider = ChangeNotifierProvider<UserDetailsService>((ref) {
  return UserDetailsService();
});

/// Provider for the user's premium status - returns a Future`<bool>`
final userIsPremiumProvider = FutureProvider<bool>((ref) async {
  final userDetailsService = ref.read(userDetailsServiceProvider);
  await Future.microtask(() {});
  return await userDetailsService.checkPremiumStatus();
});

/// Provider for the user's details - returns a Future`<Map<String, dynamic>?>`
final userDetailsProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final userDetailsService = ref.read(userDetailsServiceProvider);
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
final appUserRepositoryProvider = Provider<UserRepository>((ref) {
  return AppUserRepository();
});

/// Provider for the current user (AppUserModel)
final currentAppUserProvider = FutureProvider<AppUserModel?>((ref) async {
  // Watch the Supabase User from auth_providers
  final supabaseUser = ref.watch(currentUserProvider);

  if (supabaseUser == null) {
    return null;
  }
  final repository = ref.read(appUserRepositoryProvider);
  return await repository.getCurrentUser();
});

/// Provider to fetch a user profile by their ID
final appUserProfileProviderFamily = FutureProvider.autoDispose.family<AppUserModel?, String?>((ref, userId) async {
  if (userId == null || userId.isEmpty) {
    return null;
  }
  final repository = ref.read(appUserRepositoryProvider);
  return await repository.getUserById(userId);
});

/// Provider for checking if a user has a premium subscription
final isPremiumUserProvider = FutureProvider.autoDispose.family<bool, String>((ref, userId) {
  final repository = ref.read(appUserRepositoryProvider);
  return repository.isPremiumUser(userId);
});

/// Provider for getting a user's subscription details
final userSubscriptionProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, String>((ref, userId) {
  final repository = ref.read(appUserRepositoryProvider);
  return repository.getUserSubscription(userId);
});

/// Provider for getting family members
final familyMembersProvider = FutureProvider.autoDispose.family<List<AppUserModel>, String>((ref, userId) {
  final repository = ref.read(appUserRepositoryProvider);
  return repository.getFamilyMembers(userId);
});
