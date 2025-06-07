import 'package:vuet_app/models/social_interest_models.dart';

// --- Hobby Repository ---
abstract class HobbyRepository {
  Future<List<Hobby>> getHobbiesByUserId(String userId);
  Future<Hobby?> getHobbyById(String id);
  Future<void> createHobby(Hobby hobby);
  Future<void> updateHobby(Hobby hobby);
  Future<void> deleteHobby(String id);
}

// --- SocialPlan Repository ---
abstract class SocialPlanRepository {
  Future<List<SocialPlan>> getSocialPlansByUserId(String userId);
  Future<SocialPlan?> getSocialPlanById(String id);
  Future<void> createSocialPlan(SocialPlan socialPlan);
  Future<void> updateSocialPlan(SocialPlan socialPlan);
  Future<void> deleteSocialPlan(String id);
}

// --- SocialEvent Repository ---
abstract class SocialEventRepository {
  Future<List<SocialEvent>> getSocialEventsByUserId(String userId);
  Future<SocialEvent?> getSocialEventById(String id);
  Future<void> createSocialEvent(SocialEvent socialEvent);
  Future<void> updateSocialEvent(SocialEvent socialEvent);
  Future<void> deleteSocialEvent(String id);
}
