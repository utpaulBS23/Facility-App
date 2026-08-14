import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/status_dot_tag.dart';
import '../../../core/widgets/text/typography.dart';
import '../models/stock_averaging_models.dart';

part '../widgets/facility_averaging_list_card.dart';
part '../widgets/facility_dropdown_card.dart';
part '../widgets/monthly_demand_card.dart';
part '../widgets/stock_averaging_summary_row.dart';

class StockAveragingPage extends StatelessWidget {
  const StockAveragingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;

    return Scaffold(
      backgroundColor: color.scaffoldBackground,
      appBar: AppBar(
        leading: const AppBackButton(),
        leadingWidth: AppBackButton.width,
        title: const Headline2xlTinyText('Stock averaging'),
        centerTitle: true,
        backgroundColor: color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _StockAveragingSummaryRow(),
            Gap(spacing.s16),
            const _MonthlyDemandCard(stats: mockMonthlyDemandStats),
            Gap(spacing.s16),
            _FacilityDropdownCard(
              onTap: () {
                // Facility selector bottom sheet
              },
            ),
            Gap(spacing.s16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: mockFacilityAveragingItems.length,
              separatorBuilder: (_, _) => Gap(spacing.s12),
              itemBuilder: (context, index) {
                return _FacilityAveragingListCard(
                  item: mockFacilityAveragingItems[index],
                  onTap: () {
                    context.pushNamed(Routes.stockAveragingDetails);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
