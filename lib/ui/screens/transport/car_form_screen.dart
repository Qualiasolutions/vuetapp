import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/theme_config.dart';
import '../../../ui/shared/widgets.dart';
import '../../../models/transport_entities.dart';
import 'package:go_router/go_router.dart';

class CarFormScreen extends ConsumerStatefulWidget {
  final Car? car; // null for create, Car instance for edit
  
  const CarFormScreen({super.key, this.car});

  @override
  ConsumerState<CarFormScreen> createState() => _CarFormScreenState();
}

class _CarFormScreenState extends ConsumerState<CarFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for all Car fields as specified in detailed guide
  late final TextEditingController _nameController;
  late final TextEditingController _makeController;
  late final TextEditingController _modelController;
  late final TextEditingController _registrationController;
  late final TextEditingController _motDueDateController;
  late final TextEditingController _insuranceDueDateController;
  late final TextEditingController _serviceDueDateController;
  late final TextEditingController _taxDueDateController;
  late final TextEditingController _warrantyDueDateController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers with existing data if editing
    final car = widget.car;
    _nameController = TextEditingController(text: car?.name ?? '');
    _makeController = TextEditingController(text: car?.make ?? '');
    _modelController = TextEditingController(text: car?.model ?? '');
    _registrationController = TextEditingController(text: car?.registration ?? '');
    _motDueDateController = TextEditingController(
      text: car?.motDueDate?.toIso8601String().split('T')[0] ?? ''
    );
    _insuranceDueDateController = TextEditingController(
      text: car?.insuranceDueDate?.toIso8601String().split('T')[0] ?? ''
    );
    _serviceDueDateController = TextEditingController(
      text: car?.serviceDueDate?.toIso8601String().split('T')[0] ?? ''
    );
    _taxDueDateController = TextEditingController(
      text: car?.taxDueDate?.toIso8601String().split('T')[0] ?? ''
    );
    _warrantyDueDateController = TextEditingController(
      text: car?.warrantyDueDate?.toIso8601String().split('T')[0] ?? ''
    );
    _notesController = TextEditingController(text: car?.notes ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _makeController.dispose();
    _modelController.dispose();
    _registrationController.dispose();
    _motDueDateController.dispose();
    _insuranceDueDateController.dispose();
    _serviceDueDateController.dispose();
    _taxDueDateController.dispose();
    _warrantyDueDateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.car != null;
    
    return Scaffold(
      appBar: VuetHeader(isEditing ? 'Edit Car' : 'Add Car'),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Car form layout as specified in detailed guide
            VuetTextField(
              'Friendly name',
              controller: _nameController,
              validator: TransportValidators.required,
            ),
            const SizedBox(height: 16),
            
            VuetTextField(
              'Make',
              controller: _makeController,
              validator: TransportValidators.required,
            ),
            const SizedBox(height: 16),
            
            VuetTextField(
              'Model',
              controller: _modelController,
              validator: TransportValidators.required,
            ),
            const SizedBox(height: 16),
            
            VuetTextField(
              'Registration',
              controller: _registrationController,
              validator: TransportValidators.required,
            ),
            const SizedBox(height: 16),
            
            // Date fields for hidden tags (MOT, Insurance, etc.)
            VuetDatePicker(
              'MOT Due Date (YYYY-MM-DD)',
              controller: _motDueDateController,
              validator: TransportValidators.optionalDate,
            ),
            const SizedBox(height: 16),
            
            VuetDatePicker(
              'Insurance Due Date (YYYY-MM-DD)',
              controller: _insuranceDueDateController,
              validator: TransportValidators.optionalDate,
            ),
            const SizedBox(height: 16),
            
            VuetDatePicker(
              'Service Due Date (YYYY-MM-DD)',
              controller: _serviceDueDateController,
              validator: TransportValidators.optionalDate,
            ),
            const SizedBox(height: 16),
            
            VuetDatePicker(
              'Tax Due Date (YYYY-MM-DD)',
              controller: _taxDueDateController,
              validator: TransportValidators.optionalDate,
            ),
            const SizedBox(height: 16),
            
            VuetDatePicker(
              'Warranty Due Date (YYYY-MM-DD)',
              controller: _warrantyDueDateController,
              validator: TransportValidators.optionalDate,
            ),
            const SizedBox(height: 16),
            
            VuetTextField(
              'Notes (optional)',
              controller: _notesController,
              validator: (value) => null, // Optional field
            ),
            
            // Divider as specified in guide
            const VuetDivider(),
            
            // Save button with Modern Palette styling
            VuetSaveButton(
              text: isEditing ? 'Update Car' : 'Save Car',
              onPressed: _saveCar,
            ),
          ],
        ),
      ),
    );
  }

  void _saveCar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      // Parse optional dates
      DateTime? parseDate(String text) {
        if (text.trim().isEmpty) return null;
        return DateTime.tryParse(text);
      }

      final car = Car(
        id: widget.car?.id,
        name: _nameController.text.trim(),
        make: _makeController.text.trim(),
        model: _modelController.text.trim(),
        registration: _registrationController.text.trim(),
        motDueDate: parseDate(_motDueDateController.text),
        insuranceDueDate: parseDate(_insuranceDueDateController.text),
        serviceDueDate: parseDate(_serviceDueDateController.text),
        taxDueDate: parseDate(_taxDueDateController.text),
        warrantyDueDate: parseDate(_warrantyDueDateController.text),
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );

      // TODO: Save to Supabase using MCP tools
      // For now, just show success and navigate back
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.car != null ? 'Car updated successfully!' : 'Car created successfully!'),
            backgroundColor: AppColors.mediumTurquoise,
          ),
        );
        
        // Navigate back to car list
        context.go('/categories/transport/cars');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving car: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
