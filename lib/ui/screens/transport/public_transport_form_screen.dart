import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/theme_config.dart';
import '../../../ui/shared/widgets.dart';
import '../../../models/transport_entities.dart';
import '../../../providers/transport_providers.dart'; // Added import
import 'package:go_router/go_router.dart';

class PublicTransportFormScreen extends ConsumerStatefulWidget {
  final PublicTransport? transport; // null for create, PublicTransport instance for edit
  
  const PublicTransportFormScreen({super.key, this.transport});

  @override
  ConsumerState<PublicTransportFormScreen> createState() => _PublicTransportFormScreenState();
}

class _PublicTransportFormScreenState extends ConsumerState<PublicTransportFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for all PublicTransport fields
  late final TextEditingController _nameController;
  late final TextEditingController _transportTypeController;
  late final TextEditingController _routeNumberController;
  late final TextEditingController _operatorController;
  late final TextEditingController _notesController;

  // Transport type options
  final List<String> _transportTypes = [
    'Bus',
    'Metro',
    'Tram',
    'Subway',
    'Light Rail',
    'Trolley',
    'Other',
  ];

  String? _selectedTransportType;

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers with existing data if editing
    final transport = widget.transport;
    _nameController = TextEditingController(text: transport?.name ?? '');
    _transportTypeController = TextEditingController(text: transport?.transportType ?? '');
    _routeNumberController = TextEditingController(text: transport?.routeNumber ?? '');
    _operatorController = TextEditingController(text: transport?.operator ?? '');
    _notesController = TextEditingController(text: transport?.notes ?? '');
    
    _selectedTransportType = transport?.transportType;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _transportTypeController.dispose();
    _routeNumberController.dispose();
    _operatorController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.transport != null;
    
    return Scaffold(
      appBar: VuetHeader(isEditing ? 'Edit Public Transport' : 'Add Public Transport'),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Public Transport form layout following Modern Palette guide
            VuetTextField(
              'Name',
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
              'Route Number (optional)',
              controller: _routeNumberController,
              validator: (value) => null, // Optional field
            ),
            const SizedBox(height: 16),
            
            VuetTextField(
              'Operator (optional)',
              controller: _operatorController,
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
              text: isEditing ? 'Update Public Transport' : 'Save Public Transport',
              onPressed: _saveTransport,
            ),
          ],
        ),
      ),
    );
  }

  void _saveTransport() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final transport = PublicTransport(
        id: widget.transport?.id,
        name: _nameController.text.trim(),
        transportType: _selectedTransportType!,
        routeNumber: _routeNumberController.text.trim().isEmpty ? null : _routeNumberController.text.trim(),
        operator: _operatorController.text.trim().isEmpty ? null : _operatorController.text.trim(),
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );

      await ref.read(publicTransportRepositoryProvider).savePublicTransport(transport);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.transport != null ? 'Public transport updated successfully!' : 'Public transport created successfully!'),
            backgroundColor: AppColors.mediumTurquoise,
          ),
        );
        
        // Navigate back to public transport list
        context.go('/categories/transport/public');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving public transport: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
