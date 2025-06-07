import 'package:uuid/uuid.dart';
import 'package:vuet_app/models/transport_entities.dart';
import 'package:vuet_app/models/task_model.dart';
import 'package:vuet_app/models/task_type_enums.dart'; // Assuming TaskType enum is here
import 'package:vuet_app/models/pets_model.dart'; // Added for Pet model

// As per systemPatterns.md
enum EntityChangeType {
  created,
  updated,
  deleted,
}

abstract class AutoTaskRule {
  bool shouldTrigger(dynamic entity, EntityChangeType changeType);
  List<TaskModel> generateTasks(dynamic entity);
}

class CarAutoTaskRule extends AutoTaskRule {
  final Uuid _uuid = const Uuid();

  @override
  bool shouldTrigger(dynamic entity, EntityChangeType changeType) {
    if (entity is! Car) return false;
    // Trigger on creation or update if relevant date fields are present
    return (changeType == EntityChangeType.created || changeType == EntityChangeType.updated) &&
        (entity.motDueDate != null ||
            entity.insuranceDueDate != null ||
            entity.serviceDueDate != null ||
            entity.taxDueDate != null ||
            entity.warrantyDueDate != null);
  }

  @override
  List<TaskModel> generateTasks(dynamic entity) {
    if (entity is! Car) return [];

    final car = entity;
    final List<TaskModel> tasks = [];
    final now = DateTime.now();

    void createTaskForDate(DateTime? date, String hiddenTag) {
      if (date != null) {
        tasks.add(TaskModel(
          id: _uuid.v4(),
          title: '🚗 $hiddenTag for ${car.registration}',
          dueDate: date,
          priority: 'medium', // Default priority
          status: 'pending', // Default status
          isRecurring: false, // Default, can be made configurable later
          createdAt: now,
          updatedAt: now,
          entityId: car.id?.toString(), // Link task to the car entity
          taskType: TaskType.task, // General task type
          tags: [hiddenTag.toLowerCase().replaceAll('_', '-')], // Add hidden tag as a searchable tag
        ));
      }
    }

    createTaskForDate(car.motDueDate, 'MOT_DUE');
    createTaskForDate(car.insuranceDueDate, 'INSURANCE_DUE');
    createTaskForDate(car.serviceDueDate, 'SERVICE_DUE');
    createTaskForDate(car.taxDueDate, 'TAX_DUE');
    createTaskForDate(car.warrantyDueDate, 'WARRANTY_DUE');

    return tasks;
  }
}

class PetVaccinationTaskRule extends AutoTaskRule {
  final Uuid _uuid = const Uuid();

  @override
  bool shouldTrigger(dynamic entity, EntityChangeType changeType) {
    if (entity is! Pet) return false;
    // Trigger on creation or update if vaccination_due is set and is in the future (or today)
    return (changeType == EntityChangeType.created || changeType == EntityChangeType.updated) &&
        entity.vaccinationDue != null &&
        !entity.vaccinationDue!.isBefore(DateTime.now().subtract(const Duration(days: 1))); // Allow today
  }

  @override
  List<TaskModel> generateTasks(dynamic entity) {
    if (entity is! Pet) return [];

    final pet = entity;
    final List<TaskModel> tasks = [];
    final now = DateTime.now();
    const String hiddenTag = 'VACCINATION_DUE';

    if (pet.vaccinationDue != null) {
      tasks.add(TaskModel(
        id: _uuid.v4(),
        title: '💉 Vaccination Due for ${pet.name}',
        dueDate: pet.vaccinationDue,
        priority: 'high', // Vaccinations are important
        status: 'pending',
        isRecurring: false, // Typically not recurring unless specified otherwise for boosters
        createdAt: now,
        updatedAt: now,
        entityId: pet.id, // Link task to the pet entity
        taskType: TaskType.task, 
        tags: [hiddenTag.toLowerCase().replaceAll('_', '-')], // "vaccination-due"
      ));
    }
    return tasks;
  }
}

class AutoTaskEngine {
  final List<AutoTaskRule> _rules;

  AutoTaskEngine(this._rules);

  List<TaskModel> processEntityChange(dynamic entity, EntityChangeType changeType) {
    final List<TaskModel> allGeneratedTasks = [];
    for (final rule in _rules) {
      if (rule.shouldTrigger(entity, changeType)) {
        allGeneratedTasks.addAll(rule.generateTasks(entity));
      }
    }
    return allGeneratedTasks;
  }
}

// Example of how to initialize and use the engine:
// final autoTaskEngine = AutoTaskEngine([CarAutoTaskRule(), PetVaccinationTaskRule()]);
// final newTasks = autoTaskEngine.processEntityChange(savedPet, EntityChangeType.created);
// // Then save newTasks to Supabase
