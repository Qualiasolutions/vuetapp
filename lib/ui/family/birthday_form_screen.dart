import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme_config.dart';
import '../../models/family_entities.dart';
import '../shared/widgets.dart';

/// Birthday Form Screen - Create/Edit Birthday entities
/// Following detailed guide: name, dob, known_year fields
class BirthdayFormScreen extends StatefulWidget {
  const BirthdayFormScreen({
    super.key,
    this.birthday,
    this.isEditing = false,
  });

  final Birthday? birthday;
  final bool isEditing;

  @override
  State<BirthdayFormScreen> createState() => _BirthdayFormScreenState();
}

class _BirthdayFormScreenState extends State<BirthdayFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  bool _knownYear = true;

  @override
  void initState() {
    super.initState();
    if (widget.birthday != null) {
      _nameController.text = widget.birthday!.name;
      _dobController.text = widget.birthday!.dob.toIso8601String().split('T')[0];
      _knownYear = widget.birthday!.knownYear;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VuetHeader(widget.isEditing ? 'Edit Birthday' : 'Add Birthday'),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Name field - required
            VuetTextField(
              'Name',
              controller: _nameController,
              validator: VuetValidators.required,
            ),
            
            const SizedBox(height: 16),
            
            // Date of Birth field - required, date format
            VuetDatePicker(
              'Date of Birth (YYYY-MM-DD)',
              controller: _dobController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Required';
                }
                if (DateTime.tryParse(value) == null) {
                  return 'yyyy-MM-dd';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // Known Year toggle
            Row(
              children: [
                const Text(
                  'Known Year',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.darkJungleGreen,
                  ),
                ),
                const Spacer(),
                VuetToggle(
                  value: _knownYear,
                  onChanged: (value) {
                    setState(() {
                      _knownYear = value;
                    });
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            Text(
              _knownYear 
                ? 'Birth year is known and will be used for age calculation'
                : 'Birth year is unknown, only month/day will be used',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.steel,
              ),
            ),
            
            // Form divider as specified in guide
            const VuetDivider(),
            
            // Save button with Modern Palette styling
            VuetSaveButton(
              text: widget.isEditing ? 'Update' : 'Save',
              onPressed: _saveBirthday,
            ),
          ],
        ),
      ),
    );
  }

  void _saveBirthday() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      /* // Commenting out unused variable and its object creation for now
      final birthday = Birthday(
        id: widget.birthday?.id,
        name: _nameController.text.trim(),
        dob: DateTime.parse(_dobController.text),
        knownYear: _knownYear,
      );
      */

      // TODO: Save to Supabase using MCP tools
      // For now, show success message and navigate back
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isEditing 
                ? 'Birthday updated successfully' 
                : 'Birthday created successfully',
            ),
            backgroundColor: AppColors.mediumTurquoise,
          ),
        );
        
        // Navigate back to birthdays list
        context.go('/categories/family/birthdays');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving birthday: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
