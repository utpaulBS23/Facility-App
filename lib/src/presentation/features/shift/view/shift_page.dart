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

part '../widgets/horizontal_date_picker.dart';
part '../widgets/horizontal_date_picker_item.dart';
part '../widgets/shift_action_buttons.dart';
part '../widgets/shift_body.dart';
part '../widgets/shift_card.dart';
part '../widgets/shift_card_helpers.dart';
part '../widgets/shift_detail_checkin_card.dart';
part '../widgets/shift_detail_contract_card.dart';
part '../widgets/shift_detail_notes_card.dart';
part '../widgets/shift_detail_supervisor_card.dart';
part '../widgets/shift_detail_tiles.dart';
part '../widgets/shift_details_body.dart';
part 'shift_details_page.dart';

class ShiftPage extends StatelessWidget {
  const ShiftPage({super.key, this.role = UserRole.attendant});

  // WHY: Hard-coded to supervisor for this sprint; will be driven by auth
  // session once the backend role API is wired up.
  final UserRole role;

  void _onApplyLeave(BuildContext context) {
    context.pushNamed(Routes.applyLeave);
  }

  void _onShiftTap(BuildContext context, ShiftCardData data) {
    context.pushNamed(Routes.shiftDetails, extra: data);
  }

  void _onCheckOut() {}

  @override
  Widget build(BuildContext context) {
    final isSupervisor = role == UserRole.supervisor;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        title: DisplaySmallText(context.locale.shift),
        titleSpacing: context.dimensions.spacing.s16,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      floatingActionButton: isSupervisor ? null : _CheckOutButton(onTap: _onCheckOut),
      body: _ShiftBody(
        role: role,
        onApplyLeave: () => _onApplyLeave(context),
        onShiftTap: (data) => _onShiftTap(context, data),
      ),
    );
  }
}
