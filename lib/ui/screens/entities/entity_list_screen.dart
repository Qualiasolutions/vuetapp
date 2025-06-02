import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/entity_model.dart';
import 'package:vuet_app/models/entity_subcategory_model.dart';
import 'package:vuet_app/providers/entity_providers.dart';
import 'package:vuet_app/providers/entity_subcategory_providers.dart';
import 'package:vuet_app/ui/screens/entities/create_entity_screen.dart';
import 'package:vuet_app/ui/screens/entities/entity_detail_screen.dart';
import 'package:vuet_app/ui/widgets/entity_card.dart';
import 'package:vuet_app/utils/logger.dart';

class EntityListScreen extends ConsumerStatefulWidget {
  final int? appCategoryId;
  final String? categoryId;
  final String? subcategoryId;
  final String categoryName;
  final EntitySubtype? defaultSubtypeForNew;

  const EntityListScreen({
    super.key,
    this.appCategoryId,
    this.categoryId,
    this.subcategoryId,
    required this.categoryName,
    this.defaultSubtypeForNew,
  });

  @override
  _EntityListScreenState createState() => _EntityListScreenState();
}

class _EntityListScreenState extends ConsumerState<EntityListScreen> {
  String? _selectedSubcategoryId;
  List<EntitySubcategoryModel> _subcategories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedSubcategoryId = widget.subcategoryId;
    
    // Load subcategories if we have a category ID
    if (widget.categoryId != null) {
      _loadSubcategories();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadSubcategories() async {
    if (widget.categoryId == null) return;
    
    try {
      final subcategories = await ref.read(subcategoriesByCategoryProvider(widget.categoryId!).future);
      setState(() {
        _subcategories = subcategories;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading subcategories: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToCreateEntity() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateEntityScreen(
          initialSubtype: widget.defaultSubtypeForNew,
          initialCategoryId: widget.appCategoryId?.toString(),
        ),
      ),
    );

    if (result != null) {
      // Refresh the entities list
      ref.refresh(entitiesByCategoryProvider(widget.appCategoryId ?? 0));
    }
  }

  void _navigateToEntityDetails(BaseEntityModel entity) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EntityDetailScreen(
          entityId: entity.id!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // If we have both a subcategory ID and an app category ID, use that for filtering
    final entities = ref.watch(
      _selectedSubcategoryId != null && widget.appCategoryId != null
          ? entitiesBySubcategoryProvider((widget.appCategoryId!, _selectedSubcategoryId!))
          : entitiesByCategoryProvider(widget.appCategoryId ?? 0)
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.categoryName} Entities'),
      ),
      body: Column(
        children: [
          // Only show subcategories dropdown if we have subcategories
          if (_subcategories.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Filter by Subcategory',
                  border: OutlineInputBorder(),
                ),
                value: _selectedSubcategoryId,
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('All Subcategories'),
                  ),
                  ..._subcategories.map((subcategory) => DropdownMenuItem<String>(
                    value: subcategory.id,
                    child: Text(subcategory.displayName),
                  )),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedSubcategoryId = value;
                  });
                },
              ),
            ),
          
          Expanded(
            child: entities.when(
              data: (data) {
                if (data.isEmpty) {
                  return const Center(
                    child: Text('No entities found. Create one with the + button below.'),
                  );
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final entity = data[index];
                    return EntityCard(
                      entity: entity,
                      onTap: () => _navigateToEntityDetails(entity),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Error loading entities: $error'),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateEntity,
        child: const Icon(Icons.add),
      ),
    );
  }
}
