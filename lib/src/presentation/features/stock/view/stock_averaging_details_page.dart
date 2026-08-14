import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/text/typography.dart';
import '../models/stock_averaging_details_models.dart';

part '../widgets/average_demand_list_card.dart';
part '../widgets/facility_metadata_card.dart';
part '../widgets/monthly_total_summary_card.dart';

class StockAveragingDetailsPage extends StatelessWidget {
  const StockAveragingDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;

    return Scaffold(
      backgroundColor: color.scaffoldBackground,
      appBar: AppBar(
        leading: const AppBackButton(),
        leadingWidth: AppBackButton.width,
        title: const Headline2xlTinyText('Request details'),
        centerTitle: true,
        backgroundColor: color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _FacilityMetadataCard(),
            Gap(spacing.s16),
            const _AverageDemandListCard(items: mockAverageDemandItems),
            Gap(spacing.s16),
            const _MonthlyTotalSummaryCard(items: mockTotalSummaryItems),
            Gap(spacing.s24),
          ],
        ),
      ),
    );
  }
}
