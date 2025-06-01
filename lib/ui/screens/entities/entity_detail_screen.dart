import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/entity_model.dart';
import 'package:vuet_app/providers/entity_providers.dart';
import 'package:vuet_app/ui/screens/entities/create_edit_entity_screen.dart';
import 'package:vuet_app/ui/widgets/modern_components.dart';
import 'package:vuet_app/models/task_model.dart';
import 'package:vuet_app/providers/task_providers.dart';
import 'package:vuet_app/ui/screens/tasks/task_detail_screen.dart';
import 'package:vuet_app/ui/screens/tasks/create_task_screen.dart';
import 'package:vuet_app/ui/widgets/task_card.dart';

class EntityDetailScreen extends ConsumerWidget {
  final String entityId;

  const EntityDetailScreen({
    super.key,
    required this.entityId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entityAsyncValue = ref.watch(entityDetailProvider(entityId));

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: entityAsyncValue.when(
        data: (entity) {
          if (entity == null) {
            return _buildNotFoundState(context);
          }
          return _buildEntityDetail(context, ref, entity);
        },
        loading: () => _buildLoadingState(),
        error: (error, stackTrace) => _buildErrorState(context, error),
      ),
      floatingActionButton: entityAsyncValue.when(
        data: (entity) {
          if (entity == null) return null;
          return FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CreateTaskScreen(
                    linkedEntityId: entity.id,
                    linkedEntityName: entity.name,
                  ),
                ),
              );
            },
            tooltip: 'Create Task',
            child: const Icon(Icons.add_task),
          );
        },
        loading: () => null,
        error: (_, __) => null,
      ),
    );
  }

  Widget _buildEntityDetail(BuildContext context, WidgetRef ref, BaseEntityModel entity) {
    // Watch tasks related to this entity
    final relatedTasksAsyncValue = ref.watch(tasksByEntityIdProvider(entity.id!));
    
    return CustomScrollView(
      slivers: [
        // App Bar
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          backgroundColor: _getEntityColor(entity),
          foregroundColor: Colors.white,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              entity.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(0, 1),
                    blurRadius: 2.0,
                    color: Color.fromARGB(150, 0, 0, 0),
                  ),
                ],
              ),
            ),
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _getEntityColor(entity),
                    _getEntityColor(entity).withAlpha((0.8 * 255).round()),
                  ],
                ),
              ),
              child: Center(
                child: Icon(
                  _getEntityIcon(entity),
                  size: 80,
                  color: Colors.white.withAlpha((0.3 * 255).round()),
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _navigateToEdit(context, entity),
            ),
            PopupMenuButton<String>(
              onSelected: (value) => _handleMenuAction(context, ref, entity, value),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'duplicate',
                  child: ListTile(
                    leading: Icon(Icons.copy),
                    title: Text('Duplicate'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete, color: Colors.red),
                    title: Text('Delete', style: TextStyle(color: Colors.red)),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ],
        ),

        // Content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Entity Type Card
                _buildInfoCard(
                  title: 'Type',
                  content: _getSubtypeDisplayName(entity.subtype),
                  icon: _getEntityIcon(entity),
                  color: _getEntityColor(entity),
                ),

                const SizedBox(height: 16),

                // Description Card
                if (entity.description != null && entity.description!.isNotEmpty)
                  _buildInfoCard(
                    title: 'Description',
                    content: entity.description!,
                    icon: Icons.description,
                  ),

                const SizedBox(height: 16),

                // Status and Due Date Row
                Row(
                  children: [
                    if (entity.status != null)
                      Expanded(
                        child: _buildInfoCard(
                          title: 'Status',
                          content: entity.status!,
                          icon: Icons.info,
                          color: _getStatusColor(entity.status!),
                        ),
                      ),
                    if (entity.status != null && entity.dueDate != null)
                      const SizedBox(width: 16),
                    if (entity.dueDate != null)
                      Expanded(
                        child: _buildInfoCard(
                          title: 'Due Date',
                          content: _formatDate(entity.dueDate!),
                          icon: Icons.schedule,
                          color: _getDueDateColor(entity.dueDate!),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 16),

                // Custom Fields
                if (entity.customFields != null && entity.customFields!.isNotEmpty)
                  _buildCustomFieldsSection(entity.customFields!),

                const SizedBox(height: 16),

                // Related Tasks Section
                _buildRelatedTasksSection(context, ref, entity, relatedTasksAsyncValue),

                const SizedBox(height: 16),

                // Metadata
                _buildMetadataSection(entity),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRelatedTasksSection(
    BuildContext context, 
    WidgetRef ref, 
    BaseEntityModel entity, 
    AsyncValue<List<TaskModel>> relatedTasksAsyncValue
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Related Tasks',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CreateTaskScreen(
                      linkedEntityId: entity.id,
                      linkedEntityName: entity.name,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Task'),
              style: TextButton.styleFrom(
                foregroundColor: _getEntityColor(entity),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        relatedTasksAsyncValue.when(
          data: (tasks) {
            if (tasks.isEmpty) {
              return ModernComponents.modernCard(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.task_alt,
                          size: 48,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No tasks linked to this ${_getSubtypeDisplayName(entity.subtype).toLowerCase()} yet',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CreateTaskScreen(
                                  linkedEntityId: entity.id,
                                  linkedEntityName: entity.name,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Create Task'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _getEntityColor(entity),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            
            return Column(
              children: tasks.map((task) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TaskDetailScreen(taskId: task.id),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: TaskCard(task: task),
                ),
              )).toList(),
            );
          },
          loading: () => Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(_getEntityColor(entity)),
              ),
            ),
          ),
          error: (error, _) => ModernComponents.modernCard(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading tasks: $error',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => ref.refresh(tasksByEntityIdProvider(entity.id!)),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String content,
    required IconData icon,
    Color? color,
  }) {
    return ModernComponents.modernCard(
      margin: EdgeInsets.zero,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (color ?? Colors.grey).withAlpha((0.1 * 255).round()),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color ?? Colors.grey.shade600,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomFieldsSection(Map<String, dynamic> customFields) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 12),
        ...customFields.entries.map((entry) {
          if (entry.value == null || entry.value.toString().isEmpty) {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildInfoCard(
              title: _formatFieldName(entry.key),
              content: entry.value.toString(),
              icon: _getFieldIcon(entry.key),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildMetadataSection(BaseEntityModel entity) {
    return ModernComponents.modernCard(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 16),
          _buildMetadataRow('Created', _formatDate(entity.createdAt)),
          if (entity.updatedAt != null) ...[
            const SizedBox(height: 8),
            _buildMetadataRow('Updated', _formatDate(entity.updatedAt!)),
          ],
          if (entity.id != null) ...[
            const SizedBox(height: 8),
            _buildMetadataRow('ID', entity.id!),
          ],
        ],
      ),
    );
  }

  Widget _buildMetadataRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: ModernComponents.modernEmptyState(
        icon: Icons.error_outline,
        title: 'Error Loading Entity',
        subtitle: error.toString(),
        buttonText: 'Go Back',
        onButtonPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildNotFoundState(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Not Found'),
      ),
      body: ModernComponents.modernEmptyState(
        icon: Icons.search_off,
        title: 'Entity Not Found',
        subtitle: 'The entity you\'re looking for doesn\'t exist or has been deleted.',
        buttonText: 'Go Back',
        onButtonPressed: () => Navigator.pop(context),
      ),
    );
  }

  void _navigateToEdit(BuildContext context, BaseEntityModel entity) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateEditEntityScreen(
          appCategoryId: entity.appCategoryId ?? 0, // Changed to appCategoryId, assuming 0 for null
          entityId: entity.id,
        ),
      ),
    );
  }

  void _handleMenuAction(BuildContext context, WidgetRef ref, BaseEntityModel entity, String action) {
    switch (action) {
      case 'duplicate':
        _duplicateEntity(context, ref, entity);
        break;
      case 'delete':
        _showDeleteConfirmation(context, ref, entity);
        break;
    }
  }

  void _duplicateEntity(BuildContext context, WidgetRef ref, BaseEntityModel entity) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateEditEntityScreen(
          appCategoryId: entity.appCategoryId ?? 0, // Changed to appCategoryId, assuming 0 for null
          // TODO: Pass the duplicated entity data - this would need to be implemented
          // For now, just navigate to create screen with the same category
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, BaseEntityModel entity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Entity'),
        content: Text('Are you sure you want to delete "${entity.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              try {
                await ref.read(entityActionsProvider.notifier).deleteEntity(entity.id!);
                if (context.mounted) {
                  Navigator.pop(context); // Go back to list
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${entity.name} deleted successfully')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete entity: $e')),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // Helper methods
  Color _getEntityColor(BaseEntityModel entity) {
    // Use the same color logic as EntityCard
    switch (entity.subtype) {
      case EntitySubtype.pet:
      case EntitySubtype.vet:
      case EntitySubtype.petWalker:
      case EntitySubtype.petGroomer:
      case EntitySubtype.petSitter:
      case EntitySubtype.microchipCompany:
      case EntitySubtype.petInsuranceCompany:
      case EntitySubtype.petInsurancePolicy:
        return const Color(0xFFE49F30);
      case EntitySubtype.event:
      case EntitySubtype.hobby:
      case EntitySubtype.socialPlan:
      case EntitySubtype.socialMedia:
      case EntitySubtype.guestListInvite:
      case EntitySubtype.anniversary:
      case EntitySubtype.anniversaryPlan:
      case EntitySubtype.birthday:
        return const Color(0xFF9C27B0);
      case EntitySubtype.academicPlan:
      case EntitySubtype.extracurricularPlan:
      case EntitySubtype.school:
      case EntitySubtype.student:
      case EntitySubtype.teacher:
      case EntitySubtype.tutor:
      case EntitySubtype.courseWork:
      case EntitySubtype.subject:
      case EntitySubtype.colleague:
      case EntitySubtype.work:
        return const Color(0xFF2196F3);
      case EntitySubtype.trip:
      case EntitySubtype.holiday:
      case EntitySubtype.holidayPlan:
        return const Color(0xFF00BCD4);
      case EntitySubtype.beautySalon:
      case EntitySubtype.dentist:
      case EntitySubtype.doctor:
      case EntitySubtype.stylist:
        return const Color(0xFF4CAF50);
      case EntitySubtype.home:
      case EntitySubtype.room:
      case EntitySubtype.appliance:
      case EntitySubtype.contractor:
      case EntitySubtype.furniture:
      case EntitySubtype.gardenTool:
      case EntitySubtype.plant:
      case EntitySubtype.recipe:
      case EntitySubtype.restaurant:
      case EntitySubtype.foodPlan:
      case EntitySubtype.laundryItem:
      case EntitySubtype.dryCleaners:
        return const Color(0xFF1A6E68);
      case EntitySubtype.bank:
      case EntitySubtype.bankAccount:
      case EntitySubtype.creditCard:
        return const Color(0xFF795548);
      case EntitySubtype.car:
      case EntitySubtype.boat:
      case EntitySubtype.publicTransport:
        return const Color(0xFF607D8B);
    }
  }

  IconData _getEntityIcon(BaseEntityModel entity) {
    // Use the same icon logic as EntityCard
    switch (entity.subtype) {
      case EntitySubtype.pet:
        return Icons.pets;
      case EntitySubtype.vet:
        return Icons.medical_services;
      case EntitySubtype.car:
        return Icons.directions_car;
      case EntitySubtype.home:
        return Icons.home;
      case EntitySubtype.event:
        return Icons.event;
      case EntitySubtype.hobby:
        return Icons.sports_esports;
      default:
        return Icons.folder;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'completed':
        return Colors.green;
      case 'pending':
      case 'in_progress':
        return Colors.orange;
      case 'cancelled':
      case 'expired':
        return Colors.red;
      case 'draft':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  Color _getDueDateColor(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now).inDays;
    
    if (difference < 0) {
      return Colors.red; // Overdue
    } else if (difference <= 3) {
      return Colors.orange; // Due soon
    } else {
      return Colors.green; // Future
    }
  }

  String _getSubtypeDisplayName(EntitySubtype subtype) {
    // Use the same display name logic as EntityCard
    switch (subtype) {
      case EntitySubtype.pet:
        return 'Pet';
      case EntitySubtype.vet:
        return 'Veterinarian';
      case EntitySubtype.car:
        return 'Car';
      case EntitySubtype.home:
        return 'Home';
      case EntitySubtype.event:
        return 'Event';
      case EntitySubtype.hobby:
        return 'Hobby';
      default:
        return subtype.toString().split('.').last;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatFieldName(String fieldName) {
    return fieldName
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  IconData _getFieldIcon(String fieldName) {
    switch (fieldName.toLowerCase()) {
      case 'email':
        return Icons.email;
      case 'phone':
      case 'phonenumber':
        return Icons.phone;
      case 'address':
        return Icons.location_on;
      case 'website':
      case 'url':
        return Icons.link;
      case 'date':
      case 'dateofbirth':
        return Icons.calendar_today;
      case 'price':
      case 'cost':
      case 'budget':
        return Icons.attach_money;
      default:
        return Icons.info;
    }
  }
}
