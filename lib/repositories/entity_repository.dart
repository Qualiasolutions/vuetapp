import '../models/entity_model.dart';

abstract class EntityRepository {
  Future<BaseEntityModel> createEntity(BaseEntityModel entity);
  Future<BaseEntityModel?> getEntity(String id);
  Future<List<BaseEntityModel>> listEntities({String? userId, int? appCategoryId, String? subcategoryId});
  Future<BaseEntityModel> updateEntity(BaseEntityModel entity);
  Future<void> deleteEntity(String id);
}
