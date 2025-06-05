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
    IconData iconData;
    switch (subtype) {
      case EntitySubtype.pet:
        iconData = Icons.pets;
        break;
      case EntitySubtype.sitter:
        iconData = Icons.night_shelter;
        break;
      case EntitySubtype.walker:
        iconData = Icons.directions_walk;
        break;
      case EntitySubtype.groomer:
        iconData = Icons.content_cut;
        break;
      case EntitySubtype.vet:
        iconData = Icons.medical_services;
        break;
      case EntitySubtype.microchipCompany:
        iconData = Icons.memory;
        break;
      case EntitySubtype.insuranceCompany:
        iconData = Icons.shield;
        break;
      case EntitySubtype.insurancePolicy:
        iconData = Icons.policy;
        break;
      case EntitySubtype.petBirthday:
        iconData = Icons.cake;
        break;
      
      // Social
      case EntitySubtype.event:
      case EntitySubtype.socialPlan:
        iconData = Icons.event;
        break;
      case EntitySubtype.holiday:
      case EntitySubtype.holidayPlan:
        iconData = Icons.celebration;
        break;
      case EntitySubtype.hobby:
        iconData = Icons.interests;
        break;
      case EntitySubtype.socialMedia:
        iconData = Icons.connect_without_contact;
        break;
      case EntitySubtype.anniversary:
      case EntitySubtype.anniversaryPlan:
      case EntitySubtype.birthday:
        iconData = Icons.cake;
        break;
        
      // Education
      case EntitySubtype.academicPlan:
      case EntitySubtype.courseWork:
      case EntitySubtype.extracurricularPlan:
      case EntitySubtype.school:
      case EntitySubtype.student:
      case EntitySubtype.subject:
      case EntitySubtype.teacher:
      case EntitySubtype.tutor:
        iconData = Icons.school;
        break;
        
      // Career
      case EntitySubtype.colleague:
      case EntitySubtype.work:
        iconData = Icons.work;
        break;
        
      // Travel
      case EntitySubtype.trip:
        iconData = Icons.flight;
        break;
        
      // Health
      case EntitySubtype.beautySalon:
      case EntitySubtype.stylist:
        iconData = Icons.spa;
        break;
      case EntitySubtype.doctor:
      case EntitySubtype.dentist:
      case EntitySubtype.therapist:
      case EntitySubtype.physiotherapist:
      case EntitySubtype.specialist:
      case EntitySubtype.surgeon:
        iconData = Icons.local_hospital;
        break;
        
      // Home
      case EntitySubtype.appliance:
      case EntitySubtype.contractor:
      case EntitySubtype.furniture:
      case EntitySubtype.home:
      case EntitySubtype.room:
        iconData = Icons.home;
        break;
        
      // Garden
      case EntitySubtype.plant:
        iconData = Icons.local_florist;
        break;
      case EntitySubtype.tool:
        iconData = Icons.build;
        break;
      case EntitySubtype.garden:
        iconData = Icons.eco;
        break;
      case EntitySubtype.gardening:
        iconData = Icons.content_paste;
        break;

      // Food
      case EntitySubtype.foodPlan:
      case EntitySubtype.recipe:
      case EntitySubtype.restaurant:
        iconData = Icons.restaurant;
        break;
        
      // Laundry
      case EntitySubtype.item:
        iconData = Icons.checkroom;
        break;
      case EntitySubtype.dryCleaners:
        iconData = Icons.local_laundry_service;
        break;
      case EntitySubtype.clothing:
        iconData = Icons.accessibility_new;
        break;
      case EntitySubtype.laundryPlan:
        iconData = Icons.event_note;
        break;
        
      // Finance
      case EntitySubtype.bank:
      case EntitySubtype.bankAccount:
      case EntitySubtype.creditCard:
        iconData = Icons.account_balance;
        break;
        
      // Transport
      case EntitySubtype.boat:
      case EntitySubtype.car:
      case EntitySubtype.vehicleCar:
      case EntitySubtype.publicTransport:
      case EntitySubtype.motorcycle:
      case EntitySubtype.other:
        iconData = Icons.directions_car;
        break;
        
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
        iconData = Icons.description;
        break;
        
      default:
        iconData = Icons.category;
    }
    return iconData;
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
              color: color.withAlpha((0.2 * 255).round()),
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: color.withAlpha((0.7 * 255).round()),
                    child: Icon(iconData, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _formatSubtypeName(entity.subtype),
                      style: TextStyle(
                        fontSize: 12,
                        color: color.withAlpha((0.8 * 255).round()),
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
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
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
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
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
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
