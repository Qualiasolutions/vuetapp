import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/entity_category_model.dart';
import 'package:vuet_app/repositories/supabase_category_repository.dart';

// Provider for personal categories with StreamProvider for auto-refresh and autoDispose
final personalCategoriesProvider = StreamProvider.autoDispose<List<EntityCategoryModel>>((ref) async* {
  final repository = ref.read(supabaseCategoryRepositoryProvider);
  
  // Initial fetch
  yield await repository.fetchPersonalCategories();
  
  // Poll for updates every 30 seconds
  await for (final _ in Stream.periodic(const Duration(seconds: 30))) {
    try {
      yield await repository.fetchPersonalCategories();
    } catch (e) {
      // Continue with previous data on error
      continue;
    }
  }
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