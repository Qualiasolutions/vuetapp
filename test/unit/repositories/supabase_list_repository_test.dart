import 'package:flutter_test/flutter_test.dart';
import 'package:vuet_app/repositories/list_repository.dart';
import 'package:vuet_app/models/list_model.dart';
import 'package:vuet_app/models/list_item_model.dart';
import 'package:vuet_app/models/list_category_model.dart';
import 'package:vuet_app/models/list_sublist_model.dart';
import 'package:vuet_app/models/list_template_model.dart';

// Mock repository implementation for testing repository interface  
class MockListRepository implements ListRepository {
  final Map<String, ListModel> _lists = {};
  final Map<String, ListItemModel> _items = {};
  int _nextId = 1;

  
  @override
  Future<ListModel> createList(ListModel list) async {
    final id = _nextId.toString();
    final newList = list.copyWith(
      id: id,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _lists[id] = newList;
    _nextId++;
    return newList;
  }

  
  @override
  Future<ListItemModel> createListItem(ListItemModel item) async {
    final id = _nextId.toString();
    final newItem = item.copyWith(
      id: id,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _items[id] = newItem;
    _nextId++;
    return newItem;
  }

  
  @override
  Future<void> deleteList(String listId) async {
    _lists.remove(listId);
    // Remove associated items
    _items.removeWhere((key, item) => item.listId == listId);
  }

  
  @override
  Future<void> deleteListItem(String itemId) async {
    _items.remove(itemId);
  }

  
  @override
  Future<ListModel?> fetchListById(String listId) async {
    return _lists[listId];
  }

  
  Future<ListItemModel?> fetchListItemById(String itemId) async {
    return _items[itemId];
  }

  
  @override
  Future<List<ListItemModel>> fetchListItems(String listId) async {
    return _items.values
        .where((item) => item.listId == listId)
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  
  @override
  Future<List<ListModel>> fetchLists({
    required String userId,
    String? listType,
  }) async {
    var lists = _lists.values.where((list) => list.ownerId == userId);

    if (listType != null) {
      if (listType == 'shopping') {
        lists = lists.where((list) => list.isShoppingList == true);
      } else if (listType == 'planning') {
        lists = lists.where((list) => list.isShoppingList == false);
      } else if (listType == 'template') {
        lists = lists.where((list) => list.isTemplate == true);
      }
    }

    return lists.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  
  @override
  Future<ListModel> updateList(ListModel list) async {
    final updatedList = list.copyWith(updatedAt: DateTime.now());
    _lists[list.id] = updatedList;
    return updatedList;
  }

  
  @override
  Future<ListItemModel> updateListItem(ListItemModel item) async {
    final updatedItem = item.copyWith(updatedAt: DateTime.now());
    _items[item.id] = updatedItem;
    return updatedItem;
  }

  
  @override
  Future<void> reorderListItems(String listId, List<String> itemIds) async {
    for (int i = 0; i < itemIds.length; i++) {
      final item = _items[itemIds[i]];
      if (item != null) {
        final updatedItem = item.copyWith(
          sortOrder: i,
          updatedAt: DateTime.now(),
        );
        _items[updatedItem.id] = updatedItem;
      }
    }
  }
  
  
  @override
  Future<void> toggleItemCompletion(String itemId, bool isCompleted) async {
    final item = _items[itemId];
    if (item != null) {
      final updatedItem = item.copyWith(
        isCompleted: isCompleted,
        updatedAt: DateTime.now(),
      );
      _items[itemId] = updatedItem;
    }
  }
  
  
  @override
  Future<List<ListModel>> fetchTemplates(String userId) async {
    return _lists.values
        .where((list) => list.ownerId == userId && list.isTemplate == true)
        .toList();
  }
  
  
  @override
  Future<ListModel> createListFromTemplate(String templateId, String userId, String name) async {
    final template = _lists[templateId];
    if (template == null) {
      throw Exception('Template not found');
    }
    
    // Create a new list based on the template
    final newList = template.copyWith(
      id: _nextId.toString(),
      name: name,
      ownerId: userId,
      isTemplate: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _lists[newList.id] = newList;
    _nextId++;
    
    // Copy template items to the new list
    final templateItems = _items.values
        .where((item) => item.listId == templateId)
        .toList();
    
    for (final templateItem in templateItems) {
      final newItem = templateItem.copyWith(
        id: _nextId.toString(),
        listId: newList.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      _items[newItem.id] = newItem;
      _nextId++;
    }
    
    return newList;
  }

  void reset() {
    _lists.clear();
    _items.clear();
    _nextId = 1;
  }

  // Missing abstract methods implementation
  @override
  Future<List<ListCategoryModel>> fetchListCategories() async {
    // Mock implementation
    return [];
  }
  
  @override
  Future<ListCategoryModel> createListCategory(ListCategoryModel category) async {
    // Mock implementation
    return category;
  }
  
  @override
  Future<ListCategoryModel> updateListCategory(ListCategoryModel category) async {
    // Mock implementation
    return category;
  }
  
  @override
  Future<void> deleteListCategory(String categoryId) async {
    // Mock implementation
  }
  
  @override
  Future<List<ListModel>> getLists() async {
    return _lists.values.toList();
  }
  
  @override
  Future<List<ListCategoryModel>> getListCategories() async {
    return [];
  }
  
  @override
  Future<List<ListItemModel>> getListItems() async {
    return _items.values.toList();
  }
  
  // Simplified mock implementations for missing abstract methods
    @override
  Future<ListSublist> createListSublist(ListSublist sublist) async {
    return sublist;
  }

  @override
  Future<ListTemplateModel> createListTemplate(ListTemplateModel template) async {
    return template;
  }
  
  @override
  Future<void> deleteListSublist(String sublistId) async {
    // Mock implementation
  }
  
  @override
  Future<List<ListSublist>> fetchListSublists(String listId) async {
    return [];
  }
  
  @override
  Future<List<ListTemplateModel>> fetchListTemplates() async {
    return [];
  }
  
  @override
  Future<ListSublist> updateListSublist(ListSublist sublist) async {
    return sublist;
  }
}

void main() {
  group('ListRepository Interface Tests', () {
    late MockListRepository repository;

    setUp(() {
      repository = MockListRepository();
    });

    tearDown(() {
      repository.reset();
    });

    test('should create a list', () async {
      final list = ListModel(
        id: '', // Will be set by repository
        ownerId: 'test-user',
        userId: 'test-user', // Required parameter
        name: 'Shopping List',
        isShoppingList: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final result = await repository.createList(list);

      expect(result, isNotNull);
      expect(result.id, isNotEmpty);
      expect(result.name, 'Shopping List');
      expect(result.isShoppingList, true);
      expect(result.ownerId, 'test-user');
      expect(result.createdAt, isNotNull);
      expect(result.updatedAt, isNotNull);
    });

    test('should fetch lists for user', () async {
      // Create test lists
      await repository.createList(ListModel(
        id: '',
        ownerId: 'test-user',
        userId: 'test-user',
        name: 'List 1',
        isShoppingList: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      await repository.createList(ListModel(
        id: '',
        ownerId: 'test-user',
        userId: 'test-user',
        name: 'List 2',
        isShoppingList: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      await repository.createList(ListModel(
        id: '',
        ownerId: 'other-user',
        userId: 'other-user',
        name: 'Other List',
        isShoppingList: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      final lists = await repository.fetchLists(userId: 'test-user');

      expect(lists, hasLength(2));
      expect(lists.every((list) => list.ownerId == 'test-user'), true);
    });

    test('should filter lists by type', () async {
      await repository.createList(ListModel(
        id: '',
        ownerId: 'test-user',
        userId: 'test-user',
        name: 'Shopping List',
        isShoppingList: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      await repository.createList(ListModel(
        id: '',
        ownerId: 'test-user',
        userId: 'test-user',
        name: 'Planning List',
        isShoppingList: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      final shoppingLists = await repository.fetchLists(
        userId: 'test-user',
        listType: 'shopping',
      );

      expect(shoppingLists, hasLength(1));
      expect(shoppingLists.first.isShoppingList, true);
    });

    test('should update a list', () async {
      final createdList = await repository.createList(ListModel(
        id: '',
        ownerId: 'test-user',
        userId: 'test-user',
        name: 'Original List',
        isShoppingList: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      final updatedList = await repository.updateList(
        createdList.copyWith(name: 'Updated List'),
      );

      expect(updatedList.name, 'Updated List');
      expect(updatedList.id, createdList.id);
      expect(updatedList.updatedAt.isAfter(createdList.updatedAt), true);
    });

    test('should delete a list', () async {
      final createdList = await repository.createList(ListModel(
        id: '',
        ownerId: 'test-user',
        userId: 'test-user',
        name: 'Test List',
        isShoppingList: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      await repository.deleteList(createdList.id);

      final fetchedList = await repository.fetchListById(createdList.id);
      expect(fetchedList, isNull);
    });

    test('should create and fetch list items', () async {
      final list = await repository.createList(ListModel(
        id: '',
        ownerId: 'test-user',
        userId: 'test-user',
        name: 'Shopping List',
        isShoppingList: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      final item = await repository.createListItem(ListItemModel(
        id: '',
        listId: list.id,
        name: 'Milk',
        isCompleted: false,
        sortOrder: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      expect(item.listId, list.id);
      expect(item.name, 'Milk');

      final items = await repository.fetchListItems(list.id);
      expect(items, hasLength(1));
      expect(items.first.id, item.id);
    });

    test('should update list item', () async {
      final list = await repository.createList(ListModel(
        id: '',
        ownerId: 'test-user',
        userId: 'test-user',
        name: 'Shopping List',
        isShoppingList: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      final item = await repository.createListItem(ListItemModel(
        id: '',
        listId: list.id,
        name: 'Milk',
        isCompleted: false,
        sortOrder: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      final updatedItem = await repository.updateListItem(
        item.copyWith(isCompleted: true),
      );

      expect(updatedItem.isCompleted, true);
      expect(updatedItem.id, item.id);
    });

    test('should reorder list items', () async {
      final list = await repository.createList(ListModel(
        id: '',
        ownerId: 'test-user',
        userId: 'test-user',
        name: 'Shopping List',
        isShoppingList: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      final item1 = await repository.createListItem(ListItemModel(
        id: '',
        listId: list.id,
        name: 'First Item',
        isCompleted: false,
        sortOrder: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      final item2 = await repository.createListItem(ListItemModel(
        id: '',
        listId: list.id,
        name: 'Second Item',
        isCompleted: false,
        sortOrder: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      // Reorder items (swap positions)
      await repository.reorderListItems(list.id, [item2.id, item1.id]);

      final reorderedItems = await repository.fetchListItems(list.id);
      expect(reorderedItems[0].name, 'Second Item');
      expect(reorderedItems[1].name, 'First Item');
    });

    test('should handle shopping lists', () async {
      final list = await repository.createList(ListModel(
        id: '',
        ownerId: 'test-user',
        userId: 'test-user',
        name: 'Shopping List',
        isShoppingList: true,
        shoppingStoreId: 'store-123',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      expect(list.isShoppingList, true);
      expect(list.shoppingStoreId, 'store-123');

      final allLists = await repository.fetchLists(
        userId: 'test-user',
      );

      expect(allLists, hasLength(1));
      expect(allLists.first.isShoppingList, true);
    });

    test('should handle templates', () async {
      final template = await repository.createList(ListModel(
        id: '',
        ownerId: 'test-user',
        userId: 'test-user',
        name: 'Grocery Template',
        isTemplate: true,
        templateCategory: 'groceries',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      expect(template.isTemplate, true);
      expect(template.templateCategory, 'groceries');

      final templates = await repository.fetchTemplates('test-user');
      expect(templates, hasLength(1));
      expect(templates.first.isTemplate, true);
    });

    test('should create list from template', () async {
      final template = await repository.createList(ListModel(
        id: '',
        ownerId: 'template-owner',
        userId: 'template-owner',
        name: 'Grocery Template',
        isTemplate: true,
        templateCategory: 'groceries',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      // Add some items to the template
      await repository.createListItem(ListItemModel(
        id: '',
        listId: template.id,
        name: 'Milk',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      final newList = await repository.createListFromTemplate(
        template.id,
        'new-owner',
        'My Shopping List',
      );

      expect(newList.name, 'My Shopping List');
      expect(newList.ownerId, 'new-owner');
      expect(newList.isTemplate, false);
      expect(newList.id, isNot(equals(template.id)));

      final newListItems = await repository.fetchListItems(newList.id);
      expect(newListItems, hasLength(1));
      expect(newListItems.first.name, 'Milk');
    });

    test('should handle family lists', () async {
      final list = await repository.createList(ListModel(
        id: '',
        ownerId: 'test-user',
        userId: 'test-user',
        name: 'Family List',
        familyId: 'family-123',
        sharedWith: ['family-member-1', 'family-member-2'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      expect(list.familyId, 'family-123');
      expect(list.sharedWith, hasLength(2));
      expect(list.isShared, true);
    });

    test('should handle list delegation', () async {
      final list = await repository.createList(ListModel(
        id: '',
        ownerId: 'test-user',
        userId: 'test-user',
        name: 'Delegated List',
        isDelegated: true,
        delegatedTo: 'family-member',
        delegationNote: 'Please handle this',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      expect(list.isDelegated, true);
      expect(list.delegatedTo, 'family-member');
      expect(list.delegationNote, 'Please handle this');
    });

    test('should return null for non-existent items', () async {
      final list = await repository.fetchListById('non-existent');
      expect(list, isNull);

      final item = await repository.fetchListItemById('non-existent');
      expect(item, isNull);
    });
  });
}
