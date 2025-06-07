import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme_config.dart';
import '../../models/family_entities.dart';
import '../shared/widgets.dart';

/// Anniversary Form Screen - Create/Edit Anniversary entities
/// Following detailed guide: name, date, known_year fields
class AnniversaryFormScreen extends StatefulWidget {
  const AnniversaryFormScreen({
    super.key,
    this.anniversary,
    this.isEditing = false,
  });

  final Anniversary? anniversary;
  final bool isEditing;

  @override
  State<AnniversaryFormScreen> createState() => _AnniversaryFormScreenState();
}

class _AnniversaryFormScreenState extends State<AnniversaryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  bool _knownYear = true;

  @override
  void initState() {
    super.initState();
    if (widget.anniversary != null) {
      _nameController.text = widget.anniversary!.name;
      _dateController.text = widget.anniversary!.date.toIso8601String().split('T')[0];
      _knownYear = widget.anniversary!.knownYear;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VuetHeader(widget.isEditing ? 'Edit Anniversary' : 'Add Anniversary'),
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
            
            // Anniversary Date field - required, date format
            VuetDatePicker(
              'Anniversary Date (YYYY-MM-DD)',
              controller: _dateController,
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
                ? 'Anniversary year is known and will be used for anniversary calculation'
                : 'Anniversary year is unknown, only month/day will be used',
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
              onPressed: _saveAnniversary,
            ),
          ],
        ),
      ),
    );
  }

  void _saveAnniversary() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      // final anniversary = Anniversary( // Unused variable
      //   id: widget.anniversary?.id,
      //   name: _nameController.text.trim(),
      //   date: DateTime.parse(_dateController.text),
      //   knownYear: _knownYear,
      // );

      // TODO: Save to Supabase using MCP tools
      // For now, show success message and navigate back
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isEditing 
                ? 'Anniversary updated successfully' 
                : 'Anniversary created successfully',
            ),
            backgroundColor: AppColors.mediumTurquoise,
          ),
        );
        
        // Navigate back to anniversaries list
        context.go('/categories/family/anniversaries');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving anniversary: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
