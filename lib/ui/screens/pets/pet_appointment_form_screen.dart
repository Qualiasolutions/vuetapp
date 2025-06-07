import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:vuet_app/models/pets_model.dart';
import 'package:vuet_app/providers/pets_providers.dart';
import 'package:vuet_app/services/auth_service.dart';
import 'package:vuet_app/ui/shared/widgets.dart';
import 'package:vuet_app/config/theme_config.dart';
import 'package:vuet_app/utils/logger.dart';

class PetAppointmentFormScreen extends ConsumerStatefulWidget {
  final String? appointmentId; // Nullable for create mode
  final String? petId; // Optional: pre-select pet for new appointment

  const PetAppointmentFormScreen({super.key, this.appointmentId, this.petId});

  @override
  ConsumerState<PetAppointmentFormScreen> createState() => _PetAppointmentFormScreenState();
}

class _PetAppointmentFormScreenState extends ConsumerState<PetAppointmentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _startDateTimeController = TextEditingController();
  final _endDateTimeController = TextEditingController();
  final _notesController = TextEditingController();
  final _locationController = TextEditingController();

  Pet? _selectedPet;
  DateTime? _selectedStartDateTime;
  DateTime? _selectedEndDateTime;

  bool _isLoading = false;
  PetAppointment? _editingAppointment;
  List<Pet> _userPets = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    final userId = ref.read(authServiceProvider).currentUser?.id;
    if (userId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User not authenticated.')));
        context.pop();
      }
      setState(() => _isLoading = false);
      return;
    }

    try {
      _userPets = await ref.read(petsByUserIdProvider(userId).future);

      if (widget.appointmentId != null) { // Edit mode
        _editingAppointment = await ref.read(petAppointmentByIdProvider(widget.appointmentId!).future);
        if (_editingAppointment != null) {
          _titleController.text = _editingAppointment!.title;
          _selectedStartDateTime = _editingAppointment!.startDatetime;
          _startDateTimeController.text = DateFormat('yyyy-MM-dd HH:mm').format(_selectedStartDateTime!);
          _selectedEndDateTime = _editingAppointment!.endDatetime;
          _endDateTimeController.text = DateFormat('yyyy-MM-dd HH:mm').format(_selectedEndDateTime!);
          _notesController.text = _editingAppointment!.notes ?? '';
          _locationController.text = _editingAppointment!.location ?? '';
          if (_userPets.any((p) => p.id == _editingAppointment!.petId)) {
            _selectedPet = _userPets.firstWhere((p) => p.id == _editingAppointment!.petId);
          }
        } else {
           if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Appointment not found.')));
            context.pop();
          }
        }
      } else if (widget.petId != null && widget.petId!.isNotEmpty) { // Create mode with pre-selected pet
         if (_userPets.any((p) => p.id == widget.petId)) {
            _selectedPet = _userPets.firstWhere((p) => p.id == widget.petId);
          }
      }
    } catch (e, s) {
      log('Error loading initial data for appointment form: $e', name: 'PetAppointmentFormScreen', error: e, stackTrace: s);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading data: ${e.toString()}')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _selectDateTime(BuildContext context, TextEditingController controller, bool isStart, Function(DateTime) onDateTimeSelected) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: (isStart ? _selectedStartDateTime : _selectedEndDateTime) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && context.mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime((isStart ? _selectedStartDateTime : _selectedEndDateTime) ?? DateTime.now()),
      );

      if (pickedTime != null) {
        final selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        onDateTimeSelected(selectedDateTime);
        controller.text = DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime);
      }
    }
  }

  Future<void> _saveAppointment() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedPet == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a pet.')));
        return;
      }
      if (_selectedStartDateTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a start date and time.')));
        return;
      }
      if (_selectedEndDateTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select an end date and time.')));
        return;
      }
      if (_selectedEndDateTime!.isBefore(_selectedStartDateTime!)) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('End time cannot be before start time.')));
        return;
      }

      setState(() => _isLoading = true);
      final userId = ref.read(authServiceProvider).currentUser?.id;
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User not authenticated.')));
        setState(() => _isLoading = false);
        return;
      }

      try {
        final appointmentsRepository = ref.read(petAppointmentsRepositoryProvider);
        if (_editingAppointment == null) { // Create
          final newAppointment = PetAppointment(
            id: '', // Will be generated by Supabase
            userId: userId,
            petId: _selectedPet!.id,
            title: _titleController.text,
            startDatetime: _selectedStartDateTime!,
            endDatetime: _selectedEndDateTime!,
            notes: _notesController.text.isEmpty ? null : _notesController.text,
            location: _locationController.text.isEmpty ? null : _locationController.text,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          await appointmentsRepository.createPetAppointment(newAppointment);
          if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Appointment created!')));
        } else { // Update
          final updatedAppointment = _editingAppointment!.copyWith(
            petId: _selectedPet!.id,
            title: _titleController.text,
            startDatetime: _selectedStartDateTime!,
            endDatetime: _selectedEndDateTime!,
            notes: _notesController.text.isEmpty ? null : _notesController.text,
            location: _locationController.text.isEmpty ? null : _locationController.text,
            updatedAt: DateTime.now(),
          );
          await appointmentsRepository.updatePetAppointment(updatedAppointment);
          if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Appointment updated!')));
        }
        // Invalidate providers
        ref.invalidate(petAppointmentsByPetIdProvider(_selectedPet!.id));
        ref.invalidate(petAppointmentsByUserIdProvider(userId));
        if (_editingAppointment != null) {
          ref.invalidate(petAppointmentByIdProvider(_editingAppointment!.id));
        }
        if(mounted) context.pop();
      } catch (e, s) {
        log('Error saving appointment: $e', name: 'PetAppointmentFormScreen', error: e, stackTrace: s);
        if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save appointment: ${e.toString()}')));
      } finally {
        if(mounted) setState(() => _isLoading = false);
      }
    }
  }
  
  @override
  void dispose() {
    _titleController.dispose();
    _startDateTimeController.dispose();
    _endDateTimeController.dispose();
    _notesController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VuetHeader(widget.appointmentId == null ? 'Add Pet Appointment' : 'Edit Pet Appointment'),
      body: _isLoading && (_userPets.isEmpty || (widget.appointmentId != null && _editingAppointment == null))
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    if (_userPets.isNotEmpty)
                      DropdownButtonFormField<Pet>(
                        decoration: const InputDecoration(labelText: 'Pet', border: OutlineInputBorder()),
                        value: _selectedPet,
                        items: _userPets.map((Pet pet) {
                          return DropdownMenuItem<Pet>(value: pet, child: Text(pet.name));
                        }).toList(),
                        onChanged: (Pet? newValue) => setState(() => _selectedPet = newValue),
                        validator: (value) => value == null ? 'Please select a pet.' : null,
                      )
                    else if (widget.petId == null || widget.petId!.isEmpty) // Only show if not in edit mode and no petId passed
                      const Text('No pets found. Please add a pet first to create an appointment.', textAlign: TextAlign.center),
                    
                    const SizedBox(height: 16),
                    VuetTextField(
                      'Title',
                      controller: _titleController,
                      validator: VuetValidators.required,
                    ),
                    const SizedBox(height: 16),
                    VuetTextField(
                      'Start Date & Time',
                      controller: _startDateTimeController,
                      readOnly: true,
                      onTap: () => _selectDateTime(context, _startDateTimeController, true, (date) => setState(() => _selectedStartDateTime = date)),
                      validator: VuetValidators.required,
                    ),
                    const SizedBox(height: 16),
                    VuetTextField(
                      'End Date & Time',
                      controller: _endDateTimeController,
                      readOnly: true,
                      onTap: () => _selectDateTime(context, _endDateTimeController, false, (date) => setState(() => _selectedEndDateTime = date)),
                      validator: VuetValidators.required,
                    ),
                    const SizedBox(height: 16),
                    VuetTextField(
                      'Location (Optional)',
                      controller: _locationController,
                      validator: (value) => null,
                    ),
                    const SizedBox(height: 16),
                    VuetTextField(
                      'Notes (Optional)',
                      controller: _notesController,
                      validator: (value) => null,
                      type: TextInputType.multiline,
                      minLines: 3, // Added minLines
                      maxLines: 5, // Added maxLines
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _isLoading || (_userPets.isEmpty && (widget.petId == null || widget.petId!.isEmpty)) ? null : _saveAppointment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isLoading
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Text('Save Appointment', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
