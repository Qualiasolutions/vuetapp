import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/family_entities.dart'; // Actual FamilyMember model
import 'package:vuet_app/models/entity_model.dart'; // BaseEntityModel and EntitySubtype
import 'package:vuet_app/providers/entity_providers.dart' as entity_provider_file; // Access to entityServiceProvider and entitiesByCategoryProvider
import 'package:vuet_app/services/entity_service.dart'; // Access to EntityService for CRUD
import 'package:vuet_app/providers/auth_providers.dart'; // To get current user ID

const int familyAppCategoryId = 1;

// Helper function to map BaseEntityModel to FamilyMember
FamilyMember _familyMemberFromBaseEntity(BaseEntityModel baseEntity) {
  final customFields = baseEntity.customFields ?? {};
  DateTime? dob;
  if (customFields['dateOfBirth'] is String) {
    dob = DateTime.tryParse(customFields['dateOfBirth']);
  } else if (customFields['dateOfBirth'] is DateTime) {
    dob = customFields['dateOfBirth'];
  }

  return FamilyMember(
    id: int.tryParse(baseEntity.id ?? ''), // Assuming entity table ID is string, FamilyMember ID is int
    firstName: customFields['firstName'] as String? ?? baseEntity.name.split(' ').first,
    lastName: customFields['lastName'] as String? ?? (baseEntity.name.split(' ').length > 1 ? baseEntity.name.split(' ').sublist(1).join(' ') : ''),
    relationship: customFields['relationship'] as String?,
    dateOfBirth: dob,
    phoneNumber: customFields['phoneNumber'] as String?,
    email: customFields['email'] as String?,
    notes: baseEntity.description,
    // resourceType is defaulted in FamilyMember model
  );
}

// Helper function to map FamilyMember to BaseEntityModel data for saving
BaseEntityModel _familyMemberToBaseEntityData(FamilyMember familyMember, String userId) {
  return BaseEntityModel(
    id: familyMember.id?.toString(), // Convert int to String for BaseEntityModel
    name: '${familyMember.firstName} ${familyMember.lastName}'.trim(),
    description: familyMember.notes,
    userId: userId,
    appCategoryId: familyAppCategoryId,
    subtype: EntitySubtype.familyMember,
    createdAt: DateTime.now(), // Will be set by DB on creation, but good for initial model
    updatedAt: DateTime.now(),
    customFields: {
      'firstName': familyMember.firstName,
      'lastName': familyMember.lastName,
      if (familyMember.relationship != null) 'relationship': familyMember.relationship,
      if (familyMember.dateOfBirth != null) 'dateOfBirth': familyMember.dateOfBirth!.toIso8601String(),
      if (familyMember.phoneNumber != null) 'phoneNumber': familyMember.phoneNumber,
      if (familyMember.email != null) 'email': familyMember.email,
    },
  );
}

// Provider to get all family members
final familyMembersProvider = FutureProvider<List<FamilyMember>>((ref) async {
  final baseEntities = await ref.watch(entity_provider_file.entitiesByCategoryProvider(familyAppCategoryId).future);
  return baseEntities
      .where((entity) => entity.subtype == EntitySubtype.familyMember)
      .map(_familyMemberFromBaseEntity)
      .toList();
});

// Provider to get a single family member by its (BaseEntityModel) string ID
final familyMemberByIdProvider = FutureProvider.family<FamilyMember?, String>((ref, entityId) async {
  final baseEntity = await ref.watch(entity_provider_file.entityByIdProvider(entityId).future);
  if (baseEntity != null && baseEntity.subtype == EntitySubtype.familyMember) {
    return _familyMemberFromBaseEntity(baseEntity);
  }
  return null;
});


// Provider for FamilyMember specific service/actions
final familyMemberServiceProvider = Provider((ref) {
  final entityService = ref.watch(entity_provider_file.entityServiceProvider);
  final currentUser = ref.watch(currentUserProvider); // Changed from authProvider to currentUserProvider
  
  return FamilyMemberService(entityService, currentUser?.id); // Used currentUser.id
});

class FamilyMemberService {
  final EntityService _entityService;
  final String? _userId;

  FamilyMemberService(this._entityService, this._userId);

  Future<FamilyMember> addFamilyMember(FamilyMember member) async {
    if (_userId == null) throw Exception('User not authenticated');
    final baseEntityData = _familyMemberToBaseEntityData(member, _userId!);
    final createdBaseEntity = await _entityService.createEntity(baseEntityData);
    // Assuming createEntity returns the full entity with generated ID
    return _familyMemberFromBaseEntity(createdBaseEntity);
  }

  Future<FamilyMember> updateFamilyMember(FamilyMember member) async {
    if (_userId == null) throw Exception('User not authenticated');
    if (member.id == null) throw Exception('FamilyMember ID is required for update');
    final baseEntityData = _familyMemberToBaseEntityData(member, _userId!);
    final updatedBaseEntity = await _entityService.updateEntity(baseEntityData);
    return _familyMemberFromBaseEntity(updatedBaseEntity);
  }

  Future<void> deleteFamilyMember(int memberId) async {
    if (_userId == null) throw Exception('User not authenticated');
    // The generic entity service expects a String ID.
    await _entityService.deleteEntity(memberId.toString());
  }
}

// It's often good practice to also have a stream provider if your UI needs to react to real-time changes.
// This would require the SupabaseEntityRepository or EntityService to expose a stream method.
// For now, we'll rely on manual refresh via the FutureProviders.
// Example:
// final familyMembersStreamProvider = StreamProvider<List<FamilyMember>>((ref) async* {
//   // Implementation would involve watching a stream from the repository/service
//   // and applying the same filtering and mapping logic.
//   // This is more complex and depends on the underlying repository's capabilities.
// });
