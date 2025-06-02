import '../models/entity_subcategory_model.dart';

abstract class EntitySubcategoryRepository {
  Future<EntitySubcategoryModel> createSubcategory(EntitySubcategoryModel subcategory);
  Future<EntitySubcategoryModel?> getSubcategory(String id);
  Future<List<EntitySubcategoryModel>> listSubcategories({String? categoryId});
  Future<EntitySubcategoryModel> updateSubcategory(EntitySubcategoryModel subcategory);
  Future<void> deleteSubcategory(String id);
} 