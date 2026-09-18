import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../domain/entities/stock/facility_stock_averaging_overview_entity.dart';
import '../../../core/theme/theme.dart';

class FacilityAveragingListCard extends StatelessWidget {
  const FacilityAveragingListCard({
    super.key,
    required this.facility,
    required this.onTap,
  });

  final FacilityStockAveragingOverviewEntity facility;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;

    final totalDemand = facility.monthlyTotalDemandQty % 1 == 0
        ? facility.monthlyTotalDemandQty.toInt().toString()
        : facility.monthlyTotalDemandQty.toString();

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        border: Border.all(color: color.borderSubtle),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(spacing.s10),
            decoration: BoxDecoration(
              color: color.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(
                context.dimensions.radius.r10,
              ),
            ),
            child: Icon(
              Icons.location_city_outlined,
              color: color.primary,
              size: 22,
            ),
          ),
          Gap(spacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  facility.facilityName,
                  style: textStyle.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color.text.primary,
                  ),
                ),
                Gap(spacing.s4),
                Text(
                  '${facility.itemCount} items  •  $totalDemand monthly demand',
                  style: textStyle.bodySmall.copyWith(
                    color: color.text.secondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onTap,
            icon: Icon(
              Icons.edit_outlined,
              color: color.text.secondary,
              size: 20,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
