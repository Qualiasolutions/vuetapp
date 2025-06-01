import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user_model.freezed.dart';
part 'app_user_model.g.dart';

@freezed
class AppUserModel with _$AppUserModel {
  const factory AppUserModel({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
  String? email, // Stays 'email'
  String? phone, // Stays 'phone'
  @JsonKey(name: 'avatar_url') String? avatarUrl,
  @JsonKey(name: 'professional_email') String? professionalEmail,
  @JsonKey(name: 'professional_phone') String? professionalPhone, // Added JsonKey
  @JsonKey(name: 'account_type') @Default('personal') String accountType,
  @JsonKey(name: 'subscription_status') @Default('free') String subscriptionStatus, // Added JsonKey and snake_case
  @JsonKey(name: 'onboarding_completed') @Default(false) bool onboardingCompleted, // Added JsonKey and snake_case
  @JsonKey(name: 'date_of_birth') DateTime? dateOfBirth, // Added JsonKey and snake_case
  @JsonKey(name: 'member_color') @Default('#0066cc') String memberColor,
  @JsonKey(name: 'family_id') String? familyId,
  @JsonKey(name: 'family_role') String? familyRole, // Added JsonKey and snake_case
  @JsonKey(name: 'created_at') required DateTime createdAt, // Added JsonKey and snake_case
  @JsonKey(name: 'updated_at') required DateTime updatedAt, // Added JsonKey and snake_case
}) = _AppUserModel;

  factory AppUserModel.fromJson(Map<String, dynamic> json) =>
      _$AppUserModelFromJson(json);
}

extension AppUserModelX on AppUserModel {
  String get displayName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    } else if (firstName != null) {
      return firstName!;
    } else if (email != null) {
      return email!;
    }
    return 'Unknown User';
  }

  String get fullName => displayName;

  String get initials {
    if (firstName != null && lastName != null) {
      return '${firstName![0]}${lastName![0]}'.toUpperCase();
    } else if (firstName != null) {
      return firstName![0].toUpperCase();
    } else if (email != null) {
      return email![0].toUpperCase();
    }
    return 'U';
  }

  // Phone number aliases for compatibility
  String? get phoneNumber => phone;
  String? get professionalPhoneNumber => professionalPhone;

  // Account type helpers
  bool get isPersonal => accountType == 'personal' || accountType == 'both';
  bool get isProfessional => accountType == 'professional' || accountType == 'both';
  bool get isBothAccounts => accountType == 'both';

  // Subscription helpers
  bool get isFree => subscriptionStatus == 'free';
  bool get isPremium => subscriptionStatus == 'premium' || subscriptionStatus == 'family';

  // Family helpers
  bool get isInFamily => familyId != null;
  bool get isFamilyOwner => familyRole == 'owner';
  bool get isPremiumUser => isPremium;

  // Display email logic
  String? get displayEmail {
    if (accountType == 'professional' && professionalEmail != null) {
      return professionalEmail;
    }
    return email;
  }

  String? getDisplayEmail(String context) {
    if (context == 'professional' && professionalEmail != null) {
      return professionalEmail;
    }
    return email;
  }

  // Display phone logic
  String? get displayPhone {
    if (accountType == 'professional' && professionalPhone != null) {
      return professionalPhone;
    }
    return phone;
  }

  String? getDisplayPhone(String context) {
    if (context == 'professional' && professionalPhone != null) {
      return professionalPhone;
    }
    return phone;
  }
}
