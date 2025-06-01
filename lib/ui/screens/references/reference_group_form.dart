import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/reference_group_model.dart';
import 'package:vuet_app/providers/reference_providers.dart';

class ReferenceGroupForm extends ConsumerStatefulWidget {
  final ReferenceGroupModel? initialData;
  final Function(String) onSaved;
  
  const ReferenceGroupForm({
    super.key,
    this.initialData,
    required this.onSaved,
  });
  
  @override
  ConsumerState<ReferenceGroupForm> createState() => _ReferenceGroupFormState();
}

class _ReferenceGroupFormState extends ConsumerState<ReferenceGroupForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialData?.name ?? '');
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.initialData == null ? 'Create Reference Group' : 'Edit Reference Group',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Group Name',
              hintText: 'Enter group name (e.g., "Colors", "Status")',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.folder),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a group name';
              }
              if (value.trim().length < 2) {
                return 'Group name must be at least 2 characters';
              }
              return null;
            },
            autofocus: true,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveReferenceGroup,
                child: _isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(widget.initialData == null ? 'Create' : 'Update'),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Future<void> _saveReferenceGroup() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      try {
        if (widget.initialData == null) {
          // Create new reference group
          final id = await ref.read(referenceGroupNotifierProvider.notifier)
              .createReferenceGroup(
                name: _nameController.text.trim(),
              );
          
          if (mounted) {
            widget.onSaved(id);
          }
        } else {
          // Update existing reference group
          final updatedGroup = widget.initialData!.copyWith(
            name: _nameController.text.trim(),
            updatedAt: DateTime.now(),
          );
          
          await ref.read(referenceGroupNotifierProvider.notifier)
              .updateReferenceGroup(updatedGroup);
          
          if (mounted) {
            widget.onSaved(widget.initialData!.id);
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error saving reference group: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
} 