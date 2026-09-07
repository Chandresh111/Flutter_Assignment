import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analytics',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Track your learning and productivity performance.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 28),

          // Performance cards
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final columns = width >= 1000
                  ? 4
                  : width >= 650
                      ? 2
                      : 1;

              return GridView.count(
                crossAxisCount: columns,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: width < 650 ? 3.0 : 1.45,
                children: const [
                  _MetricCard(
                    icon: Icons.trending_up_rounded,
                    title: 'Overall Progress',
                    value: '78%',
                    change: '+12%',
                  ),
                  _MetricCard(
                    icon: Icons.schedule_rounded,
                    title: 'Study Time',
                    value: '32h',
                    change: '+8h',
                  ),
                  _MetricCard(
                    icon: Icons.task_alt_rounded,
                    title: 'Tasks Done',
                    value: '18',
                    change: '+6',
                  ),
                  _MetricCard(
                    icon: Icons.local_fire_department_rounded,
                    title: 'Study Streak',
                    value: '14 days',
                    change: '+3 days',
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 28),

          // Weekly performance
          _SectionCard(
            title: 'Weekly Performance',
            icon: Icons.bar_chart_rounded,
            child: Column(
              children: [
                const SizedBox(height: 20),
                SizedBox(
                  height: 220,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      _Bar(value: 0.45, label: 'Mon'),
                      _Bar(value: 0.65, label: 'Tue'),
                      _Bar(value: 0.55, label: 'Wed'),
                      _Bar(value: 0.80, label: 'Thu'),
                      _Bar(value: 0.70, label: 'Fri'),
                      _Bar(value: 0.90, label: 'Sat'),
                      _Bar(value: 0.60, label: 'Sun'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Skills progress
          _SectionCard(
            title: 'Skill Progress',
            icon: Icons.auto_graph_rounded,
            child: Column(
              children: const [
                _ProgressRow(
                  skill: 'Flutter',
                  progress: 0.85,
                ),
                _ProgressRow(
                  skill: 'Dart',
                  progress: 0.78,
                ),
                _ProgressRow(
                  skill: 'Python',
                  progress: 0.72,
                ),
                _ProgressRow(
                  skill: 'Machine Learning',
                  progress: 0.60,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String change;

  const _MetricCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.change,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: colors.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '$change this week',
                  style: TextStyle(
                    color: colors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
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

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.05),
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
              Icon(
                icon,
                color: colors.primary,
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          child,
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final double value;
  final String label;

  const _Bar({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: value,
              child: Container(
                width: 32,
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final String skill;
  final double progress;

  const _ProgressRow({
    required this.skill,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                skill,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: TextStyle(
                  color: colors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 9,
              backgroundColor: colors.surfaceContainerHighest,
            ),
          ),
        ],
      ),
    );
  }
}