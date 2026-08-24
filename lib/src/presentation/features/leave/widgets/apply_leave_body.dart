import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../domain/entities/app_permission.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/permission_gate.dart';
import '../riverpod/apply_leave_provider/selected_leave_attendant_provider.dart';
import '../riverpod/apply_leave_provider/selected_leave_policy_id_provider.dart';
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
    required this.leaveApplicationType,
    required this.onTypeChanged,
    required this.onSelectAttendant,
    required this.startDate,
    required this.endDate,
    required this.onPickStartDate,
    required this.onPickEndDate,
    required this.onSelectShift,
    required this.reasonController,
  });

  final LeaveApplicationType leaveApplicationType;
  final ValueChanged<LeaveApplicationType> onTypeChanged;
  final VoidCallback onSelectAttendant;
  final DateTime startDate;
  final DateTime endDate;
  final VoidCallback onPickStartDate;
  final VoidCallback onPickEndDate;
  final VoidCallback onSelectShift;
  final TextEditingController reasonController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAttendant = ref.watch(selectedLeaveAttendantProvider);
    final selectedLeavePolicyId = ref.watch(selectedLeavePolicyIdProvider);

    final spacing = context.dimensions.spacing;
    final isBehalf = leaveApplicationType == LeaveApplicationType.onBehalf;

    final isShiftEnabled = switch (leaveApplicationType) {
      LeaveApplicationType.own => true,
      LeaveApplicationType.onBehalf => selectedAttendant != null,
    };
    final isLeavePolicyEnabled = switch (leaveApplicationType) {
      LeaveApplicationType.own => true,
      LeaveApplicationType.onBehalf => selectedAttendant != null,
    };
    final isReasonEnabled = selectedLeavePolicyId != null;

    return SingleChildScrollView(
      padding: EdgeInsets.all(spacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PermissionGate(
            permissions: const [UserPermission.leaveFileOnBehalf],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ApplicationTypeSwitch(
                  selectedType: leaveApplicationType,
                  onTypeChanged: onTypeChanged,
                ),
                Gap(spacing.s12),
                if (isBehalf) ...[
                  SelectAttendantCard(
                    onTap: onSelectAttendant,
                  ),
                  Gap(spacing.s8),
                ],
              ],
            ),
          ),
          PermissionGate(
            permissions: const [UserPermission.leaveBalanceView],
            child: LeaveSummaryCard(
              isBehalf: isBehalf,
            ),
          ),
          Gap(spacing.s8),
          LeaveDateRangeCard(
            startDate: startDate,
            endDate: endDate,
            onStartDateTap: onPickStartDate,
            onEndDateTap: onPickEndDate,
          ),
          Gap(spacing.s8),
          SelectShiftCard(
            onTap: onSelectShift,
            enabled: isShiftEnabled,
          ),
          Gap(spacing.s8),
          LeaveTypeInput(
            attendantId: isBehalf ? selectedAttendant?.id : null,
            isEnabled: isLeavePolicyEnabled,
          ),
          Gap(spacing.s8),
          LeaveReasonInput(
            controller: reasonController,
            enabled: isReasonEnabled,
          ),
        ],
      ),
    );
  }
}
