import 'package:vuet_app/models/reference_model.dart';
import 'package:vuet_app/models/reference_group_model.dart';

/// Repository interface for managing references
abstract class ReferenceRepository {
  /// Get all references
  Future<List<ReferenceModel>> getAllReferences();
  
  /// Get all reference groups
  Future<List<ReferenceGroupModel>> getAllReferenceGroups();
  
  /// Get a reference by ID
  Future<ReferenceModel?> getReferenceById(String id);
  
  /// Get a reference group by ID
  Future<ReferenceGroupModel?> getReferenceGroupById(String id);
  
  /// Get references by group ID
  Future<List<ReferenceModel>> getReferencesByGroupId(String groupId);
  
  /// Get references by entity ID
  Future<List<ReferenceModel>> getReferencesByEntityId(String entityId);
  
  /// Create a new reference
  Future<String> createReference(ReferenceModel reference);
  
  /// Create a new reference group
  Future<String> createReferenceGroup(ReferenceGroupModel group);
  
  /// Update an existing reference
  Future<void> updateReference(ReferenceModel reference);
  
  /// Update an existing reference group
  Future<void> updateReferenceGroup(ReferenceGroupModel group);
  
  /// Delete a reference
  Future<void> deleteReference(String id);
  
  /// Delete a reference group
  Future<void> deleteReferenceGroup(String id);
  
  /// Link a reference to an entity
  Future<void> linkReferenceToEntity(String referenceId, String entityId);
  
  /// Unlink a reference from an entity
  Future<void> unlinkReferenceFromEntity(String referenceId, String entityId);
} 