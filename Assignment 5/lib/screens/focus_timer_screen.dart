import 'dart:async';

import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class FocusTimerScreen extends StatefulWidget {
  const FocusTimerScreen({
    super.key,
  });

  @override
  State<FocusTimerScreen> createState() =>
      _FocusTimerScreenState();
}

class _FocusTimerScreenState
    extends State<FocusTimerScreen> {
  Timer? _timer;

  bool _isRunning = false;
  bool _isBreak = false;

  int _focusMinutes = 25;
  int _remainingSeconds = 25 * 60;
  int _completedSessions = 0;

  final List<int> _presets = [
    15,
    25,
    45,
    60,
  ];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int get _totalSeconds {
    if (_isBreak) {
      return 5 * 60;
    }

    return _focusMinutes * 60;
  }

  double get _progress {
    if (_totalSeconds == 0) {
      return 0;
    }

    return 1 -
        (_remainingSeconds / _totalSeconds);
  }

  String get _formattedTime {
    final minutes =
        (_remainingSeconds ~/ 60)
            .toString()
            .padLeft(2, '0');

    final seconds =
        (_remainingSeconds % 60)
            .toString()
            .padLeft(2, '0');

    return '$minutes:$seconds';
  }

  void _startTimer() {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (!mounted) return;

        if (_remainingSeconds <= 1) {
          _timer?.cancel();

          setState(() {
            _isRunning = false;
            _finishSession();
          });

          return;
        }

        setState(() {
          _remainingSeconds--;
        });
      },
    );
  }

  void _pauseTimer() {
    _timer?.cancel();

    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();

    setState(() {
      _isRunning = false;
      _isBreak = false;
      _remainingSeconds =
          _focusMinutes * 60;
    });
  }

  void _skipSession() {
    _timer?.cancel();

    setState(() {
      _isRunning = false;

      if (_isBreak) {
        _isBreak = false;
        _remainingSeconds =
            _focusMinutes * 60;
      } else {
        _completedSessions++;
        _isBreak = true;
        _remainingSeconds = 5 * 60;
      }
    });
  }

  void _finishSession() {
    if (_isBreak) {
      _isBreak = false;
      _remainingSeconds =
          _focusMinutes * 60;

      _showSessionMessage(
        'Break finished',
        'Ready for another focused session?',
        Icons.bolt_rounded,
      );
    } else {
      _completedSessions++;
      _isBreak = true;
      _remainingSeconds = 5 * 60;

      _showSessionMessage(
        'Focus session complete!',
        'Great work. Take a short break.',
        Icons.check_circle_rounded,
      );
    }
  }

  void _showSessionMessage(
    String title,
    String message,
    IconData icon,
  ) {
    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  void _selectPreset(int minutes) {
    if (_isRunning) return;

    setState(() {
      _focusMinutes = minutes;
      _isBreak = false;
      _remainingSeconds =
          minutes * 60;
    });
  }

  @override
  Widget build(BuildContext context) {
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

            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth >= 1050) {
                  return Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 6,
                        child: _buildTimerCard(
                          context,
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        flex: 4,
                        child: _buildStatsPanel(
                          context,
                        ),
                      ),
                    ],
                  );
                }

                return Column(
                  children: [
                    _buildTimerCard(context),
                    const SizedBox(height: 18),
                    _buildStatsPanel(context),
                  ],
                );
              },
            ),

            const SizedBox(height: 18),

            _buildHowItWorks(context),
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
                'Deep Work',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: colors.primary,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Focus Timer',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Protect your attention and make every minute count.',
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
                Icons.local_fire_department_rounded,
                size: 16,
                color: AppColors.accent,
              ),
              const SizedBox(width: 6),
              Text(
                '$_completedSessions sessions',
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

  Widget _buildTimerCard(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).cardColor,
            colors.primaryContainer.withValues(
              alpha: 0.12,
            ),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: colors.outline.withValues(
            alpha: 0.08,
          ),
        ),
      ),
      child: Column(
        children: [
          _buildModeToggle(context),

          const SizedBox(height: 28),

          _TimerCircle(
            progress: _progress,
            time: _formattedTime,
            isRunning: _isRunning,
            isBreak: _isBreak,
          ),

          const SizedBox(height: 26),

          Text(
            _isBreak
                ? 'Take a short break'
                : _isRunning
                    ? 'Stay focused'
                    : 'Ready when you are',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: colors.onSurface,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            _isBreak
                ? 'Step away and recharge your mind.'
                : 'Focus on one thing. Ignore the noise.',
            style: TextStyle(
              fontSize: 10.5,
              color: colors.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 22),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              _TimerActionButton(
                icon: Icons.refresh_rounded,
                label: 'Reset',
                onTap: _resetTimer,
              ),

              const SizedBox(width: 12),

              SizedBox(
                height: 50,
                child: FilledButton.icon(
                  onPressed: _isRunning
                      ? _pauseTimer
                      : _startTimer,
                  icon: Icon(
                    _isRunning
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                  ),
                  label: Text(
                    _isRunning
                        ? 'Pause'
                        : 'Start Focus',
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor:
                        AppColors.primary,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(13),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              _TimerActionButton(
                icon: Icons.skip_next_rounded,
                label: 'Skip',
                onTap: _skipSession,
              ),
            ],
          ),

          const SizedBox(height: 26),

          _buildPresets(context),
        ],
      ),
    );
  }

  Widget _buildModeToggle(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest
            .withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ModeButton(
              label: 'Focus',
              icon: Icons.bolt_rounded,
              selected: !_isBreak,
              onTap: () {
                if (_isRunning) return;

                setState(() {
                  _isBreak = false;
                  _remainingSeconds =
                      _focusMinutes * 60;
                });
              },
            ),
          ),
          Expanded(
            child: _ModeButton(
              label: 'Short Break',
              icon: Icons.coffee_rounded,
              selected: _isBreak,
              onTap: () {
                if (_isRunning) return;

                setState(() {
                  _isBreak = true;
                  _remainingSeconds = 5 * 60;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresets(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        Text(
          'FOCUS DURATION',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
            color: colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 9),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 7,
          children: _presets.map(
            (minutes) {
              final selected =
                  _focusMinutes == minutes &&
                      !_isBreak;

              return ChoiceChip(
                label: Text(
                  '$minutes min',
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                selected: selected,
                onSelected: (_) {
                  _selectPreset(minutes);
                },
                selectedColor: colors.primary,
                labelStyle: TextStyle(
                  color: selected
                      ? Colors.white
                      : colors.onSurface,
                ),
                showCheckmark: false,
                side: BorderSide(
                  color: colors.outline.withValues(
                    alpha: 0.10,
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ],
    );
  }

  Widget _buildStatsPanel(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final focusMinutes =
        _completedSessions * _focusMinutes;

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
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.violetSurface,
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.insights_rounded,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(width: 11),
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'Focus Stats',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Your current session progress',
                    style: TextStyle(
                      fontSize: 9.5,
                      color:
                          colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          _FocusStat(
            icon: Icons.check_circle_rounded,
            label: 'Completed Sessions',
            value: '$_completedSessions',
            color: AppColors.success,
          ),

          const SizedBox(height: 10),

          _FocusStat(
            icon: Icons.schedule_rounded,
            label: 'Focused Minutes',
            value: '$focusMinutes',
            color: AppColors.primary,
          ),

          const SizedBox(height: 10),

          _FocusStat(
            icon: Icons.local_fire_department_rounded,
            label: 'Current Streak',
            value: _completedSessions > 0
                ? 'Active'
                : 'Ready',
            color: AppColors.warning,
          ),

          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.blueSurface,
                  AppColors.cyanSurface,
                ],
              ),
              borderRadius:
                  BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Today\'s goal',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Complete 4 focus sessions',
                  style: TextStyle(
                    fontSize: 9.5,
                    color:
                        colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 11),
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value:
                        (_completedSessions / 4)
                            .clamp(0.0, 1.0),
                    minHeight: 7,
                    backgroundColor:
                        Colors.white.withValues(
                      alpha: 0.7,
                    ),
                    valueColor:
                        const AlwaysStoppedAnimation(
                      AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  '$_completedSessions / 4 sessions',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
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

  Widget _buildHowItWorks(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final items = [
      (
        Icons.bolt_rounded,
        'Focus',
        'Work without distractions.',
        AppColors.primary,
      ),
      (
        Icons.coffee_rounded,
        'Break',
        'Recharge for five minutes.',
        AppColors.secondary,
      ),
      (
        Icons.repeat_rounded,
        'Repeat',
        'Build momentum session by session.',
        AppColors.accent,
      ),
    ];

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
          Text(
            'How it works',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: colors.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'A simple rhythm for deeper concentration.',
            style: TextStyle(
              fontSize: 10,
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: items.map(
              (item) {
                return Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(
                      right: 12,
                    ),
                    child: _HowItWorksItem(
                      icon: item.$1,
                      title: item.$2,
                      description: item.$3,
                      color: item.$4,
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }
}

class _TimerCircle extends StatelessWidget {
  final double progress;
  final String time;
  final bool isRunning;
  final bool isBreak;

  const _TimerCircle({
    required this.progress,
    required this.time,
    required this.isRunning,
    required this.isBreak,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final timerColor = isBreak
        ? AppColors.secondary
        : colors.primary;

    return TweenAnimationBuilder<double>(
      tween: Tween(
        begin: 0,
        end: progress,
      ),
      duration: const Duration(
        milliseconds: 300,
      ),
      builder: (context, value, child) {
        return SizedBox(
          width: 245,
          height: 245,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 235,
                height: 235,
                child: CircularProgressIndicator(
                  value: 1,
                  strokeWidth: 12,
                  color: colors
                      .surfaceContainerHighest
                      .withValues(alpha: 0.55),
                ),
              ),
              SizedBox(
                width: 235,
                height: 235,
                child: CircularProgressIndicator(
                  value: value,
                  strokeWidth: 12,
                  strokeCap: StrokeCap.round,
                  color: timerColor,
                ),
              ),
              Container(
                width: 190,
                height: 190,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.surface
                      .withValues(alpha: 0.25),
                  boxShadow: [
                    BoxShadow(
                      color: timerColor.withValues(
                        alpha: 0.08,
                      ),
                      blurRadius: 35,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Icon(
                      isBreak
                          ? Icons.coffee_rounded
                          : isRunning
                              ? Icons.bolt_rounded
                              : Icons.play_circle_outline_rounded,
                      size: 25,
                      color: timerColor,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 43,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -2,
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isBreak
                          ? 'SHORT BREAK'
                          : 'FOCUS SESSION',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.3,
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
      },
    );
  }
}

class _TimerActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _TimerActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(
            horizontal: 13,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: colors.outline.withValues(
                alpha: 0.10,
              ),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 17,
                color: colors.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  color: colors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ModeButton({
    required this.label,
    required this.icon,
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
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 9,
          ),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 15,
                color: selected
                    ? Colors.white
                    : colors.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  color: selected
                      ? Colors.white
                      : colors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FocusStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _FocusStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest
            .withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(
              icon,
              size: 17,
              color: color,
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 9.5,
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: colors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _HowItWorksItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _HowItWorksItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.055),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: color.withValues(alpha: 0.10),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 18,
              color: color,
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 8.5,
                    height: 1.3,
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