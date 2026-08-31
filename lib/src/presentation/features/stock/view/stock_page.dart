import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/accessible_facility_entity.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/shift_slot_entity.dart';
import '../../../core/application_state/session_provider/session_provider.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/text/typography.dart';
import '../../shift/riverpod/shift_slots_provider.dart';
import '../widgets/facility_selector_card.dart';
import '../widgets/facility_stock_balance_body.dart';
import '../widgets/stock_footer_bar.dart';

class StockPageArgs {
  const StockPageArgs({
    required this.facilityId,
    this.shiftAssignmentId,
  });

  final int facilityId;
  final int? shiftAssignmentId;
}

class StockPage extends ConsumerStatefulWidget {
  const StockPage({super.key, this.args});

  final StockPageArgs? args;

  @override
  ConsumerState<StockPage> createState() => _StockPageState();
}

class _StockPageState extends ConsumerState<StockPage> {
  int? _selectedFacilityId;

  @override
  void initState() {
    super.initState();
    _selectedFacilityId = widget.args?.facilityId;
  }

  int? _assignmentIdFor(ShiftSlotsEntity data) {
    final activeSlot = data.activeSlot;
    if (activeSlot == null) return null;

    for (final slot in data.slots) {
      if (slot.shiftSlotId == activeSlot.shiftSlotId) {
        return slot.me?.assignmentId;
      }
    }

    return null;
  }

  void _showFacilitySelector(
    BuildContext context,
    List<AccessibleFacilityEntity> facilities,
  ) {
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
    final color = context.color;
    final spacing = context.dimensions.spacing;
    final facilities =
        ref.watch(userSessionProvider)?.accessibleFacilities ?? const [];

    final activeSlotsAsync = ref.watch(shiftSlotsProvider);
    final activeShiftFacilityId = activeSlotsAsync.valueOrNull?.facility?.id;
    final activeAssignmentId = activeSlotsAsync.valueOrNull != null
        ? _assignmentIdFor(activeSlotsAsync.valueOrNull!)
        : widget.args?.shiftAssignmentId;

    _selectedFacilityId ??=
        widget.args?.facilityId ?? activeShiftFacilityId ?? facilities.firstOrNull?.id;

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
        title: Headline2xlTinyText(context.locale.stock),
        centerTitle: true,
        backgroundColor: color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (facilities.isNotEmpty) ...[
              FacilitySelectorCard(
                facilityName: selectedFacilityName.isEmpty
                    ? context.locale.selectFacility
                    : selectedFacilityName,
                onTap: () => _showFacilitySelector(context, facilities),
              ),
              Gap(spacing.s16),
            ],
            FacilityStockBalanceBody(facilityId: _selectedFacilityId),
          ],
        ),
      ),
      bottomNavigationBar: activeShiftFacilityId != null &&
              activeAssignmentId != null &&
              activeShiftFacilityId == _selectedFacilityId
          ? PermissionGate(
              permissions: const [UserPermission.shiftStockCountCreate],
              child: StockFooterBar(
                onUpdateStockBalances: () => context.pushNamed(
                  Routes.updateStock,
                  extra: (activeShiftFacilityId, activeAssignmentId),
                ),
              ),
            )
          : null,
    );
  }
}
