import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vuet_app/models/social_interest_models.dart';
import 'package:vuet_app/repositories/social_interest_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // For Ref
import 'package:vuet_app/providers/auth_providers.dart'; // For supabaseClientProvider

// --- Supabase Hobby Repository ---
class SupabaseHobbyRepository implements HobbyRepository {
  final SupabaseClient _client;
  // final Ref _ref; // If AutoTaskEngine or other providers are needed

  SupabaseHobbyRepository(this._client);
  // SupabaseHobbyRepository(this._client, this._ref);


  @override
  Future<void> createHobby(Hobby hobby) async {
    try {
      await _client.from('social_hobbies').insert(hobby.toJson());
    } catch (e) {
      // Handle error appropriately
      print('Error creating hobby: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteHobby(String id) async {
    try {
      await _client.from('social_hobbies').delete().match({'id': id});
    } catch (e) {
      print('Error deleting hobby: $e');
      rethrow;
    }
  }

  @override
  Future<Hobby?> getHobbyById(String id) async {
    try {
      final response = await _client
          .from('social_hobbies')
          .select()
          .match({'id': id})
          .limit(1)
          .maybeSingle();
      return response == null ? null : Hobby.fromJson(response);
    } catch (e) {
      print('Error getting hobby by id: $e');
      rethrow;
    }
  }

  @override
  Future<List<Hobby>> getHobbiesByUserId(String userId) async {
    try {
      final response = await _client
          .from('social_hobbies')
          .select()
          .match({'user_id': userId});
      return response.map((item) => Hobby.fromJson(item)).toList();
    } catch (e) {
      print('Error getting hobbies by user id: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateHobby(Hobby hobby) async {
    try {
      await _client
          .from('social_hobbies')
          .update(hobby.toJson())
          .match({'id': hobby.id});
    } catch (e) {
      print('Error updating hobby: $e');
      rethrow;
    }
  }
}

// --- Supabase SocialPlan Repository ---
class SupabaseSocialPlanRepository implements SocialPlanRepository {
  final SupabaseClient _client;

  SupabaseSocialPlanRepository(this._client);

  @override
  Future<void> createSocialPlan(SocialPlan socialPlan) async {
    try {
      await _client.from('social_plans').insert(socialPlan.toJson());
    } catch (e) {
      print('Error creating social plan: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteSocialPlan(String id) async {
    try {
      await _client.from('social_plans').delete().match({'id': id});
    } catch (e) {
      print('Error deleting social plan: $e');
      rethrow;
    }
  }

  @override
  Future<SocialPlan?> getSocialPlanById(String id) async {
    try {
      final response = await _client
          .from('social_plans')
          .select()
          .match({'id': id})
          .limit(1)
          .maybeSingle();
      return response == null ? null : SocialPlan.fromJson(response);
    } catch (e) {
      print('Error getting social plan by id: $e');
      rethrow;
    }
  }

  @override
  Future<List<SocialPlan>> getSocialPlansByUserId(String userId) async {
    try {
      final response = await _client
          .from('social_plans')
          .select()
          .match({'user_id': userId});
      return response.map((item) => SocialPlan.fromJson(item)).toList();
    } catch (e) {
      print('Error getting social plans by user id: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateSocialPlan(SocialPlan socialPlan) async {
    try {
      await _client
          .from('social_plans')
          .update(socialPlan.toJson())
          .match({'id': socialPlan.id});
    } catch (e) {
      print('Error updating social plan: $e');
      rethrow;
    }
  }
}

// --- Supabase SocialEvent Repository ---
class SupabaseSocialEventRepository implements SocialEventRepository {
  final SupabaseClient _client;

  SupabaseSocialEventRepository(this._client);

  @override
  Future<void> createSocialEvent(SocialEvent socialEvent) async {
    try {
      await _client.from('social_events').insert(socialEvent.toJson());
    } catch (e) {
      print('Error creating social event: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteSocialEvent(String id) async {
    try {
      await _client.from('social_events').delete().match({'id': id});
    } catch (e) {
      print('Error deleting social event: $e');
      rethrow;
    }
  }

  @override
  Future<SocialEvent?> getSocialEventById(String id) async {
    try {
      final response = await _client
          .from('social_events')
          .select()
          .match({'id': id})
          .limit(1)
          .maybeSingle();
      return response == null ? null : SocialEvent.fromJson(response);
    } catch (e) {
      print('Error getting social event by id: $e');
      rethrow;
    }
  }

  @override
  Future<List<SocialEvent>> getSocialEventsByUserId(String userId) async {
    try {
      final response = await _client
          .from('social_events')
          .select()
          .match({'user_id': userId});
      return response.map((item) => SocialEvent.fromJson(item)).toList();
    } catch (e) {
      print('Error getting social events by user id: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateSocialEvent(SocialEvent socialEvent) async {
    try {
      await _client
          .from('social_events')
          .update(socialEvent.toJson())
          .match({'id': socialEvent.id});
    } catch (e) {
      print('Error updating social event: $e');
      rethrow;
    }
  }
}
