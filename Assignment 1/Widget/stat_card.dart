import 'package:flutter/material.dart';
import '../models/dashboard_data.dart';

class StatCard extends StatefulWidget {
  final DashboardStat stat;
  final int index;

  const StatCard({
    super.key,
    required this.stat,
    required this.index,
  });

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    Future.delayed(
      Duration(milliseconds: widget.index * 100),
      () {
        if (mounted) {
          _controller.forward();
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: colors.outline.withValues(alpha:0.08),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.06),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    widget.stat.icon,
                    color: colors.primary,
                    size: 22,
                  ),
                ),
                Icon(
                  Icons.more_horiz_rounded,
                  color: colors.outline,
                ),
              ],
            ),

            const Spacer(),

            Text(
              widget.stat.value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 5),

            Text(
              widget.stat.title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Icon(
                  Icons.arrow_upward_rounded,
                  size: 14,
                  color: colors.primary,
                ),
                const SizedBox(width: 3),
                Expanded(
                  child: Text(
                    widget.stat.change,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}