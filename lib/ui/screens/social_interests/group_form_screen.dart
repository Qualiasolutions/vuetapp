import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/theme_config.dart';
import '../../../ui/shared/widgets.dart';
import '../../../models/social_interests_entities.dart';
import 'package:go_router/go_router.dart';

class GroupFormScreen extends ConsumerStatefulWidget {
  final String? groupId;
  
  const GroupFormScreen({super.key, this.groupId});

  @override
  ConsumerState<GroupFormScreen> createState() => _GroupFormScreenState();
}

class _GroupFormScreenState extends ConsumerState<GroupFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _groupTypeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _meetingFrequencyController = TextEditingController();
  final _meetingLocationController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _contactPhoneController = TextEditingController();
  final _contactEmailController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedGroupType;
  String? _selectedMeetingFrequency;

  final List<String> _groupTypes = [
    'Club',
    'Society',
    'Team',
    'Organization',
    'Committee',
    'Association',
    'Community Group',
    'Study Group',
    'Support Group',
    'Hobby Group',
    'Professional Group',
    'Volunteer Group',
  ];

  final List<String> _meetingFrequencies = [
    'Daily',
    'Weekly',
    'Bi-weekly',
    'Monthly',
    'Quarterly',
    'Annually',
    'As needed',
    'Irregular',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.groupId != null) {
      _loadGroupData();
    }
  }

  void _loadGroupData() {
    // TODO: Load group data from Supabase MCP when editing
    // For now, using sample data for edit mode demonstration
    if (widget.groupId == '1') {
      _nameController.text = 'Book Club';
      _selectedGroupType = 'Club';
      _groupTypeController.text = 'Club';
      _descriptionController.text = 'Monthly book reading and discussion group';
      _selectedMeetingFrequency = 'Monthly';
      _meetingFrequencyController.text = 'Monthly';
      _meetingLocationController.text = 'Community Library';
      _contactPersonController.text = 'Jane Smith';
      _contactPhoneController.text = '+1 555-0123';
      _contactEmailController.text = 'jane.smith@email.com';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _groupTypeController.dispose();
    _descriptionController.dispose();
    _meetingFrequencyController.dispose();
    _meetingLocationController.dispose();
    _contactPersonController.dispose();
    _contactPhoneController.dispose();
    _contactEmailController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.groupId != null;
    
    return Scaffold(
      appBar: VuetHeader(isEditing ? 'Edit Group' : 'Add Group'),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Group Name
            VuetTextField(
              'Group Name',
              controller: _nameController,
              validator: SocialInterestsValidators.required,
            ),
            const SizedBox(height: 16),

            // Group Type Dropdown
            GestureDetector(
              onTap: _showGroupTypeDropdown,
              child: AbsorbPointer(
                child: VuetTextField(
                  'Group Type',
                  controller: _groupTypeController,
                  validator: SocialInterestsValidators.required,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Description
            VuetTextField(
              'Description (optional)',
              controller: _descriptionController,
              validator: (value) => null,
            ),
            const SizedBox(height: 16),

            // Meeting Frequency Dropdown
            GestureDetector(
              onTap: _showMeetingFrequencyDropdown,
              child: AbsorbPointer(
                child: VuetTextField(
                  'Meeting Frequency (optional)',
                  controller: _meetingFrequencyController,
                  validator: (value) => null,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Meeting Location
            VuetTextField(
              'Meeting Location (optional)',
              controller: _meetingLocationController,
              validator: (value) => null,
            ),
            const SizedBox(height: 24),

            // Contact Information Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.steel.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.steel.withValues(alpha: 0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.contact_phone,
                        color: AppColors.mediumTurquoise,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Contact Information',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkJungleGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Contact Person
                  VuetTextField(
                    'Contact Person (optional)',
                    controller: _contactPersonController,
                    validator: (value) => null,
                  ),
                  const SizedBox(height: 16),

                  // Contact Phone
                  VuetTextField(
                    'Contact Phone (optional)',
                    controller: _contactPhoneController,
                    validator: SocialInterestsValidators.optionalPhone,
                  ),
                  const SizedBox(height: 16),

                  // Contact Email
                  VuetTextField(
                    'Contact Email (optional)',
                    controller: _contactEmailController,
                    validator: SocialInterestsValidators.optionalEmail,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Notes
            VuetTextField(
              'Notes (optional)',
              controller: _notesController,
              validator: (value) => null,
            ),
            const SizedBox(height: 32),

            // Save Button
            VuetSaveButton(
              text: isEditing ? 'Update Group' : 'Save Group',
              onPressed: _saveGroup,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showGroupTypeDropdown() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Group Type',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.darkJungleGreen,
              ),
            ),
            const SizedBox(height: 16),
            ...(_groupTypes.map((type) => ListTile(
              title: Text(type),
              leading: Icon(
                _getGroupTypeIcon(type),
                color: AppColors.mediumTurquoise,
              ),
              onTap: () {
                setState(() {
                  _selectedGroupType = type;
                  _groupTypeController.text = type;
                });
                Navigator.pop(context);
              },
            ))),
          ],
        ),
      ),
    );
  }

  void _showMeetingFrequencyDropdown() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Meeting Frequency',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.darkJungleGreen,
              ),
            ),
            const SizedBox(height: 16),
            ...(_meetingFrequencies.map((frequency) => ListTile(
              title: Text(frequency),
              leading: Icon(
                Icons.schedule,
                color: AppColors.mediumTurquoise,
              ),
              onTap: () {
                setState(() {
                  _selectedMeetingFrequency = frequency;
                  _meetingFrequencyController.text = frequency;
                });
                Navigator.pop(context);
              },
            ))),
          ],
        ),
      ),
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

  void _saveGroup() {
    if (_formKey.currentState!.validate()) {
      // TODO: Save to Supabase MCP
      final group = Group(
        id: widget.groupId != null ? int.tryParse(widget.groupId!) : null,
        name: _nameController.text.trim(),
        groupType: _selectedGroupType ?? _groupTypeController.text.trim(),
        description: _descriptionController.text.trim().isNotEmpty 
            ? _descriptionController.text.trim() 
            : null,
        meetingFrequency: _selectedMeetingFrequency ?? 
            (_meetingFrequencyController.text.trim().isNotEmpty 
                ? _meetingFrequencyController.text.trim() 
                : null),
        meetingLocation: _meetingLocationController.text.trim().isNotEmpty 
            ? _meetingLocationController.text.trim() 
            : null,
        contactPerson: _contactPersonController.text.trim().isNotEmpty 
            ? _contactPersonController.text.trim() 
            : null,
        contactPhone: _contactPhoneController.text.trim().isNotEmpty 
            ? _contactPhoneController.text.trim() 
            : null,
        contactEmail: _contactEmailController.text.trim().isNotEmpty 
            ? _contactEmailController.text.trim() 
            : null,
        notes: _notesController.text.trim().isNotEmpty 
            ? _notesController.text.trim() 
            : null,
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.groupId != null 
              ? 'Group updated successfully' 
              : 'Group saved successfully'),
          backgroundColor: AppColors.mediumTurquoise,
        ),
      );

      // Navigate back to groups list
      context.go('/categories/social-interests/groups');
    }
  }
}
