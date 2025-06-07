import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/education_entities.dart';
import 'package:vuet_app/providers/education_providers.dart';
import 'package:vuet_app/ui/shared/widgets.dart'; // VuetHeader, VuetTextField, VuetDatePicker, VuetSaveButton, VuetValidators
import 'package:vuet_app/config/theme_config.dart'; // For AppColors

class StudentFormScreen extends ConsumerStatefulWidget {
  final String? studentId; // Null for new, non-null for editing
  final String? schoolIdForContext; // Optional, if creating student from a school's context

  const StudentFormScreen({super.key, this.studentId, this.schoolIdForContext});

  @override
  ConsumerState<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends ConsumerState<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _dobController;
  late TextEditingController _gradeLevelController;
  late TextEditingController _studentIdNumberController;
  late TextEditingController _notesController;
  
  String? _selectedSchoolId; // To hold selected school ID

  Student? _initialStudent;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _dobController = TextEditingController();
    _gradeLevelController = TextEditingController();
    _studentIdNumberController = TextEditingController();
    _notesController = TextEditingController();
    _selectedSchoolId = widget.schoolIdForContext;

    if (widget.studentId != null) {
      _loadStudentData();
    }
  }

  Future<void> _loadStudentData() async {
    setState(() => _isLoading = true);
    try {
      _initialStudent = await ref.read(studentByIdProvider(widget.studentId!).future);
      if (_initialStudent != null) {
        _firstNameController.text = _initialStudent!.firstName;
        _lastNameController.text = _initialStudent!.lastName ?? '';
        _dobController.text = _initialStudent!.dateOfBirth?.toIso8601String().split('T')[0] ?? '';
        _selectedSchoolId = _initialStudent!.schoolId;
        _gradeLevelController.text = _initialStudent!.gradeLevel ?? '';
        _studentIdNumberController.text = _initialStudent!.studentIdNumber ?? '';
        _notesController.text = _initialStudent!.notes ?? '';
      }
    } catch (e) {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading student data: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _gradeLevelController.dispose();
    _studentIdNumberController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveStudent() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final now = DateTime.now();
        final studentToSave = Student(
          id: _initialStudent?.id ?? '',
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          dateOfBirth: _dobController.text.isNotEmpty ? DateTime.tryParse(_dobController.text) : null,
          schoolId: _selectedSchoolId,
          gradeLevel: _gradeLevelController.text,
          studentIdNumber: _studentIdNumberController.text,
          notes: _notesController.text,
          createdAt: _initialStudent?.createdAt ?? now,
          updatedAt: now,
          ownerId: _initialStudent?.ownerId,
          entityType: 'Student',
        );

        await ref.read(studentRepositoryProvider).saveStudent(studentToSave);
        
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Student saved successfully!')),
          );
          Navigator.of(context).pop();
        }

      } catch (e) {
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving student: ${e.toString()}')),
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
  Widget build(BuildContext context) {
    final allSchoolsAsync = ref.watch(allSchoolsProvider);

    if (widget.studentId != null && _isLoading && _initialStudent == null) {
      return Scaffold(
        appBar: VuetHeader(widget.studentId == null ? 'Add Student' : 'Edit Student'),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: VuetHeader(widget.studentId == null ? 'Add Student' : 'Edit Student'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (widget.studentId != null && _isLoading && _initialStudent == null)
                const Center(child: CircularProgressIndicator())
              else ...[
                VuetTextField(
                  'First Name',
                  controller: _firstNameController,
                  validator: VuetValidators.required,
                ),
                const SizedBox(height: 16),
                VuetTextField(
                  'Last Name',
                  controller: _lastNameController,
                  validator: (v) => null, // Optional
                ),
                const SizedBox(height: 16),
                VuetDatePicker(
                  'Date of Birth',
                  controller: _dobController,
                  validator: (v) => (v == null || v.isEmpty) ? null : VuetValidators.dateIso(v), // Optional date
                ),
                const SizedBox(height: 16),
                allSchoolsAsync.when(
                  data: (schools) => DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'School',
                      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.steel)),
                      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.mediumTurquoise)),
                    ),
                    value: _selectedSchoolId,
                    items: schools.map((school) => DropdownMenuItem(
                      value: school.id,
                      child: Text(school.name),
                    )).toList(),
                    onChanged: (value) => setState(() => _selectedSchoolId = value),
                    // validator: (value) => value == null ? 'Please select a school' : null, // Optional or required
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (e, s) => Text('Error loading schools: $e'),
                ),
                const SizedBox(height: 16),
                VuetTextField(
                  'Grade Level',
                  controller: _gradeLevelController,
                  validator: (v) => null, // Optional
                ),
                const SizedBox(height: 16),
                VuetTextField(
                  'Student ID Number',
                  controller: _studentIdNumberController,
                  validator: (v) => null, // Optional
                ),
                const SizedBox(height: 16),
                VuetTextField(
                  'Notes',
                  controller: _notesController,
                  validator: (v) => null, // Optional
                  minLines: 3,
                  maxLines: 5,
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : VuetSaveButton(onPressed: _saveStudent),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
