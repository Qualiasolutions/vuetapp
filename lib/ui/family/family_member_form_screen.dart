import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme_config.dart';
import '../../models/family_entities.dart';
import '../shared/widgets.dart';

/// FamilyMember Form Screen - Create/Edit FamilyMember entities
/// Following detailed guide: first_name, last_name, relationship, date_of_birth, phone_number, email, notes fields
class FamilyMemberFormScreen extends StatefulWidget {
  const FamilyMemberFormScreen({
    super.key,
    this.familyMember,
    this.isEditing = false,
  });

  final FamilyMember? familyMember;
  final bool isEditing;

  @override
  State<FamilyMemberFormScreen> createState() => _FamilyMemberFormScreenState();
}

class _FamilyMemberFormScreenState extends State<FamilyMemberFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _relationshipController = TextEditingController();
  final _dobController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.familyMember != null) {
      _firstNameController.text = widget.familyMember!.firstName;
      _lastNameController.text = widget.familyMember!.lastName;
      _relationshipController.text = widget.familyMember!.relationship ?? '';
      _dobController.text = widget.familyMember!.dateOfBirth?.toIso8601String().split('T')[0] ?? '';
      _phoneController.text = widget.familyMember!.phoneNumber ?? '';
      _emailController.text = widget.familyMember!.email ?? '';
      _notesController.text = widget.familyMember!.notes ?? '';
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _relationshipController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VuetHeader(widget.isEditing ? 'Edit Family Member' : 'Add Family Member'),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // First Name field - required
            VuetTextField(
              'First Name',
              controller: _firstNameController,
              validator: VuetValidators.required,
            ),
            
            const SizedBox(height: 16),
            
            // Last Name field - required
            VuetTextField(
              'Last Name',
              controller: _lastNameController,
              validator: VuetValidators.required,
            ),
            
            const SizedBox(height: 16),
            
            // Relationship field - required
            VuetTextField(
              'Relationship',
              controller: _relationshipController,
              validator: VuetValidators.required,
            ),
            
            const SizedBox(height: 16),
            
            // Date of Birth field - optional
            VuetDatePicker(
              'Date of Birth (Optional)',
              controller: _dobController,
              validator: (value) => null, // Optional field
            ),
            
            const SizedBox(height: 16),
            
            // Phone Number field - optional
            VuetTextField(
              'Phone Number (Optional)',
              controller: _phoneController,
              validator: (value) => null, // Optional field
              type: TextInputType.phone,
            ),
            
            const SizedBox(height: 16),
            
            // Email field - optional
            VuetTextField(
              'Email (Optional)',
              controller: _emailController,
              validator: (value) => null, // Optional field
              type: TextInputType.emailAddress,
            ),
            
            const SizedBox(height: 16),
            
            // Notes field - optional, multiline
            TextFormField(
              controller: _notesController,
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                hintText: 'Notes (Optional)',
                hintStyle: TextStyle(color: AppColors.steel),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.steel),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.mediumTurquoise),
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
              validator: (value) => null, // Optional field, no validation
            ),
            
            // Form divider as specified in guide
            const VuetDivider(),
            
            // Save button with Modern Palette styling
            VuetSaveButton(
              text: widget.isEditing ? 'Update' : 'Save',
              onPressed: _saveFamilyMember,
            ),
          ],
        ),
      ),
    );
  }

  void _saveFamilyMember() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final familyMember = FamilyMember(
        id: widget.familyMember?.id,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        relationship: _relationshipController.text.trim(),
        dateOfBirth: _dobController.text.trim().isEmpty 
            ? null 
            : DateTime.parse(_dobController.text),
        phoneNumber: _phoneController.text.trim().isEmpty 
            ? null 
            : _phoneController.text.trim(),
        email: _emailController.text.trim().isEmpty 
            ? null 
            : _emailController.text.trim(),
        notes: _notesController.text.trim().isEmpty 
            ? null 
            : _notesController.text.trim(),
      );

      // TODO: Save to Supabase using MCP tools
      // For now, show success message and navigate back
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isEditing 
                ? 'Family member updated successfully' 
                : 'Family member created successfully',
            ),
            backgroundColor: AppColors.mediumTurquoise,
          ),
        );
        
        // Navigate back to family members list
        context.go('/categories/family/family-members');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving family member: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
