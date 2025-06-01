import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/entity_category_model.dart';
import 'package:vuet_app/models/hierarchical_category_display_model.dart';
import 'package:vuet_app/repositories/supabase_category_repository.dart'; 
import 'package:vuet_app/constants/default_categories.dart'; 
import 'package:vuet_app/services/auth_service.dart';
import 'package:vuet_app/services/entity_service.dart';
import 'package:vuet_app/utils/logger.dart';

// Existing categoriesProvider (flat list, might be deprecated or used for specific non-hierarchical views)
final categoriesProvider = FutureProvider<List<EntityCategoryModel>>((ref) async {
  final categoryRepository = ref.watch(supabaseCategoryRepositoryProvider);
  final authService = ref.watch(authServiceProvider);

  try {
    List<EntityCategoryModel> userCategories = [];
    if (authService.isSignedIn) {
      userCategories = await categoryRepository.fetchCategories(); 
    }
    
    final Set<String> userCategoryNames = userCategories.map((uc) => uc.name.toLowerCase()).toSet();
    final List<EntityCategoryModel> mergedCategories = List.from(userCategories);

    for (final defaultCategory in defaultCategories) {
      if (!userCategoryNames.contains(defaultCategory.name.toLowerCase())) {
        mergedCategories.add(defaultCategory.copyWith(ownerId: null)); 
      }
    }
    
    mergedCategories.sort((a, b) {
        int priorityCompare = (a.priority ?? 99).compareTo(b.priority ?? 99);
        if (priorityCompare != 0) {
          return priorityCompare;
        }
        return (a.name).compareTo(b.name);
      });
    return mergedCategories;

  } catch (e, s) {
    log('Error fetching user categories in categoriesProvider. Error: $e', name: 'CategoryProviders', error: e, stackTrace: s);
    final sortedDefaultCategories = List<EntityCategoryModel>.from(defaultCategories);
    sortedDefaultCategories.sort((a, b) {
        int priorityCompare = (a.priority ?? 99).compareTo(b.priority ?? 99);
        if (priorityCompare != 0) {
          return priorityCompare;
        }
        return (a.name).compareTo(b.name);
      });
    return sortedDefaultCategories;
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
