import 'package:flutter/material.dart';

import '../models/task_model.dart';
import '../utils/app_colors.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 160),
      lowerBound: 0.97,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleToggle() async {
    await _animationController.reverse();

    if (!mounted) return;

    widget.onToggle();

    await _animationController.forward();
  }

  void _showDeleteConfirmation() {
    final colors = Theme.of(context).colorScheme;

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          icon: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: colors.errorContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.delete_outline_rounded,
              color: colors.error,
            ),
          ),
          title: const Text(
            'Delete task?',
            textAlign: TextAlign.center,
          ),
          content: Text(
            'Are you sure you want to delete "${widget.task.title}"?',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onDelete();
              },
              style: FilledButton.styleFrom(
                backgroundColor: colors.error,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final completed = widget.task.isCompleted;

    return ScaleTransition(
      scale: _animationController,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: completed
                ? AppColors.success.withValues(alpha: 0.18)
                : colors.outline.withValues(alpha: 0.08),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _handleToggle,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 12,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CompletionButton(
                    completed: completed,
                    onPressed: _handleToggle,
                  ),

                  const SizedBox(width: 11),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 220),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: completed
                                ? colors.onSurfaceVariant
                                : colors.onSurface,
                            decoration: completed
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            decorationThickness: 1.4,
                          ),
                          child: Text(
                            widget.task.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        if (widget.task.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            widget.task.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10.5,
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ],

                        const SizedBox(height: 8),

                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: completed
                                    ? AppColors.success
                                    : AppColors.warning,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              completed
                                  ? 'Completed'
                                  : 'In progress',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: completed
                                    ? AppColors.success
                                    : AppColors.warning,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 5),

                  SizedBox(
                    width: 30,
                    height: 30,
                    child: IconButton(
                      tooltip: 'Delete task',
                      padding: EdgeInsets.zero,
                      onPressed: _showDeleteConfirmation,
                      icon: Icon(
                        Icons.more_horiz_rounded,
                        size: 20,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CompletionButton extends StatelessWidget {
  final bool completed;
  final VoidCallback onPressed;

  const _CompletionButton({
    required this.completed,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        width: 27,
        height: 27,
        decoration: BoxDecoration(
          color: completed
              ? AppColors.success
              : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            width: 1.8,
            color: completed
                ? AppColors.success
                : colors.outline.withValues(alpha: 0.35),
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          transitionBuilder: (child, animation) {
            return ScaleTransition(
              scale: animation,
              child: child,
            );
          },
          child: completed
              ? const Icon(
                  Icons.check_rounded,
                  key: ValueKey('completed'),
                  color: Colors.white,
                  size: 17,
                )
              : Icon(
                  Icons.circle,
                  key: const ValueKey('active'),
                  color: colors.primary.withValues(alpha: 0.08),
                  size: 8,
                ),
        ),
      ),
    );
  }
}