import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/entity_model.dart';
import 'package:vuet_app/models/entity_category_model.dart'; // Will be EntityCategory
import 'package:vuet_app/models/entity_subcategory_model.dart';
import 'package:vuet_app/models/hierarchical_category_display_model.dart';
import 'package:vuet_app/repositories/entity_repository.dart';
import 'package:vuet_app/repositories/category_repository.dart';
import 'package:vuet_app/repositories/entity_subcategory_repository.dart';
import 'package:vuet_app/services/auth_service.dart';
// Import the main repository files, not the .g.dart files directly
import 'package:vuet_app/repositories/supabase_entity_repository.dart';
import 'package:vuet_app/repositories/supabase_category_repository.dart';
import 'package:vuet_app/repositories/supabase_entity_subcategory_repository.dart';

/// Service class for entity operations
class EntityService {
  final EntityRepository _repository;
  final CategoryRepository? _categoryRepository;
  final EntitySubcategoryRepository? _subcategoryRepository;
  final dynamic _authService;

  /// Constructor for EntityService
  EntityService({
    required EntityRepository repository,
    CategoryRepository? categoryRepository,
    EntitySubcategoryRepository? subcategoryRepository,
    dynamic authService,
  }) : 
    _repository = repository,
    _categoryRepository = categoryRepository,
    _subcategoryRepository = subcategoryRepository,
    _authService = authService;

  // Helper property to check if user is signed in
  bool get _isUserSignedIn => _authService?.isSignedIn ?? false;
  
  // Helper property to get current user ID
  String? get _currentUserId => _authService?.currentUser?.id;

  /// Create a new entity
  Future<BaseEntityModel> createEntity(BaseEntityModel entity, {String? subcategoryId}) async {
    if (_authService != null && !_isUserSignedIn) {
      throw Exception('User not authenticated.');
    }
    
    final userId = _currentUserId ?? entity.userId;
    var entityToCreate = entity.copyWith(
      userId: userId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      subcategoryId: subcategoryId,
    );

    try {
      return await _repository.createEntity(entityToCreate);
    } catch (e) {
      _handleError('Failed to create entity', e);
      rethrow;
    }
  }

  /// Get an entity by ID (legacy method)
  Future<BaseEntityModel?> getEntityById(String id) async {
    if (_authService != null && !_isUserSignedIn) {
      throw Exception('User not authenticated.');
    }
    try {
      final entity = await _repository.getEntity(id);
      if (entity == null) {
        return null;
      }
      if (_authService != null) {
        final userId = _currentUserId!;
        if (entity.userId != userId) {
          throw Exception('Not authorized to access this entity.');
        }
      }
      return entity;
    } catch (e) {
      _handleError('Failed to get entity by ID', e);
      rethrow;
    }
  }

  /// Get an entity by ID (new method)
  Future<BaseEntityModel?> getEntity(String id) async {
    try {
      return await _repository.getEntity(id);
    } catch (e) {
      _handleError('Failed to get entity', e);
      rethrow;
    }
  }

  /// Get entities by category
  Future<List<BaseEntityModel>> getEntitiesByCategory(int appCategoryId, {String? subcategoryId}) async {
    if (_authService != null && !_isUserSignedIn) {
      throw Exception('User not authenticated.');
    }
    try {
      final userId = _currentUserId;
      return await _repository.listEntities(
        userId: userId, 
        appCategoryId: appCategoryId,
        subcategoryId: subcategoryId,
      );
    } catch (e) {
      _handleError('Failed to get entities by category', e);
      rethrow;
    }
  }

  /// Get all user entities
  Future<List<BaseEntityModel>> getAllUserEntities() async {
    if (_authService != null && !_isUserSignedIn) {
      throw Exception('User not authenticated.');
    }
    try {
      final userId = _currentUserId;
      return await _repository.listEntities(userId: userId);
    } catch (e) {
      _handleError('Failed to get all user entities', e);
      rethrow;
    }
  }

  /// List all entities (generic method)
  Future<List<BaseEntityModel>> listEntities({String? userId, int? appCategoryId, String? subcategoryId}) async {
    try {
      return await _repository.listEntities(
        userId: userId ?? _currentUserId,
        appCategoryId: appCategoryId,
        subcategoryId: subcategoryId,
      );
    } catch (e) {
      _handleError('Failed to list entities', e);
      rethrow;
    }
  }

  /// Update an entity
  Future<BaseEntityModel> updateEntity(BaseEntityModel entity, {String? subcategoryId}) async {
    if (_authService != null && !_isUserSignedIn) {
      throw Exception('User not authenticated.');
    }
    
    var entityToUpdate = entity;
    
    if (_authService != null) {
      final userId = _currentUserId!;
      if (entity.userId != userId) {
          log('Warning: Attempting to update entity with different userId.', name: "EntityService");
      }
      
      entityToUpdate = entity.copyWith(
        userId: userId,
        updatedAt: DateTime.now(),
        subcategoryId: subcategoryId ?? entity.subcategoryId,
      );
    } else {
      entityToUpdate = entity.copyWith(
        updatedAt: DateTime.now(),
        subcategoryId: subcategoryId ?? entity.subcategoryId,
      );
    }

    try {
      return await _repository.updateEntity(entityToUpdate);
    } catch (e) {
      _handleError('Failed to update entity', e);
      rethrow;
    }
  }

  /// Delete an entity
  Future<void> deleteEntity(String id) async {
    if (_authService != null && !_isUserSignedIn) {
      throw Exception('User not authenticated.');
    }
    try {
      await _repository.deleteEntity(id);
    } catch (e) {
      _handleError('Failed to delete entity', e);
      rethrow;
    }
  }

  // Add subcategory-related methods
  Future<List<EntitySubcategoryModel>> getSubcategoriesByCategory(String categoryId) async {
    if (_subcategoryRepository == null) {
      throw Exception('Subcategory repository not provided');
    }
    try {
      return await _subcategoryRepository.listSubcategories(categoryId: categoryId);
    } catch (e) {
      _handleError('Failed to get subcategories by category', e);
      rethrow;
    }
  }

  Future<EntitySubcategoryModel?> getSubcategoryById(String id) async {
    if (_subcategoryRepository == null) {
      throw Exception('Subcategory repository not provided');
    }
    try {
      return await _subcategoryRepository.getSubcategory(id);
    } catch (e) {
      _handleError('Failed to get subcategory by ID', e);
      rethrow;
    }
  }

  // Private method to handle and log errors
  void _handleError(String message, dynamic error) {
    final errorMessage = '$message: ${error.toString()}';
    log(errorMessage, name: 'EntityService', error: error);
  }

  Future<List<HierarchicalCategoryDisplayModel>> getHierarchicalCategories(String userId) async {
    if (_categoryRepository == null) {
      throw Exception('CategoryRepository not provided');
    }
    
    try {
      // fetchCategories should now return List<EntityCategory> from the new 'entity_categories' table
      List<EntityCategory> supabaseCategories = await _categoryRepository.fetchCategories();
      
      // The merging logic with defaultCategories_UNUSED might be temporary or for seeding.
      // For now, we assume supabaseCategories is the primary source.
      // If defaultCategories_UNUSED is for fallback, that logic would be different.
      // For simplicity, let's assume supabaseCategories is what we work with primarily.
      // If `defaultCategories_UNUSED` is meant to augment, that logic needs careful review.
      // Given the new DB table, this merging might be entirely replaced.
      // For now, let's just use what's fetched from Supabase.
      
      final List<EntityCategory> categoriesToBuildHierarchyFrom = List.from(supabaseCategories);

      // The old defaultCategories had 'parentId', the new EntityCategory doesn't directly.
      // The hierarchy was built using parentId. If the new `entity_categories` table
      // doesn't have a parent_id column (our DDL didn't add one), then _buildHierarchy
      // will only return top-level items. This needs to be considered.
      // For now, assuming the fetched categories are flat or _buildHierarchy handles it.
      // The sorting should use the new model's fields.
      categoriesToBuildHierarchyFrom.sort((a, b) {
        int priorityCompare = (a.sortOrder).compareTo(b.sortOrder);
        if (priorityCompare != 0) {
          return priorityCompare;
        }
        // Using internal 'name' for secondary sort, or 'displayName' if preferred for user-facing sort.
        return (a.name).compareTo(b.name); 
      });

      // The _buildHierarchy method expects parentId. Our current EntityCategory doesn't have parentId.
      // This hierarchical logic will need significant rework if categories are flat from the DB
      // or if hierarchy is defined differently.
      // For now, passing the flat list.
      return _buildHierarchy(null, categoriesToBuildHierarchyFrom);
    } catch (e) {
      _handleError('Error fetching or building hierarchical categories', e);
      return []; 
    }
  }

  List<HierarchicalCategoryDisplayModel> _buildHierarchy(
    String? parentId, 
    List<EntityCategory> allCategories // Updated to EntityCategory
  ) {
    final List<HierarchicalCategoryDisplayModel> children = [];
    // The EntityCategory model does not have parentId. This logic will not work as is.
    // This will need to be refactored based on how hierarchy is now determined (if at all from this flat list).
    // For now, to avoid errors, I'll assume no parentId means it's a top-level category.
    // This will effectively make the hierarchy flat if no parentId field exists and is populated.
    // UPDATE: EntityCategory now has parentId.
    final directChildren = allCategories.where((category) {
      return category.parentId == parentId;
    }).toList();

    for (final category in directChildren) {
      // If categories are flat, grandChildren will always be empty.
      final grandChildren = _buildHierarchy(category.id, allCategories);
      children.add(HierarchicalCategoryDisplayModel(
        category: category,
        children: grandChildren,
      ));
    }
    return children;
  }
  
  // Helper method for logging
  void log(String message, {required String name, Object? error, StackTrace? stackTrace}) {
    developer.log(message, name: name, error: error, stackTrace: stackTrace);
  }
}

final entityServiceProvider = Provider<EntityService>((ref) {
  final entityRepository = ref.watch(supabaseEntityRepositoryProvider);
  final categoryRepository = ref.watch(supabaseCategoryRepositoryProvider);
  final authService = ref.watch(authServiceProvider);
  final subcategoryRepository = ref.watch(supabaseEntitySubcategoryRepositoryProvider);
  return EntityService(
    repository: entityRepository,
    categoryRepository: categoryRepository,
    subcategoryRepository: subcategoryRepository,
    authService: authService,
  );
});
