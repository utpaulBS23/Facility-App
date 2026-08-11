part of '../view/leave_details_page.dart';

class _LeaveDetailShiftSection extends StatelessWidget {
  const _LeaveDetailShiftSection({required this.leaveRequest});

  final LeaveRequestEntity leaveRequest;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;
    final shifts = leaveRequest.shifts;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        border: Border.all(color: color.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.locale.shiftInformation,
            style: textStyle.headline2xlTiny.copyWith(
              fontWeight: FontWeight.bold,
              color: color.text.primary,
            ),
          ),
          Gap(spacing.s12),
          Divider(color: color.borderSubtle, height: 1),
          Gap(spacing.s12),
          if (shifts.isEmpty)
            _LeaveDetailRow(
              label: context.locale.dateTime,
              value: '${leaveRequest.startDate} → ${leaveRequest.endDate}',
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: shifts.length,
              separatorBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(vertical: spacing.s8),
                child: Divider(
                  color: color.borderSubtle,
                  height: context.dimensions.spacing.s1,
                ),
              ),
              itemBuilder: (context, index) => _ShiftItemTile(
                shift: shifts[index],
              ),
            ),
        ],
      ),
    );
  }
}

class _ShiftItemTile extends StatelessWidget {
  const _ShiftItemTile({
    required this.shift,
  });

  final LeaveShiftDetailEntity shift;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LeaveDetailRow(
          label: context.locale.facility,
          value: shift.facilityName,
        ),
        Gap(spacing.s8),
        _LeaveDetailRow(
          label: context.locale.shift,
          value: shift.shiftName,
        ),
        Gap(spacing.s8),
        _LeaveDetailRow(
          label: context.locale.dateTime,
          value:
              '${shift.shiftDate} · ${shift.startTime} - ${shift.endTime}',
        ),
      ],
    );
  }
}
