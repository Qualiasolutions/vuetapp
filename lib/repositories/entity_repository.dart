import '../models/entity_model.dart';

abstract class EntityRepository {
  Future<BaseEntityModel> createEntity(BaseEntityModel entity);
  Future<BaseEntityModel?> getEntity(String id);
  Future<List<BaseEntityModel>> listEntities({String? userId, int? appCategoryId}); // Changed categoryId to appCategoryId (int?)
  Future<BaseEntityModel> updateEntity(BaseEntityModel entity);
  Future<void> deleteEntity(String id);
}
