import 'package:flutter/material.dart';
import 'package:vuet_app/models/entity_model.dart';
import 'package:vuet_app/ui/widgets/modern_components.dart';

class EntityCard extends StatelessWidget {
  final BaseEntityModel entity;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool showSubtype;

  const EntityCard({
    super.key,
    required this.entity,
    this.onTap,
    this.onLongPress,
    this.showSubtype = true,
  });

  @override
  Widget build(BuildContext context) {
    return ModernComponents.modernCard(
      onTap: onTap,
      margin: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon and subtype
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getSubtypeColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getSubtypeIcon(),
                  color: _getSubtypeColor(),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entity.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (showSubtype) ...[
                      const SizedBox(height: 2),
                      Text(
                        _getSubtypeDisplayName(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Description if available
          if (entity.description != null && entity.description!.isNotEmpty) ...[
            Text(
              entity.description!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
          ],
          
          // Status and due date row
          Row(
            children: [
              // Status indicator
              if (entity.status != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getStatusColor().withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    entity.status!,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              
              // Due date if available
              if (entity.dueDate != null) ...[
                Icon(
                  Icons.schedule,
                  size: 14,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 4),
                Text(
                  _formatDueDate(entity.dueDate!),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
              
              const Spacer(),
              
              // More options button
              if (onLongPress != null)
                GestureDetector(
                  onTap: onLongPress,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.more_vert,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getSubtypeIcon() {
    switch (entity.subtype) {
      // Pets category (1)
      case EntitySubtype.pet:
        return Icons.pets;
      case EntitySubtype.vet:
        return Icons.medical_services;
      case EntitySubtype.petWalker:
        return Icons.directions_walk;
      case EntitySubtype.petGroomer:
        return Icons.content_cut;
      case EntitySubtype.petSitter:
        return Icons.home;
      case EntitySubtype.microchipCompany:
        return Icons.memory;
      case EntitySubtype.petInsuranceCompany:
        return Icons.shield;
      case EntitySubtype.petInsurancePolicy:
        return Icons.policy;

      // Social Interests category (2)
      case EntitySubtype.anniversary:
        return Icons.favorite;
      case EntitySubtype.anniversaryPlan:
        return Icons.event_note;
      case EntitySubtype.birthday:
        return Icons.cake;
      case EntitySubtype.event:
        return Icons.event;
      case EntitySubtype.guestListInvite:
        return Icons.person_add;
      case EntitySubtype.hobby:
        return Icons.sports_esports;
      case EntitySubtype.holiday:
        return Icons.beach_access;
      case EntitySubtype.holidayPlan:
        return Icons.event_available;
      case EntitySubtype.socialMedia:
        return Icons.share;
      case EntitySubtype.socialPlan:
        return Icons.people;

      // Education category (3)
      case EntitySubtype.academicPlan:
        return Icons.school;
      case EntitySubtype.courseWork:
        return Icons.assignment;
      case EntitySubtype.extracurricularPlan:
        return Icons.sports;
      case EntitySubtype.school:
        return Icons.account_balance;
      case EntitySubtype.student:
        return Icons.person;
      case EntitySubtype.subject:
        return Icons.book;
      case EntitySubtype.teacher:
        return Icons.person;
      case EntitySubtype.tutor:
        return Icons.school;

      // Career category (4)
      case EntitySubtype.colleague:
        return Icons.badge;
      case EntitySubtype.work:
        return Icons.business_center;

      // Travel category (5)
      case EntitySubtype.trip:
        return Icons.flight;

      // Health category (6)
      case EntitySubtype.beautySalon:
        return Icons.spa;
      case EntitySubtype.dentist:
        return Icons.medical_services;
      case EntitySubtype.doctor:
        return Icons.local_hospital;
      case EntitySubtype.stylist:
        return Icons.content_cut;
      case EntitySubtype.therapist:
        return Icons.psychology;
      case EntitySubtype.physiotherapist:
        return Icons.healing;
      case EntitySubtype.specialist:
        return Icons.medical_services;
      case EntitySubtype.surgeon:
        return Icons.medical_services;

      // Home category (7)
      case EntitySubtype.appliance:
        return Icons.kitchen;
      case EntitySubtype.contractor:
        return Icons.build;
      case EntitySubtype.furniture:
        return Icons.chair;
      case EntitySubtype.home:
        return Icons.home;
      case EntitySubtype.room:
        return Icons.meeting_room;

      // Garden category (8)
      case EntitySubtype.gardenTool:
        return Icons.build;
      case EntitySubtype.plant:
        return Icons.local_florist;

      // Food category (9)
      case EntitySubtype.foodPlan:
        return Icons.restaurant_menu;
      case EntitySubtype.recipe:
        return Icons.restaurant;
      case EntitySubtype.restaurant:
        return Icons.restaurant;

      // Laundry category (10)
      case EntitySubtype.dryCleaners:
        return Icons.local_laundry_service;
      case EntitySubtype.laundryItem:
        return Icons.dry_cleaning;

      // Finance category (11)
      case EntitySubtype.bank:
        return Icons.account_balance;
      case EntitySubtype.bankAccount:
        return Icons.account_balance_wallet;
      case EntitySubtype.creditCard:
        return Icons.credit_card;

      // Transport category (12)
      case EntitySubtype.boat:
        return Icons.directions_boat;
      case EntitySubtype.car:
        return Icons.directions_car;
      case EntitySubtype.publicTransport:
        return Icons.directions_bus;
      case EntitySubtype.motorcycle:
        return Icons.motorcycle;
      case EntitySubtype.bicycle:
        return Icons.pedal_bike;
      case EntitySubtype.truck:
        return Icons.local_shipping;
      case EntitySubtype.van:
        return Icons.airport_shuttle;
      case EntitySubtype.rv:
        return Icons.rv_hookup;
      case EntitySubtype.atv:
        return Icons.terrain;
      case EntitySubtype.jetSki:
        return Icons.sailing;
        
      // Document entities (Category 14)
      case EntitySubtype.document:
        return Icons.description;
      case EntitySubtype.passport:
        return Icons.badge;
      case EntitySubtype.license:
        return Icons.card_membership;
      case EntitySubtype.bankStatement:
        return Icons.receipt;
      case EntitySubtype.taxDocument:
        return Icons.receipt_long;
      case EntitySubtype.contract:
        return Icons.description;
      case EntitySubtype.will:
        return Icons.description;
      case EntitySubtype.medicalRecord:
        return Icons.healing;
      case EntitySubtype.prescription:
        return Icons.local_pharmacy;
      case EntitySubtype.resume:
        return Icons.description;
      case EntitySubtype.certificate:
        return Icons.card_membership;
        
      default:
        return Icons.folder;
    }
  }

  Color _getSubtypeColor() {
    switch (entity.subtype) {
      // Pets category (1) - Orange
      case EntitySubtype.pet:
      case EntitySubtype.vet:
      case EntitySubtype.petWalker:
      case EntitySubtype.petGroomer:
      case EntitySubtype.petSitter:
      case EntitySubtype.microchipCompany:
      case EntitySubtype.petInsuranceCompany:
      case EntitySubtype.petInsurancePolicy:
        return const Color(0xFFE49F30);

      // Social Interests category (2) - Purple
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

      // Education category (3) - Blue
      case EntitySubtype.academicPlan:
      case EntitySubtype.courseWork:
      case EntitySubtype.extracurricularPlan:
      case EntitySubtype.school:
      case EntitySubtype.student:
      case EntitySubtype.subject:
      case EntitySubtype.teacher:
      case EntitySubtype.tutor:
        return const Color(0xFF2196F3);

      // Career category (4) - Blue
      case EntitySubtype.colleague:
      case EntitySubtype.work:
        return const Color(0xFF2196F3);

      // Travel category (5) - Cyan
      case EntitySubtype.trip:
        return const Color(0xFF00BCD4);

      // Health category (6) - Green
      case EntitySubtype.beautySalon:
      case EntitySubtype.dentist:
      case EntitySubtype.doctor:
      case EntitySubtype.stylist:
      case EntitySubtype.therapist:
      case EntitySubtype.physiotherapist:
      case EntitySubtype.specialist:
      case EntitySubtype.surgeon:
        return const Color(0xFF4CAF50);

      // Home category (7) - Teal
      case EntitySubtype.appliance:
      case EntitySubtype.contractor:
      case EntitySubtype.furniture:
      case EntitySubtype.home:
      case EntitySubtype.room:
        return const Color(0xFF1A6E68);

      // Garden category (8) - Green
      case EntitySubtype.gardenTool:
      case EntitySubtype.plant:
        return const Color(0xFF4CAF50);

      // Food category (9) - Orange
      case EntitySubtype.foodPlan:
      case EntitySubtype.recipe:
      case EntitySubtype.restaurant:
        return const Color(0xFFFF9800);

      // Laundry category (10) - Blue Grey
      case EntitySubtype.dryCleaners:
      case EntitySubtype.laundryItem:
        return const Color(0xFF607D8B);

      // Finance category (11) - Brown
      case EntitySubtype.bank:
      case EntitySubtype.bankAccount:
      case EntitySubtype.creditCard:
        return const Color(0xFF795548);

      // Transport category (12) - Blue Grey
      case EntitySubtype.boat:
      case EntitySubtype.car:
      case EntitySubtype.publicTransport:
      case EntitySubtype.motorcycle:
      case EntitySubtype.bicycle:
      case EntitySubtype.truck:
      case EntitySubtype.van:
      case EntitySubtype.rv:
      case EntitySubtype.atv:
      case EntitySubtype.jetSki:
        return const Color(0xFF607D8B);
        
      // Document entities (Category 14) - Light Blue
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
        return const Color(0xFF03A9F4);
        
      // Grey color for any unhandled subtypes
        return const Color(0xFF9E9E9E);
    }
  }

  Color _getStatusColor() {
    switch (entity.status?.toLowerCase()) {
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
      // Default color for other statuses
        return Colors.blue;
    }
  }

  String _getSubtypeDisplayName() {
    switch (entity.subtype) {
      // Pets category (1)
      case EntitySubtype.pet:
        return 'Pet';
      case EntitySubtype.vet:
        return 'Veterinarian';
      case EntitySubtype.petWalker:
        return 'Pet Walker';
      case EntitySubtype.petGroomer:
        return 'Pet Groomer';
      case EntitySubtype.petSitter:
        return 'Pet Sitter';
      case EntitySubtype.microchipCompany:
        return 'Microchip Company';
      case EntitySubtype.petInsuranceCompany:
        return 'Pet Insurance Company';
      case EntitySubtype.petInsurancePolicy:
        return 'Pet Insurance Policy';

      // Social Interests category (2)
      case EntitySubtype.anniversary:
        return 'Anniversary';
      case EntitySubtype.anniversaryPlan:
        return 'Anniversary Plan';
      case EntitySubtype.birthday:
        return 'Birthday';
      case EntitySubtype.event:
        return 'Event';
      case EntitySubtype.guestListInvite:
        return 'Guest List';
      case EntitySubtype.hobby:
        return 'Hobby';
      case EntitySubtype.holiday:
        return 'Holiday';
      case EntitySubtype.holidayPlan:
        return 'Holiday Plan';
      case EntitySubtype.socialMedia:
        return 'Social Media';
      case EntitySubtype.socialPlan:
        return 'Social Plan';

      // Education category (3)
      case EntitySubtype.academicPlan:
        return 'Academic Plan';
      case EntitySubtype.courseWork:
        return 'Course Work';
      case EntitySubtype.extracurricularPlan:
        return 'Extracurricular Plan';
      case EntitySubtype.school:
        return 'School';
      case EntitySubtype.student:
        return 'Student';
      case EntitySubtype.subject:
        return 'Subject';
      case EntitySubtype.teacher:
        return 'Teacher';
      case EntitySubtype.tutor:
        return 'Tutor';

      // Career category (4)
      case EntitySubtype.colleague:
        return 'Colleague';
      case EntitySubtype.work:
        return 'Work';

      // Travel category (5)
      case EntitySubtype.trip:
        return 'Trip';

      // Health category (6)
      case EntitySubtype.beautySalon:
        return 'Beauty Salon';
      case EntitySubtype.dentist:
        return 'Dentist';
      case EntitySubtype.doctor:
        return 'Doctor';
      case EntitySubtype.stylist:
        return 'Stylist';
      case EntitySubtype.therapist:
        return 'Therapist';
      case EntitySubtype.physiotherapist:
        return 'Physiotherapist';
      case EntitySubtype.specialist:
        return 'Medical Specialist';
      case EntitySubtype.surgeon:
        return 'Surgeon';

      // Home category (7)
      case EntitySubtype.appliance:
        return 'Appliance';
      case EntitySubtype.contractor:
        return 'Contractor';
      case EntitySubtype.furniture:
        return 'Furniture';
      case EntitySubtype.home:
        return 'Home';
      case EntitySubtype.room:
        return 'Room';

      // Garden category (8)
      case EntitySubtype.gardenTool:
        return 'Garden Tool';
      case EntitySubtype.plant:
        return 'Plant';

      // Food category (9)
      case EntitySubtype.foodPlan:
        return 'Food Plan';
      case EntitySubtype.recipe:
        return 'Recipe';
      case EntitySubtype.restaurant:
        return 'Restaurant';

      // Laundry category (10)
      case EntitySubtype.dryCleaners:
        return 'Dry Cleaners';
      case EntitySubtype.laundryItem:
        return 'Laundry Item';

      // Finance category (11)
      case EntitySubtype.bank:
        return 'Bank';
      case EntitySubtype.bankAccount:
        return 'Bank Account';
      case EntitySubtype.creditCard:
        return 'Credit Card';

      // Transport category (12)
      case EntitySubtype.boat:
        return 'Boat';
      case EntitySubtype.car:
        return 'Car';
      case EntitySubtype.publicTransport:
        return 'Public Transport';
      case EntitySubtype.motorcycle:
        return 'Motorcycle';
      case EntitySubtype.bicycle:
        return 'Bicycle';
      case EntitySubtype.truck:
        return 'Truck';
      case EntitySubtype.van:
        return 'Van';
      case EntitySubtype.rv:
        return 'RV';
      case EntitySubtype.atv:
        return 'ATV';
      case EntitySubtype.jetSki:
        return 'Jet Ski';
        
      // Document entities (Category 14)
      case EntitySubtype.document:
        return 'Document';
      case EntitySubtype.passport:
        return 'Passport';
      case EntitySubtype.license:
        return 'License';
      case EntitySubtype.bankStatement:
        return 'Bank Statement';
      case EntitySubtype.taxDocument:
        return 'Tax Document';
      case EntitySubtype.contract:
        return 'Contract';
      case EntitySubtype.will:
        return 'Will';
      case EntitySubtype.medicalRecord:
        return 'Medical Record';
      case EntitySubtype.prescription:
        return 'Prescription';
      case EntitySubtype.resume:
        return 'Resume';
      case EntitySubtype.certificate:
        return 'Certificate';
        
      default:
        return entity.subtype.toString().split('.').last;
    }
  }

  String _formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now).inDays;
    
    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else if (difference == -1) {
      return 'Yesterday';
    } else if (difference > 0) {
      return 'In $difference days';
    } else {
      return '${difference.abs()} days ago';
    }
  }
}
