import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class ProjectsScreen extends StatefulWidget {
  final VoidCallback onAddTask;

  const ProjectsScreen({
    super.key,
    required this.onAddTask,
  });

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  String _selectedFilter = 'All';

  final List<_ProjectData> _projects = [
    _ProjectData(
      name: 'Flutter Assignment',
      description:
          'Build a polished productivity application.',
      icon: Icons.flutter_dash_rounded,
      progress: 0.82,
      tasks: 11,
      completedTasks: 9,
      priority: 'High',
      status: 'In Progress',
      category: 'Development',
    ),
    _ProjectData(
      name: 'ML Learning',
      description:
          'Strengthen machine learning fundamentals.',
      icon: Icons.auto_awesome_rounded,
      progress: 0.64,
      tasks: 14,
      completedTasks: 9,
      priority: 'High',
      status: 'In Progress',
      category: 'Learning',
    ),
    _ProjectData(
      name: 'Portfolio Website',
      description:
          'Build an impressive developer portfolio.',
      icon: Icons.web_rounded,
      progress: 0.48,
      tasks: 10,
      completedTasks: 5,
      priority: 'Medium',
      status: 'In Progress',
      category: 'Development',
    ),
    _ProjectData(
      name: 'DSA Preparation',
      description:
          'Practice algorithms and data structures.',
      icon: Icons.code_rounded,
      progress: 0.76,
      tasks: 25,
      completedTasks: 19,
      priority: 'High',
      status: 'In Progress',
      category: 'Learning',
    ),
    _ProjectData(
      name: 'Semester Planning',
      description:
          'Organize academic goals and deadlines.',
      icon: Icons.school_rounded,
      progress: 1.0,
      tasks: 8,
      completedTasks: 8,
      priority: 'Low',
      status: 'Completed',
      category: 'Personal',
    ),
    _ProjectData(
      name: 'Personal Goals',
      description:
          'Track habits and long-term objectives.',
      icon: Icons.flag_rounded,
      progress: 0.31,
      tasks: 13,
      completedTasks: 4,
      priority: 'Medium',
      status: 'In Progress',
      category: 'Personal',
    ),
  ];

  List<_ProjectData> get filteredProjects {
    if (_selectedFilter == 'All') {
      return _projects;
    }

    return _projects.where((project) {
      return project.category == _selectedFilter;
    }).toList();
  }

  int get completedProjects {
    return _projects
        .where((project) => project.progress >= 1)
        .length;
  }

  int get activeProjects {
    return _projects
        .where((project) => project.progress < 1)
        .length;
  }

  double get averageProgress {
    if (_projects.isEmpty) return 0;

    final total = _projects.fold<double>(
      0,
      (sum, project) => sum + project.progress,
    );

    return total / _projects.length;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: widget.onAddTask,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(
          Icons.add_rounded,
        ),
        label: const Text(
          'New Project',
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

            _buildOverview(context),

            const SizedBox(height: 22),

            _buildProjectToolbar(context),

            const SizedBox(height: 18),

            _buildProjectGrid(context),

            const SizedBox(height: 22),

            _buildBottomInsight(context),
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
                'Workspace',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: colors.primary,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Projects',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Turn your ideas into organized, measurable progress.',
                style: TextStyle(
                  fontSize: 12,
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        _HeaderAction(
          icon: Icons.grid_view_rounded,
          label: 'Overview',
          selected: true,
        ),
      ],
    );
  }

  Widget _buildOverview(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth =
            (constraints.maxWidth - 36) / 4;

        return Row(
          children: [
            SizedBox(
              width: cardWidth,
              child: _OverviewCard(
                icon: Icons.folder_rounded,
                title: 'Total Projects',
                value: '${_projects.length}',
                subtitle: 'Your workspace',
                color: AppColors.primary,
                surface: AppColors.blueSurface,
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: cardWidth,
              child: _OverviewCard(
                icon: Icons.play_circle_outline_rounded,
                title: 'Active',
                value: '$activeProjects',
                subtitle: 'Currently working',
                color: AppColors.warning,
                surface: AppColors.orangeSurface,
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: cardWidth,
              child: _OverviewCard(
                icon: Icons.check_circle_rounded,
                title: 'Completed',
                value: '$completedProjects',
                subtitle: 'Successfully finished',
                color: AppColors.success,
                surface: AppColors.greenSurface,
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: cardWidth,
              child: _OverviewCard(
                icon: Icons.insights_rounded,
                title: 'Avg. Progress',
                value:
                    '${(averageProgress * 100).round()}%',
                subtitle: 'Across all projects',
                color: AppColors.accent,
                surface: AppColors.violetSurface,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProjectToolbar(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    const filters = [
      'All',
      'Development',
      'Learning',
      'Personal',
    ];

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
            'My Projects',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: colors.onSurface,
            ),
          ),
          const Spacer(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: filters.map(
                (filter) {
                  final selected =
                      _selectedFilter == filter;

                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 7),
                    child: ChoiceChip(
                      label: Text(
                        filter,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      selected: selected,
                      onSelected: (_) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                      selectedColor:
                          colors.primary,
                      labelStyle: TextStyle(
                        color: selected
                            ? Colors.white
                            : colors.onSurface,
                      ),
                      side: BorderSide(
                        color: colors.outline
                            .withValues(alpha: 0.10),
                      ),
                      showCheckmark: false,
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectGrid(BuildContext context) {
    final projects = filteredProjects;

    if (projects.isEmpty) {
      return _EmptyProjects(
        onCreate: widget.onAddTask,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 1200
            ? 3
            : constraints.maxWidth >= 750
                ? 2
                : 1;

        final spacing = 14.0;

        final cardWidth = columns == 1
            ? constraints.maxWidth
            : (constraints.maxWidth -
                    spacing * (columns - 1)) /
                columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: projects.map(
            (project) {
              return SizedBox(
                width: cardWidth,
                child: _ProjectCard(
                  project: project,
                ),
              );
            },
          ).toList(),
        );
      },
    );
  }

  Widget _buildBottomInsight(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

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
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: AppColors.primary.withValues(
            alpha: 0.08,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: 0.75,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.lightbulb_outline_rounded,
              color: colors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Keep building',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${(averageProgress * 100).round()}% average progress '
                  'across your projects. Consistency wins.',
                  style: TextStyle(
                    fontSize: 10,
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

class _ProjectData {
  final String name;
  final String description;
  final IconData icon;
  final double progress;
  final int tasks;
  final int completedTasks;
  final String priority;
  final String status;
  final String category;

  const _ProjectData({
    required this.name,
    required this.description,
    required this.icon,
    required this.progress,
    required this.tasks,
    required this.completedTasks,
    required this.priority,
    required this.status,
    required this.category,
  });
}

class _OverviewCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final Color surface;

  const _OverviewCard({
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

class _ProjectCard extends StatelessWidget {
  final _ProjectData project;

  const _ProjectCard({
    required this.project,
  });

  Color _priorityColor() {
    switch (project.priority) {
      case 'High':
        return AppColors.danger;
      case 'Medium':
        return AppColors.warning;
      default:
        return AppColors.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final percentage =
        (project.progress * 100).round();

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
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.secondary,
                    ],
                  ),
                  borderRadius:
                      BorderRadius.circular(13),
                ),
                child: Icon(
                  project.icon,
                  color: Colors.white,
                  size: 22,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      project.category,
                      style: TextStyle(
                        fontSize: 9,
                        color:
                            colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.more_horiz_rounded,
                color: colors.onSurfaceVariant,
                size: 20,
              ),
            ],
          ),

          const SizedBox(height: 15),

          Text(
            project.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10.5,
              height: 1.4,
              color: colors.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 17),

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
                '$percentage%',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: colors.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 7),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: project.progress,
              minHeight: 7,
              backgroundColor:
                  colors.surfaceContainerHighest,
              valueColor:
                  const AlwaysStoppedAnimation(
                AppColors.primary,
              ),
            ),
          ),

          const SizedBox(height: 17),

          Row(
            children: [
              _ProjectMeta(
                icon: Icons.checklist_rounded,
                text:
                    '${project.completedTasks}/${project.tasks} tasks',
              ),

              const Spacer(),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: _priorityColor()
                      .withValues(alpha: 0.08),
                  borderRadius:
                      BorderRadius.circular(8),
                ),
                child: Text(
                  project.priority,
                  style: TextStyle(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w800,
                    color: _priorityColor(),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 11),

          Row(
            children: [
              Icon(
                project.progress >= 1
                    ? Icons.check_circle_rounded
                    : Icons.timelapse_rounded,
                size: 14,
                color: project.progress >= 1
                    ? AppColors.success
                    : colors.primary,
              ),
              const SizedBox(width: 5),
              Text(
                project.status,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: project.progress >= 1
                      ? AppColors.success
                      : colors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProjectMeta extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ProjectMeta({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: colors.onSurfaceVariant,
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(
            fontSize: 9,
            color: colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _HeaderAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;

  const _HeaderAction({
    required this.icon,
    required this.label,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: selected
            ? colors.primary
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: selected
                ? Colors.white
                : colors.onSurfaceVariant,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: selected
                  ? Colors.white
                  : colors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyProjects extends StatelessWidget {
  final VoidCallback onCreate;

  const _EmptyProjects({
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 65,
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
          Icon(
            Icons.folder_open_rounded,
            size: 42,
            color: colors.primary,
          ),
          const SizedBox(height: 13),
          Text(
            'No projects found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: colors.onSurface,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Try another project category.',
            style: TextStyle(
              fontSize: 10,
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 17),
          FilledButton.icon(
            onPressed: onCreate,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Create Project'),
          ),
        ],
      ),
    );
  }
}