import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme_config.dart';
import '../../models/family_entities.dart';
import '../shared/widgets.dart';

/// Appointment Form Screen - Create/Edit Appointment entities
/// Following detailed guide: title, start_datetime, end_datetime, location, notes, patient_ids fields
class AppointmentFormScreen extends StatefulWidget {
  const AppointmentFormScreen({
    super.key,
    this.appointment,
    this.isEditing = false,
  });

  final Appointment? appointment;
  final bool isEditing;

  @override
  State<AppointmentFormScreen> createState() => _AppointmentFormScreenState();
}

class _AppointmentFormScreenState extends State<AppointmentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _startDateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endDateController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.appointment != null) {
      _titleController.text = widget.appointment!.title;
      _startDateController.text = widget.appointment!.startDatetime.toIso8601String().split('T')[0];
      _startTimeController.text = _formatTime(widget.appointment!.startDatetime);
      _endDateController.text = widget.appointment!.endDatetime.toIso8601String().split('T')[0];
      _endTimeController.text = _formatTime(widget.appointment!.endDatetime);
      _locationController.text = widget.appointment!.location ?? '';
      _notesController.text = widget.appointment!.notes ?? '';
    } else {
      // Set default end time to 1 hour after start time
      final now = DateTime.now();
      final startTime = DateTime(now.year, now.month, now.day, now.hour + 1);
      final endTime = startTime.add(const Duration(hours: 1));
      
      _startDateController.text = startTime.toIso8601String().split('T')[0];
      _startTimeController.text = _formatTime(startTime);
      _endDateController.text = endTime.toIso8601String().split('T')[0];
      _endTimeController.text = _formatTime(endTime);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _startDateController.dispose();
    _startTimeController.dispose();
    _endDateController.dispose();
    _endTimeController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VuetHeader(widget.isEditing ? 'Edit Appointment' : 'Add Appointment'),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title field - required
            VuetTextField(
              'Title',
              controller: _titleController,
              validator: VuetValidators.required,
            ),
            
            const SizedBox(height: 16),
            
            // Start Date and Time
            const Text(
              'Start Date & Time',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.darkJungleGreen,
              ),
            ),
            const SizedBox(height: 8),
            
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: VuetDatePicker(
                    'Start Date',
                    controller: _startDateController,
                    validator: VuetValidators.required,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTimePicker(
                    'Start Time',
                    _startTimeController,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // End Date and Time
            const Text(
              'End Date & Time',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.darkJungleGreen,
              ),
            ),
            const SizedBox(height: 8),
            
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: VuetDatePicker(
                    'End Date',
                    controller: _endDateController,
                    validator: VuetValidators.required,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTimePicker(
                    'End Time',
                    _endTimeController,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Location field - optional
            VuetTextField(
              'Location (Optional)',
              controller: _locationController,
              validator: (value) => null, // Optional field, no validation
            ),
            
            const SizedBox(height: 16),
            
            // Notes field - optional, multiline
            TextFormField(
              controller: _notesController,
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                hintText: 'Notes (Optional)',
                hintStyle: TextStyle(color: AppColors.steel),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.steel),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.mediumTurquoise),
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
              validator: (value) => null, // Optional field, no validation
            ),
            
            // Form divider as specified in guide
            const VuetDivider(),
            
            // Save button with Modern Palette styling
            VuetSaveButton(
              text: widget.isEditing ? 'Update' : 'Save',
              onPressed: _saveAppointment,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker(String hint, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.steel),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.steel),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.mediumTurquoise),
        ),
        suffixIcon: const Icon(Icons.access_time, color: AppColors.steel),
      ),
      validator: VuetValidators.required,
      onTap: () async {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.mediumTurquoise,
                  onPrimary: AppColors.white,
                  surface: AppColors.white,
                  onSurface: AppColors.darkJungleGreen,
                ),
              ),
              child: child!,
            );
          },
        );
        if (time != null) {
          controller.text = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
        }
      },
    );
  }

  void _saveAppointment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      // Parse start datetime
      final startDate = DateTime.parse(_startDateController.text);
      final startTimeParts = _startTimeController.text.split(':');
      final startDateTime = DateTime(
        startDate.year,
        startDate.month,
        startDate.day,
        int.parse(startTimeParts[0]),
        int.parse(startTimeParts[1]),
      );

      // Parse end datetime
      final endDate = DateTime.parse(_endDateController.text);
      final endTimeParts = _endTimeController.text.split(':');
      final endDateTime = DateTime(
        endDate.year,
        endDate.month,
        endDate.day,
        int.parse(endTimeParts[0]),
        int.parse(endTimeParts[1]),
      );

      // Validate that end time is after start time
      if (endDateTime.isBefore(startDateTime)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('End time must be after start time'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      /* // Commenting out unused variable and its object creation for now
      final appointment = Appointment( 
        id: widget.appointment?.id,
        title: _titleController.text.trim(),
        startDatetime: startDateTime,
        endDatetime: endDateTime,
        location: _locationController.text.trim().isEmpty 
            ? null 
            : _locationController.text.trim(),
        notes: _notesController.text.trim().isEmpty 
            ? null 
            : _notesController.text.trim(),
        patientIds: widget.appointment?.patientIds ?? [], // TODO: Implement patient selection
      );
      */

      // TODO: Save to Supabase using MCP tools
      // For now, show success message and navigate back
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isEditing 
                ? 'Appointment updated successfully' 
                : 'Appointment created successfully',
            ),
            backgroundColor: AppColors.mediumTurquoise,
          ),
        );
        
        // Navigate back to appointments list
        context.go('/categories/family/appointments');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving appointment: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
