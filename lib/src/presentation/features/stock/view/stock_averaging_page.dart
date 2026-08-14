import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/facility_entity.dart';
import '../../../../domain/entities/stock/facility_stock_target_entity.dart';
import '../../../../domain/entities/stock/top_demand_item_entity.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/text/typography.dart';
import '../../roster/riverpod/facility_list_provider.dart';
import '../riverpod/stock_averaging_provider.dart';

part '../widgets/facility_averaging_list_card.dart';
part '../widgets/facility_dropdown_card.dart';
part '../widgets/monthly_demand_card.dart';

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

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final facilitiesAsync = ref.watch(facilityListProvider);
    final facilities = facilitiesAsync.valueOrNull ?? const [];

    _selectedFacilityId ??= facilities.firstOrNull?.id;

    final averagingAsync = ref.watch(
      stockAveragingProvider(facilityId: _selectedFacilityId),
    );

    final selectedFacilityName = facilities
            .where((f) => f.id == _selectedFacilityId)
            .firstOrNull
            ?.name ??
        '';

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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            averagingAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (err, stack) => const SizedBox.shrink(),
              data: (page) => _MonthlyDemandCard(items: page.topDemandItems),
            ),
            Gap(spacing.s16),
            if (facilities.isNotEmpty) ...[
              _FacilityDropdownCard(
                facilityName: selectedFacilityName.isEmpty
                    ? context.locale.selectFacility
                    : selectedFacilityName,
                onTap: () => _showFacilitySelector(context, facilities),
              ),
              Gap(spacing.s16),
            ],
            averagingAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => AppErrorWidget(
                message: err.toString(),
                onRetry: () => ref.invalidate(
                  stockAveragingProvider(facilityId: _selectedFacilityId),
                ),
              ),
              data: (page) {
                final items = page.items;

                if (items.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(spacing.s24),
                      child: Text(
                        'No stock targets found.',
                        style: context.textStyle.bodyMedium.copyWith(
                          color: color.text.secondary,
                        ),
                      ),
                    ),
                  );
                }

                return ListView.separated(
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
