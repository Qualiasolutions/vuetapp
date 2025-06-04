import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/entity_category_model.dart';
import 'package:vuet_app/repositories/supabase_category_repository.dart';
import 'package:vuet_app/config/app_categories.dart';

// Provider for displaying personal categories as defined display groups
final personalCategoryDisplayGroupsProvider = Provider<List<CategoryDisplayGroup>>((ref) {
  return categoryDisplayGroups; // Return the static list of display groups
});

// Provider for professional categories with StreamProvider for auto-refresh and autoDispose
final professionalCategoriesProvider = StreamProvider.autoDispose<List<EntityCategoryModel>>((ref) async* {
  final repository = ref.read(supabaseCategoryRepositoryProvider);
  
  // Initial fetch
  yield await repository.fetchProfessionalCategories();
  
  // Poll for updates every 30 seconds
  await for (final _ in Stream.periodic(const Duration(seconds: 30))) {
    try {
      yield await repository.fetchProfessionalCategories();
    } catch (e) {
      // Continue with previous data on error
      continue;
    }
  }
});

// Provider for uncategorised entities count with StreamProvider for auto-refresh and autoDispose
final uncategorisedEntitiesCountProvider = StreamProvider.autoDispose<int>((ref) async* {
  final repository = ref.read(supabaseCategoryRepositoryProvider);
  
  // Initial fetch
  yield await repository.fetchUncategorisedEntitiesCount();
  
  // Poll for updates every 30 seconds
  await for (final _ in Stream.periodic(const Duration(seconds: 30))) {
    try {
      yield await repository.fetchUncategorisedEntitiesCount();
    } catch (e) {
      // Continue with previous data on error
      continue;
    }
  }
}); 