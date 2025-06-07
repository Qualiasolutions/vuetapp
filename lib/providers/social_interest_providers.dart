import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/social_interest_models.dart';
import 'package:vuet_app/providers/auth_providers.dart'; // For supabaseClientProvider and authServiceProvider
import 'package:vuet_app/repositories/social_interest_repository.dart';
import 'package:vuet_app/repositories/supabase_social_interest_repository.dart';

// --- Repository Providers ---

final hobbyRepositoryProvider = Provider<HobbyRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseHobbyRepository(client);
});

final socialPlanRepositoryProvider = Provider<SocialPlanRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseSocialPlanRepository(client);
});

final socialEventRepositoryProvider = Provider<SocialEventRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseSocialEventRepository(client);
});

// --- Data Providers ---

// Hobbies
final userHobbiesProvider = FutureProvider<List<Hobby>>((ref) async {
  final userId = ref.watch(currentUserProvider)?.id;
  if (userId == null) return [];
  return ref.watch(hobbyRepositoryProvider).getHobbiesByUserId(userId);
});

final hobbyByIdProvider = FutureProvider.family<Hobby?, String>((ref, id) async {
  return ref.watch(hobbyRepositoryProvider).getHobbyById(id);
});

// Social Plans
final userSocialPlansProvider = FutureProvider<List<SocialPlan>>((ref) async {
  final userId = ref.watch(currentUserProvider)?.id;
  if (userId == null) return [];
  return ref.watch(socialPlanRepositoryProvider).getSocialPlansByUserId(userId);
});

final socialPlanByIdProvider = FutureProvider.family<SocialPlan?, String>((ref, id) async {
  return ref.watch(socialPlanRepositoryProvider).getSocialPlanById(id);
});

// Social Events
final userSocialEventsProvider = FutureProvider<List<SocialEvent>>((ref) async {
  final userId = ref.watch(currentUserProvider)?.id;
  if (userId == null) return [];
  return ref.watch(socialEventRepositoryProvider).getSocialEventsByUserId(userId);
});

final socialEventByIdProvider = FutureProvider.family<SocialEvent?, String>((ref, id) async {
  return ref.watch(socialEventRepositoryProvider).getSocialEventById(id);
});
