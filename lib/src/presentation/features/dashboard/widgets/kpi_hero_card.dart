import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

/// Brand-coloured headline number with a change pill ("up 6% vs last month").
class KpiHeroCard extends StatelessWidget {
  const KpiHeroCard({
    super.key,
    required this.label,
    required this.value,
    required this.deltaText,
    required this.deltaPositive,
    this.footnote,
  });

  final String label;
  final String value;

  /// Already formatted, e.g. "▲ 6% vs last month".
  final String deltaText;
  final bool deltaPositive;
  final String? footnote;

  @override
  Widget build(BuildContext context) {
    final c = context.color;
    final spacing = context.dimensions.spacing;
    final footnote = this.footnote;
    final deltaColor = Color.lerp(
      deltaPositive ? c.success : c.error,
      Colors.black,
      0.45,
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: spacing.s16,
        vertical: spacing.s16 + 2,
      ),
      decoration: BoxDecoration(
        color: c.primary,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.textStyle.labelMedium12.copyWith(
              color: c.onPrimary.withValues(alpha: 0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: spacing.s6),
          Text(
            value,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              height: 1.1,
              color: c.onPrimary,
            ),
          ),
          SizedBox(height: spacing.s8),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.s10,
                  vertical: spacing.s4,
                ),
                decoration: BoxDecoration(
                  color: c.onPrimary,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  deltaText,
                  style: context.textStyle.labelMedium12.copyWith(
                    color: deltaColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (footnote != null) ...[
                SizedBox(width: spacing.s8),
                Flexible(
                  child: Text(
                    footnote,
                    style: context.textStyle.bodySmall.copyWith(
                      color: c.onPrimary.withValues(alpha: 0.9),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
