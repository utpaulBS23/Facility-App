part of '../view/apply_leave_page.dart';

class _SelectShiftBody extends StatelessWidget {
  const _SelectShiftBody({required this.shifts});

  final List<ShiftEntity> shifts;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return ListView.separated(
      padding: EdgeInsets.all(spacing.s16),
      itemCount: shifts.length,
      separatorBuilder: (context, index) => Gap(spacing.s12),
      itemBuilder: (context, index) {
        final shift = shifts[index];
        return _SelectableShiftCard(
          shift: shift,
          onTap: () => context.pop(shift),
        );
      },
    );
  }
}

class _SelectableShiftCard extends StatelessWidget {
  const _SelectableShiftCard({required this.shift, required this.onTap});

  final ShiftEntity shift;
  final VoidCallback onTap;

  bool get _isInProgress => shift.status == 'in_progress';

  Color _dotColor(BuildContext context) =>
      _isInProgress ? context.color.success : context.color.warning;

  String _statusLabel(BuildContext context) =>
      _isInProgress ? context.locale.inProgress : context.locale.upcoming;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final date = DateFormatter.shiftDate(DateTime.parse(shift.shiftDate));
    final timeRange =
        '${DateFormatter.shiftTime(shift.startTime)} – ${DateFormatter.shiftTime(shift.endTime)}';

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(spacing.s16),
        decoration: BoxDecoration(
          color: context.color.onPrimary,
          border: Border.all(color: context.color.borderSubtle),
          borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: _dotColor(context),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Gap(spacing.s4),
                      Text(
                        _statusLabel(context),
                        style: context.textStyle.bodySmall.copyWith(
                          color: context.color.text.secondary,
                        ),
                      ),
                    ],
                  ),
                  Gap(spacing.s8),
                  Text(
                    shift.facility.name,
                    style: context.textStyle.titleSmall.copyWith(
                      color: context.color.text.primary,
                    ),
                  ),
                  Gap(spacing.s6),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 12,
                        color: context.color.text.secondary,
                      ),
                      Gap(spacing.s4),
                      Text(
                        date,
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
                        timeRange,
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
              size: 24,
              color: context.color.primary,
            ),
          ],
        ),
      ),
    );
  }
}
