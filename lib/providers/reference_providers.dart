import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/reference_model.dart';
import 'package:vuet_app/models/reference_group_model.dart';
import 'package:vuet_app/repositories/supabase_reference_repository.dart';
import 'package:uuid/uuid.dart';

part 'reference_providers.g.dart';

/// Provider for all references
@riverpod
Future<List<ReferenceModel>> references(Ref ref) async {
  final repository = ref.watch(referenceRepositoryProvider);
  return repository.getAllReferences();
}

/// Provider for all reference groups
@riverpod
Future<List<ReferenceGroupModel>> referenceGroups(Ref ref) async {
  final repository = ref.watch(referenceRepositoryProvider);
  return repository.getAllReferenceGroups();
}

/// Provider for references by group ID
@riverpod
Future<List<ReferenceModel>> referencesByGroup(
  Ref ref,
  String groupId,
) async {
  final repository = ref.watch(referenceRepositoryProvider);
  return repository.getReferencesByGroupId(groupId);
}

/// Provider for references by entity ID
@riverpod
Future<List<ReferenceModel>> referencesByEntity(
  Ref ref,
  String entityId,
) async {
  final repository = ref.watch(referenceRepositoryProvider);
  return repository.getReferencesByEntityId(entityId);
}

/// Provider for a specific reference by ID
@riverpod
Future<ReferenceModel?> referenceById(
  Ref ref,
  String id,
) async {
  final repository = ref.watch(referenceRepositoryProvider);
  return repository.getReferenceById(id);
}

/// Provider for a specific reference group by ID
@riverpod
Future<ReferenceGroupModel?> referenceGroupById(
  Ref ref,
  String id,
) async {
  final repository = ref.watch(referenceRepositoryProvider);
  return repository.getReferenceGroupById(id);
}

/// Notifier for managing reference CRUD operations
@riverpod
class ReferenceNotifier extends _$ReferenceNotifier {
  @override
  FutureOr<void> build() {
    // Initial state
    return null;
  }

  /// Create a new reference
  Future<String> createReference({
    required String name,
    String? groupId,
    String? value,
    String? type,
    String? icon,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(referenceRepositoryProvider);
      
      final reference = ReferenceModel(
        id: const Uuid().v4(),
        name: name,
        groupId: groupId,
        value: value,
        type: type,
        icon: icon,
      );
      
      final id = await repository.createReference(reference);
      
      // Invalidate related providers
      ref.invalidate(referencesProvider);
      if (groupId != null) {
        ref.invalidate(referencesByGroupProvider(groupId));
      }
      
      state = const AsyncValue.data(null);
      return id;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Update an existing reference
  Future<void> updateReference(ReferenceModel reference) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(referenceRepositoryProvider);
      await repository.updateReference(reference);
      
      // Invalidate related providers
      ref.invalidate(referencesProvider);
      ref.invalidate(referenceByIdProvider(reference.id));
      if (reference.groupId != null) {
        ref.invalidate(referencesByGroupProvider(reference.groupId!));
      }
      
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Delete a reference
  Future<void> deleteReference(String id) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(referenceRepositoryProvider);
      
      // Get the reference first to know which group to invalidate
      final reference = await repository.getReferenceById(id);
      
      await repository.deleteReference(id);
      
      // Invalidate related providers
      ref.invalidate(referencesProvider);
      ref.invalidate(referenceByIdProvider(id));
      if (reference?.groupId != null) {
        ref.invalidate(referencesByGroupProvider(reference!.groupId!));
      }
      
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Link a reference to an entity
  Future<void> linkReferenceToEntity(String referenceId, String entityId) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(referenceRepositoryProvider);
      await repository.linkReferenceToEntity(referenceId, entityId);
      
      // Invalidate related providers
      ref.invalidate(referencesByEntityProvider(entityId));
      
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Unlink a reference from an entity
  Future<void> unlinkReferenceFromEntity(String referenceId, String entityId) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(referenceRepositoryProvider);
      await repository.unlinkReferenceFromEntity(referenceId, entityId);
      
      // Invalidate related providers
      ref.invalidate(referencesByEntityProvider(entityId));
      
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

/// Notifier for managing reference group CRUD operations
@riverpod
class ReferenceGroupNotifier extends _$ReferenceGroupNotifier {
  @override
  FutureOr<void> build() {
    // Initial state
    return null;
  }

  /// Create a new reference group
  Future<String> createReferenceGroup({
    required String name,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(referenceRepositoryProvider);
      
      final group = ReferenceGroupModel(
        id: const Uuid().v4(),
        name: name,
      );
      
      final id = await repository.createReferenceGroup(group);
      
      // Invalidate related providers
      ref.invalidate(referenceGroupsProvider);
      
      state = const AsyncValue.data(null);
      return id;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Update an existing reference group
  Future<void> updateReferenceGroup(ReferenceGroupModel group) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(referenceRepositoryProvider);
      await repository.updateReferenceGroup(group);
      
      // Invalidate related providers
      ref.invalidate(referenceGroupsProvider);
      ref.invalidate(referenceGroupByIdProvider(group.id));
      
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Delete a reference group
  Future<void> deleteReferenceGroup(String id) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(referenceRepositoryProvider);
      await repository.deleteReferenceGroup(id);
      
      // Invalidate related providers
      ref.invalidate(referenceGroupsProvider);
      ref.invalidate(referenceGroupByIdProvider(id));
      ref.invalidate(referencesByGroupProvider(id));
      ref.invalidate(referencesProvider);
      
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
} 