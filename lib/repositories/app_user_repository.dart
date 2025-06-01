import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vuet_app/config/supabase_config.dart';
import 'package:vuet_app/models/app_user_model.dart';
import 'package:vuet_app/models/family_invitation_model.dart';
import 'package:vuet_app/repositories/user_repository.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

/// Supabase implementation of the UserRepository interface using AppUserModel
class AppUserRepository implements UserRepository {
  final SupabaseClient _client = SupabaseConfig.client;
  final String _profilesTable = 'profiles';
  final String _subscriptionsTable = 'subscriptions';
  final String _invitationsTable = 'family_invitations';

  @override
  Future<AppUserModel?> getCurrentUser() async {
    try {
      final currentUserId = _client.auth.currentUser?.id;
      if (currentUserId == null) {
        return null;
      }
      
      return await getUserById(currentUserId);
    } catch (e) {
      debugPrint('Error fetching current user: $e');
      return null;
    }
  }

  @override
  Future<AppUserModel?> getUserById(String userId) async {
    try {
      final response = await _client
          .from(_profilesTable)
          .select()
          .eq('id', userId)
          .maybeSingle();
      
      debugPrint('Supabase response for user $userId: $response');
      
      if (response == null) {
        return null;
      }
      return AppUserModel.fromJson(response);
    } catch (e) {
      debugPrint('Error fetching user by ID: $e');
      return null;
    }
  }

  @override
  Future<AppUserModel> updateUserProfile({
    required String userId,
    required String firstName,
    required String lastName,
    DateTime? dateOfBirth,
    String? memberColor,
  }) async {
    try {
      final Map<String, dynamic> updateData = {
        'first_name': firstName,
        'last_name': lastName,
        'updated_at': DateTime.now().toIso8601String(),
      };
      
      if (dateOfBirth != null) {
        updateData['date_of_birth'] = dateOfBirth.toIso8601String();
      }
      
      if (memberColor != null) {
        updateData['member_color'] = memberColor;
      }
      
      await _client
          .from(_profilesTable)
          .update(updateData)
          .eq('id', userId);
      
      final updatedUser = await getUserById(userId);
      if (updatedUser == null) {
        throw Exception('Failed to fetch updated user');
      }
      
      return updatedUser;
    } catch (e) {
      debugPrint('Error updating user profile: $e');
      throw Exception('Failed to update profile: $e');
    }
  }

  @override
  Future<AppUserModel> updateUserContact({
    required String userId,
    String? email,
    String? phoneNumber,
  }) async {
    try {
      final Map<String, dynamic> updateData = {
        'updated_at': DateTime.now().toIso8601String(),
      };
      
      if (email != null && email.isNotEmpty) {
        // Update email in auth
        await _client.auth.updateUser(UserAttributes(email: email));
        updateData['email'] = email;
      }
      
      if (phoneNumber != null) {
        updateData['phone'] = phoneNumber;
      }
      
      await _client
          .from(_profilesTable)
          .update(updateData)
          .eq('id', userId);
      
      final updatedUser = await getUserById(userId);
      if (updatedUser == null) {
        throw Exception('Failed to fetch updated user');
      }
      
      return updatedUser;
    } catch (e) {
      debugPrint('Error updating user contact: $e');
      throw Exception('Failed to update contact: $e');
    }
  }

  @override
  Future<String> uploadProfileImage({
    required String userId,
    required File imageFile,
  }) async {
    try {
      final fileExt = path.extension(imageFile.path);
      final fileName = '${const Uuid().v4()}$fileExt';
      final filePath = 'avatars/$userId/$fileName';
      
      // Upload the file
      await _client.storage
          .from('user_content')
          .upload(filePath, imageFile);
      
      // Get public URL
      final imageUrl = _client.storage
          .from('user_content')
          .getPublicUrl(filePath);
      
      // Update user profile
      await _client
          .from(_profilesTable)
          .update({
            'avatar_url': imageUrl,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);
      
      return imageUrl;
    } catch (e) {
      debugPrint('Error uploading profile image: $e');
      throw Exception('Failed to upload profile image: $e');
    }
  }

  @override
  Future<void> updateUserPassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } catch (e) {
      debugPrint('Error updating password: $e');
      throw Exception('Failed to update password: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getUserSubscription(String userId) async {
    try {
      final subscriptions = await _client
          .from(_subscriptionsTable)
          .select()
          .eq('profile_id', userId)
          .order('created_at', ascending: false)
          .limit(1);
      
      if (subscriptions.isEmpty) {
        return {};
      }
      
      return Map<String, dynamic>.from(subscriptions.first);
    } catch (e) {
      debugPrint('Error fetching subscription: $e');
      return {};
    }
  }

  @override
  Future<bool> isPremiumUser(String userId) async {
    try {
      final subscriptionInfo = await getUserSubscription(userId);
      return subscriptionInfo.isNotEmpty && 
             subscriptionInfo['status'] == 'active' &&
             (subscriptionInfo['end_date'] == null || 
              DateTime.parse(subscriptionInfo['end_date']).isAfter(DateTime.now()));
    } catch (e) {
      debugPrint('Error checking premium status: $e');
      return false;
    }
  }

  @override
  Future<List<AppUserModel>> getFamilyMembers(String userId) async {
    try {
      // First get user's subscription to see if they have a family plan
      final subscriptionInfo = await getUserSubscription(userId);
      
      if (subscriptionInfo.isEmpty || subscriptionInfo['is_family'] != true) {
        return [];
      }
      
      final String familyId = subscriptionInfo['family_id'] ?? userId;
      
      // Get all users in the family
      final familyUsers = await _client
          .from(_profilesTable)
          .select()
          .eq('family_id', familyId);
      
      return familyUsers
          .map((userData) => AppUserModel.fromJson(userData))
          .toList();
    } catch (e) {
      debugPrint('Error fetching family members: $e');
      return [];
    }
  }

  @override
  Future<bool> inviteFamilyMember(String email) async {
    try {
      final currentUser = await getCurrentUser();
      if (currentUser == null) {
        return false;
      }

      // Check if user has a family subscription
      final subscriptionInfo = await getUserSubscription(currentUser.id);
      if (subscriptionInfo.isEmpty || subscriptionInfo['is_family'] != true) {
        return false;
      }

      final String familyId = subscriptionInfo['family_id'] ?? currentUser.id;

      // Create invitation
      await _client.from(_invitationsTable).insert({
        'family_id': familyId,
        'inviter_id': currentUser.id,
        'email': email,
        'status': 'pending',
        'created_at': DateTime.now().toIso8601String(),
      });

      return true;
    } catch (e) {
      debugPrint('Error inviting family member: $e');
      return false;
    }
  }

  @override
  Future<List<FamilyInvitationModel>> getFamilyInvitations() async {
    try {
      final currentUser = await getCurrentUser();
      if (currentUser == null || currentUser.email == null) {
        return [];
      }

      final invitations = await _client
          .from(_invitationsTable)
          .select()
          .eq('email', currentUser.email!)
          .eq('status', 'pending');

      return invitations
          .map((data) => FamilyInvitationModel.fromJson(data))
          .toList();
    } catch (e) {
      debugPrint('Error fetching family invitations: $e');
      return [];
    }
  }

  @override
  Future<bool> acceptFamilyInvitation(String invitationId) async {
    try {
      final currentUser = await getCurrentUser();
      if (currentUser == null) {
        return false;
      }

      // Get the invitation
      final invitation = await _client
          .from(_invitationsTable)
          .select()
          .eq('id', invitationId)
          .single();

      // Update invitation status
      await _client
          .from(_invitationsTable)
          .update({'status': 'accepted'})
          .eq('id', invitationId);

      // Update user's family_id
      await _client
          .from(_profilesTable)
          .update({
            'family_id': invitation['family_id'],
            'family_role': 'member',
          })
          .eq('id', currentUser.id);

      return true;
    } catch (e) {
      debugPrint('Error accepting family invitation: $e');
      return false;
    }
  }

  @override
  Future<bool> declineFamilyInvitation(String invitationId) async {
    try {
      await _client
          .from(_invitationsTable)
          .update({'status': 'declined'})
          .eq('id', invitationId);

      return true;
    } catch (e) {
      debugPrint('Error declining family invitation: $e');
      return false;
    }
  }

  @override
  Future<bool> removeFamilyMember(String memberId) async {
    try {
      final currentUser = await getCurrentUser();
      if (currentUser == null || !currentUser.isFamilyOwner) {
        return false;
      }

      await _client
          .from(_profilesTable)
          .update({
            'family_id': null,
            'family_role': null,
          })
          .eq('id', memberId);

      return true;
    } catch (e) {
      debugPrint('Error removing family member: $e');
      return false;
    }
  }

  @override
  Future<bool> leaveFamilyGroup() async {
    try {
      final currentUser = await getCurrentUser();
      if (currentUser == null || currentUser.isFamilyOwner) {
        return false; // Owner can't leave, they must transfer ownership first
      }

      await _client
          .from(_profilesTable)
          .update({
            'family_id': null,
            'family_role': null,
          })
          .eq('id', currentUser.id);

      return true;
    } catch (e) {
      debugPrint('Error leaving family group: $e');
      return false;
    }
  }
} 