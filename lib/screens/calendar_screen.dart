import 'package:flutter/material.dart';

import '../models/task_model.dart';
import '../utils/app_colors.dart';

class CalendarScreen extends StatefulWidget {
  final List<Task> tasks;
  final VoidCallback onAddTask;

  const CalendarScreen({
    super.key,
    required this.tasks,
    required this.onAddTask,
  });

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _displayedMonth;
  late DateTime _selectedDate;

  final DateTime _today = DateTime.now();

  @override
  void initState() {
    super.initState();

    _displayedMonth = DateTime(
      _today.year,
      _today.month,
    );

    _selectedDate = DateTime(
      _today.year,
      _today.month,
      _today.day,
    );
  }

  bool _isSameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  bool _isToday(DateTime date) {
    return _isSameDay(date, _today);
  }

  bool _isSelected(DateTime date) {
    return _isSameDay(date, _selectedDate);
  }

  bool _isCurrentMonth(DateTime date) {
    return date.month == _displayedMonth.month &&
        date.year == _displayedMonth.year;
  }

  void _previousMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month - 1,
      );
    });
  }

  void _nextMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + 1,
      );
    });
  }

  void _goToToday() {
    setState(() {
      _displayedMonth = DateTime(
        _today.year,
        _today.month,
      );

      _selectedDate = DateTime(
        _today.year,
        _today.month,
        _today.day,
      );
    });
  }

  List<DateTime> _buildCalendarDays() {
    final firstDay = DateTime(
      _displayedMonth.year,
      _displayedMonth.month,
      1,
    );

    final daysInMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month + 1,
      0,
    ).day;

    // Monday = 1 ... Sunday = 7.
    final leadingDays = firstDay.weekday - 1;

    final previousMonthLastDay = DateTime(
      _displayedMonth.year,
      _displayedMonth.month,
      0,
    ).day;

    final days = <DateTime>[];

    for (int i = leadingDays; i > 0; i--) {
      days.add(
        DateTime(
          _displayedMonth.year,
          _displayedMonth.month - 1,
          previousMonthLastDay - i + 1,
        ),
      );
    }

    for (int day = 1; day <= daysInMonth; day++) {
      days.add(
        DateTime(
          _displayedMonth.year,
          _displayedMonth.month,
          day,
        ),
      );
    }

    while (days.length < 42) {
      final nextDay = days.length -
          leadingDays -
          daysInMonth +
          1;

      days.add(
        DateTime(
          _displayedMonth.year,
          _displayedMonth.month + 1,
          nextDay,
        ),
      );
    }

    return days;
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return months[month - 1];
  }

  List<Task> _tasksForSelectedDate() {
    // The current Task model does not contain a due-date field.
    // Therefore, existing tasks are shown as today's agenda.
    if (!_isToday(_selectedDate)) {
      return [];
    }

    return widget.tasks;
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

            LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 1050;

                if (wide) {
                  return Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 7,
                        child: _buildCalendarCard(
                          context,
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        flex: 3,
                        child: _buildAgendaCard(
                          context,
                        ),
                      ),
                    ],
                  );
                }

                return Column(
                  children: [
                    _buildCalendarCard(context),
                    const SizedBox(height: 18),
                    _buildAgendaCard(context),
                  ],
                );
              },
            ),
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
                'Planning',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: colors.primary,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Calendar',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Plan your days and keep your priorities visible.',
                style: TextStyle(
                  fontSize: 12,
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        OutlinedButton.icon(
          onPressed: _goToToday,
          icon: const Icon(
            Icons.today_rounded,
            size: 17,
          ),
          label: const Text('Today'),
        ),
      ],
    );
  }

  Widget _buildCalendarCard(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final days = _buildCalendarDays();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colors.outline.withValues(
            alpha: 0.08,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: colors.primaryContainer.withValues(
                    alpha: 0.45,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.calendar_month_rounded,
                  color: colors.primary,
                  size: 21,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${_monthName(_displayedMonth.month)} '
                  '${_displayedMonth.year}',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: colors.onSurface,
                  ),
                ),
              ),
              _CalendarNavButton(
                icon: Icons.chevron_left_rounded,
                onTap: _previousMonth,
              ),
              const SizedBox(width: 6),
              _CalendarNavButton(
                icon: Icons.chevron_right_rounded,
                onTap: _nextMonth,
              ),
            ],
          ),

          const SizedBox(height: 22),

          Row(
            children: [
              'Mon',
              'Tue',
              'Wed',
              'Thu',
              'Fri',
              'Sat',
              'Sun',
            ].map(
              (day) {
                return Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                );
              },
            ).toList(),
          ),

          const SizedBox(height: 10),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: days.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 7,
              crossAxisSpacing: 7,
              childAspectRatio: 1.25,
            ),
            itemBuilder: (context, index) {
              final date = days[index];

              return _CalendarDay(
                date: date,
                selected: _isSelected(date),
                today: _isToday(date),
                currentMonth: _isCurrentMonth(date),
                hasTasks: _isToday(date) &&
                    widget.tasks.isNotEmpty,
                onTap: () {
                  setState(() {
                    _selectedDate = date;
                  });
                },
              );
            },
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              _LegendItem(
                color: colors.primary,
                label: 'Selected',
              ),
              const SizedBox(width: 18),
              _LegendItem(
                color: AppColors.success,
                label: 'Today',
              ),
              const SizedBox(width: 18),
              _LegendItem(
                color: colors.outline,
                label: 'Other days',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAgendaCard(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final selectedTasks = _tasksForSelectedDate();

    final completed = selectedTasks
        .where((task) => task.isCompleted)
        .length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
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
                      'Daily Agenda',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_selectedDate.day} '
                      '${_monthName(_selectedDate.month)} '
                      '${_selectedDate.year}',
                      style: TextStyle(
                        fontSize: 10,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.blueSurface,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  '${selectedTasks.length} tasks',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: colors.primary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          if (selectedTasks.isEmpty)
            _buildEmptyAgenda(context)
          else ...[
            Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: AppColors.blueSurface,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.insights_rounded,
                    color: colors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '$completed of ${selectedTasks.length} '
                      'tasks completed',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: colors.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 13),

            ...selectedTasks.map(
              (task) => Padding(
                padding: const EdgeInsets.only(
                  bottom: 9,
                ),
                child: _AgendaItem(
                  task: task,
                ),
              ),
            ),
          ],

          const SizedBox(height: 8),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: widget.onAddTask,
              icon: const Icon(
                Icons.add_rounded,
                size: 17,
              ),
              label: const Text(
                'Schedule Task',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyAgenda(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 38,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: colors.primaryContainer.withValues(
          alpha: 0.2,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(
            Icons.event_available_rounded,
            size: 34,
            color: colors.primary,
          ),
          const SizedBox(height: 11),
          Text(
            'No tasks scheduled',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: colors.onSurface,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            _isToday(_selectedDate)
                ? 'Your current tasks will appear here.'
                : 'No tasks are assigned to this date yet.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarNavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CalendarNavButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: colors.primaryContainer.withValues(
        alpha: 0.3,
      ),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 38,
          height: 38,
          child: Icon(
            icon,
            size: 20,
            color: colors.onSurface,
          ),
        ),
      ),
    );
  }
}

class _CalendarDay extends StatelessWidget {
  final DateTime date;
  final bool selected;
  final bool today;
  final bool currentMonth;
  final bool hasTasks;
  final VoidCallback onTap;

  const _CalendarDay({
    required this.date,
    required this.selected,
    required this.today,
    required this.currentMonth,
    required this.hasTasks,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    Color background;

    if (selected) {
      background = colors.primary;
    } else if (today) {
      background = AppColors.greenSurface;
    } else {
      background = Colors.transparent;
    }

    final Color textColor;

    if (selected) {
      textColor = Colors.white;
    } else if (!currentMonth) {
      textColor = colors.onSurfaceVariant.withValues(
        alpha: 0.35,
      );
    } else {
      textColor = colors.onSurface;
    }

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: today && !selected
                ? Border.all(
                    color: AppColors.success.withValues(
                      alpha: 0.35,
                    ),
                  )
                : null,
          ),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Text(
                '${date.day}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: selected || today
                      ? FontWeight.w800
                      : FontWeight.w500,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(
                  milliseconds: 180,
                ),
                width: hasTasks ? 5 : 3,
                height: hasTasks ? 5 : 3,
                decoration: BoxDecoration(
                  color: hasTasks
                      ? (selected
                          ? Colors.white
                          : AppColors.primary)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            color: colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _AgendaItem extends StatelessWidget {
  final Task task;

  const _AgendaItem({
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withValues(
          alpha: 0.25,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colors.outline.withValues(
            alpha: 0.06,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(
              color: task.isCompleted
                  ? AppColors.success
                  : AppColors.warning,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: colors.onSurface,
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                if (task.description.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    task.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 9,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            task.isCompleted
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            size: 18,
            color: task.isCompleted
                ? AppColors.success
                : colors.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}