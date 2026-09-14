import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/facility_expense/facility_expense_entity.dart';
import '../../../../domain/entities/login_entity.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../core/application_state/session_provider/session_provider.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/number_formatter.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/facility_expenses_list_provider.dart';
import '../widgets/shimmer/shimmer_box.dart';

part '../widgets/expense_body.dart';
part '../widgets/expense_facility_selector.dart';
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

  @override
  void initState() {
    super.initState();
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
      builder: (_) => _ExpenseFacilityPickerSheet(
        facilities: facilities,
        selectedFacilityId: _facilityId,
      ),
    );
    if (result == null || result.facilityId == _facilityId) return;
    setState(() => _facilityId = result.facilityId);
    _fetch();
  }

  void _fetch() {
    ref.read(facilityExpensesListProvider.notifier).fetch(facilityId: _facilityId);
  }

  void _onAddExpense() => context.pushNamed(Routes.addFacilityExpense);

  String? _facilityName(List<AccessibleFacilityEntity> facilities, int? id) =>
      facilities
          .cast<AccessibleFacilityEntity?>()
          .firstWhere((f) => f?.id == id, orElse: () => null)
          ?.name;

  @override
  Widget build(BuildContext context) {
    final facilities =
        ref.watch(userSessionProvider)?.accessibleFacilities ??
        const <AccessibleFacilityEntity>[];
    final listAsync = ref.watch(facilityExpensesListProvider);

    final session = ref.watch(userSessionProvider);
    final canAddExpense =
        session?.canAny([UserPermission.facilityExpenseCreate]) ?? false;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(title: context.locale.expenseTracking),
      body: _FacilityExpenseBody(
        listAsync: listAsync,
        facilityName: _facilityName(facilities, _facilityId),
        canPickFacility: facilities.length > 1,
        onPickFacility: () => _onPickFacility(facilities),
        onRetry: _fetch,
      ),
      floatingActionButton: canAddExpense
          ? FloatingActionButton(
              onPressed: _onAddExpense,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
