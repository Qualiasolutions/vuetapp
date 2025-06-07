import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../models/transport_entities.dart';
import '../../../ui/shared/widgets.dart'; // For VuetTextField, VuetDatePicker etc.
import '../../../config/theme_config.dart'; // For AppColors if needed directly
import '../../../providers/transport_providers.dart'; // Added import

class RentalCarFormScreen extends ConsumerStatefulWidget {
  final RentalCar? rentalCar; // null for create, instance for edit

  const RentalCarFormScreen({super.key, this.rentalCar});

  @override
  ConsumerState<RentalCarFormScreen> createState() => _RentalCarFormScreenState();
}

class _RentalCarFormScreenState extends ConsumerState<RentalCarFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for RentalCar fields
  late final TextEditingController _nameController;
  late final TextEditingController _rentalCompanyController;
  late final TextEditingController _makeController;
  late final TextEditingController _modelController;
  late final TextEditingController _registrationController;
  late final TextEditingController _pickupDateController;
  late final TextEditingController _returnDateController;
  late final TextEditingController _pickupLocationController;
  late final TextEditingController _returnLocationController;
  late final TextEditingController _totalCostController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    final rentalCar = widget.rentalCar;
    _nameController = TextEditingController(text: rentalCar?.name ?? '');
    _rentalCompanyController = TextEditingController(text: rentalCar?.rentalCompany ?? '');
    _makeController = TextEditingController(text: rentalCar?.make ?? '');
    _modelController = TextEditingController(text: rentalCar?.model ?? '');
    _registrationController = TextEditingController(text: rentalCar?.registration ?? '');
    _pickupDateController = TextEditingController(
        text: rentalCar?.pickupDate?.toIso8601String().split('T')[0] ?? '');
    _returnDateController = TextEditingController(
        text: rentalCar?.returnDate?.toIso8601String().split('T')[0] ?? '');
    _pickupLocationController = TextEditingController(text: rentalCar?.pickupLocation ?? '');
    _returnLocationController = TextEditingController(text: rentalCar?.returnLocation ?? '');
    _totalCostController = TextEditingController(text: rentalCar?.totalCost?.toString() ?? '');
    _notesController = TextEditingController(text: rentalCar?.notes ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _rentalCompanyController.dispose();
    _makeController.dispose();
    _modelController.dispose();
    _registrationController.dispose();
    _pickupDateController.dispose();
    _returnDateController.dispose();
    _pickupLocationController.dispose();
    _returnLocationController.dispose();
    _totalCostController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.rentalCar != null;

    return Scaffold(
      appBar: VuetHeader(isEditing ? 'Edit Rental Car' : 'Add Rental Car'),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            VuetTextField(
              'Name (e.g., Holiday Rental)',
              controller: _nameController,
              validator: TransportValidators.required,
            ),
            const SizedBox(height: 16),
            VuetTextField(
              'Rental Company',
              controller: _rentalCompanyController,
              validator: TransportValidators.required,
            ),
            const SizedBox(height: 16),
            VuetTextField(
              'Make (optional)',
              controller: _makeController,
              validator: (value) => null, // Optional
            ),
            const SizedBox(height: 16),
            VuetTextField(
              'Model (optional)',
              controller: _modelController,
              validator: (value) => null, // Optional
            ),
            const SizedBox(height: 16),
            VuetTextField(
              'Registration (optional)',
              controller: _registrationController,
              validator: (value) => null, // Optional
            ),
            const SizedBox(height: 16),
            VuetDatePicker(
              'Pickup Date (YYYY-MM-DD)',
              controller: _pickupDateController,
              validator: TransportValidators.optionalDate,
            ),
            const SizedBox(height: 16),
            VuetDatePicker(
              'Return Date (YYYY-MM-DD)',
              controller: _returnDateController,
              validator: TransportValidators.optionalDate,
            ),
            const SizedBox(height: 16),
            VuetTextField(
              'Pickup Location (optional)',
              controller: _pickupLocationController,
              validator: (value) => null, // Optional
            ),
            const SizedBox(height: 16),
            VuetTextField(
              'Return Location (optional)',
              controller: _returnLocationController,
              validator: (value) => null, // Optional
            ),
            const SizedBox(height: 16),
            VuetTextField(
              'Total Cost (optional)',
              controller: _totalCostController,
              validator: (value) { // Optional, but if provided, must be a number
                if (value == null || value.trim().isEmpty) return null;
                if (double.tryParse(value) == null) return 'Must be a valid number';
                if (double.parse(value) < 0) return 'Cannot be negative';
                return null;
              },
              type: TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            VuetTextField(
              'Notes (optional)',
              controller: _notesController,
              validator: (value) => null, // Optional
            ),
            const VuetDivider(),
            VuetSaveButton(
              text: isEditing ? 'Update Rental Car' : 'Save Rental Car',
              onPressed: _saveRentalCar,
            ),
          ],
        ),
      ),
    );
  }

  void _saveRentalCar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      DateTime? parseDate(String text) {
        if (text.trim().isEmpty) return null;
        return DateTime.tryParse(text);
      }

      double? parseDouble(String text) {
        if (text.trim().isEmpty) return null;
        return double.tryParse(text);
      }

      final rentalCar = RentalCar(
        id: widget.rentalCar?.id, // Keep existing ID if editing
        name: _nameController.text.trim(),
        rentalCompany: _rentalCompanyController.text.trim(),
        make: _makeController.text.trim().isEmpty ? null : _makeController.text.trim(),
        model: _modelController.text.trim().isEmpty ? null : _modelController.text.trim(),
        registration: _registrationController.text.trim().isEmpty ? null : _registrationController.text.trim(),
        pickupDate: parseDate(_pickupDateController.text),
        returnDate: parseDate(_returnDateController.text),
        pickupLocation: _pickupLocationController.text.trim().isEmpty ? null : _pickupLocationController.text.trim(),
        returnLocation: _returnLocationController.text.trim().isEmpty ? null : _returnLocationController.text.trim(),
        totalCost: parseDouble(_totalCostController.text),
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );

      // TODO: Save to Supabase using MCP tools / Riverpod provider
      await ref.read(rentalCarRepositoryProvider).saveRentalCar(rentalCar);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.rentalCar != null ? 'Rental Car updated!' : 'Rental Car created!'),
            backgroundColor: AppColors.mediumTurquoise, // Or your success color
          ),
        );
        // Navigate back to the list screen (assuming a route like this exists)
        context.go('/categories/transport/rental_cars');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving rental car: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
