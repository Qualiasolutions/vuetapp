import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/list_model.dart';
import 'package:vuet_app/models/list_item_model.dart';
import 'package:vuet_app/models/list_category_model.dart';
import 'package:vuet_app/models/list_template_model.dart';
import 'package:vuet_app/models/list_sublist_model.dart';
import 'package:vuet_app/repositories/supabase_list_repository.dart';

// Provider for the ListRepository implementation
// This re-exports the provider from supabase_list_repository.dart
final listRepositoryProvider = Provider<ListRepository>((ref) {
  return ref.watch(supabaseListRepositoryProvider);
});

abstract class ListRepository {
  // Lists CRUD
  Future<List<ListModel>> fetchLists({
    required String userId,
    String? listType,
  });
  
  Future<ListModel?> fetchListById(String listId);
  
  Future<ListModel> createList(ListModel list);
  
  Future<ListModel> updateList(ListModel list);
  
  Future<void> deleteList(String listId);
  
  // List Items CRUD
  Future<List<ListItemModel>> fetchListItems(String listId);
  
  Future<ListItemModel> createListItem(ListItemModel item);
  
  Future<ListItemModel> updateListItem(ListItemModel item);
  
  Future<void> deleteListItem(String itemId);
  
  // Batch operations
  Future<void> toggleItemCompletion(String itemId, bool isCompleted);
  
  Future<void> reorderListItems(String listId, List<String> itemIds);
  
  // Templates (legacy from lists table)
  Future<List<ListModel>> fetchTemplates(String userId);
  
  Future<ListModel> createListFromTemplate(String templateId, String userId, String name);

  // =============================================================================
  // NEW MODERNIZED METHODS
  // =============================================================================
  
  // List Categories
  Future<List<ListCategoryModel>> fetchListCategories();
  
  Future<ListCategoryModel> createListCategory(ListCategoryModel category);
  
  Future<ListCategoryModel> updateListCategory(ListCategoryModel category);
  
  Future<void> deleteListCategory(String categoryId);
  
  // Convenience methods for providers
  Future<List<ListModel>> getLists();
  
  Future<List<ListCategoryModel>> getListCategories();
  
  Future<List<ListItemModel>> getListItems();
  
  // List Templates (from list_templates table)
  Future<List<ListTemplateModel>> fetchListTemplates();
  
  Future<ListTemplateModel> createListTemplate(ListTemplateModel template);
  
  // List Sublists
  Future<List<ListSublist>> fetchListSublists(String listId);
  
  Future<ListSublist> createListSublist(ListSublist sublist);
  
  Future<ListSublist> updateListSublist(ListSublist sublist);
  
  Future<void> deleteListSublist(String sublistId);
}
