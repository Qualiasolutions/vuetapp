import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vuet_app/utils/logger.dart';

import '../models/entity_category_model.dart';
import 'category_repository.dart';

part 'supabase_category_repository.g.dart';

@Riverpod(keepAlive: true)
// Changed function name to match expected provider name
CategoryRepository supabaseCategoryRepository( 
    Ref ref) {
  return SupabaseCategoryRepository(Supabase.instance.client);
}

class SupabaseCategoryRepository implements CategoryRepository { 
  final SupabaseClient _supabaseClient;

  SupabaseCategoryRepository(this._supabaseClient); 

  @override
  Future<EntityCategoryModel> createCategory(
      EntityCategoryModel category) async {
    final response = await _supabaseClient
        .from('entity_categories')
        .insert(category.toJson())
        .select()
        .single();
    return EntityCategoryModel.fromJson(response);
  }

  @override
  Future<EntityCategoryModel> fetchCategoryById(String id) async {
    final response = await _supabaseClient
        .from('entity_categories')
        .select()
        .eq('id', id)
        .single();
    return EntityCategoryModel.fromJson(response);
  }

  @override
  Future<List<EntityCategoryModel>> fetchCategories() async {
    final userId = _supabaseClient.auth.currentUser?.id;

    // Build query to fetch both global categories (owner_id=null) AND user-owned categories
    final queryBuilder = _supabaseClient
        .from('entity_categories')
        .select();

    // If user is authenticated, get both global and user-owned categories
    // If not authenticated, get only global categories
    if (userId != null) {
      queryBuilder.or('user_id.is.null,user_id.eq.$userId'); // Changed owner_id to user_id
    } else {
      queryBuilder.filter('user_id', 'is', null); // Changed owner_id to user_id
    }

    final topLevelResponse = await queryBuilder;

    final List<EntityCategoryModel> topLevelCategories = topLevelResponse
        .map((json) => EntityCategoryModel.fromJson(json))
        .toList();

    // 2. Fetch all subcategories from entity_subcategories
    // These are global/shared, not filtered by owner_id directly in this table.
    // Their parent (entity_categories) might be user-owned or global.
    final subcategoriesResponse = await _supabaseClient
        .from('entity_subcategories')
        .select();

    final List<EntityCategoryModel> subCategoryModels = [];
    for (final subJson in subcategoriesResponse) {
      // Ensure all necessary fields for EntityCategoryModel are present or handled with defaults
      subCategoryModels.add(EntityCategoryModel(
        id: subJson['id'] as String, // PK of entity_subcategories
        name: subJson['display_name'] as String, // Human-readable name
        description: subJson['description'] as String? ?? '', // entity_subcategories doesn't have description, use default
        icon: subJson['icon'] as String?,
        ownerId: null, // Subcategories might not have a direct owner_id; they belong to a parent.
                       // Or, this could be the parent's owner_id if needed for RLS elsewhere.
                       // For now, keeping it simple.
        createdAt: subJson['created_at'] != null ? DateTime.parse(subJson['created_at'] as String) : null,
        updatedAt: subJson['updated_at'] != null ? DateTime.parse(subJson['updated_at'] as String) : null,
        color: subJson['color'] as String?,
        priority: subJson['priority'] as int?, // entity_subcategories doesn't have priority, use default
        isProfessional: false, // Default, or derive from parent if necessary
        parentId: subJson['category_id'] as String?, // This is the FK to entity_categories.id
      ));
    }
    
    // Combine top-level user categories and all subcategories
    // The EntityService will handle merging these with the hardcoded defaultCategories
    final combinedList = <EntityCategoryModel>[];
    combinedList.addAll(topLevelCategories);
    combinedList.addAll(subCategoryModels);
    
    // Deduplicate based on ID, preferring user-specific if conflicts (though IDs should be unique UUIDs)
    final uniqueCategories = <String, EntityCategoryModel>{};
    for (var cat in combinedList) {
      uniqueCategories[cat.id] = cat;
    }

    return uniqueCategories.values.toList();
  }
  
  @override
  Future<List<EntityCategoryModel>> fetchPersonalCategories() async {
    final userId = _supabaseClient.auth.currentUser?.id;

    // Build query to fetch personal categories
    final queryBuilder = _supabaseClient
        .from('entity_categories')
        .select()
        .eq('is_professional', false);

    // If user is authenticated, get both global and user-owned categories
    // If not authenticated, get only global categories
    if (userId != null) {
      queryBuilder.or('user_id.is.null,user_id.eq.$userId'); // Changed owner_id to user_id
    } else {
      queryBuilder.filter('user_id', 'is', null); // Changed owner_id to user_id
    }

    final response = await queryBuilder;
    return response.map((json) => EntityCategoryModel.fromJson(json)).toList();
  }

  @override
  Future<List<EntityCategoryModel>> fetchProfessionalCategories() async {
    final userId = _supabaseClient.auth.currentUser?.id;

    // Build query to fetch professional categories
    final queryBuilder = _supabaseClient
        .from('entity_categories')
        .select()
        .eq('is_professional', true);

    // If user is authenticated, get both global and user-owned categories
    // If not authenticated, get only global categories
    if (userId != null) {
      queryBuilder.or('user_id.is.null,user_id.eq.$userId'); // Changed owner_id to user_id
    } else {
      queryBuilder.filter('user_id', 'is', null); // Changed owner_id to user_id
    }

    final response = await queryBuilder;
    return response.map((json) => EntityCategoryModel.fromJson(json)).toList();
  }

  @override
  Future<EntityCategoryModel> updateCategory(
      EntityCategoryModel category) async {
    final response = await _supabaseClient
        .from('entity_categories')
        .update(category.toJson())
        .eq('id', category.id)
        .select()
        .single();
    return EntityCategoryModel.fromJson(response);
  }

  @override
  Future<void> deleteCategory(String id) async {
    await _supabaseClient.from('entity_categories').delete().eq('id', id);
  }

  @override
  Future<int> fetchUncategorisedEntitiesCount() async {
    log('fetchUncategorisedEntitiesCount called, returning 0 (placeholder)', name: 'SupabaseCategoryRepository');
    return 0; 
  }
}
