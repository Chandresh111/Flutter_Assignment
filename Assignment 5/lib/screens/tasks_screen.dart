import 'package:flutter/material.dart';

import '../models/task_model.dart';
import '../utils/app_colors.dart';
import '../widgets/filter_chips.dart';
import '../widgets/search_bar.dart';
import '../widgets/task_card.dart';

class TasksScreen extends StatefulWidget {
  final List<Task> tasks;
  final ValueChanged<Task> onToggleTask;
  final ValueChanged<Task> onDeleteTask;
  final ValueChanged<String> onSearchChanged;
  final String searchQuery;
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;
  final VoidCallback onAddTask;

  const TasksScreen({
    super.key,
    required this.tasks,
    required this.onToggleTask,
    required this.onDeleteTask,
    required this.onSearchChanged,
    required this.searchQuery,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.onAddTask,
  });

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  bool _showCompletedFirst = false;

  List<Task> get filteredTasks {
    List<Task> result = List<Task>.from(widget.tasks);

    if (widget.searchQuery.trim().isNotEmpty) {
      final query = widget.searchQuery.toLowerCase().trim();

      result = result.where((task) {
        return task.title.toLowerCase().contains(query) ||
            task.description.toLowerCase().contains(query);
      }).toList();
    }

    switch (widget.selectedFilter) {
      case 'Active':
        result = result
            .where((task) => !task.isCompleted)
            .toList();
        break;

      case 'Completed':
        result = result
            .where((task) => task.isCompleted)
            .toList();
        break;
    }

    if (_showCompletedFirst) {
      result.sort((a, b) {
        if (a.isCompleted == b.isCompleted) {
          return 0;
        }

        return a.isCompleted ? -1 : 1;
      });
    }

    return result;
  }

  int get completedCount {
    return widget.tasks
        .where((task) => task.isCompleted)
        .length;
  }

  int get activeCount {
    return widget.tasks
        .where((task) => !task.isCompleted)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            28,
            26,
            28,
            40,
          ),
          children: [
            _buildHeader(context),

            const SizedBox(height: 24),

            _buildSummaryCards(context),

            const SizedBox(height: 22),

            _buildTaskToolbar(context),

            const SizedBox(height: 18),

            _buildTaskList(context),

            const SizedBox(height: 20),

            _buildBottomSummary(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: widget.onAddTask,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(
          Icons.add_rounded,
        ),
        label: const Text(
          'Add Task',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'Task Management',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: colors.primary,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Your Tasks',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Organize your work, stay focused, and get things done.',
                style: TextStyle(
                  fontSize: 12,
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        SizedBox(
          width: 280,
          height: 44,
          child: SearchBarWidget(
            onChanged: widget.onSearchChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth =
            (constraints.maxWidth - 24) / 3;

        return Row(
          children: [
            SizedBox(
              width: cardWidth,
              child: _TaskSummaryCard(
                icon: Icons.checklist_rounded,
                title: 'Total Tasks',
                value: '${widget.tasks.length}',
                subtitle: 'All your tasks',
                color: AppColors.primary,
                surface: AppColors.blueSurface,
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: cardWidth,
              child: _TaskSummaryCard(
                icon: Icons.pending_actions_rounded,
                title: 'In Progress',
                value: '$activeCount',
                subtitle: 'Still to complete',
                color: AppColors.warning,
                surface: AppColors.orangeSurface,
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: cardWidth,
              child: _TaskSummaryCard(
                icon: Icons.task_alt_rounded,
                title: 'Completed',
                value: '$completedCount',
                subtitle: 'Successfully finished',
                color: AppColors.success,
                surface: AppColors.greenSurface,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTaskToolbar(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.outline.withValues(
            alpha: 0.08,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            'All Tasks',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: colors.onSurface,
            ),
          ),

          const SizedBox(width: 14),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: colors.primaryContainer.withValues(
                alpha: 0.5,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${filteredTasks.length}',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: colors.primary,
              ),
            ),
          ),

          const Spacer(),

          FilterChips(
            selectedFilter: widget.selectedFilter,
            onFilterChanged: widget.onFilterChanged,
          ),

          const SizedBox(width: 10),

          IconButton(
            tooltip: _showCompletedFirst
                ? 'Show active first'
                : 'Show completed first',
            onPressed: () {
              setState(() {
                _showCompletedFirst =
                    !_showCompletedFirst;
              });
            },
            icon: Icon(
              _showCompletedFirst
                  ? Icons.sort_rounded
                  : Icons.swap_vert_rounded,
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (filteredTasks.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(
          vertical: 70,
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: colors.outline.withValues(
              alpha: 0.08,
            ),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: colors.primaryContainer.withValues(
                  alpha: 0.35,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.searchQuery.isNotEmpty
                    ? Icons.search_off_rounded
                    : Icons.task_alt_rounded,
                size: 31,
                color: colors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.searchQuery.isNotEmpty
                  ? 'No matching tasks'
                  : 'No tasks in this view',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.searchQuery.isNotEmpty
                  ? 'Try searching for something else.'
                  : 'Create a new task to get started.',
              style: TextStyle(
                fontSize: 11,
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: widget.onAddTask,
              icon: const Icon(
                Icons.add_rounded,
              ),
              label: const Text(
                'Create Task',
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colors.outline.withValues(
            alpha: 0.08,
          ),
        ),
      ),
      child: Column(
        children: [
          ...filteredTasks.map(
            (task) => Padding(
              padding: const EdgeInsets.only(
                bottom: 10,
              ),
              child: TaskCard(
                key: ValueKey(task.id),
                task: task,
                onToggle: () {
                  widget.onToggleTask(task);
                },
                onDelete: () {
                  widget.onDeleteTask(task);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSummary(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final percentage = widget.tasks.isEmpty
        ? 0
        : ((completedCount /
                    widget.tasks.length) *
                100)
            .round();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.blueSurface,
            AppColors.cyanSurface,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(
            alpha: 0.08,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.insights_rounded,
            color: colors.primary,
            size: 23,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Task completion',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '$percentage% of your tasks are complete.',
                  style: TextStyle(
                    fontSize: 10,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$percentage%',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w900,
              color: colors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskSummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final Color surface;

  const _TaskSummaryCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    required this.surface,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.outline.withValues(
            alpha: 0.08,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: color,
              size: 23,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 10,
                    color: colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                    color: colors.onSurface,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 9,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}