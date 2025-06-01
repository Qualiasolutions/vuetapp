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
      case EntitySubtype.pet:
        return Icons.pets;
      case EntitySubtype.vet:
        return Icons.medical_services;
      case EntitySubtype.walker:
        return Icons.directions_walk;
      case EntitySubtype.groomer:
        return Icons.content_cut;
      case EntitySubtype.sitter:
        return Icons.home;
      case EntitySubtype.microchipCompany:
        return Icons.memory;
      case EntitySubtype.insuranceCompany:
        return Icons.shield;
      case EntitySubtype.insurancePolicy:
        return Icons.policy;
      case EntitySubtype.event:
        return Icons.event;
      case EntitySubtype.eventSubentity:
        return Icons.event_note;
      case EntitySubtype.hobby:
        return Icons.sports_esports;
      case EntitySubtype.socialPlan:
        return Icons.people;
      case EntitySubtype.socialMedia:
        return Icons.share;
      case EntitySubtype.guestListInvite:
        return Icons.person_add;
      case EntitySubtype.academicPlan:
        return Icons.school;
      case EntitySubtype.extracurricularPlan:
        return Icons.sports;
      case EntitySubtype.school:
        return Icons.account_balance;
      case EntitySubtype.schoolBreak:
        return Icons.beach_access;
      case EntitySubtype.schoolTerm:
        return Icons.calendar_today;
      case EntitySubtype.schoolYear:
        return Icons.date_range;
      case EntitySubtype.student:
        return Icons.person;
      case EntitySubtype.careerGoal:
        return Icons.flag;
      case EntitySubtype.daysOff:
        return Icons.free_breakfast;
      case EntitySubtype.employee:
        return Icons.badge;
      case EntitySubtype.trip:
        return Icons.flight;
      case EntitySubtype.travelPlan:
        return Icons.map;
      case EntitySubtype.flight:
        return Icons.airplanemode_active;
      case EntitySubtype.trainBusFerry:
        return Icons.train;
      case EntitySubtype.rentalCar:
        return Icons.car_rental;
      case EntitySubtype.taxiOrTransfer:
        return Icons.local_taxi;
      case EntitySubtype.driveTime:
        return Icons.drive_eta;
      case EntitySubtype.hotelOrRental:
        return Icons.hotel;
      case EntitySubtype.stayWithFriend:
        return Icons.home;
      case EntitySubtype.holiday:
        return Icons.beach_access;
      case EntitySubtype.holidayPlan:
        return Icons.event_available;
      case EntitySubtype.healthBeauty:
        return Icons.spa;
      case EntitySubtype.healthGoal:
        return Icons.fitness_center;
      case EntitySubtype.patient:
        return Icons.person;
      case EntitySubtype.appointment:
        return Icons.schedule;
      case EntitySubtype.home:
        return Icons.home;
      case EntitySubtype.homeAppliance:
        return Icons.kitchen;
      case EntitySubtype.garden:
        return Icons.local_florist;
      case EntitySubtype.food:
        return Icons.restaurant;
      case EntitySubtype.foodPlan:
        return Icons.restaurant_menu;
      case EntitySubtype.laundryPlan:
        return Icons.local_laundry_service;
      case EntitySubtype.finance:
        return Icons.account_balance;
      case EntitySubtype.car:
        return Icons.directions_car;
      case EntitySubtype.boat:
        return Icons.directions_boat;
      case EntitySubtype.publicTransport:
        return Icons.directions_bus;
      case EntitySubtype.vehicle:
        return Icons.directions_car;
      case EntitySubtype.list:
        return Icons.list;
      case EntitySubtype.listEntry:
        return Icons.list_alt;
      case EntitySubtype.planningList:
        return Icons.checklist;
      case EntitySubtype.planningSublist:
        return Icons.subdirectory_arrow_right;
      case EntitySubtype.planningListItem:
        return Icons.check_box_outline_blank;
      case EntitySubtype.shoppingList:
        return Icons.shopping_cart;
      case EntitySubtype.shoppingListItem:
        return Icons.shopping_basket;
      case EntitySubtype.shoppingListStore:
        return Icons.store;
      case EntitySubtype.shoppingListDelegation:
        return Icons.person_outline;
      case EntitySubtype.anniversary:
        return Icons.favorite;
      case EntitySubtype.anniversaryPlan:
        return Icons.event_note;
      case EntitySubtype.birthday:
        return Icons.cake;
      case EntitySubtype.professionalEntity:
        return Icons.business;
      case EntitySubtype.clothing:
        return Icons.checkroom;
      // Charity & Religion entity types
      case EntitySubtype.charity:
        return Icons.volunteer_activism;
      case EntitySubtype.religiousOrganization:
        return Icons.church;
      case EntitySubtype.charityEvent:
        return Icons.event;
      case EntitySubtype.donation:
        return Icons.attach_money;
      case EntitySubtype.religiousService:
        return Icons.menu_book;
    }
  }

  Color _getSubtypeColor() {
    switch (entity.subtype) {
      case EntitySubtype.pet:
      case EntitySubtype.vet:
      case EntitySubtype.walker:
      case EntitySubtype.groomer:
      case EntitySubtype.sitter:
      case EntitySubtype.microchipCompany:
      case EntitySubtype.insuranceCompany:
      case EntitySubtype.insurancePolicy:
        return const Color(0xFFE49F30);
      case EntitySubtype.event:
      case EntitySubtype.eventSubentity:
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
      case EntitySubtype.schoolBreak:
      case EntitySubtype.schoolTerm:
      case EntitySubtype.schoolYear:
      case EntitySubtype.student:
      case EntitySubtype.careerGoal:
      case EntitySubtype.daysOff:
      case EntitySubtype.employee:
        return const Color(0xFF2196F3);
      case EntitySubtype.trip:
      case EntitySubtype.travelPlan:
      case EntitySubtype.flight:
      case EntitySubtype.trainBusFerry:
      case EntitySubtype.rentalCar:
      case EntitySubtype.taxiOrTransfer:
      case EntitySubtype.driveTime:
      case EntitySubtype.hotelOrRental:
      case EntitySubtype.stayWithFriend:
      case EntitySubtype.holiday:
      case EntitySubtype.holidayPlan:
        return const Color(0xFF00BCD4);
      case EntitySubtype.healthBeauty:
      case EntitySubtype.healthGoal:
      case EntitySubtype.patient:
      case EntitySubtype.appointment:
        return const Color(0xFF4CAF50);
      case EntitySubtype.home:
      case EntitySubtype.homeAppliance:
      case EntitySubtype.garden:
      case EntitySubtype.food:
      case EntitySubtype.foodPlan:
      case EntitySubtype.laundryPlan:
        return const Color(0xFF1A6E68);
      case EntitySubtype.finance:
      case EntitySubtype.list:
        return const Color(0xFF795548);
      case EntitySubtype.car:
      case EntitySubtype.boat:
      case EntitySubtype.publicTransport:
      case EntitySubtype.vehicle:
        return const Color(0xFF607D8B);
      // Charity & Religion entity types
      case EntitySubtype.charity:
      case EntitySubtype.donation:
      case EntitySubtype.charityEvent:
        return const Color(0xFFFF5722);
      case EntitySubtype.religiousOrganization:
      case EntitySubtype.religiousService:
        return const Color(0xFF9C27B0);
      default:
        return const Color(0xFF79858D);
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
      default:
        return Colors.blue;
    }
  }

  String _getSubtypeDisplayName() {
    switch (entity.subtype) {
      case EntitySubtype.pet:
        return 'Pet';
      case EntitySubtype.vet:
        return 'Veterinarian';
      case EntitySubtype.walker:
        return 'Dog Walker';
      case EntitySubtype.groomer:
        return 'Groomer';
      case EntitySubtype.sitter:
        return 'Pet Sitter';
      case EntitySubtype.microchipCompany:
        return 'Microchip Company';
      case EntitySubtype.insuranceCompany:
        return 'Insurance Company';
      case EntitySubtype.insurancePolicy:
        return 'Insurance Policy';
      case EntitySubtype.event:
        return 'Event';
      case EntitySubtype.eventSubentity:
        return 'Event Detail';
      case EntitySubtype.hobby:
        return 'Hobby';
      case EntitySubtype.socialPlan:
        return 'Social Plan';
      case EntitySubtype.socialMedia:
        return 'Social Media';
      case EntitySubtype.guestListInvite:
        return 'Guest List';
      case EntitySubtype.academicPlan:
        return 'Academic Plan';
      case EntitySubtype.extracurricularPlan:
        return 'Extracurricular Plan';
      case EntitySubtype.school:
        return 'School';
      case EntitySubtype.schoolBreak:
        return 'School Break';
      case EntitySubtype.schoolTerm:
        return 'School Term';
      case EntitySubtype.schoolYear:
        return 'School Year';
      case EntitySubtype.student:
        return 'Student';
      case EntitySubtype.careerGoal:
        return 'Career Goal';
      case EntitySubtype.daysOff:
        return 'Days Off';
      case EntitySubtype.employee:
        return 'Employee';
      case EntitySubtype.trip:
        return 'Trip';
      case EntitySubtype.travelPlan:
        return 'Travel Plan';
      case EntitySubtype.flight:
        return 'Flight';
      case EntitySubtype.trainBusFerry:
        return 'Train/Bus/Ferry';
      case EntitySubtype.rentalCar:
        return 'Rental Car';
      case EntitySubtype.taxiOrTransfer:
        return 'Taxi/Transfer';
      case EntitySubtype.driveTime:
        return 'Drive Time';
      case EntitySubtype.hotelOrRental:
        return 'Hotel/Rental';
      case EntitySubtype.stayWithFriend:
        return 'Stay with Friend';
      case EntitySubtype.holiday:
        return 'Holiday';
      case EntitySubtype.holidayPlan:
        return 'Holiday Plan';
      case EntitySubtype.healthBeauty:
        return 'Health & Beauty';
      case EntitySubtype.healthGoal:
        return 'Health Goal';
      case EntitySubtype.patient:
        return 'Patient';
      case EntitySubtype.appointment:
        return 'Appointment';
      case EntitySubtype.home:
        return 'Home';
      case EntitySubtype.homeAppliance:
        return 'Home Appliance';
      case EntitySubtype.garden:
        return 'Garden';
      case EntitySubtype.food:
        return 'Food';
      case EntitySubtype.foodPlan:
        return 'Food Plan';
      case EntitySubtype.laundryPlan:
        return 'Laundry Plan';
      case EntitySubtype.finance:
        return 'Finance';
      case EntitySubtype.car:
        return 'Car';
      case EntitySubtype.boat:
        return 'Boat';
      case EntitySubtype.publicTransport:
        return 'Public Transport';
      case EntitySubtype.vehicle:
        return 'Vehicle';
      case EntitySubtype.list:
        return 'List';
      case EntitySubtype.listEntry:
        return 'List Entry';
      case EntitySubtype.planningList:
        return 'Planning List';
      case EntitySubtype.planningSublist:
        return 'Planning Sublist';
      case EntitySubtype.planningListItem:
        return 'Planning Item';
      case EntitySubtype.shoppingList:
        return 'Shopping List';
      case EntitySubtype.shoppingListItem:
        return 'Shopping Item';
      case EntitySubtype.shoppingListStore:
        return 'Store';
      case EntitySubtype.shoppingListDelegation:
        return 'Shopping Delegation';
      case EntitySubtype.anniversary:
        return 'Anniversary';
      case EntitySubtype.anniversaryPlan:
        return 'Anniversary Plan';
      case EntitySubtype.birthday:
        return 'Birthday';
      case EntitySubtype.professionalEntity:
        return 'Professional';
      case EntitySubtype.clothing:
        return 'Clothing';
      // Charity & Religion entity types
      case EntitySubtype.charity:
        return 'Charity';
      case EntitySubtype.religiousOrganization:
        return 'Religious Organization';
      case EntitySubtype.charityEvent:
        return 'Charity Event';
      case EntitySubtype.donation:
        return 'Donation';
      case EntitySubtype.religiousService:
        return 'Religious Service';
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
