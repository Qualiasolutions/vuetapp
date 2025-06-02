import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/entity_subcategory_model.dart';
import 'package:vuet_app/providers/category_providers.dart';
import '../entities/entity_list_screen.dart';
import 'package:vuet_app/models/entity_model.dart';
import '../../screens/tasks/tag_filter_task_screen.dart';
import 'package:vuet_app/ui/helpers/ui_helpers.dart';
import 'package:vuet_app/models/entity_category_model.dart';
import 'package:vuet_app/providers/category_screen_providers.dart';
import 'package:vuet_app/constants/default_subcategories.dart';
import 'package:vuet_app/ui/screens/entities/entity_form_screen.dart';

// Helper to parse EntitySubtype from string
EntitySubtype _parseEntitySubtype(String subtypeName) {
  // Try to find a matching EntitySubtype by its JsonValue
  try {
    // Loop through all enum values and check if any has a matching JsonValue
    for (final type in EntitySubtype.values) {
      // Convert enum to its string representation which includes the JsonValue annotation
      final typeString = type.toString().split('.').last;
      
      // Match by name or similar variations
      if (subtypeName == typeString || 
          subtypeName.toLowerCase().replaceAll(' ', '_') == typeString.toLowerCase() ||
          subtypeName == type.toString().split('.').last) {
        return type;
      }
    }
    
    // Fallback to the first enum value if no match found
    print("Warning: Could not parse EntitySubtype '$subtypeName'. Unknown value. Falling back to first available subtype.");
    return EntitySubtype.values.first;
  } catch (e) {
    print("Error parsing EntitySubtype: $e. Falling back to first available subtype.");
    return EntitySubtype.values.first;
  }
}

class SubCategoryScreen extends ConsumerStatefulWidget {
  final int? appCategoryId;
  final String categoryId;
  final String categoryName;
  final List<String>? subCategoryKeys;

  const SubCategoryScreen({
    super.key,
    this.appCategoryId,
    required this.categoryId,
    required this.categoryName,
    this.subCategoryKeys,
  });

  factory SubCategoryScreen.fromCategoryId({
    int? appCategoryId,
    required String parentCategoryId,
    required String parentCategoryName,
    List<String>? subCategoryKeys,
  }) {
    return SubCategoryScreen(
      key: ValueKey('SubCategoryScreen_$parentCategoryId'),
      appCategoryId: appCategoryId,
      categoryId: parentCategoryId,
      categoryName: parentCategoryName,
      subCategoryKeys: subCategoryKeys,
    );
  }

  @override
  ConsumerState<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends ConsumerState<SubCategoryScreen> {
  List<EntitySubcategoryModel> _subcategories = [];
  bool _hasEntities = false; // Flag to track if there are entities
  
  // For dropdown menus
  final List<String> _quickNavOptions = ['My Entities', 'Favorites', 'Recently Viewed'];
  final List<String> _actionOptions = ['Add New Entity', 'Import Entities', 'Settings'];
  String? _selectedQuickNavOption;
  String? _selectedActionOption;

  @override
  void initState() {
    super.initState();
    
    // Determine if any entities exist (would be from a provider in real app)
    _hasEntities = false; // This would be dynamic in a real app
  }
  
  void _addNewEntity(BuildContext context, EntitySubcategoryModel? subcategory) {
    final subtype = subcategory != null && subcategory.entityTypeIds.isNotEmpty
        ? _parseEntitySubtype(subcategory.entityTypeIds.first)
        : EntitySubtype.values.first;
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EntityFormScreen(
          categoryId: widget.categoryId,
          categoryName: widget.categoryName,
          defaultSubtype: subtype,
          subcategoryId: subcategory?.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyContent;
    
    // If we have subCategoryKeys, display hardcoded subcategories from constants
    if (widget.subCategoryKeys != null && widget.subCategoryKeys!.isNotEmpty) {
      // Get the first key (for now we only use the first one)
      final subcategoryKey = widget.subCategoryKeys!.first;
      
      // Try to get the subcategories for this key
      final defaultSubcategories = allSubcategories[subcategoryKey];
      
      if (defaultSubcategories != null && defaultSubcategories.isNotEmpty) {
        // Store subcategories for dropdown navigation
        _subcategories = defaultSubcategories;
        
        if (_hasEntities) {
          bodyContent = _buildEntityList(context);
        } else {
          bodyContent = _buildEmptyState(context);
        }
      } else {
        // Fall back to the database if no hardcoded subcategories
        final subcategoriesAsyncValue = ref.watch(entitySubcategoriesProvider(widget.categoryId));
        
        bodyContent = subcategoriesAsyncValue.when(
          data: (subcategories) {
            _subcategories = subcategories;
            
            if (subcategories.isEmpty) {
              return const Center(
                child: Text('No subcategories available for this category.'),
              );
            }
            
            if (_hasEntities) {
              return _buildEntityList(context);
            } else {
              return _buildEmptyState(context);
            }
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(
            child: Text('Error loading subcategories: $err'),
          ),
        );
      }
    } else {
      // No subcategory keys provided, try to load from database
      final subcategoriesAsyncValue = ref.watch(entitySubcategoriesProvider(widget.categoryId));
      
      bodyContent = subcategoriesAsyncValue.when(
        data: (subcategories) {
          _subcategories = subcategories;
          
          if (subcategories.isEmpty) {
            return const Center(
              child: Text('No subcategories available for this category.'),
            );
          }
          
          if (_hasEntities) {
            return _buildEntityList(context);
          } else {
            return _buildEmptyState(context);
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Error loading subcategories: $err'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        backgroundColor: Colors.grey[700],
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Column(
        children: [
          // Dropdown menu bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
            ),
            child: Row(
              children: [
                // Quick Nav dropdown
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        hint: const Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Text('Quick Nav'),
                        ),
                        value: _selectedQuickNavOption,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        isExpanded: true,
                        borderRadius: BorderRadius.circular(12),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedQuickNavOption = value;
                          });
                        },
                        items: _subcategories.map<DropdownMenuItem<String>>((subcategory) {
                          return DropdownMenuItem<String>(
                            value: subcategory.displayName,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text(subcategory.displayName),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // I Want To dropdown
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        hint: const Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Text('I Want To'),
                        ),
                        value: _selectedActionOption,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        isExpanded: true,
                        borderRadius: BorderRadius.circular(12),
                        onChanged: (String? value) {
                          if (value == 'Add New Entity') {
                            _addNewEntity(context, _subcategories.isNotEmpty ? _subcategories.first : null);
                          }
                          setState(() {
                            _selectedActionOption = value;
                          });
                        },
                        items: _actionOptions.map<DropdownMenuItem<String>>((String option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text(option),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Main content area
          Expanded(
            child: bodyContent,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addNewEntity(context, _subcategories.isNotEmpty ? _subcategories.first : null);
        },
        backgroundColor: const Color(0xFFB23B00),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
  
  // Widget to show when there are no entities
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You don\'t currently have any Pets.',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Click the + button below to add some',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
  
  // Widget to show when there are entities
  Widget _buildEntityList(BuildContext context) {
    // This would be replaced with actual entity data
    return ListView.separated(
      padding: const EdgeInsets.all(0),
      itemCount: 1, // Example with one entity
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        return ListTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.image, color: Colors.grey),
          ),
          title: const Text('Test'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Navigate to entity detail screen
          },
        );
      },
    );
  }
  
  // Helper method to build a consistent list of subcategories
  Widget _buildSubcategoriesList(BuildContext context, List<EntitySubcategoryModel> subcategories) {
    return ListView.builder(
      itemCount: subcategories.length,
      itemBuilder: (context, index) {
        final subcategory = subcategories[index];
        final iconData = UiHelpers.getIconFromString(subcategory.icon);
        final color = UiHelpers.getColorFromString(subcategory.color);

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          elevation: 2.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              child: Icon(iconData, color: color, size: 24),
            ),
            title: Text(
              subcategory.displayName,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              if (subcategory.tagName != null && subcategory.tagName!.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TagFilterTaskScreen(
                      categoryName: widget.categoryName,
                      subcategoryName: subcategory.displayName,
                      tagName: subcategory.tagName!,
                    ),
                  ),
                );
              } else if (subcategory.entityTypeIds.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EntityListScreen(
                      appCategoryId: widget.appCategoryId,
                      categoryId: widget.categoryId,
                      subcategoryId: subcategory.id,
                      categoryName: subcategory.displayName,
                      defaultSubtypeForNew: _parseEntitySubtype(subcategory.entityTypeIds.first),
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('No action defined for ${subcategory.displayName}')),
                );
              }
            },
          ),
        );
      },
    );
  }
}
