import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/stock/facility_stock_averaging_overview_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/date_formatter.dart';

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

    final isSetUp = facility.isSetUp;
    final supervisor = facility.supervisorName.isNotEmpty
        ? facility.supervisorName
        : context.locale.notAvailable;

    final lastCounted = facility.lastStockCountAt != null
        ? DateFormatter.shortDate(
            DateTime.parse(facility.lastStockCountAt!).toLocal(),
          )
        : context.locale.notAvailable;

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
                Row(
                  children: [
                    Icon(
                      Icons.person_outline_rounded,
                      size: 14,
                      color: color.text.secondary,
                    ),
                    Gap(spacing.s4),
                    Expanded(
                      child: Text(
                        supervisor,
                        style: textStyle.bodySmall.copyWith(
                          color: color.text.secondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Gap(spacing.s6),
                Row(
                  children: [
                    Text(
                      'Last Count: $lastCounted  •  ',
                      style: textStyle.bodySmall.copyWith(
                        color: color.text.secondary,
                        fontSize: 11,
                      ),
                    ),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isSetUp ? color.success : color.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Gap(spacing.s4),
                    Text(
                      isSetUp ? 'Set up' : 'Not set up',
                      style: textStyle.bodySmall.copyWith(
                        color: isSetUp ? color.success : color.error,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
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
