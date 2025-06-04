import 'dart:developer' as developer;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// Ensure EntityTypeHelper is accessible if used directly, or BaseEntityModel.toSupabaseJson handles it.
// import '../models/entity_model.dart'; // Already imported

import '../models/entity_model.dart';
import 'entity_repository.dart';
import 'base_supabase_repository.dart';

part 'supabase_entity_repository.g.dart';

@Riverpod(keepAlive: true)
EntityRepository supabaseEntityRepository(Ref ref) { 
  return SupabaseEntityRepository(Supabase.instance.client);
}

class SupabaseEntityRepository extends BaseSupabaseRepository implements EntityRepository {
  SupabaseEntityRepository(super.client);

  @override
  Future<BaseEntityModel> createEntity(BaseEntityModel entity) async {
    return executeQuery('createEntity', () async {
      // BaseEntityModel.toSupabaseJson() is expected to correctly prepare all fields,
      // including app_category_id and entity_type_id (derived from entity.subtype).
      final jsonData = entity.toSupabaseJson();

      // Basic validation for required fields before sending to Supabase
      if (!jsonData.containsKey('app_category_id') || jsonData['app_category_id'] == null) {
        developer.log('app_category_id is missing or null in jsonData for createEntity', name: 'SupabaseEntityRepository', error: jsonData);
        throw ArgumentError('app_category_id is required to create an entity.');
      }
      if (!jsonData.containsKey('entity_type_id') || jsonData['entity_type_id'] == null) {
        developer.log('entity_type_id is missing or null in jsonData for createEntity', name: 'SupabaseEntityRepository', error: jsonData);
        throw ArgumentError('entity_type_id is required to create an entity.');
      }
      
      final response = await from('entities')
          .insert(jsonData)
          .select()
          .single();
      return BaseEntityModel.fromJson(response);
    });
  }

  @override
  Future<BaseEntityModel?> getEntity(String id) async {
    return executeQuery('getEntity', () async {
      final response = await from('entities')
          .select()
          .eq('id', id)
          .single();
      return BaseEntityModel.fromJson(response);
    });
  }

  @override
  Future<List<BaseEntityModel>> listEntities({String? userId, int? appCategoryId, String? subcategoryId}) async {
    // Internally, subcategoryId (if provided) is treated as an entity_type_id string for filtering.
    return executeQuery('listEntities', () async {
      var query = from('entities').select();
      if (userId != null) {
        query = query.eq('user_id', userId); 
      }
      if (appCategoryId != null) {
        query = query.eq('app_category_id', appCategoryId); 
      }
      if (subcategoryId != null) {
        // Directly filter by the entity_type_id string, assuming subcategoryId parameter holds this value.
        query = query.eq('entity_type_id', subcategoryId);
      }
      final response = await query;
      return response.map((json) => BaseEntityModel.fromJson(json)).toList();
    });
  }

  @override
  Future<BaseEntityModel> updateEntity(BaseEntityModel entity) async {
    return executeQuery('updateEntity', () async {
      // BaseEntityModel.toSupabaseJson() is expected to correctly prepare all fields.
      final jsonData = entity.toSupabaseJson();

      // Basic validation for required fields before sending to Supabase
      if (!jsonData.containsKey('app_category_id') || jsonData['app_category_id'] == null) {
        developer.log('app_category_id is missing or null in jsonData for updateEntity', name: 'SupabaseEntityRepository', error: jsonData);
        // Depending on DB constraints, app_category_id might not be updatable or always required here.
        // For now, we assume it might be part of the update payload.
      }
      if (!jsonData.containsKey('entity_type_id') || jsonData['entity_type_id'] == null) {
        developer.log('entity_type_id is missing or null in jsonData for updateEntity', name: 'SupabaseEntityRepository', error: jsonData);
      }

      final response = await from('entities')
          .update(jsonData) // Use the prepared jsonData
          .eq('id', entity.id!)
          .select()
          .single();
      return BaseEntityModel.fromJson(response);
    });
  }

  @override
  Future<void> deleteEntity(String id) async {
    return executeQuery('deleteEntity', () async {
      await from('entities').delete().eq('id', id);
    });
  }
}
