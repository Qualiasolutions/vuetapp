import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/providers/family_providers.dart';
import 'package:vuet_app/ui/theme/app_theme.dart';
import 'package:vuet_app/ui/widgets/loading_indicator.dart';
import 'package:vuet_app/ui/widgets/error_view.dart';

/// Shared content management screen for family collaboration
class SharedContentScreen extends ConsumerStatefulWidget {
  const SharedContentScreen({super.key});

  @override
  ConsumerState<SharedContentScreen> createState() => _SharedContentScreenState();
}

class _SharedContentScreenState extends ConsumerState<SharedContentScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserFamilyAsync = ref.watch(currentUserFamilyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shared Content'),
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.textLight,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.textLight,
          labelColor: AppTheme.textLight,
          unselectedLabelColor: AppTheme.textLight.withValues(alpha: 0.7),
          tabs: const [
            Tab(text: 'Lists', icon: Icon(Icons.list_alt)),
            Tab(text: 'Tasks', icon: Icon(Icons.task_alt)),
            Tab(text: 'Entities', icon: Icon(Icons.pets)),
            Tab(text: 'Calendar', icon: Icon(Icons.calendar_today)),
          ],
        ),
      ),
      body: currentUserFamilyAsync.when(
        data: (family) {
          if (family == null) {
            return _buildNoFamilyView(context);
          }
          return _buildContentView(context, family);
        },
        loading: () => const LoadingIndicator(),
        error: (error, _) => ErrorView(
          message: 'Error loading family: $error',
          onRetry: () => ref.invalidate(currentUserFamilyProvider),
        ),
      ),
    );
  }

  Widget _buildNoFamilyView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.family_restroom_outlined,
              size: 80,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(height: 24),
            Text(
              'No Family Group',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Join a family group to access shared content',
              style: TextStyle(color: AppTheme.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentView(BuildContext context, family) {
    return Column(
      children: [
        _buildSearchBar(context),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildSharedListsTab(context, family),
              _buildSharedTasksTab(context, family),
              _buildSharedEntitiesTab(context, family),
              _buildSharedCalendarTab(context, family),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: (query) {
          setState(() {
            _searchQuery = query;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search shared content...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
      ),
    );
  }

  Widget _buildSharedListsTab(BuildContext context, family) {
    return RefreshIndicator(
      onRefresh: () async {
        // TODO: Implement refresh
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              context,
              title: 'Shared Lists',
              subtitle: 'Lists shared with your family',
              icon: Icons.list_alt,
              color: AppTheme.secondary,
              onAddTap: () => _showCreateSharedListDialog(context),
            ),
            const SizedBox(height: 16),
            _buildListsGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSharedTasksTab(BuildContext context, family) {
    return RefreshIndicator(
      onRefresh: () async {
        // TODO: Implement refresh
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              context,
              title: 'Family Tasks',
              subtitle: 'Tasks assigned within your family',
              icon: Icons.task_alt,
              color: AppTheme.accent,
              onAddTap: () => _showCreateFamilyTaskDialog(context),
            ),
            const SizedBox(height: 16),
            _buildTasksView(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSharedEntitiesTab(BuildContext context, family) {
    return RefreshIndicator(
      onRefresh: () async {
        // TODO: Implement refresh
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              context,
              title: 'Family Resources',
              subtitle: 'Shared pets, vehicles, and more',
              icon: Icons.pets,
              color: AppTheme.primary,
              onAddTap: () => _showAddSharedEntityDialog(context),
            ),
            const SizedBox(height: 16),
            _buildEntitiesGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSharedCalendarTab(BuildContext context, family) {
    return RefreshIndicator(
      onRefresh: () async {
        // TODO: Implement refresh
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              context,
              title: 'Family Calendar',
              subtitle: 'Shared events and schedules',
              icon: Icons.calendar_today,
              color: AppTheme.info,
              onAddTap: () => _showCreateEventDialog(context),
            ),
            const SizedBox(height: 16),
            _buildCalendarView(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onAddTap,
  }) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onAddTap,
          icon: const Icon(Icons.add),
          style: IconButton.styleFrom(
            backgroundColor: color,
            foregroundColor: AppTheme.textLight,
          ),
        ),
      ],
    );
  }

  Widget _buildListsGrid(BuildContext context) {
    // Mock data for demonstration
    final mockLists = [
      {
        'name': 'Weekly Groceries',
        'type': 'shopping',
        'items': 12,
        'shared_with': 3,
        'color': AppTheme.secondary,
        'last_updated': ' 2 hours ago',
        'owner': 'Mom',
      },
      {
        'name': 'Holiday Planning',
        'type': 'planning',
        'items': 8,
        'shared_with': 4,
        'color': AppTheme.accent,
        'last_updated': '1 day ago',
        'owner': 'Dad',
      },
      {
        'name': 'House Chores',
        'type': 'tasks',
        'items': 15,
        'shared_with': 3,
        'color': AppTheme.primary,
        'last_updated': '3 hours ago',
        'owner': 'Sarah',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: mockLists.length,
      itemBuilder: (context, index) {
        final list = mockLists[index];
        return _buildListCard(context, list);
      },
    );
  }

  Widget _buildListCard(BuildContext context, Map<String, dynamic> list) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => _openSharedList(context, list),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: list['color'].withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      list['type'] == 'shopping'
                          ? Icons.shopping_cart
                          : list['type'] == 'planning'
                              ? Icons.schedule
                              : Icons.task_alt,
                      color: list['color'],
                      size: 20,
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 16),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'share',
                        child: Row(
                          children: [
                            Icon(Icons.share, size: 16),
                            SizedBox(width: 8),
                            Text('Share'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'remove',
                        child: Row(
                          children: [
                            Icon(Icons.remove_circle, size: 16),
                            SizedBox(width: 8),
                            Text('Remove'),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) => _handleListAction(context, list, value as String),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                list['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                '${list['items']} items',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.people,
                    size: 12,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${list['shared_with']} members',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'by ${list['owner']}',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  Text(
                    list['last_updated'],
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTasksView(BuildContext context) {
    // Mock data for demonstration
    final mockTasks = [
      {
        'title': 'Take out trash',
        'assignee': 'John',
        'assigner': 'Mom',
        'due_date': 'Today',
        'priority': 'high',
        'status': 'pending',
      },
      {
        'title': 'Feed the dog',
        'assignee': 'Sarah',
        'assigner': 'Dad',
        'due_date': 'Tomorrow',
        'priority': 'medium',
        'status': 'in_progress',
      },
      {
        'title': 'Clean garage',
        'assignee': 'Mike',
        'assigner': 'Mom',
        'due_date': 'This weekend',
        'priority': 'low',
        'status': 'pending',
      },
    ];

    return Column(
      children: mockTasks.map((task) => _buildTaskCard(context, task)).toList(),
    );
  }

  Widget _buildTaskCard(BuildContext context, Map<String, dynamic> task) {
    Color priorityColor = task['priority'] == 'high'
        ? Colors.red
        : task['priority'] == 'medium'
            ? AppTheme.accent
            : AppTheme.secondary;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: priorityColor.withValues(alpha: 0.1),
          child: Icon(
            Icons.task_alt,
            color: priorityColor,
            size: 20,
          ),
        ),
        title: Text(
          task['title'],
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Assigned to ${task['assignee']} by ${task['assigner']}'),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.schedule, size: 12, color: AppTheme.textSecondary),
                const SizedBox(width: 4),
                Text(
                  task['due_date'],
                  style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: priorityColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    task['priority'].toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: priorityColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'complete',
              child: Row(
                children: [
                  Icon(Icons.check_circle, size: 16),
                  SizedBox(width: 8),
                  Text('Mark Complete'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'reassign',
              child: Row(
                children: [
                  Icon(Icons.person_add, size: 16),
                  SizedBox(width: 8),
                  Text('Reassign'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 16),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
          ],
          onSelected: (value) => _handleTaskAction(context, task, value as String),
        ),
      ),
    );
  }

  Widget _buildEntitiesGrid(BuildContext context) {
    // Mock data for demonstration
    final mockEntities = [
      {
        'name': 'Max (Dog)',
        'type': 'pet',
        'owner': 'Family',
        'icon': Icons.pets,
        'color': AppTheme.secondary,
      },
      {
        'name': 'Honda Civic',
        'type': 'vehicle',
        'owner': 'Dad',
        'icon': Icons.directions_car,
        'color': AppTheme.accent,
      },
      {
        'name': 'Home Office',
        'type': 'location',
        'owner': 'Mom',
        'icon': Icons.home_work,
        'color': AppTheme.primary,
      },
      {
        'name': 'Vacation House',
        'type': 'property',
        'owner': 'Family',
        'icon': Icons.house,
        'color': AppTheme.info,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: mockEntities.length,
      itemBuilder: (context, index) {
        final entity = mockEntities[index];
        return _buildEntityCard(context, entity);
      },
    );
  }

  Widget _buildEntityCard(BuildContext context, Map<String, dynamic> entity) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => _openEntityDetails(context, entity),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: entity['color'].withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  entity['icon'],
                  color: entity['color'],
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                entity['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'Managed by ${entity['owner']}',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarView(BuildContext context) {
    return Column(
      children: [
        _buildCalendarHeader(context),
        const SizedBox(height: 16),
        _buildUpcomingEvents(context),
      ],
    );
  }

  Widget _buildCalendarHeader(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'This Week',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    '5 family events scheduled',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            TextButton.icon(
              onPressed: () => _openFullCalendar(context),
              icon: const Icon(Icons.calendar_month),
              label: const Text('View Calendar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingEvents(BuildContext context) {
    // Mock data for demonstration
    final mockEvents = [
      {
        'title': 'Soccer Practice',
        'time': 'Today 4:00 PM',
        'attendees': ['John', 'Sarah'],
        'color': AppTheme.secondary,
      },
      {
        'title': 'Family Dinner',
        'time': 'Tomorrow 6:30 PM',
        'attendees': ['Everyone'],
        'color': AppTheme.accent,
      },
      {
        'title': 'School Meeting',
        'time': 'Friday 2:00 PM',
        'attendees': ['Mom', 'Dad'],
        'color': AppTheme.primary,
      },
    ];

    return Column(
      children: mockEvents.map((event) => _buildEventCard(context, event)).toList(),
    );
  }

  Widget _buildEventCard(BuildContext context, Map<String, dynamic> event) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: event['color'].withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.event,
            color: event['color'],
            size: 20,
          ),
        ),
        title: Text(
          event['title'],
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event['time']),
            const SizedBox(height: 4),
            Text(
              'Attendees: ${(event['attendees'] as List).join(', ')}',
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: () => _editEvent(context, event),
          icon: const Icon(Icons.edit),
        ),
      ),
    );
  }

  // Action handlers
  void _openSharedList(BuildContext context, Map<String, dynamic> list) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening ${list['name']}')),
    );
  }

  void _handleListAction(BuildContext context, Map<String, dynamic> list, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$action action for ${list['name']}')),
    );
  }

  void _handleTaskAction(BuildContext context, Map<String, dynamic> task, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$action action for ${task['title']}')),
    );
  }

  void _openEntityDetails(BuildContext context, Map<String, dynamic> entity) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening ${entity['name']} details')),
    );
  }

  void _openFullCalendar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening full calendar view')),
    );
  }

  void _editEvent(BuildContext context, Map<String, dynamic> event) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Editing ${event['title']}')),
    );
  }

  // Dialog methods
  void _showCreateSharedListDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Shared List'),
        content: const Text('Create a new list to share with your family.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showCreateFamilyTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Family Task'),
        content: const Text('Create a new task and assign it to a family member.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showAddSharedEntityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Shared Resource'),
        content: const Text('Add a new shared resource for your family.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showCreateEventDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Family Event'),
        content: const Text('Create a new event for your family calendar.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
} 