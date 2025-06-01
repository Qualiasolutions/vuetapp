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
    return switch (entity.subtype) {
      // Pets category (1)
      EntitySubtype.pet => Icons.pets,
      EntitySubtype.vet => Icons.medical_services,
      EntitySubtype.petWalker => Icons.directions_walk,
      EntitySubtype.petGroomer => Icons.content_cut,
      EntitySubtype.petSitter => Icons.home,
      EntitySubtype.microchipCompany => Icons.memory,
      EntitySubtype.petInsuranceCompany => Icons.shield,
      EntitySubtype.petInsurancePolicy => Icons.policy,

      // Social Interests category (2)
      EntitySubtype.anniversary => Icons.favorite,
      EntitySubtype.anniversaryPlan => Icons.event_note,
      EntitySubtype.birthday => Icons.cake,
      EntitySubtype.event => Icons.event,
      EntitySubtype.guestListInvite => Icons.person_add,
      EntitySubtype.hobby => Icons.sports_esports,
      EntitySubtype.holiday => Icons.beach_access,
      EntitySubtype.holidayPlan => Icons.event_available,
      EntitySubtype.socialMedia => Icons.share,
      EntitySubtype.socialPlan => Icons.people,

      // Education category (3)
      EntitySubtype.academicPlan => Icons.school,
      EntitySubtype.courseWork => Icons.assignment,
      EntitySubtype.extracurricularPlan => Icons.sports,
      EntitySubtype.school => Icons.account_balance,
      EntitySubtype.student => Icons.person,
      EntitySubtype.subject => Icons.book,
      EntitySubtype.teacher => Icons.person,
      EntitySubtype.tutor => Icons.school,

      // Career category (4)
      EntitySubtype.colleague => Icons.badge,
      EntitySubtype.work => Icons.business_center,

      // Travel category (5)
      EntitySubtype.trip => Icons.flight,

      // Health category (6)
      EntitySubtype.beautySalon => Icons.spa,
      EntitySubtype.dentist => Icons.medical_services,
      EntitySubtype.doctor => Icons.local_hospital,
      EntitySubtype.stylist => Icons.content_cut,
      EntitySubtype.therapist => Icons.psychology,
      EntitySubtype.physiotherapist => Icons.healing,
      EntitySubtype.specialist => Icons.medical_services,
      EntitySubtype.surgeon => Icons.medical_services,

      // Home category (7)
      EntitySubtype.appliance => Icons.kitchen,
      EntitySubtype.contractor => Icons.build,
      EntitySubtype.furniture => Icons.chair,
      EntitySubtype.home => Icons.home,
      EntitySubtype.room => Icons.meeting_room,

      // Garden category (8)
      EntitySubtype.gardenTool => Icons.build,
      EntitySubtype.plant => Icons.local_florist,

      // Food category (9)
      EntitySubtype.foodPlan => Icons.restaurant_menu,
      EntitySubtype.recipe => Icons.restaurant,
      EntitySubtype.restaurant => Icons.restaurant,

      // Laundry category (10)
      EntitySubtype.dryCleaners => Icons.local_laundry_service,
      EntitySubtype.laundryItem => Icons.dry_cleaning,

      // Finance category (11)
      EntitySubtype.bank => Icons.account_balance,
      EntitySubtype.bankAccount => Icons.account_balance_wallet,
      EntitySubtype.creditCard => Icons.credit_card,

      // Transport category (12)
      EntitySubtype.boat => Icons.directions_boat,
      EntitySubtype.car => Icons.directions_car,
      EntitySubtype.publicTransport => Icons.directions_bus,
      EntitySubtype.motorcycle => Icons.motorcycle,
      EntitySubtype.bicycle => Icons.pedal_bike,
      EntitySubtype.truck => Icons.local_shipping,
      EntitySubtype.van => Icons.airport_shuttle,
      EntitySubtype.rv => Icons.rv_hookup,
      EntitySubtype.atv => Icons.terrain,
      EntitySubtype.jetSki => Icons.sailing,
        
      // Document entities (Category 14)
      EntitySubtype.document => Icons.description,
      EntitySubtype.passport => Icons.badge,
      EntitySubtype.license => Icons.card_membership,
      EntitySubtype.bankStatement => Icons.receipt,
      EntitySubtype.taxDocument => Icons.receipt_long,
      EntitySubtype.contract => Icons.description,
      EntitySubtype.will => Icons.description,
      EntitySubtype.medicalRecord => Icons.healing,
      EntitySubtype.prescription => Icons.local_pharmacy,
      EntitySubtype.resume => Icons.description,
      EntitySubtype.certificate => Icons.card_membership,
      
      // Handle any future enum extensions
      // ignore: unreachable_switch_case
      _ => Icons.folder,
    };
  }

  Color _getSubtypeColor() {
    return switch (entity.subtype) {
      // Pets category (1) - Orange
      EntitySubtype.pet ||
      EntitySubtype.vet ||
      EntitySubtype.petWalker ||
      EntitySubtype.petGroomer ||
      EntitySubtype.petSitter ||
      EntitySubtype.microchipCompany ||
      EntitySubtype.petInsuranceCompany ||
      EntitySubtype.petInsurancePolicy => const Color(0xFFE49F30),

      // Social Interests category (2) - Purple
      EntitySubtype.anniversary ||
      EntitySubtype.anniversaryPlan ||
      EntitySubtype.birthday ||
      EntitySubtype.event ||
      EntitySubtype.guestListInvite ||
      EntitySubtype.hobby ||
      EntitySubtype.holiday ||
      EntitySubtype.holidayPlan ||
      EntitySubtype.socialMedia ||
      EntitySubtype.socialPlan => const Color(0xFF9C27B0),

      // Education category (3) - Blue
      EntitySubtype.academicPlan ||
      EntitySubtype.courseWork ||
      EntitySubtype.extracurricularPlan ||
      EntitySubtype.school ||
      EntitySubtype.student ||
      EntitySubtype.subject ||
      EntitySubtype.teacher ||
      EntitySubtype.tutor => const Color(0xFF2196F3),

      // Career category (4) - Blue
      EntitySubtype.colleague ||
      EntitySubtype.work => const Color(0xFF2196F3),

      // Travel category (5) - Cyan
      EntitySubtype.trip => const Color(0xFF00BCD4),

      // Health category (6) - Green
      EntitySubtype.beautySalon ||
      EntitySubtype.dentist ||
      EntitySubtype.doctor ||
      EntitySubtype.stylist ||
      EntitySubtype.therapist ||
      EntitySubtype.physiotherapist ||
      EntitySubtype.specialist ||
      EntitySubtype.surgeon => const Color(0xFF4CAF50),

      // Home category (7) - Teal
      EntitySubtype.appliance ||
      EntitySubtype.contractor ||
      EntitySubtype.furniture ||
      EntitySubtype.home ||
      EntitySubtype.room => const Color(0xFF1A6E68),

      // Garden category (8) - Green
      EntitySubtype.gardenTool ||
      EntitySubtype.plant => const Color(0xFF4CAF50),

      // Food category (9) - Orange
      EntitySubtype.foodPlan ||
      EntitySubtype.recipe ||
      EntitySubtype.restaurant => const Color(0xFFFF9800),

      // Laundry category (10) - Blue Grey
      EntitySubtype.dryCleaners ||
      EntitySubtype.laundryItem => const Color(0xFF607D8B),

      // Finance category (11) - Brown
      EntitySubtype.bank ||
      EntitySubtype.bankAccount ||
      EntitySubtype.creditCard => const Color(0xFF795548),

      // Transport category (12) - Blue Grey
      EntitySubtype.boat ||
      EntitySubtype.car ||
      EntitySubtype.publicTransport ||
      EntitySubtype.motorcycle ||
      EntitySubtype.bicycle ||
      EntitySubtype.truck ||
      EntitySubtype.van ||
      EntitySubtype.rv ||
      EntitySubtype.atv ||
      EntitySubtype.jetSki => const Color(0xFF607D8B),
        
      // Document entities (Category 14) - Light Blue
      EntitySubtype.document ||
      EntitySubtype.passport ||
      EntitySubtype.license ||
      EntitySubtype.bankStatement ||
      EntitySubtype.taxDocument ||
      EntitySubtype.contract ||
      EntitySubtype.will ||
      EntitySubtype.medicalRecord ||
      EntitySubtype.prescription ||
      EntitySubtype.resume ||
      EntitySubtype.certificate => const Color(0xFF03A9F4),
      
      // Grey color for any other/future types
      // ignore: unreachable_switch_case
      _ => const Color(0xFF9E9E9E),
    };
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
      default:
        return Colors.blue;
    }
  }

  String _getSubtypeDisplayName() {
    return switch (entity.subtype) {
      // Pets category (1)
      EntitySubtype.pet => 'Pet',
      EntitySubtype.vet => 'Veterinarian',
      EntitySubtype.petWalker => 'Pet Walker',
      EntitySubtype.petGroomer => 'Pet Groomer',
      EntitySubtype.petSitter => 'Pet Sitter',
      EntitySubtype.microchipCompany => 'Microchip Company',
      EntitySubtype.petInsuranceCompany => 'Pet Insurance Company',
      EntitySubtype.petInsurancePolicy => 'Pet Insurance Policy',

      // Social Interests category (2)
      EntitySubtype.anniversary => 'Anniversary',
      EntitySubtype.anniversaryPlan => 'Anniversary Plan',
      EntitySubtype.birthday => 'Birthday',
      EntitySubtype.event => 'Event',
      EntitySubtype.guestListInvite => 'Guest List',
      EntitySubtype.hobby => 'Hobby',
      EntitySubtype.holiday => 'Holiday',
      EntitySubtype.holidayPlan => 'Holiday Plan',
      EntitySubtype.socialMedia => 'Social Media',
      EntitySubtype.socialPlan => 'Social Plan',

      // Education category (3)
      EntitySubtype.academicPlan => 'Academic Plan',
      EntitySubtype.courseWork => 'Course Work',
      EntitySubtype.extracurricularPlan => 'Extracurricular Plan',
      EntitySubtype.school => 'School',
      EntitySubtype.student => 'Student',
      EntitySubtype.subject => 'Subject',
      EntitySubtype.teacher => 'Teacher',
      EntitySubtype.tutor => 'Tutor',

      // Career category (4)
      EntitySubtype.colleague => 'Colleague',
      EntitySubtype.work => 'Work',

      // Travel category (5)
      EntitySubtype.trip => 'Trip',

      // Health category (6)
      EntitySubtype.beautySalon => 'Beauty Salon',
      EntitySubtype.dentist => 'Dentist',
      EntitySubtype.doctor => 'Doctor',
      EntitySubtype.stylist => 'Stylist',
      EntitySubtype.therapist => 'Therapist',
      EntitySubtype.physiotherapist => 'Physiotherapist',
      EntitySubtype.specialist => 'Medical Specialist',
      EntitySubtype.surgeon => 'Surgeon',

      // Home category (7)
      EntitySubtype.appliance => 'Appliance',
      EntitySubtype.contractor => 'Contractor',
      EntitySubtype.furniture => 'Furniture',
      EntitySubtype.home => 'Home',
      EntitySubtype.room => 'Room',

      // Garden category (8)
      EntitySubtype.gardenTool => 'Garden Tool',
      EntitySubtype.plant => 'Plant',

      // Food category (9)
      EntitySubtype.foodPlan => 'Food Plan',
      EntitySubtype.recipe => 'Recipe',
      EntitySubtype.restaurant => 'Restaurant',

      // Laundry category (10)
      EntitySubtype.dryCleaners => 'Dry Cleaners',
      EntitySubtype.laundryItem => 'Laundry Item',

      // Finance category (11)
      EntitySubtype.bank => 'Bank',
      EntitySubtype.bankAccount => 'Bank Account',
      EntitySubtype.creditCard => 'Credit Card',

      // Transport category (12)
      EntitySubtype.boat => 'Boat',
      EntitySubtype.car => 'Car',
      EntitySubtype.publicTransport => 'Public Transport',
      EntitySubtype.motorcycle => 'Motorcycle',
      EntitySubtype.bicycle => 'Bicycle',
      EntitySubtype.truck => 'Truck',
      EntitySubtype.van => 'Van',
      EntitySubtype.rv => 'RV',
      EntitySubtype.atv => 'ATV',
      EntitySubtype.jetSki => 'Jet Ski',
        
      // Document entities (Category 14)
      EntitySubtype.document => 'Document',
      EntitySubtype.passport => 'Passport',
      EntitySubtype.license => 'License',
      EntitySubtype.bankStatement => 'Bank Statement',
      EntitySubtype.taxDocument => 'Tax Document',
      EntitySubtype.contract => 'Contract',
      EntitySubtype.will => 'Will',
      EntitySubtype.medicalRecord => 'Medical Record',
      EntitySubtype.prescription => 'Prescription',
      EntitySubtype.resume => 'Resume',
      EntitySubtype.certificate => 'Certificate',
      
      // Handle any future enum extensions
      // ignore: unreachable_switch_case
      var subtype => subtype.toString().split('.').last,
    };
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
