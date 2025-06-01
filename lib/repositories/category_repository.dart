import 'package:vuet_app/models/entity_category_model.dart';

abstract class CategoryRepository {
  Future<List<EntityCategoryModel>> fetchCategories();
  
  Future<EntityCategoryModel> fetchCategoryById(String id);

  Future<EntityCategoryModel> createCategory(EntityCategoryModel category);

  Future<EntityCategoryModel> updateCategory(EntityCategoryModel category);

  Future<void> deleteCategory(String id);
  
  // May keep this if it's still relevant for entities without a category
  Future<int> fetchUncategorisedEntitiesCount();
  
  // Fetch personal categories for a user
  Future<List<EntityCategoryModel>> fetchPersonalCategories();
  
  // Fetch professional categories for a user
  Future<List<EntityCategoryModel>> fetchProfessionalCategories();
}
