import 'dart:async'; // Import for Completer
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import for WidgetRef
import 'package:vuet_app/models/entity_category_model.dart';
import 'package:vuet_app/models/hierarchical_category_display_model.dart';
import 'package:vuet_app/providers/category_providers.dart'; // Import for hierarchicalCategoriesProvider
import 'package:vuet_app/utils/logger.dart';

class HierarchicalCategorySelectorDialog extends StatefulWidget {
  final List<HierarchicalCategoryDisplayModel> topLevelCategories;
  final Function(EntityCategory) onCategorySelected;

  const HierarchicalCategorySelectorDialog({
    super.key,
    required this.topLevelCategories,
    required this.onCategorySelected,
  });

  @override
  State<HierarchicalCategorySelectorDialog> createState() => _HierarchicalCategorySelectorDialogState();
}

class _HierarchicalCategorySelectorDialogState extends State<HierarchicalCategorySelectorDialog> {
  List<HierarchicalCategoryDisplayModel> _currentCategories = [];
  String _currentTitle = "Select Category";
  final List<List<HierarchicalCategoryDisplayModel>> _history = [];
  final List<String> _titleHistory = [];

  // Maps string icon names from the database to Material IconData
  IconData _getIconFromString(String? iconName) {
    if (iconName == null) return Icons.category; // Default icon
    // Ensure iconName is treated as case-insensitive for matching
    switch (iconName.toLowerCase()) {
      // Main Categories & Aliases
      case 'family':
      case 'family_restroom':
        return Icons.family_restroom;
      case 'pets':
        return Icons.pets;
      case 'social_interests':
      case 'people':
        return Icons.people;
      case 'education':
      case 'education_and_career':
      // 'school' is also a subcategory key, handled below if more specific icon needed
        return Icons.school;
      case 'career':
      // 'work' is also a subcategory key
        return Icons.work;
      case 'travel':
      // 'flight' is also a subcategory key
        return Icons.flight_takeoff; // Main travel icon
      case 'health_beauty':
      case 'health_and_beauty':
      case 'spa': // Also a direct subcategory icon string
        return Icons.spa;
      case 'home':
      case 'home_and_garden':
      // 'home_property' is a subcategory key
        return Icons.home;
      case 'garden':
      // 'garden_generic' is a subcategory key
        return Icons.local_florist; // Main garden icon
      case 'food':
      // 'restaurant' is also a subcategory key/direct icon string
        return Icons.restaurant; // Main food icon
      case 'laundry':
        return Icons.local_laundry_service;
      case 'finance':
      case 'account_balance_wallet':
      case 'account_balance':
        return Icons.account_balance_wallet;
      case 'transport':
      case 'directions_car': // Also a subcategory key 'car'
        return Icons.directions_car;
      case 'charity_religion':
      case 'church':
        return Icons.church;

      // PETS Subcategories
      case 'pet': // Generic pet, covered by main 'pets' if not distinct
        return Icons.pets_outlined;
      case 'bird':
        return Icons.flutter_dash; // Placeholder, consider Icons.emoji_nature
      case 'cat':
        return Icons.pets_outlined; // No specific Material cat icon
      case 'dog':
        return Icons.pets_outlined; // No specific Material dog icon
      case 'fish':
        return Icons.waves_outlined; 
      case 'other_pet':
        return Icons.pets_outlined;
      case 'vet':
        return Icons.medical_services_outlined;
      case 'pet_walker':
        return Icons.directions_walk_outlined;
      case 'pet_groomer':
        return Icons.content_cut_outlined;
      case 'pet_sitter':
        return Icons.home_work_outlined;
      case 'microchip_company':
        return Icons.memory_outlined;
      case 'insurance_company_pet': 
      case 'insurance_company': 
        return Icons.shield_outlined;
      case 'insurance_policy_pet': 
      case 'insurance_policy': 
        return Icons.article_outlined;
      case 'pet_birthday':
        return Icons.cake_outlined;

      // SOCIAL INTERESTS Subcategories
      case 'event':
        return Icons.event_outlined;
      case 'hobby':
        return Icons.interests_outlined;
      case 'holiday_social': // key from _iconPath
      case 'holiday': // general holiday
        return Icons.celebration_outlined;
      case 'holiday_plan_social': // key from _iconPath
      case 'holiday_plan':
        return Icons.edit_calendar_outlined;
      case 'social_plan':
        return Icons.group_outlined;
      case 'social_media':
        return Icons.share_outlined;
      case 'anniversary_plan':
        return Icons.edit_calendar_outlined;
      case 'birthday':
        return Icons.cake_outlined; // Shared with pet_birthday
      case 'anniversary':
        return Icons.auto_awesome_outlined;
      case 'event_subentity':
        return Icons.event_note_outlined;
      case 'guest_list_invite':
        return Icons.list_alt_outlined;

      // EDUCATION Subcategories
      case 'school': // Subcategory, distinct from main 'Education' if needed
        return Icons.school_outlined;
      case 'subject':
        return Icons.book_online_outlined;
      case 'course_work':
        return Icons.assignment_ind_outlined;
      case 'teacher':
        return Icons.person_pin_outlined;
      case 'tutor':
        return Icons.supervisor_account_outlined;
      case 'academic_plan':
        return Icons.assessment_outlined;
      case 'extracurricular_plan':
        return Icons.sports_soccer_outlined;
      case 'student':
        return Icons.face_retouching_natural_outlined;
      case 'school_break':
        return Icons.beach_access_outlined;
      case 'school_term':
        return Icons.date_range_outlined;
      case 'school_term_end':
        return Icons.event_available_outlined;
      case 'school_term_start':
        return Icons.event_note_outlined;
      case 'school_year_end':
        return Icons.emoji_events_outlined;
      case 'school_year_start':
        return Icons.flag_circle_outlined;

      // CAREER Subcategories
      case 'work': // Subcategory, distinct from main 'Career' if needed
        return Icons.work_outline;
      case 'colleague':
        return Icons.people_alt_outlined;
      case 'career_goal':
        return Icons.emoji_flags_outlined;
      case 'days_off':
        return Icons.weekend_outlined;
      case 'employee':
        return Icons.badge_outlined;

      // TRAVEL Subcategories
      case 'trip':
        return Icons.explore_outlined;
      case 'accommodations': // Direct name 'hotel'
      case 'hotel':
        return Icons.hotel_outlined;
      case 'attractions': // Direct name 'photo_camera'
      case 'photo_camera':
        return Icons.photo_camera_outlined;
      case 'drive_time':
        return Icons.timer_outlined;
      case 'flight': // Subcategory, distinct from main 'Travel' if needed
        return Icons.flight_outlined;
      case 'holiday_travel':
        return Icons.luggage_outlined;
      case 'holiday_plan_travel':
        return Icons.calendar_month_outlined;
      case 'hotel_or_rental':
        return Icons.holiday_village_outlined;
      case 'rental_car':
        return Icons.car_rental_outlined;
      case 'stay_with_friend':
        return Icons.night_shelter_outlined;
      case 'taxi_or_transfer':
        return Icons.local_taxi_outlined;
      case 'train_bus_ferry':
        return Icons.commute_outlined;
      case 'travel_plan':
        return Icons.map_outlined;

      // HEALTH & BEAUTY Subcategories
      case 'doctor':
        return Icons.medical_information_outlined;
      case 'dentist':
        return Icons.tag_faces_outlined;
      case 'beauty_salon':
        return Icons.storefront_outlined;
      case 'stylist':
        return Icons.cut_outlined;
      case 'appointment':
        return Icons.calendar_today_outlined;
      case 'beauty_generic': // Direct name 'spa', covered by main
        return Icons.spa_outlined; // Explicit for subcategory
      case 'fitness_activity': // Direct name 'fitness_center'
      case 'fitness_center':
        return Icons.fitness_center_outlined;
      case 'health_goal':
        return Icons.favorite_border_outlined;
      case 'medical_generic': // Direct name 'local_hospital'
      case 'local_hospital':
        return Icons.local_hospital_outlined;
      case 'patient':
        return Icons.personal_injury_outlined;

      // HOME Subcategories
      case 'home_property': // key from _iconPath
        return Icons.home_outlined; // Explicit for subcategory
      case 'room':
        return Icons.meeting_room_outlined;
      case 'furniture':
        return Icons.chair_outlined;
      case 'appliance':
        return Icons.kitchen_outlined;
      case 'contractor':
        return Icons.construction_outlined;
      case 'cleaning_home': // Direct name 'cleaning_services'
      case 'cleaning_services':
        return Icons.cleaning_services_outlined;
      case 'cooking_home': 
        return Icons.soup_kitchen_outlined;
      case 'home_maintenance_tasks': // Direct name 'home_repair_service'
      case 'home_repair_service':
        return Icons.home_repair_service_outlined;

      // GARDEN Subcategories
      case 'plant':
        return Icons.eco_outlined;
      case 'garden_tool':
        return Icons.handyman_outlined;
      case 'garden_generic':
        return Icons.grass_outlined;
      case 'gardening_tasks': // Direct name 'yard'
      case 'yard':
        return Icons.yard_outlined;
      
      // FOOD Subcategories
      case 'food_plan':
        return Icons.restaurant_menu_outlined;
      case 'recipe':
        return Icons.menu_book_outlined;
      // 'restaurant' (main food icon) also from _iconPath('restaurant')
      case 'food_generic':
        return Icons.lunch_dining_outlined;

      // LAUNDRY Subcategories
      case 'laundry_item':
        return Icons.checkroom_outlined;
      case 'dry_cleaners':
        return Icons.dry_cleaning_outlined;
      case 'clothing_laundry':
        return Icons.style_outlined; // Corrected from styler_outlined
      case 'laundry_plan':
        return Icons.event_note_outlined;

      // FINANCE Subcategories
      case 'bank': 
        return Icons.account_balance_outlined; // More specific than main finance icon
      case 'credit_card':
        return Icons.credit_card_outlined;
      case 'bank_account':
        return Icons.account_box_outlined;
      case 'finance_generic':
        return Icons.savings_outlined;

      // TRANSPORT Subcategories
      case 'car': // key from _iconPath('car'), covered by main 'transport'
        return Icons.directions_car_outlined; // Explicit for subcategory
      case 'boat': // key from _iconPath('boat')
        return Icons.directions_boat_outlined;
      case 'public_transport_cat': // key from _iconPath('public_transport')
      case 'public_transport':
        return Icons.train_outlined;

      // From Hierarchical Dialog specific additions / other existing
      case 'local_florist': // Already in Hierarchical, good for main Garden
         return Icons.local_florist_outlined;
      // 'restaurant' already handled for Food main/sub
      // 'local_laundry_service' already handled for Laundry main
      case 'favorite': // From Hierarchical, was spa, now favorite
         return Icons.favorite_outlined;

      default:
        // Consider logging unknown iconName for debugging
        // log('Unknown iconName: $iconName, using default.', name: '_getIconFromString');
        return Icons.category; // Fallback icon
    }
  }

  @override
  void initState() {
    super.initState();
    _currentCategories = widget.topLevelCategories;
    _history.add(widget.topLevelCategories);
    _titleHistory.add("Select Category");
  }

  void _navigateToSubcategories(HierarchicalCategoryDisplayModel parent) {
    setState(() {
      _history.add(parent.children);
      _titleHistory.add(parent.category.name);
      _currentCategories = parent.children;
      _currentTitle = parent.category.name;
    });
  }

  void _navigateBack() {
    if (_history.length > 1) {
      setState(() {
        _history.removeLast();
        _titleHistory.removeLast();
        _currentCategories = _history.last;
        _currentTitle = _titleHistory.last;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_history.length > 1)
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 20),
              onPressed: _navigateBack,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          Expanded(
            child: Text(
                _currentTitle, 
                textAlign: _history.length > 1 ? TextAlign.center: TextAlign.start, 
                overflow: TextOverflow.ellipsis
            ),
          ),
          if (_history.length <= 1)
             const SizedBox(width: 40) 
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.5, 
        child: _currentCategories.isEmpty
            ? const Center(child: Text('No categories available.'))
            : ListView.builder(
                itemCount: _currentCategories.length,
                itemBuilder: (context, index) {
                  final hierarchicalCategory = _currentCategories[index];
                  final category = hierarchicalCategory.category;
                  return ListTile(
                    leading: Icon(_getIconFromString(category.iconName), size: 24), // Use new icon logic
                    title: Text(category.displayName ?? category.name), // Using displayName, fallback to name
                    trailing: hierarchicalCategory.children.isNotEmpty ? const Icon(Icons.chevron_right) : null,
                    onTap: () {
                      if (hierarchicalCategory.children.isNotEmpty) {
                        _navigateToSubcategories(hierarchicalCategory);
                      } else {
                        widget.onCategorySelected(category); 
                        Navigator.of(context).pop(); 
                      }
                    },
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

Future<EntityCategory?> showHierarchicalCategorySelectorDialog(
  BuildContext context,
  WidgetRef ref // Add WidgetRef parameter
) async {
  EntityCategory? selectedCategory;

  // Watch the provider
  final hierarchicalCategoriesAsyncValue = ref.watch(hierarchicalCategoriesProvider);

  return hierarchicalCategoriesAsyncValue.when(
    data: (topLevelCategories) {
      if (topLevelCategories.isEmpty) {
        log("HierarchicalCategorySelectorDialog: No categories to display from provider.", name: 'showHierarchicalCategorySelectorDialog');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No categories available to select.')),
        );
        return null; // Return null directly if no categories
      }
      // Use a Completer to handle the async nature of showDialog returning a value
      final completer = Completer<EntityCategory?>();
      showDialog<void>( // showDialog will not directly return EntityCategory anymore
        context: context,
        builder: (BuildContext dialogContext) {
          return HierarchicalCategorySelectorDialog(
            topLevelCategories: topLevelCategories,
            onCategorySelected: (category) {
              selectedCategory = category;
              // Don't pop here, let the dialog manage its own pop or rely on standard dialog actions
            },
          );
        },
      ).then((_) {
        // When the dialog is popped (regardless of how), complete with the selectedCategory
        // This ensures that if the dialog is dismissed by tapping outside or pressing back,
        // the `selectedCategory` (which might be null if nothing was selected) is returned.
        if (!completer.isCompleted) {
          completer.complete(selectedCategory);
        }
      });
      return completer.future; // Return the future from the completer
    },
    loading: () async {
      // Optionally, show a loading indicator dialog or just return null
      // For simplicity, returning null, but a loading dialog might be better UX.
      log("HierarchicalCategorySelectorDialog: Categories loading.", name: 'showHierarchicalCategorySelectorDialog');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Loading categories...')),
      // );
      return null;
    },
    error: (error, stackTrace) async {
      log("HierarchicalCategorySelectorDialog: Error loading categories. $error", name: 'showHierarchicalCategorySelectorDialog', error: error, stackTrace: stackTrace);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading categories: ${error.toString()}')),
      );
      return null;
    },
  );
}
