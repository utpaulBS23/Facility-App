part of '../view/profit_report_page.dart';

class _IncentiveRateTable extends StatelessWidget {
  const _IncentiveRateTable({required this.rows});

  final List<IncentiveRateRowEntity> rows;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                context.locale.achievementRate,
                style: context.textStyle.bodySmall.copyWith(
                  color: color.text.secondary,
                ),
              ),
            ),
            Text(
              context.locale.incentive,
              style: context.textStyle.bodySmall.copyWith(
                color: color.text.secondary,
              ),
            ),
          ],
        ),
        Gap(spacing.s8),
        Divider(color: color.borderSubtle, height: 1),
        for (final row in rows) ...[
          Padding(
            padding: EdgeInsets.symmetric(vertical: spacing.s10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    row.rangeLabel,
                    style: context.textStyle.bodyMedium,
                  ),
                ),
                Expanded(
                  child: Text(
                    row.valueText,
                    textAlign: TextAlign.end,
                    style: context.textStyle.bodyMedium.copyWith(
                      color: switch (row.style) {
                        IncentiveRateRowStyle.positive => color.success,
                        IncentiveRateRowStyle.muted => color.text.muted,
                        IncentiveRateRowStyle.note => color.primary,
                      },
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (row != rows.last) Divider(color: color.borderSubtle, height: 1),
        ],
      ],
    );
  }
}
