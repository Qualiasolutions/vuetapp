import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme_config.dart';
import '../../models/family_entities.dart';
import '../shared/widgets.dart';

/// Patient Form Screen - Create/Edit Patient entities
/// Following detailed guide: first_name, last_name, medical_number, notes fields
class PatientFormScreen extends StatefulWidget {
  const PatientFormScreen({
    super.key,
    this.patient,
    this.isEditing = false,
  });

  final Patient? patient;
  final bool isEditing;

  @override
  State<PatientFormScreen> createState() => _PatientFormScreenState();
}

class _PatientFormScreenState extends State<PatientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _medicalNumberController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.patient != null) {
      _firstNameController.text = widget.patient!.firstName;
      _lastNameController.text = widget.patient!.lastName;
      _medicalNumberController.text = widget.patient!.medicalNumber ?? '';
      _notesController.text = widget.patient!.notes ?? '';
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _medicalNumberController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VuetHeader(widget.isEditing ? 'Edit Patient' : 'Add Patient'),
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
            
            // Medical Number field - optional
            VuetTextField(
              'Medical Number (Optional)',
              controller: _medicalNumberController,
              validator: (value) => null, // Optional field, no validation
              type: TextInputType.text,
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
              onPressed: _savePatient,
            ),
          ],
        ),
      ),
    );
  }

  void _savePatient() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final patient = Patient(
        id: widget.patient?.id,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        medicalNumber: _medicalNumberController.text.trim().isEmpty 
            ? null 
            : _medicalNumberController.text.trim(),
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
                ? 'Patient updated successfully' 
                : 'Patient created successfully',
            ),
            backgroundColor: AppColors.mediumTurquoise,
          ),
        );
        
        // Navigate back to patients list
        context.go('/categories/family/patients');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving patient: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
