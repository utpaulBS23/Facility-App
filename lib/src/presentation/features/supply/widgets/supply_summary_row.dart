part of '../view/supply_requests_page.dart';

class _SupplySummaryRow extends StatelessWidget {
  const _SupplySummaryRow({
    required this.summary,
  });

  final SupplyRequestSummaryEntity summary;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Container(
      padding: EdgeInsets.all(spacing.s8),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        border: Border.all(color: context.color.borderSubtle),
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
      ),
      child: Row(
        children: [
          _SummaryTile(
            countText: summary.pending != null ? NumberFormatter.format(summary.pending) : context.locale.notAvailable,
            label: context.locale.pending,
            background: context.color.warningAlt,
            textColor: context.color.warning,
          ),
          Gap(spacing.s6),
          _SummaryTile(
            countText: summary.approved != null ? NumberFormatter.format(summary.approved) : context.locale.notAvailable,
            label: context.locale.approved,
            background: context.color.successAlt,
            textColor: context.color.success,
          ),
          Gap(spacing.s6),
          _SummaryTile(
            countText: summary.rejected != null ? NumberFormatter.format(summary.rejected) : context.locale.notAvailable,
            label: context.locale.rejected,
            background: context.color.errorAlt,
            textColor: context.color.error,
          ),
          Gap(spacing.s6),
          _SummaryTile(
            countText: summary.completed != null ? NumberFormatter.format(summary.completed) : context.locale.notAvailable,
            label: context.locale.completed,
            background: context.color.scaffoldBackground,
            textColor: context.color.text.primary,
          ),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.countText,
    required this.label,
    required this.background,
    required this.textColor,
  });

  final String countText;
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
              countText,
              style: context.textStyle.titleMedium.copyWith(color: textColor),
              textAlign: TextAlign.center,
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
