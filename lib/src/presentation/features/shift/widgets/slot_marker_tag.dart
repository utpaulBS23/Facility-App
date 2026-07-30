part of '../view/shift_tab.dart';

/// Dot + label status marker used in the slot card's tag row.
class _SlotMarkerTag extends StatelessWidget {
  const _SlotMarkerTag({required this.color, required this.label});

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
        // WHY the label takes the dot's colour: the two read as one marker,
        // and the status stays legible without a pill behind it.
        Text(label, style: context.textStyle.bodySmall.copyWith(color: color)),
      ],
    );
  }
}
