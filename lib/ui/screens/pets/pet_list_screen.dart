import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/theme_config.dart';
import '../../../ui/shared/widgets.dart';
import '../../../models/pet_entities.dart';
import 'package:go_router/go_router.dart';

class PetListScreen extends ConsumerStatefulWidget {
  const PetListScreen({super.key});

  @override
  ConsumerState<PetListScreen> createState() => _PetListScreenState();
}

class _PetListScreenState extends ConsumerState<PetListScreen> {
  // Sample data for now - will be replaced with Supabase MCP integration
  List<Pet> _pets = [
    Pet(
      id: 1,
      name: 'Buddy',
      type: 'Dog',
      breed: 'Golden Retriever',
      dob: DateTime(2020, 3, 15),
      microchipNumber: '123456789012345',
    ),
    Pet(
      id: 2,
      name: 'Whiskers',
      type: 'Cat',
      breed: 'Persian',
      dob: DateTime(2019, 8, 22),
      notes: 'Very friendly and loves treats',
    ),
    Pet(
      id: 3,
      name: 'Charlie',
      type: 'Bird',
      breed: 'Cockatiel',
      dob: DateTime(2021, 1, 10),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VuetHeader('Pets'),
      floatingActionButton: VuetFAB(
        onPressed: () => context.go('/categories/pets/pets/create'),
        tooltip: 'Add Pet',
      ),
      body: _pets.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _pets.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _buildPetCard(_pets[index]),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.pets,
            size: 64,
            color: AppColors.steel,
          ),
          const SizedBox(height: 16),
          Text(
            'No pets yet',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.steel,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add your first pet',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.steel,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPetCard(Pet pet) {
    return Card(
      color: AppColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.steel.withValues(alpha: 0.2)),
      ),
      child: InkWell(
        onTap: () => _showPetDetails(pet),
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
                          pet.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkJungleGreen,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          pet.type,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.steel,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Pet type icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.mediumTurquoise.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getPetIcon(pet.type),
                      color: AppColors.mediumTurquoise,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 8),
                  PopupMenuButton<String>(
                    onSelected: (value) => _handleMenuAction(value, pet),
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
              
              // Pet details
              if (pet.breed != null && pet.breed!.isNotEmpty)
                _buildInfoRow('Breed', pet.breed!),
              
              if (pet.dob != null) ...[
                const SizedBox(height: 8),
                _buildInfoRow('Date of Birth', pet.dob!.toIso8601String().split('T')[0]),
                const SizedBox(height: 8),
                _buildAgeRow(pet.dob!),
              ],
              
              if (pet.microchipNumber != null && pet.microchipNumber!.isNotEmpty) ...[
                const SizedBox(height: 8),
                _buildInfoRow('Microchip', pet.microchipNumber!),
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
    );
  }

  Widget _buildAgeRow(DateTime dob) {
    final now = DateTime.now();
    final age = now.difference(dob);
    final years = (age.inDays / 365).floor();
    final months = ((age.inDays % 365) / 30).floor();
    
    String ageText;
    if (years > 0) {
      ageText = '$years year${years == 1 ? '' : 's'}';
      if (months > 0) {
        ageText += ', $months month${months == 1 ? '' : 's'}';
      }
    } else if (months > 0) {
      ageText = '$months month${months == 1 ? '' : 's'}';
    } else {
      ageText = '${age.inDays} day${age.inDays == 1 ? '' : 's'}';
    }
    
    return Row(
      children: [
        Text(
          'Age: ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.steel,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.orange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.orange.withValues(alpha: 0.3)),
          ),
          child: Text(
            ageText,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.orange,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  IconData _getPetIcon(String petType) {
    switch (petType.toLowerCase()) {
      case 'dog':
        return Icons.pets;
      case 'cat':
        return Icons.pets;
      case 'bird':
        return Icons.flutter_dash;
      case 'fish':
        return Icons.water;
      case 'rabbit':
        return Icons.cruelty_free;
      default:
        return Icons.pets;
    }
  }

  void _showPetDetails(Pet pet) {
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
              
              // Title with icon
              Row(
                children: [
                  Icon(
                    _getPetIcon(pet.type),
                    color: AppColors.mediumTurquoise,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      pet.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkJungleGreen,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Details
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    _buildDetailRow('Type', pet.type),
                    if (pet.breed != null && pet.breed!.isNotEmpty)
                      _buildDetailRow('Breed', pet.breed!),
                    if (pet.dob != null)
                      _buildDetailRow('Date of Birth', pet.dob!.toIso8601String().split('T')[0]),
                    if (pet.microchipNumber != null && pet.microchipNumber!.isNotEmpty)
                      _buildDetailRow('Microchip Number', pet.microchipNumber!),
                    if (pet.notes != null && pet.notes!.isNotEmpty)
                      _buildDetailRow('Notes', pet.notes!),
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
                        context.go('/categories/pets/pets/edit/${pet.id}');
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

  void _handleMenuAction(String action, Pet pet) {
    switch (action) {
      case 'edit':
        context.go('/categories/pets/pets/edit/${pet.id}');
        break;
      case 'delete':
        _showDeleteConfirmation(pet);
        break;
    }
  }

  void _showDeleteConfirmation(Pet pet) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Pet'),
        content: Text('Are you sure you want to delete "${pet.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deletePet(pet);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _deletePet(Pet pet) {
    setState(() {
      _pets.removeWhere((p) => p.id == pet.id);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${pet.name} deleted'),
        backgroundColor: AppColors.mediumTurquoise,
        action: SnackBarAction(
          label: 'Undo',
          textColor: AppColors.white,
          onPressed: () {
            setState(() {
              _pets.add(pet);
            });
          },
        ),
      ),
    );
  }
}
