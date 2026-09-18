import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../domain/entities/stock/facility_stock_target_detail_entity.dart';
import '../../../core/theme/theme.dart';
import 'average_demand_list_card.dart';
import 'facility_metadata_card.dart';
import 'monthly_total_summary_card.dart';

class StockTargetDetailBody extends StatelessWidget {
  const StockTargetDetailBody({
    super.key,
    required this.detail,
    required this.isEditing,
    required this.onQtyChanged,
  });

  final FacilityStockTargetDetailEntity detail;
  final bool isEditing;
  final Function(int stockItemId, double newQty) onQtyChanged;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final updatedByName = detail.targets.isNotEmpty ? detail.targets.first.updatedByName : '';
    final updatedAt = detail.targets.isNotEmpty ? detail.targets.first.updatedAt : '';

    if (isEditing) {
      return SingleChildScrollView(
        padding: EdgeInsets.all(spacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FacilityMetadataCard(
              facilityName: detail.facilityName,
              updatedByName: updatedByName,
              updatedAt: updatedAt,
            ),
            Gap(spacing.s16),
            ItemStepperCardsSection(
              targets: detail.targets,
              onQtyChanged: onQtyChanged,
            ),
            Gap(spacing.s24),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(spacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FacilityMetadataCard(
            facilityName: detail.facilityName,
            updatedByName: updatedByName,
            updatedAt: updatedAt,
          ),
          Gap(spacing.s16),
          MonthlyTotalSummaryCard(
            targets: detail.targets,
            monthlyTotalDemandQty: detail.monthlyTotalDemandQty,
          ),
          Gap(spacing.s24),
        ],
      ),
    );
  }
}
