import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:vuet_app/config/theme_config.dart';
import 'package:vuet_app/ui/shared/widgets.dart';
import 'package:vuet_app/ui/widgets/modern_components.dart';
import 'package:vuet_app/ui/screens/home_garden/home_form_screen.dart'; // Assuming this exists
import 'package:vuet_app/ui/screens/home_garden/home_detail_screen.dart'; // Assuming this exists
import 'package:vuet_app/utils/logger.dart';
import 'package:vuet_app/models/entity_model.dart'; // For BaseEntityModel and EntitySubtype
import 'package:vuet_app/providers/entity_providers.dart'; // For entityServiceProvider
import 'package:vuet_app/ui/screens/tasks/create_task_screen.dart'; // For quick actions
import 'package:vuet_app/ui/widgets/i_want_to_menu.dart'; // For I WANT TO menu

// --- Temporary HomeProperty Model (will be moved to lib/models/home_garden_entities.dart) ---
@immutable
class HomeProperty extends BaseEntityModel {
  final String? address;
  final String? propertyType; // e.g., House, Apartment, Condo, Townhouse, Garden
  final double? sizeSqFt;
  final DateTime? purchaseDate;
  final double? value;
  final String? notes;

  const HomeProperty({
    String? id,
    required String name,
    String? description,
    String? userId,
    String? categoryId,
    String? subcategoryId,
    String? categoryName,
    String? subcategoryName,
    String? imageUrl,
    bool? isHidden,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.address,
    this.propertyType,
    this.sizeSqFt,
    this.purchaseDate,
    this.value,
    this.notes,
  }) : super(
          id: id,
          name: name,
          description: description,
          userId: userId,
          categoryId: categoryId,
          subcategoryId: subcategoryId,
          categoryName: categoryName,
          subcategoryName: subcategoryName,
          imageUrl: imageUrl,
          isHidden: isHidden,
          createdAt: createdAt,
          updatedAt: updatedAt,
          subtype: EntitySubtype.home, // Crucial for IWantToMenu
        );

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        userId,
        categoryId,
        subcategoryId,
        categoryName,
        subcategoryName,
        imageUrl,
        isHidden,
        createdAt,
        updatedAt,
        address,
        propertyType,
        sizeSqFt,
        purchaseDate,
        value,
        notes,
        subtype,
      ];

  factory HomeProperty.fromJson(Map<String, dynamic> json) {
    return HomeProperty(
      id: json['id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      userId: json['user_id'] as String?,
      categoryId: json['category_id'] as String? ?? 'HOME_AND_GARDEN',
      subcategoryId: json['subcategory_id'] as String?,
      categoryName: json['category_name'] as String? ?? 'Home & Garden',
      subcategoryName: json['subcategory_name'] as String?,
      imageUrl: json['image_url'] as String?,
      isHidden: json['is_hidden'] as bool?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      address: json['address'] as String?,
      propertyType: json['property_type'] as String?,
      sizeSqFt: (json['size_sq_ft'] as num?)?.toDouble(),
      purchaseDate: json['purchase_date'] != null
          ? DateTime.parse(json['purchase_date'] as String)
          : null,
      value: (json['value'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'user_id': userId,
      'category_id': categoryId,
      'subcategory_id': subcategoryId,
      'category_name': categoryName,
      'subcategory_name': subcategoryName,
      'image_url': imageUrl,
      'is_hidden': isHidden,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'address': address,
      'property_type': propertyType,
      'size_sq_ft': sizeSqFt,
      'purchase_date': purchaseDate?.toIso8601String(),
      'value': value,
      'notes': notes,
      'subtype': subtype.toShortString(),
    };
  }
}

// --- End Temporary HomeProperty Model ---

// Provider for the search query for home properties
final homePropertySearchQueryProvider = StateProvider<String>((ref) => '');

// Provider for filtered home properties
final filteredHomePropertiesProvider =
    FutureProvider.family<List<HomeProperty>, String>((ref, searchQuery) async {
  final entityService = ref.watch(entityServiceProvider);
  final allEntities = await entityService.listEntities(
    categoryName: 'HOME_AND_GARDEN', // Assuming 'HOME_AND_GARDEN' is the category name
    subtype: EntitySubtype.home, // Or other relevant subtypes like garden, food, laundry
  );

  // Cast BaseEntityModel to HomeProperty
  final allHomeProperties =
      allEntities.map((e) => HomeProperty.fromJson(e.toJson())).toList();

  if (searchQuery.isEmpty) {
    return allHomeProperties;
  } else {
    return allHomeProperties.where((property) {
      final lowerCaseQuery = searchQuery.toLowerCase();
      return property.name.toLowerCase().contains(lowerCaseQuery) ||
          (property.address?.toLowerCase().contains(lowerCaseQuery) ?? false) ||
          (property.propertyType?.toLowerCase().contains(lowerCaseQuery) ?? false) ||
          (property.description?.toLowerCase().contains(lowerCaseQuery) ?? false);
    }).toList();
  }
});

// Provider for refreshing home property list
final homePropertyListRefreshProvider = StateProvider<bool>((ref) => false);

class HomeListScreen extends ConsumerStatefulWidget {
  const HomeListScreen({super.key});

  @override
  ConsumerState<HomeListScreen> createState() => _HomeListScreenState();
}

class _HomeListScreenState extends ConsumerState<HomeListScreen> {
  late final TextEditingController _searchController;
  late final ScrollController _scrollController;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshHomeProperties() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    // Invalidate the provider to force a refresh
    ref.invalidate(homePropertyListRefreshProvider);
    ref.invalidate(filteredHomePropertiesProvider(ref.read(homePropertySearchQueryProvider)));

    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network delay

    setState(() {
      _isRefreshing = false;
    });
  }

  void _onSearchChanged(String query) {
    ref.read(homePropertySearchQueryProvider.notifier).state = query;
  }

  void _navigateToCreateHome(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomeFormScreen()),
    ).then((value) {
      if (value == true) {
        _refreshHomeProperties();
      }
    });
  }

  void _navigateToEditHome(BuildContext context, HomeProperty home) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeFormScreen(home: home)),
    ).then((value) {
      if (value == true) {
        _refreshHomeProperties();
      }
    });
  }

  Future<void> _deleteHome(BuildContext context, String homeId) async {
    try {
      await ref.read(entityServiceProvider).deleteEntity(homeId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Home property deleted successfully')),
        );
        _refreshHomeProperties();
      }
    } catch (e, st) {
      log('Error deleting home property: $e',
          name: 'HomeListScreen', error: e, stackTrace: st);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete home property: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(homePropertySearchQueryProvider);
    final homePropertiesAsync = ref.watch(filteredHomePropertiesProvider(searchQuery));

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        title: const Text('Home & Garden'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.darkJungleGreen,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search properties...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshHomeProperties,
            tooltip: 'Refresh properties',
          ),
        ],
      ),
      body: homePropertiesAsync.when(
        data: (homeProperties) {
          if (homeProperties.isEmpty) {
            return _buildEmptyState(context, searchQuery.isNotEmpty);
          }
          return RefreshIndicator(
            onRefresh: _refreshHomeProperties,
            child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: homeProperties.length,
              itemBuilder: (context, index) {
                final home = homeProperties[index];
                return HomePropertyCard(
                  home: home,
                  onTap: () =>
                      context.go('/home_garden/homes/${home.id}'), // Navigate to detail
                  onEdit: () => _navigateToEditHome(context, home),
                  onDelete: () => _confirmDelete(context, home.id!),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          log('Error loading home properties: $error',
              name: 'HomeListScreen', error: error, stackTrace: stackTrace);
          return ModernComponents.modernErrorState(
            title: 'Error Loading Properties',
            subtitle: 'Could not load home properties. Please try again.',
            onButtonPressed: _refreshHomeProperties,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreateHome(context),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isSearching) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSearching ? Icons.search_off : Icons.home,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 24),
            Text(
              isSearching
                  ? 'No matching properties found'
                  : 'No home properties yet',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              isSearching
                  ? 'Try adjusting your search query.'
                  : 'Create your first home property to get started!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (!isSearching)
              ElevatedButton.icon(
                onPressed: () => _navigateToCreateHome(context),
                icon: const Icon(Icons.add),
                label: const Text('Add Property'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String homeId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Property'),
        content: const Text(
            'Are you sure you want to delete this property? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteHome(context, homeId);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class HomePropertyCard extends StatelessWidget {
  final HomeProperty home;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const HomePropertyCard({
    super.key,
    required this.home,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          home.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (home.address != null && home.address!.isNotEmpty)
                          Text(
                            home.address!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        onEdit();
                      } else if (value == 'delete') {
                        onDelete();
                      } else if (value == 'home_maintenance') {
                        // Navigate to create task with HOME__MAINTENANCE tag
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateTaskScreen(
                              initialTagCode: 'HOME__MAINTENANCE',
                              initialCategoryName: 'Home & Garden',
                              initialSubcategoryName: 'Home Maintenance',
                              entityId: home.id,
                            ),
                          ),
                        );
                      } else if (value == 'home_cleaning') {
                        // Navigate to create task with HOME__CLEANING tag
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateTaskScreen(
                              initialTagCode: 'HOME__CLEANING',
                              initialCategoryName: 'Home & Garden',
                              initialSubcategoryName: 'House Cleaning',
                              entityId: home.id,
                            ),
                          ),
                        );
                      } else if (value == 'garden_planting') {
                        // Navigate to create task with GARDEN__PLANTING tag
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateTaskScreen(
                              initialTagCode: 'GARDEN__PLANTING',
                              initialCategoryName: 'Home & Garden',
                              initialSubcategoryName: 'Garden Planting',
                              entityId: home.id,
                            ),
                          ),
                        );
                      } else if (value == 'food_shopping') {
                        // Navigate to create task with FOOD__SHOPPING tag
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateTaskScreen(
                              initialTagCode: 'FOOD__SHOPPING',
                              initialCategoryName: 'Home & Garden',
                              initialSubcategoryName: 'Food Shopping',
                              entityId: home.id,
                            ),
                          ),
                        );
                      } else if (value == 'laundry_washing') {
                        // Navigate to create task with LAUNDRY__WASHING tag
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateTaskScreen(
                              initialTagCode: 'LAUNDRY__WASHING',
                              initialCategoryName: 'Home & Garden',
                              initialSubcategoryName: 'Laundry Washing',
                              entityId: home.id,
                            ),
                          ),
                        );
                      } else if (value == 'i_want_to') {
                        // Show the I WANT TO menu
                        IWantToMenu.show(
                          context: context,
                          entity: home,
                          onTagSelected: (tag, category, subcategory) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateTaskScreen(
                                  initialTagCode: tag,
                                  initialCategoryName: category,
                                  initialSubcategoryName: subcategory,
                                  entityId: home.id,
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'home_maintenance',
                        child: ListTile(
                          leading: Icon(Icons.build),
                          title: Text('Home Maintenance'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'home_cleaning',
                        child: ListTile(
                          leading: Icon(Icons.cleaning_services),
                          title: Text('House Cleaning'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'garden_planting',
                        child: ListTile(
                          leading: Icon(Icons.eco),
                          title: Text('Garden Planting'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'food_shopping',
                        child: ListTile(
                          leading: Icon(Icons.shopping_cart),
                          title: Text('Food Shopping'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'laundry_washing',
                        child: ListTile(
                          leading: Icon(Icons.wash),
                          title: Text('Laundry Washing'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'i_want_to',
                        child: ListTile(
                          leading: Icon(Icons.lightbulb_outline),
                          title: Text('I WANT TO...'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'edit',
                        child: ListTile(
                          leading: Icon(Icons.edit),
                          title: Text('Edit Property'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: ListTile(
                          leading: Icon(Icons.delete, color: Colors.red),
                          title: Text('Delete', style: TextStyle(color: Colors.red)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (home.description != null && home.description!.isNotEmpty)
                Text(
                  home.description!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 8),
              // Property type and size
              Row(
                children: [
                  if (home.propertyType != null && home.propertyType!.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getPropertyTypeColor(home.propertyType!).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        home.propertyType!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _getPropertyTypeColor(home.propertyType!),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (home.sizeSqFt != null) ...[
                    Icon(
                      Icons.square_foot,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${home.sizeSqFt!.toStringAsFixed(0)} sq ft',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              // Purchase date and value
              Row(
                children: [
                  if (home.purchaseDate != null) ...[
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Purchased: ${_formatDate(home.purchaseDate!)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                  if (home.value != null) ...[
                    Icon(
                      Icons.attach_money,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatCurrency(home.value!),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPropertyTypeColor(String propertyType) {
    switch (propertyType.toLowerCase()) {
      case 'house':
        return Colors.blue;
      case 'apartment':
        return Colors.orange;
      case 'condo':
        return Colors.purple;
      case 'townhouse':
        return Colors.green;
      case 'garden':
        return Colors.lightGreen;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }
}
