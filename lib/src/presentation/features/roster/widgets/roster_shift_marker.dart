part of '../view/roster_shifts_page.dart';

class _RosterShiftMarkerRow extends StatelessWidget {
  const _RosterShiftMarkerRow({required this.shift});

  final ShiftEntity shift;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Row(
      children: [
        if (shift.slotStatus.isNotEmpty) ...[
          _RosterShiftMarkerTag(
            color: slotStatusColor(context, shift.slotStatus),
            label: slotStatusLabel(context, shift.slotStatus),
          ),
          Gap(spacing.s8),
        ],
        if (shift.hasFreeCapacity)
          _RosterShiftMarkerTag(
            color: context.color.warning,
            label: context.locale.employeeShortest,
          ),
        const Spacer(),
        if (!shift.hasFreeCapacity) const SlotStatusChip(status: 'full'),
      ],
    );
  }
}

class _RosterShiftMarkerTag extends StatelessWidget {
  const _RosterShiftMarkerTag({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: spacing.s10,
          height: spacing.s10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        Gap(spacing.s4),
        Text(label, style: context.textStyle.bodySmall.copyWith(color: color)),
      ],
    );
  }
}
