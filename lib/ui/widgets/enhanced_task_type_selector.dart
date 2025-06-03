import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/task_type_enums.dart';
import 'package:vuet_app/ui/widgets/modern_components.dart';
import 'package:vuet_app/providers/category_providers.dart';
import 'package:vuet_app/providers/entity_providers.dart';

class EnhancedTaskTypeSelector extends ConsumerStatefulWidget {
  final TaskType? initialTaskType;
  final String? initialTaskSubtype;
  final String? initialEntityId;
  final void Function(TaskType? type, String? subtype, String? entityId) onTypeChanged;

  const EnhancedTaskTypeSelector({
    super.key,
    this.initialTaskType,
    this.initialTaskSubtype,
    this.initialEntityId,
    required this.onTypeChanged,
  });

  @override
  ConsumerState<EnhancedTaskTypeSelector> createState() => _EnhancedTaskTypeSelectorState();
}

class _EnhancedTaskTypeSelectorState extends ConsumerState<EnhancedTaskTypeSelector> {
  TaskType? _selectedTaskType;
  String? _selectedTaskSubtype;
  String? _selectedEntityId;

  @override
  void initState() {
    super.initState();
    _selectedTaskType = widget.initialTaskType;
    _selectedTaskSubtype = widget.initialTaskSubtype;
    _selectedEntityId = widget.initialEntityId;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ModernComponents.modernDropdown<TaskType>(
          label: 'Task Type',
          value: _selectedTaskType,
          items: TaskType.values.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(type.displayName),
            );
          }).toList(),
          onChanged: (type) {
            setState(() {
              _selectedTaskType = type;
              _selectedTaskSubtype = null; // Reset subtype when type changes
              _selectedEntityId = null; // Reset entity when type changes
            });
            widget.onTypeChanged(_selectedTaskType, _selectedTaskSubtype, _selectedEntityId);
          },
          validator: (value) {
            if (value == null) {
              return 'Please select a task type';
            }
            return null;
          },
        ),
        if (_selectedTaskType != null) ...[
          const SizedBox(height: 16),
          _buildSubtypeSelector(),
          const SizedBox(height: 16),
          _buildEntitySelector(),
        ],
      ],
    );
  }

  Widget _buildSubtypeSelector() {
    switch (_selectedTaskType) {
      case TaskType.transport:
        return ModernComponents.modernDropdown<TransportSubtype>(
          label: 'Transport Subtype',
          value: _selectedTaskSubtype != null
              ? TransportSubtype.values.firstWhere(
                  (e) => e.toString() == 'TransportSubtype.$_selectedTaskSubtype',
                  orElse: () => TransportSubtype.flight,
                )
              : null,
          items: TransportSubtype.values.map((subtype) {
            return DropdownMenuItem(
              value: subtype,
              child: Text(subtype.displayName),
            );
          }).toList(),
          onChanged: (subtype) {
            setState(() {
              _selectedTaskSubtype = subtype?.toString().split('.').last;
            });
            widget.onTypeChanged(_selectedTaskType, _selectedTaskSubtype, _selectedEntityId);
          },
        );
      case TaskType.activity:
        return ModernComponents.modernDropdown<ActivitySubtype>(
          label: 'Activity Subtype',
          value: _selectedTaskSubtype != null
              ? ActivitySubtype.values.firstWhere(
                  (e) => e.toString() == 'ActivitySubtype.$_selectedTaskSubtype',
                  orElse: () => ActivitySubtype.activity,
                )
              : null,
          items: ActivitySubtype.values.map((subtype) {
            return DropdownMenuItem(
              value: subtype,
              child: Text(subtype.displayName),
            );
          }).toList(),
          onChanged: (subtype) {
            setState(() {
              _selectedTaskSubtype = subtype?.toString().split('.').last;
            });
            widget.onTypeChanged(_selectedTaskType, _selectedTaskSubtype, _selectedEntityId);
          },
        );
      case TaskType.accommodation:
        return ModernComponents.modernDropdown<AccommodationSubtype>(
          label: 'Accommodation Subtype',
          value: _selectedTaskSubtype != null
              ? AccommodationSubtype.values.firstWhere(
                  (e) => e.toString() == 'AccommodationSubtype.$_selectedTaskSubtype',
                  orElse: () => AccommodationSubtype.hotel,
                )
              : null,
          items: AccommodationSubtype.values.map((subtype) {
            return DropdownMenuItem(
              value: subtype,
              child: Text(subtype.displayName),
            );
          }).toList(),
          onChanged: (subtype) {
            setState(() {
              _selectedTaskSubtype = subtype?.toString().split('.').last;
            });
            widget.onTypeChanged(_selectedTaskType, _selectedTaskSubtype, _selectedEntityId);
          },
        );
      case TaskType.anniversary:
        return ModernComponents.modernDropdown<AnniversarySubtype>(
          label: 'Anniversary Subtype',
          value: _selectedTaskSubtype != null
              ? AnniversarySubtype.values.firstWhere(
                  (e) => e.toString() == 'AnniversarySubtype.$_selectedTaskSubtype',
                  orElse: () => AnniversarySubtype.birthday,
                )
              : null,
          items: AnniversarySubtype.values.map((subtype) {
            return DropdownMenuItem(
              value: subtype,
              child: Text(subtype.displayName),
            );
          }).toList(),
          onChanged: (subtype) {
            setState(() {
              _selectedTaskSubtype = subtype?.toString().split('.').last;
            });
            widget.onTypeChanged(_selectedTaskType, _selectedTaskSubtype, _selectedEntityId);
          },
        );
      case TaskType.dueDate:
        return const SizedBox.shrink(); // No specific subtype for deadline
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildEntitySelector() {
    final entityCategoriesAsync = ref.watch(allEntityCategoriesProvider);

    return entityCategoriesAsync.when(
      data: (categories) {
        if (categories.isEmpty) {
          return const SizedBox.shrink(); // No categories available
        }

        // For now, show all entities from the first category
        // This can be enhanced later to match task types to specific categories
        final firstCategory = categories.first;
        final entitiesAsync = ref.watch(entitiesByCategoryProvider(firstCategory.appCategoryId ?? 1));

        return entitiesAsync.when(
          data: (entities) {
            if (entities.isEmpty) {
              return const SizedBox.shrink(); // No entities for this category
            }
            return ModernComponents.modernDropdown<String>(
              label: 'Link to Entity',
              value: _selectedEntityId,
              items: entities.map((entity) {
                return DropdownMenuItem(
                  value: entity.id,
                  child: Text(entity.name),
                );
              }).toList(),
              onChanged: (entityId) {
                setState(() {
                  _selectedEntityId = entityId;
                });
                widget.onTypeChanged(_selectedTaskType, _selectedTaskSubtype, _selectedEntityId);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) {
            debugPrint('Error loading entities: $error');
            return Text('Error loading entities: $error');
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) {
        debugPrint('Error loading categories: $error');
        return Text('Error loading categories: $error');
      },
    );
  }
}
