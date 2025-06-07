import 'package:freezed_annotation/freezed_annotation.dart';

part 'social_interest_models.freezed.dart';
part 'social_interest_models.g.dart';

@freezed
class Hobby with _$Hobby {
  const factory Hobby({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String name,
    String? description,
    String? frequency,
    @JsonKey(name: 'last_engaged_date') DateTime? lastEngagedDate,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _Hobby;

  factory Hobby.fromJson(Map<String, dynamic> json) => _$HobbyFromJson(json);
}

@freezed
class SocialPlan with _$SocialPlan {
  const factory SocialPlan({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String title,
    String? description,
    @JsonKey(name: 'plan_date') required DateTime planDate,
    // Storing time as String for simplicity with TIME type from Supabase, can be parsed.
    // Alternatively, use a custom converter or combine with planDate into a DateTime.
    @JsonKey(name: 'plan_time') String? planTime, 
    String? location,
    String? status,
    @JsonKey(name: 'with_contacts') dynamic withContacts, // JSONB can be Map or List
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _SocialPlan;

  factory SocialPlan.fromJson(Map<String, dynamic> json) => _$SocialPlanFromJson(json);
}

@freezed
class SocialEvent with _$SocialEvent {
  const factory SocialEvent({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String name,
    String? description,
    @JsonKey(name: 'start_datetime') required DateTime startDatetime,
    @JsonKey(name: 'end_datetime') DateTime? endDatetime,
    @JsonKey(name: 'location_name') String? locationName,
    @JsonKey(name: 'location_address') String? locationAddress,
    @JsonKey(name: 'is_public', defaultValue: false) required bool isPublic,
    String? organizer,
    @JsonKey(name: 'website_url') String? websiteUrl,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _SocialEvent;

  factory SocialEvent.fromJson(Map<String, dynamic> json) => _$SocialEventFromJson(json);
}
