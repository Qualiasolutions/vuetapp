import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vuet_app/config/supabase_config.dart';
import 'package:vuet_app/models/app_user_model.dart';
import 'package:vuet_app/models/family_invitation_model.dart';
import 'package:vuet_app/repositories/user_repository.dart';
import 'package:vuet_app/repositories/base_supabase_repository.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

/// Supabase implementation of the UserRepository interface
class SupabaseUserRepository extends BaseSupabaseRepository implements UserRepository {
  final String _profilesTable = 'profiles';
  final String _subscriptionsTable = 'subscriptions';
  final String _invitationsTable = 'family_invitations';

  SupabaseUserRepository() : super(SupabaseConfig.client);

  @override
  Future<AppUserModel?> getCurrentUser() async {
    return executeQuery('getCurrentUser', () async {
      final currentUserId = client.auth.currentUser?.id;
      if (currentUserId == null) {
        return null;
      }

      return await getUserById(currentUserId);
    });
  }

  @override
  Future<AppUserModel?> getUserById(String userId) async {
    return executeQuery('getUserById', () async {
      final response = await from(_profilesTable)
          .select()
          .eq('id', userId)
          .maybeSingle();

      debugPrint('Supabase raw response for user $userId: $response');

      if (response == null) {
        return null;
      }
      
      Map<String, dynamic> rawUserData = Map<String, dynamic>.from(response);
      Map<String, dynamic> userData = {};
      
      String? getString(dynamic value) {
        if (value is String) return value;
        if (value == null) return null;
        debugPrint('Warning: Expected String or null, got \${value.runtimeType} for value: \$value. Returning null.');
        return null; 
      }

      userData['id'] = getString(rawUserData['id']) ?? userId;
      userData['first_name'] = getString(rawUserData['first_name']);
      userData['last_name'] = getString(rawUserData['last_name']);
      userData['email'] = getString(rawUserData['email']);
      userData['phone'] = getString(rawUserData['phone']);
      userData['avatar_url'] = getString(rawUserData['avatar_url']);
      userData['professional_email'] = getString(rawUserData['professional_email']);
      userData['professional_phone'] = getString(rawUserData['professional_phone']);
      userData['account_type'] = getString(rawUserData['account_type']) ?? 'personal';
      userData['subscription_status'] = getString(rawUserData['subscription_status']) ?? 'free';
      userData['member_color'] = getString(rawUserData['member_color']) ?? '#0066cc';
      userData['family_id'] = getString(rawUserData['family_id']);
      userData['family_role'] = getString(rawUserData['family_role']);

      userData['created_at'] = getString(rawUserData['created_at']);
      if (userData['created_at'] == null) {
         debugPrint("Warning: 'created_at' was null or invalid. Defaulting. Value: \${rawUserData['created_at']}");
        userData['created_at'] = DateTime.now().toIso8601String();
      }
      
      userData['updated_at'] = getString(rawUserData['updated_at']);
      if (userData['updated_at'] == null) {
        debugPrint("Warning: 'updated_at' was null or invalid. Defaulting. Value: \${rawUserData['updated_at']}");
        userData['updated_at'] = DateTime.now().toIso8601String();
      }

      if (rawUserData['onboarding_completed'] is bool) {
        userData['onboarding_completed'] = rawUserData['onboarding_completed'];
      } else {
        debugPrint("Warning: 'onboarding_completed' was not a bool. Defaulting to false. Value: \${rawUserData['onboarding_completed']}");
        userData['onboarding_completed'] = false; 
      }

      userData['date_of_birth'] = getString(rawUserData['date_of_birth']);

      debugPrint('DEBUG: Filtered UserData map before AppUserModel.fromJson call:');
      userData.forEach((key, value) {
        debugPrint('  DEBUG: Key: "$key", Value: "$value", Type: "\${value.runtimeType}"');
      });
      
      try {
        return AppUserModel.fromJson(userData);
      } catch (e, s) {
        debugPrint('Error during AppUserModel.fromJson: $e\n$s');
        debugPrint('Data that caused error in fromJson: $userData');
        rethrow;
      }
    });
  }

  @override
  Future<AppUserModel> updateUserProfile({
    required String userId,
    required String firstName,
    required String lastName,
    DateTime? dateOfBirth,
    String? memberColor,
  }) async {
    return executeQuery('updateUserProfile', () async {
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

      await from(_profilesTable).update(updateData).eq('id', userId);

      final updatedUser = await getUserById(userId);
      if (updatedUser == null) {
        throw Exception('Failed to fetch updated user');
      }

      return updatedUser;
    });
  }

  @override
  Future<AppUserModel> updateUserContact({
    required String userId,
    String? email,
    String? phoneNumber,
  }) async {
    return executeQuery('updateUserContact', () async {
      final Map<String, dynamic> updateData = {
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (email != null && email.isNotEmpty) {
        // Update email in auth
        await client.auth.updateUser(UserAttributes(email: email));
        updateData['email'] = email;
      }

      if (phoneNumber != null) {
        updateData['phone'] = phoneNumber;
      }

      await from(_profilesTable).update(updateData).eq('id', userId);

      final updatedUser = await getUserById(userId);
      if (updatedUser == null) {
        throw Exception('Failed to fetch updated user');
      }

      return updatedUser;
    });
  }

  @override
  Future<String> uploadProfileImage({
    required String userId,
    required File imageFile,
  }) async {
    return executeQuery('uploadProfileImage', () async {
      final fileExt = path.extension(imageFile.path);
      final fileName = '${const Uuid().v4()}$fileExt';
      final filePath = 'avatars/$userId/$fileName';

      // Upload the file
      await client.storage.from('user_content').upload(filePath, imageFile);

      // Get public URL
      final imageUrl =
          client.storage.from('user_content').getPublicUrl(filePath);

      // Update user profile
      await from(_profilesTable).update({
        'avatar_url': imageUrl,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', userId);

      return imageUrl;
    });
  }

  @override
  Future<void> updateUserPassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    return executeQuery('updateUserPassword', () async {
      await client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    });
  }

  @override
  Future<Map<String, dynamic>> getUserSubscription(String userId) async {
    return executeQuery('getUserSubscription', () async {
      final subscriptions = await from(_subscriptionsTable)
          .select()
          .eq('profile_id', userId)
          .order('created_at', ascending: false)
          .limit(1);

      if (subscriptions.isEmpty) {
        return {};
      }

      return Map<String, dynamic>.from(subscriptions.first);
    });
  }

  @override
  Future<bool> isPremiumUser(String userId) async {
    return executeQuery('isPremiumUser', () async {
      final subscriptionInfo = await getUserSubscription(userId);
      return subscriptionInfo.isNotEmpty &&
          subscriptionInfo['status'] == 'active' &&
          (subscriptionInfo['end_date'] == null ||
              DateTime.parse(subscriptionInfo['end_date'])
                  .isAfter(DateTime.now()));
    });
  }

  @override
  Future<List<AppUserModel>> getFamilyMembers(String userId) async {
    return executeQuery('getFamilyMembers', () async {
      // First get user's subscription to see if they have a family plan
      final subscriptionInfo = await getUserSubscription(userId);

      if (subscriptionInfo.isEmpty || subscriptionInfo['is_family'] != true) {
        return [];
      }

      final String familyId = subscriptionInfo['family_id'] ?? userId;

      // Get all users in the family
      final familyUsers =
          await from(_profilesTable).select().eq('family_id', familyId);

      return familyUsers
          .map((userData) => AppUserModel.fromJson(userData))
          .toList();
    });
  }

  @override
  Future<bool> inviteFamilyMember(String email) async {
    return executeQuery('inviteFamilyMember', () async {
      final currentUser = await getCurrentUser();
      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      // Check if user has family subscription
      final subscriptionInfo = await getUserSubscription(currentUser.id);
      if (subscriptionInfo.isEmpty || subscriptionInfo['is_family'] != true) {
        throw Exception('No family subscription');
      }

      final String familyId = subscriptionInfo['family_id'] ?? currentUser.id;

      // Check if already part of family
      final existingUser = await from(_profilesTable)
          .select('id')
          .eq('email', email)
          .eq('family_id', familyId)
          .maybeSingle();

      if (existingUser != null) {
        throw Exception('User already in family');
      }

      // Create invitation
      final invitation = {
        'id': const Uuid().v4(),
        'inviter_id': currentUser.id,
        'invitee_email': email,
        'family_id': familyId,
        'created_at': DateTime.now().toIso8601String(),
        'expires_at':
            DateTime.now().add(const Duration(days: 7)).toIso8601String(),
        'status': 'pending'
      };

      await from(_invitationsTable).insert(invitation);
      return true;
    });
  }

  Future<List<FamilyInvitationModel>> getSentInvitations() async {
    return executeQuery('getSentInvitations', () async {
      final currentUser = await getCurrentUser();
      if (currentUser == null) {
        return [];
      }

      final invitations = await from(_invitationsTable)
          .select()
          .eq('inviter_id', currentUser.id)
          .order('created_at', ascending: false);

      return invitations
          .map((data) => FamilyInvitationModel.fromJson(data))
          .toList();
    });
  }

  Future<bool> cancelInvitation(String invitationId) async {
    return executeQuery('cancelInvitation', () async {
      final currentUser = await getCurrentUser();
      if (currentUser == null) {
        return false;
      }

      await from(_invitationsTable)
          .delete()
          .match({'id': invitationId, 'inviter_id': currentUser.id});

      return true;
    });
  }

  @override
  Future<bool> acceptFamilyInvitation(String invitationId) async {
    return executeQuery('acceptFamilyInvitation', () async {
      final currentUser = client.auth.currentUser;
      if (currentUser == null) {
        return false;
      }

      // Get the invitation
      final invitation = await from(_invitationsTable)
          .select()
          .eq('id', invitationId)
          .single();

      if (invitation['status'] != 'pending' ||
          DateTime.parse(invitation['expires_at']).isBefore(DateTime.now())) {
        return false;
      }

      // Update invitation status
      await from(_invitationsTable)
          .update({'status': 'accepted'}).eq('id', invitationId);

      // Update user's family_id
      await from(_profilesTable).update({
        'family_id': invitation['family_id'],
        'family_role': 'member',
        'updated_at': DateTime.now().toIso8601String()
      }).eq('id', currentUser.id);

      return true;
    });
  }

  @override
  Future<bool> removeFamilyMember(String memberId) async {
    return executeQuery('removeFamilyMember', () async {
      final currentUser = await getCurrentUser();
      if (currentUser == null) {
        return false;
      }

      // Check if user is family owner
      final subscriptionInfo = await getUserSubscription(currentUser.id);
      if (subscriptionInfo.isEmpty ||
          subscriptionInfo['family_owner'] != currentUser.id) {
        return false;
      }

      // Update user profile to remove family_id
      await from(_profilesTable).update({
        'family_id': null,
        'family_role': null,
        'updated_at': DateTime.now().toIso8601String()
      }).eq('id', memberId);

      return true;
    });
  }

  @override
  Future<bool> leaveFamilyGroup() async {
    return executeQuery('leaveFamilyGroup', () async {
      final currentUser = client.auth.currentUser;
      if (currentUser == null) {
        return false;
      }

      // Check if user is NOT the family owner
      final subscriptionInfo = await getUserSubscription(currentUser.id);
      if (subscriptionInfo.isNotEmpty &&
          subscriptionInfo['family_owner'] == currentUser.id) {
        return false; // Can't leave if you're the owner
      }

      // Update user profile to remove family_id
      await from(_profilesTable).update({
        'family_id': null,
        'family_role': null,
        'updated_at': DateTime.now().toIso8601String()
      }).eq('id', currentUser.id);

      return true;
    });
  }

  Future<String?> getFamilyOwner() async {
    return executeQuery('getFamilyOwner', () async {
      final currentUser = await getCurrentUser();
      if (currentUser == null) {
        return null;
      }

      final subscriptionInfo = await getUserSubscription(currentUser.id);
      if (subscriptionInfo.isEmpty || subscriptionInfo['is_family'] != true) {
        return null;
      }

      return subscriptionInfo['family_owner'];
    });
  }

  @override
  Future<List<FamilyInvitationModel>> getFamilyInvitations() async {
    return executeQuery('getFamilyInvitations', () async {
      final currentUser = await getCurrentUser();
      if (currentUser == null || currentUser.email == null) {
        return [];
      }

      final invitations = await from(_invitationsTable)
          .select()
          .eq('invitee_email', currentUser.email!)
          .eq('status', 'pending');

      return invitations
          .map((data) => FamilyInvitationModel.fromJson(data))
          .toList();
    });
  }

  @override
  Future<bool> declineFamilyInvitation(String invitationId) async {
    return executeQuery('declineFamilyInvitation', () async {
      await from(_invitationsTable)
          .update({'status': 'declined'}).eq('id', invitationId);

      return true;
    });
  }
}
