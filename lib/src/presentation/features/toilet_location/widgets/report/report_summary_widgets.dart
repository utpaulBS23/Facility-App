import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../dashboard/widgets/dashboard_tone.dart';

/// A centred tile: icon, a big number and a caption, tinted by [tone]. Three
/// of them sit in a row under the filters.
class ReportSummaryTile extends StatelessWidget {
  const ReportSummaryTile({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.tone,
  });

  final IconData icon;
  final String value;
  final String label;
  final DashboardTone tone;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final fg = tone.foreground(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.s8,
        vertical: spacing.s12,
      ),
      decoration: BoxDecoration(
        color: tone.background(context),
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: fg),
          SizedBox(height: spacing.s4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: fg,
              ),
            ),
          ),
          SizedBox(height: spacing.s2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: context.textStyle.labelMedium12.copyWith(color: fg),
          ),
        ],
      ),
    );
  }
}

/// The red bar at the bottom: a round icon, "Profit/Loss" and the amount.
class ReportProfitBanner extends StatelessWidget {
  const ReportProfitBanner({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final c = context.color;
    final spacing = context.dimensions.spacing;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: c.primary,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r16),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.25),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.trending_up_rounded, color: c.onPrimary),
          ),
          SizedBox(width: spacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: context.textStyle.labelMedium12.copyWith(
                    color: c.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: c.onPrimary,
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
