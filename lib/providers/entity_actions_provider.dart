import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/entity_model.dart';
import 'package:vuet_app/providers/entity_providers.dart';
import 'package:vuet_app/services/entity_service.dart' hide entityServiceProvider;

// State class for entity operations
class EntityActionsState {
  final bool isLoading;
  final String? errorMessage;
  
  const EntityActionsState({
    this.isLoading = false,
    this.errorMessage,
  });
  
  EntityActionsState copyWith({
    bool? isLoading,
    String? errorMessage,
  }) {
    return EntityActionsState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

// Notifier class for entity operations
class EntityActionsNotifier extends StateNotifier<EntityActionsState> {
  final EntityService _entityService;
  
  EntityActionsNotifier(this._entityService) : super(const EntityActionsState());
  
  Future<BaseEntityModel?> createEntity(BaseEntityModel entity) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final createdEntity = await _entityService.createEntity(entity);
      state = state.copyWith(isLoading: false);
      return createdEntity;
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to create entity: ${error.toString()}',
      );
      return null;
    }
  }
  
  Future<BaseEntityModel?> updateEntity(BaseEntityModel entity) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final updatedEntity = await _entityService.updateEntity(entity);
      state = state.copyWith(isLoading: false);
      return updatedEntity;
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update entity: ${error.toString()}',
      );
      return null;
    }
  }
  
  Future<bool> deleteEntity(String entityId) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      await _entityService.deleteEntity(entityId);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to delete entity: ${error.toString()}',
      );
      return false;
    }
  }
}

// Provider for EntityActionsNotifier
final entityActionsProvider = StateNotifierProvider<EntityActionsNotifier, EntityActionsState>((ref) {
  final entityService = ref.watch(entityServiceProvider);
  return EntityActionsNotifier(entityService);
}); 