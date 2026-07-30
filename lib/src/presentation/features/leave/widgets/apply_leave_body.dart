import 'package:facility_management_app/src/presentation/core/widgets/permission_gate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../domain/entities/app_permission.dart';
import '../../../core/theme/theme.dart';
import '../riverpod/apply_leave_form_provider.dart';
import 'apply_leave_attendant_selector.dart';
import 'apply_leave_date_selector.dart';
import 'apply_leave_reason_input.dart';
import 'apply_leave_shift_selector.dart';
import 'apply_leave_summary_card.dart';
import 'apply_leave_type_input.dart';
import 'apply_leave_type_switch.dart';

class ApplyLeaveBody extends ConsumerWidget {
  const ApplyLeaveBody({
    super.key,
    required this.onPickStartDate,
    required this.onPickEndDate,
    required this.onSelectShiftTap,
    required this.onSelectAttendantTap,
  });

  final VoidCallback onPickStartDate;
  final VoidCallback onPickEndDate;
  final VoidCallback onSelectShiftTap;
  final VoidCallback onSelectAttendantTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.dimensions.spacing;
    final form = ref.watch(applyLeaveFormProvider);
    final formNotifier = ref.read(applyLeaveFormProvider.notifier);
    final isBehalf = form.appType == LeaveApplicationType.onBehalf;

    return SingleChildScrollView(
      padding: EdgeInsets.all(spacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PermissionGate(
            anyOf: const [AppPermission.leaveFileOnBehalf],
            child: Column(
              children: [
                ApplicationTypeSwitch(
                  selectedType: form.appType,
                  onTypeChanged: formNotifier.setApplicationType,
                ),
                Gap(spacing.s12),
                if (isBehalf) ...[
                  SelectAttendantCard(
                    selectedAttendant: form.selectedAttendant,
                    onTap: onSelectAttendantTap,
                  ),
                  Gap(spacing.s8),
                ],
              ],
            ),
          ),
          PermissionGate(
            anyOf: const [AppPermission.leaveBalanceView],
            child: LeaveSummaryCard(
              attendantId: isBehalf ? form.selectedAttendant?.id : null,
              isAttendantPending: isBehalf && form.selectedAttendant == null,
              selectedLeavePolicyId: form.leavePolicyId,
            ),
          ),
          Gap(spacing.s8),
          LeaveDateRangeCard(
            startDate: form.startDate,
            endDate: form.endDate,
            onStartDateTap: onPickStartDate,
            onEndDateTap: onPickEndDate,
          ),
          Gap(spacing.s8),
          SelectShiftCard(
            selectedShift: form.selectedShift,
            onTap: onSelectShiftTap,
          ),
          Gap(spacing.s8),
          LeaveTypeInput(
            selectedLeavePolicyId: form.leavePolicyId,
            onChanged: formNotifier.setLeavePolicyId,
          ),
          Gap(spacing.s8),
          LeaveReasonInput(
            initialValue: form.reason,
            onChanged: formNotifier.setReason,
          ),
        ],
      ),
    );
  }
}
