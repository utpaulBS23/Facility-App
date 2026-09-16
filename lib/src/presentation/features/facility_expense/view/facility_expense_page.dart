import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/facility_expense/facility_expense_entity.dart';
import '../../../../domain/entities/login_entity.dart';
import '../../../core/application_state/session_provider/session_provider.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/number_formatter.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../../../core/widgets/facility_picker_sheet.dart';
import '../../../core/widgets/month_filter_button.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/facility_expenses_list_provider.dart';
import '../widgets/shimmer/shimmer_box.dart';

part '../widgets/expense_body.dart';
part '../widgets/expense_list_card.dart';
part '../widgets/expense_list_section.dart';
part '../widgets/expense_stats_row.dart';
part '../widgets/shimmer/expense_list_shimmer.dart';
part '../widgets/shimmer/expense_stats_row_shimmer.dart';

class FacilityExpensePage extends ConsumerStatefulWidget {
  const FacilityExpensePage({super.key});

  @override
  ConsumerState<FacilityExpensePage> createState() =>
      _FacilityExpensePageState();
}

class _FacilityExpensePageState extends ConsumerState<FacilityExpensePage> {
  int? _facilityId;
  late String _selectedMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    WidgetsBinding.instance.addPostFrameCallback((_) => _selectDefaultFacility());
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
        includeAllOption: true,
      ),
    );
    if (result == null || result.facilityId == _facilityId) return;
    setState(() => _facilityId = result.facilityId);
    _fetch();
  }

  void _onMonthChanged(String month) {
    setState(() => _selectedMonth = month);
    _fetch();
  }

  void _fetch() {
    ref
        .read(facilityExpensesListProvider.notifier)
        .fetch(facilityId: _facilityId, month: _selectedMonth);
  }

  void _onAddExpense() => context.pushNamed(Routes.addFacilityExpense);

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final facilities =
        ref.watch(userSessionProvider)?.accessibleFacilities ??
        const <AccessibleFacilityEntity>[];
    final listAsync = ref.watch(facilityExpensesListProvider);

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(
        title: context.locale.expenseTracking,
        actions: [
          MonthFilterButton(
            selectedMonth: _selectedMonth,
            onChanged: _onMonthChanged,
          ),
          if (facilities.length > 1)
            IconButton(
              onPressed: () => _onPickFacility(facilities),
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.apartment_outlined, size: 18),
                  if (_facilityId != null)
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        width: spacing.s8,
                        height: spacing.s8,
                        decoration: BoxDecoration(
                          color: context.color.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          Gap(spacing.s8),
        ],
      ),
      floatingActionButton: PermissionGate(
        permissions: const [UserPermission.facilityExpenseCreate],
        child: FloatingActionButton(
          onPressed: _onAddExpense,
          backgroundColor: context.color.primary,
          foregroundColor: context.color.onPrimary,
          child: const Icon(Icons.add),
        ),
      ),
      body: _FacilityExpenseBody(listAsync: listAsync, onRetry: _fetch),
    );
  }
}
