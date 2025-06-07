import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/social_interest_models.dart';
import 'package:vuet_app/providers/auth_providers.dart';
import 'package:vuet_app/providers/social_interest_providers.dart';
import 'package:vuet_app/ui/shared/widgets.dart';
import 'package:intl/intl.dart'; // For date/time formatting

class SocialPlanFormScreen extends ConsumerStatefulWidget {
  final String? socialPlanId;
  const SocialPlanFormScreen({super.key, this.socialPlanId});

  @override
  ConsumerState<SocialPlanFormScreen> createState() => _SocialPlanFormScreenState();
}

class _SocialPlanFormScreenState extends ConsumerState<SocialPlanFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late TextEditingController _statusController;
  // For with_contacts, we might use a simple text field for now, or a more complex widget later
  late TextEditingController _withContactsController; 

  DateTime? _planDate;
  TimeOfDay? _planTime;

  bool _isLoading = false;
  SocialPlan? _editingSocialPlan;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _locationController = TextEditingController();
    _statusController = TextEditingController(text: 'planned'); // Default status
    _withContactsController = TextEditingController();

    if (widget.socialPlanId != null) {
      _loadSocialPlanData();
    }
  }

  Future<void> _loadSocialPlanData() async {
    setState(() => _isLoading = true);
    try {
      _editingSocialPlan = await ref.read(socialPlanByIdProvider(widget.socialPlanId!).future);
      if (_editingSocialPlan != null) {
        _titleController.text = _editingSocialPlan!.title;
        _descriptionController.text = _editingSocialPlan!.description ?? '';
        _locationController.text = _editingSocialPlan!.location ?? '';
        _statusController.text = _editingSocialPlan!.status ?? 'planned';
        _withContactsController.text = _editingSocialPlan!.withContacts?.toString() ?? ''; // Simple display for now
        _planDate = _editingSocialPlan!.planDate;
        if (_editingSocialPlan!.planTime != null) {
          try {
            final timeParts = _editingSocialPlan!.planTime!.split(':');
            _planTime = TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
          } catch (e) {
            // Handle parsing error if necessary
            print('Error parsing plan time: $e');
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading social plan: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _statusController.dispose();
    _withContactsController.dispose();
    super.dispose();
  }

  Future<void> _selectPlanDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _planDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _planDate) {
      setState(() {
        _planDate = picked;
      });
    }
  }

  Future<void> _selectPlanTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _planTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _planTime) {
      setState(() {
        _planTime = picked;
      });
    }
  }
  
  String _formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    return DateFormat.Hm().format(dt); // HH:mm
  }

  Future<void> _saveSocialPlan() async {
    if (_formKey.currentState!.validate()) {
      if (_planDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a plan date.')),
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
        final planTimeString = _planTime != null ? _formatTimeOfDay(_planTime!) : null;

        if (_editingSocialPlan == null) { // Create new
          final newSocialPlan = SocialPlan(
            id: '', 
            userId: userId,
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
            planDate: _planDate!,
            planTime: planTimeString,
            location: _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
            status: _statusController.text.trim().isEmpty ? 'planned' : _statusController.text.trim(),
            withContacts: _withContactsController.text.trim().isEmpty ? null : _withContactsController.text.trim(), // Simple text for now
            createdAt: now,
            updatedAt: now,
          );
          await ref.read(socialPlanRepositoryProvider).createSocialPlan(newSocialPlan);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Social plan created successfully!')),
          );
        } else { // Update existing
          final updatedSocialPlan = _editingSocialPlan!.copyWith(
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
            planDate: _planDate!,
            planTime: planTimeString,
            location: _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
            status: _statusController.text.trim().isEmpty ? 'planned' : _statusController.text.trim(),
            withContacts: _withContactsController.text.trim().isEmpty ? null : _withContactsController.text.trim(),
            updatedAt: now,
          );
          await ref.read(socialPlanRepositoryProvider).updateSocialPlan(updatedSocialPlan);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Social plan updated successfully!')),
          );
        }
        ref.invalidate(userSocialPlansProvider);
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving social plan: $e')),
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
      appBar: VuetHeader(widget.socialPlanId == null ? 'Add Social Plan' : 'Edit Social Plan'),
      body: _isLoading && widget.socialPlanId != null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    VuetTextField(
                      'Title*',
                      controller: _titleController,
                      validator: VuetValidators.required,
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: Text(_planDate == null
                          ? 'Plan Date*'
                          : 'Date: ${MaterialLocalizations.of(context).formatShortDate(_planDate!)}'),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () => _selectPlanDate(context),
                    ),
                    const SizedBox(height: 16),
                     ListTile(
                      title: Text(_planTime == null 
                          ? 'Plan Time (optional)' 
                          : 'Time: ${_planTime!.format(context)}'),
                      trailing: const Icon(Icons.access_time),
                      onTap: () => _selectPlanTime(context),
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
                      'Location (optional)',
                      controller: _locationController,
                      validator: (value) => null,
                    ),
                     const SizedBox(height: 16),
                    VuetTextField( // Consider a DropdownButtonFormField for status
                      'Status (e.g., planned, confirmed)',
                      controller: _statusController,
                      validator: (value) => null,
                    ),
                    const SizedBox(height: 16),
                    VuetTextField( 
                      'With (Contacts/People - optional)',
                      controller: _withContactsController,
                      validator: (value) => null,
                    ),
                    const SizedBox(height: 24),
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : VuetSaveButton(onPressed: _saveSocialPlan),
                  ],
                ),
              ),
            ),
    );
  }
}
