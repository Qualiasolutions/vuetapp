import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/social_interest_models.dart';
import 'package:vuet_app/providers/auth_providers.dart';
import 'package:vuet_app/providers/social_interest_providers.dart';
import 'package:vuet_app/ui/shared/widgets.dart';
import 'package:intl/intl.dart'; // For date/time formatting

class SocialEventFormScreen extends ConsumerStatefulWidget {
  final String? socialEventId;
  const SocialEventFormScreen({super.key, this.socialEventId});

  @override
  ConsumerState<SocialEventFormScreen> createState() => _SocialEventFormScreenState();
}

class _SocialEventFormScreenState extends ConsumerState<SocialEventFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationNameController;
  late TextEditingController _locationAddressController;
  late TextEditingController _organizerController;
  late TextEditingController _websiteUrlController;

  DateTime? _startDateTime;
  DateTime? _endDateTime;
  bool _isPublic = false;

  bool _isLoading = false;
  SocialEvent? _editingSocialEvent;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _locationNameController = TextEditingController();
    _locationAddressController = TextEditingController();
    _organizerController = TextEditingController();
    _websiteUrlController = TextEditingController();

    if (widget.socialEventId != null) {
      _loadSocialEventData();
    }
  }

  Future<void> _loadSocialEventData() async {
    setState(() => _isLoading = true);
    try {
      _editingSocialEvent = await ref.read(socialEventByIdProvider(widget.socialEventId!).future);
      if (_editingSocialEvent != null) {
        _nameController.text = _editingSocialEvent!.name;
        _descriptionController.text = _editingSocialEvent!.description ?? '';
        _locationNameController.text = _editingSocialEvent!.locationName ?? '';
        _locationAddressController.text = _editingSocialEvent!.locationAddress ?? '';
        _organizerController.text = _editingSocialEvent!.organizer ?? '';
        _websiteUrlController.text = _editingSocialEvent!.websiteUrl ?? '';
        _startDateTime = _editingSocialEvent!.startDatetime;
        _endDateTime = _editingSocialEvent!.endDatetime;
        _isPublic = _editingSocialEvent!.isPublic;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading social event: $e')),
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
    _descriptionController.dispose();
    _locationNameController.dispose();
    _locationAddressController.dispose();
    _organizerController.dispose();
    _websiteUrlController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context, bool isStart) async {
    final initialDate = (isStart ? _startDateTime : _endDateTime) ?? DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );
      if (pickedTime != null) {
        setState(() {
          final selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          if (isStart) {
            _startDateTime = selectedDateTime;
          } else {
            _endDateTime = selectedDateTime;
          }
        });
      }
    }
  }
  
  String _formatDateTime(DateTime? dt) {
    if (dt == null) return 'Not set';
    return DateFormat.yMMMd().add_jm().format(dt); // e.g. Sep 23, 2023, 5:30 PM
  }


  Future<void> _saveSocialEvent() async {
    if (_formKey.currentState!.validate()) {
       if (_startDateTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a start date and time.')),
        );
        return;
      }
      setState(() => _isLoading = true);
      final userId = ref.read(currentUserProvider)?.id;
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated.')),
        );
        setState(() => _isLoading = false);
        return;
      }

      try {
        final now = DateTime.now();
        if (_editingSocialEvent == null) { // Create new
          final newSocialEvent = SocialEvent(
            id: '',
            userId: userId,
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
            startDatetime: _startDateTime!,
            endDatetime: _endDateTime,
            locationName: _locationNameController.text.trim().isEmpty ? null : _locationNameController.text.trim(),
            locationAddress: _locationAddressController.text.trim().isEmpty ? null : _locationAddressController.text.trim(),
            isPublic: _isPublic,
            organizer: _organizerController.text.trim().isEmpty ? null : _organizerController.text.trim(),
            websiteUrl: _websiteUrlController.text.trim().isEmpty ? null : _websiteUrlController.text.trim(),
            createdAt: now,
            updatedAt: now,
          );
          await ref.read(socialEventRepositoryProvider).createSocialEvent(newSocialEvent);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Social event created successfully!')),
          );
        } else { // Update existing
          final updatedSocialEvent = _editingSocialEvent!.copyWith(
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
            startDatetime: _startDateTime!,
            endDatetime: _endDateTime,
            locationName: _locationNameController.text.trim().isEmpty ? null : _locationNameController.text.trim(),
            locationAddress: _locationAddressController.text.trim().isEmpty ? null : _locationAddressController.text.trim(),
            isPublic: _isPublic,
            organizer: _organizerController.text.trim().isEmpty ? null : _organizerController.text.trim(),
            websiteUrl: _websiteUrlController.text.trim().isEmpty ? null : _websiteUrlController.text.trim(),
            updatedAt: now,
          );
          await ref.read(socialEventRepositoryProvider).updateSocialEvent(updatedSocialEvent);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Social event updated successfully!')),
          );
        }
        ref.invalidate(userSocialEventsProvider);
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving social event: $e')),
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
      appBar: VuetHeader(widget.socialEventId == null ? 'Add Social Event' : 'Edit Social Event'),
      body: _isLoading && widget.socialEventId != null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    VuetTextField(
                      'Event Name*',
                      controller: _nameController,
                      validator: VuetValidators.required,
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: Text('Start Date & Time*: ${_formatDateTime(_startDateTime)}'),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () => _selectDateTime(context, true),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: Text('End Date & Time (optional): ${_formatDateTime(_endDateTime)}'),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () => _selectDateTime(context, false),
                    ),
                    const SizedBox(height: 16),
                    VuetTextField(
                      'Description (optional)',
                      controller: _descriptionController,
                      validator: (value) => null,
                      type: TextInputType.multiline,
                    ),
                    const SizedBox(height: 16),
                    VuetTextField(
                      'Location Name (optional)',
                      controller: _locationNameController,
                      validator: (value) => null,
                    ),
                    const SizedBox(height: 16),
                    VuetTextField(
                      'Location Address (optional)',
                      controller: _locationAddressController,
                      validator: (value) => null,
                      type: TextInputType.multiline,
                    ),
                    const SizedBox(height: 16),
                     VuetTextField(
                      'Organizer (optional)',
                      controller: _organizerController,
                      validator: (value) => null,
                    ),
                    const SizedBox(height: 16),
                    VuetTextField(
                      'Website URL (optional)',
                      controller: _websiteUrlController,
                      validator: (value) => null, // Could add URL validator
                      type: TextInputType.url,
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Is Public Event?'),
                      value: _isPublic,
                      onChanged: (bool value) {
                        setState(() {
                          _isPublic = value;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : VuetSaveButton(onPressed: _saveSocialEvent),
                  ],
                ),
              ),
            ),
    );
  }
}
