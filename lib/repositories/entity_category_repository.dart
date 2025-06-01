import '../models/entity_category_model.dart';

abstract class EntityCategoryRepository {
  Future<EntityCategoryModel> createCategory(EntityCategoryModel category);
  Future<EntityCategoryModel?> getCategory(String id);
  Future<List<EntityCategoryModel>> listCategories({String? ownerId});
  Future<EntityCategoryModel> updateCategory(EntityCategoryModel category);
  Future<void> deleteCategory(String id);
}
