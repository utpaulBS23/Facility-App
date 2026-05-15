part of '../view/attendance_page.dart';

class _AttendanceBody extends StatelessWidget {
  const _AttendanceBody({
    required this.summary,
    required this.onItemTap,
    required this.onApplyLeave,
  });

  final MonthlyAttendanceSummaryEntity summary;
  final ValueChanged<AttendanceItemEntity> onItemTap;
  final VoidCallback onApplyLeave;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return ListView.separated(
      padding: EdgeInsets.all(spacing.s16),
      // WHY: +2 for stats card and apply-leave button at top.
      itemCount: summary.attendances.length + 2,
      separatorBuilder: (context, index) => Gap(spacing.s12),
      itemBuilder: (context, index) {
        if (index == 0) return _AttendanceStatsCard(summary: summary);
        if (index == 1) return _ApplyLeaveButton(onTap: onApplyLeave);
        final item = summary.attendances[index - 2];
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
