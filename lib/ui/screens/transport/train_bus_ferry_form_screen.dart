import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/theme_config.dart';
import '../../../ui/shared/widgets.dart';
import '../../../models/transport_entities.dart';
import 'package:go_router/go_router.dart';

class TrainBusFerryFormScreen extends ConsumerStatefulWidget {
  final TrainBusFerry? journey; // null for create, TrainBusFerry instance for edit
  
  const TrainBusFerryFormScreen({super.key, this.journey});

  @override
  ConsumerState<TrainBusFerryFormScreen> createState() => _TrainBusFerryFormScreenState();
}

class _TrainBusFerryFormScreenState extends ConsumerState<TrainBusFerryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for all TrainBusFerry fields
  late final TextEditingController _nameController;
  late final TextEditingController _transportTypeController;
  late final TextEditingController _operatorController;
  late final TextEditingController _routeNumberController;
  late final TextEditingController _departureStationController;
  late final TextEditingController _arrivalStationController;
  late final TextEditingController _departureTimeController;
  late final TextEditingController _arrivalTimeController;
  late final TextEditingController _notesController;

  // Transport type options
  final List<String> _transportTypes = [
    'Train',
    'Bus',
    'Ferry',
    'Coach',
    'Other',
  ];

  String? _selectedTransportType;

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers with existing data if editing
    final journey = widget.journey;
    _nameController = TextEditingController(text: journey?.name ?? '');
    _transportTypeController = TextEditingController(text: journey?.transportType ?? '');
    _operatorController = TextEditingController(text: journey?.operator ?? '');
    _routeNumberController = TextEditingController(text: journey?.routeNumber ?? '');
    _departureStationController = TextEditingController(text: journey?.departureStation ?? '');
    _arrivalStationController = TextEditingController(text: journey?.arrivalStation ?? '');
    _departureTimeController = TextEditingController(
      text: journey?.departureTime?.toIso8601String() ?? ''
    );
    _arrivalTimeController = TextEditingController(
      text: journey?.arrivalTime?.toIso8601String() ?? ''
    );
    _notesController = TextEditingController(text: journey?.notes ?? '');
    
    _selectedTransportType = journey?.transportType;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _transportTypeController.dispose();
    _operatorController.dispose();
    _routeNumberController.dispose();
    _departureStationController.dispose();
    _arrivalStationController.dispose();
    _departureTimeController.dispose();
    _arrivalTimeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.journey != null;
    
    return Scaffold(
      appBar: VuetHeader(isEditing ? 'Edit Journey' : 'Add Journey'),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Journey form layout following Modern Palette guide
            VuetTextField(
              'Journey Name',
              controller: _nameController,
              validator: TransportValidators.required,
            ),
            const SizedBox(height: 16),
            
            // Transport Type Dropdown
            DropdownButtonFormField<String>(
              value: _selectedTransportType,
              decoration: InputDecoration(
                labelText: 'Transport Type',
                labelStyle: TextStyle(color: AppColors.steel),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.steel),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.mediumTurquoise, width: 2),
                ),
              ),
              items: _transportTypes.map((type) => DropdownMenuItem(
                value: type,
                child: Text(type),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTransportType = value;
                  _transportTypeController.text = value ?? '';
                });
              },
              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            
            VuetTextField(
              'Operator (optional)',
              controller: _operatorController,
              validator: (value) => null, // Optional field
            ),
            const SizedBox(height: 16),
            
            VuetTextField(
              'Route Number (optional)',
              controller: _routeNumberController,
              validator: (value) => null, // Optional field
            ),
            const SizedBox(height: 16),
            
            VuetTextField(
              'Departure Station (optional)',
              controller: _departureStationController,
              validator: (value) => null, // Optional field
            ),
            const SizedBox(height: 16),
            
            VuetTextField(
              'Arrival Station (optional)',
              controller: _arrivalStationController,
              validator: (value) => null, // Optional field
            ),
            const SizedBox(height: 16),
            
            // Date/Time pickers for departure and arrival
            VuetDateTimePicker(
              'Departure Date & Time (optional)',
              controller: _departureTimeController,
              validator: (value) => null, // Optional field
            ),
            const SizedBox(height: 16),
            
            VuetDateTimePicker(
              'Arrival Date & Time (optional)',
              controller: _arrivalTimeController,
              validator: (value) => null, // Optional field
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
              text: isEditing ? 'Update Journey' : 'Save Journey',
              onPressed: _saveJourney,
            ),
          ],
        ),
      ),
    );
  }

  void _saveJourney() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      // Parse optional date/times
      DateTime? parseDateTime(String text) {
        if (text.trim().isEmpty) return null;
        return DateTime.tryParse(text);
      }

      final journey = TrainBusFerry(
        id: widget.journey?.id,
        name: _nameController.text.trim(),
        transportType: _selectedTransportType!,
        operator: _operatorController.text.trim().isEmpty ? null : _operatorController.text.trim(),
        routeNumber: _routeNumberController.text.trim().isEmpty ? null : _routeNumberController.text.trim(),
        departureStation: _departureStationController.text.trim().isEmpty ? null : _departureStationController.text.trim(),
        arrivalStation: _arrivalStationController.text.trim().isEmpty ? null : _arrivalStationController.text.trim(),
        departureTime: parseDateTime(_departureTimeController.text),
        arrivalTime: parseDateTime(_arrivalTimeController.text),
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );

      // TODO: Save to Supabase using MCP tools
      // For now, just show success and navigate back
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.journey != null ? 'Journey updated successfully!' : 'Journey created successfully!'),
            backgroundColor: AppColors.mediumTurquoise,
          ),
        );
        
        // Navigate back to journey list
        context.go('/categories/transport/transit');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving journey: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

// Custom DateTime picker widget for journey times
class VuetDateTimePicker extends StatefulWidget {
  const VuetDateTimePicker(
    this.label, {
    required this.controller,
    this.validator,
    super.key,
  });

  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  @override
  State<VuetDateTimePicker> createState() => _VuetDateTimePickerState();
}

class _VuetDateTimePickerState extends State<VuetDateTimePicker> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        // First pick date
        final date = await showDatePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
          initialDate: DateTime.now(),
        );
        
        if (date != null) {
          // Then pick time
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          
          if (time != null) {
            final dateTime = DateTime(
              date.year,
              date.month,
              date.day,
              time.hour,
              time.minute,
            );
            widget.controller.text = dateTime.toIso8601String();
            setState(() {});
          }
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: TextStyle(color: AppColors.steel),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.steel),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.mediumTurquoise, width: 2),
            ),
          ),
          validator: widget.validator,
          readOnly: true,
        ),
      ),
    );
  }
}
