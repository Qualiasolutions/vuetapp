import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/theme_config.dart';
import '../../../ui/shared/widgets.dart';
import '../../../models/pet_entities.dart';
import 'package:go_router/go_router.dart';

class PetFormScreen extends ConsumerStatefulWidget {
  final Pet? pet; // null for create, Pet instance for edit
  
  const PetFormScreen({super.key, this.pet});

  @override
  ConsumerState<PetFormScreen> createState() => _PetFormScreenState();
}

class _PetFormScreenState extends ConsumerState<PetFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for all Pet fields as specified in detailed guide
  late final TextEditingController _nameController;
  late final TextEditingController _typeController;
  late final TextEditingController _breedController;
  late final TextEditingController _dobController;
  late final TextEditingController _microchipNumberController;
  late final TextEditingController _notesController;

  // Pet type options
  final List<String> _petTypes = [
    'Dog',
    'Cat',
    'Bird',
    'Fish',
    'Rabbit',
    'Hamster',
    'Guinea Pig',
    'Reptile',
    'Other'
  ];

  String? _selectedPetType;

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers with existing data if editing
    final pet = widget.pet;
    _nameController = TextEditingController(text: pet?.name ?? '');
    _typeController = TextEditingController(text: pet?.type ?? '');
    _breedController = TextEditingController(text: pet?.breed ?? '');
    _dobController = TextEditingController(
      text: pet?.dob?.toIso8601String().split('T')[0] ?? ''
    );
    _microchipNumberController = TextEditingController(text: pet?.microchipNumber ?? '');
    _notesController = TextEditingController(text: pet?.notes ?? '');
    
    // Set selected pet type
    _selectedPetType = pet?.type;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _breedController.dispose();
    _dobController.dispose();
    _microchipNumberController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.pet != null;
    
    return Scaffold(
      appBar: VuetHeader(isEditing ? 'Edit Pet' : 'Add Pet'),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Pet form layout as specified in detailed guide
            VuetTextField(
              'Pet name',
              controller: _nameController,
              validator: PetValidators.required,
            ),
            const SizedBox(height: 16),
            
            // Pet type dropdown
            DropdownButtonFormField<String>(
              value: _selectedPetType,
              decoration: InputDecoration(
                labelText: 'Pet type',
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
              items: _petTypes.map((type) => DropdownMenuItem(
                value: type,
                child: Text(type),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPetType = value;
                  _typeController.text = value ?? '';
                });
              },
              validator: (value) => value == null ? 'Please select a pet type' : null,
            ),
            const SizedBox(height: 16),
            
            VuetTextField(
              'Breed (optional)',
              controller: _breedController,
              validator: (value) => null, // Optional field
            ),
            const SizedBox(height: 16),
            
            VuetDatePicker(
              'Date of birth (YYYY-MM-DD)',
              controller: _dobController,
              validator: PetValidators.optionalDate,
            ),
            const SizedBox(height: 16),
            
            VuetTextField(
              'Microchip number (optional)',
              controller: _microchipNumberController,
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
              text: isEditing ? 'Update Pet' : 'Save Pet',
              onPressed: _savePet,
            ),
          ],
        ),
      ),
    );
  }

  void _savePet() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      // Parse optional date
      DateTime? parseDate(String text) {
        if (text.trim().isEmpty) return null;
        return DateTime.tryParse(text);
      }

      final pet = Pet(
        id: widget.pet?.id,
        name: _nameController.text.trim(),
        type: _selectedPetType!,
        breed: _breedController.text.trim().isEmpty ? null : _breedController.text.trim(),
        dob: parseDate(_dobController.text),
        microchipNumber: _microchipNumberController.text.trim().isEmpty ? null : _microchipNumberController.text.trim(),
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );

      // TODO: Save to Supabase using MCP tools
      // For now, just show success and navigate back
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.pet != null ? 'Pet updated successfully!' : 'Pet created successfully!'),
            backgroundColor: AppColors.mediumTurquoise,
          ),
        );
        
        // Navigate back to pet list
        context.go('/categories/pets/pets');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving pet: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
