import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/stock/facility_stock_balance_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/status_pill.dart';

class FacilityBalanceCard extends StatelessWidget {
  const FacilityBalanceCard({super.key, required this.item});

  final FacilityStockBalanceEntity item;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    final formattedQty = item.currentQty % 1 == 0
        ? item.currentQty.toInt().toString()
        : item.currentQty.toString();

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        border: Border.all(color: color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(spacing.s10),
            decoration: BoxDecoration(
              color: color.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(radius.r12),
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              color: color.primary,
              size: spacing.s20,
            ),
          ),
          Gap(spacing.s12),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.itemName,
                        style: context.textStyle.bodyLarge.copyWith(
                          color: color.text.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gap(spacing.s2),
                      Text(
                        '$formattedQty ${item.unit}',
                        style: context.textStyle.bodyMedium.copyWith(
                          color: color.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (item.thresholdQty != null) ...[
                        Gap(spacing.s2),
                        Text(
                          '${context.locale.threshold}: ${item.thresholdQty!.toInt()} ${item.unit}',
                          style: context.textStyle.bodySmall.copyWith(
                            color: color.text.secondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Gap(spacing.s12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _StockStatusPill(status: item.status),
                    if (item.lastCountedAt != null) ...[
                      Gap(spacing.s4),
                      Text(
                        DateFormatter.shortDate(
                          DateTime.parse(item.lastCountedAt!).toLocal(),
                        ),
                        style: context.textStyle.bodySmall.copyWith(
                          color: color.text.secondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StockStatusPill extends StatelessWidget {
  const _StockStatusPill({required this.status});

  final FacilityStockStatus status;

  @override
  Widget build(BuildContext context) {
    final color = context.color;

    return switch (status) {
      FacilityStockStatus.ok => StatusPill(
          label: context.locale.healthy,
          background: color.successAlt,
          foreground: color.success,
        ),
      FacilityStockStatus.low => StatusPill(
          label: context.locale.lowStock,
          background: color.warningAlt,
          foreground: color.warning,
        ),
      FacilityStockStatus.out => StatusPill(
          label: context.locale.outOfStock,
          background: color.errorAlt,
          foreground: color.error,
        ),
      _ => const SizedBox.shrink(),
    };
  }
}
