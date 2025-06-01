import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vuet_app/config/supabase_config.dart';
import 'package:vuet_app/models/task_category_model.dart';
import 'package:vuet_app/repositories/task_category_repository.dart';

/// Supabase implementation of the TaskCategoryRepository interface
class SupabaseTaskCategoryRepository implements TaskCategoryRepository {
  /// Supabase client instance
  final SupabaseClient _client;
  
  /// Constructor
  SupabaseTaskCategoryRepository({SupabaseClient? client}) 
    : _client = client ?? SupabaseConfig.client;
  
  /// Table name for task categories
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
      final categoryData = {
        'name': name,
        'color': color,
        'icon': icon,
        'created_by': createdById,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };
      
      final response = await _client
          .from(_tableName)
          .insert(categoryData)
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
      // Build update data based on provided parameters
      final updateData = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };
      
      if (name != null) updateData['name'] = name;
      if (color != null) updateData['color'] = color;
      if (icon != null) updateData['icon'] = icon;
      
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
      await _client
          .from(_tableName)
          .delete()
          .eq('id', id);
    } catch (e) {
      debugPrint('❌ Error deleting category: $e');
      rethrow;
    }
  }

  @override
  Future<List<TaskCategoryModel>> getProfessionalCategories(String userId) async {
    // TODO: Implement fetching professional categories for the given userId
    // This might involve a specific query to Supabase, possibly filtering by a 'type' or 'is_professional' field
    // and matching the 'created_by' or a dedicated 'user_id' field with the provided userId.
    debugPrint('SupabaseTaskCategoryRepository: getProfessionalCategories called for userId: $userId - NOT IMPLEMENTED');
    return []; // Return empty list as a placeholder
  }
}
