part of '../view/apply_leave_page.dart';

class _ApplicationTypeSwitch extends StatelessWidget {
  const _ApplicationTypeSwitch({
    required this.selectedType,
    required this.onTypeChanged,
  });

  final LeaveApplicationType selectedType;
  final ValueChanged<LeaveApplicationType> onTypeChanged;

  @override
  Widget build(BuildContext context) {
    final color = context.color;
    final textStyle = context.textStyle;

    return SegmentedButton<LeaveApplicationType>(
      segments: [
        ButtonSegment<LeaveApplicationType>(
          value: LeaveApplicationType.own,
          label: Text(context.locale.own),
          icon: const Icon(Icons.person_outline),
        ),
        ButtonSegment<LeaveApplicationType>(
          value: LeaveApplicationType.onBehalf,
          label: Text(context.locale.onBehalf),
          icon: const Icon(Icons.people_outline),
        ),
      ],
      selected: {selectedType},
      onSelectionChanged: (newSelection) {
        onTypeChanged(newSelection.first);
      },
      style: SegmentedButton.styleFrom(
        backgroundColor: color.onPrimary,
        selectedBackgroundColor: color.primary.withValues(alpha: 0.15),
        selectedForegroundColor: color.primary,
        foregroundColor: color.text.secondary,
        textStyle: textStyle.labelLarge.copyWith(fontWeight: FontWeight.bold),
        side: BorderSide(color: color.borderSubtle),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.dimensions.radius.r12)),
      ),
    );
  }
}
