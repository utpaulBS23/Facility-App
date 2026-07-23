part of '../view/attendance_page.dart';

class _AttendanceBody extends StatelessWidget {
  const _AttendanceBody({
    required this.summary,
    required this.onItemTap,
    required this.onApplyLeave,
    required this.showApplyLeave,
  });

  final MonthlyAttendanceSummaryEntity summary;
  final ValueChanged<AttendanceItemEntity> onItemTap;
  final VoidCallback onApplyLeave;
  final bool showApplyLeave;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return ListView.separated(
      padding: EdgeInsets.all(spacing.s16),
      // WHY: stats card is always item 0; apply-leave slot exists only when
      // the user holds leave.request — index math shifts accordingly.
      itemCount: summary.attendances.length + (showApplyLeave ? 2 : 1),
      separatorBuilder: (context, index) => Gap(spacing.s12),
      itemBuilder: (context, index) {
        if (index == 0) return _AttendanceStatsCard(summary: summary);
        if (showApplyLeave && index == 1) {
          return _ApplyLeaveButton(onTap: onApplyLeave);
        }
        final item = summary.attendances[index - (showApplyLeave ? 2 : 1)];
        return _AttendanceListItem(
          item: item,
          onTap: () => onItemTap(item),
        );
      },
    );
  }
}

class _ApplyLeaveButton extends StatelessWidget {
  const _ApplyLeaveButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: FilledButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.calendar_month_outlined),
        label: Text(context.locale.applyLeave),
      ),
    );
  }
}
