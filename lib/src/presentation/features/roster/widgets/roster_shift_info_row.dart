part of '../view/roster_shifts_page.dart';

class _RosterShiftInfoRow extends StatelessWidget {
  const _RosterShiftInfoRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: spacing.s16, color: context.color.text.secondary),
        Gap(spacing.s6),
        Expanded(
          child: Text(
            label,
            style: context.textStyle.bodySmall.copyWith(
              color: context.color.text.secondary,
            ),
          ),
        ),
      ],
    );
  }
}
