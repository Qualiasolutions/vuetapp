import '../models/transport_entities.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../state/auto_task_engine.dart';
import '../models/task_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Added for Ref
import '../providers/task_providers.dart'; // Added for autoTaskEngineProvider and taskServiceProvider
import '../providers/auth_providers.dart'; // Assuming supabaseClientProvider might be here or in a common spot

// --- Car Repository ---
abstract class CarRepository {
  Future<List<Car>> getAllCars();
  Future<Car?> getCarById(int id);
  Future<Car> saveCar(
      Car car); // Returns the saved car, potentially with an updated ID
  Future<void> deleteCar(int id);
}

class SupabaseCarRepository implements CarRepository {
  final SupabaseClient _supabase;
  final Ref _ref;

  // Constructor now takes Ref
  SupabaseCarRepository(this._ref) : _supabase = _ref.read(supabaseClientProvider); // Use a provider for SupabaseClient

  // Removed: final AutoTaskEngine _autoTaskEngine = AutoTaskEngine([CarAutoTaskRule()]);

  Future<void> _saveTasks(List<TaskModel> tasks) async {
    if (tasks.isEmpty) return;
    final taskService = _ref.read(taskServiceProvider);
    for (final task in tasks) {
      // Call TaskService.createTask, mapping fields from TaskModel
      // TaskService.createTask will handle setting createdById, createdAt, updatedAt, id, status etc.
      await taskService.createTask(
        title: task.title,
        description: task.description,
        dueDate: task.dueDate,
        priority: task.priority,
        categoryId: task.categoryId,
        entityId: task.entityId,
        taskType: task.taskType,
        taskSubtype: task.taskSubtype,
        startDateTime: task.startDateTime,
        endDateTime: task.endDateTime,
        location: task.location,
        typeSpecificData: task.typeSpecificData,
        urgency: task.urgency,
        taskBehavior: task.taskBehavior,
        tags: task.tags,
        parentTaskId: task.parentTaskId,
        // isRecurring and recurrencePattern might need to be passed if supported by createTask
      );
    }
  }

  @override
  Future<List<Car>> getAllCars() async {
    final List<dynamic> responseData = await _supabase
        .from('entities')
        .select(
            'id, name, notes, cars!inner(make, model, registration, mot_due_date, insurance_due_date, service_due_date, tax_due_date, warranty_due_date)')
        .eq('entity_type', 'car');

    return responseData.map((rawData) {
      final Map<String, dynamic> data = rawData as Map<String, dynamic>;
      // The 'cars' table data is nested under the 'cars' key.
      final Map<String, dynamic> carSpecificData =
          data['cars'] as Map<String, dynamic>? ?? {};

      // Construct the flat map expected by Car.fromJson
      final Map<String, dynamic> carJson = {
        'id': data['id'],
        'name': data['name'],
        'notes': data['notes'],
        'make': carSpecificData['make'],
        'model': carSpecificData['model'],
        'registration': carSpecificData['registration'],
        // Supabase returns dates as ISO8601 strings, Car.fromJson handles parsing
        'motDueDate': carSpecificData['mot_due_date'],
        'insuranceDueDate': carSpecificData['insurance_due_date'],
        'serviceDueDate': carSpecificData['service_due_date'],
        'taxDueDate': carSpecificData['tax_due_date'],
        'warrantyDueDate': carSpecificData['warranty_due_date'],
        // resourceType is defaulted in the Car model factory, so not needed from DB unless it can vary
      };
      return Car.fromJson(carJson);
    }).toList();
  }

  @override
  Future<Car?> getCarById(int id) async {
    final rawData = await _supabase
        .from('entities')
        .select(
            'id, name, notes, cars!inner(make, model, registration, mot_due_date, insurance_due_date, service_due_date, tax_due_date, warranty_due_date)')
        .eq('id', id)
        .eq('entity_type', 'car') // Ensure we are fetching a car
        .maybeSingle(); // Returns Map<String, dynamic>?

    if (rawData == null) {
      return null;
    }

    final Map<String, dynamic> data = rawData;
    final Map<String, dynamic> carSpecificData =
        data['cars'] as Map<String, dynamic>? ?? {};

    final Map<String, dynamic> carJson = {
      'id': data['id'],
      'name': data['name'],
      'notes': data['notes'],
      'make': carSpecificData['make'],
      'model': carSpecificData['model'],
      'registration': carSpecificData['registration'],
      'motDueDate': carSpecificData['mot_due_date'],
      'insuranceDueDate': carSpecificData['insurance_due_date'],
      'serviceDueDate': carSpecificData['service_due_date'],
      'taxDueDate': carSpecificData['tax_due_date'],
      'warrantyDueDate': carSpecificData['warranty_due_date'],
    };
    return Car.fromJson(carJson);
  }

  @override
  Future<Car> saveCar(Car car) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    // Transport category_id is assumed to be 12 from progress.md
    const transportCategoryId = 12;

    if (car.id == null) {
      // Insert new car
      // 1. Insert into 'entities' table
      final entityResponse = await _supabase
          .from('entities')
          .insert({
            'name': car.name,
            'description': car.notes, // Use car.notes for entities.description
            'category_id': transportCategoryId,
            'entity_type': 'car', // As per systemPatterns.md and techContext.md
            'user_id': userId,
          })
          .select()
          .single();

      final newEntityId = entityResponse['id'] as int;

      // 2. Insert into 'cars' table
      await _supabase.from('cars').insert({
        'entity_id': newEntityId,
        'make': car.make,
        'model': car.model,
        'registration': car.registration,
        'mot_due_date': car.motDueDate?.toIso8601String(),
        'insurance_due_date': car.insuranceDueDate?.toIso8601String(),
        'service_due_date': car.serviceDueDate?.toIso8601String(),
        'tax_due_date': car.taxDueDate?.toIso8601String(),
        'warranty_due_date': car.warrantyDueDate?.toIso8601String(),
      });

      // Return the car with the new ID
      // It's good practice to fetch the newly created complete entity if possible,
      // or ensure the returned object accurately reflects the DB state.
      // For now, just returning with the ID.
      final savedCar = car.copyWith(id: newEntityId);
      // Generate and save auto-tasks
      final autoTaskEngine = _ref.read(autoTaskEngineProvider);
      final newTasks = autoTaskEngine.processEntityChange(savedCar, EntityChangeType.created);
      await _saveTasks(newTasks);
      return savedCar;
    } else {
      // Update existing car
      // 1. Update 'entities' table
      await _supabase.from('entities').update({
        'name': car.name,
        'description': car.notes, // Use car.notes for entities.description
        // Potentially other updatable base entity fields
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', car.id!);

      // 2. Update 'cars' table
      await _supabase.from('cars').update({
        'make': car.make,
        'model': car.model,
        'registration': car.registration,
        'mot_due_date': car.motDueDate?.toIso8601String(),
        'insurance_due_date': car.insuranceDueDate?.toIso8601String(),
        'service_due_date': car.serviceDueDate?.toIso8601String(),
        'tax_due_date': car.taxDueDate?.toIso8601String(),
        'warranty_due_date': car.warrantyDueDate?.toIso8601String(),
      }).eq('entity_id', car.id!);

      // Generate and save auto-tasks
      final autoTaskEngine = _ref.read(autoTaskEngineProvider);
      final updatedTasks = autoTaskEngine.processEntityChange(car, EntityChangeType.updated);
      await _saveTasks(updatedTasks);
      return car;
    }
  }

  @override
  Future<void> deleteCar(int id) async {
    // It's generally safer to delete from the child table first,
    // then the parent table, unless ON DELETE CASCADE is set up on the foreign key.
    // Assuming no cascade for this implementation.

    // 1. Delete from 'cars' table
    await _supabase
        .from('cars')
        .delete()
        .eq('entity_id', id);

    // 2. Delete from 'entities' table
    // This will delete the base entity record.
    await _supabase
        .from('entities')
        .delete()
        .eq('id', id);
    
    // No return value needed for Future<void>
  }
}

// --- PublicTransport Repository ---
abstract class PublicTransportRepository {
  Future<List<PublicTransport>> getAllPublicTransport();
  Future<PublicTransport?> getPublicTransportById(int id);
  Future<PublicTransport> savePublicTransport(PublicTransport publicTransport);
  Future<void> deletePublicTransport(int id);
}

class SupabasePublicTransportRepository implements PublicTransportRepository {
  final _supabase = Supabase.instance.client;
  static const String _entityType = 'PublicTransport';
  static const String _specificTableName = 'public_transports'; // Assumed table name

  @override
  Future<List<PublicTransport>> getAllPublicTransport() async {
    final List<dynamic> responseData = await _supabase
        .from('entities')
        .select('id, name, notes, ${_specificTableName}!inner(transport_type, route_number, operator)')
        .eq('entity_type', _entityType);

    return responseData.map((rawData) {
      final Map<String, dynamic> data = rawData as Map<String, dynamic>;
      final Map<String, dynamic> specificData = data[_specificTableName] as Map<String, dynamic>? ?? {};
      
      final Map<String, dynamic> itemJson = {
        'id': data['id'],
        'name': data['name'],
        'notes': data['notes'],
        'transportType': specificData['transport_type'],
        'routeNumber': specificData['route_number'],
        'operator': specificData['operator'],
      };
      return PublicTransport.fromJson(itemJson);
    }).toList();
  }

  @override
  Future<PublicTransport?> getPublicTransportById(int id) async {
     final rawData = await _supabase
        .from('entities')
        .select('id, name, notes, ${_specificTableName}!inner(transport_type, route_number, operator)')
        .eq('id', id)
        .eq('entity_type', _entityType)
        .maybeSingle();

    if (rawData == null) {
      return null;
    }
    final Map<String, dynamic> data = rawData;
    final Map<String, dynamic> specificData = data[_specificTableName] as Map<String, dynamic>? ?? {};
    
    final Map<String, dynamic> itemJson = {
      'id': data['id'],
      'name': data['name'],
      'notes': data['notes'],
      'transportType': specificData['transport_type'],
      'routeNumber': specificData['route_number'],
      'operator': specificData['operator'],
    };
    return PublicTransport.fromJson(itemJson);
  }

  @override
  Future<PublicTransport> savePublicTransport(PublicTransport publicTransport) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }
    const transportCategoryId = 12; // Assuming Transport category ID

    final Map<String, dynamic> specificDataToSave = {
      'transport_type': publicTransport.transportType,
      'route_number': publicTransport.routeNumber,
      'operator': publicTransport.operator,
    };

    if (publicTransport.id == null) {
      final entityResponse = await _supabase
          .from('entities')
          .insert({
            'name': publicTransport.name,
            'description': publicTransport.notes,
            'category_id': transportCategoryId,
            'entity_type': _entityType,
            'user_id': userId,
          })
          .select()
          .single();
      final newEntityId = entityResponse['id'] as int;
      await _supabase.from(_specificTableName).insert({
        'entity_id': newEntityId,
        ...specificDataToSave,
      });
      return publicTransport.copyWith(id: newEntityId);
    } else {
      await _supabase
          .from('entities')
          .update({
            'name': publicTransport.name,
            'description': publicTransport.notes,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', publicTransport.id!);
      await _supabase
          .from(_specificTableName)
          .update(specificDataToSave)
          .eq('entity_id', publicTransport.id!);
      return publicTransport;
    }
  }

  @override
  Future<void> deletePublicTransport(int id) async {
    await _supabase
        .from(_specificTableName)
        .delete()
        .eq('entity_id', id);
    await _supabase
        .from('entities')
        .delete()
        .eq('id', id);
  }
}

// --- TrainBusFerry Repository ---
abstract class TrainBusFerryRepository {
  Future<List<TrainBusFerry>> getAllTrainBusFerries();
  Future<TrainBusFerry?> getTrainBusFerryById(int id);
  Future<TrainBusFerry> saveTrainBusFerry(TrainBusFerry trainBusFerry);
  Future<void> deleteTrainBusFerry(int id);
}

class SupabaseTrainBusFerryRepository implements TrainBusFerryRepository {
  final _supabase = Supabase.instance.client;
  static const String _entityType = 'TrainBusFerry';
  static const String _specificTableName = 'train_bus_ferries'; // Assumed table name

  @override
  Future<List<TrainBusFerry>> getAllTrainBusFerries() async {
    final List<dynamic> responseData = await _supabase
        .from('entities')
        .select('id, name, notes, ${_specificTableName}!inner(transport_type, operator, route_number, departure_station, arrival_station, departure_time, arrival_time)')
        .eq('entity_type', _entityType);

    return responseData.map((rawData) {
      final Map<String, dynamic> data = rawData as Map<String, dynamic>;
      final Map<String, dynamic> specificData = data[_specificTableName] as Map<String, dynamic>? ?? {};
      
      final Map<String, dynamic> itemJson = {
        'id': data['id'],
        'name': data['name'],
        'notes': data['notes'],
        'transportType': specificData['transport_type'],
        'operator': specificData['operator'],
        'routeNumber': specificData['route_number'],
        'departureStation': specificData['departure_station'],
        'arrivalStation': specificData['arrival_station'],
        'departureTime': specificData['departure_time'],
        'arrivalTime': specificData['arrival_time'],
      };
      return TrainBusFerry.fromJson(itemJson);
    }).toList();
  }

  @override
  Future<TrainBusFerry?> getTrainBusFerryById(int id) async {
    final rawData = await _supabase
        .from('entities')
        .select('id, name, notes, ${_specificTableName}!inner(transport_type, operator, route_number, departure_station, arrival_station, departure_time, arrival_time)')
        .eq('id', id)
        .eq('entity_type', _entityType)
        .maybeSingle();

    if (rawData == null) return null;
    
    final Map<String, dynamic> data = rawData;
    final Map<String, dynamic> specificData = data[_specificTableName] as Map<String, dynamic>? ?? {};
    
    final Map<String, dynamic> itemJson = {
      'id': data['id'],
      'name': data['name'],
      'notes': data['notes'],
      'transportType': specificData['transport_type'],
      'operator': specificData['operator'],
      'routeNumber': specificData['route_number'],
      'departureStation': specificData['departure_station'],
      'arrivalStation': specificData['arrival_station'],
      'departureTime': specificData['departure_time'],
      'arrivalTime': specificData['arrival_time'],
    };
    return TrainBusFerry.fromJson(itemJson);
  }

  @override
  Future<TrainBusFerry> saveTrainBusFerry(TrainBusFerry trainBusFerry) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');
    const transportCategoryId = 12;

    final Map<String, dynamic> specificDataToSave = {
      'transport_type': trainBusFerry.transportType,
      'operator': trainBusFerry.operator,
      'route_number': trainBusFerry.routeNumber,
      'departure_station': trainBusFerry.departureStation,
      'arrival_station': trainBusFerry.arrivalStation,
      'departure_time': trainBusFerry.departureTime?.toIso8601String(),
      'arrival_time': trainBusFerry.arrivalTime?.toIso8601String(),
    };

    if (trainBusFerry.id == null) {
      final entityResponse = await _supabase.from('entities').insert({
        'name': trainBusFerry.name,
        'description': trainBusFerry.notes,
        'category_id': transportCategoryId,
        'entity_type': _entityType,
        'user_id': userId,
      }).select().single();
      final newEntityId = entityResponse['id'] as int;
      await _supabase.from(_specificTableName).insert({'entity_id': newEntityId, ...specificDataToSave});
      return trainBusFerry.copyWith(id: newEntityId);
    } else {
      await _supabase.from('entities').update({
        'name': trainBusFerry.name,
        'description': trainBusFerry.notes,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', trainBusFerry.id!);
      await _supabase.from(_specificTableName).update(specificDataToSave).eq('entity_id', trainBusFerry.id!);
      return trainBusFerry;
    }
  }

  @override
  Future<void> deleteTrainBusFerry(int id) async {
    await _supabase.from(_specificTableName).delete().eq('entity_id', id);
    await _supabase.from('entities').delete().eq('id', id);
  }
}

// --- RentalCar Repository ---
abstract class RentalCarRepository {
  Future<List<RentalCar>> getAllRentalCars();
  Future<RentalCar?> getRentalCarById(int id);
  Future<RentalCar> saveRentalCar(RentalCar rentalCar);
  Future<void> deleteRentalCar(int id);
}

class SupabaseRentalCarRepository implements RentalCarRepository {
  final _supabase = Supabase.instance.client;
  static const String _entityType = 'RentalCar';
  static const String _specificTableName = 'rental_cars'; // Assumed table name

  @override
  Future<List<RentalCar>> getAllRentalCars() async {
    final List<dynamic> responseData = await _supabase
        .from('entities')
        .select('id, name, notes, ${_specificTableName}!inner(rental_company, make, model, registration, pickup_date, return_date, pickup_location, return_location, total_cost)')
        .eq('entity_type', _entityType);

    return responseData.map((rawData) {
      final Map<String, dynamic> data = rawData as Map<String, dynamic>;
      final Map<String, dynamic> specificData = data[_specificTableName] as Map<String, dynamic>? ?? {};
      
      final Map<String, dynamic> itemJson = {
        'id': data['id'],
        'name': data['name'],
        'notes': data['notes'],
        'rentalCompany': specificData['rental_company'],
        'make': specificData['make'],
        'model': specificData['model'],
        'registration': specificData['registration'],
        'pickupDate': specificData['pickup_date'],
        'returnDate': specificData['return_date'],
        'pickupLocation': specificData['pickup_location'],
        'returnLocation': specificData['return_location'],
        'totalCost': specificData['total_cost'],
      };
      return RentalCar.fromJson(itemJson);
    }).toList();
  }

  @override
  Future<RentalCar?> getRentalCarById(int id) async {
    final rawData = await _supabase
        .from('entities')
        .select('id, name, notes, ${_specificTableName}!inner(rental_company, make, model, registration, pickup_date, return_date, pickup_location, return_location, total_cost)')
        .eq('id', id)
        .eq('entity_type', _entityType)
        .maybeSingle();

    if (rawData == null) return null;

    final Map<String, dynamic> data = rawData;
    final Map<String, dynamic> specificData = data[_specificTableName] as Map<String, dynamic>? ?? {};
    
    final Map<String, dynamic> itemJson = {
      'id': data['id'],
      'name': data['name'],
      'notes': data['notes'],
      'rentalCompany': specificData['rental_company'],
      'make': specificData['make'],
      'model': specificData['model'],
      'registration': specificData['registration'],
      'pickupDate': specificData['pickup_date'],
      'returnDate': specificData['return_date'],
      'pickupLocation': specificData['pickup_location'],
      'returnLocation': specificData['return_location'],
      'totalCost': specificData['total_cost'],
    };
    return RentalCar.fromJson(itemJson);
  }

  @override
  Future<RentalCar> saveRentalCar(RentalCar rentalCar) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');
    const transportCategoryId = 12;

    final Map<String, dynamic> specificDataToSave = {
      'rental_company': rentalCar.rentalCompany,
      'make': rentalCar.make,
      'model': rentalCar.model,
      'registration': rentalCar.registration,
      'pickup_date': rentalCar.pickupDate?.toIso8601String(),
      'return_date': rentalCar.returnDate?.toIso8601String(),
      'pickup_location': rentalCar.pickupLocation,
      'return_location': rentalCar.returnLocation,
      'total_cost': rentalCar.totalCost,
    };

    if (rentalCar.id == null) {
      final entityResponse = await _supabase.from('entities').insert({
        'name': rentalCar.name,
        'description': rentalCar.notes,
        'category_id': transportCategoryId,
        'entity_type': _entityType,
        'user_id': userId,
      }).select().single();
      final newEntityId = entityResponse['id'] as int;
      await _supabase.from(_specificTableName).insert({'entity_id': newEntityId, ...specificDataToSave});
      return rentalCar.copyWith(id: newEntityId);
    } else {
      await _supabase.from('entities').update({
        'name': rentalCar.name,
        'description': rentalCar.notes,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', rentalCar.id!);
      await _supabase.from(_specificTableName).update(specificDataToSave).eq('entity_id', rentalCar.id!);
      return rentalCar;
    }
  }

  @override
  Future<void> deleteRentalCar(int id) async {
    await _supabase.from(_specificTableName).delete().eq('entity_id', id);
    await _supabase.from('entities').delete().eq('id', id);
  }
}
