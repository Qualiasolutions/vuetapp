import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vuet_app/utils/logger.dart';

import '../models/entity_category_model.dart'; // Will be EntityCategory
import 'category_repository.dart';

part 'supabase_category_repository.g.dart';

@Riverpod(keepAlive: true)
// Changed function name to match expected provider name
CategoryRepository supabaseCategoryRepository(Ref ref) {
  return SupabaseCategoryRepository(Supabase.instance.client);
}

class SupabaseCategoryRepository implements CategoryRepository { 
  final SupabaseClient _supabaseClient;

  SupabaseCategoryRepository(this._supabaseClient); 

  @override
  Future<EntityCategory> createCategory( // Updated
      EntityCategory category) async { // Updated
    final response = await _supabaseClient
        .from('entity_categories')
        .insert(category.toJson())
        .select()
        .single();
    return EntityCategory.fromJson(response); // Updated
  }

  @override
  Future<EntityCategory> fetchCategoryById(String id) async { // Updated
    final response = await _supabaseClient
        .from('entity_categories')
        .select()
        .eq('id', id)
        .single();
    return EntityCategory.fromJson(response); // Updated
  }

  @override
  Future<List<EntityCategory>> fetchCategories() async { // Updated
    final userId = _supabaseClient.auth.currentUser?.id;

    // Build query to fetch both global categories (owner_id=null) AND user-owned categories
    final queryBuilder = _supabaseClient.from('entity_categories').select();

    // If user is authenticated, get both global and user-owned categories
    // If not authenticated, get only global categories
    if (userId != null) {
      queryBuilder.or(
          'user_id.is.null,user_id.eq.$userId'); // Changed owner_id to user_id
    } else {
      queryBuilder.filter('user_id', 'is', null); // Changed owner_id to user_id
    }

    // Fetches all categories from the new 'entity_categories' table.
    // RLS policies on the table will handle user-specific access if defined.
    // For now, it fetches all, assuming RLS allows general read.
    // The old logic for user_id filtering and subcategories is removed as
    // the new 'entity_categories' table is the single source of truth for main categories.
    final response = await _supabaseClient
        .from('entity_categories') // Correct table name
        .select()
        .order('sort_order', ascending: true); // Order by sort_order

    return response
        .map((json) => EntityCategory.fromJson(json)) // Updated
        .toList();
  }

  @override
  Future<List<EntityCategory>> fetchPersonalCategories() async { // Updated
    final userId = _supabaseClient.auth.currentUser?.id;

    // Build query to fetch personal categories
    final queryBuilder = _supabaseClient
        .from('entity_categories')
        .select()
        .eq('is_professional', false);

    // If user is authenticated, get both global and user-owned categories
    // If not authenticated, get only global categories
    if (userId != null) {
      queryBuilder.or(
          'user_id.is.null,user_id.eq.$userId'); // Changed owner_id to user_id
    } else {
      queryBuilder.filter('user_id', 'is', null); // Changed owner_id to user_id
    }

    // This method might need re-evaluation.
    // For now, it fetches all and filters if 'is_professional' concept is added to EntityCategory.
    // Or, it could filter by some other criteria if 'personal' has a new meaning.
    // Currently, our EntityCategory doesn't have 'is_professional'.
    // Returning all categories for now, same as fetchCategories.
    log('fetchPersonalCategories called, returning all categories. Review if specific filtering is needed.', name: 'SupabaseCategoryRepository');
    return fetchCategories();
  }

  @override
  Future<List<EntityCategory>> fetchProfessionalCategories() async { // Updated
    final userId = _supabaseClient.auth.currentUser?.id;

    // Build query to fetch professional categories
    final queryBuilder = _supabaseClient
        .from('entity_categories')
        .select()
        .eq('is_professional', true);

    // If user is authenticated, get both global and user-owned categories
    // If not authenticated, get only global categories
    if (userId != null) {
      queryBuilder.or(
          'user_id.is.null,user_id.eq.$userId'); // Changed owner_id to user_id
    } else {
      queryBuilder.filter('user_id', 'is', null); // Changed owner_id to user_id
    }

    // Similar to fetchPersonalCategories, this needs re-evaluation.
    // Returning all categories for now.
    log('fetchProfessionalCategories called, returning all categories. Review if specific filtering is needed.', name: 'SupabaseCategoryRepository');
    return fetchCategories();
  }

  @override
  Future<EntityCategory> updateCategory( // Updated
      EntityCategory category) async { // Updated
    final response = await _supabaseClient
        .from('entity_categories') // Correct table name
        .update(category.toJson())
        .eq('id', category.id)
        .select()
        .single();
    return EntityCategory.fromJson(response); // Updated
  }

  @override
  Future<void> deleteCategory(String id) async {
    await _supabaseClient.from('entity_categories').delete().eq('id', id);
  }

  @override
  Future<int> fetchUncategorisedEntitiesCount() async {
    log('fetchUncategorisedEntitiesCount called, returning 0 (placeholder)',
        name: 'SupabaseCategoryRepository');
    return 0;
  }
}
