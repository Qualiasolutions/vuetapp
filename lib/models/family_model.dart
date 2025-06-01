import 'package:freezed_annotation/freezed_annotation.dart';

part 'family_model.freezed.dart';
part 'family_model.g.dart';

/// Model representing a family group in the application
@freezed
class FamilyModel with _$FamilyModel {
  const factory FamilyModel({
    /// Unique ID of the family
    required String id,
    
    /// Name of the family group
    required String name,
    
    /// URL to the family's profile image
    String? imageUrl,
    
    /// ID of the user who owns/created this family
    required String ownerId,
    
    /// Family settings and preferences
    @Default({}) Map<String, dynamic> settings,
    
    /// When the family was created
    required DateTime createdAt,
    
    /// When the family was last updated
    required DateTime updatedAt,
    
    /// List of family members (populated when needed)
    @Default([]) List<FamilyMemberModel> members,
  }) = _FamilyModel;

  factory FamilyModel.fromJson(Map<String, dynamic> json) =>
      _$FamilyModelFromJson(json);
}

/// Model representing a family member with their role and details
@freezed
class FamilyMemberModel with _$FamilyMemberModel {
  const factory FamilyMemberModel({
    /// User ID of the family member
    required String userId,
    
    /// Family ID this member belongs to
    required String familyId,
    
    /// Role of the member in the family
    @Default(FamilyRole.member) FamilyRole role,
    
    /// Color assigned to this member for visual identification
    @Default('#0066cc') String memberColor,
    
    /// When this user joined the family
    required DateTime joinedAt,
    
    /// User details (populated when needed)
    String? firstName,
    String? lastName,
    String? email,
    String? profileImageUrl,
    
    /// Whether this member is currently active
    @Default(true) bool isActive,
  }) = _FamilyMemberModel;

  factory FamilyMemberModel.fromJson(Map<String, dynamic> json) =>
      _$FamilyMemberModelFromJson(json);
}

/// Enum representing different roles within a family
enum FamilyRole {
  /// Family owner - full control over family settings and members
  owner,
  
  /// Family admin - can manage members and some settings
  admin,
  
  /// Regular family member - basic family features access
  member;

  /// Display name for the role
  String get displayName {
    switch (this) {
      case FamilyRole.owner:
        return 'Owner';
      case FamilyRole.admin:
        return 'Admin';
      case FamilyRole.member:
        return 'Member';
    }
  }

  /// Whether this role can manage other members
  bool get canManageMembers {
    return this == FamilyRole.owner || this == FamilyRole.admin;
  }

  /// Whether this role can modify family settings
  bool get canModifySettings {
    return this == FamilyRole.owner;
  }

  /// Whether this role can invite new members
  bool get canInviteMembers {
    return this == FamilyRole.owner || this == FamilyRole.admin;
  }
}

/// Extension to add helpful methods to FamilyModel
extension FamilyModelExtension on FamilyModel {
  /// Get the owner member from the members list
  FamilyMemberModel? get owner {
    try {
      return members.firstWhere((member) => member.role == FamilyRole.owner);
    } catch (e) {
      return null;
    }
  }

  /// Get all admin members
  List<FamilyMemberModel> get admins {
    return members.where((member) => member.role == FamilyRole.admin).toList();
  }

  /// Get all regular members (non-admin, non-owner)
  List<FamilyMemberModel> get regularMembers {
    return members.where((member) => member.role == FamilyRole.member).toList();
  }

  /// Get total number of active members
  int get activeMemberCount {
    return members.where((member) => member.isActive).length;
  }

  /// Whether the family has reached a member limit
  bool get isAtMemberLimit {
    const maxMembers = 6; // Can be made configurable
    return activeMemberCount >= maxMembers;
  }

  /// Get a member by user ID
  FamilyMemberModel? getMemberByUserId(String userId) {
    try {
      return members.firstWhere((member) => member.userId == userId);
    } catch (e) {
      return null;
    }
  }

  /// Whether a user has a specific role in this family
  bool hasRole(String userId, FamilyRole role) {
    final member = getMemberByUserId(userId);
    return member?.role == role;
  }

  /// Whether a user can perform admin actions
  bool canUserManageMembers(String userId) {
    final member = getMemberByUserId(userId);
    return member?.role.canManageMembers ?? false;
  }
}
