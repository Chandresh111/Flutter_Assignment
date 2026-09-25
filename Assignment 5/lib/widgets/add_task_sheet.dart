import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class AddTaskSheet extends StatefulWidget {
  final Function(String title, String description) onAddTask;

  const AddTaskSheet({
    super.key,
    required this.onAddTask,
  });

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isAdding = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isAdding = true;
    });

    await Future.delayed(
      const Duration(milliseconds: 350),
    );

    widget.onAddTask(
      _titleController.text.trim(),
      _descriptionController.text.trim(),
    );

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(
          left: 22,
          right: 22,
          top: 12,
          bottom: MediaQuery.of(context).viewInsets.bottom + 22,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.onSurfaceVariant.withValues(
                      alpha: 0.25,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // Header
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.secondary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.add_task_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),

                  const SizedBox(width: 13),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create New Task',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: colors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Add something you want to accomplish.',
                          style: TextStyle(
                            fontSize: 11,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              // Task title
              Text(
                'TASK TITLE',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                  color: colors.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 7),

              TextFormField(
                controller: _titleController,
                autofocus: true,
                textCapitalization:
                    TextCapitalization.sentences,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colors.onSurface,
                ),
                decoration: InputDecoration(
                  hintText:
                      'e.g. Complete Flutter assignment',
                  hintStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: colors.onSurfaceVariant,
                  ),
                  prefixIcon: Icon(
                    Icons.title_rounded,
                    color: colors.primary,
                    size: 20,
                  ),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please enter a task title';
                  }

                  if (value.trim().length < 3) {
                    return 'Task title must be at least 3 characters';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 15),

              // Description
              Text(
                'DESCRIPTION',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                  color: colors.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 7),

              TextFormField(
                controller: _descriptionController,
                textCapitalization:
                    TextCapitalization.sentences,
                maxLines: 3,
                style: TextStyle(
                  fontSize: 13,
                  color: colors.onSurface,
                ),
                decoration: InputDecoration(
                  hintText:
                      'Add some details about this task...',
                  hintStyle: TextStyle(
                    fontSize: 12,
                    color: colors.onSurfaceVariant,
                  ),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(
                      bottom: 42,
                    ),
                    child: Icon(
                      Icons.notes_rounded,
                      size: 20,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Add button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed:
                      _isAdding ? null : _submitTask,
                  icon: _isAdding
                      ? const SizedBox(
                          width: 19,
                          height: 19,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.3,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(
                          Icons.add_rounded,
                        ),
                  label: Text(
                    _isAdding
                        ? 'Creating Task...'
                        : 'Create Task',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor:
                        AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(13),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}