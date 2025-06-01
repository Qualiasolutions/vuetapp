import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/school_terms_models.dart';
import 'package:intl/intl.dart';
import 'package:vuet_app/providers/auth_providers.dart';

/// Form for creating and editing school terms and breaks
class SchoolTermForm extends ConsumerStatefulWidget {
  final String schoolYearId;
  final bool isBreak;
  final SchoolTermModel? initialTerm;
  final SchoolBreakModel? initialBreak;
  final Function(dynamic) onSave; // Returns either SchoolTermModel or SchoolBreakModel
  final VoidCallback onCancel;

  const SchoolTermForm({
    super.key,
    required this.schoolYearId,
    required this.isBreak,
    this.initialTerm,
    this.initialBreak,
    required this.onSave,
    required this.onCancel,
  });

  @override
  ConsumerState<SchoolTermForm> createState() => _SchoolTermFormState();
}

class _SchoolTermFormState extends ConsumerState<SchoolTermForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  
  DateTime? _startDate;
  DateTime? _endDate;
  bool _showOnCalendars = false;
  bool _showOnlyStartAndEnd = true; // Only for terms
  bool _isLoading = false;
  String? _errorMessage;

  final DateFormat _dateFormat = DateFormat('MMM d, yyyy');

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.isBreak && widget.initialBreak != null) {
      final break_ = widget.initialBreak!;
      _nameController.text = break_.name;
      _startDate = break_.startDate;
      _endDate = break_.endDate;
      _showOnCalendars = break_.showOnCalendars;
    } else if (!widget.isBreak && widget.initialTerm != null) {
      final term = widget.initialTerm!;
      _nameController.text = term.name;
      _startDate = term.startDate;
      _endDate = term.endDate;
      _showOnCalendars = term.showOnCalendars;
      _showOnlyStartAndEnd = term.showOnlyStartAndEnd;
    } else {
      // Default values for new items
      _showOnCalendars = false;
      _showOnlyStartAndEnd = true;
      
      if (widget.isBreak) {
        _nameController.text = '';
      } else {
        _nameController.text = '';
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              _getFormTitle(),
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
                    // Name field
                    _buildNameField(),
                    
                    const SizedBox(height: 16),
                    
                    // Date fields
                    _buildDateFields(),
                    
                    const SizedBox(height: 16),
                    
                    // Calendar options
                    _buildCalendarOptions(),
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

  String _getFormTitle() {
    if (widget.isBreak) {
      return widget.initialBreak != null ? 'Edit Break' : 'Add Break';
    } else {
      return widget.initialTerm != null ? 'Edit Term' : 'Add Term';
    }
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${widget.isBreak ? 'Break' : 'Term'} Name *',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: widget.isBreak 
                ? 'e.g., Winter Break, Spring Break'
                : 'e.g., Fall Semester, Spring Term',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a name';
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
        Text(
          '${widget.isBreak ? 'Break' : 'Term'} Period *',
          style: const TextStyle(fontWeight: FontWeight.w600),
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

  Widget _buildCalendarOptions() {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Show on Calendars'),
          subtitle: Text('Display this ${widget.isBreak ? 'break' : 'term'} on calendar views'),
          value: _showOnCalendars,
          onChanged: (value) {
            setState(() {
              _showOnCalendars = value;
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
        
        // Only show this option for terms, not breaks
        if (!widget.isBreak)
          SwitchListTile(
            title: const Text('Show Only Start and End'),
            subtitle: const Text('Show only the start and end dates instead of the full duration'),
            value: _showOnlyStartAndEnd,
            onChanged: (value) {
              setState(() {
                _showOnlyStartAndEnd = value;
              });
            },
            contentPadding: EdgeInsets.zero,
          ),
      ],
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
                : Text(_getExistingItem() != null ? 'Update' : 'Create'),
          ),
        ],
      ),
    );
  }

  dynamic _getExistingItem() {
    return widget.isBreak ? widget.initialBreak : widget.initialTerm;
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
      initialDate: _endDate ?? _startDate?.add(const Duration(days: 30)) ?? DateTime.now(),
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
          _isLoading = false; // Stop loading if user is not authenticated
        });
        return;
      }
      final userId = user.id;

      if (widget.isBreak) {
        final schoolBreak = SchoolBreakModel(
          id: widget.initialBreak?.id ?? '',
          name: _nameController.text.trim(),
          startDate: _startDate!,
          endDate: _endDate!,
          schoolYearId: widget.schoolYearId,
          showOnCalendars: _showOnCalendars,
          userId: userId,
          createdAt: widget.initialBreak?.createdAt ?? DateTime.now(),
          updatedAt: DateTime.now(),
        );
        widget.onSave(schoolBreak);
      } else {
        final schoolTerm = SchoolTermModel(
          id: widget.initialTerm?.id ?? '',
          name: _nameController.text.trim(),
          startDate: _startDate!,
          endDate: _endDate!,
          schoolYearId: widget.schoolYearId,
          showOnCalendars: _showOnCalendars,
          showOnlyStartAndEnd: _showOnlyStartAndEnd,
          userId: userId,
          createdAt: widget.initialTerm?.createdAt ?? DateTime.now(),
          updatedAt: DateTime.now(),
        );
        widget.onSave(schoolTerm);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to save: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
} 