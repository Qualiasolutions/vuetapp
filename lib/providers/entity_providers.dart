import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/entity_model.dart';
import 'package:vuet_app/models/entity_category_model.dart';
import 'package:vuet_app/services/entity_service.dart';
import 'package:vuet_app/services/auth_service.dart';

// Re-export the entityServiceProvider from entity_service.dart
export 'package:vuet_app/services/entity_service.dart' show entityServiceProvider;

// Provider for fetching all entities for the current user
final allUserEntitiesProvider = StreamProvider<List<BaseEntityModel>>((ref) {
  final entityService = ref.watch(entityServiceProvider);
  return Stream.fromFuture(entityService.getAllUserEntities()); 
});

// Provider for fetching a specific entity by ID - RENAMED
final entityDetailProvider = FutureProvider.family<BaseEntityModel?, String>((ref, entityId) async {
  final entityService = ref.watch(entityServiceProvider);
  return entityService.getEntityById(entityId);
});

// Provider for filtering entities by subtype for the current user
final entityBySubtypeProvider = StreamProvider.family<List<BaseEntityModel>, EntitySubtype>((ref, subtype) {
    final entityService = ref.watch(entityServiceProvider);
    return Stream.fromFuture(entityService.getAllUserEntities()).map((entities) {
        return entities.where((entity) => entity.subtype == subtype).toList();
    });
});


// Provider for filtering entities by multiple subtypes for the current user
final entityBySubtypesProvider = StreamProvider.family<List<BaseEntityModel>, List<EntitySubtype>>((ref, subtypes) {
    final entityService = ref.watch(entityServiceProvider);
    return Stream.fromFuture(entityService.getAllUserEntities()).map((entities) {
        return entities.where((entity) => subtypes.contains(entity.subtype)).toList();
    });
});

// Provider for streaming entities for a given appCategoryId for the current user
final entityByCategoryStreamProvider = StreamProvider.family<List<BaseEntityModel>, int>((ref, appCategoryId) { // Changed String to int, categoryId to appCategoryId
  final entityService = ref.watch(entityServiceProvider);
  return entityService.entityUpdatesByCategoryId(appCategoryId); // Pass appCategoryId
});

// --- Entity Actions --- 

// 1. Define the Notifier class for entity actions
class EntityActions extends StateNotifier<AsyncValue<void>> {
  final EntityService _entityService;

  EntityActions(this._entityService) : super(const AsyncValue.data(null)); // Initial state

  Future<void> createEntity(BaseEntityModel entity) async {
    state = const AsyncValue.loading();
    try {
      await _entityService.createEntity(entity);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      // Optionally rethrow or handle specific errors
      // For example, you might want to show a user-facing error message
    }
  }

  Future<void> updateEntity(BaseEntityModel entity) async {
    state = const AsyncValue.loading();
    try {
      await _entityService.updateEntity(entity);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteEntity(String entityId) async {
    state = const AsyncValue.loading();
    try {
      await _entityService.deleteEntity(entityId);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

// 2. Define the StateNotifierProvider for EntityActions
final entityActionsProvider = StateNotifierProvider<EntityActions, AsyncValue<void>>((ref) {
  final entityService = ref.watch(entityServiceProvider);
  return EntityActions(entityService);
});

// ============================================================================
// ADDITIONAL PROVIDERS FOR UI COMPONENTS (matches old React Vuet functionality)
// ============================================================================

// Provider for entity categories (matches old React categories functionality)
final entityCategoriesProvider = FutureProvider<List<EntityCategoryModel>>((ref) async {
  final authService = ref.watch(authServiceProvider);
  final userId = authService.currentUser?.id;
  if (userId == null) return [];
  
  final entityService = ref.watch(entityServiceProvider);
  // Get hierarchical categories but flatten them for the provider
  final hierarchical = await entityService.getHierarchicalCategories(userId);
  return hierarchical.map((h) => h.category).toList();
});

// Provider method for entities by category ID (matches old React entity filtering)
class EntityProviders {
  static FutureProvider<List<BaseEntityModel>> entitiesByCategoryIdProvider(String categoryId) {
    return FutureProvider<List<BaseEntityModel>>((ref) async {
      final entityService = ref.watch(entityServiceProvider);
      final allEntities = await entityService.getAllUserEntities();
      
      // Convert string categoryId to int for filtering
      final int? appCategoryId = int.tryParse(categoryId);
      if (appCategoryId == null) return [];
      
      // Filter entities by appCategoryId
      return allEntities.where((entity) => entity.appCategoryId == appCategoryId).toList();
    });
  }
}
