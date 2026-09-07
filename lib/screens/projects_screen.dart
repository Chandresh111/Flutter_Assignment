import 'package:flutter/material.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final projects = [
      const _ProjectData(
        title: 'Flutter Dashboard',
        description: 'Responsive student dashboard UI',
        progress: 0.90,
        status: 'Completed',
        icon: Icons.dashboard_rounded,
      ),
      const _ProjectData(
        title: 'Mini Redis',
        description: 'In-memory key-value database',
        progress: 0.65,
        status: 'In Progress',
        icon: Icons.storage_rounded,
      ),
      const _ProjectData(
        title: 'ML Portfolio',
        description: 'Machine learning project collection',
        progress: 0.45,
        status: 'In Progress',
        icon: Icons.auto_graph_rounded,
      ),
      const _ProjectData(
        title: 'Library System',
        description: 'Flutter library management application',
        progress: 0.78,
        status: 'In Progress',
        icon: Icons.local_library_rounded,
      ),
      const _ProjectData(
        title: 'DSA Practice',
        description: 'Algorithms and problem solving',
        progress: 0.72,
        status: 'Active',
        icon: Icons.code_rounded,
      ),
      const _ProjectData(
        title: 'Portfolio Website',
        description: 'Interactive developer portfolio',
        progress: 0.55,
        status: 'In Progress',
        icon: Icons.web_rounded,
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Projects',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Manage your projects and track development progress.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 28),

          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;

              final columns = width >= 1100
                  ? 3
                  : width >= 650
                      ? 2
                      : 1;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: projects.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                  childAspectRatio: width < 650 ? 1.55 : 1.25,
                ),
                itemBuilder: (context, index) {
                  return _ProjectCard(
                    project: projects[index],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProjectData {
  final String title;
  final String description;
  final double progress;
  final String status;
  final IconData icon;

  const _ProjectData({
    required this.title,
    required this.description,
    required this.progress,
    required this.status,
    required this.icon,
  });
}

class _ProjectCard extends StatelessWidget {
  final _ProjectData project;

  const _ProjectCard({
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final isCompleted = project.progress >= 0.9;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colors.outline.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  project.icon,
                  color: colors.primary,
                ),
              ),
              const Spacer(),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz_rounded),
                onSelected: (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$value: ${project.title}'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'View',
                    child: Text('View project'),
                  ),
                  PopupMenuItem(
                    value: 'Edit',
                    child: Text('Edit project'),
                  ),
                  PopupMenuItem(
                    value: 'Delete',
                    child: Text('Delete project'),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 18),

          Text(
            project.title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            project.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),

          const Spacer(),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? Colors.green.withValues(alpha: 0.12)
                      : colors.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  project.status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isCompleted
                        ? Colors.green.shade700
                        : colors.primary,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${(project.progress * 100).round()}%',
                style: TextStyle(
                  color: colors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: project.progress,
              minHeight: 8,
              backgroundColor: colors.surfaceContainerHighest,
            ),
          ),
        ],
      ),
    );
  }
}