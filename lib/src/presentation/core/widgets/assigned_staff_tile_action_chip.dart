part of 'assigned_staff_tile.dart';

/// Small tonal action chip for [AssignedStaffTile] — icon and word together,
/// coloured like the rest of the app's status pills so an action reads as
/// belonging to the same visual language rather than a stray control.
class _StaffTileActionChip extends StatelessWidget {
  const _StaffTileActionChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.background,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color background;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = BorderRadius.circular(context.dimensions.radius.r6);

    return Material(
      color: background,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.s8,
            vertical: spacing.s6,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: spacing.s14, color: color),
              Gap(spacing.s4),
              Text(
                label,
                style: context.textStyle.labelSmall.copyWith(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
