part of '../view/toilet_details_page.dart';

class _ToiletStatusBanner extends StatelessWidget {
  const _ToiletStatusBanner({required this.toilet});

  final ToiletEntity toilet;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.s16,
        vertical: spacing.s10,
      ),
      decoration: BoxDecoration(
        color: toilet.status.statusColor(context).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(radius.r10),
      ),
      child: Row(
        children: [
          Container(
            width: spacing.s8,
            height: spacing.s8,
            decoration: BoxDecoration(
              color: toilet.status.statusColor(context),
              shape: BoxShape.circle,
            ),
          ),
          Gap(spacing.s6),
          Text(
            toilet.status.localizedName(context),
            style: context.textStyle.bodyMedium.copyWith(
              color: toilet.status.statusColor(context),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ToiletDetailHeaderCard extends StatelessWidget {
  const _ToiletDetailHeaderCard({required this.toilet});

  final ToiletEntity toilet;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;
    final textStyle = context.textStyle;

    return Container(
      padding: EdgeInsets.all(spacing.s12),
      decoration: BoxDecoration(
        color: color.onPrimary,
        border: Border.all(color: color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: spacing.s40,
            height: spacing.s40,
            decoration: BoxDecoration(
              color: color.errorAlt,
              borderRadius: BorderRadius.circular(radius.r10),
            ),
            child: Icon(Icons.location_on, color: color.error, size: spacing.s20),
          ),
          Gap(spacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  toilet.name,
                  style: textStyle.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color.text.primary,
                  ),
                ),
                Gap(spacing.s4),
                Row(
                  children: [
                    Icon(Icons.star, size: spacing.s14, color: color.warning),
                    Gap(spacing.s4),
                    Text(
                      toilet.averageRating.toStringAsFixed(1),
                      style: textStyle.bodySmall.copyWith(
                        color: color.text.secondary,
                      ),
                    ),
                  ],
                ),
                if (toilet.address.isNotEmpty) ...[
                  Gap(spacing.s4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: spacing.s14,
                        color: color.text.secondary,
                      ),
                      Gap(spacing.s4),
                      Expanded(
                        child: Text(
                          toilet.address,
                          style: textStyle.bodySmall.copyWith(
                            color: color.text.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
