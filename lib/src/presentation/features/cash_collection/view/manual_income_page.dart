import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/login_entity.dart';
import '../../../../domain/entities/menu_item_key.dart';
import '../../../core/application_state/session_provider/session_provider.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/facility_filter_button.dart';
import '../../../core/widgets/facility_picker_sheet.dart';
import '../../../core/widgets/menu_item_app_bar.dart';
import '../../../core/widgets/month_filter_button.dart';
import '../../../core/widgets/permission_gate.dart';
import '../widgets/manual_income_tab.dart';

/// The Manual Income menu entry: the month's cash collection entries, with a
/// button to add one.
class ManualIncomePage extends ConsumerStatefulWidget {
  const ManualIncomePage({super.key});

  @override
  ConsumerState<ManualIncomePage> createState() => _ManualIncomePageState();
}

class _ManualIncomePageState extends ConsumerState<ManualIncomePage> {
  /// Null = every accessible facility.
  int? _facilityId;
  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);

  String get _monthParam =>
      '${_month.year}-${_month.month.toString().padLeft(2, '0')}';

  Future<void> _onPickFacility(
    List<AccessibleFacilityEntity> facilities,
  ) async {
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
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final facilities =
        ref.watch(userSessionProvider)?.accessibleFacilities ??
        const <AccessibleFacilityEntity>[];

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: MenuItemAppBar(
        itemKey: MenuItemKey.manualIncome,
        fallbackTitle: context.locale.manualIncome,
        actions: [
          MonthFilterButton(
            month: _month,
            lastDate: DateTime.now(),
            onSelected: (date) =>
                setState(() => _month = DateTime(date.year, date.month)),
          ),
          if (facilities.length > 1)
            FacilityFilterButton(
              hasSelection: _facilityId != null,
              onTap: () => _onPickFacility(facilities),
            ),
          Gap(spacing.s8),
        ],
      ),
      body: ManualIncomeTab(facilityId: _facilityId, month: _monthParam),
      floatingActionButton: PermissionGate(
        permissions: const [UserPermission.cashCollectionCreate],
        child: FloatingActionButton(
          onPressed: () => context.pushNamed(Routes.addManualIncome),
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
