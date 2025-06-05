import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/entity_model.dart';
import 'package:vuet_app/models/entity_subcategory_model.dart';
import 'package:vuet_app/ui/screens/entities/create_edit_entity_screen.dart';
import 'package:vuet_app/ui/screens/entities/entity_list_screen.dart';
import 'package:vuet_app/constants/default_subcategories.dart';
import 'package:vuet_app/utils/logger.dart';
import 'package:vuet_app/utils/entity_type_helper.dart' as helper_util;

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
  TabController? _tabController;
  bool _isLoading = true;
  List<EntitySubcategoryModel> _subcategories = [];

  // Placeholder for dropdown values
  String? _quickNavValue;
  String? _iWantToValue;

  // Define transport specific sections
  final List<String> _transportSections = [
    'Cars & Motorcycles',
    'Boats & Other',
    'Public Transport',
    'My Transport Information',
    'Transport Preferences',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.categoryName != 'Transport') {
      _loadSubcategoriesForTabs();
    } else {
      // For Transport, we don't need to load subcategories for tabs
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadSubcategoriesForTabs() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get subcategories from the default categories or from the repository
      _subcategories = [];
      if (allSubcategories.containsKey(widget.categoryId)) {
        _subcategories = allSubcategories[widget.categoryId]!;
      } else if (widget.subCategoryKeys.isNotEmpty && allSubcategories.containsKey(widget.subCategoryKeys.first)) {
        _subcategories = allSubcategories[widget.subCategoryKeys.first]!;
      } else {
        for (final key in widget.subCategoryKeys) {
          if (allSubcategories.containsKey(key)) {
            _subcategories.addAll(allSubcategories[key]!);
          }
        }
      }

      if (_subcategories.isNotEmpty) {
      _tabController = TabController(
        length: _subcategories.length,
        vsync: this,
      );

        _tabController!.addListener(() {
          if (!mounted) return;
        });
      } else {
        log('No subcategories found for tabbing for category: ${widget.categoryName}', name: 'SubCategoryScreen');
      }
    } catch (e, s) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading subcategories: $e')),
      );
      log('Error loading subcategories: $e', name: 'SubCategoryScreen', stackTrace: s);
    } finally {
      // ignore: control_flow_in_finally
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  EntitySubtype? _getEntitySubtypeForSubcategory(EntitySubcategoryModel subcategory) {
    if (widget.categoryName == 'Transport') {
      return null;
    }

    if (subcategory.entityTypeIds.isEmpty) {
      log('Warning: entityTypeIds is empty for subcategory ${subcategory.name}', name: 'SubCategoryScreen');
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
        default: return EntitySubtype.general;
      }
    }

    final String entityTypeString = subcategory.entityTypeIds[0];

    switch (entityTypeString) {
      case 'Pet': return EntitySubtype.pet;
      case 'Vet': return EntitySubtype.vet;
      case 'Walker': return EntitySubtype.walker;
      case 'Groomer': return EntitySubtype.groomer;
      case 'Sitter': return EntitySubtype.sitter;
      case 'MicrochipCompany': return EntitySubtype.microchipCompany;
      case 'InsuranceCompany': return EntitySubtype.insuranceCompany;
      case 'InsurancePolicy': return EntitySubtype.insurancePolicy;
      case 'PetBirthday': return EntitySubtype.petBirthday;
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
      case 'Work': return EntitySubtype.work;
      case 'Colleague': return EntitySubtype.colleague;
      case 'CareerGoal': return EntitySubtype.careerGoal;
      case 'DaysOff': return EntitySubtype.daysOff;
      case 'Employee': return EntitySubtype.employee;
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
      case 'Home': return EntitySubtype.home;
      case 'Room': return EntitySubtype.room;
      case 'Furniture': return EntitySubtype.furniture;
      case 'Appliance': return EntitySubtype.appliance;
      case 'Contractor': return EntitySubtype.contractor;
      case 'CLEANING': return EntitySubtype.cleaning;
      case 'COOKING': return EntitySubtype.cooking;
      case 'HOME_MAINTENANCE': return EntitySubtype.homeMaintenance;
      case 'Plant': return EntitySubtype.plant;
      case 'Tool': return EntitySubtype.tool;
      case 'Garden': return EntitySubtype.garden;
      case 'GARDENING': return EntitySubtype.gardening;
      case 'FoodPlan': return EntitySubtype.foodPlan;
      case 'Recipe': return EntitySubtype.recipe;
      case 'Restaurant': return EntitySubtype.restaurant;
      case 'Food': return EntitySubtype.food;
      case 'Item': return EntitySubtype.item;
      case 'DryCleaners': return EntitySubtype.dryCleaners;
      case 'Clothing': return EntitySubtype.clothing;
      case 'LaundryPlan': return EntitySubtype.laundryPlan;
      case 'Bank': return EntitySubtype.bank;
      case 'CreditCard': return EntitySubtype.creditCard;
      case 'BankAccount': return EntitySubtype.bankAccount;
      case 'Finance': return EntitySubtype.finance;
      case 'Car': return EntitySubtype.car;
      case 'Boat': return EntitySubtype.boat;
      case 'PublicTransport': return EntitySubtype.publicTransport;
      case 'Motorcycle': return EntitySubtype.motorcycle;
      case 'Bicycle': return EntitySubtype.other;
      case 'Truck': return EntitySubtype.other;
      case 'Van': return EntitySubtype.other;
      case 'RV': return EntitySubtype.other;
      case 'ATV': return EntitySubtype.other;
      case 'JetSki': return EntitySubtype.other;
      default:
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
          default: return EntitySubtype.general;
        }
    }
  }

  Widget _buildTransportUI(BuildContext context) {
    List<String> quickNavItems = ['Quick Nav Option 1', 'Quick Nav Option 2'];
    List<String> iWantToItems = [
      'Be reminded of due dates for MOT, Service, Warranty, Insurance, Lease Expiration',
      'Schedule a monthly wash',
      'Schedule a repair',
      'Be reminded to decide if trading',
      'Keep up with driving license numbers, contact information, warranty, insurance logins',
      'Be reminded when driving license(s) will expire',
      'Remember to buy train tickets for commute'
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                hint: const Text('Quick Nav'),
                value: _quickNavValue,
                icon: const Icon(Icons.arrow_drop_down),
                items: quickNavItems.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _quickNavValue = newValue;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                hint: const Text('I Want To'),
                value: _iWantToValue,
                icon: const Icon(Icons.arrow_drop_down),
                items: iWantToItems.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _iWantToValue = newValue;
                  });
                  if (newValue != null) {
                    log("Selected 'I Want To': $newValue", name: "SubCategoryScreen");
                  }
                },
              ),
            ),
            ),
            const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              itemCount: _transportSections.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final section = _transportSections[index];
                return ListTile(
                  title: Text(section),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    log('Tapped on Transport Section: $section', name: "SubCategoryScreen");
                    if (section == 'Cars & Motorcycles' || section == 'Boats & Other' || section == 'Public Transport') {
                      EntitySubcategoryModel? navSubcategory;
                      if (section == 'Cars & Motorcycles') {
                        try {
                          navSubcategory = allSubcategories['transport']?.firstWhere((s) => s.id == 'cars_motorcycles');
                        } catch (e) {
                          navSubcategory = null;
                        }
                      } else if (section == 'Boats & Other') {
                        try {
                          navSubcategory = allSubcategories['transport']?.firstWhere((s) => s.id == 'boats_and_others');
                        } catch (e) {
                          navSubcategory = null;
                        }
                      } else if (section == 'Public Transport') {
                        try {
                          navSubcategory = allSubcategories['transport']?.firstWhere((s) => s.id == 'public_transport_cat');
                        } catch (e) {
                          navSubcategory = null;
                        }
                      }

                      if (navSubcategory != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EntityListScreen(
                              categoryId: widget.categoryId,
                              subcategoryId: navSubcategory!.id,
                              categoryName: widget.categoryName,
                              screenTitle: navSubcategory.displayName,
                              currentSubcategory: navSubcategory,
                            ),
                          ),
                        );
                      } else {
                        log('Could not find subcategory model for $section', name: "SubCategoryScreen");
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Navigation for $section not yet implemented.')),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isTransportCategory = widget.categoryName == 'Transport';
    final Color appBarTextColor = isTransportCategory ? Colors.white : (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black);
    final Color appBarIconColor = isTransportCategory ? Colors.white : Theme.of(context).iconTheme.color ?? (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          style: TextStyle(color: appBarTextColor),
        ),
        iconTheme: IconThemeData(color: appBarIconColor),
        backgroundColor: isTransportCategory ? Theme.of(context).primaryColor : Theme.of(context).appBarTheme.backgroundColor,
        bottom: (isTransportCategory || _isLoading || _subcategories.isEmpty || _tabController == null)
            ? null
            : TabBar(
          controller: _tabController,
          isScrollable: true,
                tabs: _subcategories.map((sub) => Tab(text: sub.displayName)).toList(),
              ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : isTransportCategory
              ? _buildTransportUI(context)
              : (_subcategories.isEmpty || _tabController == null
                  ? Center(child: Text('No subcategories available for ${widget.categoryName}.'))
                  : TabBarView(
        controller: _tabController,
                      children: _subcategories.map((sub) {
                        final entitySubtype = _getEntitySubtypeForSubcategory(sub);
                        int? appCategoryIdForTab;
                        if (entitySubtype != null) {
                           try {
                            appCategoryIdForTab = helper_util.EntityTypeHelper.categoryMapping[entitySubtype];
                           } catch (e) {
                             log('Could not find appCategoryId for subtype: $entitySubtype in SubCategoryScreen tab view', name: 'SubCategoryScreen');
                           }
                        }

          return EntityListScreen(
            categoryId: widget.categoryId,
                          subcategoryId: sub.id,
                          categoryName: widget.categoryName,
                          screenTitle: sub.displayName,
                          appCategoryId: appCategoryIdForTab, 
                          defaultEntityType: entitySubtype,
                          currentSubcategory: sub, 
          );
        }).toList(),
                    )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          EntitySubtype? currentSubtype;
          String? subcategoryIdForCreation;
          String? subcategoryNameForCreation;

          if (isTransportCategory) {
            log('FAB pressed on Transport screen. Needs context for specific creation.', name: "SubCategoryScreen");
            ScaffoldMessenger.of(context).showSnackBar(
               const SnackBar(content: Text('Add button functionality for Transport sections to be defined.')),
             );
             return;

          } else if (_tabController != null && _subcategories.isNotEmpty) {
            final selectedSubcategory = _subcategories[_tabController!.index];
            currentSubtype = _getEntitySubtypeForSubcategory(selectedSubcategory);
            subcategoryIdForCreation = selectedSubcategory.id;
            subcategoryNameForCreation = selectedSubcategory.displayName;
          }

          if (subcategoryIdForCreation != null && subcategoryNameForCreation != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateEditEntityScreen(
                  appCategoryId: helper_util.EntityTypeHelper.categoryMapping[currentSubtype ?? EntitySubtype.general] ?? 1,
                  initialSubtype: currentSubtype ?? EntitySubtype.general,
                ),
              ),
            );
          } else if (!isTransportCategory) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cannot determine subcategory to add an item.')),
            );
             log('FAB pressed, but subcategory context unclear for non-Transport.', name: "SubCategoryScreen");
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
