part of '../view/stock_page.dart';

class _StockItemCard extends StatelessWidget {
  const _StockItemCard({
    required this.item,
    required this.onTap,
  });

  final MockStockItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(radius.r12),
      child: Container(
        padding: EdgeInsets.all(spacing.s16),
        decoration: BoxDecoration(
          color: color.onPrimary,
          border: Border.all(color: color.borderSubtle),
          borderRadius: BorderRadius.circular(radius.r12),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(spacing.s10),
              decoration: BoxDecoration(
                color: color.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(radius.r12),
              ),
              child: Icon(
                item.icon,
                color: color.primary,
                size: 20,
              ),
            ),
            Gap(spacing.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: context.textStyle.bodyLarge.copyWith(
                      color: color.text.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gap(spacing.s4),
                  Row(
                    children: [
                      Text(
                        '${item.quantity}',
                        style: context.textStyle.bodyMedium.copyWith(
                          color: color.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        ' ${item.unit} • ',
                        style: context.textStyle.bodySmall.copyWith(
                          color: color.text.secondary,
                        ),
                      ),
                      StatusDotTag(
                        dotColor: item.statusColor(color),
                        label: item.statusLabel,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: color.text.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
