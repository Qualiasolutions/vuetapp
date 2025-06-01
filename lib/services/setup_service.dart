import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vuet_app/models/setup_completion_model.dart';

class SetupService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Category setup completion methods
  Future<List<CategorySetupCompletion>> getCategorySetupCompletions() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final response = await _supabase
        .from('category_setup_completions')
        .select()
        .eq('user_id', userId);

    return (response as List)
        .map((json) => CategorySetupCompletion.fromJson(json))
        .toList();
  }

  Future<bool> isCategorySetupCompleted(String categoryId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return false;

    final response = await _supabase
        .from('category_setup_completions')
        .select('id')
        .eq('user_id', userId)
        .eq('category_id', categoryId)
        .maybeSingle();

    return response != null;
  }

  Future<void> markCategorySetupCompleted(String categoryId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    await _supabase.from('category_setup_completions').insert({
      'user_id': userId,
      'category_id': categoryId,
      'completed_at': DateTime.now().toIso8601String(),
    });
  }

  // Entity type setup completion methods
  Future<List<EntityTypeSetupCompletion>> getEntityTypeSetupCompletions() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final response = await _supabase
        .from('entity_type_setup_completions')
        .select()
        .eq('user_id', userId);

    return (response as List)
        .map((json) => EntityTypeSetupCompletion.fromJson(json))
        .toList();
  }

  Future<bool> isEntityTypeSetupCompleted(String entityTypeName) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return false;

    final response = await _supabase
        .from('entity_type_setup_completions')
        .select('id')
        .eq('user_id', userId)
        .eq('entity_type_name', entityTypeName)
        .maybeSingle();

    return response != null;
  }

  Future<void> markEntityTypeSetupCompleted(String entityTypeName) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    await _supabase.from('entity_type_setup_completions').insert({
      'user_id': userId,
      'entity_type_name': entityTypeName,
      'completed_at': DateTime.now().toIso8601String(),
    });
  }

  // Batch operations
  Future<Map<String, bool>> getCategorySetupStatus(List<String> categoryIds) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return {};

    final response = await _supabase
        .from('category_setup_completions')
        .select('category_id')
        .eq('user_id', userId)
        .inFilter('category_id', categoryIds);

    final completedCategories = (response as List)
        .map((row) => row['category_id'] as String)
        .toSet();

    return Map.fromEntries(
      categoryIds.map((id) => MapEntry(id, completedCategories.contains(id))),
    );
  }

  Future<Map<String, bool>> getEntityTypeSetupStatus(List<String> entityTypeNames) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return {};

    final response = await _supabase
        .from('entity_type_setup_completions')
        .select('entity_type_name')
        .eq('user_id', userId)
        .inFilter('entity_type_name', entityTypeNames);

    final completedEntityTypes = (response as List)
        .map((row) => row['entity_type_name'] as String)
        .toSet();

    return Map.fromEntries(
      entityTypeNames.map((name) => MapEntry(name, completedEntityTypes.contains(name))),
    );
  }
}
