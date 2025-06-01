import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../entities/entity_list_screen.dart';
import '../../../models/entity_model.dart';
import '../../screens/tasks/tag_filter_task_screen.dart';

// Subcategory definition matching React's subCategories.ts exactly
class SubCategoryItem {
  final String name;
  final String displayName;
  final IconData icon;
  final List<EntitySubtype> entityTypes;
  final String? tagName; // For TagScreen navigation
  final Color? color;

  const SubCategoryItem({
    required this.name,
    required this.displayName,
    required this.icon,
    required this.entityTypes,
    this.tagName,
    this.color,
  });
}

// Exact mapping from React's subCategories.ts
const Map<String, List<SubCategoryItem>> categorySubcategories = {
  'PETS': [
    SubCategoryItem(
      name: 'myPets',
      displayName: 'My Pets',
      icon: Icons.pets,
      entityTypes: [EntitySubtype.pet],
      color: Color(0xFFE49F30),
    ),
    SubCategoryItem(
      name: 'feedingSchedule',
      displayName: 'Feeding Schedule',
      icon: Icons.restaurant,
      entityTypes: [],
      tagName: 'PETS__FEEDING',
      color: Color(0xFF4CAF50),
    ),
    SubCategoryItem(
      name: 'exercise',
      displayName: 'Exercise',
      icon: Icons.directions_run,
      entityTypes: [],
      tagName: 'PETS__EXERCISE',
      color: Color(0xFF2196F3),
    ),
    SubCategoryItem(
      name: 'cleaningGrooming',
      displayName: 'Cleaning & Grooming',
      icon: Icons.content_cut,
      entityTypes: [EntitySubtype.groomer],
      tagName: 'PETS__GROOMING',
      color: Color(0xFF9C27B0),
    ),
    SubCategoryItem(
      name: 'health',
      displayName: 'Health',
      icon: Icons.medical_services,
      entityTypes: [EntitySubtype.vet],
      tagName: 'PETS__HEALTH',
      color: Color(0xFFF44336),
    ),
  ],
  'SOCIAL_INTERESTS': [ // MODIFIED KEY from 'SOCIAL_INTERESTS'
    SubCategoryItem(
      name: 'socialPlans',
      displayName: 'Social Plans',
      icon: Icons.people,
      entityTypes: [EntitySubtype.socialPlan],
      color: Color(0xFF9C27B0),
    ),
    SubCategoryItem(
      name: 'anniversaries',
      displayName: 'Anniversaries',
      icon: Icons.favorite,
      entityTypes: [EntitySubtype.anniversary, EntitySubtype.anniversaryPlan],
      color: Color(0xFFE91E63),
    ),
    SubCategoryItem(
      name: 'nationalHolidays',
      displayName: 'National Holidays',
      icon: Icons.flag,
      entityTypes: [EntitySubtype.holiday, EntitySubtype.holidayPlan],
      color: Color(0xFF3F51B5),
    ),
    SubCategoryItem(
      name: 'events',
      displayName: 'Events',
      icon: Icons.event,
      entityTypes: [EntitySubtype.event, EntitySubtype.eventSubentity],
      color: Color(0xFF00BCD4),
    ),
    SubCategoryItem(
      name: 'hobbies',
      displayName: 'Hobbies',
      icon: Icons.sports_esports,
      entityTypes: [EntitySubtype.hobby],
      color: Color(0xFF4CAF50),
    ),
    SubCategoryItem(
      name: 'socialMedia',
      displayName: 'Social Media',
      icon: Icons.share,
      entityTypes: [EntitySubtype.socialMedia],
      color: Color(0xFF2196F3),
    ),
  ],
  'EDUCATION': [
    SubCategoryItem(
      name: 'students',
      displayName: 'Students',
      icon: Icons.school,
      entityTypes: [EntitySubtype.student],
      color: Color(0xFF2196F3),
    ),
    SubCategoryItem(
      name: 'schools',
      displayName: 'Schools',
      icon: Icons.account_balance,
      entityTypes: [
        EntitySubtype.school,
        EntitySubtype.schoolBreak,
        EntitySubtype.schoolTerm,
        EntitySubtype.schoolYear
      ],
      color: Color(0xFF3F51B5),
    ),
    SubCategoryItem(
      name: 'academicPlans',
      displayName: 'Academic Plans',
      icon: Icons.assignment,
      entityTypes: [EntitySubtype.academicPlan],
      color: Color(0xFF4CAF50),
    ),
    SubCategoryItem(
      name: 'extracurricularPlans',
      displayName: 'Extracurricular Plans',
      icon: Icons.sports,
      entityTypes: [EntitySubtype.extracurricularPlan],
      color: Color(0xFFFF9800),
    ),
  ],
  'CAREER': [
    SubCategoryItem(
      name: 'employees',
      displayName: 'Employees',
      icon: Icons.business_center,
      entityTypes: [EntitySubtype.employee],
      color: Color(0xFF2196F3),
    ),
    SubCategoryItem(
      name: 'daysOff',
      displayName: 'Days Off',
      icon: Icons.beach_access,
      entityTypes: [EntitySubtype.daysOff],
      color: Color(0xFF4CAF50),
    ),
    SubCategoryItem(
      name: 'careerGoals',
      displayName: 'Career Goals',
      icon: Icons.trending_up,
      entityTypes: [EntitySubtype.careerGoal],
      color: Color(0xFFFF9800),
    ),
  ],
  'TRAVEL': [
    SubCategoryItem(
      name: 'myTrips',
      displayName: 'My Trips',
      icon: Icons.flight,
      entityTypes: [EntitySubtype.trip],
      color: Color(0xFF00BCD4),
    ),
    SubCategoryItem(
      name: 'myTravelPlans',
      displayName: 'My Travel Plans',
      icon: Icons.map,
      entityTypes: [EntitySubtype.travelPlan],
      color: Color(0xFF2196F3),
    ),
    SubCategoryItem(
      name: 'flights',
      displayName: 'Flights',
      icon: Icons.airplanemode_active,
      entityTypes: [EntitySubtype.flight],
      color: Color(0xFF3F51B5),
    ),
    SubCategoryItem(
      name: 'accommodation',
      displayName: 'Accommodation',
      icon: Icons.hotel,
      entityTypes: [EntitySubtype.hotelOrRental, EntitySubtype.stayWithFriend],
      color: Color(0xFF4CAF50),
    ),
    SubCategoryItem(
      name: 'transport',
      displayName: 'Transport',
      icon: Icons.directions_car,
      entityTypes: [
        EntitySubtype.rentalCar,
        EntitySubtype.taxiOrTransfer,
        EntitySubtype.trainBusFerry
      ],
      color: Color(0xFF607D8B),
    ),
  ],
  'HEALTH_BEAUTY': [ // MODIFIED KEY from 'HEALTH_BEAUTY'
    SubCategoryItem(
      name: 'patients',
      displayName: 'Patients',
      icon: Icons.person,
      entityTypes: [EntitySubtype.patient],
      color: Color(0xFF4CAF50),
    ),
    SubCategoryItem(
      name: 'appointments',
      displayName: 'Appointments',
      icon: Icons.event_available,
      entityTypes: [EntitySubtype.appointment],
      color: Color(0xFF2196F3),
    ),
    SubCategoryItem(
      name: 'healthGoals',
      displayName: 'Health Goals',
      icon: Icons.fitness_center,
      entityTypes: [EntitySubtype.healthGoal],
      color: Color(0xFFFF9800),
    ),
    SubCategoryItem(
      name: 'healthBeauty',
      displayName: 'Health & Beauty',
      icon: Icons.spa,
      entityTypes: [EntitySubtype.healthBeauty],
      color: Color(0xFFE91E63),
    ),
  ],
  'HOME': [
    SubCategoryItem(
      name: 'myHomes',
      displayName: 'My Homes',
      icon: Icons.home,
      entityTypes: [EntitySubtype.home],
      color: Color(0xFF1A6E68),
    ),
    SubCategoryItem(
      name: 'appliances',
      displayName: 'Appliances',
      icon: Icons.kitchen,
      entityTypes: [EntitySubtype.homeAppliance],
      color: Color(0xFF607D8B),
    ),
  ],
  'GARDEN': [
    SubCategoryItem(
      name: 'gardens',
      displayName: 'Gardens',
      icon: Icons.local_florist,
      entityTypes: [EntitySubtype.garden],
      color: Color(0xFF4CAF50),
    ),
  ],
  'FOOD': [
    SubCategoryItem(
      name: 'foodPlans',
      displayName: 'Food Plans',
      icon: Icons.restaurant_menu,
      entityTypes: [EntitySubtype.foodPlan],
      color: Color(0xFFFF9800),
    ),
    SubCategoryItem(
      name: 'food',
      displayName: 'Food Items',
      icon: Icons.fastfood,
      entityTypes: [EntitySubtype.food],
      color: Color(0xFFF44336),
    ),
  ],
  'LAUNDRY': [
    SubCategoryItem(
      name: 'laundryPlans',
      displayName: 'Laundry Plans',
      icon: Icons.local_laundry_service,
      entityTypes: [EntitySubtype.laundryPlan],
      color: Color(0xFF607D8B),
    ),
  ],
  'FINANCE': [
    SubCategoryItem(
      name: 'myFinances',
      displayName: 'My Finances',
      icon: Icons.account_balance,
      entityTypes: [EntitySubtype.finance],
      color: Color(0xFF795548),
    ),
  ],
  'TRANSPORT': [
    SubCategoryItem(
      name: 'cars',
      displayName: 'Cars',
      icon: Icons.directions_car,
      entityTypes: [EntitySubtype.car],
      color: Color(0xFF607D8B),
    ),
    SubCategoryItem(
      name: 'boats',
      displayName: 'Boats',
      icon: Icons.directions_boat,
      entityTypes: [EntitySubtype.boat],
      color: Color(0xFF00BCD4),
    ),
    SubCategoryItem(
      name: 'publicTransport',
      displayName: 'Public Transport',
      icon: Icons.directions_bus,
      entityTypes: [EntitySubtype.publicTransport],
      color: Color(0xFF2196F3),
    ),
    SubCategoryItem(
      name: 'vehicles',
      displayName: 'Other Vehicles',
      icon: Icons.commute,
      entityTypes: [EntitySubtype.vehicle],
      color: Color(0xFF9C27B0),
    ),
  ],
  'CHARITY_RELIGION': [
    SubCategoryItem(
      name: 'charities',
      displayName: 'Charities',
      icon: Icons.volunteer_activism,
      entityTypes: [EntitySubtype.charity, EntitySubtype.donation],
      color: Color(0xFFFF5722),
    ),
    SubCategoryItem(
      name: 'religious',
      displayName: 'Religious Organizations',
      icon: Icons.church,
      entityTypes: [EntitySubtype.religiousOrganization, EntitySubtype.religiousService],
      color: Color(0xFF9C27B0),
    ),
    SubCategoryItem(
      name: 'charityEvents',
      displayName: 'Charity Events',
      icon: Icons.event,
      entityTypes: [EntitySubtype.charityEvent],
      color: Color(0xFF4CAF50),
    ),
  ],
};

class SubCategoryScreen extends ConsumerWidget {
  final String parentCategoryName;
  final String parentCategoryId;
  final List<SubCategoryItem> subCategories;

  const SubCategoryScreen({
    super.key,
    required this.parentCategoryName,
    required this.parentCategoryId,
    required this.subCategories,
  });

  // Constructor that automatically gets subcategories from the mapping
  SubCategoryScreen.fromCategoryId({
    super.key,
    required this.parentCategoryName,
    required this.parentCategoryId,
  }) : subCategories = categorySubcategories[parentCategoryName.toUpperCase()] ?? [];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(parentCategoryName),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey.shade200,
          ),
        ),
      ),
      body: subCategories.isEmpty
          ? _buildEmptyState(context)
          : _buildSubCategoriesList(context),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 24),
            const Text(
              'No subcategories available',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              "This category doesn't have subcategories yet for ID: $parentCategoryId. Looked up with name: $parentCategoryName", // Updated and fixed string
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ), // Removed const from Text as it contains interpolation
          ],
        ),
      ),
    );
  }

  Widget _buildSubCategoriesList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: subCategories.length,
      itemBuilder: (context, index) {
        final subCategory = subCategories[index];
        return _buildSubCategoryCard(context, subCategory);
      },
    );
  }

  Widget _buildSubCategoryCard(BuildContext context, SubCategoryItem subCategory) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _navigateToSubCategory(context, subCategory, parentCategoryId),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: (subCategory.color ?? Colors.grey).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  subCategory.icon,
                  color: subCategory.color ?? Colors.grey,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subCategory.displayName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subCategory.entityTypes.isNotEmpty
                          ? '${subCategory.entityTypes.length} entity type${subCategory.entityTypes.length == 1 ? '' : 's'}'
                          : 'Task category',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToSubCategory(BuildContext context, SubCategoryItem subCategory, String currentParentCatId) {
    if (subCategory.entityTypes.isNotEmpty) {
      // First priority: Navigate to entity list screen when entity types are defined
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EntityListScreen(
            appCategoryId: _mapParentCategoryNameToAppId(currentParentCatId), // Changed to appCategoryId and new mapping function
            categoryName: subCategory.displayName, // This is the name of the sub-category, which becomes the title of the EntityListScreen
            defaultSubtypeForNew: subCategory.entityTypes.first, // Use the first entity type as the default for new items
          ),
        ),
      );
    } else if (subCategory.tagName != null) {
      // Second priority: Navigate to tag-filtered task screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TagFilterTaskScreen(
            categoryName: parentCategoryName,
            subcategoryName: subCategory.displayName,
            tagName: subCategory.tagName!,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${subCategory.displayName} not implemented yet'),
        ),
      );
    }
  }

  // Maps parent category string name (e.g., "PETS") to an integer app_category_id
  // Based on Categories-Entities-Tasks-Connection.md
  int _mapParentCategoryNameToAppId(String parentCategoryName) {
     switch (parentCategoryName.toUpperCase()) {
      case 'PETS':
        return 1;
      case 'SOCIAL_INTERESTS':
        return 2;
      case 'EDUCATION':
        return 3;
      case 'CAREER':
        return 4;
      case 'TRAVEL':
        return 5;
      case 'HEALTH_BEAUTY':
        return 6;
      case 'HOME': // HOME_GARDEN group in UI, but HOME is a distinct category
        return 7;
      case 'GARDEN':
        return 8;
      case 'FOOD':
        return 9;
      case 'LAUNDRY':
        return 10;
      case 'FINANCE':
        return 11;
      case 'TRANSPORT':
        return 12;
      // CHARITY_RELIGION was not in the list of 12 predefined categories with IDs.
      // Need to decide how to handle this. For now, returning a placeholder or throwing error.
      // Assuming 'REFERENCES' and 'EDUCATION_CAREER' are UI groupings, not direct app_category_ids.
      default:
        // Log an error or throw an exception for unmapped categories
        // For now, returning a common placeholder like 0 or -1, or a specific ID if 'Other' exists.
        // This needs to align with how `app_categories` table handles unknown/default.
        // Let's assume 0 is not a valid app_category_id and can signify an issue.
        // Warning: Unmapped parentCategoryName to app_category_id: $parentCategoryName
        return 0; // Placeholder for unmapped category
    }
  }
}
