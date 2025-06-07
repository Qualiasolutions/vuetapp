import 'package:freezed_annotation/freezed_annotation.dart';

part 'social_interests_entities.freezed.dart';
part 'social_interests_entities.g.dart';

/// Contact entity for Social Interests category
/// Fields: name, phone, email, address, birthday, relationship, company, job_title
@freezed
class Contact with _$Contact {
  const factory Contact({
    int? id,
    required String name,
    String? phone,
    String? email,
    String? address,
    DateTime? birthday,
    String? relationship, // Friend, Family, Colleague, Acquaintance, etc.
    String? company,
    String? jobTitle,
    String? notes,
    @Default('Contact') String resourceType,
  }) = _Contact;

  factory Contact.fromJson(Map<String, dynamic> json) => _$ContactFromJson(json);
}

/// Event entity for Social Interests category
/// Fields: name, event_type, date, time, location, organizer, attendees, description
@freezed
class Event with _$Event {
  const factory Event({
    int? id,
    required String name,
    required String eventType, // Party, Meeting, Conference, Wedding, etc.
    required DateTime date,
    String? time,
    String? location,
    String? organizer,
    String? attendees,
    String? description,
    String? notes,
    @Default('Event') String resourceType,
  }) = _Event;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}

/// Group entity for Social Interests category
/// Fields: name, group_type, description, meeting_frequency, meeting_location, contact_person
@freezed
class Group with _$Group {
  const factory Group({
    int? id,
    required String name,
    required String groupType, // Club, Society, Team, Organization, etc.
    String? description,
    String? meetingFrequency, // Weekly, Monthly, Quarterly, etc.
    String? meetingLocation,
    String? contactPerson,
    String? contactPhone,
    String? contactEmail,
    String? notes,
    @Default('Group') String resourceType,
  }) = _Group;

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
}

/// Social Activity entity for Social Interests category
@freezed
class SocialActivity with _$SocialActivity {
  const factory SocialActivity({
    int? id,
    required String name,
    required String activityType, // Hobby, Sport, Interest, etc.
    String? description,
    String? frequency, // Daily, Weekly, Monthly, etc.
    String? location,
    String? equipment,
    double? cost,
    String? notes,
    @Default('SocialActivity') String resourceType,
  }) = _SocialActivity;

  factory SocialActivity.fromJson(Map<String, dynamic> json) => _$SocialActivityFromJson(json);
}

/// Social Gathering entity for Social Interests category
@freezed
class SocialGathering with _$SocialGathering {
  const factory SocialGathering({
    int? id,
    required String name,
    required String gatheringType, // Dinner, Party, Meetup, etc.
    required DateTime dateTime,
    String? location,
    String? hostName,
    int? expectedAttendees,
    String? theme,
    String? notes,
    @Default('SocialGathering') String resourceType,
  }) = _SocialGathering;

  factory SocialGathering.fromJson(Map<String, dynamic> json) => _$SocialGatheringFromJson(json);
}

/// Validation helpers for Social Interests entities
class SocialInterestsValidators {
  /// Required string validator
  static String? required(String? value) {
    return value != null && value.trim().isNotEmpty ? null : 'Required';
  }
  
  /// Date ISO validator (YYYY-MM-DD)
  static String? dateIso(String? value) {
    return DateTime.tryParse(value ?? '') != null ? null : 'yyyy-MM-dd';
  }
  
  /// Optional date validator
  static String? optionalDate(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return DateTime.tryParse(value) != null ? null : 'yyyy-MM-dd';
  }
  
  /// Positive number validator
  static String? positiveNumber(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final parsed = double.tryParse(value);
    return parsed != null && parsed > 0 ? null : 'Must be > 0';
  }
  
  /// Email validator (optional)
  static String? optionalEmail(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return emailRegex.hasMatch(value) ? null : 'Invalid email';
  }
  
  /// Phone validator (optional)
  static String? optionalPhone(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]+$');
    return phoneRegex.hasMatch(value) ? null : 'Invalid phone';
  }
  
  /// Time validator (HH:MM format, optional)
  static String? optionalTime(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final timeRegex = RegExp(r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$');
    return timeRegex.hasMatch(value) ? null : 'HH:MM format';
  }
  
  /// Positive integer validator (optional)
  static String? optionalPositiveInt(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final parsed = int.tryParse(value);
    return parsed != null && parsed > 0 ? null : 'Must be > 0';
  }
}
