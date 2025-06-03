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
    // First check if the subcategory has a direct mapping
    switch (subcategory.name) {
      case 'dogs':
      case 'cats':
      case 'birds':
      case 'fish':
      case 'other_pets':
        return EntitySubtype.pet;
      case 'social_plans':
        return EntitySubtype.socialPlan;
      case 'anniversaries':
        return EntitySubtype.anniversary;
      case 'events':
        return EntitySubtype.event;
      case 'hobbies':
        return EntitySubtype.hobby;
      case 'courses':
        return EntitySubtype.courseWork;
      case 'educational_goals':
      case 'professional_goals':
        return EntitySubtype.academicPlan;
      case 'careers':
        return EntitySubtype.work;
      case 'trips':
        return EntitySubtype.trip;
      case 'fitness':
      case 'medical':
        return EntitySubtype.doctor;
      case 'beauty':
        return EntitySubtype.beautySalon;
      case 'home_maintenance':
      case 'gardening':
      case 'cooking':
      case 'cleaning':
        return EntitySubtype.home;
      case 'accounts':
      case 'budgeting':
      case 'investments':
        return EntitySubtype.bankAccount;
      case 'vehicles':
        return EntitySubtype.car;
      case 'public_transport':
        return EntitySubtype.publicTransport;
      default:
        // Return a default based on category
        switch (widget.categoryId) {
          case 'pets':
            return EntitySubtype.pet;
          case 'social_interests':
            return EntitySubtype.event;
          case 'education_career':
            return EntitySubtype.academicPlan;
          case 'travel':
            return EntitySubtype.trip;
          case 'health_beauty':
            return EntitySubtype.doctor;
          case 'home_garden':
            return EntitySubtype.home;
          case 'finance':
            return EntitySubtype.bankAccount;
          case 'transport':
            return EntitySubtype.car;
          default:
            return EntitySubtype.pet; // Default fallback
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
