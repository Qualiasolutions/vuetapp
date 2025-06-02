import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/entity_model.dart';
import 'package:vuet_app/providers/entity_providers.dart';

/// Provider that exposes entity CRUD operations as AsyncNotifier
class EntityActionsNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // Initial state is just void
    return;
  }

  Future<BaseEntityModel> createEntity(BaseEntityModel entity) async {
    state = const AsyncLoading();
    try {
      final entityService = ref.read(entityServiceProvider);
      final result = await entityService.createEntity(entity);
      state = const AsyncData(null);
      return result;
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      rethrow;
    }
  }

  Future<BaseEntityModel> updateEntity(BaseEntityModel entity) async {
    state = const AsyncLoading();
    try {
      final entityService = ref.read(entityServiceProvider);
      final result = await entityService.updateEntity(entity);
      state = const AsyncData(null);
      return result;
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      rethrow;
    }
  }

  Future<void> deleteEntity(String id) async {
    state = const AsyncLoading();
    try {
      final entityService = ref.read(entityServiceProvider);
      await entityService.deleteEntity(id);
      state = const AsyncData(null);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      rethrow;
    }
  }
}

/// Provider for entity actions
final entityActionsProvider = AsyncNotifierProvider<EntityActionsNotifier, void>(() {
  return EntityActionsNotifier();
}); 