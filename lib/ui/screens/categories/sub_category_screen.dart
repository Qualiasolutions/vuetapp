import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/entity_model.dart';
import 'package:vuet_app/models/entity_subcategory_model.dart';
import 'package:vuet_app/ui/screens/entities/create_entity_screen.dart';
import 'package:vuet_app/ui/screens/entities/entity_list_screen.dart';
import 'package:vuet_app/constants/default_subcategories.dart';
import 'package:vuet_app/utils/logger.dart';

class SubCategoryScreen extends ConsumerStatefulWidget {
  final String categoryId;
  final String categoryName;
  final List<String> subCategoryKeys;

  const SubCategoryScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.subCategoryKeys,
  });

  @override
  ConsumerState<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends ConsumerState<SubCategoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  int _selectedTabIndex = 0;
  List<EntitySubcategoryModel> _subcategories = [];

  @override
  void initState() {
    super.initState();
    _loadSubcategories();
  }

  Future<void> _loadSubcategories() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get subcategories from the default categories or from the repository
      if (allSubcategories.containsKey(widget.categoryId)) {
        _subcategories = allSubcategories[widget.categoryId]!;
      } else {
        // Combine subcategories for all relevant category keys
        for (final key in widget.subCategoryKeys) {
          if (allSubcategories.containsKey(key)) {
            _subcategories.addAll(allSubcategories[key]!);
          }
        }
      }

      // Initialize tab controller
      _tabController = TabController(
        length: _subcategories.length,
        vsync: this,
      );

      _tabController.addListener(() {
        if (!_tabController.indexIsChanging) {
          setState(() {
            _selectedTabIndex = _tabController.index;
          });
        }
      });
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading subcategories: $e')),
      );
      log('Error loading subcategories: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Convert subcategory to entity subtype if needed
  EntitySubtype? _getEntitySubtypeForSubcategory(EntitySubcategoryModel subcategory) {
    if (subcategory.entityTypeIds.isEmpty) {
      // Fallback if entityTypeIds is empty, though this shouldn't happen with new setup
      switch (widget.categoryId) {
        case 'pets': return EntitySubtype.pet;
        case 'social_interests': return EntitySubtype.event;
        case 'education': return EntitySubtype.academicPlan;
        case 'career': return EntitySubtype.work;
        case 'travel': return EntitySubtype.trip;
        case 'health_beauty': return EntitySubtype.appointment; // Or a more generic health type
        case 'home': return EntitySubtype.home;
        case 'garden': return EntitySubtype.plant;
        case 'food': return EntitySubtype.foodPlan;
        case 'laundry': return EntitySubtype.item; // Was laundryItem, now item
        case 'finance': return EntitySubtype.bankAccount;
        case 'transport': return EntitySubtype.car;
        default: return null;
      }
    }

    final String entityTypeString = subcategory.entityTypeIds[0];

    switch (entityTypeString) {
      // Pets
      case 'Pet': return EntitySubtype.pet;
      case 'Vet': return EntitySubtype.vet;
      case 'Walker': return EntitySubtype.walker;
      case 'Groomer': return EntitySubtype.groomer;
      case 'Sitter': return EntitySubtype.sitter;
      case 'MicrochipCompany': return EntitySubtype.microchipCompany;
      case 'InsuranceCompany': return EntitySubtype.insuranceCompany;
      case 'InsurancePolicy': return EntitySubtype.insurancePolicy;
      case 'PetBirthday': return EntitySubtype.petBirthday;

      // Social Interests
      case 'Event': return EntitySubtype.event;
      case 'Hobby': return EntitySubtype.hobby;
      case 'Holiday': return EntitySubtype.holiday;
      case 'HolidayPlan': return EntitySubtype.holidayPlan;
      case 'SocialPlan': return EntitySubtype.socialPlan;
      case 'SocialMedia': return EntitySubtype.socialMedia;
      case 'AnniversaryPlan': return EntitySubtype.anniversaryPlan;
      case 'Birthday': return EntitySubtype.birthday;
      case 'Anniversary': return EntitySubtype.anniversary;
      case 'EventSubentity': return EntitySubtype.eventSubentity;
      case 'GuestListInvite': return EntitySubtype.guestListInvite;

      // Education
      case 'School': return EntitySubtype.school;
      case 'Subject': return EntitySubtype.subject;
      case 'CourseWork': return EntitySubtype.courseWork;
      case 'Teacher': return EntitySubtype.teacher;
      case 'Tutor': return EntitySubtype.tutor;
      case 'AcademicPlan': return EntitySubtype.academicPlan;
      case 'ExtracurricularPlan': return EntitySubtype.extracurricularPlan;
      case 'Student': return EntitySubtype.student;
      case 'SchoolBreak': return EntitySubtype.schoolBreak;
      case 'SchoolTerm': return EntitySubtype.schoolTerm;
      case 'SchoolTermEnd': return EntitySubtype.schoolTermEnd;
      case 'SchoolTermStart': return EntitySubtype.schoolTermStart;
      case 'SchoolYearEnd': return EntitySubtype.schoolYearEnd;
      case 'SchoolYearStart': return EntitySubtype.schoolYearStart;

      // Career
      case 'Work': return EntitySubtype.work;
      case 'Colleague': return EntitySubtype.colleague;
      case 'CareerGoal': return EntitySubtype.careerGoal;
      case 'DaysOff': return EntitySubtype.daysOff;
      case 'Employee': return EntitySubtype.employee;

      // Travel
      case 'Trip': return EntitySubtype.trip;
      case 'ACCOMMODATION': return EntitySubtype.accommodation;
      case 'PLACE': return EntitySubtype.place;
      case 'DriveTime': return EntitySubtype.driveTime;
      case 'Flight': return EntitySubtype.flight;
      case 'HotelOrRental': return EntitySubtype.hotelOrRental;
      case 'RentalCar': return EntitySubtype.rentalCar;
      case 'StayWithFriend': return EntitySubtype.stayWithFriend;
      case 'TaxiOrTransfer': return EntitySubtype.taxiOrTransfer;
      case 'TrainBusFerry': return EntitySubtype.trainBusFerry;
      case 'TravelPlan': return EntitySubtype.travelPlan;

      // Health & Beauty
      case 'Doctor': return EntitySubtype.doctor;
      case 'Dentist': return EntitySubtype.dentist;
      case 'BeautySalon': return EntitySubtype.beautySalon;
      case 'Stylist': return EntitySubtype.stylist;
      case 'Appointment': return EntitySubtype.appointment;
      case 'BEAUTY': return EntitySubtype.beauty;
      case 'FITNESS_ACTIVITY': return EntitySubtype.fitnessActivity;
      case 'HealthGoal': return EntitySubtype.healthGoal;
      case 'MEDICAL': return EntitySubtype.medical;
      case 'Patient': return EntitySubtype.patient;

      // Home
      case 'Home': return EntitySubtype.home;
      case 'Room': return EntitySubtype.room;
      case 'Furniture': return EntitySubtype.furniture;
      case 'Appliance': return EntitySubtype.appliance;
      case 'Contractor': return EntitySubtype.contractor;
      case 'CLEANING': return EntitySubtype.cleaning;
      case 'COOKING': return EntitySubtype.cooking;
      case 'HOME_MAINTENANCE': return EntitySubtype.homeMaintenance;

      // Garden
      case 'Plant': return EntitySubtype.plant;
      case 'Tool': return EntitySubtype.tool;
      case 'Garden': return EntitySubtype.garden;
      case 'GARDENING': return EntitySubtype.gardening;

      // Food
      case 'FoodPlan': return EntitySubtype.foodPlan;
      case 'Recipe': return EntitySubtype.recipe;
      case 'Restaurant': return EntitySubtype.restaurant;
      case 'Food': return EntitySubtype.food;

      // Laundry
      case 'Item': return EntitySubtype.item;
      case 'DryCleaners': return EntitySubtype.dryCleaners;
      case 'Clothing': return EntitySubtype.clothing;
      case 'LaundryPlan': return EntitySubtype.laundryPlan;

      // Finance
      case 'Bank': return EntitySubtype.bank;
      case 'CreditCard': return EntitySubtype.creditCard;
      case 'BankAccount': return EntitySubtype.bankAccount;
      case 'Finance': return EntitySubtype.finance;

      // Transport
      case 'Car': return EntitySubtype.car;
      case 'Boat': return EntitySubtype.boat;
      case 'PublicTransport': return EntitySubtype.publicTransport;

      default:
        // Fallback for any unmapped entityTypeString to category-based default
        // This could log an error/warning in a real app for unmapped types
        log('Warning: Unmapped entityTypeString: $entityTypeString for subcategory ${subcategory.name}', name: 'SubCategoryScreen');
        switch (widget.categoryId) {
          case 'pets': return EntitySubtype.pet;
          case 'social_interests': return EntitySubtype.event;
          case 'education': return EntitySubtype.academicPlan;
          case 'career': return EntitySubtype.work;
          case 'travel': return EntitySubtype.trip;
          case 'health_beauty': return EntitySubtype.appointment; 
          case 'home': return EntitySubtype.home;
          case 'garden': return EntitySubtype.plant;
          case 'food': return EntitySubtype.foodPlan;
          case 'laundry': return EntitySubtype.item;
          case 'finance': return EntitySubtype.bankAccount;
          case 'transport': return EntitySubtype.car;
          default: return EntitySubtype.general; // A very generic fallback
        }
    }
  }

  void _onCreateEntity() {
    if (_subcategories.isEmpty || _selectedTabIndex >= _subcategories.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to create entity: no subcategory selected')),
      );
      return;
    }

    final subcategory = _subcategories[_selectedTabIndex];
    final entitySubtype = _getEntitySubtypeForSubcategory(subcategory);
    
    if (entitySubtype == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to determine entity type for this subcategory')),
      );
      return;
    }

    // Get appCategoryId based on entity subtype
    int? appCategoryId = EntityTypeHelper.categoryMapping[entitySubtype];
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateEntityScreen(
          initialSubtype: entitySubtype,
          initialCategoryId: widget.categoryId,
          initialSubcategoryId: subcategory.id,
          appCategoryId: appCategoryId,
        ),
      ),
    ).then((_) {
      // Refresh the view when returning from create screen
      setState(() {});
    });
  }
  
  // Widget to show when there are no entities
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon matching the category
            Icon(
              _getCategoryIcon(widget.categoryId),
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              'You don\'t currently have any ${widget.categoryName} entities',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Add your first ${widget.categoryName} entity to get started',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _onCreateEntity,
              icon: const Icon(Icons.add),
              label: Text('Add ${widget.categoryName} Entity'),
            ),
          ],
        ),
      ),
    );
  }
  
  // Helper method to get icon for category
  IconData _getCategoryIcon(String categoryId) {
    switch (categoryId) {
      case 'pets':
        return Icons.pets;
      case 'social_interests':
        return Icons.people;
      case 'education_career':
        return Icons.school;
      case 'travel':
        return Icons.flight;
      case 'health_beauty':
        return Icons.spa;
      case 'home_garden':
        return Icons.home;
      case 'finance':
        return Icons.account_balance;
      case 'transport':
        return Icons.directions_car;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Loading Subcategories...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_subcategories.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.categoryName)),
        body: _buildEmptyState(context),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _subcategories.map((subcategory) {
            Widget iconWidget;
            if (subcategory.icon != null && subcategory.icon!.isNotEmpty) {
              iconWidget = Image.asset(
                subcategory.icon!,
                width: 24, // Example size, adjust as needed
                height: 24, // Example size, adjust as needed
                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                  log('Failed to load subcategory icon: ${subcategory.icon}, Error: $error', name: 'SubCategoryScreen');
                  return const Icon(Icons.category, size: 24); // Default icon on error
                },
              );
            } else {
              iconWidget = const Icon(Icons.category, size: 24); // Default icon if path is null or empty
            }
            return Tab(
              icon: iconWidget,
              text: subcategory.displayName,
            );
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _subcategories.map((subcategory) {
          final entitySubtype = _getEntitySubtypeForSubcategory(subcategory);
          final int? appCategoryIdForEntityList = entitySubtype != null ? EntityTypeHelper.categoryMapping[entitySubtype] : null;

          return EntityListScreen(
            categoryId: widget.categoryId,
            subcategoryId: subcategory.id,
            categoryName: widget.categoryName, // Main category name for EntityListScreen
            appCategoryId: appCategoryIdForEntityList,
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onCreateEntity,
        tooltip: 'Add New ${widget.categoryName} Entity',
        child: const Icon(Icons.add),
      ),
    );
  }
}
