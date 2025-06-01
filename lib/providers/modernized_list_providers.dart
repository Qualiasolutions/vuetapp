import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/list_category_model.dart';
import 'package:vuet_app/models/list_item_model.dart';
import 'package:vuet_app/models/list_model.dart';
import 'package:vuet_app/repositories/list_repository.dart';
import 'package:vuet_app/repositories/supabase_list_repository.dart';
import 'package:vuet_app/services/auth_service.dart';
import 'package:vuet_app/services/list_service.dart';
import 'package:vuet_app/utils/error_handler.dart';

/// Provider for ListService
final listServiceProvider = Provider<ListService>((ref) {
  final repository = ref.watch(supabaseListRepositoryProvider);
  final authService = ref.watch(authServiceProvider);
  return ListService(repository: repository, authService: authService);
});

/// Provider for all lists
final allListsProvider = FutureProvider<List<ListModel>>((ref) async {
  final repository = ref.watch(listRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);
  
  if (userId == null) return [];
  
  return repository.fetchLists(userId: userId);
});

/// Provider for planning lists
final planningListsProvider = FutureProvider<List<ListModel>>((ref) async {
  final repository = ref.watch(listRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);
  
  if (userId == null) return [];
  
  return repository.fetchLists(userId: userId, listType: 'planning');
});

/// Provider for shopping lists
final shoppingListsProvider = FutureProvider<List<ListModel>>((ref) async {
  final repository = ref.watch(listRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);
  
  if (userId == null) return [];
  
  return repository.fetchLists(userId: userId, listType: 'shopping');
});

/// Provider for delegated lists
final delegatedListsProvider = FutureProvider<List<ListModel>>((ref) async {
  final repository = ref.watch(listRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);
  
  if (userId == null) return [];
  
  return repository.fetchLists(userId: userId, listType: 'delegated');
});

/// Provider for list categories
final listCategoriesProvider = FutureProvider<List<ListCategoryModel>>((ref) async {
  final listService = ref.watch(listServiceProvider);
  try {
    return await listService.getListCategories();
  } catch (e, st) {
    ErrorHandler.handleError('Failed to fetch list categories', e, st);
    rethrow;
  }
});

/// Provider family for a single list by ID
final listByIdProviderFamily = FutureProvider.family<ListModel?, String>((ref, listId) async {
  final repository = ref.watch(listRepositoryProvider);
  return repository.fetchListById(listId);
});

/// Provider family for list items by list ID
final listItemsProviderFamily = FutureProvider.family<List<ListItemModel>, String>((ref, listId) async {
  final repository = ref.watch(listRepositoryProvider);
  return repository.fetchListItems(listId);
});

/// Notifier for managing lists state
class ListNotifier extends StateNotifier<AsyncValue<List<ListModel>>> {
  final ListRepository _repository;
  final String? _userId;

  ListNotifier(this._repository, this._userId) : super(const AsyncValue.loading()) {
    _loadLists();
  }

  Future<void> _loadLists() async {
    if (_userId == null) {
      state = const AsyncValue.data([]);
      return;
    }

    try {
      state = const AsyncValue.loading();
      final lists = await _repository.fetchLists(userId: _userId);
      state = AsyncValue.data(lists);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() async {
    await _loadLists();
  }

  Future<void> createList(ListModel list) async {
    try {
      await _repository.createList(list);
      await _loadLists(); // Refresh the list
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateList(ListModel list) async {
    try {
      await _repository.updateList(list);
      await _loadLists(); // Refresh the list
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteList(String listId) async {
    try {
      await _repository.deleteList(listId);
      await _loadLists(); // Refresh the list
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> createListCategory(ListCategoryModel category) async {
    try {
      await _repository.createListCategory(category);
    } catch (e, st) {
      ErrorHandler.handleError('Failed to create list category in notifier', e, st);
    }
  }

  Future<void> updateListCategory(ListCategoryModel category) async {
    try {
      await _repository.updateListCategory(category);
    } catch (e, st) {
      ErrorHandler.handleError('Failed to update list category in notifier', e, st);
    }
  }

  Future<void> deleteListCategory(String id) async {
    try {
      await _repository.deleteListCategory(id);
    } catch (e, st) {
      ErrorHandler.handleError('Failed to delete list category in notifier', e, st);
    }
  }

  Future<void> createListItem(ListItemModel item) async {
    try {
      await _repository.createListItem(item);
    } catch (e, st) {
      ErrorHandler.handleError('Failed to create list item in notifier', e, st);
    }
  }

  Future<void> updateListItem(ListItemModel item) async {
    try {
      await _repository.updateListItem(item);
      // Note: StateNotifier doesn't have direct access to ref for invalidation
    } catch (e, st) {
      ErrorHandler.handleError('Failed to update list item in notifier', e, st);
    }
  }

  Future<void> deleteListItem(String id, String listId) async {
    try {
      await _repository.deleteListItem(id);
      // Note: StateNotifier doesn't have direct access to ref for invalidation
    } catch (e, st) {
      ErrorHandler.handleError('Failed to delete list item in notifier', e, st);
    }
  }
}

/// Provider for ListNotifier
final listNotifierProvider = StateNotifierProvider<ListNotifier, AsyncValue<List<ListModel>>>((ref) {
  final repository = ref.watch(listRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);
  return ListNotifier(repository, userId);
});

/// Provider for current user ID
final currentUserIdProvider = Provider<String?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.currentUser?.id;
});

/// Provider for list repository
final listRepositoryProvider = Provider<ListRepository>((ref) {
  return ref.watch(supabaseListRepositoryProvider);
});
