part of '../view/apply_leave_page.dart';

class _SelectShiftCard extends StatelessWidget {
  const _SelectShiftCard({required this.selectedShift, required this.onTap});

  final ShiftEntity? selectedShift;
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

  final ShiftEntity? selectedShift;
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
                        shift.facility.name,
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
                            DateFormatter.shiftDate(
                              DateTime.parse(shift.shiftDate),
                            ),
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
                            '${DateFormatter.shiftTime(shift.startTime)} – ${DateFormatter.shiftTime(shift.endTime)}',
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
