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
      final jsonData = entity.toSupabaseJson();
      
      // Debug log the exact data being sent to Supabase
      print('🔍 DEBUG - Full JSON being sent to Supabase:');
      jsonData.forEach((key, value) {
        print('  - $key: $value');
      });
      
      // Get the entity_type_id that will be sent
      final entityTypeId = jsonData['entity_type_id'];
      print('🔍 DEBUG - Using entity_type_id: $entityTypeId');
      
      // Verify this entity_type_id exists in the database
      try {
        final typeCheck = await from('entity_types')
            .select('id, name')
            .eq('id', entityTypeId)
            .single();
        
        print('✅ Found entity_type_id in database: ${typeCheck['id']} (${typeCheck['name']})');
      } catch (e) {
        print('❌ Entity type not found: $e');
        
        // Try to find by display name instead
        try {
          final enumString = entity.subtype.toString();
          final displayName = enumString.split('.').last;
          
          print('🔍 Trying to find entity type by name...');
          // Try to convert the display name to snake_case to match database format
          final snakeCaseName = displayName.replaceAllMapped(
              RegExp(r'([A-Z])'), 
              (match) => match.start > 0 ? '_${match.group(0)!.toLowerCase()}' : match.group(0)!.toLowerCase()
          );
          
          print('🔍 Looking for entity_type with id: $snakeCaseName');
          final nameCheck = await from('entity_types')
              .select('id, name')
              .eq('id', snakeCaseName)
              .single();
          
          print('✅ Found by name conversion: ${nameCheck['id']}');
          jsonData['entity_type_id'] = nameCheck['id'];
        } catch (nameError) {
          print('❌ Could not find entity type by converted name: $nameError');
          
          // Last resort: query all entity_types to see what's available
          try {
            print('🔍 Listing available entity types for reference...');
            final allTypes = await from('entity_types').select('id, name, app_category_id').limit(20);
            
            print('🔍 Available entity types:');
            for (final type in allTypes) {
              print('  - ${type['id']} (${type['name']}) - Category ${type['app_category_id']}');
            }
            
            // Try to use a fallback from the same category
            final appCategoryId = jsonData['app_category_id'];
            if (appCategoryId != null) {
              try {
                final fallbackType = await from('entity_types')
                    .select('id, name')
                    .eq('app_category_id', appCategoryId)
                    .limit(1)
                    .single();
                
                print('✅ Using fallback from same category: ${fallbackType['id']}');
                jsonData['entity_type_id'] = fallbackType['id'];
              } catch (_) {
                // If all else fails, use a known safe value
                print('⚠️ Using last resort fallback: "event"');
                jsonData['entity_type_id'] = 'event';
              }
            } else {
              // Default fallback
              print('⚠️ Using default fallback: "event"');
              jsonData['entity_type_id'] = 'event';
            }
          } catch (listError) {
            print('❌ Failed to list entity types: $listError');
            // Use a final hardcoded fallback that we know exists
            jsonData['entity_type_id'] = 'event';
          }
        }
      }
      
      // Make sure required fields are present
      if (!jsonData.containsKey('app_category_id') || jsonData['app_category_id'] == null) {
        // Default to social category (2) if missing
        jsonData['app_category_id'] = 2;
      }
      
      print('🔍 FINAL DATA TO INSERT:');
      jsonData.forEach((key, value) {
        print('  - $key: $value');
      });
      
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
    return executeQuery('listEntities', () async {
      var query = from('entities').select();
      if (userId != null) {
        query = query.eq('user_id', userId); 
      }
      if (appCategoryId != null) {
        query = query.eq('app_category_id', appCategoryId); 
      }
      if (subcategoryId != null) {
        query = query.eq('subcategory_id', subcategoryId);
      }
      final response = await query;
      return response.map((json) => BaseEntityModel.fromJson(json)).toList();
    });
  }

  @override
  Future<BaseEntityModel> updateEntity(BaseEntityModel entity) async {
    return executeQuery('updateEntity', () async {
      final response = await from('entities')
          .update(entity.toSupabaseJson())
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
