import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/career_entities.dart';
import 'package:vuet_app/providers/career_providers.dart';
import 'package:vuet_app/ui/shared/widgets.dart'; // For VuetHeader, VuetTextField, VuetDatePicker, VuetSaveButton, VuetValidators
import 'package:intl/intl.dart'; // For date formatting

class CareerGoalFormScreen extends ConsumerStatefulWidget {
  final String? careerGoalId;
  const CareerGoalFormScreen({super.key, this.careerGoalId});

  @override
  ConsumerState<CareerGoalFormScreen> createState() => _CareerGoalFormScreenState();
}

class _CareerGoalFormScreenState extends ConsumerState<CareerGoalFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _targetDateController = TextEditingController();
  String? _status; // Example: 'Not Started', 'In Progress', 'Achieved'

  CareerGoal? _initialGoal;

  @override
  void initState() {
    super.initState();
    if (widget.careerGoalId != null) {
      _loadExistingGoal();
    }
  }

  Future<void> _loadExistingGoal() async {
    // Use a separate provider or direct call if careerGoalByIdProvider is not suitable for mutations
    // For simplicity, assuming careerGoalByIdProvider can be used here.
    // In a real app, you might fetch once and then manage state locally or use a StateNotifier.
    final goal = await ref.read(careerGoalByIdProvider(widget.careerGoalId!).future);
    if (goal != null) {
      setState(() {
        _initialGoal = goal;
        _titleController.text = goal.title;
        _descriptionController.text = goal.description ?? '';
        _targetDateController.text = goal.targetDate != null ? DateFormat('yyyy-MM-dd').format(goal.targetDate!) : '';
        _status = goal.status;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _targetDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _targetDateController.text.isNotEmpty ? DateTime.tryParse(_targetDateController.text) ?? DateTime.now() : DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _targetDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      final careerRepository = ref.read(careerRepositoryProvider);
      final goal = CareerGoal(
        id: _initialGoal?.id,
        title: _titleController.text,
        description: _descriptionController.text,
        targetDate: _targetDateController.text.isNotEmpty ? DateTime.tryParse(_targetDateController.text) : null,
        status: _status ?? 'Not Started',
        // userId will be set by the repository
      );

      try {
        if (_initialGoal == null) {
          await careerRepository.createCareerGoal(goal);
        } else {
          await careerRepository.updateCareerGoal(goal);
        }
        if (mounted) {
          Navigator.of(context).pop();
           // Invalidate providers to refresh lists
          ref.invalidate(userCareerGoalsProvider);
          if (_initialGoal?.id != null) {
            ref.invalidate(careerGoalByIdProvider(_initialGoal!.id!));
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving goal: ${e.toString()}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // If loading existing data and it's not yet available, show loading.
    // This is a simplified loading state.
    if (widget.careerGoalId != null && _initialGoal == null && ref.watch(careerGoalByIdProvider(widget.careerGoalId!)).isLoading) {
        return const Scaffold(appBar: VuetHeader('Edit Career Goal'), body: Center(child: CircularProgressIndicator()));
    }


    return Scaffold(
      appBar: VuetHeader(_initialGoal == null ? 'New Career Goal' : 'Edit Career Goal'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              VuetTextField(
                'Title',
                controller: _titleController,
                validator: VuetValidators.required,
              ),
              const SizedBox(height: 16),
              VuetTextField(
                'Description (Optional)',
                controller: _descriptionController,
                validator: VuetValidators.optional,
                minLines: 3, // Using new properties from shared widgets
                maxLines: 5,
              ),
              const SizedBox(height: 16),
              VuetDatePicker(
                'Target Date (Optional)', // Positional hint
                controller: _targetDateController,
                validator: (value) { // Custom validator for optional date
                  if (value == null || value.isEmpty) {
                    return null; // Optional, so empty is fine
                  }
                  // If not empty, try to parse as a date
                  try {
                    DateFormat('yyyy-MM-dd').parseStrict(value);
                    return null;
                  } catch (e) {
                    return 'Invalid date format (YYYY-MM-DD)';
                  }
                },
                // onTap is handled internally by VuetDatePicker
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _status ?? 'Not Started',
                decoration: const InputDecoration(labelText: 'Status'),
                items: ['Not Started', 'In Progress', 'Achieved', 'On Hold']
                    .map((label) => DropdownMenuItem(
                          value: label,
                          child: Text(label),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _status = value;
                  });
                },
              ),
              const SizedBox(height: 32),
              VuetSaveButton(onPressed: _saveForm),
            ],
          ),
        ),
      ),
    );
  }
}
