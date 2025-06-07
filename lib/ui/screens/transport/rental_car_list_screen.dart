import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/theme_config.dart';
import '../../../ui/shared/widgets.dart';
import '../../../models/transport_entities.dart';
import 'package:go_router/go_router.dart';

class RentalCarListScreen extends ConsumerStatefulWidget {
  const RentalCarListScreen({super.key});

  @override
  ConsumerState<RentalCarListScreen> createState() => _RentalCarListScreenState();
}

class _RentalCarListScreenState extends ConsumerState<RentalCarListScreen> {
  // Sample data for now - will be replaced with Supabase MCP integration
  List<RentalCar> _rentalCars = [
    RentalCar(
      id: 1,
      name: 'Holiday Car Rental',
      rentalCompany: 'Hertz',
      make: 'Toyota',
      model: 'Corolla',
      registration: 'RNT123',
      pickupDate: DateTime(2025, 7, 10),
      returnDate: DateTime(2025, 7, 17),
      pickupLocation: 'London Heathrow Airport',
      returnLocation: 'London Heathrow Airport',
      totalCost: 280.50,
    ),
    RentalCar(
      id: 2,
      name: 'Business Trip Car',
      rentalCompany: 'Enterprise',
      make: 'BMW',
      model: '3 Series',
      pickupDate: DateTime(2025, 8, 5),
      returnDate: DateTime(2025, 8, 8),
      pickupLocation: 'Manchester City Centre',
      returnLocation: 'Manchester Airport',
      totalCost: 450.00,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VuetHeader('Rental Cars'),
      floatingActionButton: VuetFAB(
        onPressed: () => context.go('/categories/transport/rentals/create'),
        tooltip: 'Add Rental Car',
      ),
      body: _rentalCars.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _rentalCars.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _buildRentalCarCard(_rentalCars[index]),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.car_rental,
            size: 64,
            color: AppColors.steel,
          ),
          const SizedBox(height: 16),
          Text(
            'No rental cars yet',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.steel,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add your first rental',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.steel,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRentalCarCard(RentalCar rental) {
    final now = DateTime.now();
    final isActive = rental.pickupDate != null && 
                    rental.returnDate != null &&
                    now.isAfter(rental.pickupDate!) && 
                    now.isBefore(rental.returnDate!);
    
    return Card(
      color: AppColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.steel.withOpacity(0.2)),
      ),
      child: InkWell(
        onTap: () => _showRentalDetails(rental),
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
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                rental.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.darkJungleGreen,
                                ),
                              ),
                            ),
                            if (isActive)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.mediumTurquoise.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.mediumTurquoise.withOpacity(0.3)),
                                ),
                                child: Text(
                                  'Active',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.mediumTurquoise,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          rental.rentalCompany,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.steel,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) => _handleMenuAction(value, rental),
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
              
              // Car details
              if (rental.make != null && rental.model != null)
                _buildInfoRow('Vehicle', '${rental.make} ${rental.model}'),
              
              if (rental.registration != null) ...[
                const SizedBox(height: 8),
                _buildInfoRow('Registration', rental.registration!),
              ],
              
              // Rental period
              if (rental.pickupDate != null && rental.returnDate != null) ...[
                const SizedBox(height: 8),
                _buildDateRangeRow(rental.pickupDate!, rental.returnDate!),
              ],
              
              // Cost
              if (rental.totalCost != null) ...[
                const SizedBox(height: 8),
                _buildCostRow(rental.totalCost!),
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

  Widget _buildDateRangeRow(DateTime pickup, DateTime returnDate) {
    final pickupStr = pickup.toIso8601String().split('T')[0];
    final returnStr = returnDate.toIso8601String().split('T')[0];
    final duration = returnDate.difference(pickup).inDays;
    
    return Row(
      children: [
        Text(
          'Period: ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.steel,
          ),
        ),
        Text(
          '$pickupStr to $returnStr',
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.darkJungleGreen,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${duration}d',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.orange,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCostRow(double cost) {
    return Row(
      children: [
        Text(
          'Total Cost: ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.steel,
          ),
        ),
        Text(
          '£${cost.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.darkJungleGreen,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void _showRentalDetails(RentalCar rental) {
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
                rental.name,
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
                    _buildDetailRow('Rental Company', rental.rentalCompany),
                    if (rental.make != null)
                      _buildDetailRow('Make', rental.make!),
                    if (rental.model != null)
                      _buildDetailRow('Model', rental.model!),
                    if (rental.registration != null)
                      _buildDetailRow('Registration', rental.registration!),
                    if (rental.pickupDate != null)
                      _buildDetailRow('Pickup Date', rental.pickupDate!.toIso8601String().split('T')[0]),
                    if (rental.returnDate != null)
                      _buildDetailRow('Return Date', rental.returnDate!.toIso8601String().split('T')[0]),
                    if (rental.pickupLocation != null)
                      _buildDetailRow('Pickup Location', rental.pickupLocation!),
                    if (rental.returnLocation != null)
                      _buildDetailRow('Return Location', rental.returnLocation!),
                    if (rental.totalCost != null)
                      _buildDetailRow('Total Cost', '£${rental.totalCost!.toStringAsFixed(2)}'),
                    if (rental.notes != null && rental.notes!.isNotEmpty)
                      _buildDetailRow('Notes', rental.notes!),
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
                        context.go('/categories/transport/rentals/edit/${rental.id}');
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

  void _handleMenuAction(String action, RentalCar rental) {
    switch (action) {
      case 'edit':
        context.go('/categories/transport/rentals/edit/${rental.id}');
        break;
      case 'delete':
        _showDeleteConfirmation(rental);
        break;
    }
  }

  void _showDeleteConfirmation(RentalCar rental) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Rental Car'),
        content: Text('Are you sure you want to delete "${rental.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteRental(rental);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _deleteRental(RentalCar rental) {
    setState(() {
      _rentalCars.removeWhere((r) => r.id == rental.id);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${rental.name} deleted'),
        backgroundColor: AppColors.mediumTurquoise,
        action: SnackBarAction(
          label: 'Undo',
          textColor: AppColors.white,
          onPressed: () {
            setState(() {
              _rentalCars.add(rental);
            });
          },
        ),
      ),
    );
  }
}
