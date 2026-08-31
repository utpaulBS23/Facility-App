import 'package:facility_management_app/src/presentation/core/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/login_entity.dart';
import '../../../../domain/entities/shift_entity.dart';
import '../../../../domain/entities/shift_slot_entity.dart';
import '../../../core/application_state/session_provider/session_provider.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../../../core/widgets/facility_picker_sheet.dart';
import '../../../core/widgets/assign_staff_button.dart';
import '../../../core/widgets/horizontal_date_picker.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/slot_status_chip.dart';
import '../../../core/widgets/status_pill.dart';
import '../../../core/widgets/text/typography.dart';
import '../../../core/widgets/unassign_staff_confirm_dialog.dart';
import '../riverpod/make_slot_lead_provider.dart';
import '../riverpod/shift_slots_provider.dart';
import '../riverpod/unassign_shift_slot_provider.dart';

part '../widgets/shift_action_buttons.dart';
part '../widgets/shift_fab.dart';
part '../widgets/shift_card_helpers.dart';
part '../widgets/shift_detail_checkin_card.dart';
part '../widgets/shift_detail_contract_card.dart';
part '../widgets/shift_detail_notes_card.dart';
part '../widgets/shift_detail_supervisor_card.dart';
part '../widgets/shift_detail_tiles.dart';
part '../widgets/shift_details_body.dart';
part '../widgets/shift_slots_content.dart';
part '../widgets/shift_slots_list.dart';
part '../widgets/shift_slots_message.dart';
part '../widgets/active_slot_banner.dart';
part '../widgets/assigned_staff_table.dart';
part '../widgets/row_action_button.dart';
part '../widgets/slot_card.dart';
part '../widgets/slot_assigned_section.dart';
part '../widgets/slot_detail_check_in_card.dart';
part '../widgets/slot_detail_contract_card.dart';
part '../widgets/slot_detail_staffing_card.dart';
part '../widgets/slot_details_action_listener.dart';
part '../widgets/slot_details_check_out_bar.dart';
part '../widgets/slot_details_content.dart';
part '../widgets/slot_roster_section.dart';
part '../widgets/slot_selfie_avatar.dart';
part '../widgets/slot_selfie_entry.dart';
part '../widgets/slot_marker_tag.dart';
part '../widgets/staff_row_actions.dart';
part '../widgets/table_cell.dart';
part 'shift_details_page.dart';
part 'shift_slots_page.dart';
part 'slot_details_page.dart';

class ShiftTab extends ConsumerStatefulWidget {
  const ShiftTab({super.key});

  @override
  ConsumerState<ShiftTab> createState() => _ShiftTabState();
}

class _ShiftTabState extends ConsumerState<ShiftTab> {
  int? _selectedFacilityId;

  void _onApplyLeave(BuildContext context) {
    context.pushNamed(Routes.applyLeave);
  }

  void _onOpenRosters(BuildContext context) {
    context.pushNamed(Routes.rosterList);
  }

  void _onSlotTap(BuildContext context, ShiftSlotEntity slot) {
    context.pushNamed(Routes.shiftDetails, extra: slot);
  }

  Future<void> _pickFacility(List<AccessibleFacilityEntity> facilities) async {
    final result = await showModalBottomSheet<({int? facilityId})>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FacilityPickerSheet(
        facilities: facilities,
        selectedFacilityId: _selectedFacilityId,
      ),
    );
    if (result == null || result.facilityId == _selectedFacilityId) return;
    setState(() => _selectedFacilityId = result.facilityId);
  }

  @override
  Widget build(BuildContext context) {
    final facilities =
        ref.watch(userSessionProvider)?.accessibleFacilities ??
        const <AccessibleFacilityEntity>[];
    final selectedFacilityName = facilities
        .cast<AccessibleFacilityEntity?>()
        .firstWhere((f) => f?.id == _selectedFacilityId, orElse: () => null)
        ?.name;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        title: DisplaySmallText(context.locale.shift),
        titleSpacing: context.dimensions.spacing.s16,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
        actions: [
          if (facilities.length > 1)
            TextButton.icon(
              onPressed: () => _pickFacility(facilities),
              icon: const Icon(Icons.apartment_outlined, size: 18),
              label: Text(
                selectedFacilityName ?? context.locale.facilityName,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
      floatingActionButton: _ShiftFab(
        onOpenRosters: () => _onOpenRosters(context),
      ),
      // WHY these two permissions: they are what [ShiftEntitlement] is derived
      // from — managing a roster (`shift.assign_attendant`) or working a shift
      // (`attendance.check_in`). Every role with either reads the same slots
      // list; a session with neither gets an explicit empty state.
      body: PermissionGate(
        permissions: const [
          UserPermission.shiftAssignAttendant,
          UserPermission.attendanceCheckIn,
        ],
        builder: (context, hasShiftAccess) => hasShiftAccess
            ? _ShiftSlotsView(
                facilityId: _selectedFacilityId,
                onApplyLeave: () => _onApplyLeave(context),
                onSlotTap: (slot) => _onSlotTap(context, slot),
              )
            : Center(
                child: Padding(
                  padding: EdgeInsets.all(context.dimensions.spacing.s24),
                  child: Text(
                    context.locale.shiftsUnavailable,
                    style: context.textStyle.bodyMedium.copyWith(
                      color: context.color.text.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
      ),
    );
  }
}
