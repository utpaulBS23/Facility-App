part of '../view/apply_leave_page.dart';

class _ApplyLeaveBody extends StatelessWidget {
  const _ApplyLeaveBody({
    required this.selectedShift,
    required this.selectedLeaveType,
    required this.reasonController,
    required this.onSelectShiftTap,
    required this.selectedAttendant,
    required this.onSelectAttendantTap,
    required this.showAttendantSelector,
  });

  final ShiftEntity? selectedShift;
  final String? selectedLeaveType;
  final TextEditingController reasonController;
  final VoidCallback onSelectShiftTap;
  final PartnerStaffEntity? selectedAttendant;
  final VoidCallback onSelectAttendantTap;
  final bool showAttendantSelector;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return SingleChildScrollView(
      padding: EdgeInsets.all(spacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showAttendantSelector) ...[
            _SelectAttendantCard(
              selectedAttendant: selectedAttendant,
              onTap: onSelectAttendantTap,
            ),
            Gap(spacing.s8),
          ],
          _LeaveSummaryCard(),
          Gap(spacing.s8),
          _SelectShiftCard(
            selectedShift: selectedShift,
            onTap: onSelectShiftTap,
          ),
          Gap(spacing.s8),
          _LeaveTypeInput(selectedLeaveType: selectedLeaveType),
          Gap(spacing.s8),
          _ReasonInput(controller: reasonController),
        ],
      ),
    );
  }
}

class _LeaveTypeInput extends StatelessWidget {
  const _LeaveTypeInput({required this.selectedLeaveType});

  final String? selectedLeaveType;

  @override
  Widget build(BuildContext context) {
    return DropdownMenuFormField(
      width: double.infinity,
      hintText: context.locale.leaveType,
      dropdownMenuEntries: [
            context.locale.sickLeave,
            context.locale.casualLeave,
            context.locale.maternityLeave,
          ]
              .map((type) => DropdownMenuEntry(value: type, label: type))
              .toList(),
      onSelected: (value) {},
      initialSelection: selectedLeaveType,
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
  const _SubmitBar({required this.onTap});

  final VoidCallback onTap;

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
            onPressed: onTap,
            child: Text(context.locale.submitLeaveRequest),
          ),
        ),
      ),
    );
  }
}
