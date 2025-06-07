import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/education_entities.dart';
import 'package:vuet_app/providers/education_providers.dart';
import 'package:vuet_app/ui/shared/widgets.dart';
import 'package:vuet_app/config/theme_config.dart'; // For AppColors

class AcademicPlanFormScreen extends ConsumerStatefulWidget {
  final String? academicPlanId;
  final String? studentIdForContext; // To pre-select student if creating from student's context

  const AcademicPlanFormScreen({super.key, this.academicPlanId, this.studentIdForContext});

  @override
  ConsumerState<AcademicPlanFormScreen> createState() => _AcademicPlanFormScreenState();
}

class _AcademicPlanFormScreenState extends ConsumerState<AcademicPlanFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _planNameController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late TextEditingController _descriptionController;
  late TextEditingController _goalsController; // For simplicity, goals as comma-separated string

  String? _selectedStudentId;
  AcademicPlan? _initialPlan;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _planNameController = TextEditingController();
    _startDateController = TextEditingController();
    _endDateController = TextEditingController();
    _descriptionController = TextEditingController();
    _goalsController = TextEditingController();
    _selectedStudentId = widget.studentIdForContext;

    if (widget.academicPlanId != null) {
      _loadPlanData();
    }
  }

  Future<void> _loadPlanData() async {
    setState(() => _isLoading = true);
    try {
      _initialPlan = await ref.read(academicPlanByIdProvider(widget.academicPlanId!).future);
      if (_initialPlan != null) {
        _planNameController.text = _initialPlan!.planName;
        _startDateController.text = _initialPlan!.startDate?.toIso8601String().split('T')[0] ?? '';
        _endDateController.text = _initialPlan!.endDate?.toIso8601String().split('T')[0] ?? '';
        _descriptionController.text = _initialPlan!.description ?? '';
        _goalsController.text = (_initialPlan!.goals ?? []).join(', ');
        _selectedStudentId = _initialPlan!.studentId;
      }
    } catch (e) {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading plan data: ${e.toString()}')),
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
    _planNameController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _descriptionController.dispose();
    _goalsController.dispose();
    super.dispose();
  }

  Future<void> _savePlan() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final now = DateTime.now();
        final planToSave = AcademicPlan(
          id: _initialPlan?.id ?? '',
          planName: _planNameController.text,
          studentId: _selectedStudentId,
          startDate: _startDateController.text.isNotEmpty ? DateTime.tryParse(_startDateController.text) : null,
          endDate: _endDateController.text.isNotEmpty ? DateTime.tryParse(_endDateController.text) : null,
          description: _descriptionController.text,
          goals: _goalsController.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList(),
          notes: _initialPlan?.notes, // Assuming notes are not edited in this basic form
          createdAt: _initialPlan?.createdAt ?? now,
          updatedAt: now,
          ownerId: _initialPlan?.ownerId,
          entityType: 'AcademicPlan',
        );

        await ref.read(academicPlanRepositoryProvider).saveAcademicPlan(planToSave);
        
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Academic Plan saved successfully!')),
          );
          Navigator.of(context).pop();
        }

      } catch (e) {
         if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving plan: ${e.toString()}')),
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
    final allStudentsAsync = ref.watch(allStudentsProvider);

    if (widget.academicPlanId != null && _isLoading && _initialPlan == null) {
      return Scaffold(
        appBar: VuetHeader(widget.academicPlanId == null ? 'Add Academic Plan' : 'Edit Academic Plan'),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: VuetHeader(widget.academicPlanId == null ? 'Add Academic Plan' : 'Edit Academic Plan'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (widget.academicPlanId != null && _isLoading && _initialPlan == null)
                const Center(child: CircularProgressIndicator())
              else ...[
                VuetTextField(
                  'Plan Name',
                  controller: _planNameController,
                  validator: VuetValidators.required,
                ),
                const SizedBox(height: 16),
                allStudentsAsync.when(
                  data: (students) => DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Student (Optional)',
                      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.steel)),
                      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.mediumTurquoise)),
                    ),
                    value: _selectedStudentId,
                    items: students.map((student) => DropdownMenuItem(
                      value: student.id,
                      child: Text('${student.firstName} ${student.lastName ?? ''}'),
                    )).toList(),
                    onChanged: (value) => setState(() => _selectedStudentId = value),
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (e, s) => Text('Error loading students: $e'),
                ),
                const SizedBox(height: 16),
                VuetDatePicker(
                  'Start Date',
                  controller: _startDateController,
                  validator: (v) => (v == null || v.isEmpty) ? null : VuetValidators.dateIso(v),
                ),
                const SizedBox(height: 16),
                VuetDatePicker(
                  'End Date',
                  controller: _endDateController,
                  validator: (v) => (v == null || v.isEmpty) ? null : VuetValidators.dateIso(v),
                ),
                const SizedBox(height: 16),
                VuetTextField(
                  'Description',
                  controller: _descriptionController,
                  validator: (v) => null, // Optional
                  minLines: 3,
                  maxLines: 5,
                ),
                const SizedBox(height: 16),
                VuetTextField(
                  'Goals (comma-separated)',
                  controller: _goalsController,
                  validator: (v) => null, // Optional
                  minLines: 2,
                  maxLines: 4,
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : VuetSaveButton(onPressed: _savePlan),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
