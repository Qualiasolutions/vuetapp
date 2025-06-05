import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/entity_model.dart';
import 'package:vuet_app/providers/entity_providers.dart';
import 'package:vuet_app/ui/widgets/modern_components.dart';

class EntityOverviewTab extends ConsumerWidget {
  final String entityId;

  const EntityOverviewTab({
    super.key,
    required this.entityId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entityAsyncValue = ref.watch(entityByIdProvider(entityId));

    return entityAsyncValue.when(
      data: (entity) {
        if (entity == null) {
          return _buildNotFoundState();
        }
        return _buildOverviewContent(entity);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => _buildErrorState(error),
    );
  }

  Widget _buildOverviewContent(BaseEntityModel entity) {
    return SingleChildScrollView(
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

          // Metadata
          _buildMetadataSection(entity),

          const SizedBox(height: 32),
        ],
      ),
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
                                  color: (color ?? Colors.grey).withValues(alpha: 0.1),
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

  Widget _buildNotFoundState() {
    return ModernComponents.modernEmptyState(
      icon: Icons.search_off,
      title: 'Entity Not Found',
      subtitle: 'The entity you\'re looking for doesn\'t exist.',
    );
  }

  Widget _buildErrorState(Object error) {
    return ModernComponents.modernEmptyState(
      icon: Icons.error_outline,
      title: 'Error Loading Entity',
      subtitle: error.toString(),
    );
  }

  // Helper methods
  Color _getEntityColor(BaseEntityModel entity) {
    switch (entity.subtype) {
      // Pets Category - Orange
      case EntitySubtype.pet:
      case EntitySubtype.vet:
      case EntitySubtype.walker:
      case EntitySubtype.groomer:
      case EntitySubtype.sitter:
      case EntitySubtype.microchipCompany:
      case EntitySubtype.insuranceCompany:
      case EntitySubtype.insurancePolicy:
        return const Color(0xFFE49F30);
      
      // Social Category - Purple  
      case EntitySubtype.anniversary:
      case EntitySubtype.anniversaryPlan:
      case EntitySubtype.birthday:
      case EntitySubtype.event:
      case EntitySubtype.guestListInvite:
      case EntitySubtype.hobby:
      case EntitySubtype.holiday:
      case EntitySubtype.holidayPlan:
      case EntitySubtype.socialMedia:
      case EntitySubtype.socialPlan:
        return const Color(0xFF9C27B0);
      
      // Education Category - Blue
      case EntitySubtype.academicPlan:
      case EntitySubtype.courseWork:
      case EntitySubtype.extracurricularPlan:
      case EntitySubtype.school:
      case EntitySubtype.student:
      case EntitySubtype.subject:
      case EntitySubtype.teacher:
      case EntitySubtype.tutor:
        return const Color(0xFF2196F3);
      
      // Career Category - Indigo
      case EntitySubtype.colleague:
      case EntitySubtype.work:
        return const Color(0xFF3F51B5);
      
      // Travel Category - Cyan
      case EntitySubtype.trip:
        return const Color(0xFF00BCD4);
      
      // Health Category - Green
      case EntitySubtype.beautySalon:
      case EntitySubtype.dentist:
      case EntitySubtype.doctor:
      case EntitySubtype.stylist:
      case EntitySubtype.therapist:
      case EntitySubtype.physiotherapist:
      case EntitySubtype.specialist:
      case EntitySubtype.surgeon:
        return const Color(0xFF4CAF50);
      
      // Home Category - Teal
      case EntitySubtype.appliance:
      case EntitySubtype.contractor:
      case EntitySubtype.furniture:
      case EntitySubtype.home:
      case EntitySubtype.room:
        return const Color(0xFF009688);
      
      // Garden Category - Light Green
      case EntitySubtype.tool:
      case EntitySubtype.plant:
        return const Color(0xFF8BC34A);
      
      // Food Category - Orange Red
      case EntitySubtype.foodPlan:
      case EntitySubtype.recipe:
      case EntitySubtype.restaurant:
        return const Color(0xFFFF5722);
      
      // Laundry Category - Deep Purple
      case EntitySubtype.dryCleaners:
      case EntitySubtype.item:
        return const Color(0xFF673AB7);
      
      // Finance Category - Brown
      case EntitySubtype.bank:
      case EntitySubtype.bankAccount:
      case EntitySubtype.creditCard:
        return const Color(0xFF795548);
      
      // Transport Category - Blue Grey
      case EntitySubtype.boat:
      case EntitySubtype.car:
      case EntitySubtype.publicTransport:
      case EntitySubtype.motorcycle:
      case EntitySubtype.other:
        return const Color(0xFF607D8B);
        
      // Document entities and other cases
      default:
        return const Color(0xFF9E9E9E); // Grey color for any unhandled subtypes
    }
  }

  IconData _getEntityIcon(BaseEntityModel entity) {
    switch (entity.subtype) {
      case EntitySubtype.pet:
        return Icons.pets;
      case EntitySubtype.vet:
        return Icons.local_hospital;
      case EntitySubtype.walker:
        return Icons.directions_walk;
      case EntitySubtype.groomer:
        return Icons.content_cut;
      case EntitySubtype.sitter:
        return Icons.night_shelter;
      case EntitySubtype.microchipCompany:
        return Icons.memory;
      case EntitySubtype.insuranceCompany:
        return Icons.shield;
      case EntitySubtype.insurancePolicy:
        return Icons.policy;
      case EntitySubtype.birthday:
        return Icons.cake;
      case EntitySubtype.event:
        return Icons.event;
      case EntitySubtype.hobby:
        return Icons.sports_esports;
      case EntitySubtype.therapist:
        return Icons.psychology;
      case EntitySubtype.doctor:
        return Icons.local_hospital;
      case EntitySubtype.plant:
        return Icons.local_florist;
      case EntitySubtype.restaurant:
        return Icons.restaurant;
      case EntitySubtype.bank:
        return Icons.account_balance;
      case EntitySubtype.creditCard:
        return Icons.credit_card;
      case EntitySubtype.motorcycle:
        return Icons.motorcycle;
      case EntitySubtype.document:
        return Icons.description;
      case EntitySubtype.passport:
        return Icons.badge;
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
    switch (subtype) {
      case EntitySubtype.pet:
        return 'Pet';
      case EntitySubtype.vet:
        return 'Veterinarian';
      case EntitySubtype.walker:
        return 'Walker';
      case EntitySubtype.groomer:
        return 'Groomer';
      case EntitySubtype.sitter:
        return 'Sitter';
      case EntitySubtype.microchipCompany:
        return 'Microchip Company';
      case EntitySubtype.insuranceCompany:
        return 'Insurance Company';
      case EntitySubtype.insurancePolicy:
        return 'Insurance Policy';
      case EntitySubtype.birthday:
        return 'Birthday';
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
