import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:vuet_app/config/theme_config.dart';
import 'package:vuet_app/ui/shared/widgets.dart';
import 'package:vuet_app/ui/widgets/modern_components.dart';
import 'package:vuet_app/ui/screens/charity_religion/charity_form_screen.dart'; // Assuming this exists
import 'package:vuet_app/ui/screens/charity_religion/charity_detail_screen.dart'; // Assuming this exists
import 'package:vuet_app/utils/logger.dart';
import 'package:vuet_app/models/entity_model.dart'; // For BaseEntityModel and EntitySubtype
import 'package:vuet_app/providers/entity_providers.dart'; // For entityServiceProvider
import 'package:vuet_app/ui/screens/tasks/create_task_screen.dart'; // For quick actions
import 'package:vuet_app/ui/widgets/i_want_to_menu.dart'; // For I WANT TO menu

// --- Temporary Charity Model (will be moved to lib/models/charity_religion_entities.dart) ---
@immutable
class Charity extends BaseEntityModel {
  final String? organizationName;
  final String? mission;
  final String? contactPerson;
  final String? contactEmail;
  final String? contactPhone;
  final double? lastDonationAmount;
  final DateTime? lastDonationDate;
  final String? volunteerActivity;

  const Charity({
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
    this.organizationName,
    this.mission,
    this.contactPerson,
    this.contactEmail,
    this.contactPhone,
    this.lastDonationAmount,
    this.lastDonationDate,
    this.volunteerActivity,
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
          subtype: EntitySubtype.referenceGroup, // Default to referenceGroup for now
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
        organizationName,
        mission,
        contactPerson,
        contactEmail,
        contactPhone,
        lastDonationAmount,
        lastDonationDate,
        volunteerActivity,
        subtype,
      ];

  factory Charity.fromJson(Map<String, dynamic> json) {
    return Charity(
      id: json['id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      userId: json['user_id'] as String?,
      categoryId: json['category_id'] as String? ?? 'CHARITY_AND_RELIGION',
      subcategoryId: json['subcategory_id'] as String?,
      categoryName: json['category_name'] as String? ?? 'Charity & Religion',
      subcategoryName: json['subcategory_name'] as String?,
      imageUrl: json['image_url'] as String?,
      isHidden: json['is_hidden'] as bool?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      organizationName: json['organization_name'] as String?,
      mission: json['mission'] as String?,
      contactPerson: json['contact_person'] as String?,
      contactEmail: json['contact_email'] as String?,
      contactPhone: json['contact_phone'] as String?,
      lastDonationAmount: (json['last_donation_amount'] as num?)?.toDouble(),
      lastDonationDate: json['last_donation_date'] != null
          ? DateTime.parse(json['last_donation_date'] as String)
          : null,
      volunteerActivity: json['volunteer_activity'] as String?,
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
      'organization_name': organizationName,
      'mission': mission,
      'contact_person': contactPerson,
      'contact_email': contactEmail,
      'contact_phone': contactPhone,
      'last_donation_amount': lastDonationAmount,
      'last_donation_date': lastDonationDate?.toIso8601String(),
      'volunteer_activity': volunteerActivity,
      'subtype': subtype.toShortString(),
    };
  }
}

// --- End Temporary Charity Model ---

// Provider for the search query for charities
final charitySearchQueryProvider = StateProvider<String>((ref) => '');

// Provider for filtered charities
final filteredCharitiesProvider =
    FutureProvider.family<List<Charity>, String>((ref, searchQuery) async {
  final entityService = ref.watch(entityServiceProvider);
  final allEntities = await entityService.listEntities(
    categoryName: 'CHARITY_AND_RELIGION', // Assuming 'CHARITY_AND_RELIGION' is the category name
    subtype: EntitySubtype.referenceGroup, // Or other relevant subtypes
  );

  // Cast BaseEntityModel to Charity
  final allCharities =
      allEntities.map((e) => Charity.fromJson(e.toJson())).toList();

  if (searchQuery.isEmpty) {
    return allCharities;
  } else {
    return allCharities.where((charity) {
      final lowerCaseQuery = searchQuery.toLowerCase();
      return charity.name.toLowerCase().contains(lowerCaseQuery) ||
          (charity.organizationName?.toLowerCase().contains(lowerCaseQuery) ?? false) ||
          (charity.mission?.toLowerCase().contains(lowerCaseQuery) ?? false) ||
          (charity.description?.toLowerCase().contains(lowerCaseQuery) ?? false);
    }).toList();
  }
});

// Provider for refreshing charity list
final charityListRefreshProvider = StateProvider<bool>((ref) => false);

class CharityListScreen extends ConsumerStatefulWidget {
  const CharityListScreen({super.key});

  @override
  ConsumerState<CharityListScreen> createState() => _CharityListScreenState();
}

class _CharityListScreenState extends ConsumerState<CharityListScreen> {
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

  Future<void> _refreshCharities() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    // Invalidate the provider to force a refresh
    ref.invalidate(charityListRefreshProvider);
    ref.invalidate(filteredCharitiesProvider(ref.read(charitySearchQueryProvider)));

    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network delay

    setState(() {
      _isRefreshing = false;
    });
  }

  void _onSearchChanged(String query) {
    ref.read(charitySearchQueryProvider.notifier).state = query;
  }

  void _navigateToCreateCharity(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CharityFormScreen()),
    ).then((value) {
      if (value == true) {
        _refreshCharities();
      }
    });
  }

  void _navigateToEditCharity(BuildContext context, Charity charity) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CharityFormScreen(charity: charity)),
    ).then((value) {
      if (value == true) {
        _refreshCharities();
      }
    });
  }

  Future<void> _deleteCharity(BuildContext context, String charityId) async {
    try {
      await ref.read(entityServiceProvider).deleteEntity(charityId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Charity record deleted successfully')),
        );
        _refreshCharities();
      }
    } catch (e, st) {
      log('Error deleting charity: $e',
          name: 'CharityListScreen', error: e, stackTrace: st);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete charity: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(charitySearchQueryProvider);
    final charitiesAsync = ref.watch(filteredCharitiesProvider(searchQuery));

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        title: const Text('Charity & Religion'),
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
                hintText: 'Search charities...',
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
            onPressed: _refreshCharities,
            tooltip: 'Refresh charities',
          ),
        ],
      ),
      body: charitiesAsync.when(
        data: (charities) {
          if (charities.isEmpty) {
            return _buildEmptyState(context, searchQuery.isNotEmpty);
          }
          return RefreshIndicator(
            onRefresh: _refreshCharities,
            child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: charities.length,
              itemBuilder: (context, index) {
                final charity = charities[index];
                return CharityCard(
                  charity: charity,
                  onTap: () =>
                      context.go('/charity_religion/charities/${charity.id}'), // Navigate to detail
                  onEdit: () => _navigateToEditCharity(context, charity),
                  onDelete: () => _confirmDelete(context, charity.id!),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          log('Error loading charities: $error',
              name: 'CharityListScreen', error: error, stackTrace: stackTrace);
          return ModernComponents.modernErrorState(
            title: 'Error Loading Charities',
            subtitle: 'Could not load charity records. Please try again.',
            onButtonPressed: _refreshCharities,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreateCharity(context),
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
              isSearching ? Icons.search_off : Icons.volunteer_activism,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 24),
            Text(
              isSearching
                  ? 'No matching charities found'
                  : 'No charity or religious activities yet',
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
                  : 'Create your first charity or religious record to get started!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (!isSearching)
              ElevatedButton.icon(
                onPressed: () => _navigateToCreateCharity(context),
                icon: const Icon(Icons.add),
                label: const Text('Add Charity/Activity'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String charityId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Record'),
        content: const Text(
            'Are you sure you want to delete this charity or religious record? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteCharity(context, charityId);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class CharityCard extends StatelessWidget {
  final Charity charity;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CharityCard({
    super.key,
    required this.charity,
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
                          charity.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (charity.organizationName != null && charity.organizationName!.isNotEmpty)
                          Text(
                            charity.organizationName!,
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
                      } else if (value == 'donation') {
                        // Navigate to create task with CHARITY_RELIGION__DONATION tag
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateTaskScreen(
                              initialTagCode: 'CHARITY_RELIGION__DONATION',
                              initialCategoryName: 'Charity & Religion',
                              initialSubcategoryName: 'Donation',
                              entityId: charity.id,
                            ),
                          ),
                        );
                      } else if (value == 'volunteer') {
                        // Navigate to create task with CHARITY_RELIGION__VOLUNTEER tag
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateTaskScreen(
                              initialTagCode: 'CHARITY_RELIGION__VOLUNTEER',
                              initialCategoryName: 'Charity & Religion',
                              initialSubcategoryName: 'Volunteer Work',
                              entityId: charity.id,
                            ),
                          ),
                        );
                      } else if (value == 'event') {
                        // Navigate to create task with CHARITY_RELIGION__EVENT tag
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateTaskScreen(
                              initialTagCode: 'CHARITY_RELIGION__EVENT',
                              initialCategoryName: 'Charity & Religion',
                              initialSubcategoryName: 'Religious Event',
                              entityId: charity.id,
                            ),
                          ),
                        );
                      } else if (value == 'service') {
                        // Navigate to create task with CHARITY_RELIGION__SERVICE tag
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateTaskScreen(
                              initialTagCode: 'CHARITY_RELIGION__SERVICE',
                              initialCategoryName: 'Charity & Religion',
                              initialSubcategoryName: 'Religious Service',
                              entityId: charity.id,
                            ),
                          ),
                        );
                      } else if (value == 'prayer') {
                        // Navigate to create task with CHARITY_RELIGION__PRAYER tag
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateTaskScreen(
                              initialTagCode: 'CHARITY_RELIGION__PRAYER',
                              initialCategoryName: 'Charity & Religion',
                              initialSubcategoryName: 'Prayer/Meditation',
                              entityId: charity.id,
                            ),
                          ),
                        );
                      } else if (value == 'i_want_to') {
                        // Show the I WANT TO menu
                        IWantToMenu.show(
                          context: context,
                          entity: charity,
                          onTagSelected: (tag, category, subcategory) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateTaskScreen(
                                  initialTagCode: tag,
                                  initialCategoryName: category,
                                  initialSubcategoryName: subcategory,
                                  entityId: charity.id,
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'donation',
                        child: ListTile(
                          leading: Icon(Icons.volunteer_activism),
                          title: Text('Add Donation'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'volunteer',
                        child: ListTile(
                          leading: Icon(Icons.people),
                          title: Text('Volunteer Work'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'event',
                        child: ListTile(
                          leading: Icon(Icons.event),
                          title: Text('Religious Event'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'service',
                        child: ListTile(
                          leading: Icon(Icons.church),
                          title: Text('Religious Service'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'prayer',
                        child: ListTile(
                          leading: Icon(Icons.self_improvement),
                          title: Text('Prayer/Meditation'),
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
                          title: Text('Edit Record'),
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
              if (charity.mission != null && charity.mission!.isNotEmpty)
                Text(
                  charity.mission!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 8),
              // Contact information
              if (charity.contactPerson != null && charity.contactPerson!.isNotEmpty) ...[
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Contact: ${charity.contactPerson}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
              ],
              // Last donation information
              if (charity.lastDonationAmount != null && charity.lastDonationDate != null) ...[
                Row(
                  children: [
                    Icon(
                      Icons.attach_money,
                      size: 16,
                      color: Colors.green.shade700,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Last donation: ${_formatCurrency(charity.lastDonationAmount!)} on ${_formatDate(charity.lastDonationDate!)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green.shade700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
              ],
              // Volunteer activity
              if (charity.volunteerActivity != null && charity.volunteerActivity!.isNotEmpty) ...[
                Row(
                  children: [
                    Icon(
                      Icons.volunteer_activism,
                      size: 16,
                      color: Colors.orange.shade700,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Volunteer: ${charity.volunteerActivity}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.orange.shade700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }
}
