import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vuet_app/config/supabase_config.dart';
import 'package:vuet_app/models/reference_model.dart';
import 'package:vuet_app/models/reference_group_model.dart';
import 'package:vuet_app/models/entity_reference_model.dart';
import 'package:vuet_app/repositories/reference_repository.dart';
import 'package:vuet_app/services/supabase_auth_service.dart';
import 'package:vuet_app/providers/auth_providers.dart';
import 'package:uuid/uuid.dart';

part 'supabase_reference_repository.g.dart';

class SupabaseReferenceRepository implements ReferenceRepository {
  final SupabaseClient _client = SupabaseConfig.client;
  final SupabaseAuthService _authService;
  
  SupabaseReferenceRepository(this._authService);
  
  @override
  Future<List<ReferenceModel>> getAllReferences() async {
    final response = await _client
        .from('references')
        .select()
        .order('name');
    
    return response.map((data) => ReferenceModel.fromJson(_mapReferenceFromDb(data))).toList();
  }
  
  @override
  Future<List<ReferenceGroupModel>> getAllReferenceGroups() async {
    final response = await _client
        .from('reference_groups')
        .select()
        .order('name');
    
    return response.map((data) => ReferenceGroupModel.fromJson(_mapReferenceGroupFromDb(data))).toList();
  }
  
  @override
  Future<ReferenceModel?> getReferenceById(String id) async {
    final response = await _client
        .from('references')
        .select()
        .eq('id', id)
        .maybeSingle();
    
    if (response == null) return null;
    return ReferenceModel.fromJson(_mapReferenceFromDb(response));
  }
  
  @override
  Future<ReferenceGroupModel?> getReferenceGroupById(String id) async {
    final response = await _client
        .from('reference_groups')
        .select()
        .eq('id', id)
        .maybeSingle();
    
    if (response == null) return null;
    return ReferenceGroupModel.fromJson(_mapReferenceGroupFromDb(response));
  }
  
  @override
  Future<List<ReferenceModel>> getReferencesByGroupId(String groupId) async {
    final response = await _client
        .from('references')
        .select()
        .eq('group_id', groupId)
        .order('name');
    
    return response.map((data) => ReferenceModel.fromJson(_mapReferenceFromDb(data))).toList();
  }
  
  @override
  Future<List<ReferenceModel>> getReferencesByEntityId(String entityId) async {
    final response = await _client
        .from('entity_references')
        .select('references(*)')
        .eq('entity_id', entityId);
    
    return response
        .map((data) => ReferenceModel.fromJson(_mapReferenceFromDb(data['references'])))
        .toList();
  }
  
  @override
  Future<String> createReference(ReferenceModel reference) async {
    final id = const Uuid().v4();
    final data = _mapReferenceToDb(reference.copyWith(
      id: id,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ));
    
    final response = await _client
        .from('references')
        .insert(data)
        .select()
        .single();
    
    return response['id'] as String;
  }
  
  @override
  Future<String> createReferenceGroup(ReferenceGroupModel group) async {
    final id = const Uuid().v4();
    final data = _mapReferenceGroupToDb(group.copyWith(
      id: id,
      createdBy: _authService.currentUser?.id,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ));
    
    final response = await _client
        .from('reference_groups')
        .insert(data)
        .select()
        .single();
    
    return response['id'] as String;
  }
  
  @override
  Future<void> updateReference(ReferenceModel reference) async {
    final data = _mapReferenceToDb(reference.copyWith(
      updatedAt: DateTime.now(),
    ));
    
    await _client
        .from('references')
        .update(data)
        .eq('id', reference.id);
  }
  
  @override
  Future<void> updateReferenceGroup(ReferenceGroupModel group) async {
    final data = _mapReferenceGroupToDb(group.copyWith(
      updatedAt: DateTime.now(),
    ));
    
    await _client
        .from('reference_groups')
        .update(data)
        .eq('id', group.id);
  }
  
  @override
  Future<void> deleteReference(String id) async {
    // First delete any entity references
    await _client
        .from('entity_references')
        .delete()
        .eq('reference_id', id);
    
    // Then delete the reference
    await _client
        .from('references')
        .delete()
        .eq('id', id);
  }
  
  @override
  Future<void> deleteReferenceGroup(String id) async {
    // Get all references in this group
    final references = await getReferencesByGroupId(id);
    
    // Delete all references in the group
    for (final reference in references) {
      await deleteReference(reference.id);
    }
    
    // Delete the group
    await _client
        .from('reference_groups')
        .delete()
        .eq('id', id);
  }
  
  @override
  Future<void> linkReferenceToEntity(String referenceId, String entityId) async {
    final data = EntityReferenceModel(
      id: const Uuid().v4(),
      entityId: entityId,
      referenceId: referenceId,
      createdAt: DateTime.now(),
    ).toJson();
    
    await _client
        .from('entity_references')
        .insert(data);
  }
  
  @override
  Future<void> unlinkReferenceFromEntity(String referenceId, String entityId) async {
    await _client
        .from('entity_references')
        .delete()
        .eq('reference_id', referenceId)
        .eq('entity_id', entityId);
  }
  
  // Helper methods to map between model and database fields
  Map<String, dynamic> _mapReferenceGroupFromDb(Map<String, dynamic> data) {
    return {
      'id': data['id'],
      'name': data['name'],
      'description': data['description'],
      'createdBy': data['created_by'],
      'createdAt': data['created_at'],
      'updatedAt': data['updated_at'],
    };
  }
  
  Map<String, dynamic> _mapReferenceGroupToDb(ReferenceGroupModel group) {
    return {
      'id': group.id,
      'name': group.name,
      'description': group.description,
      'created_by': group.createdBy,
      'created_at': group.createdAt?.toIso8601String(),
      'updated_at': group.updatedAt?.toIso8601String(),
    };
  }
  
  Map<String, dynamic> _mapReferenceFromDb(Map<String, dynamic> data) {
    return {
      'id': data['id'],
      'name': data['name'],
      'groupId': data['group_id'],
      'value': data['value'],
      'type': data['type'],
      'icon': data['icon'],
      'createdAt': data['created_at'],
      'updatedAt': data['updated_at'],
    };
  }
  
  Map<String, dynamic> _mapReferenceToDb(ReferenceModel reference) {
    return {
      'id': reference.id,
      'name': reference.name,
      'group_id': reference.groupId,
      'value': reference.value,
      'type': reference.type,
      'icon': reference.icon,
      'created_at': reference.createdAt?.toIso8601String(),
      'updated_at': reference.updatedAt?.toIso8601String(),
    };
  }
}

@riverpod
ReferenceRepository referenceRepository(Ref ref) {
  final authService = ref.watch(supabaseAuthServiceProvider);
  return SupabaseReferenceRepository(authService);
} 