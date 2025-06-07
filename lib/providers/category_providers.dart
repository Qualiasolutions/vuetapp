import 'package:vuet_app/models/entity_category_model.dart'; // Will be EntityCategory
import 'package:vuet_app/models/hierarchical_category_display_model.dart';
import 'package:vuet_app/repositories/supabase_category_repository.dart';
import 'package:vuet_app/constants/default_subcategories.dart';
import 'package:vuet_app/services/auth_service.dart';
import 'package:vuet_app/services/entity_service.dart';
import 'package:vuet_app/utils/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart'; // Removed unnecessary import
import '../models/entity_subcategory_model.dart';
import '../repositories/supabase_entity_category_repository.dart';
import '../repositories/supabase_entity_subcategory_repository.dart';

part 'category_providers.g.dart';

// Existing categoriesProvider (flat list, might be deprecated or used for specific non-hierarchical views)
// This provider will likely need significant rework or replacement once the new schema-driven approach is fully implemented.
// For now, just updating model names to clear immediate errors.
final categoriesProvider = FutureProvider<List<EntityCategory>>((ref) async {
  final categoryRepository = ref.watch(supabaseCategoryRepositoryProvider);
  final authService = ref.watch(authServiceProvider);

  try {
    List<EntityCategory> userCategories = [];
    if (authService.isSignedIn) {
      // Assuming fetchCategories will be updated to return List<EntityCategory>
      // and interact with the new 'entity_categories' table.
      // This part of the code is highly dependent on supabase_category_repository.dart changes.
      // For now, we'll assume it returns an empty list if not yet updated.
      // userCategories = await categoryRepository.fetchCategories();
    }
    
    // The fetchCategories method should now return the full list from the database.
    // If user-specific logic was intended, it needs to be implemented in the repository.
    // For now, assuming fetchCategories returns all relevant categories.
    // List<EntityCategory> categories = await categoryRepository.fetchCategories(); // Assuming this fetches all from new table.
    
    // Let's use the allEntityCategoriesProvider's underlying repository call for consistency,
    // as it's confirmed to work with the new table.
    // The categoriesProvider might be deprecated in favor of allEntityCategoriesProvider.
    // For now, let's make it fetch directly.
    List<EntityCategory> categories = await ref.watch(supabaseEntityCategoryRepositoryProvider).listCategories();


    categories.sort((a, b) {
        int priorityCompare = (a.sortOrder).compareTo(b.sortOrder);
        if (priorityCompare != 0) {
          return priorityCompare;
        }
        return (a.name).compareTo(b.name);
      });
    return categories;

  } catch (e, s) {
    log('Error fetching categories in categoriesProvider. Error: $e', name: 'CategoryProviders', error: e, stackTrace: s);
    // Return empty list on error, rather than falling back to hardcoded defaults.
    return [];
  }
});

// New provider for hierarchical categories
final hierarchicalCategoriesProvider = FutureProvider<List<HierarchicalCategoryDisplayModel>>((ref) async {
  final authService = ref.watch(authServiceProvider); 
  final entityService = ref.watch(entityServiceProvider);

  final user = authService.currentUser; 

  if (user != null && user.id.isNotEmpty) {
    try {
      return await entityService.getHierarchicalCategories(user.id);
    } catch (e, s) {
      log('Error in hierarchicalCategoriesProvider. Error: $e', name: 'CategoryProviders', error: e, stackTrace: s);
      return []; 
    }
  } else {
    log('hierarchicalCategoriesProvider: User not authenticated, returning empty hierarchy.', name: 'CategoryProviders');
    return [];
  }
});

// Provider to fetch all entity categories
@riverpod
// ignore: deprecated_member_use_from_same_package
Future<List<EntityCategory>> allEntityCategories(AllEntityCategoriesRef ref) async { // Updated to EntityCategory
  final categoryRepository = ref.watch(supabaseEntityCategoryRepositoryProvider);
  // Assuming your listCategories can be called without ownerId to get all
  // This will also need to be updated to return List<EntityCategory>
  return categoryRepository.listCategories();
}

// Provider family to fetch subcategories for a given categoryId
@riverpod
Future<List<EntitySubcategoryModel>> entitySubcategories(
    // ignore: deprecated_member_use_from_same_package
    EntitySubcategoriesRef ref, String categoryId) async {
  final subcategoryRepository = ref.watch(supabaseEntitySubcategoryRepositoryProvider);
  
  try {
    final dbSubcategories = await subcategoryRepository.listSubcategories(categoryId: categoryId);
    
    // If we have subcategories from the database, return them
    if (dbSubcategories.isNotEmpty) {
      return dbSubcategories;
    }
    
    // If not, check if we have default subcategories for this category
    final defaultSubcats = allSubcategories[categoryId];
    if (defaultSubcats != null) {
      log('Using default subcategories for category $categoryId', name: 'CategoryProviders');
      return defaultSubcats;
    }
    
    // For category groups, check all possible matches
    for (final entry in allSubcategories.entries) {
      if (categoryId.contains(entry.key)) {
        log('Using default subcategories for partial match category $categoryId -> ${entry.key}', name: 'CategoryProviders');
        return entry.value;
      }
    }
    
    // If we still don't have any, return an empty list
    return [];
  } catch (e, s) {
    log('Error fetching subcategories: $e', name: 'CategoryProviders', error: e, stackTrace: s);
    
    // Try to get default subcategories even if there's an error
    final defaultSubcats = allSubcategories[categoryId];
    if (defaultSubcats != null) {
      log('Using default subcategories for category $categoryId after error', name: 'CategoryProviders');
      return defaultSubcats;
    }
    
    return [];
  }
}
