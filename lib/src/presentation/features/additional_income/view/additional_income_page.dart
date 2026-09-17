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
import '../widgets/shimmer/shimmer_box.dart';

part '../widgets/income_body.dart';
part '../widgets/income_list_card.dart';
part '../widgets/income_list_section.dart';
part '../widgets/income_stats_row.dart';
part '../widgets/shimmer/income_list_shimmer.dart';
part '../widgets/shimmer/income_stats_row_shimmer.dart';

class AdditionalIncomePage extends ConsumerStatefulWidget {
  const AdditionalIncomePage({super.key});

  @override
  ConsumerState<AdditionalIncomePage> createState() =>
      _AdditionalIncomePageState();
}

class _AdditionalIncomePageState extends ConsumerState<AdditionalIncomePage> {
  int? _facilityId;
  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _selectDefaultFacility());
  }

  void _onMonthSelected(DateTime date) {
    setState(() => _month = DateTime(date.year, date.month));
  }

  void _selectDefaultFacility() {
    final facilities = ref.read(userSessionProvider)?.accessibleFacilities;
    if (facilities == null || facilities.isEmpty || !mounted) return;
    final primary = facilities.cast<AccessibleFacilityEntity?>().firstWhere(
      (f) => f?.isPrimary ?? false,
      orElse: () => null,
    );
    final selected = (primary ?? facilities.first).id;
    setState(() => _facilityId = selected);
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
      ),
    );
    if (result == null || result.facilityId == _facilityId) return;
    setState(() => _facilityId = result.facilityId);
    _fetch();
  }

  void _fetch() {
    ref.read(additionalIncomeListProvider.notifier).fetch(facilityId: _facilityId);
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
    final facilities =
        ref.watch(userSessionProvider)?.accessibleFacilities ??
        const <AccessibleFacilityEntity>[];
    final listAsync = ref
        .watch(additionalIncomeListProvider)
        .whenData((result) => _filterByMonth(result));

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
          Gap(context.dimensions.spacing.s8),
        ],
      ),
      body: _AdditionalIncomeBody(
        listAsync: listAsync,
        onRetry: _fetch,
      ),
      floatingActionButton: PermissionGate(
        permissions: const [UserPermission.additionalIncomeCreate],
        child: FloatingActionButton(
          onPressed: _onAddIncome,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
          ),
          backgroundColor: context.color.primary,
          child: Icon(Icons.add, size: context.dimensions.spacing.s30),
        ),
      ),
    );
  }
}
