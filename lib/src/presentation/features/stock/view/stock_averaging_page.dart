import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain/entities/stock/stock_averaging_overview_entity.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/stock_averaging_provider.dart';
import '../widgets/facility_averaging_list_card.dart';
import '../widgets/monthly_demand_card.dart';
import '../widgets/stock_averaging_shimmer.dart';

class StockAveragingPage extends ConsumerWidget {
  const StockAveragingPage({super.key});

  Scaffold _scaffold(BuildContext context, {required Widget body}) {
    final color = context.color;

    return Scaffold(
      backgroundColor: color.scaffoldBackground,
      appBar: AppBar(
        leading: AppBackButton(onTap: () => context.goNamed(Routes.shift)),
        leadingWidth: AppBackButton.width,
        title: const Headline2xlTinyText('Stock Averaging'),
        centerTitle: true,
        backgroundColor: color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: body,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final averagingAsync = ref.watch(stockAveragingOverviewProvider());

    return _scaffold(
      context,
      body: averagingAsync.when(
        loading: () => const StockAveragingShimmer(),
        error: (err, _) => AppErrorWidget(
          message: err.toString(),
          onRetry: () => ref.invalidate(stockAveragingOverviewProvider()),
        ),
        data: (overview) => _StockAveragingBody(overview: overview),
      ),
    );
  }
}

class _StockAveragingBody extends StatelessWidget {
  const _StockAveragingBody({required this.overview});

  final StockAveragingOverviewEntity overview;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final facilities = overview.facilities;

    return SingleChildScrollView(
      padding: EdgeInsets.all(spacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MonthlyDemandCard(items: overview.monthlyDemand),
          if (overview.monthlyDemand.isNotEmpty) Gap(spacing.s16),
          if (facilities.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(spacing.s24),
                child: Text(
                  'No facilities found.',
                  style: context.textStyle.bodyMedium.copyWith(
                    color: color.text.secondary,
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: facilities.length,
              separatorBuilder: (context, index) => Gap(spacing.s12),
              itemBuilder: (context, index) {
                final facility = facilities[index];
                return FacilityAveragingListCard(
                  facility: facility,
                  onTap: () {
                    context.pushNamed(
                      Routes.stockAveragingDetails,
                      extra: facility.facilityId,
                    );
                  },
                );
              },
            ),
          Gap(spacing.s24),
        ],
      ),
    );
  }
}
