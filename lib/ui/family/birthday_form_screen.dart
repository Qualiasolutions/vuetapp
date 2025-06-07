import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:vuet_app/models/family_entities.dart';
import 'package:vuet_app/providers/birthday_providers.dart';
import 'package:vuet_app/ui/shared/widgets.dart';
import 'package:vuet_app/config/theme_config.dart';

class BirthdayFormScreen extends ConsumerStatefulWidget {
  final String? birthdayId; // This will be the BaseEntityModel ID (string)

  const BirthdayFormScreen({super.key, this.birthdayId});

  @override
  ConsumerState<BirthdayFormScreen> createState() => _BirthdayFormScreenState();
}

class _BirthdayFormScreenState extends ConsumerState<BirthdayFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _dobController;
  late TextEditingController _notesController;
  bool _knownYear = true;

  Birthday? _existingBirthday;
  bool _isLoading = false;
  DateTime? _selectedDateOfBirth;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _dobController = TextEditingController();
    _notesController = TextEditingController();

    if (widget.birthdayId != null) {
      _loadExistingData();
    }
  }

  Future<void> _loadExistingData() async {
    setState(() => _isLoading = true);
    try {
      _existingBirthday = await ref.read(birthdayByIdProvider(widget.birthdayId!).future);
      if (_existingBirthday != null) {
        _nameController.text = _existingBirthday!.name;
        _selectedDateOfBirth = _existingBirthday!.dob;
        _dobController.text = DateFormat('yyyy-MM-dd').format(_selectedDateOfBirth!);
        _knownYear = _existingBirthday!.knownYear;
        _notesController.text = _existingBirthday!.notes ?? '';
      } else {
         if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Birthday not found.'), backgroundColor: Colors.red));
      }
    } catch (e) {
       if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading birthday data: $e'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateOfBirth ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)), // Allow future dates for planning
    );
    if (picked != null && picked != _selectedDateOfBirth) {
      setState(() {
        _selectedDateOfBirth = picked;
        _dobController.text = DateFormat('yyyy-MM-dd').format(_selectedDateOfBirth!);
      });
    }
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDateOfBirth == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a date of birth.'), backgroundColor: Colors.red),
        );
        return;
      }
      setState(() => _isLoading = true);
      
      final birthdayData = Birthday(
        id: _existingBirthday?.id,
        name: _nameController.text.trim(),
        dob: _selectedDateOfBirth!,
        knownYear: _knownYear,
        notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
      );

      try {
        final service = ref.read(birthdayServiceProvider);
        if (_existingBirthday == null) {
          await service.addBirthday(birthdayData);
        } else {
          await service.updateBirthday(birthdayData);
        }
        ref.refresh(familyBirthdaysProvider); // Refresh the list
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Birthday saved successfully!'), backgroundColor: AppColors.mediumTurquoise),
          );
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving birthday: $e'), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = _existingBirthday != null;
    return Scaffold(
      appBar: VuetHeader(isEditMode ? 'Edit Birthday' : 'Add Birthday'),
      body: _isLoading && widget.birthdayId != null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _buildTextFormField(_nameController, "Person's Name", isRequired: true),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      _dobController,
                      'Date of Birth (YYYY-MM-DD)',
                      isRequired: true,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      suffixIcon: Icons.calendar_today,
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Year is known?'),
                      value: _knownYear,
                      onChanged: (bool value) {
                        setState(() {
                          _knownYear = value;
                        });
                      },
                      activeColor: AppColors.mediumTurquoise,
                      contentPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 16),
                    _buildTextFormField(_notesController, 'Notes', maxLines: 3),
                    const SizedBox(height: 32),
                    VuetSaveButton(
                      text: isEditMode ? 'Save Changes' : 'Add Birthday',
                      onPressed: _isLoading ? () {} : () => _saveForm(),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextFormField(
    TextEditingController controller,
    String label, {
    bool isRequired = false,
    int? maxLines = 1,
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
    IconData? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label + (isRequired ? ' *' : ''),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.mediumTurquoise, width: 2.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        suffixIcon: suffixIcon != null ? IconButton(icon: Icon(suffixIcon), onPressed: onTap) : null,
      ),
      validator: (value) {
        if (isRequired && (value == null || value.trim().isEmpty)) {
          return '$label is required';
        }
        return null;
      },
      maxLines: maxLines,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
    );
  }
}
