part of '../view/shift_tab.dart';

/// Small text button for a table-row action — same shape wherever
/// [_AssignedStaffTable] needs one, coloured by intent.
class _RowActionButton extends StatelessWidget {
  const _RowActionButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: spacing.s8),
        minimumSize: Size(0, spacing.s32),
        visualDensity: VisualDensity.compact,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        label,
        style: context.textStyle.labelSmall.copyWith(color: color),
      ),
    );
  }
}
