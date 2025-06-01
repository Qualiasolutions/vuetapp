import 'dart:io';
import 'package:vuet_app/models/app_user_model.dart';
import 'package:vuet_app/models/family_invitation_model.dart';

/// Interface for user repository operations
abstract class UserRepository {
  /// Get the current user's profile
  Future<AppUserModel?> getCurrentUser();
  
  /// Get a user by their ID
  Future<AppUserModel?> getUserById(String userId);
  
  /// Update a user's basic profile information
  Future<AppUserModel> updateUserProfile({
    required String userId,
    required String firstName,
    required String lastName,
    DateTime? dateOfBirth,
    String? memberColor,
  });
  
  /// Update a user's contact information (email or phone)
  Future<AppUserModel> updateUserContact({
    required String userId,
    String? email,
    String? phoneNumber,
  });
  
  /// Upload and update a user's profile image
  Future<String> uploadProfileImage({
    required String userId,
    required File imageFile,
  });
  
  /// Update user password
  Future<void> updateUserPassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  });
  
  /// Get user's subscription details
  Future<Map<String, dynamic>> getUserSubscription(String userId);
  
  /// Check if user has premium subscription
  Future<bool> isPremiumUser(String userId);
  
  /// Get all family members for a user (if they have a family subscription)
  Future<List<AppUserModel>> getFamilyMembers(String userId);
  
  /// Send an invitation to join the family group
  Future<bool> inviteFamilyMember(String email);
  
  /// Get all pending invitations for the current user
  Future<List<FamilyInvitationModel>> getFamilyInvitations();
  
  /// Decline a family invitation
  Future<bool> declineFamilyInvitation(String invitationId);
  
  /// Accept a family invitation (for the invitee)
  Future<bool> acceptFamilyInvitation(String invitationId);
  
  /// Remove a member from the family group (for the family owner)
  Future<bool> removeFamilyMember(String memberId);
  
  /// Leave the current family group (for family members)
  Future<bool> leaveFamilyGroup();
}
