import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Small rounded label used to mark state on a card.
///
/// WHY shared: slot status, "slot full" and any future card marker must stay
/// visually identical — one widget owns the pill's metrics so callers only
/// choose the colours and the copy.
class StatusPill extends StatelessWidget {
  /// Creates a [StatusPill].
  const StatusPill({
    super.key,
    required this.label,
    required this.background,
    required this.foreground,
    this.icon,
  });

  final String label;
  final Color background;
  final Color foreground;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final dimensions = context.dimensions;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dimensions.spacing.s8,
        vertical: dimensions.spacing.s2,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(dimensions.radius.r6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: dimensions.spacing.s12, color: foreground),
            SizedBox(width: dimensions.spacing.s4),
          ],
          Text(
            label,
            style: context.textStyle.bodySmall.copyWith(color: foreground),
          ),
        ],
      ),
    );
  }
}
