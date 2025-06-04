import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/list_category_model.dart';
import 'package:vuet_app/models/list_item_model.dart';
import 'package:vuet_app/models/list_model.dart';
import 'package:vuet_app/repositories/list_repository.dart';
import 'package:vuet_app/repositories/supabase_list_repository.dart';
import 'package:vuet_app/services/auth_service.dart';
import 'package:vuet_app/utils/error_handler.dart';

/// Provider for ListService
final listServiceProvider = ChangeNotifierProvider<ListService>((ref) {
  final repository = ref.watch(supabaseListRepositoryProvider);
  final authService = ref.watch(authServiceProvider);
  return ListService(repository: repository, authService: authService);
});

/// Service for managing lists in the application
class ListService extends ChangeNotifier {
  final ListRepository _repository;
  final AuthService _authService;

  List<ListModel> _lists = [];
  List<ListCategoryModel> _listCategories = [];
  List<ListItemModel> _listItems = [];

  List<ListModel> get lists => _lists;
  List<ListCategoryModel> get listCategories => _listCategories;
  List<ListItemModel> get listItems => _listItems;

  ListService({
    required ListRepository repository,
    required AuthService authService,
  })  : _repository = repository,
        _authService = authService {
    _loadLists();
    _loadListCategories();
    _loadListItems();
  }

  String? get _userId => _authService.currentUser?.id;
  bool get _isAuthenticated => _userId != null;

  Future<void> _loadLists() async {
    if (!_isAuthenticated) return;
    try {
      _lists = await _repository.getLists();
      notifyListeners();
    } catch (e) {
      ErrorHandler.handleError('Failed to load lists', e);
    }
  }

  Future<void> _loadListCategories() async {
    if (!_isAuthenticated) return;
    try {
      _listCategories = await _repository.getListCategories();
      notifyListeners();
    } catch (e) {
      ErrorHandler.handleError('Failed to load list categories', e);
    }
  }

  Future<void> _loadListItems() async {
    if (!_isAuthenticated) return;
    try {
      _listItems = await _repository.getListItems();
      notifyListeners();
    } catch (e) {
      ErrorHandler.handleError('Failed to load list items', e);
    }
  }

  Future<void> refreshAll() async {
    await _loadLists();
    await _loadListCategories();
    await _loadListItems();
  }

  // List operations
  Future<String?> createList(ListModel list) async {
    if (!_isAuthenticated) return null;
    try {
      // Create a new instance with the current user ID as owner
      final newList = ListModel(
        id: list.id,
        name: list.name,
        ownerId: _userId!,
        userId: _userId!, // Required parameter
        type: list.type,
        categoryId: list.categoryId,
        isTemplate: list.isTemplate,
        isShoppingList: list.isShoppingList,
        isDelegated: list.isDelegated,
        description: list.description,
        metadata: list.metadata,
        createdAt: list.createdAt,
        updatedAt: list.updatedAt,
        templateId: list.templateId,
        createdFromTemplate: list.createdFromTemplate,
      );
      
      // Get the ID string from the repository result
      final result = await _repository.createList(newList);
      await _loadLists();
      return result.id;
    } catch (e) {
      ErrorHandler.handleError('Failed to create list', e);
      return null;
    }
  }

  Future<bool> updateList(ListModel list) async {
    if (!_isAuthenticated) return false;
    try {
      await _repository.updateList(list);
      await _loadLists();
      return true;
    } catch (e) {
      ErrorHandler.handleError('Failed to update list', e);
      return false;
    }
  }

  Future<bool> deleteList(String id) async {
    if (!_isAuthenticated) return false;
    try {
      await _repository.deleteList(id);
      await _loadLists();
      return true;
    } catch (e) {
      ErrorHandler.handleError('Failed to delete list', e);
      return false;
    }
  }

  // List Category operations
  Future<String?> createListCategory(ListCategoryModel category) async {
    if (!_isAuthenticated) return null;
    try {
      // Create a new instance (ListCategoryModel doesn't have userId)
      final newCategory = ListCategoryModel(
        id: category.id,
        name: category.name,
        icon: category.icon,
        color: category.color,
        description: category.description,
        order: category.order,
        isCustom: category.isCustom,
        suggestedTemplates: category.suggestedTemplates,
        createdAt: category.createdAt,
        updatedAt: category.updatedAt,
      );
      
      // Get the ID string from the repository result
      final result = await _repository.createListCategory(newCategory);
      await _loadListCategories();
      return result.id;
    } catch (e) {
      ErrorHandler.handleError('Failed to create list category', e);
      return null;
    }
  }

  Future<bool> updateListCategory(ListCategoryModel category) async {
    if (!_isAuthenticated) return false;
    try {
      await _repository.updateListCategory(category);
      await _loadListCategories();
      return true;
    } catch (e) {
      ErrorHandler.handleError('Failed to update list category', e);
      return false;
    }
  }

  Future<bool> deleteListCategory(String id) async {
    if (!_isAuthenticated) return false;
    try {
      await _repository.deleteListCategory(id);
      await _loadListCategories();
      return true;
    } catch (e) {
      ErrorHandler.handleError('Failed to delete list category', e);
      return false;
    }
  }

  // List Item operations
  Future<String?> createListItem(ListItemModel item) async {
    if (!_isAuthenticated) return null;
    try {
      // Create a new instance directly (ListItemModel doesn't have userId)
      final newItem = ListItemModel(
        id: item.id,
        listId: item.listId,
        name: item.name,
        description: item.description,
        isCompleted: item.isCompleted,
        sortOrder: item.sortOrder,
        quantity: item.quantity,
        notes: item.notes,
        linkedTaskId: item.linkedTaskId,
        sublistId: item.sublistId,
        metadata: item.metadata,
        createdAt: item.createdAt,
        updatedAt: item.updatedAt,
      );
      
      // Get the ID string from the repository result
      final result = await _repository.createListItem(newItem);
      await _loadListItems();
      return result.id;
    } catch (e) {
      ErrorHandler.handleError('Failed to create list item', e);
      return null;
    }
  }

  Future<bool> updateListItem(ListItemModel item) async {
    if (!_isAuthenticated) return false;
    try {
      await _repository.updateListItem(item);
      await _loadListItems();
      return true;
    } catch (e) {
      ErrorHandler.handleError('Failed to update list item', e);
      return false;
    }
  }

  Future<bool> deleteListItem(String id) async {
    if (!_isAuthenticated) return false;
    try {
      await _repository.deleteListItem(id);
      await _loadListItems();
      return true;
    } catch (e) {
      ErrorHandler.handleError('Failed to delete list item', e);
      return false;
    }
  }

  // Filtered getters
  List<ListModel> getListsByCategoryId(String categoryId) {
    return _lists.where((list) => list.categoryId == categoryId).toList();
  }

  List<ListItemModel> getListItemsByListId(String listId) {
    return _listItems.where((item) => item.listId == listId).toList();
  }

  @override
  void dispose() {
    // No stream controllers to dispose in this service directly
    super.dispose();
  }
}

// ============================================================================
// MODERN PROVIDERS FOR UI COMPONENTS
// ============================================================================

/// Provider for current user ID
final currentUserIdProvider = Provider<String?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.currentUser?.id;
});

/// Provider for list repository
final listRepositoryProvider = Provider<ListRepository>((ref) {
  return ref.watch(supabaseListRepositoryProvider);
});

/// Provider for all lists
final allListsProvider = FutureProvider<List<ListModel>>((ref) async {
  final repository = ref.watch(listRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);
  
  if (userId == null) return [];
  
  return repository.fetchLists(userId: userId);
});

/// Provider for planning lists (matches old React Vuet functionality)
final planningListsProvider = FutureProvider<List<ListModel>>((ref) async {
  final repository = ref.watch(listRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);
  
  if (userId == null) return [];
  
  return repository.fetchLists(userId: userId, listType: 'planning');
});

/// Provider for shopping lists (matches old React Vuet functionality)
final shoppingListsProvider = FutureProvider<List<ListModel>>((ref) async {
  final repository = ref.watch(listRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);
  
  if (userId == null) return [];
  
  return repository.fetchLists(userId: userId, listType: 'shopping');
});

/// Provider for delegated lists (matches old React Vuet functionality)
final delegatedListsProvider = FutureProvider<List<ListModel>>((ref) async {
  final repository = ref.watch(listRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);
  
  if (userId == null) return [];
  
  return repository.fetchLists(userId: userId, listType: 'delegated');
});

/// Provider for list categories
final listCategoriesProvider = FutureProvider<List<ListCategoryModel>>((ref) async {
  final repository = ref.watch(listRepositoryProvider);
  return repository.fetchListCategories();
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

/// Notifier for managing lists state (matches old React Vuet reducer functionality)
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
      final lists = await _repository.fetchLists(userId: _userId!);
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
}

/// Provider for ListNotifier (matches old React Vuet list management)
final listNotifierProvider = StateNotifierProvider<ListNotifier, AsyncValue<List<ListModel>>>((ref) {
  final repository = ref.watch(listRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);
  return ListNotifier(repository, userId);
});
