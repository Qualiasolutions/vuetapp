import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/theme_config.dart';
import '../../../ui/shared/widgets.dart';
import '../../../models/social_interests_entities.dart';
import 'package:go_router/go_router.dart';

class ContactFormScreen extends ConsumerStatefulWidget {
  final Contact? contact; // null for create, Contact instance for edit
  
  const ContactFormScreen({super.key, this.contact});

  @override
  ConsumerState<ContactFormScreen> createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends ConsumerState<ContactFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for all Contact fields
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late final TextEditingController _birthdayController;
  late final TextEditingController _relationshipController;
  late final TextEditingController _companyController;
  late final TextEditingController _jobTitleController;
  late final TextEditingController _notesController;

  // Relationship type options
  final List<String> _relationshipTypes = [
    'Friend',
    'Family',
    'Colleague',
    'Acquaintance',
    'Business Contact',
    'Neighbor',
    'Classmate',
    'Other'
  ];

  String? _selectedRelationship;

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers with existing data if editing
    final contact = widget.contact;
    _nameController = TextEditingController(text: contact?.name ?? '');
    _phoneController = TextEditingController(text: contact?.phone ?? '');
    _emailController = TextEditingController(text: contact?.email ?? '');
    _addressController = TextEditingController(text: contact?.address ?? '');
    _birthdayController = TextEditingController(
      text: contact?.birthday?.toIso8601String().split('T')[0] ?? ''
    );
    _relationshipController = TextEditingController(text: contact?.relationship ?? '');
    _companyController = TextEditingController(text: contact?.company ?? '');
    _jobTitleController = TextEditingController(text: contact?.jobTitle ?? '');
    _notesController = TextEditingController(text: contact?.notes ?? '');
    
    // Set selected relationship
    _selectedRelationship = contact?.relationship;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _birthdayController.dispose();
    _relationshipController.dispose();
    _companyController.dispose();
    _jobTitleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.contact != null;
    
    return Scaffold(
      appBar: VuetHeader(isEditing ? 'Edit Contact' : 'Add Contact'),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Contact form layout
            VuetTextField(
              'Contact name',
              controller: _nameController,
              validator: SocialInterestsValidators.required,
            ),
            const SizedBox(height: 16),
            
            VuetTextField(
              'Phone (optional)',
              controller: _phoneController,
              validator: SocialInterestsValidators.optionalPhone,
            ),
            const SizedBox(height: 16),
            
            VuetTextField(
              'Email (optional)',
              controller: _emailController,
              validator: SocialInterestsValidators.optionalEmail,
            ),
            const SizedBox(height: 16),
            
            VuetTextField(
              'Address (optional)',
              controller: _addressController,
              validator: (value) => null, // Optional field
            ),
            const SizedBox(height: 16),
            
            VuetDatePicker(
              'Birthday (YYYY-MM-DD, optional)',
              controller: _birthdayController,
              validator: SocialInterestsValidators.optionalDate,
            ),
            const SizedBox(height: 16),
            
            // Relationship dropdown
            DropdownButtonFormField<String>(
              value: _selectedRelationship,
              decoration: InputDecoration(
                labelText: 'Relationship (optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.steel),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.steel),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.mediumTurquoise, width: 2),
                ),
              ),
              items: _relationshipTypes.map((type) => DropdownMenuItem(
                value: type,
                child: Text(type),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRelationship = value;
                  _relationshipController.text = value ?? '';
                });
              },
            ),
            const SizedBox(height: 16),
            
            VuetTextField(
              'Company (optional)',
              controller: _companyController,
              validator: (value) => null, // Optional field
            ),
            const SizedBox(height: 16),
            
            VuetTextField(
              'Job title (optional)',
              controller: _jobTitleController,
              validator: (value) => null, // Optional field
            ),
            const SizedBox(height: 16),
            
            VuetTextField(
              'Notes (optional)',
              controller: _notesController,
              validator: (value) => null, // Optional field
            ),
            
            // Divider
            const VuetDivider(),
            
            // Save button with Modern Palette styling
            VuetSaveButton(
              text: isEditing ? 'Update Contact' : 'Save Contact',
              onPressed: _saveContact,
            ),
          ],
        ),
      ),
    );
  }

  void _saveContact() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      // Parse optional date
      DateTime? parseDate(String text) {
        if (text.trim().isEmpty) return null;
        return DateTime.tryParse(text);
      }

      /* // Commenting out unused variable and its object creation for now
      final contact = Contact(
        id: widget.contact?.id,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
        email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
        address: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
        birthday: parseDate(_birthdayController.text),
        relationship: _selectedRelationship,
        company: _companyController.text.trim().isEmpty ? null : _companyController.text.trim(),
        jobTitle: _jobTitleController.text.trim().isEmpty ? null : _jobTitleController.text.trim(),
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );
      */

      // TODO: Save to Supabase using MCP tools
      // For now, just show success and navigate back
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.contact != null ? 'Contact updated successfully!' : 'Contact created successfully!'),
            backgroundColor: AppColors.mediumTurquoise,
          ),
        );
        
        // Navigate back to contact list
        context.go('/categories/social-interests/contacts');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving contact: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
