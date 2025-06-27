import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:vuet_app/config/theme_config.dart';
import 'package:vuet_app/ui/shared/widgets.dart';
import 'package:vuet_app/ui/widgets/modern_components.dart';
import 'package:vuet_app/ui/screens/travel/travel_form_screen.dart'; // Assuming this exists
import 'package:vuet_app/ui/screens/travel/travel_detail_screen.dart'; // Assuming this exists
import 'package:vuet_app/utils/logger.dart';
import 'package:vuet_app/models/entity_model.dart'; // For BaseEntityModel and EntitySubtype
import 'package:vuet_app/providers/entity_providers.dart'; // For entityServiceProvider
import 'package:vuet_app/ui/screens/tasks/create_task_screen.dart'; // For quick actions
import 'package:vuet_app/ui/widgets/i_want_to_menu.dart'; // For I WANT TO menu

// --- Temporary Travel Model (will be moved to lib/models/travel_entities.dart) ---
@immutable
class Travel extends BaseEntityModel {
  final String? destination;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? status; // e.g., Planned, Booked, In Progress, Completed, Cancelled

  const Travel({
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
    this.destination,
    this.startDate,
    this.endDate,
    this.status,
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
          subtype: EntitySubtype.trip, // Default to trip for now
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
        destination,
        startDate,
        endDate,
        status,
        subtype,
      ];

  factory Travel.fromJson(Map<String, dynamic> json) {
    return Travel(
      id: json['id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      userId: json['user_id'] as String?,
      categoryId: json['category_id'] as String?,
      subcategoryId: json['subcategory_id'] as String?,
      categoryName: json['category_name'] as String?,
      subcategoryName: json['subcategory_name'] as String?,
      imageUrl: json['image_url'] as String?,
      isHidden: json['is_hidden'] as bool?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      destination: json['destination'] as String?,
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'] as String)
          : null,
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'] as String)
          : null,
      status: json['status'] as String?,
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
      'destination': destination,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'status': status,
      'subtype': subtype.toShortString(),
    };
  }
}

// --- End Temporary Travel Model ---

// Provider for the search query for travels
final travelSearchQueryProvider = StateProvider<String>((ref) => '');

// Provider for filtered travels
final filteredTravelsProvider =
    FutureProvider.family<List<Travel>, String>((ref, searchQuery) async {
  final entityService = ref.watch(entityServiceProvider);
  final allEntities = await entityService.listEntities(
    categoryName: 'TRAVEL', // Assuming 'TRAVEL' is the category name for travels
    subtype: EntitySubtype.trip, // Or EntitySubtype.travelPlan
  );

  // Cast BaseEntityModel to Travel
  final allTravels = allEntities.map((e) => Travel.fromJson(e.toJson())).toList();

  if (searchQuery.isEmpty) {
    return allTravels;
  } else {
    return allTravels.where((travel) {
      final lowerCaseQuery = searchQuery.toLowerCase();
      return travel.name.toLowerCase().contains(lowerCaseQuery) ||
          (travel.destination?.toLowerCase().contains(lowerCaseQuery) ?? false) ||
          (travel.description?.toLowerCase().contains(lowerCaseQuery) ?? false);
    }).toList();
  }
});

// Provider for refreshing travel list
final travelListRefreshProvider = StateProvider<bool>((ref) => false);

class TravelListScreen extends ConsumerStatefulWidget {
  const TravelListScreen({super.key});

  @override
  ConsumerState<TravelListScreen> createState() => _TravelListScreenState();
}

class _TravelListScreenState extends ConsumerState<TravelListScreen> {
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

  Future<void> _refreshTravels() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    // Invalidate the provider to force a refresh
    ref.invalidate(travelListRefreshProvider);
    ref.invalidate(filteredTravelsProvider(ref.read(travelSearchQueryProvider)));

    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network delay

    setState(() {
      _isRefreshing = false;
    });
  }

  void _onSearchChanged(String query) {
    ref.read(travelSearchQueryProvider.notifier).state = query;
  }

  void _navigateToCreateTravel(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TravelFormScreen()),
    ).then((value) {
      if (value == true) {
        _refreshTravels();
      }
    });
  }

  void _navigateToEditTravel(BuildContext context, Travel travel) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TravelFormScreen(travel: travel)),
    ).then((value) {
      if (value == true) {
        _refreshTravels();
      }
    });
  }

  Future<void> _deleteTravel(BuildContext context, String travelId) async {
    try {
      await ref.read(entityServiceProvider).deleteEntity(travelId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Travel deleted successfully')),
        );
        _refreshTravels();
      }
    } catch (e, st) {
      log('Error deleting travel: $e', name: 'TravelListScreen', error: e, stackTrace: st);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete travel: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(travelSearchQueryProvider);
    final travelsAsync = ref.watch(filteredTravelsProvider(searchQuery));

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        title: const Text('Travels'),
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
                hintText: 'Search travels...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshTravels,
            tooltip: 'Refresh travels',
          ),
        ],
      ),
      body: travelsAsync.when(
        data: (travels) {
          if (travels.isEmpty) {
            return _buildEmptyState(context, searchQuery.isNotEmpty);
          }
          return RefreshIndicator(
            onRefresh: _refreshTravels,
            child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: travels.length,
              itemBuilder: (context, index) {
                final travel = travels[index];
                return TravelCard(
                  travel: travel,
                  onTap: () => context.go('/travel/trips/${travel.id}'), // Navigate to detail
                  onEdit: () => _navigateToEditTravel(context, travel),
                  onDelete: () => _confirmDelete(context, travel.id!),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          log('Error loading travels: $error', name: 'TravelListScreen', error: error, stackTrace: stackTrace);
          return ModernComponents.modernErrorState(
            title: 'Error Loading Travels',
            subtitle: 'Could not load travel list. Please try again.',
            onButtonPressed: _refreshTravels,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreateTravel(context),
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
              isSearching ? Icons.search_off : Icons.flight,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 24),
            Text(
              isSearching ? 'No matching travels found' : 'No travels yet',
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
                  : 'Create your first travel plan to get started!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (!isSearching)
              ElevatedButton.icon(
                onPressed: () => _navigateToCreateTravel(context),
                icon: const Icon(Icons.add),
                label: const Text('Add Travel'),
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

  void _confirmDelete(BuildContext context, String travelId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Travel'),
        content: const Text('Are you sure you want to delete this travel record? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteTravel(context, travelId);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class TravelCard extends StatelessWidget {
  final Travel travel;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TravelCard({
    super.key,
    required this.travel,
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
                          travel.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (travel.destination != null && travel.destination!.isNotEmpty)
                          Text(
                            travel.destination!,
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
                      } else if (value == 'booking') {
                        // Navigate to create task with TRAVEL__BOOKING tag
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateTaskScreen(
                              initialTagCode: 'TRAVEL__BOOKING',
                              initialCategoryName: 'Travel',
                              initialSubcategoryName: 'Booking',
                              entityId: travel.id,
                            ),
                          ),
                        );
                      } else if (value == 'packing') {
                        // Navigate to create task with TRAVEL__PACKING tag
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateTaskScreen(
                              initialTagCode: 'TRAVEL__PACKING',
                              initialCategoryName: 'Travel',
                              initialSubcategoryName: 'Packing',
                              entityId: travel.id,
                            ),
                          ),
                        );
                      } else if (value == 'flight') {
                        // Navigate to create task with TRAVEL__FLIGHT tag
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateTaskScreen(
                              initialTagCode: 'TRAVEL__FLIGHT',
                              initialCategoryName: 'Travel',
                              initialSubcategoryName: 'Flight',
                              entityId: travel.id,
                            ),
                          ),
                        );
                      } else if (value == 'i_want_to') {
                        // Show the I WANT TO menu
                        IWantToMenu.show(
                          context: context,
                          entity: travel,
                          onTagSelected: (tag, category, subcategory) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateTaskScreen(
                                  initialTagCode: tag,
                                  initialCategoryName: category,
                                  initialSubcategoryName: subcategory,
                                  entityId: travel.id,
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'booking',
                        child: ListTile(
                          leading: Icon(Icons.book_online),
                          title: Text('Book Travel'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'packing',
                        child: ListTile(
                          leading: Icon(Icons.luggage),
                          title: Text('Pack for Trip'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'flight',
                        child: ListTile(
                          leading: Icon(Icons.flight),
                          title: Text('Manage Flights'),
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
                          title: Text('Edit Travel'),
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
              if (travel.description != null && travel.description!.isNotEmpty)
                Text(
                  travel.description!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 8),
              Row(
                children: [
                  // Date range (if available)
                  if (travel.startDate != null) ...[
                    Icon(
                      Icons.date_range,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDateRange(travel.startDate, travel.endDate),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                  const SizedBox(width: 16),
                  // Status indicator (if available)
                  if (travel.status != null && travel.status!.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getStatusColor(travel.status!).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        travel.status!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _getStatusColor(travel.status!),
                        ),
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

  String _formatDateRange(DateTime? startDate, DateTime? endDate) {
    if (startDate == null) {
      return '';
    }

    final startStr = DateFormat('MMM d, yyyy').format(startDate);
    
    if (endDate == null) {
      return startStr;
    } else {
      final endStr = DateFormat('MMM d, yyyy').format(endDate);
      return '$startStr - $endStr';
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'planned':
        return Colors.blue;
      case 'booked':
        return Colors.green;
      case 'in progress':
        return Colors.orange;
      case 'completed':
        return Colors.purple;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
