part of '../view/additional_income_page.dart';

class _ProductSaleEntryCard extends StatelessWidget {
  const _ProductSaleEntryCard({required this.entry});

  final ProductSaleEntryEntity entry;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final profit = entry.profit;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        border: Border.all(color: context.color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                size: spacing.s14,
                color: context.color.text.secondary,
              ),
              Gap(spacing.s4),
              BodySmallText(
                DateFormatter.shortDate(entry.entryDate),
                color: context.color.text.secondary,
              ),
            ],
          ),
          Gap(spacing.s4),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: spacing.s14,
                color: context.color.text.secondary,
              ),
              Gap(spacing.s4),
              Expanded(
                child: BodySmallText(
                  entry.facilityName,
                  color: context.color.text.secondary,
                ),
              ),
            ],
          ),
          Gap(spacing.s12),
          Text(entry.productName, style: context.textStyle.bodyLarge),
          Gap(spacing.s2),
          BodySmallText(
            '${entry.unitsSold} × ৳${NumberFormatter.format(entry.unitPrice)}',
            color: context.color.text.secondary,
          ),
          Gap(spacing.s8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '৳${NumberFormatter.format(entry.revenue)}',
                style: context.textStyle.headlineTiny.copyWith(
                  color: context.color.primary,
                ),
              ),
              if (profit != null)
                BodySmallText(
                  '${context.locale.totalProfit}: ৳${NumberFormatter.format(profit)}',
                  color: context.color.success,
                ),
            ],
          ),
          Gap(spacing.s12),
          Row(
            children: [
              Icon(
                Icons.person_outline_rounded,
                size: spacing.s14,
                color: context.color.text.secondary,
              ),
              Gap(spacing.s4),
              BodySmallText(
                '${context.locale.submittedBy}: ${entry.recordedByName}',
                color: context.color.text.secondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
