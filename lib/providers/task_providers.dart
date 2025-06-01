import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vuet_app/models/task_category_model.dart';
import 'package:vuet_app/services/task_service.dart' show TaskService; // Import only the TaskService class
import 'package:vuet_app/services/task_category_service.dart'; // Added for TaskCategoryService
import 'package:vuet_app/services/notification_service.dart' show notificationServiceProvider; // Import NotificationService provider
import 'package:vuet_app/services/auth_service.dart'; // Added for authServiceProvider
import 'package:vuet_app/repositories/supabase_task_repository.dart'; // Added for supabaseTaskRepositoryProvider
import 'package:vuet_app/models/task_model.dart'; // Import the task model

// Riverpod provider for TaskService, now defined in its own providers file
final taskServiceProvider = ChangeNotifierProvider<TaskService>((ref) {
  final notificationService = ref.watch(notificationServiceProvider);
  final authService = ref.watch(authServiceProvider); // Added
  final taskRepository = ref.watch(supabaseTaskRepositoryProvider); // Added
  return TaskService(
    repository: taskRepository, // Added
    notificationService: notificationService, 
    authService: authService, // Added
    supabase: Supabase.instance.client, // Added missing supabase parameter
  );
});

// Provider for TaskCategoryService
final taskCategoryServiceProvider = Provider<TaskCategoryService>((ref) {
  // TaskCategoryService constructor handles default SupabaseTaskCategoryRepository and SupabaseClient
  return TaskCategoryService();
});

// Provider to fetch all categories (personal/general)
final allCategoriesProvider = FutureProvider.autoDispose<List<TaskCategoryModel>>((ref) async {
  final taskCategoryService = ref.watch(taskCategoryServiceProvider);
  return await taskCategoryService.getCategories();
});

// Provider to fetch professional categories
final professionalCategoriesProvider = FutureProvider.autoDispose<List<TaskCategoryModel>>((ref) async {
  final taskCategoryService = ref.watch(taskCategoryServiceProvider);
  return await taskCategoryService.getProfessionalCategories();
});

// Provider to fetch a single task category by its ID
final taskCategoryDetailProviderFamily = FutureProvider.autoDispose.family<TaskCategoryModel?, String?>((ref, categoryId) async {
  if (categoryId == null || categoryId.isEmpty) {
    return null;
  }
  final taskCategoryService = ref.watch(taskCategoryServiceProvider);
  return await taskCategoryService.getCategoryById(categoryId);
});

// Provider for fetching tasks linked to a specific entity ID
final tasksByEntityIdProvider = FutureProvider.family<List<TaskModel>, String>((ref, entityId) async {
  final taskService = ref.watch(taskServiceProvider);
  return await taskService.getTasksByEntityId(entityId);
});
