import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/family_entities.dart'; // Actual Birthday model
import 'package:vuet_app/models/entity_model.dart';    // BaseEntityModel and EntitySubtype
import 'package:vuet_app/providers/entity_providers.dart' as entity_provider_file; // Access to entityServiceProvider and entitiesByCategoryProvider
import 'package:vuet_app/services/entity_service.dart';    // Access to EntityService for CRUD
import 'package:vuet_app/providers/auth_providers.dart';    // To get current user ID

const int familyAppCategoryId = 1; // Birthdays in Family category

// Helper function to map BaseEntityModel to Birthday
Birthday _birthdayFromBaseEntity(BaseEntityModel baseEntity) {
  final customFields = baseEntity.customFields ?? {};
  DateTime? dob;

  // Try to get dob from customFields first, then from dueDate as a fallback
  if (customFields['dob'] is String) {
    dob = DateTime.tryParse(customFields['dob']);
  } else if (customFields['dob'] is DateTime) {
    dob = customFields['dob'];
  }
  dob ??= baseEntity.dueDate; // Fallback to dueDate if not in customFields

  if (dob == null) {
    // This case should ideally not happen if data is saved correctly.
    // Consider throwing an error or using a default date.
    // For now, let's use a placeholder or throw.
    // Using current date as a fallback, but this is not ideal.
    // Log a warning if this happens.
    print("Warning: DOB is null for Birthday entity ID: ${baseEntity.id}. Using current date as fallback.");
    dob = DateTime.now(); 
  }
  
  bool knownYear = true; // Default
  if (customFields['knownYear'] is bool) {
    knownYear = customFields['knownYear'];
  } else if (customFields['knownYear'] is String) {
    knownYear = (customFields['knownYear'] as String).toLowerCase() == 'true';
  }

  return Birthday(
    id: int.tryParse(baseEntity.id ?? ''), // Assuming entity table ID is string, Birthday ID is int
    name: baseEntity.name, // BaseEntityModel.name stores the person's name for the birthday
    dob: dob,
    knownYear: knownYear,
    notes: baseEntity.description,
    // resourceType is defaulted in Birthday model
  );
}

// Helper function to map Birthday to BaseEntityModel data for saving
BaseEntityModel _birthdayToBaseEntityData(Birthday birthday, String userId) {
  return BaseEntityModel(
    id: birthday.id?.toString(), // Convert int to String for BaseEntityModel
    name: birthday.name, // Person's name
    description: birthday.notes,
    userId: userId,
    appCategoryId: familyAppCategoryId, // Explicitly for Family category
    subtype: EntitySubtype.birthday, // Use the existing 'birthday' subtype
    createdAt: DateTime.now(), // Will be set by DB on creation
    updatedAt: DateTime.now(),
    dueDate: birthday.dob, // Store dob in dueDate for easier querying/sorting if needed
    customFields: {
      'dob': birthday.dob.toIso8601String(), // Also store in custom fields for clarity/backup
      'knownYear': birthday.knownYear,
      // Any other Birthday-specific fields can go here
    },
  );
}

// Provider to get all birthdays in the Family category
final familyBirthdaysProvider = FutureProvider<List<Birthday>>((ref) async {
  // Fetch all entities for Family Category (ID 1)
  final baseEntities = await ref.watch(entity_provider_file.entitiesByCategoryProvider(familyAppCategoryId).future);
  // Filter for those that are of subtype 'birthday'
  return baseEntities
      .where((entity) => entity.subtype == EntitySubtype.birthday)
      .map(_birthdayFromBaseEntity)
      .toList();
});

// Provider to get a single birthday by its (BaseEntityModel) string ID
final birthdayByIdProvider = FutureProvider.family<Birthday?, String>((ref, entityId) async {
  final baseEntity = await ref.watch(entity_provider_file.entityByIdProvider(entityId).future);
  if (baseEntity != null && baseEntity.subtype == EntitySubtype.birthday && baseEntity.appCategoryId == familyAppCategoryId) {
    return _birthdayFromBaseEntity(baseEntity);
  }
  return null; // Return null if not found, wrong subtype, or wrong category
});

// Provider for Birthday specific service/actions
final birthdayServiceProvider = Provider((ref) {
  final entityService = ref.watch(entity_provider_file.entityServiceProvider);
  final currentUser = ref.watch(currentUserProvider);
  
  return BirthdayService(entityService, currentUser?.id);
});

class BirthdayService {
  final EntityService _entityService;
  final String? _userId;

  BirthdayService(this._entityService, this._userId);

  Future<Birthday> addBirthday(Birthday birthday) async {
    if (_userId == null) throw Exception('User not authenticated');
    final baseEntityData = _birthdayToBaseEntityData(birthday, _userId!);
    final createdBaseEntity = await _entityService.createEntity(baseEntityData);
    return _birthdayFromBaseEntity(createdBaseEntity);
  }

  Future<Birthday> updateBirthday(Birthday birthday) async {
    if (_userId == null) throw Exception('User not authenticated');
    if (birthday.id == null) throw Exception('Birthday ID is required for update');
    final baseEntityData = _birthdayToBaseEntityData(birthday, _userId!);
    final updatedBaseEntity = await _entityService.updateEntity(baseEntityData);
    return _birthdayFromBaseEntity(updatedBaseEntity);
  }

  Future<void> deleteBirthday(int birthdayId) async {
    if (_userId == null) throw Exception('User not authenticated');
    await _entityService.deleteEntity(birthdayId.toString());
  }
}
