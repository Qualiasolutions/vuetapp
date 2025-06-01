import 'package:vuet_app/models/lists/list_entry_model.dart';
import 'package:vuet_app/models/lists/planning_list_model.dart';
import 'package:vuet_app/models/lists/shopping_list_model.dart';
import 'package:vuet_app/repositories/lists/lists_repository.dart';
import 'package:riverpod/riverpod.dart';

/// Provider for Lists Service
final listsServiceProvider = Provider<ListsService>((ref) {
  return ListsService();
});

/// Service for managing lists functionality
class ListsService {
  final ListsRepository _listsRepository = ListsRepository();

  // Planning Lists
  Future<List<PlanningList>> getPlanningLists() async {
    return await _listsRepository.getPlanningLists();
  }

  Future<PlanningList?> createPlanningList({
    required String category,
    required String name,
    required List<String> members,
  }) async {
    return await _listsRepository.createPlanningList(
      category: category,
      name: name,
      members: members,
    );
  }

  Future<bool> deletePlanningList(String id) async {
    return await _listsRepository.deletePlanningList(id);
  }

  // Planning Sublists
  Future<List<PlanningSublist>> getPlanningSublistsByList(String listId) async {
    return await _listsRepository.getPlanningSublistsByList(listId);
  }

  Future<PlanningSublist?> createPlanningSublist({
    required String listId,
    required String title,
  }) async {
    return await _listsRepository.createPlanningSublist(
      listId: listId,
      title: title,
    );
  }

  Future<bool> deletePlanningSublist(String id) async {
    return await _listsRepository.deletePlanningSublist(id);
  }

  // Planning List Items
  Future<List<PlanningListItem>> getPlanningListItemsBySublist(String sublistId) async {
    return await _listsRepository.getPlanningListItemsBySublist(sublistId);
  }

  Future<PlanningListItem?> createPlanningListItem({
    required String sublistId,
    required String title,
  }) async {
    return await _listsRepository.createPlanningListItem(
      sublistId: sublistId,
      title: title,
    );
  }

  Future<PlanningListItem?> togglePlanningListItemChecked(String id, bool checked) async {
    return await _listsRepository.togglePlanningListItemChecked(id, checked);
  }

  Future<bool> deletePlanningListItem(String id) async {
    return await _listsRepository.deletePlanningListItem(id);
  }

  // Shopping Lists
  Future<List<ShoppingList>> getShoppingLists() async {
    return await _listsRepository.getShoppingLists();
  }

  Future<ShoppingList?> createShoppingList({
    required String name,
    required List<String> members,
  }) async {
    return await _listsRepository.createShoppingList(
      name: name,
      members: members,
    );
  }

  Future<bool> deleteShoppingList(String id) async {
    return await _listsRepository.deleteShoppingList(id);
  }

  // Shopping List Items
  Future<List<ShoppingListItem>> getShoppingListItems(String listId) async {
    return await _listsRepository.getShoppingListItems(listId);
  }

  Future<ShoppingListItem?> createShoppingListItem({
    required String listId,
    String? storeId,
    required String title,
  }) async {
    return await _listsRepository.createShoppingListItem(
      listId: listId,
      storeId: storeId,
      title: title,
    );
  }

  Future<ShoppingListItem?> toggleShoppingListItemChecked(String id, bool checked) async {
    return await _listsRepository.toggleShoppingListItemChecked(id, checked);
  }

  Future<bool> deleteShoppingListItem(String id) async {
    return await _listsRepository.deleteShoppingListItem(id);
  }

  // Shopping List Stores
  Future<List<ShoppingListStore>> getShoppingListStores() async {
    return await _listsRepository.getShoppingListStores();
  }

  Future<ShoppingListStore?> createShoppingListStore({
    required String name,
    required String createdBy,
  }) async {
    return await _listsRepository.createShoppingListStore(
      name: name,
      createdBy: createdBy,
    );
  }

  Future<bool> deleteShoppingListStore(String id) async {
    return await _listsRepository.deleteShoppingListStore(id);
  }

  // List Entry Operations
  Future<ListEntry?> getListEntry(String id) async {
    return await _listsRepository.getListEntry(id);
  }

  Future<List<ListEntry>> getListEntries(String listId) async {
    return await _listsRepository.getListEntries(listId);
  }

  Future<ListEntry?> createListEntry(ListEntryCreateRequest request) async {
    return await _listsRepository.createListEntry(request);
  }

  Future<ListEntry?> updateListEntry(ListEntryUpdateRequest request) async {
    return await _listsRepository.updateListEntry(request);
  }

  Future<bool> deleteListEntry(String id) async {
    return await _listsRepository.deleteListEntry(id);
  }
}
