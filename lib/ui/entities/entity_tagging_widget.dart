import 'package:flutter/material.dart';
import '../../models/entity_model.dart';
import '../../models/reference_model.dart';
import '../../models/reference_group_model.dart';

// Widget for displaying and managing entity tags
class EntityTaggingWidget extends StatefulWidget {
  final BaseEntityModel entity;
  final ValueChanged<List<ReferenceModel>> onTagsChanged;

  const EntityTaggingWidget({super.key, required this.entity, required this.onTagsChanged});

  @override
  EntityTaggingWidgetState createState() => EntityTaggingWidgetState();
}

class EntityTaggingWidgetState extends State<EntityTaggingWidget> {
  List<ReferenceModel> _selectedTags = [];
  List<ReferenceGroupModel> _referenceGroups = [];
  List<ReferenceModel> _availableReferences = [];

  @override
  void initState() {
    super.initState();
    // BaseEntityModel does not have a direct 'references' field.
    // Tags should be fetched based on entity.id or passed in if already loaded.
    // For now, initialize as empty and add a TODO.
    _selectedTags = []; 
    // TODO: If widget.entity.id is valid (i.e., editing an existing entity), 
    // fetch its currently associated tags and populate _selectedTags.
    // This might involve calling a repository method like `fetchTagsForEntity(widget.entity.id)`.
    // Example: if (widget.entity.id != 0 && widget.entity.id != null) { _fetchEntityTags(widget.entity.id); }
    
    _fetchReferenceData(); // This fetches all available tags/groups for selection.
  }

  Future<void> _fetchReferenceData() async {
    // TODO: Use EntityRepository to fetch reference groups and references
    // For now, using dummy data
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
    setState(() {
      _referenceGroups = [
        ReferenceGroupModel(id: 'group1', name: 'Colors', createdAt: DateTime.now(), updatedAt: DateTime.now()),
        ReferenceGroupModel(id: 'group2', name: 'Status', createdAt: DateTime.now(), updatedAt: DateTime.now()),
      ];
      _availableReferences = [
        ReferenceModel(id: 'ref1', groupId: 'group1', name: 'Red', createdAt: DateTime.now(), updatedAt: DateTime.now()),
        ReferenceModel(id: 'ref2', groupId: 'group1', name: 'Blue', createdAt: DateTime.now(), updatedAt: DateTime.now()),
        ReferenceModel(id: 'ref3', groupId: 'group2', name: 'Open', createdAt: DateTime.now(), updatedAt: DateTime.now()),
        ReferenceModel(id: 'ref4', groupId: 'group2', name: 'Closed', createdAt: DateTime.now(), updatedAt: DateTime.now()),
      ];
    });
  }

  void _toggleTag(ReferenceModel tag) {
    setState(() {
      if (_selectedTags.any((t) => t.id == tag.id)) {
        _selectedTags.removeWhere((t) => t.id == tag.id);
      } else {
        _selectedTags.add(tag);
      }
    });
    widget.onTagsChanged(_selectedTags);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tags:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 8.0,
          children: _selectedTags.map((tag) => Chip(label: Text(tag.name))).toList(),
        ),
        SizedBox(height: 16),
        Text('Available Tags:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        // Fixed ExpansionTile with proper null checks
        ..._referenceGroups.map((group) {
          final referencesInGroup = _availableReferences.where((ref) => ref.groupId == group.id).toList();
          return ExpansionTile(
            title: Text(group.name),
            children: referencesInGroup.map((ref) {
              final isSelected = _selectedTags.any((t) => t.id == ref.id);
              return CheckboxListTile(
                title: Text(ref.name),
                value: isSelected,
                onChanged: (bool? value) {
                  _toggleTag(ref);
                },
              );
            }).toList(),
          );
        }),
      ],
    );
  }
}
