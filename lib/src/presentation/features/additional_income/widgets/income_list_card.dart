part of '../view/additional_income_page.dart';

class _IncomeListCard extends ConsumerWidget {
  const _IncomeListCard({required this.income});

  final AdditionalIncomeEntity income;

  // WHY resolve client-side: the additional-incomes list endpoint returns
  // `income_type` as the raw master-data code (e.g. "rent_device"), not a
  // display label — cross-reference against the extraEarningType options
  // (already fetched for the Add Income form) to show the human label.
  String _incomeTypeLabel(WidgetRef ref) {
    final options =
        ref.watch(incomeTypeOptionsProvider).valueOrNull ?? const [];
    final match = options
        .cast<MasterDataItemEntity?>()
        .firstWhere((o) => o?.value == income.incomeTypeName, orElse: () => null);
    return match?.label ?? income.incomeTypeName;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final description = income.description;

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
                DateFormatter.shortDate(income.createdAt),
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
                  income.facilityName,
                  color: context.color.text.secondary,
                ),
              ),
            ],
          ),
          Gap(spacing.s12),
          Text(_incomeTypeLabel(ref), style: context.textStyle.bodyLarge),
          if (description != null && description.isNotEmpty) ...[
            Gap(spacing.s2),
            BodySmallText(description, color: context.color.text.secondary),
          ],
          Gap(spacing.s8),
          Text(
            '৳${NumberFormatter.format(income.amount)}',
            style: context.textStyle.headlineTiny.copyWith(
              color: context.color.primary,
            ),
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
                '${context.locale.submittedBy}: ${income.submittedByName}',
                color: context.color.text.secondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
