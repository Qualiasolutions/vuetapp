import 'package:flutter/material.dart';
import 'package:vuet_app/models/entity_model.dart';

class EntityCard extends StatelessWidget {
  final BaseEntityModel entity;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const EntityCard({
    super.key,
    required this.entity,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  // Helper to get icon for entity subtype
  IconData _getEntityTypeIcon(EntitySubtype subtype) {
    switch (subtype) {
      // Pets
      case EntitySubtype.pet:
        return Icons.pets;
      case EntitySubtype.vet:
      case EntitySubtype.petSitter:
      case EntitySubtype.petWalker:
      case EntitySubtype.petGroomer:
        return Icons.medical_services;
        
      // Social
      case EntitySubtype.event:
      case EntitySubtype.socialPlan:
        return Icons.event;
      case EntitySubtype.holiday:
      case EntitySubtype.holidayPlan:
        return Icons.celebration;
      case EntitySubtype.hobby:
        return Icons.interests;
      case EntitySubtype.socialMedia:
        return Icons.connect_without_contact;
      case EntitySubtype.anniversary:
      case EntitySubtype.anniversaryPlan:
      case EntitySubtype.birthday:
        return Icons.cake;
        
      // Education
      case EntitySubtype.academicPlan:
      case EntitySubtype.courseWork:
      case EntitySubtype.extracurricularPlan:
      case EntitySubtype.school:
      case EntitySubtype.student:
      case EntitySubtype.subject:
      case EntitySubtype.teacher:
      case EntitySubtype.tutor:
        return Icons.school;
        
      // Career
      case EntitySubtype.colleague:
      case EntitySubtype.work:
        return Icons.work;
        
      // Travel
      case EntitySubtype.trip:
        return Icons.flight;
        
      // Health
      case EntitySubtype.beautySalon:
      case EntitySubtype.stylist:
        return Icons.spa;
      case EntitySubtype.doctor:
      case EntitySubtype.dentist:
      case EntitySubtype.therapist:
      case EntitySubtype.physiotherapist:
      case EntitySubtype.specialist:
      case EntitySubtype.surgeon:
        return Icons.local_hospital;
        
      // Home
      case EntitySubtype.appliance:
      case EntitySubtype.contractor:
      case EntitySubtype.furniture:
      case EntitySubtype.home:
      case EntitySubtype.room:
        return Icons.home;
        
      // Garden
      case EntitySubtype.gardenTool:
      case EntitySubtype.plant:
        return Icons.yard;
        
      // Food
      case EntitySubtype.foodPlan:
      case EntitySubtype.recipe:
      case EntitySubtype.restaurant:
        return Icons.restaurant;
        
      // Laundry
      case EntitySubtype.dryCleaners:
      case EntitySubtype.laundryItem:
        return Icons.local_laundry_service;
        
      // Finance
      case EntitySubtype.bank:
      case EntitySubtype.bankAccount:
      case EntitySubtype.creditCard:
        return Icons.account_balance;
        
      // Transport
      case EntitySubtype.boat:
      case EntitySubtype.car:
      case EntitySubtype.vehicleCar:
      case EntitySubtype.publicTransport:
      case EntitySubtype.motorcycle:
      case EntitySubtype.bicycle:
      case EntitySubtype.truck:
      case EntitySubtype.van:
      case EntitySubtype.rv:
      case EntitySubtype.atv:
      case EntitySubtype.jetSki:
        return Icons.directions_car;
        
      // Documents
      case EntitySubtype.document:
      case EntitySubtype.passport:
      case EntitySubtype.license:
      case EntitySubtype.bankStatement:
      case EntitySubtype.taxDocument:
      case EntitySubtype.contract:
      case EntitySubtype.will:
      case EntitySubtype.medicalRecord:
      case EntitySubtype.prescription:
      case EntitySubtype.resume:
      case EntitySubtype.certificate:
        return Icons.description;
        
      default:
        return Icons.category;
    }
  }

  // Helper to get color for entity subtype
  Color _getEntityTypeColor(EntitySubtype subtype) {
    // Get category ID for this subtype
    final categoryId = EntityTypeHelper.categoryMapping[subtype] ?? 0;
    
    switch (categoryId) {
      case 1: // Pets
        return Colors.brown;
      case 2: // Social
        return Colors.blue;
      case 3: // Education
        return Colors.green;
      case 4: // Career
        return Colors.indigo;
      case 5: // Travel
        return Colors.orange;
      case 6: // Health
        return Colors.purple;
      case 7: // Home
        return Colors.teal;
      case 8: // Garden
        return Colors.lightGreen;
      case 9: // Food
        return Colors.red;
      case 10: // Laundry
        return Colors.blueGrey;
      case 11: // Finance
        return Colors.deepPurple;
      case 12: // Transport
        return Colors.indigo;
      case 14: // Documents
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }

  // Format display name for entity subtype
  String _formatSubtypeName(EntitySubtype subtype) {
    // Convert enum to string
    final subtypeName = subtype.toString().split('.').last;
    
    // Convert camelCase to Title Case
    final words = subtypeName.replaceAllMapped(
      RegExp(r'([A-Z])'),
      (match) => ' ${match.group(0)}',
    ).trim().split(' ');
    
    // Capitalize each word
    final formattedWords = words.map((word) {
      if (word.isEmpty) return '';
      return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
    });
    
    return formattedWords.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final iconData = _getEntityTypeIcon(entity.subtype);
    final color = _getEntityTypeColor(entity.subtype);
    final subtitle = entity.description?.isNotEmpty == true 
        ? entity.description 
        : _formatSubtypeName(entity.subtype);
    
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // Header with icon and background color
            Container(
              color: color.withOpacity(0.2),
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: color.withOpacity(0.7),
                    child: Icon(iconData, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _formatSubtypeName(entity.subtype),
                      style: TextStyle(
                        fontSize: 12,
                        color: color.withOpacity(0.8),
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    ),
                ],
              ),
            ),
            
            // Entity name and details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entity.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                    ],
                    const Spacer(),
                    if (entity.customFields != null && entity.customFields!.isNotEmpty)
                      Text(
                        '${entity.customFields!.length} detail${entity.customFields!.length != 1 ? 's' : ''}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            
            // Action buttons
            if (onEdit != null || onDelete != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (onEdit != null)
                      IconButton(
                        icon: const Icon(Icons.edit, size: 18),
                        onPressed: onEdit,
                        tooltip: 'Edit',
                        visualDensity: VisualDensity.compact,
                      ),
                    if (onDelete != null)
                      IconButton(
                        icon: const Icon(Icons.delete, size: 18),
                        onPressed: onDelete,
                        tooltip: 'Delete',
                        visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),
            ],
        ),
      ),
    );
  }
}
