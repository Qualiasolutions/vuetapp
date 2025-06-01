import 'package:vuet_app/models/family_model.dart'; // Contains FamilyModel, FamilyMemberModel, FamilyRole
import 'package:vuet_app/models/family_invitation_model.dart';

abstract class FamilyRepository {
  Future<FamilyModel> createFamily({
    required String name,
    String? imageUrl,
    Map<String, dynamic>? settings,
  });

  Future<FamilyModel?> getFamilyById(String familyId);
  Future<FamilyModel?> getCurrentUserFamily();
  Future<FamilyModel> updateFamily(FamilyModel family);
  Future<bool> deleteFamily(String familyId);
  Future<String?> uploadFamilyImage(String familyId, String imagePath);
  Future<List<FamilyMemberModel>> getFamilyMembers(String familyId);
  Future<FamilyMemberModel?> getFamilyMember(String familyId, String userId);
  Future<FamilyMemberModel> updateFamilyMember(FamilyMemberModel member);
  Future<bool> removeFamilyMember(String familyId, String userId);
  Future<bool> leaveFamilyGroup();
  Future<bool> transferOwnership(String familyId, String newOwnerId);

  Future<FamilyInvitationModel> sendFamilyInvitation({
    required String email,
    required String familyId,
    String? message,
  });
  Future<List<FamilyInvitationModel>> getSentInvitations();
  Future<List<FamilyInvitationModel>> getReceivedInvitations();
  Future<bool> acceptFamilyInvitation(String invitationId);
  Future<bool> declineFamilyInvitation(String invitationId);
  Future<bool> cancelFamilyInvitation(String invitationId);
  Future<FamilyInvitationModel> resendFamilyInvitation(String invitationId);

  Future<bool> hasPermission(String familyId, String userId, String permission);
  Future<FamilyMemberModel?> getFamilyMemberByUserId(String userId);
  Future<List<FamilyModel>> getUserFamilies();
  Future<Map<String, dynamic>> getFamilyStats(String familyId);

  Stream<List<FamilyMemberModel>> watchFamilyMembers(String familyId);
  Stream<List<FamilyInvitationModel>> watchFamilyInvitations();
  Stream<FamilyModel?> watchFamily(String familyId);
}
