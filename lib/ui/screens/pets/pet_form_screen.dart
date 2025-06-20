import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:vuet_app/models/pets_model.dart';
import 'package:vuet_app/providers/pets_providers.dart';
import 'package:vuet_app/services/auth_service.dart';
import 'package:vuet_app/ui/shared/widgets.dart'; // For VuetValidators and VuetTextField
import 'package:vuet_app/utils/logger.dart';

class PetFormScreen extends ConsumerStatefulWidget {
  final String? petId; // Nullable for create mode

  const PetFormScreen({super.key, this.petId});

  @override
  ConsumerState<PetFormScreen> createState() => _PetFormScreenState();
}

class _PetFormScreenState extends ConsumerState<PetFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _vaccinationDueController = TextEditingController();
  PetSpecies? _selectedSpecies;
  DateTime? _selectedDob;
  DateTime? _selectedVaccinationDue;

  bool _isLoading = false;
  Pet? _editingPet;

  @override
  void initState() {
    super.initState();
    if (widget.petId != null) {
      _loadPetData();
    }
  }

  Future<void> _loadPetData() async {
    setState(() => _isLoading = true);
    try {
      final pet = await ref.read(petByIdProvider(widget.petId!).future);
      if (pet != null) {
        _editingPet = pet;
        _nameController.text = pet.name;
        _selectedSpecies = pet.species;
        if (pet.dob != null) {
          _selectedDob = pet.dob;
          _dobController.text = DateFormat('yyyy-MM-dd').format(pet.dob!);
        }
        if (pet.vaccinationDue != null) {
          _selectedVaccinationDue = pet.vaccinationDue;
          _vaccinationDueController.text = DateFormat('yyyy-MM-dd').format(pet.vaccinationDue!);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pet not found.')),
          );
          context.pop();
        }
      }
    } catch (e, s) {
      log('Error loading pet data: $e', name: 'PetFormScreen', error: e, stackTrace: s);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading pet: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller, Function(DateTime) onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      onDateSelected(picked);
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> _savePet() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final userId = ref.read(authServiceProvider).currentUser?.id;
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated. Cannot save pet.')),
        );
        setState(() => _isLoading = false);
        return;
      }

      try {
        final petsRepository = ref.read(petsRepositoryProvider);
        if (_editingPet == null) { // Create mode
          final newPet = Pet(
            id: '', // Will be generated by Supabase or backend
            userId: userId,
            name: _nameController.text,
            species: _selectedSpecies,
            dob: _selectedDob,
            vaccinationDue: _selectedVaccinationDue,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          await petsRepository.createPet(newPet);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Pet created successfully!')),
            );
          }
        } else { // Edit mode
          final updatedPet = _editingPet!.copyWith(
            name: _nameController.text,
            species: _selectedSpecies,
            dob: _selectedDob,
            vaccinationDue: _selectedVaccinationDue,
            updatedAt: DateTime.now(),
          );
          await petsRepository.updatePet(updatedPet);
           if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Pet updated successfully!')),
            );
          }
        }
        // Invalidate providers to refresh lists
        ref.invalidate(petsByUserIdProvider(userId));
        if (_editingPet != null) {
          ref.invalidate(petByIdProvider(_editingPet!.id));
        }
        if (mounted) context.pop();
      } catch (e, s) {
        log('Error saving pet: $e', name: 'PetFormScreen', error: e, stackTrace: s);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save pet: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _vaccinationDueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VuetHeader(widget.petId == null ? 'Add New Pet' : 'Edit Pet'),
      body: _isLoading && widget.petId != null // Show loader only when editing and loading initial data
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    VuetTextField(
                      'Pet Name',
                      controller: _nameController,
                      validator: VuetValidators.required, // Uses default "Required" message
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<PetSpecies>(
                      decoration: const InputDecoration(
                        labelText: 'Species',
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedSpecies,
                      items: PetSpecies.values.map((PetSpecies species) {
                        return DropdownMenuItem<PetSpecies>(
                          value: species,
                          child: Text(species.toString().split('.').last),
                        );
                      }).toList(),
                      onChanged: (PetSpecies? newValue) {
                        setState(() {
                          _selectedSpecies = newValue;
                        });
                      },
                      // No validator needed if optional, or add one if required
                    ),
                    const SizedBox(height: 16),
                    VuetTextField(
                      'Date of Birth (Optional)',
                      controller: _dobController,
                      readOnly: true,
                      onTap: () => _selectDate(context, _dobController, (date) => setState(() => _selectedDob = date)),
                      validator: (value) => null, // Optional field
                    ),
                    const SizedBox(height: 16),
                    VuetTextField(
                      'Vaccination Due Date (Optional)',
                      controller: _vaccinationDueController,
                      readOnly: true,
                      onTap: () => _selectDate(context, _vaccinationDueController, (date) => setState(() => _selectedVaccinationDue = date)),
                      validator: VuetValidators.dateIso, // Uses default "yyyy-MM-dd" message, handles empty
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _savePet,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isLoading
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Text('Save Pet', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
