part of '../view/apply_leave_page.dart';

class _ApplyLeaveBody extends StatelessWidget {
  const _ApplyLeaveBody({
    required this.appType,
    required this.onAppTypeChanged,
    required this.startDate,
    required this.endDate,
    required this.onStartDateTap,
    required this.onEndDateTap,
    required this.selectedShift,
    required this.selectedLeavePolicyId,
    required this.onLeavePolicyChanged,
    required this.reasonController,
    required this.onSelectShiftTap,
    required this.selectedAttendant,
    required this.onSelectAttendantTap,
    required this.showAttendantTab,
  });

  final LeaveApplicationType appType;
  final ValueChanged<LeaveApplicationType> onAppTypeChanged;
  final DateTime startDate;
  final DateTime endDate;
  final VoidCallback onStartDateTap;
  final VoidCallback onEndDateTap;
  final ShiftEntity? selectedShift;
  final int? selectedLeavePolicyId;
  final ValueChanged<int?> onLeavePolicyChanged;
  final TextEditingController reasonController;
  final VoidCallback onSelectShiftTap;
  final LeaveAttendantEntity? selectedAttendant;
  final VoidCallback onSelectAttendantTap;
  final bool showAttendantTab;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final isBehalf = appType == LeaveApplicationType.onBehalf;

    return SingleChildScrollView(
      padding: EdgeInsets.all(spacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showAttendantTab) ...[
            _ApplicationTypeSwitch(
              selectedType: appType,
              onTypeChanged: onAppTypeChanged,
            ),
            Gap(spacing.s12),
          ],
          if (showAttendantTab && isBehalf) ...[
            _SelectAttendantCard(
              selectedAttendant: selectedAttendant,
              onTap: onSelectAttendantTap,
            ),
            Gap(spacing.s8),
          ],
          _LeaveSummaryCard(
            attendantId: isBehalf ? selectedAttendant?.id : null,
            isAttendantPending: isBehalf && selectedAttendant == null,
            selectedLeavePolicyId: selectedLeavePolicyId,
          ),
          Gap(spacing.s8),
          _LeaveDateRangeCard(
            startDate: startDate,
            endDate: endDate,
            onStartDateTap: onStartDateTap,
            onEndDateTap: onEndDateTap,
          ),
          Gap(spacing.s8),
          _SelectShiftCard(
            selectedShift: selectedShift,
            onTap: onSelectShiftTap,
          ),
          Gap(spacing.s8),
          _LeaveTypeInput(
            selectedLeavePolicyId: selectedLeavePolicyId,
            onChanged: onLeavePolicyChanged,
          ),
          Gap(spacing.s8),
          _ReasonInput(controller: reasonController),
        ],
      ),
    );
  }
}

class _LeaveTypeInput extends ConsumerWidget {
  const _LeaveTypeInput({
    required this.selectedLeavePolicyId,
    required this.onChanged,
  });

  final int? selectedLeavePolicyId;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final policiesState = ref.watch(leavePoliciesProvider);

    final entries = policiesState.maybeWhen(
      data: (policies) => policies
          .map((p) => DropdownMenuEntry<int>(value: p.id, label: p.name))
          .toList(),
      orElse: () => <DropdownMenuEntry<int>>[],
    );

    return DropdownMenuFormField<int>(
      key: ValueKey(selectedLeavePolicyId),
      width: double.infinity,
      hintText: context.locale.leaveType,
      dropdownMenuEntries: entries,
      onSelected: onChanged,
      initialSelection: selectedLeavePolicyId,
      menuStyle: MenuStyle(
        padding: WidgetStatePropertyAll(
          EdgeInsets.all(context.dimensions.spacing.s16),
        ),
      ),
    );
  }
}

class _ReasonInput extends StatelessWidget {
  const _ReasonInput({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return AppTextField.description(
      controller: controller,
      hint: '${context.locale.reason} (${context.locale.optional})',
      textInputAction: TextInputAction.done,
    );
  }
}

class _SubmitBar extends StatelessWidget {
  const _SubmitBar({required this.onTap, this.isEnabled = true});

  final VoidCallback onTap;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Container(
      padding: EdgeInsets.fromLTRB(
        spacing.s16,
        spacing.s12,
        spacing.s16,
        spacing.s20,
      ),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        boxShadow: [
          BoxShadow(
            color: context.color.shadow,
            offset: const Offset(0, 2),
            blurRadius: 14,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: spacing.s44,
          width: double.infinity,
          child: FilledButton(
            onPressed: isEnabled ? onTap : null,
            child: Text(context.locale.submitLeaveRequest),
          ),
        ),
      ),
    );
  }
}
