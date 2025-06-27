import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:vuet_app/config/theme_config.dart';
import 'package:vuet_app/ui/shared/widgets.dart';
import 'package:vuet_app/ui/widgets/modern_components.dart';
import 'package:vuet_app/ui/screens/health_beauty/patient_form_screen.dart'; // Assuming this exists
import 'package:vuet_app/ui/screens/health_beauty/patient_detail_screen.dart'; // Assuming this exists
import 'package:vuet_app/utils/logger.dart';
import 'package:vuet_app/models/entity_model.dart'; // For BaseEntityModel and EntitySubtype
import 'package:vuet_app/providers/entity_providers.dart'; // For entityServiceProvider
import 'package:vuet_app/ui/screens/tasks/create_task_screen.dart'; // For quick actions
import 'package:vuet_app/ui/widgets/i_want_to_menu.dart'; // For I WANT TO menu

// --- Temporary Patient Model (will be moved to lib/models/health_beauty_entities.dart) ---
@immutable
class Patient extends BaseEntityModel {
  final String? dateOfBirth;
  final String? bloodType;
  final String? allergies;
  final String? medicalConditions;
  final String? primaryDoctor;
  final String? emergencyContact;
  final String? insuranceInfo;
  final DateTime? lastCheckup;

  const Patient({
    String? id,
    required String name,
    String? description,
    String? userId,
    String? categoryId,
    String? subcategoryId,
    String? categoryName,
    String? subcategoryName,
    String? imageUrl,
    bool? isHidden,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.dateOfBirth,
    this.bloodType,
    this.allergies,
    this.medicalConditions,
    this.primaryDoctor,
    this.emergencyContact,
    this.insuranceInfo,
    this.lastCheckup,
  }) : super(
          id: id,
          name: name,
          description: description,
          userId: userId,
          categoryId: categoryId,
          subcategoryId: subcategoryId,
          categoryName: categoryName,
          subcategoryName: subcategoryName,
          imageUrl: imageUrl,
          isHidden: isHidden,
          createdAt: createdAt,
          updatedAt: updatedAt,
          subtype: EntitySubtype.patient,
        );

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        userId,
        categoryId,
        subcategoryId,
        categoryName,
        subcategoryName,
        imageUrl,
        isHidden,
        createdAt,
        updatedAt,
        dateOfBirth,
        bloodType,
        allergies,
        medicalConditions,
        primaryDoctor,
        emergencyContact,
        insuranceInfo,
        lastCheckup,
        subtype,
      ];

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      userId: json['user_id'] as String?,
      categoryId: json['category_id'] as String?,
      subcategoryId: json['subcategory_id'] as String?,
      categoryName: json['category_name'] as String?,
      subcategoryName: json['subcategory_name'] as String?,
      imageUrl: json['image_url'] as String?,
      isHidden: json['is_hidden'] as bool?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      dateOfBirth: json['date_of_birth'] as String?,
      bloodType: json['blood_type'] as String?,
      allergies: json['allergies'] as String?,
      medicalConditions: json['medical_conditions'] as String?,
      primaryDoctor: json['primary_doctor'] as String?,
      emergencyContact: json['emergency_contact'] as String?,
      insuranceInfo: json['insurance_info'] as String?,
      lastCheckup: json['last_checkup'] != null
          ? DateTime.parse(json['last_checkup'] as String)
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'user_id': userId,
      'category_id': categoryId,
      'subcategory_id': subcategoryId,
      'category_name': categoryName,
      'subcategory_name': subcategoryName,
      'image_url': imageUrl,
      'is_hidden': isHidden,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'date_of_birth': dateOfBirth,
      'blood_type': bloodType,
      'allergies': allergies,
      'medical_conditions': medicalConditions,
      'primary_doctor': primaryDoctor,
      'emergency_contact': emergencyContact,
      'insurance_info': insuranceInfo,
      'last_checkup': lastCheckup?.toIso8601String(),
      'subtype': subtype.toShortString(),
    };
  }
}

// --- End Temporary Patient Model ---

// Provider for the search query for patients
final patientSearchQueryProvider = StateProvider<String>((ref) => '');

// Provider for filtered patients
final filteredPatientsProvider =
    FutureProvider.family<List<Patient>, String>((ref, searchQuery) async {
  final entityService = ref.watch(entityServiceProvider);
  final allEntities = await entityService.listEntities(
    categoryName: 'HEALTH_BEAUTY', // Assuming 'HEALTH_BEAUTY' is the category name for patients
    subtype: EntitySubtype.patient,
  );

  // Cast BaseEntityModel to Patient
  final allPatients = allEntities.map((e) => Patient.fromJson(e.toJson())).toList();

  if (searchQuery.isEmpty) {
    return allPatients;
  } else {
    return allPatients.where((patient) {
      final lowerCaseQuery = searchQuery.toLowerCase();
      return patient.name.toLowerCase().contains(lowerCaseQuery) ||
          (patient.description?.toLowerCase().contains(lowerCaseQuery) ?? false) ||
          (patient.medicalConditions?.toLowerCase().contains(lowerCaseQuery) ?? false) ||
          (patient.primaryDoctor?.toLowerCase().contains(lowerCaseQuery) ?? false);
    }).toList();
  }
});

// Provider for refreshing patient list
final patientListRefreshProvider = StateProvider<bool>((ref) => false);

class PatientListScreen extends ConsumerStatefulWidget {
  const PatientListScreen({super.key});

  @override
  ConsumerState<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends ConsumerState<PatientListScreen> {
  late final TextEditingController _searchController;
  late final ScrollController _scrollController;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshPatients() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    // Invalidate the provider to force a refresh
    ref.invalidate(patientListRefreshProvider);
    ref.invalidate(filteredPatientsProvider(ref.read(patientSearchQueryProvider)));

    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network delay

    setState(() {
      _isRefreshing = false;
    });
  }

  void _onSearchChanged(String query) {
    ref.read(patientSearchQueryProvider.notifier).state = query;
  }

  void _navigateToCreatePatient(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PatientFormScreen()),
    ).then((value) {
      if (value == true) {
        _refreshPatients();
      }
    });
  }

  void _navigateToEditPatient(BuildContext context, Patient patient) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PatientFormScreen(patient: patient)),
    ).then((value) {
      if (value == true) {
        _refreshPatients();
      }
    });
  }

  Future<void> _deletePatient(BuildContext context, String patientId) async {
    try {
      await ref.read(entityServiceProvider).deleteEntity(patientId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Patient deleted successfully')),
        );
        _refreshPatients();
      }
    } catch (e, st) {
      log('Error deleting patient: $e', name: 'PatientListScreen', error: e, stackTrace: st);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete patient: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(patientSearchQueryProvider);
    final patientsAsync = ref.watch(filteredPatientsProvider(searchQuery));

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        title: const Text('Patients'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.darkJungleGreen,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search patients...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshPatients,
            tooltip: 'Refresh patients',
          ),
        ],
      ),
      body: patientsAsync.when(
        data: (patients) {
          if (patients.isEmpty) {
            return _buildEmptyState(context, searchQuery.isNotEmpty);
          }
          return RefreshIndicator(
            onRefresh: _refreshPatients,
            child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: patients.length,
              itemBuilder: (context, index) {
                final patient = patients[index];
                return PatientCard(
                  patient: patient,
                  onTap: () => context.go('/health_beauty/patients/${patient.id}'), // Navigate to detail
                  onEdit: () => _navigateToEditPatient(context, patient),
                  onDelete: () => _confirmDelete(context, patient.id!),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          log('Error loading patients: $error', name: 'PatientListScreen', error: error, stackTrace: stackTrace);
          return ModernComponents.modernErrorState(
            title: 'Error Loading Patients',
            subtitle: 'Could not load patient list. Please try again.',
            onButtonPressed: _refreshPatients,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreatePatient(context),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isSearching) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSearching ? Icons.search_off : Icons.personal_injury,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 24),
            Text(
              isSearching ? 'No matching patients found' : 'No patients yet',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              isSearching
                  ? 'Try adjusting your search query.'
                  : 'Create your first patient record to get started!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (!isSearching)
              ElevatedButton.icon(
                onPressed: () => _navigateToCreatePatient(context),
                icon: const Icon(Icons.add),
                label: const Text('Add Patient'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String patientId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Patient'),
        content: const Text('Are you sure you want to delete this patient record? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deletePatient(context, patientId);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class PatientCard extends StatelessWidget {
  final Patient patient;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PatientCard({
    super.key,
    required this.patient,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          patient.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (patient.dateOfBirth != null)
                          Text(
                            'DOB: ${patient.dateOfBirth}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        onEdit();
                      } else if (value == 'delete') {
                        onDelete();
                      } else if (value == 'appointment') {
                        // Navigate to create task with HEALTH_BEAUTY__APPOINTMENT tag
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateTaskScreen(
                              initialTagCode: 'HEALTH_BEAUTY__APPOINTMENT',
                              initialCategoryName: 'Health & Beauty',
                              initialSubcategoryName: 'Appointment',
                              entityId: patient.id,
                            ),
                          ),
                        );
                      } else if (value == 'medication') {
                        // Navigate to create task with HEALTH_BEAUTY__MEDICATION tag
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateTaskScreen(
                              initialTagCode: 'HEALTH_BEAUTY__MEDICATION',
                              initialCategoryName: 'Health & Beauty',
                              initialSubcategoryName: 'Medication',
                              entityId: patient.id,
                            ),
                          ),
                        );
                      } else if (value == 'fitness') {
                        // Navigate to create task with HEALTH_BEAUTY__FITNESS tag
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateTaskScreen(
                              initialTagCode: 'HEALTH_BEAUTY__FITNESS',
                              initialCategoryName: 'Health & Beauty',
                              initialSubcategoryName: 'Fitness Goal',
                              entityId: patient.id,
                            ),
                          ),
                        );
                      } else if (value == 'checkup') {
                        // Navigate to create task with HEALTH_BEAUTY__CHECKUP tag
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateTaskScreen(
                              initialTagCode: 'HEALTH_BEAUTY__CHECKUP',
                              initialCategoryName: 'Health & Beauty',
                              initialSubcategoryName: 'Medical Checkup',
                              entityId: patient.id,
                            ),
                          ),
                        );
                      } else if (value == 'i_want_to') {
                        // Show the I WANT TO menu
                        IWantToMenu.show(
                          context: context,
                          entity: patient,
                          onTagSelected: (tag, category, subcategory) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateTaskScreen(
                                  initialTagCode: tag,
                                  initialCategoryName: category,
                                  initialSubcategoryName: subcategory,
                                  entityId: patient.id,
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'appointment',
                        child: ListTile(
                          leading: Icon(Icons.calendar_today),
                          title: Text('Schedule Appointment'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'medication',
                        child: ListTile(
                          leading: Icon(Icons.medication),
                          title: Text('Add Medication'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'fitness',
                        child: ListTile(
                          leading: Icon(Icons.fitness_center),
                          title: Text('Add Fitness Goal'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'checkup',
                        child: ListTile(
                          leading: Icon(Icons.health_and_safety),
                          title: Text('Schedule Checkup'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'i_want_to',
                        child: ListTile(
                          leading: Icon(Icons.lightbulb_outline),
                          title: Text('I WANT TO...'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'edit',
                        child: ListTile(
                          leading: Icon(Icons.edit),
                          title: Text('Edit Patient'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: ListTile(
                          leading: Icon(Icons.delete, color: Colors.red),
                          title: Text('Delete', style: TextStyle(color: Colors.red)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (patient.description != null && patient.description!.isNotEmpty)
                Text(
                  patient.description!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 8),
              // Medical conditions
              if (patient.medicalConditions != null && patient.medicalConditions!.isNotEmpty) ...[
                Row(
                  children: [
                    Icon(
                      Icons.medical_information,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        patient.medicalConditions!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
              ],
              // Primary doctor
              if (patient.primaryDoctor != null && patient.primaryDoctor!.isNotEmpty) ...[
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Dr. ${patient.primaryDoctor!}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
              ],
              // Last checkup
              if (patient.lastCheckup != null) ...[
                Row(
                  children: [
                    Icon(
                      Icons.event_available,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Last checkup: ${_formatDate(patient.lastCheckup!)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
              // Blood type chip if available
              if (patient.bloodType != null && patient.bloodType!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Blood type: ${patient.bloodType!}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.red.shade700,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }
}
