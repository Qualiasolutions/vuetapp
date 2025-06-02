import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/entity_subcategory_model.dart';
import 'entity_subcategory_repository.dart';
import 'base_supabase_repository.dart';

part 'supabase_entity_subcategory_repository.g.dart';

@Riverpod(keepAlive: true)
EntitySubcategoryRepository supabaseEntitySubcategoryRepository(Ref ref) { 
  return SupabaseEntitySubcategoryRepository(Supabase.instance.client);
}

class SupabaseEntitySubcategoryRepository extends BaseSupabaseRepository implements EntitySubcategoryRepository {
  SupabaseEntitySubcategoryRepository(super.client);

  @override
  Future<EntitySubcategoryModel> createSubcategory(EntitySubcategoryModel subcategory) async {
    return executeQuery('createSubcategory', () async {
      final response = await from('entity_subcategories')
          .insert(subcategory.toJson())
          .select()
          .single();
      return EntitySubcategoryModel.fromJson(response);
    });
  }

  @override
  Future<EntitySubcategoryModel?> getSubcategory(String id) async {
    return executeQuery('getSubcategory', () async {
      final response = await from('entity_subcategories')
          .select()
          .eq('id', id)
          .single();
      return EntitySubcategoryModel.fromJson(response);
    });
  }

  @override
  Future<List<EntitySubcategoryModel>> listSubcategories({String? categoryId}) async {
    return executeQuery('listSubcategories', () async {
      var query = from('entity_subcategories').select();
      if (categoryId != null) {
        query = query.eq('category_id', categoryId);
      }
      final response = await query;
      return response.map((json) => EntitySubcategoryModel.fromJson(json)).toList();
    });
  }

  @override
  Future<EntitySubcategoryModel> updateSubcategory(EntitySubcategoryModel subcategory) async {
    return executeQuery('updateSubcategory', () async {
      final response = await from('entity_subcategories')
          .update(subcategory.toJson())
          .eq('id', subcategory.id)
          .select()
          .single();
      return EntitySubcategoryModel.fromJson(response);
    });
  }

  @override
  Future<void> deleteSubcategory(String id) async {
    return executeQuery('deleteSubcategory', () async {
      await from('entity_subcategories').delete().eq('id', id);
    });
  }
} 