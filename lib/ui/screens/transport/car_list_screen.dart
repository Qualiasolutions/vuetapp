import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/theme_config.dart';
import '../../../ui/shared/widgets.dart';
import '../../../models/transport_entities.dart';
import 'package:go_router/go_router.dart';

class CarListScreen extends ConsumerStatefulWidget {
  const CarListScreen({super.key});

  @override
  ConsumerState<CarListScreen> createState() => _CarListScreenState();
}

class _CarListScreenState extends ConsumerState<CarListScreen> {
  // Sample data for now - will be replaced with Supabase MCP integration
  List<Car> _cars = [
    Car(
      id: 1,
      name: 'Family Car',
      make: 'Toyota',
      model: 'Camry',
      registration: 'ABC123',
      motDueDate: DateTime(2025, 6, 15),
      insuranceDueDate: DateTime(2025, 8, 20),
      serviceDueDate: DateTime(2025, 4, 10),
    ),
    Car(
      id: 2,
      name: 'Work Car',
      make: 'Honda',
      model: 'Civic',
      registration: 'XYZ789',
      motDueDate: DateTime(2025, 9, 30),
      insuranceDueDate: DateTime(2025, 12, 5),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VuetHeader('Cars'),
      floatingActionButton: VuetFAB(
        onPressed: () => context.go('/categories/transport/cars/create'),
        tooltip: 'Add Car',
      ),
      body: _cars.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _cars.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _buildCarCard(_cars[index]),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.directions_car,
            size: 64,
            color: AppColors.steel,
          ),
          const SizedBox(height: 16),
          Text(
            'No cars yet',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.steel,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add your first car',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.steel,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarCard(Car car) {
    return Card(
      color: AppColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.steel.withOpacity(0.2)),
      ),
      child: InkWell(
        onTap: () => _showCarDetails(car),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with name and actions
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          car.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkJungleGreen,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${car.make} ${car.model}',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.steel,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) => _handleMenuAction(value, car),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Registration
              _buildInfoRow('Registration', car.registration),
              
              // Due dates with color coding
              if (car.motDueDate != null) ...[
                const SizedBox(height: 8),
                _buildDueDateRow('MOT Due', car.motDueDate!),
              ],
              
              if (car.insuranceDueDate != null) ...[
                const SizedBox(height: 8),
                _buildDueDateRow('Insurance Due', car.insuranceDueDate!),
              ],
              
              if (car.serviceDueDate != null) ...[
                const SizedBox(height: 8),
                _buildDueDateRow('Service Due', car.serviceDueDate!),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.steel,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.darkJungleGreen,
          ),
        ),
      ],
    );
  }

  Widget _buildDueDateRow(String label, DateTime dueDate) {
    final now = DateTime.now();
    final daysUntilDue = dueDate.difference(now).inDays;
    
    Color statusColor;
    String statusText;
    
    if (daysUntilDue < 0) {
      statusColor = Colors.red;
      statusText = 'Overdue';
    } else if (daysUntilDue <= 30) {
      statusColor = AppColors.orange;
      statusText = 'Due soon';
    } else {
      statusColor = AppColors.mediumTurquoise;
      statusText = 'OK';
    }
    
    return Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.steel,
          ),
        ),
        Text(
          dueDate.toIso8601String().split('T')[0],
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.darkJungleGreen,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: statusColor.withOpacity(0.3)),
          ),
          child: Text(
            statusText,
            style: TextStyle(
              fontSize: 12,
              color: statusColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  void _showCarDetails(Car car) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.steel,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Title
              Text(
                car.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkJungleGreen,
                ),
              ),
              const SizedBox(height: 20),
              
              // Details
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    _buildDetailRow('Make', car.make),
                    _buildDetailRow('Model', car.model),
                    _buildDetailRow('Registration', car.registration),
                    if (car.motDueDate != null)
                      _buildDetailRow('MOT Due', car.motDueDate!.toIso8601String().split('T')[0]),
                    if (car.insuranceDueDate != null)
                      _buildDetailRow('Insurance Due', car.insuranceDueDate!.toIso8601String().split('T')[0]),
                    if (car.serviceDueDate != null)
                      _buildDetailRow('Service Due', car.serviceDueDate!.toIso8601String().split('T')[0]),
                    if (car.taxDueDate != null)
                      _buildDetailRow('Tax Due', car.taxDueDate!.toIso8601String().split('T')[0]),
                    if (car.warrantyDueDate != null)
                      _buildDetailRow('Warranty Due', car.warrantyDueDate!.toIso8601String().split('T')[0]),
                    if (car.notes != null && car.notes!.isNotEmpty)
                      _buildDetailRow('Notes', car.notes!),
                  ],
                ),
              ),
              
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.go('/categories/transport/cars/edit/${car.id}');
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.mediumTurquoise),
                      ),
                      child: const Text('Edit', style: TextStyle(color: AppColors.mediumTurquoise)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: VuetSaveButton(
                      text: 'Close',
                      onPressed: () => Navigator.pop(context),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.steel,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.darkJungleGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(String action, Car car) {
    switch (action) {
      case 'edit':
        context.go('/categories/transport/cars/edit/${car.id}');
        break;
      case 'delete':
        _showDeleteConfirmation(car);
        break;
    }
  }

  void _showDeleteConfirmation(Car car) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Car'),
        content: Text('Are you sure you want to delete "${car.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteCar(car);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _deleteCar(Car car) {
    setState(() {
      _cars.removeWhere((c) => c.id == car.id);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${car.name} deleted'),
        backgroundColor: AppColors.mediumTurquoise,
        action: SnackBarAction(
          label: 'Undo',
          textColor: AppColors.white,
          onPressed: () {
            setState(() {
              _cars.add(car);
            });
          },
        ),
      ),
    );
  }
}
