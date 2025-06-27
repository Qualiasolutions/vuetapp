import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/entity_model.dart';
import 'package:vuet_app/models/task_model.dart';
import 'package:vuet_app/providers/entity_providers.dart';
import 'package:vuet_app/providers/task_providers.dart';
import 'package:vuet_app/ui/screens/tasks/create_task_screen.dart';
import 'package:vuet_app/ui/screens/tasks/tag_filter_task_screen.dart';
import 'package:vuet_app/ui/theme/app_theme.dart';
import 'package:vuet_app/utils/logger.dart';

/// A provider that returns tag options based on entity type
final entityTagOptionsProvider = Provider.family<List<TagOption>, BaseEntityModel>((ref, entity) {
  // Default empty list
  List<TagOption> options = [];
  
  // Determine options based on entity subtype
  switch (entity.subtype) {
    // Pet entity types
    case EntitySubtype.pet:
      options = [
        TagOption(tag: 'PETS__FEEDING', label: 'Feeding Schedule', icon: Icons.restaurant),
        TagOption(tag: 'PETS__EXERCISE', label: 'Exercise', icon: Icons.directions_run),
        TagOption(tag: 'PETS__GROOMING', label: 'Grooming', icon: Icons.content_cut),
        TagOption(tag: 'PETS__HEALTH', label: 'Health', icon: Icons.favorite),
      ];
      break;
      
    // Social entity types
    case EntitySubtype.socialPlan:
    case EntitySubtype.event:
    case EntitySubtype.hobby:
    case EntitySubtype.socialMedia:
      options = [
        TagOption(tag: 'SOCIAL_INTERESTS__INFORMATION__PUBLIC', label: 'Social Information', icon: Icons.people),
      ];
      break;
      
    // Education entity types
    case EntitySubtype.student:
    case EntitySubtype.school:
    case EntitySubtype.academicPlan:
    case EntitySubtype.extracurricularPlan:
      options = [
        TagOption(tag: 'EDUCATION__INFORMATION__PUBLIC', label: 'Education Information', icon: Icons.school),
      ];
      break;
      
    // Career entity types
    case EntitySubtype.employee:
    case EntitySubtype.daysOff:
    case EntitySubtype.careerGoal:
      options = [
        TagOption(tag: 'CAREER__INFORMATION__PUBLIC', label: 'Career Information', icon: Icons.work),
      ];
      break;
      
    // Travel entity types
    case EntitySubtype.trip:
    case EntitySubtype.travelPlan:
      options = [
        TagOption(tag: 'TRAVEL__INFORMATION__PUBLIC', label: 'Travel Information', icon: Icons.flight),
      ];
      break;
      
    // Health & Beauty entity types
    case EntitySubtype.patient:
    case EntitySubtype.appointment:
    case EntitySubtype.healthGoal:
      options = [
        // Health & Beauty uses embedded forms instead of tags
        TagOption(tag: 'HEALTH_BEAUTY__APPOINTMENT', label: 'Schedule Appointment', icon: Icons.calendar_today),
        TagOption(tag: 'HEALTH_BEAUTY__REMINDER', label: 'Set Reminder', icon: Icons.alarm),
      ];
      break;
      
    // Home entity types
    case EntitySubtype.home:
      options = [
        TagOption(tag: 'HOME__INFORMATION__PUBLIC', label: 'Home Information', icon: Icons.home),
        TagOption(tag: 'HOME__MAINTENANCE', label: 'Home Maintenance', icon: Icons.build),
      ];
      break;
      
    // Garden entity types
    case EntitySubtype.garden:
      options = [
        TagOption(tag: 'GARDEN__INFORMATION__PUBLIC', label: 'Garden Information', icon: Icons.local_florist),
        TagOption(tag: 'GARDEN__MAINTENANCE', label: 'Garden Maintenance', icon: Icons.grass),
      ];
      break;
      
    // Food entity types
    case EntitySubtype.foodPlan:
      options = [
        TagOption(tag: 'FOOD__INFORMATION__PUBLIC', label: 'Food Information', icon: Icons.restaurant_menu),
        TagOption(tag: 'FOOD__SHOPPING', label: 'Food Shopping', icon: Icons.shopping_cart),
      ];
      break;
      
    // Laundry entity types
    case EntitySubtype.laundryPlan:
    case EntitySubtype.clothing:
      options = [
        TagOption(tag: 'LAUNDRY__INFORMATION__PUBLIC', label: 'Laundry Information', icon: Icons.local_laundry_service),
      ];
      break;
      
    // Finance entity types
    case EntitySubtype.finance:
      options = [
        TagOption(tag: 'FINANCE__INFORMATION__PUBLIC', label: 'Finance Information', icon: Icons.account_balance_wallet),
        TagOption(tag: 'FINANCE__PAYMENT', label: 'Payment Reminder', icon: Icons.payment),
      ];
      break;
      
    // Transport entity types
    case EntitySubtype.car:
    case EntitySubtype.boat:
    case EntitySubtype.publicTransport:
      options = [
        TagOption(tag: 'TRANSPORT__INFORMATION__PUBLIC', label: 'Transport Information', icon: Icons.directions_car),
        TagOption(tag: 'TRANSPORT__MAINTENANCE', label: 'Maintenance Reminder', icon: Icons.build),
        TagOption(tag: 'TRANSPORT__INSURANCE', label: 'Insurance Reminder', icon: Icons.policy),
      ];
      break;
      
    // Charity & Religion entity types (replacing References)
    case EntitySubtype.referenceGroup:
    case EntitySubtype.reference:
      options = [
        TagOption(tag: 'CHARITY_RELIGION__DONATION', label: 'Donation Reminder', icon: Icons.volunteer_activism),
        TagOption(tag: 'CHARITY_RELIGION__EVENT', label: 'Event Reminder', icon: Icons.event),
      ];
      break;
      
    default:
      // For unknown entity types, provide generic options
      options = [
        TagOption(tag: 'GENERAL__REMINDER', label: 'Set Reminder', icon: Icons.notifications),
        TagOption(tag: 'GENERAL__TASK', label: 'Create Task', icon: Icons.check_circle),
      ];
  }
  
  return options;
});

/// Model class for tag options
class TagOption {
  final String tag;
  final String label;
  final IconData icon;
  
  const TagOption({
    required this.tag,
    required this.label,
    required this.icon,
  });
}

/// Shows the "I WANT TO" menu as a modal bottom sheet
class IWantToMenu extends ConsumerWidget {
  /// The entity for which to show options
  final BaseEntityModel entity;
  
  /// Optional callback when an action is selected
  final Function(String tag)? onActionSelected;
  
  /// Constructor
  const IWantToMenu({
    super.key,
    required this.entity,
    this.onActionSelected,
  });
  
  /// Static method to show the menu as a modal bottom sheet
  static Future<void> show(BuildContext context, BaseEntityModel entity) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.3,
        maxChildSize: 0.8,
        expand: false,
        builder: (context, scrollController) => IWantToMenu(
          entity: entity,
          onActionSelected: (tag) {
            Navigator.pop(context);
            // Handle the action after dismissing the sheet
            _handleTagAction(context, entity, tag);
          },
        ),
      ),
    );
  }
  
  /// Static method to handle tag actions
  static void _handleTagAction(BuildContext context, BaseEntityModel entity, String tag) {
    // Get category and subcategory names for navigation
    final String categoryName = entity.categoryName ?? 'Category';
    final String subcategoryName = entity.subcategoryName ?? 'Subcategory';
    
    // Navigate to tag filter screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TagFilterTaskScreen(
          categoryName: categoryName,
          subcategoryName: subcategoryName,
          tagName: tag,
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get tag options for this entity
    final options = ref.watch(entityTagOptionsProvider(entity));
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'I WANT TO...',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(),
          
          // Options list
          if (options.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('No actions available for this item'),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options[index];
                  return ListTile(
                    leading: Icon(option.icon, color: AppTheme.primary),
                    title: Text(option.label),
                    onTap: () {
                      if (onActionSelected != null) {
                        onActionSelected!(option.tag);
                      } else {
                        Navigator.pop(context);
                        _handleTagAction(context, entity, option.tag);
                      }
                    },
                  );
                },
              ),
            ),
          
          // Create new task button
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Create New Task'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateTaskScreen(
                      linkedEntity: entity,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accent,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Extension method to easily show the I WANT TO menu from any entity
extension IWantToMenuExtension on BaseEntityModel {
  void showIWantToMenu(BuildContext context) {
    IWantToMenu.show(context, this);
  }
}
