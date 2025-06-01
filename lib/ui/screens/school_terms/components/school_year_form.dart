import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/school_terms_models.dart';
import 'package:vuet_app/models/entity_model.dart';
import 'package:vuet_app/providers/entity_providers.dart';
import 'package:vuet_app/providers/auth_providers.dart';
import 'package:intl/intl.dart';

/// Form for creating and editing school years
class SchoolYearForm extends ConsumerStatefulWidget {
  final SchoolYearModel? initialSchoolYear;
  final Function(SchoolYearModel) onSave;
  final VoidCallback onCancel;

  const SchoolYearForm({
    super.key,
    this.initialSchoolYear,
    required this.onSave,
    required this.onCancel,
  });

  @override
  ConsumerState<SchoolYearForm> createState() => _SchoolYearFormState();
}

class _SchoolYearFormState extends ConsumerState<SchoolYearForm> {
  final _formKey = GlobalKey<FormState>();
  final _yearController = TextEditingController();
  
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedSchoolId;
  bool _showOnCalendars = false;
  bool _isLoading = false;
  String? _errorMessage;

  final DateFormat _dateFormat = DateFormat('MMM d, yyyy');

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.initialSchoolYear != null) {
      final schoolYear = widget.initialSchoolYear!;
      _yearController.text = schoolYear.year;
      _startDate = schoolYear.startDate;
      _endDate = schoolYear.endDate;
      _selectedSchoolId = schoolYear.schoolId;
      _showOnCalendars = schoolYear.showOnCalendars;
    } else {
      // Default to current academic year
      final now = DateTime.now();
      final currentYear = now.year;
      final nextYear = currentYear + 1;
      
      _yearController.text = '$currentYear/$nextYear';
      _startDate = DateTime(currentYear, 9, 1); // September 1st
      _endDate = DateTime(nextYear, 6, 30); // June 30th
      _showOnCalendars = true;
    }
  }

  @override
  void dispose() {
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entitiesAsync = ref.watch(allUserEntitiesProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              widget.initialSchoolYear != null ? 'Edit School Year' : 'Add School Year',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Error message
            if (_errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red.shade600),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red.shade600),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // Form fields
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // School selection
                    _buildSchoolSelection(entitiesAsync),
                    
                    const SizedBox(height: 16),
                    
                    // Year field
                    _buildYearField(),
                    
                    const SizedBox(height: 16),
                    
                    // Date fields
                    _buildDateFields(),
                    
                    const SizedBox(height: 16),
                    
                    // Calendar option
                    _buildCalendarOption(),
                  ],
                ),
              ),
            ),
            
            // Action buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildSchoolSelection(AsyncValue<List<BaseEntityModel>> entitiesAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'School *',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        entitiesAsync.when(
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) => Text(
            'Error loading schools: $error',
            style: TextStyle(color: Colors.red.shade600),
          ),
          data: (entities) {
            // Filter for school entities
            // Assuming 'Education' category has appCategoryId = 3 based on previous mapping
            const int educationAppCategoryId = 3; 
            final schools = entities.where((entity) => 
              entity.subtype == EntitySubtype.school || // More specific check for school subtype
              entity.appCategoryId == educationAppCategoryId
            ).toList();
            
            if (schools.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_outlined, color: Colors.orange.shade600),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'No school entities found. Please create a school entity first.',
                      ),
                    ),
                  ],
                ),
              );
            }
            
            return DropdownButtonFormField<String>(
              value: _selectedSchoolId,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Select a school',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a school';
                }
                return null;
              },
              items: schools.map((school) {
                return DropdownMenuItem<String>(
                  value: school.id,
                  child: Text(school.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSchoolId = value;
                });
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildYearField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Academic Year *',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _yearController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'e.g., 2023/2024',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the academic year';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDateFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Academic Year Period *',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Start Date'),
                  const SizedBox(height: 4),
                  InkWell(
                    onTap: () => _selectStartDate(),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.grey.shade600),
                          const SizedBox(width: 8),
                          Text(
                            _startDate != null 
                                ? _dateFormat.format(_startDate!)
                                : 'Select date',
                            style: TextStyle(
                              color: _startDate != null 
                                  ? Colors.black 
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 16),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('End Date'),
                  const SizedBox(height: 4),
                  InkWell(
                    onTap: () => _selectEndDate(),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.grey.shade600),
                          const SizedBox(width: 8),
                          Text(
                            _endDate != null 
                                ? _dateFormat.format(_endDate!)
                                : 'Select date',
                            style: TextStyle(
                              color: _endDate != null 
                                  ? Colors.black 
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        
        // Date validation error
        if (_startDate != null && _endDate != null && _endDate!.isBefore(_startDate!))
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'End date must be after start date',
              style: TextStyle(
                color: Colors.red.shade600,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCalendarOption() {
    return SwitchListTile(
      title: const Text('Show on Calendars'),
      subtitle: const Text('Display this school year on calendar views'),
      value: _showOnCalendars,
      onChanged: (value) {
        setState(() {
          _showOnCalendars = value;
        });
      },
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: _isLoading ? null : widget.onCancel,
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: _isLoading ? null : _handleSave,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(widget.initialSchoolYear != null ? 'Update' : 'Create'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    
    if (date != null) {
      setState(() {
        _startDate = date;
      });
    }
  }

  Future<void> _selectEndDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate?.add(const Duration(days: 365)) ?? DateTime.now(),
      firstDate: _startDate ?? DateTime(2020),
      lastDate: DateTime(2030),
    );
    
    if (date != null) {
      setState(() {
        _endDate = date;
      });
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_startDate == null || _endDate == null) {
      setState(() {
        _errorMessage = 'Please select both start and end dates';
      });
      return;
    }

    if (_endDate!.isBefore(_startDate!)) {
      setState(() {
        _errorMessage = 'End date must be after start date';
      });
      return;
    }

    if (_selectedSchoolId == null) {
      setState(() {
        _errorMessage = 'Please select a school';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get current user ID
      final user = ref.read(currentUserProvider);
      if (user == null) {
        setState(() {
          _errorMessage = 'User not authenticated';
          _isLoading = false;
        });
        return;
      }

      final schoolYear = SchoolYearModel(
        id: widget.initialSchoolYear?.id ?? '',
        year: _yearController.text.trim(),
        startDate: _startDate!,
        endDate: _endDate!,
        schoolId: _selectedSchoolId!,
        showOnCalendars: _showOnCalendars,
        userId: user.id,
        createdAt: widget.initialSchoolYear?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      widget.onSave(schoolYear);
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to save school year: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
