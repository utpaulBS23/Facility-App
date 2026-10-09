import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import 'dashboard_tone.dart';

/// Progress bar with a label, a value on the right and an optional footer.
class DashboardMeter extends StatelessWidget {
  const DashboardMeter({
    super.key,
    required this.label,
    required this.valueText,
    required this.percent,
    this.tone = DashboardTone.brand,
    this.footLeft,
    this.footRight,
  });

  final String label;
  final String valueText;

  /// 0 to 100; values outside are clamped.
  final num percent;
  final DashboardTone tone;
  final String? footLeft;
  final String? footRight;

  /// Green from 75, orange from 50, red below: the rule every target meter
  /// on the dashboard uses.
  static DashboardTone toneForPercent(num percent) => percent >= 75
      ? DashboardTone.green
      : percent >= 50
      ? DashboardTone.orange
      : DashboardTone.red;

  @override
  Widget build(BuildContext context) {
    final c = context.color;
    final spacing = context.dimensions.spacing;
    final footLeft = this.footLeft ?? '';
    final footRight = this.footRight ?? '';
    final factor = percent.clamp(0, 100) / 100;
    final small = context.textStyle.bodySmall.copyWith(color: c.text.secondary);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text(label, style: small)),
            SizedBox(width: spacing.s8),
            Text(
              valueText,
              style: small.copyWith(
                color: c.text.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        SizedBox(height: spacing.s8),
        Semantics(
          label: label,
          value: valueText,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Container(
              height: 8,
              color: c.subtle,
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: factor.toDouble(),
                child: Container(
                  decoration: BoxDecoration(
                    color: tone.accent(context),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (footLeft.isNotEmpty || footRight.isNotEmpty) ...[
          SizedBox(height: spacing.s6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: Text(footLeft, style: small)),
              SizedBox(width: spacing.s8),
              Flexible(
                child: Text(footRight, style: small, textAlign: TextAlign.end),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
