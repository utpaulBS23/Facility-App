part of '../view/update_stock_page.dart';

class _InstructionAlertBanner extends StatelessWidget {
  const _InstructionAlertBanner();

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    return Container(
      padding: EdgeInsets.all(spacing.s12),
      decoration: BoxDecoration(
        color: color.primary.withValues(alpha: 0.05),
        border: Border.all(color: color.primary.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: color.primary,
            size: spacing.s20,
          ),
          Gap(spacing.s8),
          Expanded(
            child: Text(
              context.locale.updateStockInstructions,
              style: context.textStyle.bodySmall.copyWith(
                color: color.text.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
