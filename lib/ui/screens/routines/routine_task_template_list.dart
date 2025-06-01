import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:vuet_app/models/routine_task_template_model.dart';
import 'package:vuet_app/providers/routine_providers.dart';

class RoutineTaskTemplateList extends ConsumerStatefulWidget {
  final String routineId;
  final List<RoutineTaskTemplateModel> initialTemplates;

  const RoutineTaskTemplateList({
    super.key,
    required this.routineId,
    required this.initialTemplates,
  });

  @override
  ConsumerState<RoutineTaskTemplateList> createState() => _RoutineTaskTemplateListState();
}

class _RoutineTaskTemplateListState extends ConsumerState<RoutineTaskTemplateList> {
  late List<RoutineTaskTemplateModel> _templates;
  final _uuid = Uuid();

  @override
  void initState() {
    super.initState();
    _templates = List.from(widget.initialTemplates);
  }

  Future<void> _addTaskTemplate() async {
    final result = await _showTemplateDialog();
    if (result != null) {
      setState(() {
        _templates.add(result);
      });
      
      final repo = ref.read(routineRepositoryProvider);
      try {
        await repo.createTaskTemplate(result);
        ref.invalidate(routineTaskTemplatesProviderFamily(widget.routineId));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Task template added')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error adding task template: ${e.toString()}')),
          );
        }
      }
    }
  }

  Future<void> _editTaskTemplate(RoutineTaskTemplateModel template, int index) async {
    final result = await _showTemplateDialog(existingTemplate: template);
    if (result != null) {
      setState(() {
        _templates[index] = result;
      });
      
      final repo = ref.read(routineRepositoryProvider);
      try {
        await repo.updateTaskTemplate(result);
        ref.invalidate(routineTaskTemplatesProviderFamily(widget.routineId));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Task template updated')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error updating task template: ${e.toString()}')),
          );
        }
      }
    }
  }

  Future<void> _deleteTaskTemplate(String templateId, int index) async {
    setState(() {
      _templates.removeAt(index);
    });
    
    final repo = ref.read(routineRepositoryProvider);
    try {
      await repo.deleteTaskTemplate(templateId);
      ref.invalidate(routineTaskTemplatesProviderFamily(widget.routineId));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task template deleted')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting task template: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _reorderTemplates(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    
    final item = _templates.removeAt(oldIndex);
    setState(() {
      _templates.insert(newIndex, item);
      
      // Update order_in_routine for all items
      for (int i = 0; i < _templates.length; i++) {
        _templates[i] = _templates[i].copyWith(orderInRoutine: i);
      }
    });
    
    final repo = ref.read(routineRepositoryProvider);
    try {
      await repo.updateTaskTemplateOrder(_templates);
      ref.invalidate(routineTaskTemplatesProviderFamily(widget.routineId));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating template order: ${e.toString()}')),
        );
      }
    }
  }

  Future<RoutineTaskTemplateModel?> _showTemplateDialog({
    RoutineTaskTemplateModel? existingTemplate,
  }) async {
    TextEditingController titleController = TextEditingController(
      text: existingTemplate?.title ?? '',
    );
    TextEditingController descriptionController = TextEditingController(
      text: existingTemplate?.description ?? '',
    );
    TextEditingController durationController = TextEditingController(
      text: existingTemplate?.estimatedDurationMinutes?.toString() ?? '',
    );
    
    TaskPriority priority = existingTemplate?.priority ?? TaskPriority.medium;
    
    return showDialog<RoutineTaskTemplateModel>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(existingTemplate == null ? 'Add Task Template' : 'Edit Task Template'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        hintText: 'Enter task title',
                      ),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description (Optional)',
                        hintText: 'Enter task description',
                      ),
                      maxLines: 2,
                    ),
                    TextField(
                      controller: durationController,
                      decoration: const InputDecoration(
                        labelText: 'Est. Duration (mins)',
                        hintText: 'e.g., 30',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<TaskPriority>(
                      value: priority,
                      decoration: const InputDecoration(
                        labelText: 'Priority',
                      ),
                      items: TaskPriority.values.map((p) {
                        String label;
                        switch (p) {
                          case TaskPriority.low:
                            label = 'Low';
                            break;
                          case TaskPriority.medium:
                            label = 'Medium';
                            break;
                          case TaskPriority.high:
                            label = 'High';
                            break;
                        }
                        return DropdownMenuItem(
                          value: p,
                          child: Text(label),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            priority = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (titleController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Title is required')),
                      );
                      return;
                    }
                    
                    int? duration;
                    if (durationController.text.isNotEmpty) {
                      duration = int.tryParse(durationController.text);
                    }
                    
                    final template = RoutineTaskTemplateModel(
                      id: existingTemplate?.id ?? _uuid.v4(),
                      routineId: widget.routineId,
                      userId: '', // Will be set by repository
                      title: titleController.text.trim(),
                      description: descriptionController.text.trim().isNotEmpty
                          ? descriptionController.text.trim()
                          : null,
                      estimatedDurationMinutes: duration,
                      categoryId: existingTemplate?.categoryId,
                      priority: priority,
                      orderInRoutine: existingTemplate?.orderInRoutine ?? _templates.length,
                      createdAt: existingTemplate?.createdAt,
                      updatedAt: existingTemplate?.updatedAt,
                    );
                    
                    Navigator.of(context).pop(template);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Task Templates (${_templates.length})',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _addTaskTemplate,
              tooltip: 'Add Task Template',
            ),
          ],
        ),
        const Divider(),
        _templates.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No task templates yet. Add some!'),
                ),
              )
            : ReorderableListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _templates.length,
                onReorder: _reorderTemplates,
                itemBuilder: (context, index) {
                  final template = _templates[index];
                  return Card(
                    key: Key(template.id),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: const Icon(Icons.drag_handle),
                      title: Text(template.title),
                      subtitle: template.description != null
                          ? Text(
                              template.description!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          : null,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (template.estimatedDurationMinutes != null)
                            Chip(
                              label: Text('${template.estimatedDurationMinutes} min'),
                              backgroundColor: Colors.grey.shade200,
                            ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editTaskTemplate(template, index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteTaskTemplate(template.id, index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ],
    );
  }
}
