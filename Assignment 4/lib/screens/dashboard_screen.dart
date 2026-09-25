import 'package:flutter/material.dart';

import '../models/dashboard_data.dart';
import '../widgets/activity_tile.dart';
import '../widgets/overview_card.dart';
import '../widgets/sidebar.dart';
import '../widgets/stat_card.dart';

import 'analytics_screen.dart';
import 'projects_screen.dart';
import 'tasks_screen.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final bool isDark;

  const DashboardScreen({
    super.key,
    required this.onThemeToggle,
    required this.isDark,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 0;
  String searchQuery = '';

  List<Activity> get filteredActivities {
    if (searchQuery.trim().isEmpty) {
      return DashboardData.activities;
    }

    return DashboardData.activities.where((activity) {
      final query = searchQuery.toLowerCase();

      return activity.title.toLowerCase().contains(query) ||
          activity.description.toLowerCase().contains(query);
    }).toList();
  }

  // Handles navigation from the sidebar.
  void selectMenu(int index) {
    setState(() {
      selectedIndex = index;
    });

    switch (index) {
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const AnalyticsScreen(),
          ),
        );
        break;

      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ProjectsScreen(),
          ),
        );
        break;

      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const TasksScreen(),
          ),
        );
        break;

      case 4:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Settings selected'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 1),
          ),
        );
        break;

      case 5:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Help & Support selected'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 1),
          ),
        );
        break;

      default:
        break;
    }
  }

  void toggleActivity(Activity activity) {
    setState(() {
      activity.completed = !activity.completed;
    });
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery is used to make the dashboard responsive.
    final screenWidth = MediaQuery.of(context).size.width;

    final bool isMobile = screenWidth < 700;
    final bool isTablet = screenWidth >= 700 && screenWidth < 1100;

    final int gridColumns = isMobile
        ? 2
        : isTablet
            ? 2
            : 4;

    return Scaffold(
      drawer: isMobile
          ? Drawer(
              child: SafeArea(
                child: Sidebar(
                  selectedIndex: selectedIndex,
                  onItemSelected: (index) {
                    Navigator.pop(context);
                    selectMenu(index);
                  },
                ),
              ),
            )
          : null,
      body: Row(
        children: [
          // Sidebar is displayed only on larger screens.
          if (!isMobile)
            Sidebar(
              selectedIndex: selectedIndex,
              onItemSelected: selectMenu,
            ),

          // Expanded allows the main dashboard to use remaining space.
          Expanded(
            child: SafeArea(
              child: Column(
                children: [
                  _buildTopBar(context, isMobile),

                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 18 : 30,
                        vertical: 10,
                      ),
                      children: [
                        _buildWelcomeSection(context),

                        const SizedBox(height: 24),

                        _buildStatsSection(
                          context,
                          gridColumns,
                          isMobile,
                        ),

                        const SizedBox(height: 30),

                        _buildOverviewSection(
                          context,
                          isMobile,
                        ),

                        const SizedBox(height: 30),

                        _buildActivitySection(
                          context,
                          isMobile,
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(
    BuildContext context,
    bool isMobile,
  ) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        isMobile ? 14 : 30,
        14,
        isMobile ? 14 : 30,
        8,
      ),
      child: Row(
        children: [
          if (isMobile)
            Builder(
              builder: (context) {
                return IconButton(
                  tooltip: 'Open menu',
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(
                    Icons.menu_rounded,
                  ),
                );
              },
            ),

          if (isMobile) const SizedBox(width: 4),

          Flexible(
            child: Text(
              selectedIndex == 0
                  ? 'Dashboard'
                  : 'Student Dashboard',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const Spacer(),

          IconButton(
            tooltip: 'Notifications',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'You have 3 new notifications',
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: Badge(
              label: const Text('3'),
              child: Icon(
                Icons.notifications_none_rounded,
                color: colors.onSurface,
              ),
            ),
          ),

          IconButton(
            tooltip: 'Change theme',
            onPressed: widget.onThemeToggle,
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Icon(
                widget.isDark
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
                key: ValueKey(widget.isDark),
              ),
            ),
          ),

          if (!isMobile) const SizedBox(width: 6),

          if (!isMobile)
            CircleAvatar(
              radius: 19,
              backgroundColor: colors.primary,
              child: const Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors.primary,
            colors.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good evening, Chandresh 👋',
                  style: TextStyle(
                    color: colors.onPrimary,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Keep learning, keep building, keep growing.',
                  style: TextStyle(
                    color: colors.onPrimary.withValues(alpha: 0.82),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          if (MediaQuery.of(context).size.width >= 500)
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_awesome_rounded,
                color: colors.onPrimary,
                size: 32,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(
    BuildContext context,
    int gridColumns,
    bool isMobile,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Overview',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 15),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: DashboardData.stats.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridColumns,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: isMobile ? 1.18 : 1.35,
          ),
          itemBuilder: (context, index) {
            return StatCard(
              stat: DashboardData.stats[index],
              index: index,
            );
          },
        ),
      ],
    );
  }

  Widget _buildOverviewSection(
    BuildContext context,
    bool isMobile,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Overview',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 15),

        if (isMobile)
          const Column(
            children: [
              OverviewCard(
                icon: Icons.school_rounded,
                title: 'Learning',
                subtitle: '8 courses in progress',
                progress: 0.78,
                progressLabel: '78%',
              ),
              SizedBox(height: 15),
              OverviewCard(
                icon: Icons.code_rounded,
                title: 'Coding',
                subtitle: '15 problems solved',
                progress: 0.65,
                progressLabel: '65%',
              ),
            ],
          )
        else
          const Row(
            children: [
              Expanded(
                child: OverviewCard(
                  icon: Icons.school_rounded,
                  title: 'Learning',
                  subtitle: '8 courses in progress',
                  progress: 0.78,
                  progressLabel: '78%',
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: OverviewCard(
                  icon: Icons.code_rounded,
                  title: 'Coding',
                  subtitle: '15 problems solved',
                  progress: 0.65,
                  progressLabel: '65%',
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildActivitySection(
    BuildContext context,
    bool isMobile,
  ) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(
              width: isMobile ? 150 : 220,
              height: 42,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: colors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 15),

        Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: colors.outline.withValues(alpha: 0.08),
            ),
          ),
          child: filteredActivities.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(30),
                  child: Center(
                    child: Text(
                      'No activities found.',
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredActivities.length,
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: 1,
                      indent: 76,
                      endIndent: 20,
                      color: colors.outline.withValues(alpha: 0.08),
                    );
                  },
                  itemBuilder: (context, index) {
                    final activity = filteredActivities[index];

                    return ActivityTile(
                      activity: activity,
                      onTap: () => toggleActivity(activity),
                    );
                  },
                ),
        ),
      ],
    );
  }
}