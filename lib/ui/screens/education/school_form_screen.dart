import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/education_entities.dart';
import 'package:vuet_app/providers/education_providers.dart';
import 'package:vuet_app/ui/shared/widgets.dart'; // VuetHeader, VuetTextField, VuetSaveButton, VuetValidators

class SchoolFormScreen extends ConsumerStatefulWidget {
  final String? schoolId; // Null for new, non-null for editing

  const SchoolFormScreen({super.key, this.schoolId});

  @override
  ConsumerState<SchoolFormScreen> createState() => _SchoolFormScreenState();
}

class _SchoolFormScreenState extends ConsumerState<SchoolFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _websiteController;
  late TextEditingController _notesController;

  School? _initialSchool;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _websiteController = TextEditingController();
    _notesController = TextEditingController();

    if (widget.schoolId != null) {
      _loadSchoolData();
    }
  }

  Future<void> _loadSchoolData() async {
    setState(() => _isLoading = true);
    try {
      _initialSchool = await ref.read(schoolByIdProvider(widget.schoolId!).future);
      if (_initialSchool != null) {
        _nameController.text = _initialSchool!.name;
        _addressController.text = _initialSchool!.address ?? '';
        _phoneController.text = _initialSchool!.phoneNumber ?? '';
        _emailController.text = _initialSchool!.email ?? '';
        _websiteController.text = _initialSchool!.website ?? '';
        _notesController.text = _initialSchool!.notes ?? '';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading school data: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveSchool() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final now = DateTime.now();
        final schoolToSave = School(
          id: _initialSchool?.id ?? '', // Empty for new, will be set by backend/repo
          name: _nameController.text,
          address: _addressController.text,
          phoneNumber: _phoneController.text,
          email: _emailController.text,
          website: _websiteController.text,
          notes: _notesController.text,
          createdAt: _initialSchool?.createdAt ?? now,
          updatedAt: now, // Will be set by backend/repo
          ownerId: _initialSchool?.ownerId, // Will be set by repo if new
          entityType: 'School',
        );

        await ref.read(schoolRepositoryProvider).saveSchool(schoolToSave);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('School saved successfully!')),
        );
        if (mounted) Navigator.of(context).pop(); // Go back after save

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving school: ${e.toString()}')),
        );
      } finally {
         if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VuetHeader(widget.schoolId == null ? 'Add School' : 'Edit School'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (widget.schoolId != null && _isLoading && _initialSchool == null)
                const Center(child: CircularProgressIndicator())
              else ...[
                VuetTextField(
                  'School Name', // Positional hint
                  controller: _nameController,
                  validator: VuetValidators.required, // Pass the function directly
                ),
                const SizedBox(height: 16),
                VuetTextField(
                  'Address',
                  controller: _addressController,
                  validator: (value) => null, // Optional
                ),
                const SizedBox(height: 16),
                VuetTextField(
                  'Phone Number',
                  controller: _phoneController,
                  validator: (value) => null, // Optional
                  type: TextInputType.phone, // Correct named parameter
                ),
                const SizedBox(height: 16),
                VuetTextField(
                  'Email Address',
                  controller: _emailController,
                  validator: VuetValidators.emailOptional, // Pass the function
                  type: TextInputType.emailAddress, // Correct named parameter
                ),
                const SizedBox(height: 16),
                VuetTextField(
                  'Website',
                  controller: _websiteController,
                  validator: (value) => null, // Optional
                  type: TextInputType.url, // Correct named parameter
                ),
                const SizedBox(height: 16),
                VuetTextField(
                  'Notes',
                  controller: _notesController,
                  validator: (value) => null, // Optional
                  minLines: 3,
                  maxLines: 5, // VuetTextField handles type for maxLines internally
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : VuetSaveButton(onPressed: _saveSchool),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
