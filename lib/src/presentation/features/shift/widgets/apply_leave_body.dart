part of '../view/apply_leave_page.dart';

class _ApplyLeaveBody extends StatelessWidget {
  const _ApplyLeaveBody({
    required this.selectedShift,
    required this.selectedLeaveType,
    required this.reasonController,
    required this.onSelectShiftTap,
  });

  final ShiftCardData? selectedShift;
  final String? selectedLeaveType;
  final TextEditingController reasonController;
  final VoidCallback onSelectShiftTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return SingleChildScrollView(
      padding: EdgeInsets.all(spacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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

class _LeaveSummaryCard extends StatelessWidget {
  const _LeaveSummaryCard();

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Container(
      padding: EdgeInsets.all(spacing.s8),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        border: Border.all(color: context.color.borderSubtle),
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatTile(
              value: '12',
              label: context.locale.leaveBalance,
              valueColor: context.color.success,
              backgroundColor: context.color.successAlt,
            ),
          ),
          Gap(spacing.s6),
          Expanded(
            child: _StatTile(
              value: '2',
              label: context.locale.pending,
              valueColor: context.color.warning,
              backgroundColor: context.color.warningAlt,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.value,
    required this.label,
    required this.valueColor,
    required this.backgroundColor,
  });

  final String value;
  final String label;
  final Color valueColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Container(
      padding: EdgeInsets.all(spacing.s12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r10),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: context.textStyle.titleMedium.copyWith(color: valueColor),
          ),
          Gap(spacing.s4),
          Text(
            label,
            style: context.textStyle.bodySmall.copyWith(
              color: context.color.text.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectShiftCard extends StatelessWidget {
  const _SelectShiftCard({required this.selectedShift, required this.onTap});

  final ShiftCardData? selectedShift;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        border: Border.all(color: context.color.borderSubtle),
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.locale.selectShift,
            style: context.textStyle.titleSmall.copyWith(
              color: context.color.text.secondary,
            ),
          ),
          Gap(spacing.s12),
          _SelectedShiftRow(selectedShift: selectedShift, onTap: onTap),
        ],
      ),
    );
  }
}

class _SelectedShiftRow extends StatelessWidget {
  const _SelectedShiftRow({required this.selectedShift, required this.onTap});

  final ShiftCardData? selectedShift;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final shift = selectedShift;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Icon(
            Icons.location_city_outlined,
            size: 28,
            color: context.color.icon,
          ),
          Gap(spacing.s8),
          Expanded(
            child: shift == null
                ? Text(
                    context.locale.selectShift,
                    style: context.textStyle.titleSmall.copyWith(
                      color: context.color.backgroundMuted,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shift.facilityName,
                        style: context.textStyle.titleSmall.copyWith(
                          color: context.color.text.secondary,
                        ),
                      ),
                      Gap(spacing.s4),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 12,
                            color: context.color.text.secondary,
                          ),
                          Gap(spacing.s4),
                          Text(
                            shift.date,
                            style: context.textStyle.bodySmall.copyWith(
                              color: context.color.text.secondary,
                            ),
                          ),
                          Gap(spacing.s8),
                          Icon(
                            Icons.access_time_outlined,
                            size: 12,
                            color: context.color.text.secondary,
                          ),
                          Gap(spacing.s4),
                          Text(
                            shift.timeRange,
                            style: context.textStyle.bodySmall.copyWith(
                              color: context.color.text.secondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            size: 28,
            color: context.color.primary,
          ),
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
      dropdownMenuEntries:
          ["Leave type", "Sick leave", "Casual leave", "Maternity leave"].map((
            type,
          ) {
            return DropdownMenuEntry(value: type, label: type);
          }).toList(),
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
    return TextField(
      controller: controller,
      maxLines: 5,
      decoration: InputDecoration(
        hintText: '${context.locale.reason} (${context.locale.optional})',
      ),
      style: context.textStyle.titleSmall.copyWith(
        color: context.color.text.primary,
      ),
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
