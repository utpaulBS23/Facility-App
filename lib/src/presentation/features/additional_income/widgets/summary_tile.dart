part of '../view/additional_income_page.dart';

/// Colored tile matching the Supply Requests page's summary row style
/// (`_SummaryTile` in supply_summary_row.dart) — reused here for both the
/// Rent and Others and Monthly Product Revenue summary rows.
class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.valueText,
    required this.label,
    required this.background,
    required this.textColor,
  });

  final String valueText;
  final String label;
  final Color background;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Expanded(
      child: Container(
        padding: EdgeInsets.all(spacing.s10),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(radius.r10),
        ),
        child: Column(
          children: [
            Text(
              valueText,
              style: context.textStyle.titleMedium.copyWith(color: textColor),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            Gap(spacing.s4),
            Text(
              label,
              style: context.textStyle.bodySmall.copyWith(
                color: context.color.text.secondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
