import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/entity_model.dart';
import '../services/entity_service.dart';
import '../repositories/supabase_entity_repository.dart';
import '../repositories/supabase_category_repository.dart';
import '../repositories/supabase_entity_subcategory_repository.dart';
import 'auth_providers.dart' as auth_providers;

// Provider for EntityService
final entityServiceProvider = Provider<EntityService>((ref) {
  final entityRepository = ref.watch(supabaseEntityRepositoryProvider);
  final categoryRepository = ref.watch(supabaseCategoryRepositoryProvider);
  final authService = ref.watch(auth_providers.authServiceProvider);
  final subcategoryRepository = ref.watch(supabaseEntitySubcategoryRepositoryProvider);
  return EntityService(
    repository: entityRepository,
    categoryRepository: categoryRepository,
    authService: authService,
    subcategoryRepository: subcategoryRepository,
  );
});

// Provider for entities by category ID
final entitiesByCategoryProvider = FutureProvider.family<List<BaseEntityModel>, int>((ref, appCategoryId) async {
  final entityService = ref.watch(entityServiceProvider);
  return entityService.getEntitiesByCategory(appCategoryId);
});

// Provider for entities by subcategory ID
final entitiesBySubcategoryProvider = FutureProvider.family<List<BaseEntityModel>, (int, String)>((ref, params) async {
  final (appCategoryId, subcategoryId) = params;
  final entityService = ref.watch(entityServiceProvider);
  return entityService.getEntitiesByCategory(appCategoryId, subcategoryId: subcategoryId);
});

// Provider for a specific entity by ID
final entityByIdProvider = FutureProvider.family<BaseEntityModel?, String>((ref, entityId) async {
  final entityService = ref.watch(entityServiceProvider);
  return entityService.getEntityById(entityId);
});

// Provider for all user entities
final allUserEntitiesProvider = FutureProvider<List<BaseEntityModel>>((ref) async {
  final entityService = ref.watch(entityServiceProvider);
  return entityService.getAllUserEntities();
});
