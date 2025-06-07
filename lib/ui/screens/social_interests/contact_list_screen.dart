import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/theme_config.dart';
import '../../../ui/shared/widgets.dart';
import '../../../models/social_interests_entities.dart';
import 'package:go_router/go_router.dart';

class ContactListScreen extends ConsumerStatefulWidget {
  const ContactListScreen({super.key});

  @override
  ConsumerState<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends ConsumerState<ContactListScreen> {
  // Sample data for now - will be replaced with Supabase MCP integration
  final List<Contact> _contacts = [
    Contact(
      id: 1,
      name: 'John Smith',
      phone: '+1 555-0123',
      email: 'john.smith@email.com',
      relationship: 'Friend',
      company: 'Tech Corp',
      jobTitle: 'Software Engineer',
    ),
    Contact(
      id: 2,
      name: 'Sarah Johnson',
      phone: '+1 555-0456',
      email: 'sarah.j@email.com',
      relationship: 'Colleague',
      birthday: DateTime(1990, 5, 15),
      notes: 'Great project manager, loves coffee',
    ),
    Contact(
      id: 3,
      name: 'Mike Wilson',
      relationship: 'Family',
      address: '123 Main St, City, State',
      birthday: DateTime(1985, 12, 3),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VuetHeader('Contacts'),
      floatingActionButton: VuetFAB(
        onPressed: () => context.go('/categories/social-interests/contacts/create'),
        tooltip: 'Add Contact',
      ),
      body: _contacts.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _contacts.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _buildContactCard(_contacts[index]),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.contacts,
            size: 64,
            color: AppColors.steel,
          ),
          const SizedBox(height: 16),
          Text(
            'No contacts yet',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.steel,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add your first contact',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.steel,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(Contact contact) {
    return Card(
      color: AppColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.steel.withValues(alpha: 0.2)),
      ),
      child: InkWell(
        onTap: () => _showContactDetails(contact),
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
                          contact.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkJungleGreen,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (contact.relationship != null)
                          Text(
                            contact.relationship!,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.steel,
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Relationship icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.mediumTurquoise.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getRelationshipIcon(contact.relationship),
                      color: AppColors.mediumTurquoise,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 8),
                  PopupMenuButton<String>(
                    onSelected: (value) => _handleMenuAction(value, contact),
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
              
              // Contact details
              if (contact.phone != null && contact.phone!.isNotEmpty)
                _buildInfoRow('Phone', contact.phone!),
              
              if (contact.email != null && contact.email!.isNotEmpty) ...[
                const SizedBox(height: 8),
                _buildInfoRow('Email', contact.email!),
              ],
              
              if (contact.company != null && contact.company!.isNotEmpty) ...[
                const SizedBox(height: 8),
                _buildInfoRow('Company', contact.company!),
              ],
              
              if (contact.jobTitle != null && contact.jobTitle!.isNotEmpty) ...[
                const SizedBox(height: 8),
                _buildInfoRow('Job Title', contact.jobTitle!),
              ],
              
              if (contact.birthday != null) ...[
                const SizedBox(height: 8),
                _buildBirthdayRow(contact.birthday!),
              ],
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

  Widget _buildBirthdayRow(DateTime birthday) {
    final now = DateTime.now();
    final nextBirthday = DateTime(now.year, birthday.month, birthday.day);
    if (nextBirthday.isBefore(now)) {
      nextBirthday.add(const Duration(days: 365));
    }
    final daysUntil = nextBirthday.difference(now).inDays;
    
    return Row(
      children: [
        Text(
          'Birthday: ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.steel,
          ),
        ),
        Text(
          birthday.toIso8601String().split('T')[0],
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.darkJungleGreen,
          ),
        ),
        if (daysUntil <= 30) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.orange.withValues(alpha: 0.3)),
            ),
            child: Text(
              daysUntil == 0 ? 'Today!' : '$daysUntil days',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.orange,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }

  IconData _getRelationshipIcon(String? relationship) {
    switch (relationship?.toLowerCase()) {
      case 'friend':
        return Icons.people;
      case 'family':
        return Icons.family_restroom;
      case 'colleague':
        return Icons.work;
      case 'business contact':
        return Icons.business;
      case 'neighbor':
        return Icons.home;
      case 'classmate':
        return Icons.school;
      default:
        return Icons.person;
    }
  }

  void _showContactDetails(Contact contact) {
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
                    _getRelationshipIcon(contact.relationship),
                    color: AppColors.mediumTurquoise,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      contact.name,
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
                    if (contact.relationship != null && contact.relationship!.isNotEmpty)
                      _buildDetailRow('Relationship', contact.relationship!),
                    if (contact.phone != null && contact.phone!.isNotEmpty)
                      _buildDetailRow('Phone', contact.phone!),
                    if (contact.email != null && contact.email!.isNotEmpty)
                      _buildDetailRow('Email', contact.email!),
                    if (contact.address != null && contact.address!.isNotEmpty)
                      _buildDetailRow('Address', contact.address!),
                    if (contact.birthday != null)
                      _buildDetailRow('Birthday', contact.birthday!.toIso8601String().split('T')[0]),
                    if (contact.company != null && contact.company!.isNotEmpty)
                      _buildDetailRow('Company', contact.company!),
                    if (contact.jobTitle != null && contact.jobTitle!.isNotEmpty)
                      _buildDetailRow('Job Title', contact.jobTitle!),
                    if (contact.notes != null && contact.notes!.isNotEmpty)
                      _buildDetailRow('Notes', contact.notes!),
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
                        context.go('/categories/social-interests/contacts/edit/${contact.id}');
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

  void _handleMenuAction(String action, Contact contact) {
    switch (action) {
      case 'edit':
        context.go('/categories/social-interests/contacts/edit/${contact.id}');
        break;
      case 'delete':
        _showDeleteConfirmation(contact);
        break;
    }
  }

  void _showDeleteConfirmation(Contact contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Contact'),
        content: Text('Are you sure you want to delete "${contact.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteContact(contact);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _deleteContact(Contact contact) {
    setState(() {
      _contacts.removeWhere((c) => c.id == contact.id);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${contact.name} deleted'),
        backgroundColor: AppColors.mediumTurquoise,
        action: SnackBarAction(
          label: 'Undo',
          textColor: AppColors.white,
          onPressed: () {
            setState(() {
              _contacts.add(contact);
            });
          },
        ),
      ),
    );
  }
}
