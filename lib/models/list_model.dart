import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';
import 'list_sublist_model.dart';

part 'list_model.freezed.dart';
part 'list_model.g.dart';

@freezed
class ListModel with _$ListModel {
  const factory ListModel({
    required String id,
    required String name,
    String? description,
    required String ownerId,
    required String userId, // Maps to user_id in database
    String? familyId,
    @Default([]) List<String> sharedWith,
    @Default([]) List<ListSublist> sublists,
    @Default(false) bool isTemplate,
    String? templateCategory,
    @Default(false) bool isShoppingList,
    String? shoppingStoreId,
    @Default(0) int totalItems,
    @Default(0) int completedItems,
    @Default(false) bool isArchived,
    @Default(false) bool isDelegated,
    String? delegatedTo,
    DateTime? delegatedAt,
    String? delegationNote,
    @Default({}) Map<String, dynamic> metadata,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? lastAccessedAt,
    
    // NEW MODERNIZED FIELDS from database schema
    String? listCategoryId, // References list_categories table
    String? templateId, // References list_templates table
    @Default(false) bool createdFromTemplate,
    @Default(0.0) double completionPercentage, // Auto-calculated in DB
    String? listType, // 'planning' | 'shopping' | 'delegated'
    @Default('private') String visibility, // 'private' | 'family' | 'public'
    @Default(false) bool isFavorite,
    @Default({}) Map<String, dynamic> reminderSettings,
    @Default({}) Map<String, dynamic> settings,
    
    // Keep legacy fields for backward compatibility during migration
    String? categoryId, // Legacy field - maps to category_id in DB
    String? type, // Legacy field - maps to type in DB
  }) = _ListModel;

  factory ListModel.fromJson(Map<String, dynamic> json) => _$ListModelFromJson(json);

  // Factory constructor for creating a new list
  factory ListModel.create({
    required String name,
    String? description,
    required String ownerId,
    String? familyId,
    bool isTemplate = false,
    String? templateCategory,
    bool isShoppingList = false,
    String? shoppingStoreId,
    String? listCategoryId,
    String? templateId,
    bool createdFromTemplate = false,
    String? listType,
    String visibility = 'private',
    bool isFavorite = false,
    Map<String, dynamic>? reminderSettings,
    Map<String, dynamic>? settings,
  }) {
    final now = DateTime.now();
    return ListModel(
      id: const Uuid().v4(),
      name: name,
      description: description,
      ownerId: ownerId,
      userId: ownerId, // Set userId same as ownerId for new lists
      familyId: familyId,
      isTemplate: isTemplate,
      templateCategory: templateCategory,
      isShoppingList: isShoppingList,
      shoppingStoreId: shoppingStoreId,
      listCategoryId: listCategoryId,
      templateId: templateId,
      createdFromTemplate: createdFromTemplate,
      listType: listType ?? (isShoppingList ? 'shopping' : 'planning'),
      visibility: visibility,
      isFavorite: isFavorite,
      reminderSettings: reminderSettings ?? {},
      settings: settings ?? {},
      createdAt: now,
      updatedAt: now,
    );
  }

  // Factory constructor for creating from template
  factory ListModel.fromTemplate({
    required ListModel template,
    required String ownerId,
    String? familyId,
    String? customName,
  }) {
    final now = DateTime.now();
    return template.copyWith(
      id: const Uuid().v4(),
      name: customName ?? template.name,
      ownerId: ownerId,
      userId: ownerId,
      familyId: familyId,
      isTemplate: false,
      templateCategory: null,
      templateId: template.id, // Reference the original template
      createdFromTemplate: true,
      sharedWith: [],
      totalItems: 0,
      completedItems: 0,
      completionPercentage: 0.0,
      isArchived: false,
      isDelegated: false,
      delegatedTo: null,
      delegatedAt: null,
      delegationNote: null,
      createdAt: now,
      updatedAt: now,
      lastAccessedAt: null,
      // Copy sublists but clear their items for the new list
      sublists: template.sublists.map((sublist) => 
        sublist.copyWith(
          id: const Uuid().v4(),
          totalItems: 0,
          completedItems: 0,
          completionPercentage: 0.0,
        )
      ).toList(),
    );
  }

  // Factory constructor for creating from Supabase JSON response
  factory ListModel.fromSupabase(Map<String, dynamic> json) {
    return ListModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      ownerId: json['owner_id'] as String,
      userId: json['user_id'] as String,
      familyId: json['family_id'] as String?,
      sharedWith: (json['shared_with'] as List<dynamic>?)?.cast<String>() ?? [],
      sublists: [], // Will be loaded separately
      isTemplate: json['is_template'] as bool? ?? false,
      templateCategory: json['template_category'] as String?,
      isShoppingList: json['is_shopping_list'] as bool,
      shoppingStoreId: json['shopping_store_id'] as String?,
      totalItems: json['total_items'] as int? ?? 0,
      completedItems: json['completed_items'] as int? ?? 0,
      isArchived: json['is_archived'] as bool? ?? false,
      isDelegated: json['is_delegated'] as bool? ?? false,
      delegatedTo: json['delegated_to'] as String?,
      delegatedAt: json['delegated_at'] != null 
          ? DateTime.parse(json['delegated_at'] as String)
          : null,
      delegationNote: json['delegation_note'] as String?,
      metadata: (json['metadata'] as Map<String, dynamic>?) ?? {},
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      lastAccessedAt: json['last_accessed_at'] != null 
          ? DateTime.parse(json['last_accessed_at'] as String)
          : null,
      
      // New modernized fields
      listCategoryId: json['list_category_id'] as String?,
      templateId: json['template_id'] as String?,
      createdFromTemplate: json['created_from_template'] as bool? ?? false,
      completionPercentage: (json['completion_percentage'] as num?)?.toDouble() ?? 0.0,
      listType: json['list_type_new'] as String?, // Use new field name
      visibility: json['visibility'] as String? ?? 'private',
      isFavorite: json['is_favorite'] as bool? ?? false,
      reminderSettings: (json['reminder_settings'] as Map<String, dynamic>?) ?? {},
      settings: (json['settings'] as Map<String, dynamic>?) ?? {},
      
      // Legacy fields for backward compatibility
      categoryId: json['category_id'] as String?,
      type: json['type'] as String?,
    );
  }

}

// Extension methods for convenience
extension ListModelX on ListModel {
  // Convert to Supabase insert/update format
  Map<String, dynamic> toSupabase() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'owner_id': ownerId,
      'user_id': userId,
      'family_id': familyId,
      'shared_with': sharedWith,
      'is_template': isTemplate,
      'template_category': templateCategory,
      'is_shopping_list': isShoppingList,
      'shopping_store_id': shoppingStoreId,
      'total_items': totalItems,
      'completed_items': completedItems,
      'is_archived': isArchived,
      'is_delegated': isDelegated,
      'delegated_to': delegatedTo,
      'delegated_at': delegatedAt?.toIso8601String(),
      'delegation_note': delegationNote,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'last_accessed_at': lastAccessedAt?.toIso8601String(),
      
      // New modernized fields
      'list_category_id': listCategoryId,
      'template_id': templateId,
      'created_from_template': createdFromTemplate,
      'completion_percentage': completionPercentage,
      'list_type_new': listType,
      'visibility': visibility,
      'is_favorite': isFavorite,
      'reminder_settings': reminderSettings,
      'settings': settings,
      
      // Legacy fields
      'category_id': categoryId,
      'type': type ?? (isShoppingList ? 'shopping' : 'planning'),
    };
  }

  // Calculate completion percentage (fallback if not set from DB)
  double get calculatedCompletionPercentage {
    if (totalItems == 0) return 0.0;
    return (completedItems / totalItems) * 100;
  }

  // Use DB completion percentage if available, otherwise calculate
  double get displayCompletionPercentage {
    return completionPercentage > 0 ? completionPercentage : calculatedCompletionPercentage;
  }

  // Check if list is fully completed
  bool get isCompleted => totalItems > 0 && completedItems == totalItems;

  // Check if list is empty
  bool get isEmpty => totalItems == 0;

  // Check if user can edit this list
  bool canEdit(String userId) {
    return ownerId == userId || sharedWith.contains(userId);
  }

  // Check if list is shared
  bool get isShared => sharedWith.isNotEmpty;

  // Get display name for delegation status
  String get delegationStatus {
    if (!isDelegated) return 'Not delegated';
    if (delegatedTo != null) return 'Delegated to family member';
    return 'Delegation pending';
  }

  // Check if list needs attention (overdue, pending delegation, etc.)
  bool get needsAttention {
    // Add logic for determining if list needs attention
    // For now, return true if delegated but not completed
    return isDelegated && !isCompleted;
  }

  // Get effective list type (use new field if available, fallback to legacy logic)
  String get effectiveListType {
    return listType ?? (isShoppingList ? 'shopping' : 'planning');
  }

  // Check if this is a planning list
  bool get isPlanningList => effectiveListType == 'planning';

  // Check if this is a delegated list
  bool get isDelegatedList => effectiveListType == 'delegated' || isDelegated;

  // Get the total number of items across all sublists
  int calculateTotalItems() {
    return sublists.fold(0, (sum, sublist) => sum + sublist.totalItems);
  }

  // Get the total number of completed items across all sublists
  int calculateCompletedItems() {
    return sublists.fold(0, (sum, sublist) => sum + sublist.completedItems);
  }

  // Update the counters based on sublists
  ListModel updateCounters() {
    final newTotalItems = calculateTotalItems();
    final newCompletedItems = calculateCompletedItems();
    final newCompletionPercentage = newTotalItems > 0 
        ? (newCompletedItems / newTotalItems) * 100 
        : 0.0;
    
    return copyWith(
      totalItems: newTotalItems,
      completedItems: newCompletedItems,
      completionPercentage: newCompletionPercentage,
      updatedAt: DateTime.now(),
    );
  }

  // Add a sublist
  ListModel addSublist(ListSublist sublist) {
    final updatedSublists = [...sublists, sublist];
    return copyWith(
      sublists: updatedSublists,
      updatedAt: DateTime.now(),
    ).updateCounters();
  }

  // Remove a sublist
  ListModel removeSublist(String sublistId) {
    final updatedSublists = sublists.where((s) => s.id != sublistId).toList();
    return copyWith(
      sublists: updatedSublists,
      updatedAt: DateTime.now(),
    ).updateCounters();
  }

  // Update a sublist
  ListModel updateSublist(ListSublist updatedSublist) {
    final updatedSublists = sublists.map((s) => 
      s.id == updatedSublist.id ? updatedSublist : s
    ).toList();
    return copyWith(
      sublists: updatedSublists,
      updatedAt: DateTime.now(),
    ).updateCounters();
  }

  // Delegate the list
  ListModel delegate({
    required String delegatedTo,
    String? note,
  }) {
    return copyWith(
      isDelegated: true,
      delegatedTo: delegatedTo,
      delegatedAt: DateTime.now(),
      delegationNote: note,
      listType: 'delegated',
      updatedAt: DateTime.now(),
    );
  }

  // Remove delegation
  ListModel removeDelegation() {
    return copyWith(
      isDelegated: false,
      delegatedTo: null,
      delegatedAt: null,
      delegationNote: null,
      listType: isShoppingList ? 'shopping' : 'planning',
      updatedAt: DateTime.now(),
    );
  }

  // Archive the list
  ListModel archive() {
    return copyWith(
      isArchived: true,
      updatedAt: DateTime.now(),
    );
  }

  // Unarchive the list
  ListModel unarchive() {
    return copyWith(
      isArchived: false,
      updatedAt: DateTime.now(),
    );
  }

  // Toggle favorite status
  ListModel toggleFavorite() {
    return copyWith(
      isFavorite: !isFavorite,
      updatedAt: DateTime.now(),
    );
  }

  // Share with additional users
  ListModel shareWith(List<String> userIds) {
    final updatedSharedWith = <String>{...sharedWith, ...userIds}.toList();
    return copyWith(
      sharedWith: updatedSharedWith,
      updatedAt: DateTime.now(),
    );
  }

  // Remove sharing with specific users
  ListModel unshareWith(List<String> userIds) {
    final updatedSharedWith = sharedWith.where((id) => !userIds.contains(id)).toList();
    return copyWith(
      sharedWith: updatedSharedWith,
      updatedAt: DateTime.now(),
    );
  }

  // Update last accessed time
  ListModel markAsAccessed() {
    return copyWith(
      lastAccessedAt: DateTime.now(),
    );
  }

  // Update visibility
  ListModel updateVisibility(String newVisibility) {
    return copyWith(
      visibility: newVisibility,
      updatedAt: DateTime.now(),
    );
  }

  // Update settings
  ListModel updateSettings(Map<String, dynamic> newSettings) {
    return copyWith(
      settings: {...settings, ...newSettings},
      updatedAt: DateTime.now(),
    );
  }

  // Update reminder settings
  ListModel updateReminderSettings(Map<String, dynamic> newReminderSettings) {
    return copyWith(
      reminderSettings: {...reminderSettings, ...newReminderSettings},
      updatedAt: DateTime.now(),
    );
  }

  // Check if list has hierarchy (sublists)
  bool get hasHierarchy => sublists.isNotEmpty;

  // Search for items by name across all sublists
  List<String> searchItems(String query) {
    final lowerQuery = query.toLowerCase();
    return sublists
        .expand((sublist) => sublist.items)
        .where((item) => item.name.toLowerCase().contains(lowerQuery))
        .map((item) => item.id)
        .toList();
  }

  // Get list category display name (if category is set)
  String? get categoryDisplayName {
    // This would need to be populated by joining with list_categories table
    // For now, return null - this will be handled by the repository/provider
    return null;
  }

  // Check if this list was created from a template
  bool get isFromTemplate => createdFromTemplate && templateId != null;
}
