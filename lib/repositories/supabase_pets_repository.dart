import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Added for Ref
import 'package:vuet_app/models/pets_model.dart';
import 'package:vuet_app/models/task_model.dart'; // Added for TaskModel
import 'package:vuet_app/repositories/pets_repository.dart';
import 'package:vuet_app/utils/logger.dart';
import 'package:vuet_app/providers/auth_providers.dart'; // For supabaseClientProvider
import 'package:vuet_app/providers/task_providers.dart'; // For autoTaskEngineProvider, taskServiceProvider
import 'package:vuet_app/state/auto_task_engine.dart'; // For EntityChangeType

class SupabasePetsRepository implements PetsRepository {
  final SupabaseClient _supabaseClient;
  final Ref _ref;

  SupabasePetsRepository(this._ref) : _supabaseClient = _ref.read(supabaseClientProvider);

  Future<void> _saveTasks(List<TaskModel> tasks) async {
    if (tasks.isEmpty) return;
    final taskService = _ref.read(taskServiceProvider);
    for (final task in tasks) {
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
      );
    }
  }

  @override
  Future<Pet> createPet(Pet pet) async {
    try {
      final response = await _supabaseClient
          .from('pets')
          .insert(pet.toJson()..remove('id')) // Let Supabase generate ID
          .select()
          .single();
      final savedPet = Pet.fromJson(response);

      // Auto-task generation
      final autoTaskEngine = _ref.read(autoTaskEngineProvider);
      final newTasks = autoTaskEngine.processEntityChange(savedPet, EntityChangeType.created);
      await _saveTasks(newTasks);

      return savedPet;
    } catch (e, s) {
      log('Error creating pet: $e', name: 'SupabasePetsRepository', error: e, stackTrace: s);
      rethrow;
    }
  }

  @override
  Future<void> deletePet(String petId) async {
    try {
      await _supabaseClient.from('pets').delete().eq('id', petId);
    } catch (e, s) {
      log('Error deleting pet: $e', name: 'SupabasePetsRepository', error: e, stackTrace: s);
      rethrow;
    }
  }

  @override
  Future<Pet?> getPet(String petId) async {
    try {
      final response = await _supabaseClient
          .from('pets')
          .select()
          .eq('id', petId)
          .maybeSingle();
      return response == null ? null : Pet.fromJson(response);
    } catch (e, s) {
      log('Error getting pet: $e', name: 'SupabasePetsRepository', error: e, stackTrace: s);
      rethrow;
    }
  }

  @override
  Future<List<Pet>> listPetsByUserId(String userId) async {
    try {
      final response = await _supabaseClient
          .from('pets')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      return response.map((item) => Pet.fromJson(item)).toList();
    } catch (e, s) {
      log('Error listing pets by user ID: $e', name: 'SupabasePetsRepository', error: e, stackTrace: s);
      rethrow;
    }
  }

  @override
  Future<Pet> updatePet(Pet pet) async {
    try {
      final response = await _supabaseClient
          .from('pets')
          .update(pet.toJson()..remove('id')..remove('user_id')..remove('created_at')) // Don't update these
          .eq('id', pet.id)
          .select()
          .single();
      final updatedPet = Pet.fromJson(response);

      // Auto-task generation
      final autoTaskEngine = _ref.read(autoTaskEngineProvider);
      final newTasks = autoTaskEngine.processEntityChange(updatedPet, EntityChangeType.updated);
      await _saveTasks(newTasks);
      
      return updatedPet;
    } catch (e, s) {
      log('Error updating pet: $e', name: 'SupabasePetsRepository', error: e, stackTrace: s);
      rethrow;
    }
  }
}

class SupabasePetAppointmentsRepository implements PetAppointmentsRepository {
  final SupabaseClient _supabaseClient;
  // final Ref _ref; // Removed unused Ref

  // Updated constructor to accept Ref, but _ref is not used in this class
  SupabasePetAppointmentsRepository(Ref ref) : _supabaseClient = ref.read(supabaseClientProvider);

  @override
  Future<PetAppointment> createPetAppointment(PetAppointment appointment) async {
    try {
      final response = await _supabaseClient
          .from('pet_appointments')
          .insert(appointment.toJson()..remove('id')) // Let Supabase generate ID
          .select()
          .single();
      return PetAppointment.fromJson(response);
    } catch (e, s) {
      log('Error creating pet appointment: $e', name: 'SupabasePetAppointmentsRepository', error: e, stackTrace: s);
      rethrow;
    }
  }

  @override
  Future<void> deletePetAppointment(String appointmentId) async {
    try {
      await _supabaseClient
          .from('pet_appointments')
          .delete()
          .eq('id', appointmentId);
    } catch (e, s) {
      log('Error deleting pet appointment: $e', name: 'SupabasePetAppointmentsRepository', error: e, stackTrace: s);
      rethrow;
    }
  }

  @override
  Future<PetAppointment?> getPetAppointment(String appointmentId) async {
    try {
      final response = await _supabaseClient
          .from('pet_appointments')
          .select()
          .eq('id', appointmentId)
          .maybeSingle();
      return response == null ? null : PetAppointment.fromJson(response);
    } catch (e, s) {
      log('Error getting pet appointment: $e', name: 'SupabasePetAppointmentsRepository', error: e, stackTrace: s);
      rethrow;
    }
  }

  @override
  Future<List<PetAppointment>> listPetAppointmentsByPetId(String petId) async {
    try {
      final response = await _supabaseClient
          .from('pet_appointments')
          .select()
          .eq('pet_id', petId)
          .order('start_datetime', ascending: true);
      return response.map((item) => PetAppointment.fromJson(item)).toList();
    } catch (e, s) {
      log('Error listing pet appointments by pet ID: $e', name: 'SupabasePetAppointmentsRepository', error: e, stackTrace: s);
      rethrow;
    }
  }
  
  @override
  Future<List<PetAppointment>> listPetAppointmentsByUserId(String userId) async {
    try {
      final response = await _supabaseClient
          .from('pet_appointments')
          .select()
          .eq('user_id', userId)
          .order('start_datetime', ascending: true);
      return response.map((item) => PetAppointment.fromJson(item)).toList();
    } catch (e, s) {
      log('Error listing pet appointments by user ID: $e', name: 'SupabasePetAppointmentsRepository', error: e, stackTrace: s);
      rethrow;
    }
  }

  @override
  Future<PetAppointment> updatePetAppointment(PetAppointment appointment) async {
    try {
      final response = await _supabaseClient
          .from('pet_appointments')
          .update(appointment.toJson()..remove('id')..remove('user_id')..remove('pet_id')..remove('created_at')) // Don't update these
          .eq('id', appointment.id)
          .select()
          .single();
      return PetAppointment.fromJson(response);
    } catch (e, s) {
      log('Error updating pet appointment: $e', name: 'SupabasePetAppointmentsRepository', error: e, stackTrace: s);
      rethrow;
    }
  }
}
