import 'package:facility_management_app/src/presentation/core/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/permission_guard.dart';
import '../../../../domain/entities/shift_entity.dart';
import '../../../../domain/entities/partner_staff_entity.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../shift/riverpod/partner_staff_provider.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';
import '../../../core/widgets/status_dot_tag.dart';
import '../../../core/application_state/session_provider/session_provider.dart';

part '../widgets/apply_leave_body.dart';
part '../widgets/apply_leave_attendant_selector.dart';
part '../widgets/apply_leave_shift_selector.dart';
part '../widgets/apply_leave_summary_card.dart';
part '../widgets/select_shift_body.dart';
part 'select_shift_page.dart';
part 'select_attendant_page.dart';
part 'leave_requests_page.dart';
part 'leave_details_page.dart';
part '../widgets/selectable_attendant_card.dart';
part '../widgets/leave_supervisor_summary_card.dart';
part '../widgets/leave_filter_bar.dart';
part '../widgets/leave_request_action_card.dart';
part '../widgets/leave_detail_header_card.dart';
part '../widgets/leave_detail_info_section.dart';
part '../widgets/leave_detail_shift_section.dart';
part '../widgets/leave_status_timeline.dart';

class ApplyLeavePage extends ConsumerStatefulWidget {
  const ApplyLeavePage({super.key});

  @override
  ConsumerState<ApplyLeavePage> createState() => _ApplyLeavePageState();
}

class _ApplyLeavePageState extends ConsumerState<ApplyLeavePage> {
  ShiftEntity? _selectedShift;
  String? _selectedLeaveType;
  PartnerStaffEntity? _selectedAttendant;
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _onSelectAttendantTap() async {
    final attendant = await context.pushNamed<PartnerStaffEntity>(
      Routes.selectAttendant,
    );
    if (attendant != null && mounted) {
      setState(() => _selectedAttendant = attendant);
    }
  }

  Future<void> _onSelectShiftTap() async {
    // WHY: leave owns its own fetch instead of reading the shift tab's
    // provider. That provider is no longer populated for attendants (the tab
    // moved to shift-slots), and reaching across features for cached state
    // broke silently when the other feature changed.
    final partnerId = ref.activePartnerId;
    if (partnerId == null) return;
    final result = await ref
        .read(getShiftsUseCaseProvider)
        .call(
          partnerId: partnerId,
          date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        );
    final shifts = switch (result) {
      Success(:final data) => data ?? const <ShiftEntity>[],
      _ => const <ShiftEntity>[],
    };
    if (!mounted) return;
    // WHY: go_router's pushNamed returns Future<T?> — pop(shift) on the
    // destination page delivers the selected shift back here without needing
    // a shared provider or a callback in extra.
    final shift = await context.pushNamed<ShiftEntity>(
      Routes.selectShift,
      extra: shifts,
    );
    if (shift != null && mounted) {
      setState(() => _selectedShift = shift);
    }
  }

  void _onSubmit() {
    // TODO: submit leave request
  }

  @override
  Widget build(BuildContext context) {
    final canViewLeaveRequests = ref.watch(
      userSessionProvider.select(
        (session) => session?.can(AppPermission.leaveView) ?? false,
      ),
    );

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: context.pop,
          child: Row(
            children: [
              Icon(
                Icons.chevron_left_rounded,
                color: context.color.primary,
                size: 28,
              ),
              Text(
                context.locale.back,
                style: context.textStyle.labelXl.copyWith(
                  color: context.color.primary,
                ),
              ),
            ],
          ),
        ),
        leadingWidth: 100,
        title: Headline2xlTinyText(context.locale.applyLeave),
        centerTitle: true,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: _ApplyLeaveBody(
        selectedShift: _selectedShift,
        selectedLeaveType: _selectedLeaveType,
        reasonController: _reasonController,
        onSelectShiftTap: _onSelectShiftTap,
        selectedAttendant: _selectedAttendant,
        onSelectAttendantTap: _onSelectAttendantTap,
        showAttendantSelector: canViewLeaveRequests,
      ),
      bottomNavigationBar: _SubmitBar(onTap: _onSubmit),
    );
  }
}
