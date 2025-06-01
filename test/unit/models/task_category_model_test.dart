import 'package:flutter_test/flutter_test.dart';
import 'package:vuet_app/models/task_category_model.dart';

void main() {
  group('TaskCategoryModel Tests', () {
    test('should create TaskCategoryModel with required parameters', () {
      final now = DateTime.now();
      final category = TaskCategoryModel(
        id: '1',
        name: 'Work',
        color: '#0066cc',
        createdById: 'user1',
        createdAt: now,
        updatedAt: now,
      );

      expect(category.id, '1');
      expect(category.name, 'Work');
      expect(category.color, '#0066cc');
      expect(category.createdById, 'user1');
      expect(category.createdAt, now);
      expect(category.updatedAt, now);
    });

    test('should create TaskCategoryModel with all parameters', () {
      final now = DateTime.now();
      final category = TaskCategoryModel(
        id: '1',
        name: 'Personal',
        color: '#FF5733',
        icon: 'person',
        createdById: 'user1',
        createdAt: now,
        updatedAt: now,
      );

      expect(category.id, '1');
      expect(category.name, 'Personal');
      expect(category.color, '#FF5733');
      expect(category.icon, 'person');
      expect(category.createdById, 'user1');
      expect(category.createdAt, now);
      expect(category.updatedAt, now);
    });

    test('should convert to and from JSON', () {
      final now = DateTime.now();
      final category = TaskCategoryModel(
        id: '1',
        name: 'Health',
        color: '#00FF00',
        icon: 'health',
        createdById: 'user1',
        createdAt: now,
        updatedAt: now,
      );

      // Test toJson
      final json = category.toJson();
      expect(json['id'], '1');
      expect(json['name'], 'Health');
      expect(json['color'], '#00FF00');
      expect(json['icon'], 'health');
      expect(json['created_by_id'], 'user1');
      expect(json['created_at'], now.toIso8601String());
      expect(json['updated_at'], now.toIso8601String());

      // Test fromJson with correct field names
      final jsonForFromJson = {
        'id': '1',
        'name': 'Health',
        'color': '#00FF00',
        'icon': 'health',
        'created_by': 'user1', // Note: uses 'created_by' not 'created_by_id'
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      };
      
      final fromJson = TaskCategoryModel.fromJson(jsonForFromJson);
      expect(fromJson.id, '1');
      expect(fromJson.name, 'Health');
      expect(fromJson.color, '#00FF00');
      expect(fromJson.icon, 'health');
      expect(fromJson.createdById, 'user1');
      expect(fromJson.createdAt, now);
      expect(fromJson.updatedAt, now);
    });

    test('should handle equality correctly', () {
      final now = DateTime.now();
      final category1 = TaskCategoryModel(
        id: '1',
        name: 'Work',
        color: '#0066cc',
        createdById: 'user1',
        createdAt: now,
        updatedAt: now,
      );

      final category2 = TaskCategoryModel(
        id: '1',
        name: 'Work',
        color: '#0066cc',
        createdById: 'user1',
        createdAt: now,
        updatedAt: now,
      );

      final category3 = TaskCategoryModel(
        id: '2',
        name: 'Personal',
        color: '#FF5733',
        createdById: 'user1',
        createdAt: now,
        updatedAt: now,
      );

      expect(category1, equals(category2));
      expect(category1, isNot(equals(category3)));
    });

    test('should handle copy with new values', () {
      final now = DateTime.now();
      final original = TaskCategoryModel(
        id: '1',
        name: 'Work',
        color: '#0066cc',
        createdById: 'user1',
        createdAt: now,
        updatedAt: now,
      );

      final copied = original.copyWith(
        name: 'Business',
        color: '#FF0000',
      );

      expect(copied.id, original.id);
      expect(copied.name, 'Business');
      expect(copied.color, '#FF0000');
      expect(copied.createdById, original.createdById);
      expect(copied.createdAt, original.createdAt);
      expect(copied.updatedAt, original.updatedAt);
    });
    test('should handle system categories with null createdById', () {
      final now = DateTime.now();
      final systemCategory = TaskCategoryModel(
        id: '1',
        name: 'Home & Garden',
        color: '#4CAF50',
        createdById: null, // System category
        createdAt: now,
        updatedAt: now,
      );

      expect(systemCategory.id, '1');
      expect(systemCategory.name, 'Home & Garden');
      expect(systemCategory.color, '#4CAF50');
      expect(systemCategory.createdById, null);
      expect(systemCategory.createdAt, now);
      expect(systemCategory.updatedAt, now);
    });

    test('should handle fromJson with null created_by (system categories)', () {
      final now = DateTime.now();
      final jsonData = {
        'id': '34214839-ffe4-40b9-8770-b5bbb864b1e8',
        'name': 'Home & Garden',
        'color': '#4CAF50',
        'icon': '59464',
        'created_by': null, // This is what causes the original error
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      };

      final category = TaskCategoryModel.fromJson(jsonData);
      expect(category.id, '34214839-ffe4-40b9-8770-b5bbb864b1e8');
      expect(category.name, 'Home & Garden');
      expect(category.color, '#4CAF50');
      expect(category.icon, '59464');
      expect(category.createdById, null);
      expect(category.createdAt, now);
      expect(category.updatedAt, now);
    });
  });
}
