import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/shift_entity.dart';
import '../../../../domain/entities/user_role.dart';
import '../../../core/gen/assets.gen.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/shift_list_provider.dart';
import '../../../core/utils/date_formatter.dart';

part '../widgets/horizontal_date_picker.dart';
part '../widgets/horizontal_date_picker_item.dart';
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

class ShiftPage extends ConsumerWidget {
  const ShiftPage({super.key});

  void _onApplyLeave(BuildContext context) {
    context.pushNamed(Routes.applyLeave);
  }

  void _onShiftTap(BuildContext context, ShiftEntity entity) {
    context.pushNamed(Routes.shiftDetails, extra: entity);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.read(getUserSessionUseCaseProvider).call();
    final role = session?.role ?? UserRole.attendant;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        title: DisplaySmallText(context.locale.shift),
        titleSpacing: context.dimensions.spacing.s16,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: role == UserRole.supervisor
          ? _SupervisorShiftView(
              onShiftTap: (entity) => _onShiftTap(context, entity),
            )
          : _AttendantShiftView(
              onApplyLeave: () => _onApplyLeave(context),
              onShiftTap: (entity) => _onShiftTap(context, entity),
            ),
    );
  }
}
