import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/theme_config.dart';
import '../../../ui/shared/widgets.dart';
import '../../../models/transport_entities.dart';
import 'package:go_router/go_router.dart';

class PublicTransportListScreen extends ConsumerStatefulWidget {
  const PublicTransportListScreen({super.key});

  @override
  ConsumerState<PublicTransportListScreen> createState() => _PublicTransportListScreenState();
}

class _PublicTransportListScreenState extends ConsumerState<PublicTransportListScreen> {
  // Sample data for now - will be replaced with Supabase MCP integration
  List<PublicTransport> _publicTransports = [
    PublicTransport(
      id: 1,
      name: 'Daily Bus Route',
      transportType: 'Bus',
      routeNumber: '42',
      operator: 'City Transport',
      notes: 'Regular commute route',
    ),
    PublicTransport(
      id: 2,
      name: 'Metro Line',
      transportType: 'Metro',
      routeNumber: 'Blue Line',
      operator: 'Metro Authority',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VuetHeader('Public Transport'),
      floatingActionButton: VuetFAB(
        onPressed: () => context.go('/categories/transport/public/create'),
        tooltip: 'Add Public Transport',
      ),
      body: _publicTransports.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _publicTransports.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _buildPublicTransportCard(_publicTransports[index]),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.train,
            size: 64,
            color: AppColors.steel,
          ),
          const SizedBox(height: 16),
          Text(
            'No public transport yet',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.steel,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add your first route',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.steel,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPublicTransportCard(PublicTransport transport) {
    return Card(
      color: AppColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.steel.withOpacity(0.2)),
      ),
      child: InkWell(
        onTap: () => _showTransportDetails(transport),
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
                          transport.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkJungleGreen,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          transport.transportType,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.steel,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) => _handleMenuAction(value, transport),
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
              
              // Route and operator info
              if (transport.routeNumber != null)
                _buildInfoRow('Route', transport.routeNumber!),
              
              if (transport.operator != null) ...[
                const SizedBox(height: 8),
                _buildInfoRow('Operator', transport.operator!),
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

  void _showTransportDetails(PublicTransport transport) {
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
                transport.name,
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
                    _buildDetailRow('Transport Type', transport.transportType),
                    if (transport.routeNumber != null)
                      _buildDetailRow('Route Number', transport.routeNumber!),
                    if (transport.operator != null)
                      _buildDetailRow('Operator', transport.operator!),
                    if (transport.notes != null && transport.notes!.isNotEmpty)
                      _buildDetailRow('Notes', transport.notes!),
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
                        context.go('/categories/transport/public/edit/${transport.id}');
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

  void _handleMenuAction(String action, PublicTransport transport) {
    switch (action) {
      case 'edit':
        context.go('/categories/transport/public/edit/${transport.id}');
        break;
      case 'delete':
        _showDeleteConfirmation(transport);
        break;
    }
  }

  void _showDeleteConfirmation(PublicTransport transport) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Public Transport'),
        content: Text('Are you sure you want to delete "${transport.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteTransport(transport);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _deleteTransport(PublicTransport transport) {
    setState(() {
      _publicTransports.removeWhere((t) => t.id == transport.id);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${transport.name} deleted'),
        backgroundColor: AppColors.mediumTurquoise,
        action: SnackBarAction(
          label: 'Undo',
          textColor: AppColors.white,
          onPressed: () {
            setState(() {
              _publicTransports.add(transport);
            });
          },
        ),
      ),
    );
  }
}
