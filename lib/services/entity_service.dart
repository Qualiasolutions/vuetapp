import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/entity_model.dart';
import 'package:vuet_app/models/entity_category_model.dart';
import 'package:vuet_app/models/entity_subcategory_model.dart';
import 'package:vuet_app/models/hierarchical_category_display_model.dart';
import 'package:vuet_app/repositories/entity_repository.dart';
import 'package:vuet_app/repositories/category_repository.dart';
import 'package:vuet_app/repositories/entity_subcategory_repository.dart';
import 'package:vuet_app/services/auth_service.dart';
import 'package:vuet_app/constants/default_categories.dart';
// Import the main repository files, not the .g.dart files directly
import 'package:vuet_app/repositories/supabase_entity_repository.dart';
import 'package:vuet_app/repositories/supabase_category_repository.dart';
import 'package:vuet_app/repositories/supabase_entity_subcategory_repository.dart';
import 'package:vuet_app/utils/logger.dart';

/// Service class for entity operations
class EntityService {
  final EntityRepository _repository;
  final CategoryRepository? _categoryRepository;
  final EntitySubcategoryRepository? _subcategoryRepository;
  final AuthService? _authService;

  /// Constructor for EntityService
  EntityService({
    required EntityRepository repository,
    CategoryRepository? categoryRepository,
    EntitySubcategoryRepository? subcategoryRepository,
    AuthService? authService,
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
    } catch (e) {
      _handleError('Error fetching or building hierarchical categories', e);
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
