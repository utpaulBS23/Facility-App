import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/additional_income/additional_income_entity.dart';
import '../../../../domain/entities/common/paginated_list_entity.dart';
import '../../../../domain/entities/login_entity.dart';
import '../../../../domain/entities/master_data_entity.dart';
import '../../../../domain/entities/product_sale_entry/product_sale_entry_entity.dart';
import '../../../core/application_state/session_provider/session_provider.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/number_formatter.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../../../core/widgets/facility_filter_button.dart';
import '../../../core/widgets/facility_picker_sheet.dart';
import '../../../core/widgets/month_filter_button.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/additional_income_list_provider.dart';
import '../riverpod/product_sale_entry_list_provider.dart';
import '../riverpod/submit_income_provider/income_type_options_provider.dart';
import '../widgets/shimmer/shimmer_box.dart';

part '../widgets/income_body.dart';
part '../widgets/income_list_card.dart';
part '../widgets/income_list_section.dart';
part '../widgets/income_list_tab_switch.dart';
part '../widgets/income_stats_row.dart';
part '../widgets/product_sale_entry_body.dart';
part '../widgets/product_sale_entry_list_card.dart';
part '../widgets/product_sale_entry_list_section.dart';
part '../widgets/product_sale_entry_stats_row.dart';
part '../widgets/summary_tile.dart';
part '../widgets/shimmer/income_list_shimmer.dart';
part '../widgets/shimmer/income_stats_row_shimmer.dart';

class AdditionalIncomePage extends ConsumerStatefulWidget {
  const AdditionalIncomePage({super.key});

  @override
  ConsumerState<AdditionalIncomePage> createState() =>
      _AdditionalIncomePageState();
}

class _AdditionalIncomePageState extends ConsumerState<AdditionalIncomePage> {
  IncomeListTab _tab = IncomeListTab.rentAndOthers;
  int? _facilityId;
  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);

  String get _monthParam =>
      '${_month.year}-${_month.month.toString().padLeft(2, '0')}';

  void _onTabChanged(IncomeListTab tab) {
    setState(() => _tab = tab);
    _fetch();
  }

  void _onMonthSelected(DateTime date) {
    setState(() => _month = DateTime(date.year, date.month));
    _fetch();
  }

  Future<void> _onPickFacility(List<AccessibleFacilityEntity> facilities) async {
    final result = await showModalBottomSheet<({int? facilityId})>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FacilityPickerSheet(
        facilities: facilities,
        selectedFacilityId: _facilityId,
        includeAllOption: true,
      ),
    );
    if (result == null || result.facilityId == _facilityId) return;
    setState(() => _facilityId = result.facilityId);
    _fetch();
  }

  void _fetch() {
    switch (_tab) {
      case IncomeListTab.rentAndOthers:
        ref
            .read(additionalIncomeListProvider.notifier)
            .fetch(facilityId: _facilityId);
      case IncomeListTab.monthlyProductRevenue:
        ref
            .read(productSaleEntryListProvider.notifier)
            .fetch(facilityId: _facilityId, month: _monthParam);
    }
  }

  void _onAddIncome() => context.pushNamed(Routes.addAdditionalIncome);

  // WHY client-side: the additional-incomes endpoint has no month query
  // param (only facility_id/page/per_page), so month narrows whatever page
  // is already loaded — same caveat as the toilet-location search filter.
  AdditionalIncomeListResultEntity _filterByMonth(
    AdditionalIncomeListResultEntity result,
  ) {
    final items = result.list.items
        .where(
          (income) =>
              income.createdAt.year == _month.year &&
              income.createdAt.month == _month.month,
        )
        .toList();
    return AdditionalIncomeListResultEntity(
      list: PaginatedListEntity(
        items: items,
        currentPage: result.list.currentPage,
        pageSize: result.list.pageSize,
        totalRecords: result.list.totalRecords,
        hasMore: result.list.hasMore,
      ),
      summary: result.summary,
    );
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final facilities =
        ref.watch(userSessionProvider)?.accessibleFacilities ??
        const <AccessibleFacilityEntity>[];
    final incomeListAsync = ref
        .watch(additionalIncomeListProvider)
        .whenData((result) => _filterByMonth(result));
    final productSaleListAsync = ref.watch(productSaleEntryListProvider);
    final isProductTab = _tab == IncomeListTab.monthlyProductRevenue;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(
        title: context.locale.extraCollection,
        actions: [
          MonthFilterButton(
            month: _month,
            lastDate: DateTime.now(),
            onSelected: _onMonthSelected,
          ),
          if (facilities.length > 1)
            FacilityFilterButton(
              hasSelection: _facilityId != null,
              onTap: () => _onPickFacility(facilities),
            ),
          Gap(spacing.s8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(spacing.s16, spacing.s16, spacing.s16, 0),
            child: _IncomeListTabSwitch(
              selectedTab: _tab,
              onTabChanged: _onTabChanged,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(spacing.s16, spacing.s4, spacing.s16, spacing.s4),
            child: isProductTab
                ? switch (productSaleListAsync) {
                    AsyncData(:final value) =>
                      _ProductSaleStatsRow(summary: value.summary),
                    AsyncError() => const SizedBox.shrink(),
                    _ => const _IncomeStatsRowShimmer(),
                  }
                : switch (incomeListAsync) {
                    AsyncData(:final value) =>
                      _IncomeStatsRow(summary: value.summary),
                    AsyncError() => const SizedBox.shrink(),
                    _ => const _IncomeStatsRowShimmer(),
                  },
          ),
          Expanded(
            child: isProductTab
                ? _ProductSaleEntryBody(
                    listAsync: productSaleListAsync,
                    onRetry: _fetch,
                  )
                : _AdditionalIncomeBody(
                    listAsync: incomeListAsync,
                    onRetry: _fetch,
                  ),
          ),
        ],
      ),
      floatingActionButton: PermissionGate(
        permissions: [
          isProductTab
              ? UserPermission.productSaleEntryCreate
              : UserPermission.additionalIncomeCreate,
        ],
        child: FloatingActionButton(
          onPressed: _onAddIncome,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
          ),
          backgroundColor: context.color.primary,
          child: Icon(Icons.add, size: spacing.s30),
        ),
      ),
    );
  }
}
