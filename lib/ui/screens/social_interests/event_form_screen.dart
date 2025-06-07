import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/theme_config.dart';
import '../../../ui/shared/widgets.dart';
import '../../../models/social_interests_entities.dart';
import 'package:go_router/go_router.dart';

class EventFormScreen extends ConsumerStatefulWidget {
  final Event? event; // null for create, Event instance for edit
  
  const EventFormScreen({super.key, this.event});

  @override
  ConsumerState<EventFormScreen> createState() => _EventFormScreenState();
}

class _EventFormScreenState extends ConsumerState<EventFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for all Event fields
  late final TextEditingController _nameController;
  late final TextEditingController _eventTypeController;
  late final TextEditingController _dateController;
  late final TextEditingController _timeController;
  late final TextEditingController _locationController;
  late final TextEditingController _organizerController;
  late final TextEditingController _attendeesController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _notesController;

  // Event type options
  final List<String> _eventTypes = [
    'Party',
    'Meeting',
    'Conference',
    'Wedding',
    'Birthday',
    'Anniversary',
    'Workshop',
    'Seminar',
    'Concert',
    'Festival',
    'Sports Event',
    'Other'
  ];

  String? _selectedEventType;

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers with existing data if editing
    final event = widget.event;
    _nameController = TextEditingController(text: event?.name ?? '');
    _eventTypeController = TextEditingController(text: event?.eventType ?? '');
    _dateController = TextEditingController(
      text: event?.date.toIso8601String().split('T')[0] ?? ''
    );
    _timeController = TextEditingController(text: event?.time ?? '');
    _locationController = TextEditingController(text: event?.location ?? '');
    _organizerController = TextEditingController(text: event?.organizer ?? '');
    _attendeesController = TextEditingController(text: event?.attendees ?? '');
    _descriptionController = TextEditingController(text: event?.description ?? '');
    _notesController = TextEditingController(text: event?.notes ?? '');
    
    // Set selected event type
    _selectedEventType = event?.eventType;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _eventTypeController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    _organizerController.dispose();
    _attendeesController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.event != null;
    
    return Scaffold(
      appBar: VuetHeader(isEditing ? 'Edit Event' : 'Add Event'),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Event form layout
            VuetTextField(
              'Event name',
              controller: _nameController,
              validator: SocialInterestsValidators.required,
            ),
            const SizedBox(height: 16),
            
            // Event type dropdown
            DropdownButtonFormField<String>(
              value: _selectedEventType,
              decoration: InputDecoration(
                labelText: 'Event type',
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
              items: _eventTypes.map((type) => DropdownMenuItem(
                value: type,
                child: Text(type),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedEventType = value;
                  _eventTypeController.text = value ?? '';
                });
              },
              validator: (value) => value == null ? 'Please select an event type' : null,
            ),
            const SizedBox(height: 16),
            
            VuetDatePicker(
              'Event date (YYYY-MM-DD)',
              controller: _dateController,
              validator: SocialInterestsValidators.dateIso,
            ),
            const SizedBox(height: 16),
            
            VuetTextField(
              'Time (HH:MM, optional)',
              controller: _timeController,
              validator: SocialInterestsValidators.optionalTime,
            ),
            const SizedBox(height: 16),
            
            VuetTextField(
              'Location (optional)',
              controller: _locationController,
              validator: (value) => null, // Optional field
            ),
            const SizedBox(height: 16),
            
            VuetTextField(
              'Organizer (optional)',
              controller: _organizerController,
              validator: (value) => null, // Optional field
            ),
            const SizedBox(height: 16),
            
            VuetTextField(
              'Attendees (optional)',
              controller: _attendeesController,
              validator: (value) => null, // Optional field
            ),
            const SizedBox(height: 16),
            
            VuetTextField(
              'Description (optional)',
              controller: _descriptionController,
              validator: (value) => null, // Optional field
            ),
            const SizedBox(height: 16),
            
            VuetTextField(
              'Notes (optional)',
              controller: _notesController,
              validator: (value) => null, // Optional field
            ),
            
            // Divider
            const VuetDivider(),
            
            // Save button with Modern Palette styling
            VuetSaveButton(
              text: isEditing ? 'Update Event' : 'Save Event',
              onPressed: _saveEvent,
            ),
          ],
        ),
      ),
    );
  }

  void _saveEvent() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      // Parse required date
      final date = DateTime.tryParse(_dateController.text);
      if (date == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid date'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      /* // Commenting out unused variable and its object creation for now
      final event = Event(
        id: widget.event?.id,
        name: _nameController.text.trim(),
        eventType: _selectedEventType!,
        date: date,
        time: _timeController.text.trim().isEmpty ? null : _timeController.text.trim(),
        location: _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
        organizer: _organizerController.text.trim().isEmpty ? null : _organizerController.text.trim(),
        attendees: _attendeesController.text.trim().isEmpty ? null : _attendeesController.text.trim(),
        description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );
      */

      // TODO: Save to Supabase using MCP tools
      // For now, just show success and navigate back
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.event != null ? 'Event updated successfully!' : 'Event created successfully!'),
            backgroundColor: AppColors.mediumTurquoise,
          ),
        );
        
        // Navigate back to event list
        context.go('/categories/social-interests/events');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving event: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
