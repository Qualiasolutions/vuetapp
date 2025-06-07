import 'package:vuet_app/models/entity_category_model.dart'; // Will be EntityCategory

abstract class CategoryRepository {
  Future<List<EntityCategory>> fetchCategories(); // Updated to EntityCategory
  
  Future<EntityCategory> fetchCategoryById(String id); // Updated to EntityCategory

  Future<EntityCategory> createCategory(EntityCategory category); // Updated to EntityCategory

  Future<EntityCategory> updateCategory(EntityCategory category); // Updated to EntityCategory

  Future<void> deleteCategory(String id);
  
  // May keep this if it's still relevant for entities without a category
  Future<int> fetchUncategorisedEntitiesCount();
  
  // Fetch personal categories for a user
  Future<List<EntityCategory>> fetchPersonalCategories(); // Updated to EntityCategory
  
  // Fetch professional categories for a user
  Future<List<EntityCategory>> fetchProfessionalCategories(); // Updated to EntityCategory
}
