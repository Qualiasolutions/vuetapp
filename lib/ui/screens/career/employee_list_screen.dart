import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/career_entities.dart';
import 'package:vuet_app/providers/career_providers.dart';
import 'package:vuet_app/ui/shared/widgets.dart';
import 'package:vuet_app/ui/navigation/career_navigator.dart';
import 'package:intl/intl.dart'; // For date formatting

class EmployeeListScreen extends ConsumerWidget {
  const EmployeeListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeesAsync = ref.watch(userEmployeesProvider);

    return Scaffold(
      appBar: const VuetHeader('Employment History'),
      body: employeesAsync.when(
        data: (employees) {
          if (employees.isEmpty) {
            return const Center(child: Text('No employment records yet. Add one!'));
          }
          return ListView.builder(
            itemCount: employees.length,
            itemBuilder: (context, index) {
              final employee = employees[index];
              String dateRange = '';
              if (employee.startDate != null) {
                dateRange = DateFormat.yMMMd().format(employee.startDate!);
                if (employee.isCurrentJob == true) {
                  dateRange += ' - Present';
                } else if (employee.endDate != null) {
                  dateRange += ' - ${DateFormat.yMMMd().format(employee.endDate!)}';
                }
              }

              return ListTile(
                title: Text('${employee.jobTitle} at ${employee.companyName}'),
                subtitle: Text(dateRange),
                trailing: employee.isCurrentJob == true ? const Icon(Icons.work_history, color: Colors.green) : null,
                onTap: () => CareerNavigator.navigateToEmployeeForm(context, employeeId: employee.id),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: ${err.toString()}')),
      ),
      floatingActionButton: VuetFAB(
        onPressed: () => CareerNavigator.navigateToEmployeeForm(context),
      ),
    );
  }
}
