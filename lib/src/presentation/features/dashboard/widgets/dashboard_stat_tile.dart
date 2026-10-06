import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import 'dashboard_tone.dart';

/// A coloured number tile: value, label and an optional hint line.
class DashboardStatTile extends StatelessWidget {
  const DashboardStatTile({
    super.key,
    required this.value,
    required this.label,
    this.tone = DashboardTone.neutral,
    this.hint,
    this.compact = false,
    this.onTap,
  });

  final String value;
  final String label;
  final DashboardTone tone;
  final String? hint;

  /// Smaller padding and number, for rows of three or more.
  final bool compact;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = BorderRadius.circular(context.dimensions.radius.r12);
    final fg = tone.foreground(context);
    final hint = this.hint;

    return Material(
      color: tone.background(context),
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 44),
          padding: compact
              ? EdgeInsets.symmetric(
                  horizontal: spacing.s12,
                  vertical: spacing.s10,
                )
              : EdgeInsets.all(spacing.s14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: compact ? 18 : 24,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                  color: fg,
                ),
              ),
              SizedBox(height: spacing.s2),
              Text(
                label,
                style: context.textStyle.labelMedium12.copyWith(
                  color: fg,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (hint != null && hint.isNotEmpty)
                Text(
                  hint,
                  style: context.textStyle.labelSmall.copyWith(
                    color: fg.withValues(alpha: 0.85),
                    letterSpacing: 0,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
