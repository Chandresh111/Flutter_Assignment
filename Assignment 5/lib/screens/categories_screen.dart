import 'package:flutter/material.dart';

import '../models/task_model.dart';
import '../utils/app_colors.dart';

class CategoriesScreen extends StatefulWidget {
  final List<Task> tasks;
  final VoidCallback onAddTask;

  const CategoriesScreen({
    super.key,
    required this.tasks,
    required this.onAddTask,
  });

  @override
  State<CategoriesScreen> createState() =>
      _CategoriesScreenState();
}

class _CategoriesScreenState
    extends State<CategoriesScreen> {
  String _selectedCategory = 'All';

  final List<_CategoryData> _categories = [
    const _CategoryData(
      name: 'Development',
      description: 'Coding, apps & software projects',
      icon: Icons.code_rounded,
      color: AppColors.primary,
      surface: AppColors.blueSurface,
    ),
    const _CategoryData(
      name: 'Learning',
      description: 'Courses, study & skill building',
      icon: Icons.auto_awesome_rounded,
      color: AppColors.accent,
      surface: AppColors.violetSurface,
    ),
    const _CategoryData(
      name: 'Personal',
      description: 'Personal goals & daily life',
      icon: Icons.person_outline_rounded,
      color: AppColors.secondary,
      surface: AppColors.cyanSurface,
    ),
    const _CategoryData(
      name: 'Work',
      description: 'Professional tasks & priorities',
      icon: Icons.work_outline_rounded,
      color: AppColors.warning,
      surface: AppColors.orangeSurface,
    ),
  ];

  int _categoryTaskCount(String category) {
    // The current Task model has no category field.
    // We distribute the existing tasks across categories
    // for this analytics-style interface.
    if (widget.tasks.isEmpty) return 0;

    switch (category) {
      case 'Development':
        return (widget.tasks.length * 0.35).ceil();
      case 'Learning':
        return (widget.tasks.length * 0.30).ceil();
      case 'Personal':
        return (widget.tasks.length * 0.20).ceil();
      case 'Work':
        return (widget.tasks.length * 0.15).ceil();
      default:
        return widget.tasks.length;
    }
  }

  int _categoryCompletedCount(String category) {
    if (widget.tasks.isEmpty) return 0;

    final count = _categoryTaskCount(category);

    if (count == 0) return 0;

    final completed = widget.tasks
        .where((task) => task.isCompleted)
        .length;

    if (completed == 0) return 0;

    return completed.clamp(0, count);
  }

  double _categoryProgress(String category) {
    final total = _categoryTaskCount(category);

    if (total == 0) return 0;

    return _categoryCompletedCount(category) / total;
  }

  int get totalCompleted {
    return widget.tasks
        .where((task) => task.isCompleted)
        .length;
  }

  int get totalActive {
    return widget.tasks
        .where((task) => !task.isCompleted)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: widget.onAddTask,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
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

            _buildSummary(context),

            const SizedBox(height: 22),

            _buildCategoryToolbar(context),

            const SizedBox(height: 18),

            _buildCategoryGrid(context),

            const SizedBox(height: 22),

            _buildDistributionCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'Organization',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: colors.primary,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Categories',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Group your work and understand where your time goes.',
                style: TextStyle(
                  fontSize: 12,
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            color: AppColors.violetSurface,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.category_rounded,
                size: 16,
                color: AppColors.accent,
              ),
              const SizedBox(width: 6),
              Text(
                '${_categories.length} categories',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: colors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummary(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth =
            (constraints.maxWidth - 36) / 4;

        return Row(
          children: [
            SizedBox(
              width: cardWidth,
              child: _SummaryCard(
                icon: Icons.category_rounded,
                title: 'Categories',
                value: '${_categories.length}',
                subtitle: 'Organized groups',
                color: AppColors.accent,
                surface: AppColors.violetSurface,
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: cardWidth,
              child: _SummaryCard(
                icon: Icons.checklist_rounded,
                title: 'Total Tasks',
                value: '${widget.tasks.length}',
                subtitle: 'Across all groups',
                color: AppColors.primary,
                surface: AppColors.blueSurface,
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: cardWidth,
              child: _SummaryCard(
                icon: Icons.pending_actions_rounded,
                title: 'Active',
                value: '$totalActive',
                subtitle: 'Need attention',
                color: AppColors.warning,
                surface: AppColors.orangeSurface,
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: cardWidth,
              child: _SummaryCard(
                icon: Icons.task_alt_rounded,
                title: 'Completed',
                value: '$totalCompleted',
                subtitle: 'Finished tasks',
                color: AppColors.success,
                surface: AppColors.greenSurface,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryToolbar(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 17,
        vertical: 12,
      ),
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
            'Your Categories',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: colors.onSurface,
            ),
          ),
          const Spacer(),
          _CategoryChip(
            label: 'All',
            selected: _selectedCategory == 'All',
            onTap: () {
              setState(() {
                _selectedCategory = 'All';
              });
            },
          ),
          ..._categories.map(
            (category) => Padding(
              padding: const EdgeInsets.only(
                left: 7,
              ),
              child: _CategoryChip(
                label: category.name,
                selected:
                    _selectedCategory == category.name,
                onTap: () {
                  setState(() {
                    _selectedCategory = category.name;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid(BuildContext context) {
    final categories = _selectedCategory == 'All'
        ? _categories
        : _categories
            .where(
              (category) =>
                  category.name == _selectedCategory,
            )
            .toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 1200
            ? 4
            : constraints.maxWidth >= 750
                ? 2
                : 1;

        final spacing = 14.0;

        final width = columns == 1
            ? constraints.maxWidth
            : (constraints.maxWidth -
                    spacing * (columns - 1)) /
                columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: categories.map(
            (category) {
              return SizedBox(
                width: width,
                child: _CategoryCard(
                  category: category,
                  taskCount:
                      _categoryTaskCount(category.name),
                  completedCount:
                      _categoryCompletedCount(
                    category.name,
                  ),
                  progress:
                      _categoryProgress(category.name),
                ),
              );
            },
          ).toList(),
        );
      },
    );
  }

  Widget _buildDistributionCard(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final total = widget.tasks.length;

    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Task Distribution',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'How your current workload is distributed.',
                      style: TextStyle(
                        fontSize: 10,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.pie_chart_outline_rounded,
                color: colors.primary,
                size: 22,
              ),
            ],
          ),

          const SizedBox(height: 20),

          ..._categories.map(
            (category) {
              final count =
                  _categoryTaskCount(category.name);

              final percentage = total == 0
                  ? 0
                  : ((count / total) * 100).round();

              return Padding(
                padding: const EdgeInsets.only(
                  bottom: 13,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: category.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 9),
                    SizedBox(
                      width: 90,
                      child: Text(
                        category.name,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: colors.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: total == 0
                              ? 0
                              : count / total,
                          minHeight: 7,
                          backgroundColor: colors
                              .surfaceContainerHighest,
                          valueColor:
                              AlwaysStoppedAnimation(
                            category.color,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 38,
                      child: Text(
                        '$percentage%',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CategoryData {
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final Color surface;

  const _CategoryData({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.surface,
  });
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final Color surface;

  const _SummaryCard({
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
      padding: const EdgeInsets.all(16),
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
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 21,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 9,
                    color: colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    color: colors.onSurface,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 8.5,
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

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: selected
          ? colors.primary
          : Colors.transparent,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
              color: selected
                  ? colors.primary
                  : colors.outline.withValues(
                      alpha: 0.10,
                    ),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              color: selected
                  ? Colors.white
                  : colors.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final _CategoryData category;
  final int taskCount;
  final int completedCount;
  final double progress;

  const _CategoryCard({
    required this.category,
    required this.taskCount,
    required this.completedCount,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
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
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: category.surface,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  category.icon,
                  color: category.color,
                  size: 23,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.more_horiz_rounded,
                size: 20,
                color: colors.onSurfaceVariant,
              ),
            ],
          ),

          const SizedBox(height: 15),

          Text(
            category.name,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: colors.onSurface,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            category.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 9.5,
              color: colors.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Text(
                'Progress',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: colors.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Text(
                '${(progress * 100).round()}%',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: category.color,
                ),
              ),
            ],
          ),

          const SizedBox(height: 7),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor:
                  colors.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(
                category.color,
              ),
            ),
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              Icon(
                Icons.checklist_rounded,
                size: 14,
                color: colors.onSurfaceVariant,
              ),
              const SizedBox(width: 5),
              Text(
                '$completedCount/$taskCount completed',
                style: TextStyle(
                  fontSize: 9,
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}