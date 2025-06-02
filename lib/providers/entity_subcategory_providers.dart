import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/entity_subcategory_model.dart';
import 'entity_providers.dart' as entity_providers;

// Provider to fetch all subcategories for a specific category
final subcategoriesByCategoryProvider = FutureProvider.family<List<EntitySubcategoryModel>, String>(
  (ref, categoryId) async {
    final entityService = ref.watch(entity_providers.entityServiceProvider);
    return entityService.getSubcategoriesByCategory(categoryId);
  }
);

// Provider for a specific subcategory by ID
final subcategoryByIdProvider = FutureProvider.family<EntitySubcategoryModel?, String>(
  (ref, subcategoryId) async {
    final entityService = ref.watch(entity_providers.entityServiceProvider);
    return entityService.getSubcategoryById(subcategoryId);
  }
); 