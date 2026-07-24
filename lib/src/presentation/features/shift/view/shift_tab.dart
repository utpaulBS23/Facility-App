import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/permission_guard.dart';
import '../../../../domain/entities/login_entity.dart';
import '../../../../domain/entities/shift_entity.dart';
import '../../../../domain/entities/shift_slot_entity.dart';
import '../../../core/application_state/session_provider/session_provider.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/horizontal_date_picker.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/shift_slots_provider.dart';
import '../../../core/utils/date_formatter.dart';

part '../widgets/shift_action_buttons.dart';
part '../widgets/shift_card_helpers.dart';
part '../widgets/shift_detail_checkin_card.dart';
part '../widgets/shift_detail_contract_card.dart';
part '../widgets/shift_detail_notes_card.dart';
part '../widgets/shift_detail_supervisor_card.dart';
part '../widgets/shift_detail_tiles.dart';
part '../widgets/shift_details_body.dart';
part '../widgets/slot_card.dart';
part '../widgets/slot_detail_cards.dart';
part '../widgets/slot_roster_section.dart';
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
    // WHY: every role with shift access reads the same slots list — only the
    // assign-staff button inside each card differs by permission. A session
    // entitled to neither shift capability gets an explicit empty state.
    final hasShiftAccess = ref.watch(
      userSessionProvider.select(
        (session) =>
            (session?.shiftViewMode ?? ShiftViewMode.unavailable) !=
            ShiftViewMode.unavailable,
      ),
    );

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        title: DisplaySmallText(context.locale.shift),
        titleSpacing: context.dimensions.spacing.s16,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
        actions: [
          PermissionGate(
            permission: AppPermission.rosterView,
            child: IconButton(
              onPressed: () => _onOpenRosters(context),
              icon: Icon(
                Icons.calendar_view_week_rounded,
                color: context.color.icon,
              ),
            ),
          ),
        ],
      ),
      body: hasShiftAccess
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
    );
  }
}
