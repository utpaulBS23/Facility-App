part of '../view/roster_list_page.dart';

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.dimensions.spacing.s8,
        vertical: context.dimensions.spacing.s4,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r4),
      ),
      child: Text(
        label,
        style: context.textStyle.labelSmall.copyWith(color: foreground),
      ),
    );
  }
}
