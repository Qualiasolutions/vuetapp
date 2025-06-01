import 'package:flutter_test/flutter_test.dart';
import 'package:vuet_app/models/task_model.dart';
import 'package:vuet_app/models/task_type_enums.dart';

void main() {
  group('TaskModel Tests', () {
    test('should create TaskModel with required parameters', () {
      final now = DateTime.now();
      final task = TaskModel(
        id: '1',
        title: 'Test Task',
        priority: 'medium',
        status: 'pending',
        createdAt: now,
        updatedAt: now,
      );

      expect(task.id, '1');
      expect(task.title, 'Test Task');
      expect(task.priority, 'medium');
      expect(task.status, 'pending');
      expect(task.isRecurring, false);
      expect(task.description, isNull);
      expect(task.dueDate, isNull);
    });

    test('should create TaskModel with all parameters', () {
      final now = DateTime.now();
      final dueDate = DateTime.now().add(const Duration(days: 7));
      final startDate = DateTime.now().add(const Duration(days: 1));
      final endDate = DateTime.now().add(const Duration(days: 1, hours: 2));

      final task = TaskModel(
        id: '1',
        title: 'Complete Task',
        description: 'Task description',
        dueDate: dueDate,
        priority: 'high',
        status: 'in_progress',
        isRecurring: true,
        recurrencePattern: {'type': 'weekly', 'interval': 1},
        categoryId: 'cat123',
        createdById: 'user123',
        assignedToId: 'user456',
        parentTaskId: 'parent123',
        entityId: 'entity123',
        taskType: TaskType.appointment,
        taskSubtype: 'meeting',
        startDateTime: startDate,
        endDateTime: endDate,
        location: 'Office',
        typeSpecificData: {'room': 'Conference A'},
        createdAt: now,
        updatedAt: now,
        completedAt: now.add(const Duration(hours: 1)),
      );

      expect(task.id, '1');
      expect(task.title, 'Complete Task');
      expect(task.description, 'Task description');
      expect(task.dueDate, dueDate);
      expect(task.priority, 'high');
      expect(task.status, 'in_progress');
      expect(task.isRecurring, true);
      expect(task.recurrencePattern, {'type': 'weekly', 'interval': 1});
      expect(task.categoryId, 'cat123');
      expect(task.createdById, 'user123');
      expect(task.assignedToId, 'user456');
      expect(task.parentTaskId, 'parent123');
      expect(task.entityId, 'entity123');
      expect(task.taskType, TaskType.appointment);
      expect(task.taskSubtype, 'meeting');
      expect(task.startDateTime, startDate);
      expect(task.endDateTime, endDate);
      expect(task.location, 'Office');
      expect(task.typeSpecificData, {'room': 'Conference A'});
      expect(task.completedAt, isNotNull);
    });

    test('should copy with new values', () {
      final now = DateTime.now();
      final originalTask = TaskModel(
        id: '1',
        title: 'Original',
        priority: 'low',
        status: 'pending',
        createdAt: now,
        updatedAt: now,
      );

      final copiedTask = originalTask.copyWith(
        title: 'Updated',
        priority: 'high',
        status: 'completed',
        taskType: TaskType.activity,
        location: 'New Location',
      );

      expect(copiedTask.id, '1');
      expect(copiedTask.title, 'Updated');
      expect(copiedTask.priority, 'high');
      expect(copiedTask.status, 'completed');
      expect(copiedTask.taskType, TaskType.activity);
      expect(copiedTask.location, 'New Location');
      expect(copiedTask.createdAt, now);
    });

    test('should convert to and from JSON', () {
      final now = DateTime.parse('2025-01-01T12:00:00Z');
      final dueDate = DateTime.parse('2025-01-07T12:00:00Z');
      
      final task = TaskModel(
        id: '1',
        title: 'Test Task',
        description: 'Description',
        dueDate: dueDate,
        priority: 'medium',
        status: 'pending',
        isRecurring: false,
        categoryId: 'cat123',
        createdById: 'user123',
        taskType: TaskType.task,
        taskSubtype: 'general',
        location: 'Home',
        typeSpecificData: {'notes': 'Important'},
        createdAt: now,
        updatedAt: now,
      );

      final json = task.toJson();
      final fromJson = TaskModel.fromJson(json);

      expect(fromJson.id, task.id);
      expect(fromJson.title, task.title);
      expect(fromJson.description, task.description);
      expect(fromJson.dueDate, task.dueDate);
      expect(fromJson.priority, task.priority);
      expect(fromJson.status, task.status);
      expect(fromJson.isRecurring, task.isRecurring);
      expect(fromJson.categoryId, task.categoryId);
      expect(fromJson.createdById, task.createdById);
      expect(fromJson.taskType, task.taskType);
      expect(fromJson.taskSubtype, task.taskSubtype);
      expect(fromJson.location, task.location);
      expect(fromJson.typeSpecificData, task.typeSpecificData);
      expect(fromJson.createdAt, task.createdAt);
      expect(fromJson.updatedAt, task.updatedAt);
    });

    test('should handle equality correctly', () {
      final now = DateTime.parse('2025-01-01T12:00:00Z');
      
      final task1 = TaskModel(
        id: '1',
        title: 'Test Task',
        priority: 'medium',
        status: 'pending',
        createdAt: now,
        updatedAt: now,
      );

      final task2 = TaskModel(
        id: '1',
        title: 'Test Task',
        priority: 'medium',
        status: 'pending',
        createdAt: now,
        updatedAt: now,
      );

      final task3 = task1.copyWith(title: 'Different Title');

      expect(task1, equals(task2));
      expect(task1, isNot(equals(task3)));
    });

    test('should validate task priorities', () {
      const validPriorities = ['low', 'medium', 'high'];
      
      for (final priority in validPriorities) {
        final task = TaskModel(
          id: '1',
          title: 'Test Task',
          priority: priority,
          status: 'pending',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        expect(task.priority, priority);
      }
    });

    test('should validate task statuses', () {
      const validStatuses = ['pending', 'in_progress', 'completed', 'cancelled'];
      
      for (final status in validStatuses) {
        final task = TaskModel(
          id: '1',
          title: 'Test Task',
          priority: 'medium',
          status: status,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        expect(task.status, status);
      }
    });

    test('should handle different task types', () {
      final now = DateTime.now();
      
      for (final taskType in TaskType.values) {
        final task = TaskModel(
          id: '1',
          title: 'Test Task',
          priority: 'medium',
          status: 'pending',
          taskType: taskType,
          createdAt: now,
          updatedAt: now,
        );
        expect(task.taskType, taskType);
      }
    });

    test('should handle JSON with null values', () {
      final json = {
        'id': '1',
        'title': 'Test Task',
        'priority': 'medium',
        'status': 'pending',
        'created_at': '2025-01-01T12:00:00Z',
        'updated_at': '2025-01-01T12:00:00Z',
        'description': null,
        'due_date': null,
        'task_type': null,
        'location': null,
      };

      final task = TaskModel.fromJson(json);

      expect(task.id, '1');
      expect(task.title, 'Test Task');
      expect(task.description, isNull);
      expect(task.dueDate, isNull);
      expect(task.taskType, isNull);
      expect(task.location, isNull);
    });
  });
}
