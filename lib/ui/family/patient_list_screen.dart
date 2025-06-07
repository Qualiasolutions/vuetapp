import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme_config.dart';
import '../../models/family_entities.dart';
import '../shared/widgets.dart';

/// Patient List Screen - Shows all Patient entities
/// Following detailed guide specifications with Modern Palette
class PatientListScreen extends StatefulWidget {
  const PatientListScreen({super.key});

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  List<Patient> _patients = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  Future<void> _loadPatients() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Load from Supabase using MCP tools
      // For now, show sample data
      await Future.delayed(const Duration(milliseconds: 500));
      
      setState(() {
        _patients = [
          Patient(
            id: 1,
            firstName: 'John',
            lastName: 'Doe',
            medicalNumber: 'MED123456',
            notes: 'Regular checkups needed',
          ),
          Patient(
            id: 2,
            firstName: 'Jane',
            lastName: 'Smith',
            medicalNumber: null,
            notes: null,
          ),
          Patient(
            id: 3,
            firstName: 'Baby',
            lastName: 'Johnson',
            medicalNumber: 'PED789012',
            notes: 'Pediatric patient - monthly visits',
          ),
        ];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading patients: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VuetHeader('Patients'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _patients.isEmpty
              ? _buildEmptyState()
              : _buildPatientList(),
      floatingActionButton: VuetFAB(
        onPressed: () => context.go('/categories/family/patients/create'),
        tooltip: 'Add Patient',
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_hospital_outlined,
            size: 64,
            color: AppColors.steel.withAlpha((255 * 0.5).round()),
          ),
          const SizedBox(height: 16),
          const Text(
            'No patients yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.steel,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add family members as patients to track medical information',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.steel,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          VuetSaveButton(
            text: 'Add First Patient',
            onPressed: () => context.go('/categories/family/patients/create'),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientList() {
    return RefreshIndicator(
      onRefresh: _loadPatients,
      color: AppColors.mediumTurquoise,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _patients.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final patient = _patients[index];
          return _PatientCard(
            patient: patient,
            onTap: () => _showPatientDetails(patient),
            onEdit: () => context.go('/categories/family/patients/${patient.id}/edit'),
            onDelete: () => _deletePatient(patient),
          );
        },
      ),
    );
  }

  void _showPatientDetails(Patient patient) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${patient.firstName} ${patient.lastName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DetailRow('First Name', patient.firstName),
            _DetailRow('Last Name', patient.lastName),
            if (patient.medicalNumber != null)
              _DetailRow('Medical Number', patient.medicalNumber!),
            if (patient.notes != null)
              _DetailRow('Notes', patient.notes!),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/categories/family/patients/${patient.id}/edit');
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  void _deletePatient(Patient patient) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Patient'),
        content: Text('Are you sure you want to delete ${patient.firstName} ${patient.lastName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Delete from Supabase using MCP tools
              setState(() {
                _patients.removeWhere((p) => p.id == patient.id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Patient deleted'),
                  backgroundColor: AppColors.mediumTurquoise,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _PatientCard extends StatelessWidget {
  const _PatientCard({
    required this.patient,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final Patient patient;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppColors.steel.withAlpha((255 * 0.3).round()),
          width: 0.5,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.mediumTurquoise.withAlpha((255 * 0.15).round()),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.local_hospital,
                  color: AppColors.mediumTurquoise,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${patient.firstName} ${patient.lastName}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkJungleGreen,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (patient.medicalNumber != null)
                      Text(
                        'Medical #: ${patient.medicalNumber}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.steel,
                        ),
                      ),
                    if (patient.notes != null)
                      Text(
                        patient.notes!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.mediumTurquoise,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      onEdit();
                      break;
                    case 'delete':
                      onDelete();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 16),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 16, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.steel,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.darkJungleGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
