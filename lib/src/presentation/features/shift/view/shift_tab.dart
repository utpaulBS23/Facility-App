import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/permission_guard.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/login_entity.dart';
import '../../../../domain/entities/shift_entity.dart';
import '../../../core/application_state/session_provider/session_provider.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/horizontal_date_picker.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/shift_list_provider.dart';
import '../../../core/utils/date_formatter.dart';

part '../widgets/shift_action_buttons.dart';
part '../widgets/shift_card.dart';
part '../widgets/shift_card_helpers.dart';
part '../widgets/shift_detail_checkin_card.dart';
part '../widgets/shift_detail_contract_card.dart';
part '../widgets/shift_detail_notes_card.dart';
part '../widgets/shift_detail_supervisor_card.dart';
part '../widgets/shift_detail_tiles.dart';
part '../widgets/shift_details_body.dart';
part 'attendant_shift_page.dart';
part 'shift_details_page.dart';
part 'supervisor_shift_page.dart';

class ShiftTab extends ConsumerWidget {
  const ShiftTab({super.key});

  void _onApplyLeave(BuildContext context) {
    context.pushNamed(Routes.applyLeave);
  }

  void _onShiftTap(BuildContext context, ShiftEntity entity) {
    context.pushNamed(Routes.shiftDetails, extra: entity);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // WHY: mode is derived from the permission that defines each experience,
    // so a session entitled to neither gets an explicit empty state instead of
    // falling through to the supervisor view and firing a doomed request.
    final mode = ref.watch(
      userSessionProvider.select(
        (session) => session?.shiftViewMode ?? ShiftViewMode.unavailable,
      ),
    );

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        title: DisplaySmallText(context.locale.shift),
        titleSpacing: context.dimensions.spacing.s16,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: switch (mode) {
        ShiftViewMode.attendant => _AttendantShiftView(
          onApplyLeave: () => _onApplyLeave(context),
          onShiftTap: (entity) => _onShiftTap(context, entity),
        ),
        ShiftViewMode.supervisor => _SupervisorShiftView(
          onShiftTap: (entity) => _onShiftTap(context, entity),
        ),
        ShiftViewMode.unavailable => Center(
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
      },
    );
  }
}
