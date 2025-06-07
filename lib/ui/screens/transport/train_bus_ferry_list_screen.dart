import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/theme_config.dart';
import '../../../ui/shared/widgets.dart';
import '../../../models/transport_entities.dart';
import 'package:go_router/go_router.dart';

class TrainBusFerryListScreen extends ConsumerStatefulWidget {
  const TrainBusFerryListScreen({super.key});

  @override
  ConsumerState<TrainBusFerryListScreen> createState() => _TrainBusFerryListScreenState();
}

class _TrainBusFerryListScreenState extends ConsumerState<TrainBusFerryListScreen> {
  // Sample data for now - will be replaced with Supabase MCP integration
  List<TrainBusFerry> _journeys = [
    TrainBusFerry(
      id: 1,
      name: 'London to Paris',
      transportType: 'Train',
      operator: 'Eurostar',
      routeNumber: 'ES9142',
      departureStation: 'London St Pancras',
      arrivalStation: 'Paris Gare du Nord',
      departureTime: DateTime(2025, 7, 15, 9, 30),
      arrivalTime: DateTime(2025, 7, 15, 12, 47),
    ),
    TrainBusFerry(
      id: 2,
      name: 'Dover to Calais Ferry',
      transportType: 'Ferry',
      operator: 'P&O Ferries',
      departureStation: 'Dover',
      arrivalStation: 'Calais',
      departureTime: DateTime(2025, 8, 20, 14, 15),
      arrivalTime: DateTime(2025, 8, 20, 16, 45),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VuetHeader('Train/Bus/Ferry'),
      floatingActionButton: VuetFAB(
        onPressed: () => context.go('/categories/transport/transit/create'),
        tooltip: 'Add Journey',
      ),
      body: _journeys.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _journeys.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _buildJourneyCard(_journeys[index]),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.directions_transit,
            size: 64,
            color: AppColors.steel,
          ),
          const SizedBox(height: 16),
          Text(
            'No journeys yet',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.steel,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add your first journey',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.steel,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJourneyCard(TrainBusFerry journey) {
    return Card(
      color: AppColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.steel.withOpacity(0.2)),
      ),
      child: InkWell(
        onTap: () => _showJourneyDetails(journey),
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
                          journey.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkJungleGreen,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.mediumTurquoise.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.mediumTurquoise.withOpacity(0.3)),
                              ),
                              child: Text(
                                journey.transportType,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.mediumTurquoise,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            if (journey.operator != null) ...[
                              const SizedBox(width: 8),
                              Text(
                                journey.operator!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.steel,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) => _handleMenuAction(value, journey),
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
              
              // Journey details
              if (journey.departureStation != null && journey.arrivalStation != null)
                _buildRouteRow(journey.departureStation!, journey.arrivalStation!),
              
              if (journey.departureTime != null && journey.arrivalTime != null) ...[
                const SizedBox(height: 8),
                _buildTimeRow(journey.departureTime!, journey.arrivalTime!),
              ],
              
              if (journey.routeNumber != null) ...[
                const SizedBox(height: 8),
                _buildInfoRow('Route', journey.routeNumber!),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRouteRow(String departure, String arrival) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'From',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.steel,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                departure,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.darkJungleGreen,
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.arrow_forward,
          color: AppColors.steel,
          size: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'To',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.steel,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                arrival,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.darkJungleGreen,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeRow(DateTime departure, DateTime arrival) {
    final departureStr = '${departure.hour.toString().padLeft(2, '0')}:${departure.minute.toString().padLeft(2, '0')}';
    final arrivalStr = '${arrival.hour.toString().padLeft(2, '0')}:${arrival.minute.toString().padLeft(2, '0')}';
    final duration = arrival.difference(departure);
    final durationStr = '${duration.inHours}h ${duration.inMinutes % 60}m';
    
    return Row(
      children: [
        Text(
          'Departure: ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.steel,
          ),
        ),
        Text(
          departureStr,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.darkJungleGreen,
          ),
        ),
        const SizedBox(width: 16),
        Text(
          'Arrival: ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.steel,
          ),
        ),
        Text(
          arrivalStr,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.darkJungleGreen,
          ),
        ),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            durationStr,
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

  void _showJourneyDetails(TrainBusFerry journey) {
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
                journey.name,
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
                    _buildDetailRow('Transport Type', journey.transportType),
                    if (journey.operator != null)
                      _buildDetailRow('Operator', journey.operator!),
                    if (journey.routeNumber != null)
                      _buildDetailRow('Route Number', journey.routeNumber!),
                    if (journey.departureStation != null)
                      _buildDetailRow('Departure Station', journey.departureStation!),
                    if (journey.arrivalStation != null)
                      _buildDetailRow('Arrival Station', journey.arrivalStation!),
                    if (journey.departureTime != null)
                      _buildDetailRow('Departure Time', journey.departureTime!.toString()),
                    if (journey.arrivalTime != null)
                      _buildDetailRow('Arrival Time', journey.arrivalTime!.toString()),
                    if (journey.notes != null && journey.notes!.isNotEmpty)
                      _buildDetailRow('Notes', journey.notes!),
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
                        context.go('/categories/transport/transit/edit/${journey.id}');
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

  void _handleMenuAction(String action, TrainBusFerry journey) {
    switch (action) {
      case 'edit':
        context.go('/categories/transport/transit/edit/${journey.id}');
        break;
      case 'delete':
        _showDeleteConfirmation(journey);
        break;
    }
  }

  void _showDeleteConfirmation(TrainBusFerry journey) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Journey'),
        content: Text('Are you sure you want to delete "${journey.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteJourney(journey);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _deleteJourney(TrainBusFerry journey) {
    setState(() {
      _journeys.removeWhere((j) => j.id == journey.id);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${journey.name} deleted'),
        backgroundColor: AppColors.mediumTurquoise,
        action: SnackBarAction(
          label: 'Undo',
          textColor: AppColors.white,
          onPressed: () {
            setState(() {
              _journeys.add(journey);
            });
          },
        ),
      ),
    );
  }
}
