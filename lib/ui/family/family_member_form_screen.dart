import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:vuet_app/models/family_entities.dart';
import 'package:vuet_app/providers/family_member_providers.dart';
import 'package:vuet_app/ui/shared/widgets.dart';
import 'package:vuet_app/config/theme_config.dart';

class FamilyMemberFormScreen extends ConsumerStatefulWidget {
  final String? familyMemberId; // This will be the BaseEntityModel ID (string)

  const FamilyMemberFormScreen({super.key, this.familyMemberId});

  @override
  ConsumerState<FamilyMemberFormScreen> createState() => _FamilyMemberFormScreenState();
}

class _FamilyMemberFormScreenState extends ConsumerState<FamilyMemberFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _relationshipController;
  late TextEditingController _dobController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _notesController;

  FamilyMember? _existingFamilyMember;
  bool _isLoading = false;
  DateTime? _selectedDateOfBirth;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _relationshipController = TextEditingController();
    _dobController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _notesController = TextEditingController();

    if (widget.familyMemberId != null) {
      _loadExistingData();
    }
  }

  Future<void> _loadExistingData() async {
    setState(() => _isLoading = true);
    try {
      // familyMemberByIdProvider expects the BaseEntityModel ID (string)
      _existingFamilyMember = await ref.read(familyMemberByIdProvider(widget.familyMemberId!).future);
      if (_existingFamilyMember != null) {
        _firstNameController.text = _existingFamilyMember!.firstName;
        _lastNameController.text = _existingFamilyMember!.lastName;
        _relationshipController.text = _existingFamilyMember!.relationship ?? '';
        if (_existingFamilyMember!.dateOfBirth != null) {
          _selectedDateOfBirth = _existingFamilyMember!.dateOfBirth;
          _dobController.text = DateFormat('yyyy-MM-dd').format(_selectedDateOfBirth!);
        }
        _phoneController.text = _existingFamilyMember!.phoneNumber ?? '';
        _emailController.text = _existingFamilyMember!.email ?? '';
        _notesController.text = _existingFamilyMember!.notes ?? '';
      } else {
        // Handle case where member is not found, though provider might throw error too
         if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Family member not found.'), backgroundColor: Colors.red));
      }
    } catch (e) {
       if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading data: $e'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoading = false);
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateOfBirth ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDateOfBirth) {
      setState(() {
        _selectedDateOfBirth = picked;
        _dobController.text = DateFormat('yyyy-MM-dd').format(_selectedDateOfBirth!);
      });
    }
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      final familyMemberData = FamilyMember(
        id: _existingFamilyMember?.id, // This is the int ID from FamilyMember model
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        relationship: _relationshipController.text.trim().isNotEmpty ? _relationshipController.text.trim() : null,
        dateOfBirth: _selectedDateOfBirth,
        phoneNumber: _phoneController.text.trim().isNotEmpty ? _phoneController.text.trim() : null,
        email: _emailController.text.trim().isNotEmpty ? _emailController.text.trim() : null,
        notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
      );

      try {
        final service = ref.read(familyMemberServiceProvider);
        if (_existingFamilyMember == null) {
          await service.addFamilyMember(familyMemberData);
        } else {
          await service.updateFamilyMember(familyMemberData);
        }
        // Refresh the list provider after saving
        ref.refresh(familyMembersProvider);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Family member saved successfully!'), backgroundColor: AppColors.mediumTurquoise),
          );
          context.pop(); // Go back to the list screen
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving family member: $e'), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = _existingFamilyMember != null;
    return Scaffold(
      appBar: VuetHeader(isEditMode ? 'Edit Family Member' : 'Add Family Member'),
      body: _isLoading && widget.familyMemberId != null // Show loader only when fetching existing data
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _buildTextFormField(_firstNameController, 'First Name', isRequired: true),
                    const SizedBox(height: 16),
                    _buildTextFormField(_lastNameController, 'Last Name', isRequired: true),
                    const SizedBox(height: 16),
                    _buildTextFormField(_relationshipController, 'Relationship (e.g., Father, Sister)'),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      _dobController,
                      'Date of Birth (YYYY-MM-DD)',
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      suffixIcon: Icons.calendar_today,
                    ),
                    const SizedBox(height: 16),
                    _buildTextFormField(_phoneController, 'Phone Number', keyboardType: TextInputType.phone),
                    const SizedBox(height: 16),
                    _buildTextFormField(_emailController, 'Email Address', keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 16),
                    _buildTextFormField(_notesController, 'Notes', maxLines: 3),
                    const SizedBox(height: 32),
                    VuetSaveButton(
                      text: isEditMode ? 'Save Changes' : 'Add Member',
                      onPressed: _isLoading ? () {} : () => _saveForm(), // Ensure non-null VoidCallback
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextFormField(
    TextEditingController controller,
    String label, {
    bool isRequired = false,
    int? maxLines = 1,
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
    IconData? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label + (isRequired ? ' *' : ''),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.mediumTurquoise, width: 2.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        suffixIcon: suffixIcon != null ? IconButton(icon: Icon(suffixIcon), onPressed: onTap) : null,
      ),
      validator: isRequired
          ? (value) {
              if (value == null || value.trim().isEmpty) {
                return '$label is required';
              }
              return null;
            }
          : null,
      maxLines: maxLines,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
    );
  }
}
