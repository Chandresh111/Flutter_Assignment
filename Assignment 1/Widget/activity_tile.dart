import 'package:flutter/material.dart';
import '../models/dashboard_data.dart';

class ActivityTile extends StatelessWidget {
  final Activity activity;
  final VoidCallback onTap;

  const ActivityTile({
    super.key,
    required this.activity,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: activity.completed
                    ? colors.primary
                    : colors.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                activity.completed
                    ? Icons.check_rounded
                    : activity.icon,
                color: activity.completed
                    ? colors.onPrimary
                    : colors.primary,
                size: 21,
              ),
            ),

            const SizedBox(width: 14),

            // Flexible prevents long activity text from overflowing.
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      decoration: activity.completed
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    activity.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            Text(
              activity.time,
              style: TextStyle(
                fontSize: 11,
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}