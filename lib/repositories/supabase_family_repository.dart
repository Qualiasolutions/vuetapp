import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vuet_app/config/supabase_config.dart';
import 'package:vuet_app/models/family_model.dart'; // Contains FamilyModel, FamilyMemberModel, FamilyRole
import 'package:vuet_app/models/family_invitation_model.dart';
import 'package:vuet_app/repositories/family_repository.dart';
import 'package:vuet_app/services/realtime_subscription_manager.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;
import 'package:vuet_app/repositories/family_constants.dart';

/// Supabase implementation of the FamilyRepository interface
class SupabaseFamilyRepository implements FamilyRepository {
  final SupabaseClient _client;
  final RealtimeSubscriptionManager _subscriptionManager;

  // Table names
  final String _familiesTable = 'families';
  final String _profilesTable = 'profiles';
  final String _familyMembersTable = 'family_members';
  final String _familyInvitationsTable = 'family_invitations';

  /// Constructor
  SupabaseFamilyRepository({
    SupabaseClient? client,
    required RealtimeSubscriptionManager subscriptionManager,
  })  : _client = client ?? SupabaseConfig.client,
        _subscriptionManager = subscriptionManager;

  // Helper method to get current user ID
  String? get _currentUserId => _client.auth.currentUser?.id;

  @override
  Future<FamilyModel> createFamily({
    required String name,
    String? imageUrl,
    Map<String, dynamic>? settings,
  }) async {
    try {
      final userId = _currentUserId;
      if (userId == null) {
        throw const FamilyException(
            'User not authenticated', FamilyErrorCodes.networkError);
      }

      // Create family record
      final familyData = {
        'id': const Uuid().v4(),
        'name': name,
        'image_url': imageUrl,
        'owner_id': userId,
        'settings': settings ?? {},
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      final familyResult = await _client
          .from(_familiesTable)
          .insert(familyData)
          .select()
          .single();

      // Create family member record for the owner
      final memberData = {
        'id': const Uuid().v4(),
        'user_id': userId,
        'family_id': familyResult['id'],
        'role': 'owner',
        'member_color': '#0066cc',
        'joined_at': DateTime.now().toIso8601String(),
        'is_active': true,
      };

      await _client.from(_familyMembersTable).insert(memberData);

      // Update user's profile with family info
      await _client.from(_profilesTable).update({
        'family_id': familyResult['id'],
        'family_role': 'owner',
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', userId);

      return FamilyModel.fromJson(familyResult);
    } catch (e) {
      debugPrint('Error creating family: $e');
      throw FamilyException(
          'Failed to create family', FamilyErrorCodes.unknownError, e);
    }
  }

  @override
  Future<FamilyModel?> getFamilyById(String familyId) async {
    try {
      final result = await _client
          .from(_familiesTable)
          .select()
          .eq('id', familyId)
          .maybeSingle();

      if (result == null) {
        return null;
      }

      // Get family members
      final members = await getFamilyMembers(familyId);

      return FamilyModel.fromJson({
        ...result,
        'members': members.map((m) => m.toJson()).toList(),
      });
    } catch (e) {
      debugPrint('Error fetching family by ID: $e');
      return null;
    }
  }

  @override
  Future<FamilyModel?> getCurrentUserFamily() async {
    try {
      final userId = _currentUserId;
      if (userId == null) return null;

      // Get user's profile to find family_id
      final profile = await _client
          .from(_profilesTable)
          .select('family_id')
          .eq('id', userId)
          .maybeSingle();

      if (profile?['family_id'] == null) {
        return null;
      }

      return await getFamilyById(profile!['family_id']);
    } catch (e) {
      debugPrint('Error fetching current user family: $e');
      return null;
    }
  }

  @override
  Future<FamilyModel> updateFamily(FamilyModel family) async {
    try {
      final userId = _currentUserId;
      if (userId == null) {
        throw const FamilyException(
            'User not authenticated', FamilyErrorCodes.networkError);
      }

      // Check if user has permission to update family
      if (!await hasPermission(
          family.id, userId, FamilyPermissions.modifySettings)) {
        throw const FamilyException('Insufficient permissions',
            FamilyErrorCodes.insufficientPermissions);
      }

      final updateData = {
        'name': family.name,
        'image_url': family.imageUrl,
        'settings': family.settings,
        'updated_at': DateTime.now().toIso8601String(),
      };

      final result = await _client
          .from(_familiesTable)
          .update(updateData)
          .eq('id', family.id)
          .select()
          .single();

      return FamilyModel.fromJson(result);
    } catch (e) {
      debugPrint('Error updating family: $e');
      throw FamilyException(
          'Failed to update family', FamilyErrorCodes.unknownError, e);
    }
  }

  @override
  Future<bool> deleteFamily(String familyId) async {
    try {
      final userId = _currentUserId;
      if (userId == null) return false;

      // Check if user is the owner
      if (!await hasPermission(
          familyId, userId, FamilyPermissions.dissolveFamily)) {
        return false;
      }

      // Remove all family members
      await _client
          .from(_familyMembersTable)
          .delete()
          .eq('family_id', familyId);

      // Update all users' profiles
      await _client.from(_profilesTable).update({
        'family_id': null,
        'family_role': null,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('family_id', familyId);

      // Delete family
      await _client.from(_familiesTable).delete().eq('id', familyId);

      return true;
    } catch (e) {
      debugPrint('Error deleting family: $e');
      return false;
    }
  }

  @override
  Future<String?> uploadFamilyImage(String familyId, String imagePath) async {
    try {
      final userId = _currentUserId;
      if (userId == null) return null;

      if (!await hasPermission(
          familyId, userId, FamilyPermissions.modifySettings)) {
        return null;
      }

      final file = File(imagePath);
      final fileExt = path.extension(imagePath);
      final fileName = '${const Uuid().v4()}$fileExt';
      final filePath = 'families/$familyId/$fileName';

      // Upload file
      await _client.storage.from('family_content').upload(filePath, file);

      // Get public URL
      final imageUrl =
          _client.storage.from('family_content').getPublicUrl(filePath);

      // Update family record
      await _client.from(_familiesTable).update({
        'image_url': imageUrl,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', familyId);

      return imageUrl;
    } catch (e) {
      debugPrint('Error uploading family image: $e');
      return null;
    }
  }

  @override
  Future<List<FamilyMemberModel>> getFamilyMembers(String familyId) async {
    try {
      final members = await _client
          .from(_familyMembersTable)
          .select('''
            *,
            profiles!inner(first_name, last_name, email, avatar_url)
          ''')
          .eq('family_id', familyId)
          .eq('is_active', true)
          .order('joined_at');

      return members.map((memberData) {
        final profile = memberData['profiles'] as Map<String, dynamic>?;
        return FamilyMemberModel.fromJson(_parseFamilyMemberJson(memberData, profile));
      }).toList();
    } catch (e) {
      debugPrint('Error fetching family members: $e');
      return [];
    }
  }

  @override
  Future<FamilyMemberModel?> getFamilyMember(
      String familyId, String userId) async {
    try {
      final member = await _client
          .from(_familyMembersTable)
          .select('''
            *,
            profiles!inner(first_name, last_name, email, avatar_url)
          ''')
          .eq('family_id', familyId)
          .eq('user_id', userId)
          .eq('is_active', true)
          .maybeSingle();

      if (member == null) return null;

      final profile = member['profiles'] as Map<String, dynamic>?;
      return FamilyMemberModel.fromJson(_parseFamilyMemberJson(member, profile));
    } catch (e) {
      debugPrint('Error fetching family member: $e');
      return null;
    }
  }

  @override
  Future<FamilyMemberModel> updateFamilyMember(FamilyMemberModel member) async {
    try {
      final userId = _currentUserId;
      if (userId == null) {
        throw const FamilyException(
            'User not authenticated', FamilyErrorCodes.networkError);
      }

      if (!await hasPermission(
          member.familyId, userId, FamilyPermissions.manageMembers)) {
        throw const FamilyException('Insufficient permissions',
            FamilyErrorCodes.insufficientPermissions);
      }

      final updateData = {
        'role': member.role.name,
        'member_color': member.memberColor,
        'is_active': member.isActive,
        'updated_at': DateTime.now().toIso8601String(),
      };

      final result = await _client
          .from(_familyMembersTable)
          .update(updateData)
          .eq('user_id', member.userId)
          .eq('family_id', member.familyId)
          .select()
          .single();

      // Also update profile table
      await _client.from(_profilesTable).update({
        'family_role': member.role.name,
        'member_color': member.memberColor,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', member.userId);

      return FamilyMemberModel.fromJson(result);
    } catch (e) {
      debugPrint('Error updating family member: $e');
      throw FamilyException(
          'Failed to update family member', FamilyErrorCodes.unknownError, e);
    }
  }

  @override
  Future<bool> removeFamilyMember(String familyId, String userId) async {
    try {
      final currentUserId = _currentUserId;
      if (currentUserId == null) return false;

      if (!await hasPermission(
          familyId, currentUserId, FamilyPermissions.manageMembers)) {
        return false;
      }

      // Cannot remove family owner
      final member = await getFamilyMember(familyId, userId);
      if (member?.role == FamilyRole.owner) {
        return false;
      }

      // Update family member record
      await _client
          .from(_familyMembersTable)
          .update({
            'is_active': false,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('family_id', familyId)
          .eq('user_id', userId);

      // Update user profile
      await _client.from(_profilesTable).update({
        'family_id': null,
        'family_role': null,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', userId);

      return true;
    } catch (e) {
      debugPrint('Error removing family member: $e');
      return false;
    }
  }

  @override
  Future<bool> leaveFamilyGroup() async {
    try {
      final userId = _currentUserId;
      if (userId == null) return false;

      // Get user's family
      final family = await getCurrentUserFamily();
      if (family == null) return false;

      // Cannot leave if you're the owner
      if (family.ownerId == userId) {
        return false;
      }

      return await removeFamilyMember(family.id, userId);
    } catch (e) {
      debugPrint('Error leaving family group: $e');
      return false;
    }
  }

  @override
  Future<bool> transferOwnership(String familyId, String newOwnerId) async {
    try {
      final userId = _currentUserId;
      if (userId == null) return false;

      if (!await hasPermission(
          familyId, userId, FamilyPermissions.transferOwnership)) {
        return false;
      }

      // Update family ownership
      await _client.from(_familiesTable).update({
        'owner_id': newOwnerId,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', familyId);

      // Update current owner to admin
      await _client
          .from(_familyMembersTable)
          .update({
            'role': 'admin',
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('family_id', familyId)
          .eq('user_id', userId);

      // Update new owner
      await _client
          .from(_familyMembersTable)
          .update({
            'role': 'owner',
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('family_id', familyId)
          .eq('user_id', newOwnerId);

      // Update profiles
      await _client
          .from(_profilesTable)
          .update({'family_role': 'admin'}).eq('id', userId);

      await _client
          .from(_profilesTable)
          .update({'family_role': 'owner'}).eq('id', newOwnerId);

      return true;
    } catch (e) {
      debugPrint('Error transferring ownership: $e');
      return false;
    }
  }

  @override
  Future<FamilyInvitationModel> sendFamilyInvitation({
    required String email,
    required String familyId,
    String? message,
  }) async {
    try {
      final userId = _currentUserId;
      if (userId == null) {
        throw const FamilyException(
            'User not authenticated', FamilyErrorCodes.networkError);
      }

      if (!await hasPermission(
          familyId, userId, FamilyPermissions.inviteMembers)) {
        throw const FamilyException('Insufficient permissions',
            FamilyErrorCodes.insufficientPermissions);
      }

      // Check if user already exists and is in family
      final existingUser = await _client
          .from(_profilesTable)
          .select('id, family_id')
          .eq('email', email)
          .maybeSingle();

      if (existingUser?['family_id'] == familyId) {
        throw const FamilyException(
            'User already in family', FamilyErrorCodes.userAlreadyInFamily);
      }

      // Check family member limit
      final members = await getFamilyMembers(familyId);
      if (members.length >= 6) {
        throw const FamilyException(
            'Family member limit reached', FamilyErrorCodes.memberLimitReached);
      }

      // Create invitation
      final invitationData = {
        'id': const Uuid().v4(),
        'inviter_id': userId,
        'invitee_email': email,
        'family_id': familyId,
        'message': message,
        'created_at': DateTime.now().toIso8601String(),
        'expires_at':
            DateTime.now().add(const Duration(days: 7)).toIso8601String(),
        'status': 'pending',
      };

      final result = await _client
          .from(_familyInvitationsTable)
          .insert(invitationData)
          .select()
          .single();

      return FamilyInvitationModel.fromJson(result);
    } catch (e) {
      debugPrint('Error sending family invitation: $e');
      if (e is FamilyException) rethrow;
      throw FamilyException(
          'Failed to send invitation', FamilyErrorCodes.unknownError, e);
    }
  }

  @override
  Future<List<FamilyInvitationModel>> getSentInvitations() async {
    try {
      final userId = _currentUserId;
      if (userId == null) return [];

      final invitations = await _client.from(_familyInvitationsTable).select('''
            *,
            families!inner(name, image_url)
          ''').eq('inviter_id', userId).order('created_at', ascending: false);

      return invitations.map((data) {
        final family = data['families'];
        return FamilyInvitationModel.fromJson({
          ...data,
          'family_name': family['name'],
          'family_image_url': family['image_url'],
        });
      }).toList();
    } catch (e) {
      debugPrint('Error fetching sent invitations: $e');
      return [];
    }
  }

  @override
  Future<List<FamilyInvitationModel>> getReceivedInvitations() async {
    try {
      final user = _client.auth.currentUser;
      if (user?.email == null) return [];

      final invitations = await _client
          .from(_familyInvitationsTable)
          .select('''
            *,
            families!inner(name, image_url),
            profiles!inner(first_name, last_name, email)
          ''')
          .eq('invitee_email', user!.email!)
          .eq('status', 'pending')
          .order('created_at', ascending: false);

      return invitations.map((data) {
        final family = data['families'];
        final inviter = data['profiles'];
        return FamilyInvitationModel.fromJson({
          ...data,
          'family_name': family['name'],
          'family_image_url': family['image_url'],
          'inviter_name': '${inviter['first_name']} ${inviter['last_name']}',
          'inviter_email': inviter['email'],
        });
      }).toList();
    } catch (e) {
      debugPrint('Error fetching received invitations: $e');
      return [];
    }
  }

  @override
  Future<bool> acceptFamilyInvitation(String invitationId) async {
    try {
      final userId = _currentUserId;
      if (userId == null) return false;

      // Get invitation details
      final invitation = await _client
          .from(_familyInvitationsTable)
          .select()
          .eq('id', invitationId)
          .single();

      if (invitation['status'] != 'pending' ||
          DateTime.parse(invitation['expires_at']).isBefore(DateTime.now())) {
        return false;
      }

      // Update invitation status
      await _client.from(_familyInvitationsTable).update({
        'status': 'accepted',
        'responded_at': DateTime.now().toIso8601String(),
      }).eq('id', invitationId);

      // Create family member record
      final memberData = {
        'id': const Uuid().v4(),
        'user_id': userId,
        'family_id': invitation['family_id'],
        'role': 'member',
        'member_color':
            '#${(DateTime.now().millisecondsSinceEpoch % 0xFFFFFF).toRadixString(16).padLeft(6, '0')}',
        'joined_at': DateTime.now().toIso8601String(),
        'is_active': true,
      };

      await _client.from(_familyMembersTable).insert(memberData);

      // Update user profile
      await _client.from(_profilesTable).update({
        'family_id': invitation['family_id'],
        'family_role': 'member',
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', userId);

      return true;
    } catch (e) {
      debugPrint('Error accepting family invitation: $e');
      return false;
    }
  }

  @override
  Future<bool> declineFamilyInvitation(String invitationId) async {
    try {
      await _client.from(_familyInvitationsTable).update({
        'status': 'declined',
        'responded_at': DateTime.now().toIso8601String(),
      }).eq('id', invitationId);

      return true;
    } catch (e) {
      debugPrint('Error declining family invitation: $e');
      return false;
    }
  }

  @override
  Future<bool> cancelFamilyInvitation(String invitationId) async {
    try {
      final userId = _currentUserId;
      if (userId == null) return false;

      await _client
          .from(_familyInvitationsTable)
          .update({
            'status': 'cancelled',
            'responded_at': DateTime.now().toIso8601String(),
          })
          .eq('id', invitationId)
          .eq('inviter_id', userId);

      return true;
    } catch (e) {
      debugPrint('Error canceling family invitation: $e');
      return false;
    }
  }

  @override
  Future<FamilyInvitationModel> resendFamilyInvitation(
      String invitationId) async {
    try {
      // Get original invitation
      final original = await _client
          .from(_familyInvitationsTable)
          .select()
          .eq('id', invitationId)
          .single();

      // Create new invitation with extended expiry
      final newInvitationData = {
        'id': const Uuid().v4(),
        'inviter_id': original['inviter_id'],
        'invitee_email': original['invitee_email'],
        'family_id': original['family_id'],
        'message': original['message'],
        'created_at': DateTime.now().toIso8601String(),
        'expires_at':
            DateTime.now().add(const Duration(days: 7)).toIso8601String(),
        'status': 'pending',
      };

      final result = await _client
          .from(_familyInvitationsTable)
          .insert(newInvitationData)
          .select()
          .single();

      // Cancel original invitation
      await cancelFamilyInvitation(invitationId);

      return FamilyInvitationModel.fromJson(result);
    } catch (e) {
      debugPrint('Error resending family invitation: $e');
      throw FamilyException(
          'Failed to resend invitation', FamilyErrorCodes.unknownError, e);
    }
  }

  @override
  Future<bool> hasPermission(
      String familyId, String userId, String permission) async {
    try {
      final member = await getFamilyMember(familyId, userId);
      if (member == null) return false;

      switch (permission) {
        case FamilyPermissions.dissolveFamily:
        case FamilyPermissions.transferOwnership:
        case FamilyPermissions.modifySettings:
          return member.role == FamilyRole.owner;

        case FamilyPermissions.manageMembers:
        case FamilyPermissions.inviteMembers:
        case FamilyPermissions.manageInvitations:
          return member.role.canManageMembers;

        case FamilyPermissions.viewMembers:
        case FamilyPermissions.assignTasks:
        case FamilyPermissions.manageSharedContent:
          return true; // All family members can do these

        default:
          return false;
      }
    } catch (e) {
      debugPrint('Error checking permission: $e');
      return false;
    }
  }

  @override
  Future<FamilyMemberModel?> getFamilyMemberByUserId(String userId) async {
    try {
      final profile = await _client
          .from(_profilesTable)
          .select('family_id')
          .eq('id', userId)
          .maybeSingle();

      if (profile?['family_id'] == null) return null;

      return await getFamilyMember(profile!['family_id'], userId);
    } catch (e) {
      debugPrint('Error fetching family member by user ID: $e');
      return null;
    }
  }

  @override
  Future<List<FamilyModel>> getUserFamilies() async {
    try {
      final userId = _currentUserId;
      if (userId == null) return [];

      final families = await _client.from(_familyMembersTable).select('''
            families!inner(*)
          ''').eq('user_id', userId).eq('is_active', true);

      return families
          .map((data) => FamilyModel.fromJson(data['families']))
          .toList();
    } catch (e) {
      debugPrint('Error fetching user families: $e');
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>> getFamilyStats(String familyId) async {
    try {
      final members = await getFamilyMembers(familyId);
      final invitations = await _client
          .from(_familyInvitationsTable)
          .select('id')
          .eq('family_id', familyId)
          .eq('status', 'pending');

      return {
        'total_members': members.length,
        'active_members': members.where((m) => m.isActive).length,
        'owners': members.where((m) => m.role == FamilyRole.owner).length,
        'admins': members.where((m) => m.role == FamilyRole.admin).length,
        'regular_members':
            members.where((m) => m.role == FamilyRole.member).length,
        'pending_invitations': invitations.length,
      };
    } catch (e) {
      debugPrint('Error fetching family stats: $e');
      return {};
    }
  }

  @override
  Stream<List<FamilyMemberModel>> watchFamilyMembers(String familyId) {
    // Use centralized subscription manager
    return _subscriptionManager
        .getTableStream(
      _familyMembersTable,
      filter: 'family_id',
      filterValue: familyId,
    )
        .asyncMap((dataList) async {
      final List<FamilyMemberModel> members = [];
      for (final itemData in dataList) {
        final memberData = itemData;
        if (memberData['is_active'] == true) {
          try {
            // The selectQuery in watchFamilyMembers should already join profiles if needed.
            // Assuming 'profiles' is part of itemData if the selectQuery is `*, profiles(*)`
            final profileData = memberData['profiles'] as Map<String, dynamic>?;
            members.add(FamilyMemberModel.fromJson(_parseFamilyMemberJson(memberData , profileData)));
          } catch (e) {
            debugPrint('Error processing member data in stream: $e for item $itemData');
            // Optionally skip this item or handle error
          }
        }
      }
      return members..sort((a, b) => a.joinedAt.compareTo(b.joinedAt));
    });
  }

  Map<String, dynamic> _parseFamilyMemberJson(Map<String, dynamic> memberData, Map<String, dynamic>? profileData) {
    final json = <String, dynamic>{};

    // From family_members table (memberData) - map to camelCase
    json['userId'] = memberData['user_id'] ?? 'unknown_user_id';
    json['familyId'] = memberData['family_id'] ?? 'unknown_family_id';
    
    final roleString = memberData['role'] as String?;
    json['role'] = FamilyRole.values.firstWhere(
        (e) => e.name == roleString,
        orElse: () => FamilyRole.member);

    json['memberColor'] = (memberData['member_color'] ?? '#0066cc') as String;
    
    try {
      // Ensure joined_at is a string before parsing
      final joinedAtString = memberData['joined_at'] as String?;
      json['joinedAt'] = joinedAtString != null
          ? DateTime.parse(joinedAtString).toIso8601String()
          : DateTime.now().toIso8601String();
    } catch (e) {
      debugPrint('Error parsing joinedAt for family member ${memberData['user_id']}: ${memberData['joined_at']}. Defaulting to now.');
      json['joinedAt'] = DateTime.now().toIso8601String();
    }
    json['isActive'] = (memberData['is_active'] ?? true) as bool;

    // From profiles table (profileData) - these are already camelCase in FamilyMemberModel
    json['firstName'] = profileData?['first_name'] as String?;
    json['lastName'] = profileData?['last_name'] as String?;
    json['email'] = profileData?['email'] as String?;
    // The profile table uses 'avatar_url', FamilyMemberModel uses 'profileImageUrl'
    json['profileImageUrl'] = profileData?['avatar_url'] as String?; 
    
    return json;
  }

  @override
  Stream<List<FamilyInvitationModel>> watchFamilyInvitations() {
    final userId = _currentUserId;
    if (userId == null) {
      return Stream.value([]);
    }

    // Use centralized subscription manager
    return _subscriptionManager
        .getTableStream(
          _familyInvitationsTable,
          filter: 'inviter_id',
          filterValue: userId,
        )
        .map((data) =>
            data.map((item) => FamilyInvitationModel.fromJson(item)).toList()
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt)));
  }

  @override
  Stream<FamilyModel?> watchFamily(String familyId) {
    // Use centralized subscription manager
    return _subscriptionManager
        .getTableStream(
      _familiesTable,
      filter: 'id',
      filterValue: familyId,
    )
        .asyncMap((data) async {
      final familyData = data.firstOrNull;
      if (familyData == null) return null;

      final members = await getFamilyMembers(familyId);

      return FamilyModel.fromJson({
        ...familyData,
        'members': members.map((m) => m.toJson()).toList(),
      });
    });
  }
}
