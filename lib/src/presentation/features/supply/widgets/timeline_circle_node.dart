part of '../view/request_details_page.dart';

class _TimelineCircleNode extends StatelessWidget {
  const _TimelineCircleNode({
    required this.isCompleted,
    required this.isActive,
    required this.isRejected,
  });

  final bool isCompleted;
  final bool isActive;
  final bool isRejected;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;

    final IconData icon = switch (this) {
      _ when isRejected => Icons.close_rounded,
      _ when isCompleted => Icons.check_rounded,
      _ => Icons.access_time_rounded,
    };

    final Color nodeBg = switch (this) {
      _ when isRejected => color.error,
      _ when isCompleted => color.success,
      _ => color.onPrimary,
    };

    final Color nodeBorder = switch (this) {
      _ when isRejected => color.error,
      _ when isCompleted => color.success,
      _ when isActive => color.warning,
      _ => color.borderSubtle,
    };

    final Color iconColor = switch (this) {
      _ when isRejected || isCompleted => color.onPrimary,
      _ when isActive => color.warning,
      _ => color.text.secondary,
    };

    return Container(
      width: spacing.s36,
      height: spacing.s36,
      decoration: BoxDecoration(
        color: nodeBg,
        shape: BoxShape.circle,
        border: Border.all(color: nodeBorder, width: spacing.s2),
      ),
      child: Icon(icon, size: spacing.s16, color: iconColor),
    );
  }
}
