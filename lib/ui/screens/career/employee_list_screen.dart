import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:vuet_app/config/theme_config.dart';
import 'package:vuet_app/models/career_entities.dart'; // Import the Employee model
import 'package:vuet_app/providers/career_providers.dart'; // Assuming this will contain employeeRepositoryProvider
import 'package:vuet_app/providers/entity_providers.dart'; // For entityServiceProvider
import 'package:vuet_app/ui/shared/widgets.dart';
import 'package:vuet_app/ui/widgets/modern_components.dart';
import 'package:vuet_app/ui/screens/career/employee_form_screen.dart'; // Assuming this exists
import 'package:vuet_app/ui/screens/career/employee_detail_screen.dart'; // Assuming this exists
import 'package:vuet_app/utils/logger.dart';
import 'package:vuet_app/models/entity_model.dart'; // For EntitySubtype
import 'package:vuet_app/ui/screens/tasks/create_task_screen.dart'; // For quick actions

// Provider for the search query for employees
final employeeSearchQueryProvider = StateProvider<String>((ref) => '');

// Provider for filtered employees
final filteredEmployeesProvider =
    FutureProvider.family<List<Employee>, String>((ref, searchQuery) async {
  final entityService = ref.watch(entityServiceProvider);
  final allEntities = await entityService.listEntities(
    categoryName: 'CAREER', // Assuming 'CAREER' is the category name for employees
    subtype: EntitySubtype.employee,
  );

  // Cast BaseEntityModel to Employee
  final allEmployees = allEntities.map((e) => Employee.fromJson(e.toJson())).toList();

  if (searchQuery.isEmpty) {
    return allEmployees;
  } else {
    return allEmployees.where((employee) {
      final lowerCaseQuery = searchQuery.toLowerCase();
      return employee.companyName.toLowerCase().contains(lowerCaseQuery) ||
          employee.jobTitle.toLowerCase().contains(lowerCaseQuery) ||
          (employee.responsibilities?.toLowerCase().contains(lowerCaseQuery) ?? false) ||
          (employee.managerName?.toLowerCase().contains(lowerCaseQuery) ?? false);
    }).toList();
  }
});

// Provider for refreshing employee list
final employeeListRefreshProvider = StateProvider<bool>((ref) => false);

class EmployeeListScreen extends ConsumerStatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  ConsumerState<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends ConsumerState<EmployeeListScreen> {
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

  Future<void> _refreshEmployees() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    // Invalidate the provider to force a refresh
    ref.invalidate(employeeListRefreshProvider);
    ref.invalidate(filteredEmployeesProvider(ref.read(employeeSearchQueryProvider)));

    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network delay

    setState(() {
      _isRefreshing = false;
    });
  }

  void _onSearchChanged(String query) {
    ref.read(employeeSearchQueryProvider.notifier).state = query;
  }

  void _navigateToCreateEmployee(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EmployeeFormScreen()),
    ).then((value) {
      if (value == true) {
        _refreshEmployees();
      }
    });
  }

  void _navigateToEditEmployee(BuildContext context, Employee employee) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EmployeeFormScreen(employee: employee)),
    ).then((value) {
      if (value == true) {
        _refreshEmployees();
      }
    });
  }

  Future<void> _deleteEmployee(BuildContext context, String employeeId) async {
    try {
      await ref.read(entityServiceProvider).deleteEntity(employeeId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Employee deleted successfully')),
        );
        _refreshEmployees();
      }
    } catch (e, st) {
      log('Error deleting employee: $e', name: 'EmployeeListScreen', error: e, stackTrace: st);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete employee: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(employeeSearchQueryProvider);
    final employeesAsync = ref.watch(filteredEmployeesProvider(searchQuery));

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        title: const Text('Employees'),
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
                hintText: 'Search employees...',
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
            onPressed: _refreshEmployees,
            tooltip: 'Refresh employees',
          ),
        ],
      ),
      body: employeesAsync.when(
        data: (employees) {
          if (employees.isEmpty) {
            return _buildEmptyState(context, searchQuery.isNotEmpty);
          }
          return RefreshIndicator(
            onRefresh: _refreshEmployees,
            child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: employees.length,
              itemBuilder: (context, index) {
                final employee = employees[index];
                return EmployeeCard(
                  employee: employee,
                  onTap: () => context.go('/career/employees/${employee.id}'), // Navigate to detail
                  onEdit: () => _navigateToEditEmployee(context, employee),
                  onDelete: () => _confirmDelete(context, employee.id!),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          log('Error loading employees: $error', name: 'EmployeeListScreen', error: error, stackTrace: stackTrace);
          return ModernComponents.modernErrorState(
            title: 'Error Loading Employees',
            subtitle: 'Could not load employee list. Please try again.',
            onButtonPressed: _refreshEmployees,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreateEmployee(context),
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
              isSearching ? Icons.search_off : Icons.work,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 24),
            Text(
              isSearching ? 'No matching employees found' : 'No employees yet',
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
                  : 'Create your first employee record to get started!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (!isSearching)
              ElevatedButton.icon(
                onPressed: () => _navigateToCreateEmployee(context),
                icon: const Icon(Icons.add),
                label: const Text('Add Employee'),
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

  void _confirmDelete(BuildContext context, String employeeId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Employee'),
        content: const Text('Are you sure you want to delete this employee record? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteEmployee(context, employeeId);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class EmployeeCard extends StatelessWidget {
  final Employee employee;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const EmployeeCard({
    super.key,
    required this.employee,
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
                          employee.companyName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          employee.jobTitle,
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
                      } else if (value == 'meeting') {
                        context.go('/tasks/create', extra: {
                          'initialTagCode': 'CAREER__MEETING',
                          'initialCategoryName': 'Career',
                          'initialEntityId': employee.id,
                        });
                      } else if (value == 'deadline') {
                        context.go('/tasks/create', extra: {
                          'initialTagCode': 'CAREER__DEADLINE',
                          'initialCategoryName': 'Career',
                          'initialEntityId': employee.id,
                        });
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'meeting',
                        child: ListTile(
                          leading: Icon(Icons.meeting_room),
                          title: Text('Add Meeting'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'deadline',
                        child: ListTile(
                          leading: Icon(Icons.event_busy),
                          title: Text('Add Deadline'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'edit',
                        child: ListTile(
                          leading: Icon(Icons.edit),
                          title: Text('Edit Employee'),
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
              if (employee.responsibilities != null && employee.responsibilities!.isNotEmpty)
                Text(
                  employee.responsibilities!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 8),
              Row(
                children: [
                  // Current/Former job status indicator
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: (employee.isCurrentJob ?? true)
                          ? Colors.green.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      (employee.isCurrentJob ?? true) ? 'Current' : 'Former',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: (employee.isCurrentJob ?? true) ? Colors.green : Colors.grey.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Date range (if available)
                  if (employee.startDate != null) ...[
                    Icon(
                      Icons.date_range,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDateRange(employee.startDate, employee.endDate),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateRange(DateTime? startDate, DateTime? endDate) {
    if (startDate == null) {
      return '';
    }

    final startStr = DateFormat('MMM yyyy').format(startDate);
    
    if (endDate == null) {
      return '$startStr - Present';
    } else {
      final endStr = DateFormat('MMM yyyy').format(endDate);
      return '$startStr - $endStr';
    }
  }
}
