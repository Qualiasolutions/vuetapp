import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      final response = await from('entities')
          .insert(entity.toJson())
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
          .eq('id', id as Object)
          .single();
      return BaseEntityModel.fromJson(response);
    });
  }

  @override
  Future<List<BaseEntityModel>> listEntities({String? userId, int? appCategoryId}) async {
    return executeQuery('listEntities', () async {
      var query = from('entities').select();
      if (userId != null) {
        query = query.eq('user_id', userId as Object); 
      }
      if (appCategoryId != null) {
        // Ensure the column name matches the database: 'app_category_id'
        query = query.eq('app_category_id', appCategoryId as Object); 
      }
      final response = await query;
      return response.map((json) => BaseEntityModel.fromJson(json)).toList();
    });
  }

  @override
  Future<BaseEntityModel> updateEntity(BaseEntityModel entity) async {
    return executeQuery('updateEntity', () async {
      final response = await from('entities')
          .update(entity.toJson())
          .eq('id', entity.id as Object)
          .select()
          .single();
      return BaseEntityModel.fromJson(response);
    });
  }

  @override
  Future<void> deleteEntity(String id) async {
    return executeQuery('deleteEntity', () async {
      await from('entities').delete().eq('id', id as Object);
    });
  }
}
