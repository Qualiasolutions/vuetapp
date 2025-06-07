import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vuet_app/models/career_entities.dart';
import 'package:vuet_app/repositories/career_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/providers/auth_providers.dart'; // For supabaseClientProvider
import 'package:vuet_app/state/auto_task_engine.dart'; // For AutoTaskEngine
import 'package:vuet_app/providers/task_providers.dart'; // For taskServiceProvider & autoTaskEngineProvider

class SupabaseCareerRepository implements CareerRepository {
  final SupabaseClient _supabaseClient;
  final Ref _ref; // For accessing other providers

  SupabaseCareerRepository(this._supabaseClient, this._ref);

  String _getUserId() {
    final user = _supabaseClient.auth.currentUser;
    if (user == null) {
      throw Exception('User is not authenticated.');
    }
    return user.id;
  }

  AutoTaskEngine get _autoTaskEngine => _ref.read(autoTaskEngineProvider);
  // Assuming TaskService is available via a provider similar to other repositories
  // If not, direct Supabase calls for tasks can be made here or TaskService needs to be created/passed.
  // For now, let's assume taskServiceProvider provides a service that can save tasks.
  dynamic get _taskService => _ref.read(taskServiceProvider);


  // CareerGoal methods
  @override
  Future<List<CareerGoal>> getCareerGoalsByUserId(String userId) async {
    final response = await _supabaseClient
        .from('career_goals')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return response.map((item) => CareerGoal.fromJson(item)).toList();
  }

  @override
  Future<CareerGoal?> getCareerGoalById(String id) async {
    final response = await _supabaseClient
        .from('career_goals')
        .select()
        .eq('id', id)
        .maybeSingle();
    return response == null ? null : CareerGoal.fromJson(response);
  }

  @override
  Future<CareerGoal> createCareerGoal(CareerGoal careerGoal) async {
    final userId = _getUserId();
    final goalToInsert = careerGoal.copyWith(userId: userId, createdAt: DateTime.now(), updatedAt: DateTime.now());
    final response = await _supabaseClient
        .from('career_goals')
        .insert(goalToInsert.toJson())
        .select()
        .single();
    return CareerGoal.fromJson(response);
  }

  @override
  Future<CareerGoal> updateCareerGoal(CareerGoal careerGoal) async {
    final goalToUpdate = careerGoal.copyWith(updatedAt: DateTime.now());
    final response = await _supabaseClient
        .from('career_goals')
        .update(goalToUpdate.toJson())
        .eq('id', careerGoal.id!)
        .select()
        .single();
    return CareerGoal.fromJson(response);
  }

  @override
  Future<void> deleteCareerGoal(String id) async {
    await _supabaseClient.from('career_goals').delete().eq('id', id);
  }

  // Employee methods
  @override
  Future<List<Employee>> getEmployeesByUserId(String userId) async {
    final response = await _supabaseClient
        .from('employees')
        .select()
        .eq('user_id', userId)
        .order('start_date', ascending: false); // Or order by is_current_job then start_date
    return response.map((item) => Employee.fromJson(item)).toList();
  }

  @override
  Future<Employee?> getEmployeeById(String id) async {
    final response = await _supabaseClient
        .from('employees')
        .select()
        .eq('id', id)
        .maybeSingle();
    return response == null ? null : Employee.fromJson(response);
  }

  @override
  Future<Employee> createEmployee(Employee employee) async {
    final userId = _getUserId();
    final employeeToInsert = employee.copyWith(userId: userId, createdAt: DateTime.now(), updatedAt: DateTime.now());
    final response = await _supabaseClient
        .from('employees')
        .insert(employeeToInsert.toJson())
        .select()
        .single();
    
    final newEmployee = Employee.fromJson(response);

    // Auto-task generation for quarterly review
    final tasks = _autoTaskEngine.processEntityChange(newEmployee, EntityChangeType.created);
    for (var task in tasks) {
      await _taskService.createTask(task.copyWith(createdById: _getUserId())); // Ensure createdById is set on task
    }

    return newEmployee;
  }

  @override
  Future<Employee> updateEmployee(Employee employee) async {
    final employeeToUpdate = employee.copyWith(updatedAt: DateTime.now());
    final response = await _supabaseClient
        .from('employees')
        .update(employeeToUpdate.toJson())
        .eq('id', employee.id!)
        .select()
        .single();

    final updatedEmployee = Employee.fromJson(response);

    // Auto-task generation for quarterly review
    // Consider if tasks should be updated/deleted/recreated or only created if not existing
    final tasks = _autoTaskEngine.processEntityChange(updatedEmployee, EntityChangeType.updated);
     for (var task in tasks) {
      // This might create duplicate tasks if not handled carefully.
      // A more robust solution would check for existing tasks with a specific tag/link.
      await _taskService.createTask(task.copyWith(createdById: _getUserId())); // Ensure createdById is set on task
    }
    return updatedEmployee;
  }

  @override
  Future<void> deleteEmployee(String id) async {
    await _supabaseClient.from('employees').delete().eq('id', id);
  }
}
