import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vuet_app/models/lists/list_entry_model.dart';
import 'package:vuet_app/models/lists/planning_list_model.dart';
import 'package:vuet_app/models/lists/shopping_list_model.dart';
import 'package:vuet_app/config/supabase_config.dart';

/// Repository for managing lists data
class ListsRepository {
  final SupabaseClient _supabaseClient = SupabaseConfig.client;

  // List Entry Operations
  Future<ListEntry?> getListEntry(String id) async {
    try {
      final response = await _supabaseClient
          .from('list_entries')
          .select()
          .eq('id', id)
          .single();
      
      return ListEntry.fromJson(response);
    } catch (e) {
      debugPrint('Error fetching list entry: $e');
      return null;
    }
  }

  Future<List<ListEntry>> getListEntries(String listId) async {
    try {
      final response = await _supabaseClient
          .from('list_entries')
          .select()
          .eq('list', listId);
      
      return (response as List).map((data) => ListEntry.fromJson(data)).toList();
    } catch (e) {
      debugPrint('Error fetching list entries: $e');
      return [];
    }
  }

  Future<ListEntry?> createListEntry(ListEntryCreateRequest request) async {
    try {
      final response = await _supabaseClient
          .from('list_entries')
          .insert(request.toJson())
          .select()
          .single();
      
      return ListEntry.fromJson(response);
    } catch (e) {
      debugPrint('Error creating list entry: $e');
      return null;
    }
  }

  Future<ListEntry?> updateListEntry(ListEntryUpdateRequest request) async {
    try {
      final response = await _supabaseClient
          .from('list_entries')
          .update(request.toJson())
          .eq('id', request.id)
          .select()
          .single();
      
      return ListEntry.fromJson(response);
    } catch (e) {
      debugPrint('Error updating list entry: $e');
      return null;
    }
  }

  Future<bool> deleteListEntry(String id) async {
    try {
      await _supabaseClient
          .from('list_entries')
          .delete()
          .eq('id', id);
      
      return true;
    } catch (e) {
      debugPrint('Error deleting list entry: $e');
      return false;
    }
  }

  // Planning List Operations
  Future<List<PlanningList>> getPlanningLists() async {
    try {
      final response = await _supabaseClient
          .from('planning_lists')
          .select();
      
      return (response as List).map((data) => PlanningList.fromJson(data)).toList();
    } catch (e) {
      debugPrint('Error fetching planning lists: $e');
      return [];
    }
  }

  Future<PlanningList?> createPlanningList({
    required String category,
    required String name,
    required List<String> members,
  }) async {
    try {
      final response = await _supabaseClient
          .from('planning_lists')
          .insert({
            'category': category,
            'name': name,
            'members': members,
          })
          .select()
          .single();
      
      return PlanningList.fromJson(response);
    } catch (e) {
      debugPrint('Error creating planning list: $e');
      return null;
    }
  }

  Future<bool> deletePlanningList(String id) async {
    try {
      await _supabaseClient
          .from('planning_lists')
          .delete()
          .eq('id', id);
      
      return true;
    } catch (e) {
      debugPrint('Error deleting planning list: $e');
      return false;
    }
  }

  // Planning Sublist Operations
  Future<List<PlanningSublist>> getPlanningSublistsByList(String listId) async {
    try {
      final response = await _supabaseClient
          .from('planning_sublists')
          .select()
          .eq('list', listId);
      
      return (response as List).map((data) => PlanningSublist.fromJson(data)).toList();
    } catch (e) {
      debugPrint('Error fetching planning sublists: $e');
      return [];
    }
  }

  Future<PlanningSublist?> createPlanningSublist({
    required String listId,
    required String title,
  }) async {
    try {
      final response = await _supabaseClient
          .from('planning_sublists')
          .insert({
            'list': listId,
            'title': title,
          })
          .select()
          .single();
      
      return PlanningSublist.fromJson(response);
    } catch (e) {
      debugPrint('Error creating planning sublist: $e');
      return null;
    }
  }

  Future<bool> deletePlanningSublist(String id) async {
    try {
      await _supabaseClient
          .from('planning_sublists')
          .delete()
          .eq('id', id);
      
      return true;
    } catch (e) {
      debugPrint('Error deleting planning sublist: $e');
      return false;
    }
  }

  // Planning List Items Operations
  Future<List<PlanningListItem>> getPlanningListItemsBySublist(String sublistId) async {
    try {
      final response = await _supabaseClient
          .from('planning_list_items')
          .select()
          .eq('sublist', sublistId);
      
      return (response as List).map((data) => PlanningListItem.fromJson(data)).toList();
    } catch (e) {
      debugPrint('Error fetching planning list items: $e');
      return [];
    }
  }

  Future<PlanningListItem?> createPlanningListItem({
    required String sublistId,
    required String title,
  }) async {
    try {
      final response = await _supabaseClient
          .from('planning_list_items')
          .insert({
            'sublist': sublistId,
            'title': title,
            'checked': false,
          })
          .select()
          .single();
      
      return PlanningListItem.fromJson(response);
    } catch (e) {
      debugPrint('Error creating planning list item: $e');
      return null;
    }
  }

  Future<PlanningListItem?> togglePlanningListItemChecked(String id, bool checked) async {
    try {
      final response = await _supabaseClient
          .from('planning_list_items')
          .update({
            'checked': checked,
          })
          .eq('id', id)
          .select()
          .single();
      
      return PlanningListItem.fromJson(response);
    } catch (e) {
      debugPrint('Error updating planning list item: $e');
      return null;
    }
  }

  Future<bool> deletePlanningListItem(String id) async {
    try {
      await _supabaseClient
          .from('planning_list_items')
          .delete()
          .eq('id', id);
      
      return true;
    } catch (e) {
      debugPrint('Error deleting planning list item: $e');
      return false;
    }
  }

  // Shopping List Operations
  Future<List<ShoppingList>> getShoppingLists() async {
    try {
      final response = await _supabaseClient
          .from('shopping_lists')
          .select();
      
      return (response as List).map((data) => ShoppingList.fromJson(data)).toList();
    } catch (e) {
      debugPrint('Error fetching shopping lists: $e');
      return [];
    }
  }

  Future<ShoppingList?> createShoppingList({
    required String name,
    required List<String> members,
  }) async {
    try {
      final response = await _supabaseClient
          .from('shopping_lists')
          .insert({
            'name': name,
            'members': members,
          })
          .select()
          .single();
      
      return ShoppingList.fromJson(response);
    } catch (e) {
      debugPrint('Error creating shopping list: $e');
      return null;
    }
  }

  Future<bool> deleteShoppingList(String id) async {
    try {
      await _supabaseClient
          .from('shopping_lists')
          .delete()
          .eq('id', id);
      
      return true;
    } catch (e) {
      debugPrint('Error deleting shopping list: $e');
      return false;
    }
  }

  // Shopping List Items Operations
  Future<List<ShoppingListItem>> getShoppingListItems(String listId) async {
    try {
      final response = await _supabaseClient
          .from('shopping_list_items')
          .select()
          .eq('list', listId);
      
      return (response as List).map((data) => ShoppingListItem.fromJson(data)).toList();
    } catch (e) {
      debugPrint('Error fetching shopping list items: $e');
      return [];
    }
  }

  Future<ShoppingListItem?> createShoppingListItem({
    required String listId,
    String? storeId,
    required String title,
  }) async {
    try {
      final response = await _supabaseClient
          .from('shopping_list_items')
          .insert({
            'list': listId,
            'store': storeId,
            'title': title,
            'checked': false,
          })
          .select()
          .single();
      
      return ShoppingListItem.fromJson(response);
    } catch (e) {
      debugPrint('Error creating shopping list item: $e');
      return null;
    }
  }

  Future<ShoppingListItem?> toggleShoppingListItemChecked(String id, bool checked) async {
    try {
      final response = await _supabaseClient
          .from('shopping_list_items')
          .update({
            'checked': checked,
          })
          .eq('id', id)
          .select()
          .single();
      
      return ShoppingListItem.fromJson(response);
    } catch (e) {
      debugPrint('Error updating shopping list item: $e');
      return null;
    }
  }

  Future<bool> deleteShoppingListItem(String id) async {
    try {
      await _supabaseClient
          .from('shopping_list_items')
          .delete()
          .eq('id', id);
      
      return true;
    } catch (e) {
      debugPrint('Error deleting shopping list item: $e');
      return false;
    }
  }

  // Shopping List Stores Operations
  Future<List<ShoppingListStore>> getShoppingListStores() async {
    try {
      final response = await _supabaseClient
          .from('shopping_list_stores')
          .select();
      
      return (response as List).map((data) => ShoppingListStore.fromJson(data)).toList();
    } catch (e) {
      debugPrint('Error fetching shopping list stores: $e');
      return [];
    }
  }

  Future<ShoppingListStore?> createShoppingListStore({
    required String name,
    required String createdBy,
  }) async {
    try {
      final response = await _supabaseClient
          .from('shopping_list_stores')
          .insert({
            'name': name,
            'created_by': createdBy,
          })
          .select()
          .single();
      
      return ShoppingListStore.fromJson(response);
    } catch (e) {
      debugPrint('Error creating shopping list store: $e');
      return null;
    }
  }

  Future<bool> deleteShoppingListStore(String id) async {
    try {
      await _supabaseClient
          .from('shopping_list_stores')
          .delete()
          .eq('id', id);
      
      return true;
    } catch (e) {
      debugPrint('Error deleting shopping list store: $e');
      return false;
    }
  }
}
