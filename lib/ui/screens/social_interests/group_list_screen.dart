import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/theme_config.dart';
import '../../../ui/shared/widgets.dart';
import '../../../models/social_interests_entities.dart';
import 'package:go_router/go_router.dart';

class GroupListScreen extends ConsumerStatefulWidget {
  const GroupListScreen({super.key});

  @override
  ConsumerState<GroupListScreen> createState() => _GroupListScreenState();
}

class _GroupListScreenState extends ConsumerState<GroupListScreen> {
  // Sample data for now - will be replaced with Supabase MCP integration
  List<Group> _groups = [
    Group(
      id: 1,
      name: 'Book Club',
      groupType: 'Club',
      description: 'Monthly book reading and discussion group',
      meetingFrequency: 'Monthly',
      meetingLocation: 'Community Library',
      contactPerson: 'Jane Smith',
      contactPhone: '+1 555-0123',
      contactEmail: 'jane.smith@email.com',
    ),
    Group(
      id: 2,
      name: 'Photography Society',
      groupType: 'Society',
      description: 'Exploring photography techniques and sharing experiences',
      meetingFrequency: 'Weekly',
      meetingLocation: 'Art Center',
      contactPerson: 'Mike Johnson',
      contactEmail: 'mike.j@photoclub.com',
    ),
    Group(
      id: 3,
      name: 'Volunteer Team',
      groupType: 'Volunteer Group',
      description: 'Community service and charity work',
      meetingFrequency: 'Bi-weekly',
      contactPerson: 'Sarah Wilson',
      contactPhone: '+1 555-0789',
      notes: 'Always looking for new volunteers!',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VuetHeader('Groups'),
      floatingActionButton: VuetFAB(
        onPressed: () => context.go('/categories/social-interests/groups/create'),
        tooltip: 'Add Group',
      ),
      body: _groups.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _groups.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _buildGroupCard(_groups[index]),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.groups,
            size: 64,
            color: AppColors.steel,
          ),
          const SizedBox(height: 16),
          Text(
            'No groups yet',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.steel,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add your first group',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.steel,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupCard(Group group) {
    return Card(
      color: AppColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.steel.withValues(alpha: 0.2)),
      ),
      child: InkWell(
        onTap: () => _showGroupDetails(group),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with name and actions
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          group.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkJungleGreen,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          group.groupType,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.steel,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Group type icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.mediumTurquoise.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getGroupTypeIcon(group.groupType),
                      color: AppColors.mediumTurquoise,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 8),
                  PopupMenuButton<String>(
                    onSelected: (value) => _handleMenuAction(value, group),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Group details
              if (group.description != null && group.description!.isNotEmpty) ...[
                Text(
                  group.description!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.darkJungleGreen,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
              ],
              
              if (group.meetingFrequency != null && group.meetingFrequency!.isNotEmpty) ...[
                _buildInfoRow('Frequency', group.meetingFrequency!),
                const SizedBox(height: 4),
              ],
              
              if (group.meetingLocation != null && group.meetingLocation!.isNotEmpty) ...[
                _buildInfoRow('Location', group.meetingLocation!),
                const SizedBox(height: 4),
              ],
              
              if (group.contactPerson != null && group.contactPerson!.isNotEmpty)
                _buildInfoRow('Contact', group.contactPerson!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.steel,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.darkJungleGreen,
            ),
          ),
        ),
      ],
    );
  }

  IconData _getGroupTypeIcon(String groupType) {
    switch (groupType.toLowerCase()) {
      case 'club':
        return Icons.groups;
      case 'society':
        return Icons.account_balance;
      case 'team':
        return Icons.sports;
      case 'organization':
        return Icons.business;
      case 'committee':
        return Icons.gavel;
      case 'association':
        return Icons.handshake;
      case 'community group':
        return Icons.location_city;
      case 'study group':
        return Icons.school;
      case 'support group':
        return Icons.favorite;
      case 'hobby group':
        return Icons.palette;
      case 'professional group':
        return Icons.work;
      case 'volunteer group':
        return Icons.volunteer_activism;
      default:
        return Icons.group;
    }
  }

  void _showGroupDetails(Group group) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.steel,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Title with icon
              Row(
                children: [
                  Icon(
                    _getGroupTypeIcon(group.groupType),
                    color: AppColors.mediumTurquoise,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      group.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkJungleGreen,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Details
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    _buildDetailRow('Group Type', group.groupType),
                    if (group.description != null && group.description!.isNotEmpty)
                      _buildDetailRow('Description', group.description!),
                    if (group.meetingFrequency != null && group.meetingFrequency!.isNotEmpty)
                      _buildDetailRow('Meeting Frequency', group.meetingFrequency!),
                    if (group.meetingLocation != null && group.meetingLocation!.isNotEmpty)
                      _buildDetailRow('Meeting Location', group.meetingLocation!),
                    if (group.contactPerson != null && group.contactPerson!.isNotEmpty)
                      _buildDetailRow('Contact Person', group.contactPerson!),
                    if (group.contactPhone != null && group.contactPhone!.isNotEmpty)
                      _buildDetailRow('Contact Phone', group.contactPhone!),
                    if (group.contactEmail != null && group.contactEmail!.isNotEmpty)
                      _buildDetailRow('Contact Email', group.contactEmail!),
                    if (group.notes != null && group.notes!.isNotEmpty)
                      _buildDetailRow('Notes', group.notes!),
                  ],
                ),
              ),
              
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.go('/categories/social-interests/groups/edit/${group.id}');
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.mediumTurquoise),
                      ),
                      child: const Text('Edit', style: TextStyle(color: AppColors.mediumTurquoise)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: VuetSaveButton(
                      text: 'Close',
                      onPressed: () => Navigator.pop(context),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.steel,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.darkJungleGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(String action, Group group) {
    switch (action) {
      case 'edit':
        context.go('/categories/social-interests/groups/edit/${group.id}');
        break;
      case 'delete':
        _showDeleteConfirmation(group);
        break;
    }
  }

  void _showDeleteConfirmation(Group group) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Group'),
        content: Text('Are you sure you want to delete "${group.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteGroup(group);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _deleteGroup(Group group) {
    setState(() {
      _groups.removeWhere((g) => g.id == group.id);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${group.name} deleted'),
        backgroundColor: AppColors.mediumTurquoise,
        action: SnackBarAction(
          label: 'Undo',
          textColor: AppColors.white,
          onPressed: () {
            setState(() {
              _groups.add(group);
            });
          },
        ),
      ),
    );
  }
}
