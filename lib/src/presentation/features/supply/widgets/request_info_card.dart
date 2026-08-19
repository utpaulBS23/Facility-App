part of '../view/request_details_page.dart';

class RequestInfoCard extends StatelessWidget {
  const RequestInfoCard({
    super.key,
    required this.label,
    required this.title,
    this.subtitle,
    this.icon,
  });

  final String label;
  final String title;
  final String? subtitle;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        border: Border.all(color: context.color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.textStyle.bodySmall.copyWith(
              color: context.color.text.secondary,
            ),
          ),
          Gap(spacing.s6),
          Text(
            title,
            style: context.textStyle.titleMedium.copyWith(
              color: context.color.text.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle != null) ...[
            Gap(spacing.s4),
            Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: spacing.s14,
                    color: context.color.text.secondary,
                  ),
                  Gap(spacing.s4),
                ],
                Expanded(
                  child: Text(
                    subtitle!,
                    style: context.textStyle.bodySmall.copyWith(
                      color: context.color.text.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
