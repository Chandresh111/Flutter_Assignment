import 'package:flutter/material.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  String selectedFilter = 'All';

  final List<_Task> tasks = [
    _Task(
      title: 'Complete Flutter Assignment 4',
      category: 'Flutter',
      priority: 'High',
      completed: false,
    ),
    _Task(
      title: 'Practice LeetCode problems',
      category: 'DSA',
      priority: 'High',
      completed: true,
    ),
    _Task(
      title: 'Study Gradient Descent',
      category: 'ML',
      priority: 'Medium',
      completed: false,
    ),
    _Task(
      title: 'Work on Mini Redis',
      category: 'Development',
      priority: 'High',
      completed: false,
    ),
    _Task(
      title: 'Update project documentation',
      category: 'Projects',
      priority: 'Low',
      completed: true,
    ),
    _Task(
      title: 'Review Dart fundamentals',
      category: 'Flutter',
      priority: 'Medium',
      completed: false,
    ),
  ];

  List<_Task> get filteredTasks {
    if (selectedFilter == 'All') {
      return tasks;
    }

    if (selectedFilter == 'Completed') {
      return tasks.where((task) => task.completed).toList();
    }

    return tasks.where((task) => !task.completed).toList();
  }

  int get completedCount {
    return tasks.where((task) => task.completed).length;
  }

  void toggleTask(_Task task) {
    setState(() {
      task.completed = !task.completed;
    });
  }

  void addTask() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Task'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Enter task name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final title = controller.text.trim();

                if (title.isNotEmpty) {
                  setState(() {
                    tasks.add(
                      _Task(
                        title: title,
                        category: 'General',
                        priority: 'Medium',
                        completed: false,
                      ),
                    );
                  });
                }

                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final progress = tasks.isEmpty
        ? 0.0
        : completedCount / tasks.length;

    return Material(
      color: theme.scaffoldBackgroundColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -----------------------------------------------------------
            // HEADER
            // -----------------------------------------------------------
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tasks',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Stay organized and keep your progress moving.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                FilledButton.icon(
                  onPressed: addTask,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Add Task'),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // -----------------------------------------------------------
            // PROGRESS CARD
            // -----------------------------------------------------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colors.primary,
                    colors.secondary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: colors.primary.withValues(alpha: 0.18),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.task_alt_rounded,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Task Progress',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '$completedCount/${tasks.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
                      backgroundColor:
                          Colors.white.withValues(alpha: 0.20),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    '${(progress * 100).round()}% of your tasks completed',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // -----------------------------------------------------------
            // FILTERS
            // -----------------------------------------------------------
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(
                    label: 'All',
                    selected: selectedFilter == 'All',
                    onSelected: () {
                      setState(() {
                        selectedFilter = 'All';
                      });
                    },
                  ),

                  const SizedBox(width: 10),

                  _FilterChip(
                    label: 'Pending',
                    selected: selectedFilter == 'Pending',
                    onSelected: () {
                      setState(() {
                        selectedFilter = 'Pending';
                      });
                    },
                  ),

                  const SizedBox(width: 10),

                  _FilterChip(
                    label: 'Completed',
                    selected: selectedFilter == 'Completed',
                    onSelected: () {
                      setState(() {
                        selectedFilter = 'Completed';
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // -----------------------------------------------------------
            // TASK LIST
            // -----------------------------------------------------------
            if (filteredTasks.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      size: 50,
                      color: colors.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No tasks here',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredTasks.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final task = filteredTasks[index];

                  return _TaskCard(
                    task: task,
                    onToggle: () => toggleTask(task),
                  );
                },
              ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
// TASK MODEL
// ===========================================================================

class _Task {
  final String title;
  final String category;
  final String priority;
  bool completed;

  _Task({
    required this.title,
    required this.category,
    required this.priority,
    required this.completed,
  });
}

// ===========================================================================
// TASK CARD
// ===========================================================================

class _TaskCard extends StatelessWidget {
  final _Task task;
  final VoidCallback onToggle;

  const _TaskCard({
    required this.task,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colors.outline.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Checkbox(
            value: task.completed,
            onChanged: (_) => onToggle(),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    decoration: task.completed
                        ? TextDecoration.lineThrough
                        : null,
                    color: task.completed
                        ? colors.onSurfaceVariant
                        : null,
                  ),
                ),

                const SizedBox(height: 8),

                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _SmallTag(
                      label: task.category,
                    ),
                    _SmallTag(
                      label: task.priority,
                      isPriority: true,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          Icon(
            task.completed
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            color: task.completed
                ? Colors.green
                : colors.outline,
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// SMALL TAG
// ===========================================================================

class _SmallTag extends StatelessWidget {
  final String label;
  final bool isPriority;

  const _SmallTag({
    required this.label,
    this.isPriority = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: isPriority
            ? colors.secondaryContainer
            : colors.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isPriority
              ? colors.onSecondaryContainer
              : colors.onPrimaryContainer,
        ),
      ),
    );
  }
}

// ===========================================================================
// FILTER CHIP
// ===========================================================================

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),

      avatar: selected
          ? const Icon(
              Icons.check_rounded,
              size: 18,
            )
          : null,

      selectedColor: colors.primaryContainer,

      backgroundColor: colors.surface,

      labelStyle: TextStyle(
        color: selected
            ? colors.onPrimaryContainer
            : colors.onSurface,
        fontWeight: FontWeight.w600,
      ),

      side: BorderSide(
        color: colors.outline.withValues(alpha: 0.12),
      ),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
}