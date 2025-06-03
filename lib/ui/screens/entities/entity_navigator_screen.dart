import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/entity_model.dart';
import 'package:vuet_app/providers/entity_providers.dart';
import 'package:vuet_app/providers/entity_actions_provider.dart';
import 'package:vuet_app/ui/screens/entities/tabs/entity_overview_tab.dart';
import 'package:vuet_app/ui/screens/entities/tabs/entity_calendar_tab.dart';
import 'package:vuet_app/ui/screens/entities/tabs/entity_references_tab.dart';
import 'package:vuet_app/ui/screens/entities/tabs/entity_messages_tab.dart';
import 'package:vuet_app/ui/screens/entities/tabs/entity_home_tab.dart';
import 'package:vuet_app/ui/screens/entities/create_edit_entity_screen.dart';
import 'package:vuet_app/ui/widgets/modern_components.dart';

// Tab configuration for different entity types
class EntityTab {
  final String name;
  final String title;
  final IconData icon;
  final Widget Function(String entityId) builder;
  final bool Function(BaseEntityModel entity)? shouldShow;

  const EntityTab({
    required this.name,
    required this.title,
    required this.icon,
    required this.builder,
    this.shouldShow,
  });
}

class EntityNavigatorScreen extends ConsumerStatefulWidget {
  final String entityId;

  const EntityNavigatorScreen({
    super.key,
    required this.entityId,
  });

  @override
  ConsumerState<EntityNavigatorScreen> createState() => _EntityNavigatorScreenState();
}

class _EntityNavigatorScreenState extends ConsumerState<EntityNavigatorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<EntityTab> _availableTabs = [];

  // Define all possible tabs
  static final List<EntityTab> _allTabs = [
    EntityTab(
      name: 'home',
      title: 'Home',
      icon: Icons.home,
      builder: (entityId) => EntityHomeTab(entityId: entityId),
      shouldShow: (entity) => _hasSpecializedHomePage(entity),
    ),
    EntityTab(
      name: 'overview',
      title: 'Overview',
      icon: Icons.info_outline,
      builder: (entityId) => EntityOverviewTab(entityId: entityId),
    ),
    EntityTab(
      name: 'calendar',
      title: 'Calendar',
      icon: Icons.calendar_today,
      builder: (entityId) => EntityCalendarTab(entityId: entityId),
    ),
    EntityTab(
      name: 'references',
      title: 'References',
      icon: Icons.link,
      builder: (entityId) => EntityReferencesTab(entityId: entityId),
      shouldShow: (entity) => _isMemberEntity(entity),
    ),
    EntityTab(
      name: 'messages',
      title: 'Messages',
      icon: Icons.message,
      builder: (entityId) => EntityMessagesTab(entityId: entityId),
      shouldShow: (entity) => _isMemberEntity(entity),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 0, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _updateTabsForEntity(BaseEntityModel entity) {
    final newTabs = _allTabs.where((tab) {
      return tab.shouldShow?.call(entity) ?? true;
    }).toList();

    if (_availableTabs.length != newTabs.length ||
        !_availableTabs.every((tab) => newTabs.any((newTab) => newTab.name == tab.name))) {
      setState(() {
        _availableTabs = newTabs;
        _tabController.dispose();
        _tabController = TabController(length: _availableTabs.length, vsync: this);
        
        // Set initial tab based on entity type
        final initialTabIndex = _getInitialTabIndex(entity);
        if (initialTabIndex < _availableTabs.length) {
          _tabController.index = initialTabIndex;
        }
      });
    }
  }

  int _getInitialTabIndex(BaseEntityModel entity) {
    // Determine initial tab based on entity type (matching React original)
    switch (entity.subtype) {
      // Note: 'list' is not in 50-entity system - keeping for backwards compatibility
      case EntitySubtype.event:
        return _availableTabs.indexWhere((tab) => tab.name == 'overview');
      default:
        return _availableTabs.indexWhere((tab) => tab.name == 'calendar');
    }
  }

  static bool _hasSpecializedHomePage(BaseEntityModel entity) {
    // Entities that have specialized home pages (matching React original)
    switch (entity.subtype) {
      case EntitySubtype.event:
        return true;
      default:
        return false;
    }
  }

  static bool _isMemberEntity(BaseEntityModel entity) {
    // Check if user is a member of this entity (for now, assume true)
    // TODO: Implement proper membership checking when family features are added
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final entityAsyncValue = ref.watch(entityByIdProvider(widget.entityId));

    return entityAsyncValue.when(
      data: (entity) {
        if (entity == null) {
          return _buildNotFoundState(context);
        }

        // Update tabs when entity changes
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _updateTabsForEntity(entity);
        });

        if (_availableTabs.isEmpty) {
          return _buildLoadingState();
        }

        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 200,
                  pinned: true,
                  backgroundColor: _getEntityColor(entity),
                  foregroundColor: Colors.white,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      entity.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 2.0,
                            color: Color.fromARGB(150, 0, 0, 0),
                          ),
                        ],
                      ),
                    ),
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            _getEntityColor(entity),
                            _getEntityColor(entity).withAlpha((0.8 * 255).round()),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          _getEntityIcon(entity),
                          size: 80,
                          color: Colors.white.withAlpha((0.3 * 255).round()),
                        ),
                      ),
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _navigateToEdit(context, entity),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) => _handleMenuAction(context, entity, value),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'duplicate',
                          child: ListTile(
                            leading: Icon(Icons.copy),
                            title: Text('Duplicate'),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: ListTile(
                            leading: Icon(Icons.delete, color: Colors.red),
                            title: Text('Delete', style: TextStyle(color: Colors.red)),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                  ],
                  bottom: TabBar(
                    controller: _tabController,
                    isScrollable: _availableTabs.length > 3,
                    indicatorColor: Colors.white,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white.withAlpha((0.7 * 255).round()),
                    tabs: _availableTabs.map((tab) => Tab(
                      icon: Icon(tab.icon),
                      text: tab.title,
                    )).toList(),
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: _availableTabs.map((tab) => tab.builder(widget.entityId)).toList(),
            ),
          ),
        );
      },
      loading: () => _buildLoadingState(),
      error: (error, stackTrace) => _buildErrorState(context, error),
    );
  }

  Widget _buildLoadingState() {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: ModernComponents.modernEmptyState(
        icon: Icons.error_outline,
        title: 'Error Loading Entity',
        subtitle: error.toString(),
        buttonText: 'Go Back',
        onButtonPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildNotFoundState(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Not Found'),
      ),
      body: ModernComponents.modernEmptyState(
        icon: Icons.search_off,
        title: 'Entity Not Found',
        subtitle: 'The entity you\'re looking for doesn\'t exist or has been deleted.',
        buttonText: 'Go Back',
        onButtonPressed: () => Navigator.pop(context),
      ),
    );
  }

  void _navigateToEdit(BuildContext context, BaseEntityModel entity) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateEditEntityScreen(
          appCategoryId: entity.appCategoryId ?? 0,
          entityId: entity.id,
        ),
      ),
    );
  }

  void _handleMenuAction(BuildContext context, BaseEntityModel entity, String action) {
    switch (action) {
      case 'duplicate':
        _duplicateEntity(context, entity);
        break;
      case 'delete':
        _showDeleteConfirmation(context, entity);
        break;
    }
  }

  void _duplicateEntity(BuildContext context, BaseEntityModel entity) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateEditEntityScreen(
          appCategoryId: entity.appCategoryId ?? 0,
          // TODO: Pass duplicated entity data when create/edit screen supports it
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, BaseEntityModel entity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Entity'),
        content: Text('Are you sure you want to delete "${entity.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              try {
                await ref.read(entityActionsProvider.notifier).deleteEntity(entity.id!);
                if (context.mounted) {
                  Navigator.pop(context); // Go back to list
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${entity.name} deleted successfully')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete entity: $e')),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // Helper methods for entity styling (updated for 50-entity system)
  Color _getEntityColor(BaseEntityModel entity) {
    switch (entity.subtype) {
      // Pets category (1) - Orange
      case EntitySubtype.pet:
      case EntitySubtype.vet:
      case EntitySubtype.walker:
      case EntitySubtype.groomer:
      case EntitySubtype.sitter:
      case EntitySubtype.microchipCompany:
      case EntitySubtype.insuranceCompany:
      case EntitySubtype.insurancePolicy:
        return const Color(0xFFE49F30);
      
      // Social Interests category (2) - Purple
      case EntitySubtype.anniversary:
      case EntitySubtype.anniversaryPlan:
      case EntitySubtype.birthday:
      case EntitySubtype.event:
      case EntitySubtype.guestListInvite:
      case EntitySubtype.hobby:
      case EntitySubtype.holiday:
      case EntitySubtype.holidayPlan:
      case EntitySubtype.socialMedia:
      case EntitySubtype.socialPlan:
        return const Color(0xFF9C27B0);
      
      // Education category (3) - Blue
      case EntitySubtype.academicPlan:
      case EntitySubtype.courseWork:
      case EntitySubtype.extracurricularPlan:
      case EntitySubtype.school:
      case EntitySubtype.student:
      case EntitySubtype.subject:
      case EntitySubtype.teacher:
      case EntitySubtype.tutor:
        return const Color(0xFF2196F3);
      
      // Career category (4) - Blue
      case EntitySubtype.colleague:
      case EntitySubtype.work:
        return const Color(0xFF2196F3);
      
      // Travel category (5) - Cyan
      case EntitySubtype.trip:
        return const Color(0xFF00BCD4);
      
      // Health category (6) - Green
      case EntitySubtype.beautySalon:
      case EntitySubtype.dentist:
      case EntitySubtype.doctor:
      case EntitySubtype.stylist:
      case EntitySubtype.therapist:
      case EntitySubtype.physiotherapist:
      case EntitySubtype.specialist:
      case EntitySubtype.surgeon:
        return const Color(0xFF4CAF50);
      
      // Home category (7) - Teal
      case EntitySubtype.appliance:
      case EntitySubtype.contractor:
      case EntitySubtype.furniture:
      case EntitySubtype.home:
      case EntitySubtype.room:
        return const Color(0xFF1A6E68);
      
      // Garden category (8) - Green
      case EntitySubtype.tool:
      case EntitySubtype.plant:
        return const Color(0xFF4CAF50);
      
      // Food category (9) - Orange
      case EntitySubtype.foodPlan:
      case EntitySubtype.recipe:
      case EntitySubtype.restaurant:
        return const Color(0xFFFF9800);
      
      // Laundry category (10) - Blue Grey
      case EntitySubtype.item:
      case EntitySubtype.dryCleaners:
        return const Color(0xFF607D8B);
      
      // Finance category (11) - Brown
      case EntitySubtype.bank:
      case EntitySubtype.bankAccount:
      case EntitySubtype.creditCard:
        return const Color(0xFF795548);
      
      // Transport category (12) - Blue Grey
      case EntitySubtype.boat:
      case EntitySubtype.car:
      case EntitySubtype.publicTransport:
      case EntitySubtype.motorcycle:
      case EntitySubtype.bicycle:
      case EntitySubtype.truck:
      case EntitySubtype.van:
      case EntitySubtype.rv:
      case EntitySubtype.atv:
      case EntitySubtype.jetSki:
        return const Color(0xFF607D8B);
        
      // Document entities and other cases
      default:
        return const Color(0xFF9E9E9E); // Grey color for any unhandled subtypes
    }
  }

  IconData _getEntityIcon(BaseEntityModel entity) {
    switch (entity.subtype) {
      case EntitySubtype.pet:
        return Icons.pets;
      case EntitySubtype.vet:
        return Icons.local_hospital;
      case EntitySubtype.walker:
        return Icons.directions_walk;
      case EntitySubtype.groomer:
        return Icons.content_cut;
      case EntitySubtype.sitter:
        return Icons.night_shelter;
      case EntitySubtype.microchipCompany:
        return Icons.memory;
      case EntitySubtype.insuranceCompany:
        return Icons.shield;
      case EntitySubtype.insurancePolicy:
        return Icons.policy;
      case EntitySubtype.petBirthday:
        return Icons.cake;
      case EntitySubtype.plant:
        return Icons.local_florist;
      case EntitySubtype.tool:
        return Icons.build;
      case EntitySubtype.restaurant:
        return Icons.restaurant;
      case EntitySubtype.item:
        return Icons.checkroom;
      case EntitySubtype.dryCleaners:
        return Icons.checkroom;
      case EntitySubtype.bank:
        return Icons.account_balance;
      case EntitySubtype.creditCard:
        return Icons.credit_card;
      case EntitySubtype.motorcycle:
        return Icons.motorcycle;
      case EntitySubtype.document:
        return Icons.description;
      case EntitySubtype.passport:
        return Icons.badge;
      default:
        return Icons.folder;
    }
  }
}
