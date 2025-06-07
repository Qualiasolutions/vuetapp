import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/career_entities.dart';
import 'package:vuet_app/providers/career_providers.dart';
import 'package:vuet_app/ui/shared/widgets.dart';
import 'package:intl/intl.dart'; // For date formatting

class EmployeeFormScreen extends ConsumerStatefulWidget {
  final String? employeeId;
  const EmployeeFormScreen({super.key, this.employeeId});

  @override
  ConsumerState<EmployeeFormScreen> createState() => _EmployeeFormScreenState();
}

class _EmployeeFormScreenState extends ConsumerState<EmployeeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _responsibilitiesController = TextEditingController();
  final _managerNameController = TextEditingController();
  final _managerEmailController = TextEditingController();
  final _nextReviewDateController = TextEditingController();
  bool _isCurrentJob = true;

  Employee? _initialEmployee;

  @override
  void initState() {
    super.initState();
    if (widget.employeeId != null) {
      _loadExistingEmployee();
    }
  }

  Future<void> _loadExistingEmployee() async {
    final employee = await ref.read(employeeByIdProvider(widget.employeeId!).future);
    if (employee != null) {
      setState(() {
        _initialEmployee = employee;
        _companyNameController.text = employee.companyName;
        _jobTitleController.text = employee.jobTitle;
        _startDateController.text = employee.startDate != null ? DateFormat('yyyy-MM-dd').format(employee.startDate!) : '';
        _endDateController.text = employee.endDate != null ? DateFormat('yyyy-MM-dd').format(employee.endDate!) : '';
        _isCurrentJob = employee.isCurrentJob ?? true;
        _responsibilitiesController.text = employee.responsibilities ?? '';
        _managerNameController.text = employee.managerName ?? '';
        _managerEmailController.text = employee.managerEmail ?? '';
        _nextReviewDateController.text = employee.nextReviewDate != null ? DateFormat('yyyy-MM-dd').format(employee.nextReviewDate!) : '';
      });
    }
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _jobTitleController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _responsibilitiesController.dispose();
    _managerNameController.dispose();
    _managerEmailController.dispose();
    _nextReviewDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.text.isNotEmpty ? DateTime.tryParse(controller.text) ?? DateTime.now() : DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      final careerRepository = ref.read(careerRepositoryProvider);
      final employee = Employee(
        id: _initialEmployee?.id,
        companyName: _companyNameController.text,
        jobTitle: _jobTitleController.text,
        startDate: _startDateController.text.isNotEmpty ? DateTime.tryParse(_startDateController.text) : null,
        endDate: _isCurrentJob ? null : (_endDateController.text.isNotEmpty ? DateTime.tryParse(_endDateController.text) : null),
        isCurrentJob: _isCurrentJob,
        responsibilities: _responsibilitiesController.text,
        managerName: _managerNameController.text,
        managerEmail: _managerEmailController.text,
        nextReviewDate: _nextReviewDateController.text.isNotEmpty ? DateTime.tryParse(_nextReviewDateController.text) : null,
      );

      try {
        if (_initialEmployee == null) {
          await careerRepository.createEmployee(employee);
        } else {
          await careerRepository.updateEmployee(employee);
        }
        if (mounted) {
          Navigator.of(context).pop();
          ref.invalidate(userEmployeesProvider);
          if (_initialEmployee?.id != null) {
            ref.invalidate(employeeByIdProvider(_initialEmployee!.id!));
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving employment record: ${e.toString()}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.employeeId != null && _initialEmployee == null && ref.watch(employeeByIdProvider(widget.employeeId!)).isLoading) {
      return const Scaffold(appBar: VuetHeader('Edit Employment'), body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: VuetHeader(_initialEmployee == null ? 'New Employment Record' : 'Edit Employment Record'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              VuetTextField('Company Name', controller: _companyNameController, validator: VuetValidators.required('Company Name')),
              const SizedBox(height: 16),
              VuetTextField('Job Title', controller: _jobTitleController, validator: VuetValidators.required('Job Title')),
              const SizedBox(height: 16),
              VuetDatePicker('Start Date', controller: _startDateController, validator: VuetValidators.dateIso),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Current Job?'),
                  const SizedBox(width: 8),
                  VuetToggle(
                    value: _isCurrentJob,
                    onChanged: (value) => setState(() => _isCurrentJob = value),
                  ),
                ],
              ),
              if (!_isCurrentJob) ...[
                const SizedBox(height: 16),
                VuetDatePicker('End Date', controller: _endDateController, validator: VuetValidators.dateIso),
              ],
              const SizedBox(height: 16),
              VuetTextField('Responsibilities (Optional)', controller: _responsibilitiesController, validator: VuetValidators.optional, minLines: 3, maxLines: 5),
              const SizedBox(height: 16),
              VuetTextField('Manager Name (Optional)', controller: _managerNameController, validator: VuetValidators.optional),
              const SizedBox(height: 16),
              VuetTextField('Manager Email (Optional)', controller: _managerEmailController, validator: VuetValidators.emailOptional, type: TextInputType.emailAddress),
              const SizedBox(height: 16),
              VuetDatePicker('Next Review Date (Optional)', controller: _nextReviewDateController, validator: (String? v) {
                  if (v == null || v.isEmpty) return null;
                  try { DateFormat('yyyy-MM-dd').parseStrict(v); return null; }
                  catch (e) { return 'Invalid date (YYYY-MM-DD)'; }
                }
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
