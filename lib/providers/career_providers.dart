import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/career_entities.dart';
import 'package:vuet_app/repositories/career_repository.dart';
import 'package:vuet_app/repositories/supabase_career_repository.dart';
import 'package:vuet_app/providers/auth_providers.dart'; // For supabaseClientProvider & currentUserProvider

// Provider for CareerRepository
final careerRepositoryProvider = Provider<CareerRepository>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return SupabaseCareerRepository(supabaseClient, ref); // Pass ref for AutoTaskEngine access
});

// Provider to get all CareerGoals for the current user
final userCareerGoalsProvider = FutureProvider.autoDispose<List<CareerGoal>>((ref) async {
  final currentUser = ref.watch(currentUserProvider);
  if (currentUser == null) {
    return []; // Or throw an error, depending on desired behavior
  }
  final careerRepository = ref.watch(careerRepositoryProvider);
  return careerRepository.getCareerGoalsByUserId(currentUser.id);
});

// Provider to get a single CareerGoal by its ID
final careerGoalByIdProvider = FutureProvider.autoDispose.family<CareerGoal?, String>((ref, id) async {
  final careerRepository = ref.watch(careerRepositoryProvider);
  return careerRepository.getCareerGoalById(id);
});

// Provider to get all Employees (employment history) for the current user
final userEmployeesProvider = FutureProvider.autoDispose<List<Employee>>((ref) async {
  final currentUser = ref.watch(currentUserProvider);
  if (currentUser == null) {
    return [];
  }
  final careerRepository = ref.watch(careerRepositoryProvider);
  return careerRepository.getEmployeesByUserId(currentUser.id);
});

// Provider to get a single Employee record by its ID
final employeeByIdProvider = FutureProvider.autoDispose.family<Employee?, String>((ref, id) async {
  final careerRepository = ref.watch(careerRepositoryProvider);
  return careerRepository.getEmployeeById(id);
});

// You might also want StreamProviders if you need real-time updates,
// but FutureProviders are simpler for basic CRUD.
