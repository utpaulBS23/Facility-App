part of '../view/roster_shifts_page.dart';

class _RosterTableCell extends StatelessWidget {
  const _RosterTableCell({required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Padding(
      padding:
          padding ??
          EdgeInsets.symmetric(horizontal: spacing.s8, vertical: spacing.s8),
      child: child,
    );
  }
}
