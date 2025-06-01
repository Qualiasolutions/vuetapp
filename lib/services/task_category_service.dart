import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vuet_app/config/supabase_config.dart';
import 'package:vuet_app/models/task_category_model.dart';
import 'package:vuet_app/repositories/supabase_task_category_repository.dart';
import 'package:vuet_app/repositories/task_category_repository.dart';

/// Service for managing task categories
class TaskCategoryService extends ChangeNotifier {
  /// Category repository instance
  final TaskCategoryRepository _repository;
  
  /// Supabase client instance for auth
  final SupabaseClient _client;
  
  /// Constructor
  TaskCategoryService({
    TaskCategoryRepository? repository,
    SupabaseClient? client,
  }) : _repository = repository ?? 
            SupabaseTaskCategoryRepository(
              supabaseClient: SupabaseConfig.client,
            ),
       _client = client ?? SupabaseConfig.client;
  
  /// Get all categories
  Future<List<TaskCategoryModel>> getCategories() async {
    try {
      return await _repository.getCategories();
    } catch (e) {
      debugPrint('❌ Error in CategoryService.getCategories: $e');
      rethrow;
    }
  }
  
  /// Get a category by ID
  Future<TaskCategoryModel?> getCategoryById(String id) async {
    try {
      return await _repository.getCategoryById(id);
    } catch (e) {
      debugPrint('❌ Error in CategoryService.getCategoryById: $e');
      rethrow;
    }
  }
  
  /// Create a new category
  Future<TaskCategoryModel> createCategory({
    required String name,
    required String color,
    String? icon,
  }) async {
    try {
      // Get current user
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }
      
      return await _repository.createCategory(
        name: name,
        color: color,
        icon: icon,
        createdById: currentUser.id,
      );
    } catch (e) {
      debugPrint('❌ Error in CategoryService.createCategory: $e');
      rethrow;
    }
  }
  
  /// Update an existing category
  Future<TaskCategoryModel> updateCategory({
    required String id,
    String? name,
    String? color,
    String? icon,
  }) async {
    try {
      return await _repository.updateCategory(
        id: id,
        name: name,
        color: color, 
        icon: icon,
      );
    } catch (e) {
      debugPrint('❌ Error in CategoryService.updateCategory: $e');
      rethrow;
    }
  }
  
  /// Delete a category
  Future<void> deleteCategory(String id) async {
    try {
      await _repository.deleteCategory(id);
    } catch (e) {
      debugPrint('❌ Error in CategoryService.deleteCategory: $e');
      rethrow;
    }
  }

  /// Get professional categories for the current user
  Future<List<TaskCategoryModel>> getProfessionalCategories() async {
    try {
      // Get current user
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }
      return await _repository.getProfessionalCategories(currentUser.id);
    } catch (e) {
      debugPrint('❌ Error in CategoryService.getProfessionalCategories: $e');
      rethrow;
    }
  }
}
