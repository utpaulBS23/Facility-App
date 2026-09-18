import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/report/convenience_benefit_entity.dart';
import '../../../../domain/entities/report/incentive_breakdown_row_entity.dart';
import '../../../../domain/entities/report/incentive_rate_row_entity.dart';
import '../../../../domain/entities/report/incentive_tier_entity.dart';
import '../../../../domain/entities/report/profit_report_entity.dart';
import '../../../../domain/entities/report/profit_report_period.dart';
import '../../../../domain/entities/report/profit_summary_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/number_formatter.dart';
import '../../../core/widgets/category_filter_chips.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../riverpod/profit_report_mock_data.dart';
import '../riverpod/profit_report_period_provider.dart';

part '../widgets/convenience_benefits_card.dart';
part '../widgets/incentive_calculation_card.dart';
part '../widgets/incentive_rate_card.dart';
part '../widgets/profit_report_collapsible_card.dart';
part '../widgets/profit_report_content.dart';
part '../widgets/profit_summary_card.dart';

class ProfitReportPage extends ConsumerWidget {
  const ProfitReportPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.dimensions.spacing;
    final selectedPeriod = ref.watch(profitReportPeriodSelectionProvider);

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(title: context.locale.profitReport),
      body: Padding(
        padding: EdgeInsets.all(spacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: CategoryFilterChips<ProfitReportPeriod>(
                categories: ProfitReportPeriod.values,
                selectedCategory: selectedPeriod,
                onSelected: (period) => ref
                    .read(profitReportPeriodSelectionProvider.notifier)
                    .select(period),
                labelBuilder: (context, period) => switch (period) {
                  ProfitReportPeriod.monthly => context.locale.monthly,
                  ProfitReportPeriod.quarterly => context.locale.quarterly,
                  ProfitReportPeriod.annual => context.locale.annual,
                },
              ),
            ),
            Gap(spacing.s16),
            Expanded(
              child: switch (selectedPeriod) {
                ProfitReportPeriod.monthly => _ProfitReportContent(
                  data: monthlyProfitReportMockData,
                ),
                ProfitReportPeriod.quarterly => _ProfitReportContent(
                  data: quarterlyProfitReportMockData,
                ),
                ProfitReportPeriod.annual => _ProfitReportContent(
                  data: annualProfitReportMockData,
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}
