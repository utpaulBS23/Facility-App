part of '../view/shift_tab.dart';

class _DateTimeTile extends StatelessWidget {
  const _DateTimeTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Container(
      padding: EdgeInsets.all(spacing.s12),
      decoration: BoxDecoration(
        color: context.color.scaffoldBackground,
        border: Border.all(color: context.color.borderSubtle),
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: context.color.text.primary),
              Gap(spacing.s8),
              Text(
                label,
                style: context.textStyle.labelSmall.copyWith(
                  color: context.color.text.primary,
                ),
              ),
            ],
          ),
          Gap(spacing.s8),
          Text(
            value,
            style: context.textStyle.headline2xlTiny.copyWith(
              color: context.color.text.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ShiftDetailRow extends StatelessWidget {
  const _ShiftDetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Row(
      children: [
        Container(
          width: spacing.s36,
          height: spacing.s36,
          decoration: BoxDecoration(
            color: context.color.scaffoldBackground,
            borderRadius: BorderRadius.circular(radius.r10),
          ),
          child: Icon(icon, size: 16, color: context.color.text.secondary),
        ),
        Gap(spacing.s16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.textStyle.labelRegular.copyWith(
                  color: context.color.text.secondary,
                ),
              ),
              Gap(spacing.s4),
              Text(
                value,
                style: context.textStyle.titleSmall.copyWith(
                  color: context.color.text.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
