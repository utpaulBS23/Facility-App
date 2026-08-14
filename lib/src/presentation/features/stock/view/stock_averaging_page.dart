import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/facility_entity.dart';
import '../../../../domain/entities/stock/facility_stock_target_entity.dart';
import '../../../../domain/entities/stock/stock_averaging_page_entity.dart';
import '../../../../domain/entities/stock/top_demand_item_entity.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/text/typography.dart';
import '../../roster/riverpod/facility_list_provider.dart';
import '../../supply/widgets/shimmer/shimmer_box.dart';
import '../riverpod/stock_averaging_provider.dart';

part '../widgets/facility_averaging_list_card.dart';
part '../widgets/facility_dropdown_card.dart';
part '../widgets/monthly_demand_card.dart';
part '../widgets/stock_averaging_shimmer.dart';

class StockAveragingPage extends ConsumerStatefulWidget {
  const StockAveragingPage({super.key});

  @override
  ConsumerState<StockAveragingPage> createState() => _StockAveragingPageState();
}

class _StockAveragingPageState extends ConsumerState<StockAveragingPage> {
  int? _selectedFacilityId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(facilityListProvider.notifier).fetch());
  }

  void _showFacilitySelector(BuildContext context, List<FacilityEntity> facilities) {
    showModalBottomSheet<void>(
      context: context,
      builder: (bottomSheetContext) {
        final color = context.color;
        final spacing = context.dimensions.spacing;

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(spacing.s16),
                child: Headline2xlTinyText(context.locale.selectFacility),
              ),
              const Divider(height: 1),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: facilities.length,
                  itemBuilder: (context, index) {
                    final facility = facilities[index];
                    final isSelected = facility.id == _selectedFacilityId;

                    return ListTile(
                      title: Text(facility.name),
                      trailing: isSelected
                          ? Icon(Icons.check_circle_rounded, color: color.primary)
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedFacilityId = facility.id;
                        });
                        Navigator.pop(bottomSheetContext);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Scaffold _scaffold(BuildContext context, {required Widget body}) {
    final color = context.color;

    return Scaffold(
      backgroundColor: color.scaffoldBackground,
      appBar: AppBar(
        leading: AppBackButton(onTap: () => context.goNamed(Routes.shift)),
        leadingWidth: AppBackButton.width,
        title: Headline2xlTinyText(context.locale.stockAveraging),
        centerTitle: true,
        backgroundColor: color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: body,
    );
  }

  @override
  Widget build(BuildContext context) {
    final facilitiesAsync = ref.watch(facilityListProvider);

    // WHY: gate the averaging fetch behind the facility list — otherwise it
    // fires once with facilityId null (before facilities load) and again
    // once _selectedFacilityId resolves, showing the loading shimmer twice.
    return facilitiesAsync.when(
      loading: () => _scaffold(context, body: const _StockAveragingShimmer()),
      error: (err, _) => _scaffold(
        context,
        body: AppErrorWidget(
          message: err.toString(),
          onRetry: () => ref.invalidate(facilityListProvider),
        ),
      ),
      data: (facilities) {
        _selectedFacilityId ??= facilities.firstOrNull?.id;

        final averagingAsync = ref.watch(
          stockAveragingProvider(facilityId: _selectedFacilityId),
        );

        return _scaffold(
          context,
          body: averagingAsync.when(
            loading: () => const _StockAveragingShimmer(),
            error: (err, _) => AppErrorWidget(
              message: err.toString(),
              onRetry: () => ref.invalidate(
                stockAveragingProvider(facilityId: _selectedFacilityId),
              ),
            ),
            data: (page) => _StockAveragingBody(page: page),
          ),
        );
      },
    );
  }
}

class _StockAveragingBody extends StatelessWidget {
  const _StockAveragingBody({required this.page});

  final StockAveragingPageEntity page;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final items = page.items;

    return SingleChildScrollView(
      padding: EdgeInsets.all(spacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _MonthlyDemandCard(items: page.topDemandItems),
          if (page.topDemandItems.isNotEmpty) Gap(spacing.s16),
          if (items.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(spacing.s24),
                child: Text(
                  'No stock targets found.',
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
              itemCount: items.length,
              separatorBuilder: (context, index) => Gap(spacing.s12),
              itemBuilder: (context, index) {
                return _FacilityAveragingListCard(
                  item: items[index],
                  onTap: () {
                    context.pushNamed(
                      Routes.stockAveragingDetails,
                      extra: items[index].facilityId,
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
