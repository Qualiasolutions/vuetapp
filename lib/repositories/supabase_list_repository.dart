import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vuet_app/config/supabase_config.dart';
import 'package:vuet_app/models/list_item_model.dart';
import 'package:vuet_app/models/list_model.dart';
import 'package:vuet_app/models/list_category_model.dart';
import 'package:vuet_app/models/list_template_model.dart';
import 'package:vuet_app/models/list_sublist_model.dart';
import 'package:vuet_app/repositories/list_repository.dart';
import 'package:vuet_app/utils/database_optimizer.dart';

// Provider for the SupabaseListRepository
final supabaseListRepositoryProvider = Provider<SupabaseListRepository>((ref) {
  return SupabaseListRepository();
});

class SupabaseListRepository implements ListRepository {
  late final SupabaseClient _client;

  SupabaseListRepository() {
    _client = SupabaseConfig.client;
  }

  @override
  Future<ListModel> createList(ListModel list) async {
    try {
      final response = await _client
          .from('lists')
          .insert(list.toSupabase())
          .select()
          .single();

      return ListModel.fromSupabase(response);
    } on PostgrestException catch (e) {
      throw Exception('Failed to create list: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create list: $e');
    }
  }

  @override
  Future<ListItemModel> createListItem(ListItemModel item) async {
    try {
      final response = await _client
          .from('list_items')
          .insert({
            'id': item.id,
            'list_id': item.listId,
            'sublist_id': item.sublistId,
            'name': item.name,
            'description': item.description,
            'is_completed': item.isCompleted,
            'sort_order': item.sortOrder,
            'quantity': item.quantity,
            'notes': item.notes,
            'linked_task_id': item.linkedTaskId,
            'metadata': item.metadata,
            'created_at': item.createdAt.toIso8601String(),
            'updated_at': item.updatedAt.toIso8601String(),
          })
          .select()
          .single();

      return ListItemModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Failed to create list item: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create list item: $e');
    }
  }

  // =============================================================================
  // NEW MODERNIZED METHODS - LIST CATEGORIES
  // =============================================================================

  @override
  Future<List<ListCategoryModel>> fetchListCategories() async {
    try {
      final response = await _client
          .from('list_categories')
          .select()
          .eq('is_active', true)
          .order('sort_order', ascending: true)
          .order('name', ascending: true);

      return response.map((json) => ListCategoryModel.fromJson(json)).toList();
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch list categories: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch list categories: $e');
    }
  }

  @override
  Future<ListCategoryModel> createListCategory(ListCategoryModel category) async {
    try {
      final response = await _client
          .from('list_categories')
          .insert({
            'name': category.name,
            'icon': category.icon,
            'color': category.color,
            'description': category.description,
            'sort_order': category.order,
            'is_custom': category.isCustom,
            'suggested_templates': category.suggestedTemplates,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      return ListCategoryModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Failed to create list category: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create list category: $e');
    }
  }

  // =============================================================================
  // NEW MODERNIZED METHODS - LIST TEMPLATES
  // =============================================================================

  @override
  Future<List<ListTemplateModel>> fetchListTemplates() async {
    try {
      final response = await _client
          .from('list_templates')
          .select()
          .order('popularity', ascending: false)
          .order('name', ascending: true);

      return response.map((json) => ListTemplateModel.fromJson(json)).toList();
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch list templates: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch list templates: $e');
    }
  }

  @override
  Future<ListTemplateModel> createListTemplate(ListTemplateModel template) async {
    try {
      final response = await _client
          .from('list_templates')
          .insert({
            'name': template.name,
            'description': template.description,
            'category_id': template.categoryId,
            'icon': template.icon,
            'color': template.color,
            'sublists': template.sublists,
            'tags': template.tags,
            'is_premium': template.isPremium,
            'is_system_template': template.isSystemTemplate,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      return ListTemplateModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Failed to create list template: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create list template: $e');
    }
  }

  // =============================================================================
  // NEW MODERNIZED METHODS - LIST SUBLISTS
  // =============================================================================

  @override
  Future<List<ListSublist>> fetchListSublists(String listId) async {
    try {
      final response = await _client
          .from('list_sublists')
          .select()
          .eq('list_id', listId)
          .order('sort_order', ascending: true)
          .order('created_at', ascending: true);

      return response.map((json) => ListSublist.fromSupabase(json)).toList();
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch list sublists: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch list sublists: $e');
    }
  }

  @override
  Future<ListSublist> createListSublist(ListSublist sublist) async {
    try {
      final response = await _client
          .from('list_sublists')
          .insert(sublist.toSupabase())
          .select()
          .single();

      return ListSublist.fromSupabase(response);
    } on PostgrestException catch (e) {
      throw Exception('Failed to create list sublist: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create list sublist: $e');
    }
  }

  @override
  Future<ListSublist> updateListSublist(ListSublist sublist) async {
    try {
      final response = await _client
          .from('list_sublists')
          .update(sublist.toSupabase())
          .eq('id', sublist.id)
          .select()
          .single();

      return ListSublist.fromSupabase(response);
    } on PostgrestException catch (e) {
      throw Exception('Failed to update list sublist: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update list sublist: $e');
    }
  }

  @override
  Future<void> deleteListSublist(String sublistId) async {
    try {
      await _client
          .from('list_sublists')
          .delete()
          .eq('id', sublistId);
    } on PostgrestException catch (e) {
      throw Exception('Failed to delete list sublist: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete list sublist: $e');
    }
  }

  @override
  Future<void> deleteList(String listId) async {
    try {
      await _client
          .from('lists')
          .delete()
          .eq('id', listId);
    } on PostgrestException catch (e) {
      throw Exception('Failed to delete list: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete list: $e');
    }
  }

  @override
  Future<void> deleteListItem(String itemId) async {
    try {
      await _client
          .from('list_items')
          .delete()
          .eq('id', itemId);
    } on PostgrestException catch (e) {
      throw Exception('Failed to delete list item: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete list item: $e');
    }
  }

  @override
  Future<ListModel?> fetchListById(String listId) async {
    try {
      final response = await _client
          .from('lists')
          .select()
          .eq('id', listId)
          .maybeSingle();

      if (response == null) return null;
      return ListModel.fromSupabase(response);
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch list: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch list: $e');
    }
  }

  @override
  Future<List<ListItemModel>> fetchListItems(String listId) async {
    try {
      final response = await _client
          .from('list_items')
          .select()
          .eq('list_id', listId)
          .order('sort_order', ascending: true)
          .order('created_at', ascending: true);

      return response.map((json) => ListItemModel.fromJson(json)).toList();
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch list items: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch list items: $e');
    }
  }

  @override
  Future<List<ListModel>> fetchLists({
    required String userId,
    String? listType,
  }) async {
    return await DatabaseOptimizer.executeWithTracking(
      'fetch_lists',
      () async {
        try {
          var query = _client
              .from('lists')
              .select()
              .eq('owner_id', userId);

          if (listType != null) {
            if (listType == 'shopping') {
              // Use new list_type_new field if available, fallback to is_shopping_list
              query = query.or('list_type_new.eq.shopping,and(is_shopping_list.eq.true,list_type_new.is.null)');
            } else if (listType == 'planning') {
              query = query.or('list_type_new.eq.planning,and(is_shopping_list.eq.false,is_template.eq.false,list_type_new.is.null)');
            } else if (listType == 'delegated') {
              query = query.or('list_type_new.eq.delegated,is_delegated.eq.true');
            } else if (listType == 'template') {
              query = query.eq('is_template', true);
            }
          }

          final response = await query.order('created_at', ascending: false);

          return response.map((json) => ListModel.fromSupabase(json)).toList();
        } on PostgrestException catch (e) {
          throw Exception('Failed to fetch lists: ${e.message}');
        } catch (e) {
          throw Exception('Failed to fetch lists: $e');
        }
      },
      enableCache: true,
      cacheKey: 'lists_${userId}_${listType ?? 'all'}',
    );
  }

  @override
  Future<ListModel> updateList(ListModel list) async {
    try {
      final updateData = list.toSupabase();
      // Remove id from update data
      updateData.remove('id');
      // Ensure updated_at is current
      updateData['updated_at'] = DateTime.now().toIso8601String();

      final response = await _client
          .from('lists')
          .update(updateData)
          .eq('id', list.id)
          .select()
          .single();

      return ListModel.fromSupabase(response);
    } on PostgrestException catch (e) {
      throw Exception('Failed to update list: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update list: $e');
    }
  }

  @override
  Future<ListItemModel> updateListItem(ListItemModel item) async {
    try {
      final response = await _client
          .from('list_items')
          .update({
            'name': item.name,
            'description': item.description,
            'is_completed': item.isCompleted,
            'sort_order': item.sortOrder,
            'quantity': item.quantity,
            'notes': item.notes,
            'linked_task_id': item.linkedTaskId,
            'sublist_id': item.sublistId,
            'metadata': item.metadata,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', item.id)
          .select()
          .single();

      return ListItemModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Failed to update list item: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update list item: $e');
    }
  }

  @override
  Future<void> reorderListItems(String listId, List<String> itemIds) async {
    try {
      // Use Supabase batch operations for better performance
      final List<Map<String, dynamic>> updates = [];
      
      for (int i = 0; i < itemIds.length; i++) {
        updates.add({
          'id': itemIds[i],
          'sort_order': i,
          'updated_at': DateTime.now().toIso8601String(),
        });
      }

      // Perform batch update using upsert
      await _client
          .from('list_items')
          .upsert(updates);
    } on PostgrestException catch (e) {
      throw Exception('Failed to reorder list items: ${e.message}');
    } catch (e) {
      throw Exception('Failed to reorder list items: $e');
    }
  }

  @override
  Future<void> toggleItemCompletion(String itemId, bool isCompleted) async {
    try {
      await _client
          .from('list_items')
          .update({
            'is_completed': isCompleted,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', itemId);
    } on PostgrestException catch (e) {
      throw Exception('Failed to toggle item completion: ${e.message}');
    } catch (e) {
      throw Exception('Failed to toggle item completion: $e');
    }
  }

  @override
  Future<List<ListModel>> fetchTemplates(String userId) async {
    try {
      final response = await _client
          .from('lists')
          .select()
          .eq('owner_id', userId)
          .eq('is_template', true)
          .order('created_at', ascending: false);

      return response.map((json) => ListModel.fromSupabase(json)).toList();
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch templates: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch templates: $e');
    }
  }

  @override
  Future<ListModel> createListFromTemplate(String templateId, String userId, String name) async {
    try {
      // First, fetch the template (could be from lists table or list_templates table)
      ListModel template;
      
      // Try fetching from list_templates first
      try {
        final templateResponse = await _client
            .from('list_templates')
            .select()
            .eq('id', templateId)
            .single();
        
        // Convert template to list model
        final templateModel = ListTemplateModel.fromJson(templateResponse);
        template = ListModel.create(
          name: templateModel.name,
          description: templateModel.description,
          ownerId: userId,
          listCategoryId: templateModel.categoryId,
          templateId: templateId,
          createdFromTemplate: true,
        );
      } catch (e) {
        // Fallback to lists table
        final templateResponse = await _client
            .from('lists')
            .select()
            .eq('id', templateId)
            .single();

        template = ListModel.fromSupabase(templateResponse);
      }

      // Create new list from template using the factory method
      final newList = ListModel.fromTemplate(
        template: template,
        ownerId: userId,
        customName: name,
      );

      // Insert the new list
      final newListResponse = await _client
          .from('lists')
          .insert(newList.toSupabase())
          .select()
          .single();

      final createdList = ListModel.fromSupabase(newListResponse);

      // Copy template items if it's a list template, or copy existing list items
      List<dynamic> templateItemsResponse = [];
      
      try {
        // Try to get items from the original template list
        templateItemsResponse = await _client
            .from('list_items')
            .select()
            .eq('list_id', templateId)
            .order('sort_order', ascending: true);
      } catch (e) {
        // Template might not have items
      }

      if (templateItemsResponse.isNotEmpty) {
        final newItems = templateItemsResponse.map((item) => {
          'id': null, // Let Supabase generate new IDs
          'list_id': createdList.id,
          'name': item['name'],
          'description': item['description'],
          'quantity': item['quantity'],
          'sort_order': item['sort_order'],
          'is_completed': false, // Reset completion status
          'notes': item['notes'],
          'sublist_id': item['sublist_id'],
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        }).toList();

        await _client
            .from('list_items')
            .insert(newItems);
      }

      // Copy sublists if they exist
      try {
        final sublistsResponse = await _client
            .from('list_sublists')
            .select()
            .eq('list_id', templateId)
            .order('sort_order', ascending: true);
            
        if (sublistsResponse.isNotEmpty) {
          final newSublists = sublistsResponse.map((sublist) => {
            'id': null, // Let Supabase generate new IDs
            'list_id': createdList.id,
            'title': sublist['title'],
            'description': sublist['description'],
            'sort_order': sublist['sort_order'],
            'color': sublist['color'],
            'icon': sublist['icon'],
            'is_completed': false, // Reset completion
            'total_items': 0, // Will be updated as items are added
            'completed_items': 0,
            'completion_percentage': 0.0,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          }).toList();

          await _client
              .from('list_sublists')
              .insert(newSublists);
        }
      } catch (e) {
        // Template might not have sublists
      }

      return createdList;
    } on PostgrestException catch (e) {
      throw Exception('Failed to create list from template: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create list from template: $e');
    }
  }
  
  // Missing interface methods
  @override
  Future<ListCategoryModel> updateListCategory(ListCategoryModel category) async {
    try {
      final response = await _client
          .from('list_categories')
          .update({
            'name': category.name,
            'icon': category.icon,
            'color': category.color,
            'description': category.description,
            'sort_order': category.order,
            'is_custom': category.isCustom,
            'suggested_templates': category.suggestedTemplates,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', category.id)
          .select()
          .single();

      return ListCategoryModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Failed to update list category: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update list category: $e');
    }
  }

  @override
  Future<void> deleteListCategory(String id) async {
    try {
      await _client
          .from('list_categories')
          .delete()
          .eq('id', id);
    } on PostgrestException catch (e) {
      throw Exception('Failed to delete list category: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete list category: $e');
    }
  }

  // Alias methods for backward compatibility
  @override
  Future<List<ListModel>> getLists() async {
    // Use current user context
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];
    return fetchLists(userId: userId);
  }

  @override
  Future<List<ListCategoryModel>> getListCategories() async {
    return fetchListCategories();
  }

  @override
  Future<List<ListItemModel>> getListItems() async {
    // Return empty list as this requires a specific list ID
    // Service layer should call fetchListItems(listId) directly
    return [];
  }
}
