part of '../view/toilet_location_page.dart';

class _ToiletCard extends StatelessWidget {
  const _ToiletCard({
    required this.toilet,
    required this.onTap,
  });

  final ToiletEntity toilet;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        border: Border.all(color: color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: spacing.s40,
                height: spacing.s40,
                decoration: BoxDecoration(
                  color: color.errorAlt,
                  borderRadius: BorderRadius.circular(radius.r10),
                ),
                child: Icon(
                  Icons.location_on,
                  color: color.error,
                  size: spacing.s20,
                ),
              ),
              Gap(spacing.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                          style: context.textStyle.bodySmall.copyWith(
                            color: color.text.secondary,
                          ),
                        ),
                      ],
                    ),
                    Gap(spacing.s2),
                    Text(
                      toilet.name,
                      style: context.textStyle.titleMedium.copyWith(
                        color: color.text.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gap(spacing.s4),
                    Row(
                      children: [
                        Icon(Icons.star, size: spacing.s14, color: color.warning),
                        Gap(spacing.s4),
                        Text(
                          toilet.averageRating.toStringAsFixed(1),
                          style: context.textStyle.bodySmall.copyWith(
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
                              style: context.textStyle.bodySmall.copyWith(
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
          Gap(spacing.s12),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: spacing.s48,
                  child: FilledButton(
                    onPressed: () => toilet.openDirection(),
                    style: FilledButton.styleFrom(
                      backgroundColor: color.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(radius.r10),
                      ),
                    ),
                    child: Text(
                      context.locale.direction,
                      style: context.textStyle.bodySmall.copyWith(
                        color: color.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              Gap(spacing.s12),
              Expanded(
                child: SizedBox(
                  height: spacing.s48,
                  child: OutlinedButton(
                    onPressed: onTap,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: color.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(radius.r10),
                      ),
                    ),
                    child: Text(
                      context.locale.details,
                      style: context.textStyle.bodySmall.copyWith(
                        color: color.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
