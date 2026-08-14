part of '../view/stock_averaging_details_page.dart';

class _FacilityMetadataCard extends StatelessWidget {
  const _FacilityMetadataCard();

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        border: Border.all(color: color.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Facility',
            style: textStyle.bodySmall.copyWith(
              color: color.text.secondary,
            ),
          ),
          Gap(spacing.s4),
          Text(
            'Mirpur-10 Public Toilet Complex',
            style: textStyle.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: color.text.primary,
            ),
          ),
          Gap(spacing.s4),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: color.text.secondary,
              ),
              Gap(spacing.s4),
              Text(
                'Mirpur-10, Dhaka',
                style: textStyle.bodySmall.copyWith(
                  color: color.text.secondary,
                ),
              ),
            ],
          ),
          Divider(color: color.borderSubtle, height: spacing.s24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Last updated',
                style: textStyle.bodySmall.copyWith(
                  color: color.text.secondary,
                ),
              ),
              Text(
                '05 March 2026',
                style: textStyle.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color.text.primary,
                ),
              ),
            ],
          ),
          Gap(spacing.s8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Updated by',
                style: textStyle.bodySmall.copyWith(
                  color: color.text.secondary,
                ),
              ),
              Text(
                'Mohammad Rahim',
                style: textStyle.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color.text.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
