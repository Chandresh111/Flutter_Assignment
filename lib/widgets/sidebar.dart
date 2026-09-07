import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      width: 250,
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 24,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          right: BorderSide(
            color: colors.outline.withValues(alpha: 0.08),
          ),
        ),
      ),
      child: Column(
        children: [
          // Logo
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.grid_view_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'StudyFlow',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 35),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'MENU',
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: colors.onSurfaceVariant,
              ),
            ),
          ),

          const SizedBox(height: 10),

          _navItem(
            context,
            index: 0,
            icon: Icons.dashboard_rounded,
            label: 'Dashboard',
          ),
          _navItem(
            context,
            index: 1,
            icon: Icons.analytics_rounded,
            label: 'Analytics',
          ),
          _navItem(
            context,
            index: 2,
            icon: Icons.folder_rounded,
            label: 'Projects',
          ),
          _navItem(
            context,
            index: 3,
            icon: Icons.task_alt_rounded,
            label: 'Tasks',
          ),

          const Spacer(),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'OTHER',
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: colors.onSurfaceVariant,
              ),
            ),
          ),

          const SizedBox(height: 10),

          _bottomItem(
            context,
            Icons.settings_rounded,
            'Settings',
          ),
          _bottomItem(
            context,
            Icons.help_outline_rounded,
            'Help & Support',
          ),

          const SizedBox(height: 16),

          // Profile
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.primaryContainer.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: colors.primary,
                  child: const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chandresh',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Student',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String label,
  }) {
    final colors = Theme.of(context).colorScheme;
    final selected = selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => onItemSelected(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: selected
                ? colors.primaryContainer
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 21,
                color: selected
                    ? colors.primary
                    : colors.onSurfaceVariant,
              ),
              const SizedBox(width: 14),
              Text(
                label,
                style: TextStyle(
                  fontWeight:
                      selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected
                      ? colors.primary
                      : colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomItem(
    BuildContext context,
    IconData icon,
    String label,
  ) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$label selected'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 21,
                color: colors.onSurfaceVariant,
              ),
              const SizedBox(width: 14),
              Text(
                label,
                style: TextStyle(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}