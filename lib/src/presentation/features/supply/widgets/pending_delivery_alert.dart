part of '../view/supply_requests_page.dart';

class PendingDeliveryAlert extends StatelessWidget {
  const PendingDeliveryAlert({
    super.key,
    this.count = 0,
    this.onTap,
  });

  final int count;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(spacing.s12),
        decoration: BoxDecoration(
          color: context.color.successAlt,
          border: Border.all(color: context.color.success),
          borderRadius: BorderRadius.circular(radius.r12),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(spacing.s10),
              decoration: BoxDecoration(
                color: context.color.success,
                borderRadius: BorderRadius.circular(radius.r10),
              ),
              child: Icon(
                Icons.local_shipping_outlined,
                color: context.color.onPrimary,
                size: spacing.s20,
              ),
            ),
            Gap(spacing.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.locale.pendingDeliveries,
                    style: context.textStyle.labelLarge.copyWith(
                      color: context.color.text.primary,
                    ),
                  ),
                  Gap(spacing.s2),
                  Text(
                    context.locale.pendingDeliveryAlertSubtitle(count),
                    style: context.textStyle.bodySmall.copyWith(
                      color: context.color.text.secondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: context.color.text.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
