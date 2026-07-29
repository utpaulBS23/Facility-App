part of '../view/apply_leave_page.dart';

class _ApplyLeaveBody extends StatelessWidget {
  const _ApplyLeaveBody({
    required this.pageState,
    required this.showAttendantTab,
  });

  final _ApplyLeavePageState pageState;
  final bool showAttendantTab;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final isBehalf = pageState._appType == LeaveApplicationType.onBehalf;

    return SingleChildScrollView(
      padding: EdgeInsets.all(spacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showAttendantTab) ...[
            _ApplicationTypeSwitch(
              selectedType: pageState._appType,
              onTypeChanged: (type) {
                if (pageState._appType == type) return;
                pageState.updateState(() {
                  pageState._appType = type;
                  pageState._selectedLeavePolicyId = null;
                  pageState._selectedShift = null;
                  pageState._startDate = DateTime.now();
                  pageState._endDate = DateTime.now();
                  pageState._selectedAttendant = null;
                });
              },
            ),
            Gap(spacing.s12),
          ],
          if (showAttendantTab && isBehalf) ...[
            _SelectAttendantCard(
              selectedAttendant: pageState._selectedAttendant,
              onTap: pageState._onSelectAttendantTap,
            ),
            Gap(spacing.s8),
          ],
          _LeaveSummaryCard(
            attendantId: isBehalf ? pageState._selectedAttendant?.id : null,
            isAttendantPending: isBehalf && pageState._selectedAttendant == null,
            selectedLeavePolicyId: pageState._selectedLeavePolicyId,
          ),
          Gap(spacing.s8),
          _LeaveDateRangeCard(
            startDate: pageState._startDate,
            endDate: pageState._endDate,
            onStartDateTap: pageState._onPickStartDate,
            onEndDateTap: pageState._onPickEndDate,
          ),
          Gap(spacing.s8),
          _SelectShiftCard(
            selectedShift: pageState._selectedShift,
            onTap: pageState._onSelectShiftTap,
          ),
          Gap(spacing.s8),
          _LeaveTypeInput(
            selectedLeavePolicyId: pageState._selectedLeavePolicyId,
            onChanged: (id) =>
                pageState.updateState(() => pageState._selectedLeavePolicyId = id),
          ),
          Gap(spacing.s8),
          _ReasonInput(controller: pageState._reasonController),
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
            offset: Offset(0, spacing.s2),
            blurRadius: spacing.s16,
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
