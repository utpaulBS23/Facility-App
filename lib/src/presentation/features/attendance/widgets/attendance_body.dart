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

    return Column(
      children: [
        Container(
          color: context.color.scaffoldBackground,
          padding: EdgeInsets.fromLTRB(
            spacing.s16,
            spacing.s16,
            spacing.s16,
            spacing.s12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _AttendanceStatsCard(summary: summary),
              if (showApplyLeave) ...[
                Gap(spacing.s12),
                _ApplyLeaveButton(onTap: onApplyLeave),
              ],
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.fromLTRB(
              spacing.s16,
              spacing.s4,
              spacing.s16,
              spacing.s16,
            ),
            itemCount: summary.attendances.length,
            separatorBuilder: (context, index) => Gap(spacing.s12),
            itemBuilder: (context, index) {
              final item = summary.attendances[index];
              return _AttendanceListItem(
                item: item,
                onTap: () => onItemTap(item),
              );
            },
          ),
        ),
      ],
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
        icon: Assets.icons.addCalendar.svg(),
        label: Text(context.locale.applyLeave),
      ),
    );
  }
}
