import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/entity_model.dart';
import 'package:vuet_app/providers/entity_providers.dart';
import 'package:vuet_app/services/auth_service.dart'; // For userId
import 'package:vuet_app/ui/widgets/entities/dynamic_entity_form.dart';
import 'package:vuet_app/utils/logger.dart';

class EntityUpsertScreen extends ConsumerStatefulWidget {
  final BaseEntityModel? entity; // If null, creating new entity
  final EntitySubtype entitySubtype; // Required for creating, can be derived from entity if editing
  final int? appCategoryId; // Optional: To pre-select category when creating

  const EntityUpsertScreen({
    super.key,
    this.entity,
    required this.entitySubtype,
    this.appCategoryId,
  });

  @override
  ConsumerState<EntityUpsertScreen> createState() => _EntityUpsertScreenState();
}

class _EntityUpsertScreenState extends ConsumerState<EntityUpsertScreen> {
  final _formKey = GlobalKey<FormState>();

  String get _subtypeDisplayName {
    return widget.entitySubtype.toString().split('.').last.replaceAllMapped(RegExp(r'[A-Z]'), (match) => ' ${match.group(0)}').trim();
  }

  Future<void> _saveEntity(
      Map<String, dynamic> customFieldsData, 
      int? appCategoryId, 
      String name, 
      String description) async {
    
    final userId = ref.read(authServiceProvider).currentUser?.id;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: User not authenticated.')),
      );
      return;
    }

    final entityNotifier = ref.read(entityActionsProvider.notifier);

    final entityToSave = BaseEntityModel(
      id: widget.entity?.id, // Null if creating
      name: name,
      description: description,
      userId: userId,
      appCategoryId: appCategoryId,
      subtype: widget.entity?.subtype ?? widget.entitySubtype, // Use initial subtype if editing
      customFields: customFieldsData,
      createdAt: widget.entity?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(), // Always update timestamp
      // Other fields like imageUrl, parentId, isHidden, attachments, dueDate, status can be added later or handled by specific subtypes
    );

    try {
      if (widget.entity == null) {
        await entityNotifier.createEntity(entityToSave);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$_subtypeDisplayName created successfully!')),
        );
      } else {
        await entityNotifier.updateEntity(entityToSave);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$_subtypeDisplayName updated successfully!')),
        );
      }
      if (mounted) {
        Navigator.of(context).pop(); // Pop after save
      }
    } catch (e, s) {
      log('Error saving entity: $e', name: 'EntityUpsertScreen', error: e, stackTrace: s);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving $_subtypeDisplayName: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final entityActionsState = ref.watch(entityActionsProvider);
    final bool isLoading = entityActionsState is AsyncLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entity == null ? 'Create $_subtypeDisplayName' : 'Edit ${widget.entity!.name}'),
        actions: [
          if (isLoading)
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
            ),
        ],
      ),
      body: IgnorePointer(
        ignoring: isLoading,
        child: DynamicEntityForm(
          key: ValueKey('${widget.entitySubtype}_${widget.entity?.id ?? 'new'}'), // Ensure form rebuilds if subtype/entity changes
          formKey: _formKey,
          entitySubtype: widget.entity?.subtype ?? widget.entitySubtype,
          initialEntity: widget.entity,
          selectedCategoryId: widget.appCategoryId,
          onSave: _saveEntity,
        ),
      ),
    );
  }
}
