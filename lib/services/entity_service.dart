import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/entity_model.dart';
import 'package:vuet_app/models/entity_category_model.dart';
import 'package:vuet_app/models/hierarchical_category_display_model.dart';
import 'package:vuet_app/repositories/entity_repository.dart';
import 'package:vuet_app/repositories/category_repository.dart';
import 'package:vuet_app/services/auth_service.dart';
import 'package:vuet_app/constants/default_categories.dart';
import 'package:vuet_app/utils/logger.dart';
// Import the main repository files, not the .g.dart files directly
import 'package:vuet_app/repositories/supabase_entity_repository.dart';
import 'package:vuet_app/repositories/supabase_category_repository.dart';

class EntityService {
  final EntityRepository _entityRepository;
  final CategoryRepository _categoryRepository;
  final AuthService _authService;

  EntityService(this._entityRepository, this._categoryRepository, this._authService);

  Future<List<BaseEntityModel>> getEntitiesByCategoryId(int appCategoryId) async {
    if (!_authService.isSignedIn) {
      throw Exception('User not authenticated.');
    }
    final userId = _authService.currentUser!.id;
    // categoryId is now appCategoryId (int)
    // No isEmpty check needed for int, but could check for a sentinel value if applicable
    try {
      // Assuming _entityRepository.listEntities will be updated to take appCategoryId
      return await _entityRepository.listEntities(userId: userId, appCategoryId: appCategoryId);
    } catch (e, s) {
      log('''EntityService Error - getEntitiesByCategoryId (appCategoryId: $appCategoryId): $e''', name: 'EntityService', error: e, stackTrace: s);
      rethrow;
    }
  }
  
  Future<List<BaseEntityModel>> getAllUserEntities() async {
    if (!_authService.isSignedIn) {
      throw Exception('User not authenticated.');
    }
    // TEMPORARY WORKAROUND - HARDCODED USER ID
    final userId = 'd885243c-4603-4bdf-82ef-e83873aa4f88';
    try {
      return await _entityRepository.listEntities(userId: userId);
    } catch (e, s) {
      log('''EntityService Error - getAllUserEntities: $e''', name: 'EntityService', error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<BaseEntityModel?> getEntityById(String entityId) async {
    if (!_authService.isSignedIn) {
      throw Exception('User not authenticated.');
    }
    try {
      return await _entityRepository.getEntity(entityId);
    } catch (e, s) {
      log('''EntityService Error - getEntityById: $e''', name: 'EntityService', error: e, stackTrace: s);
      return null; 
    }
  }

  Future<BaseEntityModel> createEntity(BaseEntityModel entity) async {
    if (!_authService.isSignedIn) {
      throw Exception('User not authenticated.');
    }
    final userId = _authService.currentUser!.id;
    var entityToCreate = entity.copyWith(userId: userId);

    // The categoryId (now appCategoryId) is an int?. No need for UUID/name resolution here.
    // This assumes the appCategoryId is correctly set before calling createEntity.
    // If mapping from a String (e.g., EntityCategoryModel.id) to int (app_category_id) is needed,
    // it should happen in the UI/form layer before this service method is called,
    // or this service would need a method to look up app_category_id by EntityCategoryModel.id.

    // For now, we assume entityToCreate.appCategoryId is the correct int? value.
    // No changes needed to entityToCreate.appCategoryId here based on the new model structure.

    try {
      return await _entityRepository.createEntity(entityToCreate);
    } catch (e, s) {
      log('''EntityService Error - createEntity: $e''', name: 'EntityService', error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<BaseEntityModel> updateEntity(BaseEntityModel entity) async {
    if (!_authService.isSignedIn) {
      throw Exception('User not authenticated.');
    }
    final userId = _authService.currentUser!.id;
    if (entity.userId != userId) {
        log('Warning: Attempting to update entity with different userId.', name: "EntityService");
    }
    var entityToUpdate = entity.copyWith(userId: userId); 

    // Similar to createEntity, appCategoryId is now int?.
    // No UUID/name resolution logic for categoryId needed here.
    // Assume entityToUpdate.appCategoryId is correct.

    try {
      return await _entityRepository.updateEntity(entityToUpdate);
    } catch (e, s) {
      log('''EntityService Error - updateEntity: $e''', name: 'EntityService', error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> deleteEntity(String entityId) async {
    if (!_authService.isSignedIn) {
      throw Exception('User not authenticated.');
    }
    try {
      await _entityRepository.deleteEntity(entityId);
    } catch (e, s) {
      log('''EntityService Error - deleteEntity: $e''', name: 'EntityService', error: e, stackTrace: s);
      rethrow;
    }
  }

  Stream<List<BaseEntityModel>> entityUpdatesByCategoryId(int appCategoryId) {
    if (!_authService.isSignedIn) {
      return Stream.error(Exception('User not authenticated.'));
    }
    final userId = _authService.currentUser!.id;
    // appCategoryId is int.

    final controller = StreamController<List<BaseEntityModel>>();
    Timer? timer;

    Future<void> fetchAndAdd() async {
      try {
        // Assuming _entityRepository.listEntities will be updated to take appCategoryId
        final entities = await _entityRepository.listEntities(userId: userId, appCategoryId: appCategoryId);
        if (!controller.isClosed) {
          controller.add(entities);
        }
      } catch (e, s) {
        if (!controller.isClosed) {
          log('''EntityService stream fetch error (appCategoryId: $appCategoryId): $e''', name: 'EntityService', error: e, stackTrace: s);
          controller.addError(e, s);
        }
      }
    }

    fetchAndAdd(); 
    timer = Timer.periodic(const Duration(seconds: 15), (_) {
      if (controller.isClosed) {
        timer?.cancel();
        return;
      }
      fetchAndAdd();
    });

    controller.onCancel = () {
      timer?.cancel();
      log("Entity stream for appCategory $appCategoryId cancelled.", name: "EntityService");
      controller.close();
    };

    return controller.stream;
  }



  Future<List<HierarchicalCategoryDisplayModel>> getHierarchicalCategories(String userId) async {
    try {
      List<EntityCategoryModel> supabaseCategories = await _categoryRepository.fetchCategories();
      
      final List<EntityCategoryModel> mergedCategories = List.from(supabaseCategories);
      final Set<String> existingIds = supabaseCategories.map((cat) => cat.id).toSet();

      for (final defaultCategory in defaultCategories) {
        if (!existingIds.contains(defaultCategory.id)) {
          // Ensure ownerId is null for defaults, as they are global.
          // Also, add to existingIds to prevent re-adding if defaultCategories itself had duplicates by ID (though unlikely).
          mergedCategories.add(defaultCategory.copyWith(ownerId: null)); 
          existingIds.add(defaultCategory.id); 
        }
      }
      
      mergedCategories.sort((a, b) {
        int priorityCompare = (a.priority ?? 99).compareTo(b.priority ?? 99);
        if (priorityCompare != 0) {
          return priorityCompare;
        }
        return (a.name).compareTo(b.name);
      });

      return _buildHierarchy(null, mergedCategories);
    } catch (e, s) {
      log('''Error fetching or building hierarchical categories: $e''', name: 'EntityService', error: e, stackTrace: s);
      return []; 
    }
  }

  List<HierarchicalCategoryDisplayModel> _buildHierarchy(
    String? parentId, 
    List<EntityCategoryModel> allCategories
  ) {
    final List<HierarchicalCategoryDisplayModel> children = [];
    final directChildren = allCategories.where((category) => category.parentId == parentId).toList();

    for (final category in directChildren) {
      final grandChildren = _buildHierarchy(category.id, allCategories);
      children.add(HierarchicalCategoryDisplayModel(
        category: category,
        children: grandChildren,
      ));
    }
    return children;
  }
}

final entityServiceProvider = Provider<EntityService>((ref) {
  final entityRepository = ref.watch(supabaseEntityRepositoryProvider);
  final categoryRepository = ref.watch(supabaseCategoryRepositoryProvider);
  final authService = ref.watch(authServiceProvider);
  return EntityService(entityRepository, categoryRepository, authService);
});
