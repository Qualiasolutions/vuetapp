import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vuet_app/models/task_category_model.dart';
import 'package:vuet_app/repositories/task_category_repository.dart';

/// Supabase implementation of the TaskCategoryRepository interface
class SupabaseTaskCategoryRepository implements TaskCategoryRepository {
  /// Supabase client instance
  final SupabaseClient _client;

  /// Constructor
  SupabaseTaskCategoryRepository({required SupabaseClient supabaseClient})
      : _client = supabaseClient;

  /// Table name for categories
  static const String _tableName = 'task_categories';

  @override
  Future<List<TaskCategoryModel>> getCategories() async {
    try {
      final response = await _client
          .from(_tableName)
          .select()
          .order('created_at', ascending: false);

      return response.map((json) => TaskCategoryModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('❌ Error getting categories: $e');
      rethrow;
    }
  }

  @override
  Future<TaskCategoryModel?> getCategoryById(String id) async {
    try {
      final response = await _client
          .from(_tableName)
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return TaskCategoryModel.fromJson(response);
    } catch (e) {
      debugPrint('❌ Error getting category by ID: $e');
      rethrow;
    }
  }

  @override
  Future<TaskCategoryModel> createCategory({
    required String name,
    required String color,
    String? icon,
    required String createdById,
  }) async {
    try {
      final now = DateTime.now().toIso8601String();

      final data = {
        'name': name,
        'color': color,
        'icon': icon,
        'created_by': createdById, // Corrected column name
        'created_at': now,
        'updated_at': now,
      };

      final response = await _client
          .from(_tableName)
          .insert(data)
          .select()
          .single();

      return TaskCategoryModel.fromJson(response);
    } catch (e) {
      debugPrint('❌ Error creating category: $e');
      rethrow;
    }
  }

  @override
  Future<TaskCategoryModel> updateCategory({
    required String id,
    String? name,
    String? color,
    String? icon,
  }) async {
    try {
      // Build update data with only the fields that are provided
      final Map<String, dynamic> updateData = {
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (name != null) {
        updateData['name'] = name;
      }

      if (color != null) {
        updateData['color'] = color;
      }

      // Handle icon specially since it can be null
      if (icon != null) {
        updateData['icon'] = icon;
      }

      final response = await _client
          .from(_tableName)
          .update(updateData)
          .eq('id', id)
          .select()
          .single();

      return TaskCategoryModel.fromJson(response);
    } catch (e) {
      debugPrint('❌ Error updating category: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    try {
      await _client.from(_tableName).delete().eq('id', id);
    } catch (e) {
      debugPrint('❌ Error deleting category: $e');
      rethrow;
    }
  }

  /// Get professional categories for a specific user
  @override
  Future<List<TaskCategoryModel>> getProfessionalCategories(String userId) async {
    try {
      // Assuming professional categories are linked to a user via the 'created_by' column
      final response = await _client
          .from(_tableName)
          .select()
          .eq('created_by', userId)
          .order('created_at', ascending: false);

      return response.map((json) => TaskCategoryModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('❌ Error getting professional categories: $e');
      rethrow;
    }
  }
}
