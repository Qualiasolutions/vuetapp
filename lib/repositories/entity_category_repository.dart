import '../models/entity_category_model.dart'; // Will be EntityCategory

abstract class EntityCategoryRepository {
  Future<EntityCategory> createCategory(EntityCategory category); // Updated
  Future<EntityCategory?> getCategory(String id); // Updated
  Future<List<EntityCategory>> listCategories({String? ownerId}); // Updated
  Future<EntityCategory> updateCategory(EntityCategory category); // Updated
  Future<void> deleteCategory(String id);
}
