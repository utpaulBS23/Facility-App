part of '../view/supply_requests_page.dart';

class _SupplySummaryRow extends StatelessWidget {
  const _SupplySummaryRow({
    required this.pendingCount,
    required this.inDeliveryCount,
    required this.deliveredCount,
    required this.rejectedCount,
  });

  final int pendingCount;
  final int inDeliveryCount;
  final int deliveredCount;
  final int rejectedCount;

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
            count: pendingCount,
            label: context.locale.pending,
            background: context.color.warningAlt,
            textColor: context.color.warning,
          ),
          Gap(spacing.s6),
          _SummaryTile(
            count: inDeliveryCount,
            label: context.locale.inDelivery,
            background: context.color.successAlt,
            textColor: context.color.success,
          ),
          Gap(spacing.s6),
          _SummaryTile(
            count: rejectedCount,
            label: context.locale.rejected,
            background: context.color.errorAlt,
            textColor: context.color.error,
          ),
          Gap(spacing.s6),
          _SummaryTile(
            count: deliveredCount,
            label: context.locale.delivered,
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
    required this.count,
    required this.label,
    required this.background,
    required this.textColor,
  });

  final int count;
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
              count.toString(),
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
