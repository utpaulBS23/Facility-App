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
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/app_back_button.dart';
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
import '../stock/view/stock_page.dart';

part '../widgets/shift_action_buttons.dart';
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
part '../widgets/slot_details_app_bar.dart';
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

class ShiftTab extends ConsumerWidget {
  const ShiftTab({super.key});

  void _onApplyLeave(BuildContext context) {
    context.pushNamed(Routes.applyLeave);
  }

  void _onOpenRosters(BuildContext context) {
    context.pushNamed(Routes.rosterList);
  }

  void _onSlotTap(BuildContext context, ShiftSlotEntity slot) {
    context.pushNamed(Routes.shiftDetails, extra: slot);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        title: DisplaySmallText(context.locale.shift),
        titleSpacing: context.dimensions.spacing.s16,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      floatingActionButton: PermissionGate(
        permissions: [UserPermission.rosterView],
        child: FloatingActionButton(
          onPressed: () => _onOpenRosters(context),
          child: const Icon(Icons.calendar_view_week_rounded),
        ),
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
