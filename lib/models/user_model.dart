import 'package:vuet_app/models/app_user_model.dart';

// Re-export the AppUserModel as UserModel for backwards compatibility
typedef UserModel = AppUserModel;

// Extension methods for UserModel (separate from AppUserModelX to avoid conflicts)
extension UserModelX on UserModel {
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
