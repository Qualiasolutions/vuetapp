import 'package:flutter_test/flutter_test.dart';
import 'package:vuet_app/models/list_model.dart';
import 'package:vuet_app/models/list_sublist_model.dart';

void main() {
  group('ListModel Tests', () {
    test('should create ListModel with required parameters', () {
      final now = DateTime.now();
      final list = ListModel(
        id: '1',
        name: 'Test List',
        ownerId: 'user123',
        userId: 'user123', // Correct: For direct constructor
        createdAt: now,
        updatedAt: now,
      );

      expect(list.id, '1');
      expect(list.name, 'Test List');
      expect(list.ownerId, 'user123');
      expect(list.userId, 'user123');
      expect(list.familyId, isNull);
      expect(list.isTemplate, false);
      expect(list.isShoppingList, false);
    });

    test('should create ListModel with optional parameters', () {
      final now = DateTime.now();
      final list = ListModel(
        id: 'list1',
        name: 'Shopping List',
        ownerId: 'user123',
        userId: 'user123', // Correct: For direct constructor
        familyId: 'family456',
        isTemplate: true,
        templateCategory: 'groceries',
        isShoppingList: true,
        shoppingStoreId: 'store789',
        createdAt: now,
        updatedAt: now,
      );

      expect(list.id, 'list1');
      expect(list.name, 'Shopping List');
      expect(list.ownerId, 'user123');
      expect(list.userId, 'user123');
      expect(list.familyId, 'family456');
      expect(list.isTemplate, true);
      expect(list.templateCategory, 'groceries');
      expect(list.isShoppingList, true);
      expect(list.shoppingStoreId, 'store789');
    });

    test('should copy with new values', () {
      final now = DateTime.now();
      final originalList = ListModel(
        id: '1',
        name: 'Original',
        ownerId: 'user123',
        userId: 'user123', // Correct: For direct constructor
        createdAt: now,
        updatedAt: now,
      );

      final copiedList = originalList.copyWith(
        name: 'Updated',
        isTemplate: true,
        templateCategory: 'new-category',
      );

      expect(copiedList.id, '1');
      expect(copiedList.name, 'Updated');
      expect(copiedList.isTemplate, true);
      expect(copiedList.templateCategory, 'new-category');
      expect(copiedList.ownerId, 'user123');
      expect(copiedList.userId, 'user123'); // userId is copied
    });

    test('should convert to and from JSON', () {
      final now = DateTime.parse('2025-01-01T12:00:00Z');
      final list = ListModel(
        id: '1',
        name: 'Test List',
        ownerId: 'user123',
        userId: 'user123', // Correct: For direct constructor
        familyId: 'family456',
        isTemplate: false,
        isShoppingList: true,
        createdAt: now,
        updatedAt: now,
      );

      final json = list.toJson();
      final fromJson = ListModel.fromJson(json);

      expect(fromJson.id, list.id);
      expect(fromJson.name, list.name);
      expect(fromJson.ownerId, list.ownerId);
      expect(fromJson.userId, list.userId);
      expect(fromJson.familyId, list.familyId);
      expect(fromJson.isTemplate, list.isTemplate);
      expect(fromJson.isShoppingList, list.isShoppingList);
      expect(fromJson.createdAt, list.createdAt);
      expect(fromJson.updatedAt, list.updatedAt);
    });

    test('should handle equality correctly', () {
      final now = DateTime.parse('2025-01-01T12:00:00Z');
      final list1 = ListModel(
        id: '1',
        name: 'Test List',
        ownerId: 'user123',
        userId: 'user123', // Correct: For direct constructor
        createdAt: now,
        updatedAt: now,
      );

      final list2 = ListModel(
        id: '1',
        name: 'Test List',
        ownerId: 'user123',
        userId: 'user123', // Correct: For direct constructor
        createdAt: now,
        updatedAt: now,
      );

      final list3 = list1.copyWith(name: 'Different Name');

      expect(list1, equals(list2));
      expect(list1, isNot(equals(list3)));
    });

    test('should create list using factory constructor', () {
      final list = ListModel.create( // Correct: No userId here
        name: 'New List',
        ownerId: 'user123',
        familyId: 'family456',
        isTemplate: true,
        templateCategory: 'work',
      );

      expect(list.name, 'New List');
      expect(list.ownerId, 'user123');
      expect(list.userId, 'user123'); // userId is set from ownerId internally
      expect(list.familyId, 'family456');
      expect(list.isTemplate, true);
      expect(list.templateCategory, 'work');
      expect(list.id, isNotEmpty);
      expect(list.createdAt, isNotNull);
      expect(list.updatedAt, isNotNull);
    });

    test('should create list from template', () {
      final template = ListModel.create( // Correct: No userId here
        name: 'Template List',
        ownerId: 'template-owner',
        isTemplate: true,
        templateCategory: 'groceries',
      );

      final newList = ListModel.fromTemplate( // Correct: No userId here
        template: template,
        ownerId: 'new-owner',
        familyId: 'family123',
        customName: 'My Grocery List',
      );

      expect(newList.name, 'My Grocery List');
      expect(newList.ownerId, 'new-owner');
      expect(newList.userId, 'new-owner'); // userId is set from ownerId internally
      expect(newList.familyId, 'family123');
      expect(newList.isTemplate, false);
      expect(newList.templateCategory, isNull); // templateCategory is not copied by default
      expect(newList.id, isNot(equals(template.id)));
      expect(newList.createdFromTemplate, true);
      expect(newList.templateId, template.id);
    });

    test('should calculate completion percentage correctly', () {
      final list = ListModel.create( // Correct: No userId here
        name: 'Test List',
        ownerId: 'user123',
      );

      // Empty list
      // For ListModel.create, totalItems/completedItems default to 0
      expect(list.completionPercentage, 0.0); 
      // If you want to use the extension, ensure listCategoryId is handled or use calculatedCompletionPercentage
      expect(list.calculatedCompletionPercentage, 0.0);


      // List with items
      final listWithItems = list.copyWith(
        totalItems: 10,
        completedItems: 3,
      );
      expect(listWithItems.completionPercentage, 0.0); // This will be 0 unless explicitly set
      expect(listWithItems.calculatedCompletionPercentage, 30.0);


      // Completed list
      final completedList = list.copyWith(
        totalItems: 5,
        completedItems: 5,
      );
      expect(completedList.completionPercentage, 0.0); // This will be 0 unless explicitly set
      expect(completedList.calculatedCompletionPercentage, 100.0);
    });

    test('should manage sublists correctly', () {
      final list = ListModel.create( // Correct: No userId here
        name: 'Test List',
        ownerId: 'user123',
      );

      final sublist = ListSublist.create(
        listId: list.id,
        title: 'Test Sublist',
      );

      final updatedList = list.addSublist(sublist);
      expect(updatedList.sublists.length, 1);
      expect(updatedList.sublists.first.title, 'Test Sublist');

      final removedList = updatedList.removeSublist(sublist.id);
      expect(removedList.sublists.length, 0);
    });

    test('should handle delegation correctly', () {
      final list = ListModel.create( // Correct: No userId here
        name: 'Test List',
        ownerId: 'user123',
      );

      expect(list.isDelegated, false);
      expect(list.delegationStatus, 'Not delegated');

      final delegatedList = list.delegate(
        delegatedTo: 'family-member',
        note: 'Please handle this',
      );

      expect(delegatedList.isDelegated, true);
      expect(delegatedList.delegatedTo, 'family-member');
      expect(delegatedList.delegationNote, 'Please handle this');
      expect(delegatedList.delegationStatus, 'Delegated to family member');
      expect(delegatedList.listType, 'delegated');


      final undelegatedList = delegatedList.removeDelegation();
      expect(undelegatedList.isDelegated, false);
      expect(undelegatedList.delegatedTo, isNull);
    });

    test('should handle permissions correctly', () {
      final list = ListModel.create( // Correct: No userId here
        name: 'Test List',
        ownerId: 'owner123',
      );

      // Owner can edit
      expect(list.canEdit('owner123'), true);
      
      // Non-owner cannot edit
      expect(list.canEdit('other-user'), false);

      // Shared users can edit
      final sharedList = list.shareWith(['shared-user']);
      expect(sharedList.canEdit('shared-user'), true);
      expect(sharedList.canEdit('other-user'), false);
    });
  });
}