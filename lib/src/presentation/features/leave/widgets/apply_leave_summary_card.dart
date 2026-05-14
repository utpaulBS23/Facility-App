part of '../view/apply_leave_page.dart';

class _LeaveSummaryCard extends StatelessWidget {
  const _LeaveSummaryCard();

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
          Expanded(
            child: _StatTile(
              value: '12',
              label: context.locale.leaveBalance,
              valueColor: context.color.success,
              backgroundColor: context.color.successAlt,
            ),
          ),
          Gap(spacing.s6),
          Expanded(
            child: _StatTile(
              value: '2',
              label: context.locale.pending,
              valueColor: context.color.warning,
              backgroundColor: context.color.warningAlt,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.value,
    required this.label,
    required this.valueColor,
    required this.backgroundColor,
  });

  final String value;
  final String label;
  final Color valueColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Container(
      padding: EdgeInsets.all(spacing.s12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r10),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: context.textStyle.titleMedium.copyWith(color: valueColor),
          ),
          Gap(spacing.s4),
          Text(
            label,
            style: context.textStyle.bodySmall.copyWith(
              color: context.color.text.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
