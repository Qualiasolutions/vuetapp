import 'package:vuet_app/models/task_category_model.dart';

/// Repository interface for task category data operations.
abstract class TaskCategoryRepository {
  /// Get all categories
  Future<List<TaskCategoryModel>> getCategories();
  
  /// Get a category by ID
  Future<TaskCategoryModel?> getCategoryById(String id);
  
  /// Create a new category
  Future<TaskCategoryModel> createCategory({
    required String name,
    required String color,
    String? icon,
    required String createdById,
  });
  
  /// Update an existing category
  Future<TaskCategoryModel> updateCategory({
    required String id,
    String? name,
    String? color,
    String? icon,
  });
  
  /// Delete a category
  Future<void> deleteCategory(String id);

  /// Get professional categories for a specific user
  Future<List<TaskCategoryModel>> getProfessionalCategories(String userId);
}
