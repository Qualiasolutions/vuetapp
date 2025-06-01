import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/list_category_model.dart';
import 'package:vuet_app/models/list_item_model.dart';
import 'package:vuet_app/models/list_model.dart';
import 'package:vuet_app/repositories/list_repository.dart';
import 'package:vuet_app/services/auth_service.dart';
import 'package:vuet_app/utils/error_handler.dart';

/// Provider for the ListService
final listServiceProvider = Provider<ListService>((ref) {
  final repository = ref.watch(listRepositoryProvider);
  final authService = ref.watch(authServiceProvider);
  return ListService(repository: repository, authService: authService);
});

/// Service class for managing lists
class ListService {
  final ListRepository repository;
  final AuthService authService;

  ListService({required this.repository, required this.authService});

  /// Get the current user ID or throw an exception if not available
  String get _currentUserId {
    final userId = authService.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }
    return userId;
  }

  /// Get all lists for the current user
  Future<List<ListModel>> getLists() async {
    try {
      return await repository.fetchLists(userId: _currentUserId);
    } catch (e, st) {
      ErrorHandler.handleError('Error fetching lists', e, st);
      rethrow;
    }
  }

  /// Get planning lists for the current user
  Future<List<ListModel>> getPlanningLists() async {
    try {
      return await repository.fetchLists(
        userId: _currentUserId,
        listType: 'planning',
      );
    } catch (e, st) {
      ErrorHandler.handleError('Error fetching planning lists', e, st);
      rethrow;
    }
  }

  /// Get shopping lists for the current user
  Future<List<ListModel>> getShoppingLists() async {
    try {
      return await repository.fetchLists(
        userId: _currentUserId,
        listType: 'shopping',
      );
    } catch (e, st) {
      ErrorHandler.handleError('Error fetching shopping lists', e, st);
      rethrow;
    }
  }

  /// Get all list categories
  Future<List<ListCategoryModel>> getListCategories() async {
    try {
      return await repository.fetchListCategories();
    } catch (e, st) {
      ErrorHandler.handleError('Error fetching list categories', e, st);
      rethrow;
    }
  }

  /// Get a specific list by ID
  Future<ListModel?> getListById(String id) async {
    try {
      return await repository.fetchListById(id);
    } catch (e, st) {
      ErrorHandler.handleError('Error fetching list by ID: $id', e, st);
      rethrow;
    }
  }

  /// Get items for a specific list
  Future<List<ListItemModel>> getListItemsByListId(String listId) async {
    try {
      return await repository.fetchListItems(listId);
    } catch (e, st) {
      ErrorHandler.handleError('Error fetching list items for list ID: $listId', e, st);
      rethrow;
    }
  }

  /// Create a new list
  Future<ListModel> createList(ListModel list) async {
    try {
      await repository.createList(list);
      return list;
    } catch (e, st) {
      ErrorHandler.handleError('Error creating list', e, st);
      rethrow;
    }
  }

  /// Update an existing list
  Future<ListModel> updateList(ListModel list) async {
    try {
      await repository.updateList(list);
      return list;
    } catch (e, st) {
      ErrorHandler.handleError('Error updating list', e, st);
      rethrow;
    }
  }

  /// Delete a list by ID
  Future<void> deleteList(String id) async {
    try {
      await repository.deleteList(id);
    } catch (e, st) {
      ErrorHandler.handleError('Error deleting list: $id', e, st);
      rethrow;
    }
  }

  /// Create a new list category
  Future<ListCategoryModel> createListCategory(ListCategoryModel category) async {
    try {
      await repository.createListCategory(category);
      return category;
    } catch (e, st) {
      ErrorHandler.handleError('Error creating list category', e, st);
      rethrow;
    }
  }

  /// Update an existing list category
  Future<ListCategoryModel> updateListCategory(ListCategoryModel category) async {
    try {
      await repository.updateListCategory(category);
      return category;
    } catch (e, st) {
      ErrorHandler.handleError('Error updating list category', e, st);
      rethrow;
    }
  }

  /// Delete a list category by ID
  Future<void> deleteListCategory(String id) async {
    try {
      await repository.deleteListCategory(id);
    } catch (e, st) {
      ErrorHandler.handleError('Error deleting list category: $id', e, st);
      rethrow;
    }
  }

  /// Create a new list item
  Future<ListItemModel> createListItem(ListItemModel item) async {
    try {
      await repository.createListItem(item);
      return item;
    } catch (e, st) {
      ErrorHandler.handleError('Error creating list item', e, st);
      rethrow;
    }
  }

  /// Update an existing list item
  Future<ListItemModel> updateListItem(ListItemModel item) async {
    try {
      await repository.updateListItem(item);
      return item;
    } catch (e, st) {
      ErrorHandler.handleError('Error updating list item', e, st);
      rethrow;
    }
  }

  /// Delete a list item by ID
  Future<void> deleteListItem(String id) async {
    try {
      await repository.deleteListItem(id);
    } catch (e, st) {
      ErrorHandler.handleError('Error deleting list item: $id', e, st);
      rethrow;
    }
  }

  /// Toggle item completion status
  Future<void> toggleItemCompletion(String itemId, bool isCompleted) async {
    try {
      await repository.toggleItemCompletion(itemId, isCompleted);
    } catch (e, st) {
      ErrorHandler.handleError('Error toggling item completion', e, st);
      rethrow;
    }
  }

  /// Reorder list items
  Future<void> reorderListItems(String listId, List<String> itemIds) async {
    try {
      await repository.reorderListItems(listId, itemIds);
    } catch (e, st) {
      ErrorHandler.handleError('Error reordering list items', e, st);
      rethrow;
    }
  }

  /// Create a list from a template
  Future<ListModel> createListFromTemplate(String templateId, String name) async {
    try {
      return await repository.createListFromTemplate(templateId, _currentUserId, name);
    } catch (e, st) {
      ErrorHandler.handleError('Error creating list from template', e, st);
      rethrow;
    }
  }
}
