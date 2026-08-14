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
        color: color.warning.withValues(alpha: 0.05),
        border: Border.all(color: color.warning),
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: color.warning,
            size: spacing.s20,
          ),
          Gap(spacing.s10),
          Expanded(
            child: Text(
              context.locale.updateStockInstructions,
              style: context.textStyle.bodyMedium.copyWith(
                color: color.text.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
