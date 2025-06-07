import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/entity_category_model.dart'; // Will be EntityCategory
import 'entity_category_repository.dart';
import 'base_supabase_repository.dart'; // Assuming you have this for common logic

part 'supabase_entity_category_repository.g.dart';

@Riverpod(keepAlive: true)
EntityCategoryRepository supabaseEntityCategoryRepository(Ref ref) {
  return SupabaseEntityCategoryRepository(Supabase.instance.client);
}

class SupabaseEntityCategoryRepository extends BaseSupabaseRepository
    implements EntityCategoryRepository {
  SupabaseEntityCategoryRepository(super.client);

  @override
  Future<EntityCategory> createCategory(EntityCategory category) async { // Updated
    return executeQuery('createCategory', () async {
      final response = await from('entity_categories')
          .insert(category.toJson())
          .select()
          .single();
      return EntityCategory.fromJson(response); // Updated
    });
  }

  @override
  Future<EntityCategory?> getCategory(String id) async { // Updated
    return executeQuery('getCategory', () async {
      try {
        final response =
            await from('entity_categories').select().eq('id', id).single();
        return EntityCategory.fromJson(response); // Updated
      } catch (e) {
        // Handle cases where the category might not be found or other errors
        // print('Error fetching category $id: $e');
        return null;
      }
    });
  }

  @override
  Future<List<EntityCategory>> listCategories( // Updated
      {String? ownerId}) async {
    return executeQuery('listCategories', () async {
      // Start with select() which returns a PostgrestFilterBuilder
      var queryBuilder = from('entity_categories').select();
      
      if (ownerId != null) {
        // .eq() is a method of PostgrestFilterBuilder and returns PostgrestFilterBuilder
        queryBuilder = queryBuilder.eq('owner_id', ownerId);
      }
      
      // .order() is a method of PostgrestFilterBuilder and returns PostgrestTransformBuilder
      // We await the result of the chain.
      final response = await queryBuilder
          .order('priority', ascending: true)
          .order('name', ascending: true);
          
      // The response here is PostgrestList (which is List<Map<String, dynamic>>)
      return response
          .map((json) => EntityCategory.fromJson(json)) // Updated
          .toList();
    });
  }

  @override
  Future<EntityCategory> updateCategory(EntityCategory category) async { // Updated
    return executeQuery('updateCategory', () async {
      final response = await from('entity_categories')
          .update(category.toJson())
          .eq('id', category.id)
          .select()
          .single();
      return EntityCategory.fromJson(response); // Updated
    });
  }

  @override
  Future<void> deleteCategory(String id) async {
    return executeQuery('deleteCategory', () async {
      await from('entity_categories').delete().eq('id', id);
    });
  }
}
