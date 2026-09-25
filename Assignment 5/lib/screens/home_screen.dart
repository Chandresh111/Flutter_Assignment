import 'package:flutter/material.dart';

import '../models/task_model.dart';
import '../utils/app_colors.dart';
import '../widgets/add_task_sheet.dart';
import '../widgets/filter_chips.dart';
import '../widgets/search_bar.dart';
import '../widgets/task_card.dart';
import 'calendar_screen.dart';
import 'categories_screen.dart';
import 'focus_timer_screen.dart';
import 'projects_screen.dart';
import 'tasks_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const HomeScreen({
    super.key,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedPage = 0;

  final List<Task> tasks = [
    Task(
      id: '1',
      title: 'Complete Flutter Assignment',
      description:
          'Build a dynamic and professional Todo application.',
    ),
    Task(
      id: '2',
      title: 'Practice DSA',
      description:
          'Solve 3 array and string problems.',
      isCompleted: true,
    ),
    Task(
      id: '3',
      title: 'Study Machine Learning',
      description:
          'Revise gradient descent and linear regression.',
    ),
    Task(
      id: '4',
      title: 'Work on Portfolio',
      description:
          'Improve project section and responsive design.',
    ),
  ];

  String selectedFilter = 'All';
  String searchQuery = '';

  int get completedCount =>
      tasks.where((task) => task.isCompleted).length;

  int get activeCount =>
      tasks.where((task) => !task.isCompleted).length;

  double get progress {
    if (tasks.isEmpty) return 0;
    return completedCount / tasks.length;
  }

  List<Task> get filteredTasks {
    var result = List<Task>.from(tasks);

    if (searchQuery.trim().isNotEmpty) {
      final query = searchQuery.toLowerCase().trim();

      result = result.where((task) {
        return task.title.toLowerCase().contains(query) ||
            task.description.toLowerCase().contains(query);
      }).toList();
    }

    switch (selectedFilter) {
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

    return result;
  }

  void _toggleTask(Task task) {
    setState(() {
      final index =
          tasks.indexWhere((item) => item.id == task.id);

      if (index != -1) {
        tasks[index] = tasks[index].copyWith(
          isCompleted: !tasks[index].isCompleted,
        );
      }
    });
  }

  void _deleteTask(Task task) {
    final index =
        tasks.indexWhere((item) => item.id == task.id);

    if (index == -1) return;

    setState(() {
      tasks.removeAt(index);
    });

    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '"${task.title}" deleted',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            setState(() {
              tasks.insert(
                index.clamp(0, tasks.length),
                task,
              );
            });
          },
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  void _addTask(
    String title,
    String description,
  ) {
    final task = Task(
      id: DateTime.now()
          .microsecondsSinceEpoch
          .toString(),
      title: title,
      description: description,
    );

    setState(() {
      tasks.insert(0, task);
      selectedFilter = 'All';
      searchQuery = '';
    });

    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Task added successfully'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showAddTaskSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context)
                .scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: AddTaskSheet(
            onAddTask: _addTask,
          ),
        );
      },
    );
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  Widget _buildCurrentPage() {
    switch (_selectedPage) {
      case 1:
        return TasksScreen(
          tasks: tasks,
          onToggleTask: _toggleTask,
          onDeleteTask: _deleteTask,
          onSearchChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
          searchQuery: searchQuery,
          selectedFilter: selectedFilter,
          onFilterChanged: (value) {
            setState(() {
              selectedFilter = value;
            });
          },
          onAddTask: _showAddTaskSheet,
        );

      case 2:
        return CalendarScreen(
          tasks: tasks,
          onAddTask: _showAddTaskSheet,
        );

      case 3:
        return ProjectsScreen(
          onAddTask: _showAddTaskSheet,
        );

      case 4:
        return CategoriesScreen(
          tasks: tasks,
          onAddTask: _showAddTaskSheet,
        );

      case 5:
        return const FocusTimerScreen();

      default:
        return _DashboardPage(
          tasks: tasks,
          completedCount: completedCount,
          activeCount: activeCount,
          progress: progress,
          filteredTasks: filteredTasks,
          selectedFilter: selectedFilter,
          searchQuery: searchQuery,
          onAddTask: _showAddTaskSheet,
          onToggleTask: _toggleTask,
          onDeleteTask: _deleteTask,
          onFilterChanged: (value) {
            setState(() {
              selectedFilter = value;
            });
          },
          onSearchChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final desktop = constraints.maxWidth >= 900;

        if (desktop) {
          return _buildDesktopLayout();
        }

        return _buildMobileLayout();
      },
    );
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      body: Row(
        children: [
          _Sidebar(
            selectedPage: _selectedPage,
            isDarkMode: widget.isDarkMode,
            onPageSelected: _selectPage,
            onThemeToggle: widget.onThemeToggle,
          ),
          Expanded(
            child: Column(
              children: [
                _TopBar(
                  pageTitle: _pageTitle,
                  onAddTask: _showAddTaskSheet,
                ),
                Expanded(
                  child: _buildCurrentPage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.secondary,
                  ],
                ),
                borderRadius:
                    BorderRadius.circular(11),
              ),
              child: const Icon(
                Icons.bolt_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'TaskFlow',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: widget.isDarkMode
                ? 'Light mode'
                : 'Dark mode',
            onPressed: widget.onThemeToggle,
            icon: Icon(
              widget.isDarkMode
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
            ),
          ),
        ],
      ),
      body: _buildCurrentPage(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedPage,
        onDestinationSelected: _selectPage,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon:
                Icon(Icons.dashboard_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.checklist_outlined),
            selectedIcon:
                Icon(Icons.checklist_rounded),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon:
                Icon(Icons.calendar_month_rounded),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_outlined),
            selectedIcon:
                Icon(Icons.folder_rounded),
            label: 'Projects',
          ),
          NavigationDestination(
            icon: Icon(Icons.more_horiz_rounded),
            selectedIcon:
                Icon(Icons.more_horiz_rounded),
            label: 'More',
          ),
        ],
      ),
    );
  }

  String get _pageTitle {
    switch (_selectedPage) {
      case 1:
        return 'Tasks';
      case 2:
        return 'Calendar';
      case 3:
        return 'Projects';
      case 4:
        return 'Categories';
      case 5:
        return 'Focus Timer';
      default:
        return 'Dashboard';
    }
  }
}

/* ═══════════════════════════════════════════════════════════════
   SIDEBAR
   ═══════════════════════════════════════════════════════════════ */

class _Sidebar extends StatelessWidget {
  final int selectedPage;
  final bool isDarkMode;
  final ValueChanged<int> onPageSelected;
  final VoidCallback onThemeToggle;

  const _Sidebar({
    required this.selectedPage,
    required this.isDarkMode,
    required this.onPageSelected,
    required this.onThemeToggle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          right: BorderSide(
            color: colors.outline.withValues(
              alpha: 0.08,
            ),
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 20,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      gradient:
                          const LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.secondary,
                        ],
                      ),
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.bolt_rounded,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TaskFlow',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              FontWeight.w800,
                          color: colors.onSurface,
                        ),
                      ),
                      Text(
                        'Track your life',
                        style: TextStyle(
                          fontSize: 10,
                          color: colors
                              .onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 32),

              _SidebarItem(
                icon:
                    Icons.dashboard_rounded,
                title: 'Dashboard',
                selected: selectedPage == 0,
                onTap: () => onPageSelected(0),
              ),

              _SidebarItem(
                icon:
                    Icons.checklist_rounded,
                title: 'Tasks',
                selected: selectedPage == 1,
                onTap: () => onPageSelected(1),
              ),

              _SidebarItem(
                icon:
                    Icons.calendar_month_rounded,
                title: 'Calendar',
                selected: selectedPage == 2,
                onTap: () => onPageSelected(2),
              ),

              _SidebarItem(
                icon: Icons.folder_rounded,
                title: 'Projects',
                selected: selectedPage == 3,
                onTap: () => onPageSelected(3),
              ),

              _SidebarItem(
                icon:
                    Icons.category_rounded,
                title: 'Categories',
                selected: selectedPage == 4,
                onTap: () => onPageSelected(4),
              ),

              _SidebarItem(
                icon:
                    Icons.timer_rounded,
                title: 'Focus Timer',
                selected: selectedPage == 5,
                onTap: () => onPageSelected(5),
              ),

              const Spacer(),

              _SidebarItem(
                icon: isDarkMode
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
                title: isDarkMode
                    ? 'Light Mode'
                    : 'Dark Mode',
                onTap: onThemeToggle,
              ),

              _SidebarItem(
                icon:
                    Icons.settings_outlined,
                title: 'Settings',
                onTap: () {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Settings coming soon',
                      ),
                      behavior:
                          SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.title,
    this.selected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).colorScheme;

    return Padding(
      padding:
          const EdgeInsets.only(bottom: 5),
      child: Material(
        color: selected
            ? colors.primary
            : Colors.transparent,
        borderRadius:
            BorderRadius.circular(11),
        child: InkWell(
          onTap: onTap,
          borderRadius:
              BorderRadius.circular(11),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 11,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 19,
                  color: selected
                      ? Colors.white
                      : colors
                          .onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: selected
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: selected
                        ? Colors.white
                        : colors.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ═══════════════════════════════════════════════════════════════
   TOP BAR
   ═══════════════════════════════════════════════════════════════ */

class _TopBar extends StatelessWidget {
  final String pageTitle;
  final VoidCallback onAddTask;

  const _TopBar({
    required this.pageTitle,
    required this.onAddTask,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).colorScheme;

    return Container(
      height: 82,
      padding:
          const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(
            color: colors.outline
                .withValues(alpha: 0.07),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  pageTitle,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight:
                        FontWeight.w800,
                    letterSpacing: -0.6,
                    color: colors.onSurface,
                  ),
                ),
                Text(
                  'One degree more every single day. 🔥',
                  style: TextStyle(
                    fontSize: 11,
                    color:
                        colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          _TopIconButton(
            icon:
                Icons.notifications_none_rounded,
            onTap: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                const SnackBar(
                  content: Text(
                    'No new notifications',
                  ),
                  behavior:
                      SnackBarBehavior.floating,
                ),
              );
            },
          ),

          const SizedBox(width: 9),

          FilledButton.icon(
            onPressed: onAddTask,
            icon: const Icon(
              Icons.add_rounded,
            ),
            label: const Text('Add Task'),
            style: FilledButton.styleFrom(
              backgroundColor:
                  AppColors.primary,
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 17,
                vertical: 13,
              ),
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _TopIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(12),
        child: Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            border: Border.all(
              color: colors.outline
                  .withValues(alpha: 0.12),
            ),
            borderRadius:
                BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 20,
            color:
                colors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

/* ═══════════════════════════════════════════════════════════════
   DASHBOARD
   ═══════════════════════════════════════════════════════════════ */

class _DashboardPage extends StatelessWidget {
  final List<Task> tasks;
  final List<Task> filteredTasks;
  final int completedCount;
  final int activeCount;
  final double progress;
  final String selectedFilter;
  final String searchQuery;

  final VoidCallback onAddTask;
  final ValueChanged<Task> onToggleTask;
  final ValueChanged<Task> onDeleteTask;
  final ValueChanged<String> onFilterChanged;
  final ValueChanged<String> onSearchChanged;

  const _DashboardPage({
    required this.tasks,
    required this.filteredTasks,
    required this.completedCount,
    required this.activeCount,
    required this.progress,
    required this.selectedFilter,
    required this.searchQuery,
    required this.onAddTask,
    required this.onToggleTask,
    required this.onDeleteTask,
    required this.onFilterChanged,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).colorScheme;

    return ListView(
      physics:
          const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        22,
        18,
        22,
        40,
      ),
      children: [
        _WelcomeBanner(
          active: activeCount,
          completed: completedCount,
          progress: progress,
        ),

        const SizedBox(height: 18),

        _OverviewRow(
          total: tasks.length,
          active: activeCount,
          completed: completedCount,
          progress: progress,
        ),

        const SizedBox(height: 18),

        LayoutBuilder(
          builder: (context, constraints) {
            final wide =
                constraints.maxWidth >= 1100;

            if (wide) {
              return Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: _TodoPanel(
                      tasks: filteredTasks,
                      selectedFilter:
                          selectedFilter,
                      searchQuery:
                          searchQuery,
                      onFilterChanged:
                          onFilterChanged,
                      onToggleTask:
                          onToggleTask,
                      onDeleteTask:
                          onDeleteTask,
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    flex: 6,
                    child: _ProductivityPanel(
                      progress: progress,
                      completed:
                          completedCount,
                      active: activeCount,
                    ),
                  ),
                ],
              );
            }

            return Column(
              children: [
                _TodoPanel(
                  tasks: filteredTasks,
                  selectedFilter:
                      selectedFilter,
                  searchQuery:
                      searchQuery,
                  onFilterChanged:
                      onFilterChanged,
                  onToggleTask:
                      onToggleTask,
                  onDeleteTask:
                      onDeleteTask,
                ),
                const SizedBox(height: 18),
                _ProductivityPanel(
                  progress: progress,
                  completed:
                      completedCount,
                  active: activeCount,
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 18),

        _QuickActions(
          activeTasks: activeCount,
          onAddTask: onAddTask,
        ),

        if (colors.brightness ==
            Brightness.dark)
          const SizedBox(height: 1),
      ],
    );
  }
}

class _WelcomeBanner extends StatelessWidget {
  final int active;
  final int completed;
  final double progress;

  const _WelcomeBanner({
    required this.active,
    required this.completed,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        gradient:
            const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.blueSurface,
            AppColors.cyanSurface,
          ],
        ),
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.primary
              .withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello! 👋',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                        FontWeight.w700,
                    color: colors.primary,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  active == 0
                      ? 'Your day is completely clear!'
                      : 'You have $active tasks to focus on today.',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.w800,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '$completed completed · '
                  '${(progress * 100).round()}% overall progress',
                  style: TextStyle(
                    fontSize: 11,
                    color:
                        colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          SizedBox(
            width: 72,
            height: 72,
            child: Stack(
              alignment:
                  Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: 1,
                  strokeWidth: 6,
                  color: Colors.white
                      .withValues(alpha: 0.65),
                ),
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 6,
                  strokeCap:
                      StrokeCap.round,
                  color: colors.primary,
                ),
                Text(
                  '${(progress * 100).round()}%',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w900,
                    color: colors.primary,
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

/* ═══════════════════════════════════════════════════════════════
   OVERVIEW
   ═══════════════════════════════════════════════════════════════ */

class _OverviewRow extends StatelessWidget {
  final int total;
  final int active;
  final int completed;
  final double progress;

  const _OverviewRow({
    required this.total,
    required this.active,
    required this.completed,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width =
            (constraints.maxWidth - 36) / 4;

        return Row(
          children: [
            SizedBox(
              width: width,
              child: _MetricCard(
                icon: Icons.checklist_rounded,
                title: 'Total Tasks',
                value: '$total',
                subtitle: 'All tasks',
                color: AppColors.primary,
                surface: AppColors.blueSurface,
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: width,
              child: _MetricCard(
                icon:
                    Icons.pending_actions_rounded,
                title: 'Active',
                value: '$active',
                subtitle: 'Need attention',
                color: AppColors.warning,
                surface:
                    AppColors.orangeSurface,
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: width,
              child: _MetricCard(
                icon:
                    Icons.task_alt_rounded,
                title: 'Completed',
                value: '$completed',
                subtitle: 'Great work',
                color: AppColors.success,
                surface:
                    AppColors.greenSurface,
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: width,
              child: _MetricCard(
                icon:
                    Icons.insights_rounded,
                title: 'Productivity',
                value:
                    '${(progress * 100).round()}%',
                subtitle: 'Overall progress',
                color: AppColors.accent,
                surface:
                    AppColors.violetSurface,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final Color surface;

  const _MetricCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    required this.surface,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color:
            Theme.of(context).cardColor,
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color: colors.outline
              .withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: surface,
              borderRadius:
                  BorderRadius.circular(12),
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
                  style: TextStyle(
                    fontSize: 9,
                    color:
                        colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight:
                        FontWeight.w900,
                    color:
                        colors.onSurface,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 8.5,
                    color:
                        colors.onSurfaceVariant,
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

/* ═══════════════════════════════════════════════════════════════
   TODO PANEL
   ═══════════════════════════════════════════════════════════════ */

class _TodoPanel extends StatelessWidget {
  final List<Task> tasks;
  final String selectedFilter;
  final String searchQuery;

  final ValueChanged<String>
      onFilterChanged;
  final ValueChanged<Task> onToggleTask;
  final ValueChanged<Task> onDeleteTask;

  const _TodoPanel({
    required this.tasks,
    required this.selectedFilter,
    required this.searchQuery,
    required this.onFilterChanged,
    required this.onToggleTask,
    required this.onDeleteTask,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color:
            Theme.of(context).cardColor,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: colors.outline
              .withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'To Do List',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight:
                      FontWeight.w800,
                  color:
                      colors.onSurface,
                ),
              ),
              const Spacer(),
              Text(
                '${tasks.length} tasks',
                style: TextStyle(
                  fontSize: 10,
                  color:
                      colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          FilterChips(
            selectedFilter:
                selectedFilter,
            onFilterChanged:
                onFilterChanged,
          ),
          const SizedBox(height: 14),
          if (tasks.isEmpty)
            _EmptyTaskState(
              searching:
                  searchQuery.isNotEmpty,
            )
          else
            ...tasks.take(6).map(
              (task) => Padding(
                padding:
                    const EdgeInsets.only(
                  bottom: 9,
                ),
                child: TaskCard(
                  key: ValueKey(task.id),
                  task: task,
                  onToggle: () =>
                      onToggleTask(task),
                  onDelete: () =>
                      onDeleteTask(task),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyTaskState
    extends StatelessWidget {
  final bool searching;

  const _EmptyTaskState({
    required this.searching,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(
        vertical: 32,
      ),
      decoration: BoxDecoration(
        color: colors.primaryContainer
            .withValues(alpha: 0.2),
        borderRadius:
            BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(
            searching
                ? Icons.search_off_rounded
                : Icons.task_alt_rounded,
            size: 32,
            color: colors.primary,
          ),
          const SizedBox(height: 9),
          Text(
            searching
                ? 'No tasks found'
                : 'Nothing here yet',
            style: TextStyle(
              fontWeight:
                  FontWeight.w700,
              color:
                  colors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

/* ═══════════════════════════════════════════════════════════════
   PRODUCTIVITY
   ═══════════════════════════════════════════════════════════════ */

class _ProductivityPanel
    extends StatelessWidget {
  final double progress;
  final int completed;
  final int active;

  const _ProductivityPanel({
    required this.progress,
    required this.completed,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color:
            Theme.of(context).cardColor,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: colors.outline
              .withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Productivity Tracker',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight:
                      FontWeight.w800,
                  color:
                      colors.onSurface,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 6,
                ),
                decoration:
                    BoxDecoration(
                  color:
                      AppColors.blueSurface,
                  borderRadius:
                      BorderRadius.circular(
                    8,
                  ),
                ),
                child: Text(
                  'This Week',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight:
                        FontWeight.w700,
                    color:
                        colors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          SizedBox(
            height: 175,
            child: CustomPaint(
              painter:
                  _ChartPainter(
                progress: progress,
                lineColor:
                    colors.primary,
                gridColor: colors
                    .outline
                    .withValues(
                  alpha: 0.08,
                ),
              ),
              child:
                  const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: 9),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceAround,
            children: [
              _DayLabel(
                day: 'Mon',
                value: '62%',
              ),
              _DayLabel(
                day: 'Tue',
                value: '74%',
              ),
              _DayLabel(
                day: 'Wed',
                value: '55%',
              ),
              _DayLabel(
                day: 'Thu',
                value: '81%',
              ),
              _DayLabel(
                day: 'Fri',
                value:
                    '${(progress * 100).round()}%',
              ),
            ],
          ),
          const SizedBox(height: 17),
          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  icon:
                      Icons.check_circle_rounded,
                  value: '$completed',
                  label: 'Completed',
                  color:
                      AppColors.success,
                ),
              ),
              Expanded(
                child: _MiniStat(
                  icon:
                      Icons.pending_actions_rounded,
                  value: '$active',
                  label: 'Remaining',
                  color:
                      AppColors.warning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChartPainter
    extends CustomPainter {
  final double progress;
  final Color lineColor;
  final Color gridColor;

  const _ChartPainter({
    required this.progress,
    required this.lineColor,
    required this.gridColor,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;

    for (int i = 1; i <= 4; i++) {
      final y =
          size.height * i / 5;

      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    const values = [
      0.58,
      0.68,
      0.53,
      0.76,
      0.64,
      0.84,
      0.72,
      0.92,
    ];

    final points =
        <Offset>[];

    for (int i = 0;
        i < values.length;
        i++) {
      final x = size.width *
          i /
          (values.length - 1);

      final y = size.height *
          (1 - values[i]);

      points.add(
        Offset(x, y),
      );
    }

    final path = Path()
      ..moveTo(
        points.first.dx,
        points.first.dy,
      );

    for (int i = 0;
        i < points.length - 1;
        i++) {
      final current =
          points[i];
      final next =
          points[i + 1];

      final controlX =
          (current.dx +
                  next.dx) /
              2;

      path.cubicTo(
        controlX,
        current.dy,
        controlX,
        next.dy,
        next.dx,
        next.dy,
      );
    }

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 3
      ..style =
          PaintingStyle.stroke
      ..strokeCap =
          StrokeCap.round
      ..strokeJoin =
          StrokeJoin.round;

    canvas.drawPath(
      path,
      paint,
    );

    final last =
        points.last;

    canvas.drawCircle(
      last,
      5,
      Paint()..color = lineColor,
    );

    canvas.drawCircle(
      last,
      2,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(
    covariant _ChartPainter oldDelegate,
  ) {
    return oldDelegate.progress !=
            progress ||
        oldDelegate.lineColor !=
            lineColor;
  }
}

class _DayLabel
    extends StatelessWidget {
  final String day;
  final String value;

  const _DayLabel({
    required this.day,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).colorScheme;

    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 9,
            fontWeight:
                FontWeight.w700,
            color:
                colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          day,
          style: TextStyle(
            fontSize: 9,
            color:
                colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _MiniStat
    extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _MiniStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: color,
        ),
        const SizedBox(width: 6),
        Text(
          '$value ',
          style: TextStyle(
            fontSize: 11,
            fontWeight:
                FontWeight.w800,
            color:
                colors.onSurface,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color:
                colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/* ═══════════════════════════════════════════════════════════════
   QUICK ACTIONS
   ═══════════════════════════════════════════════════════════════ */

class _QuickActions
    extends StatelessWidget {
  final int activeTasks;
  final VoidCallback onAddTask;

  const _QuickActions({
    required this.activeTasks,
    required this.onAddTask,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color:
            Theme.of(context).cardColor,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: colors.outline
              .withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Stay focused',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.w800,
                    color:
                        colors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activeTasks == 0
                      ? 'Everything is completed!'
                      : '$activeTasks tasks are waiting for you.',
                  style: TextStyle(
                    fontSize: 10,
                    color:
                        colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          FilledButton.icon(
            onPressed: onAddTask,
            icon: const Icon(
              Icons.add_rounded,
            ),
            label: const Text(
              'New Task',
            ),
          ),
        ],
      ),
    );
  }
}