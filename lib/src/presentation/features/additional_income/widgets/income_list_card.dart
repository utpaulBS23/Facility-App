part of '../view/additional_income_page.dart';

class _IncomeListCard extends ConsumerWidget {
  const _IncomeListCard({required this.income});

  final AdditionalIncomeEntity income;

  // WHY resolve client-side: the additional-incomes list endpoint returns
  // `income_type` as the raw master-data code (e.g. "rent_device"), not a
  // display label — cross-reference against the extraEarningType options
  // (already fetched for the Add Income form) to show the human label.
  //
  // WHY null while loading: the options are fetched when the list opens, so
  // for a moment the only thing to show is the raw code. A placeholder reads
  // better than a flash of "rent_device".
  String? _incomeTypeLabel(WidgetRef ref, String languageCode) {
    final optionsAsync = ref.watch(incomeTypeOptionsProvider);
    if (optionsAsync.isLoading && !optionsAsync.hasValue) return null;

    final options = optionsAsync.valueOrNull ?? const [];
    final match = options.cast<MasterDataItemEntity?>().firstWhere(
      (o) => o?.value == income.incomeTypeName,
      orElse: () => null,
    );
    return match?.localizedLabel(languageCode) ?? income.incomeTypeName;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final description = income.description;
    final typeLabel = _incomeTypeLabel(ref, context.languageCode);

    return Material(
      color: context.color.onPrimary,
      borderRadius: BorderRadius.circular(radius.r12),
      child: InkWell(
        borderRadius: BorderRadius.circular(radius.r12),
        onTap: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => _IncomeDetailsSheet(
            income: income,
            typeLabel:
                _incomeTypeLabel(ref, context.languageCode) ??
                income.incomeTypeName,
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(spacing.s16),
          decoration: BoxDecoration(
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
                      income.localizedFacilityName(context.languageCode),
                      color: context.color.text.secondary,
                    ),
                  ),
                ],
              ),
              Gap(spacing.s12),
              if (typeLabel == null)
                ShimmerBox(width: spacing.s120, height: spacing.s16)
              else
                Text(typeLabel, style: context.textStyle.bodyLarge),
              if (description != null && description.isNotEmpty) ...[
                Gap(spacing.s2),
                BodySmallText(description, color: context.color.text.secondary),
              ],
              Gap(spacing.s8),
              Text(
                context.numbers.currency(income.amount),
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
                    '${context.locale.submittedBy}: ${income.localizedSubmittedByName(context.languageCode)}',
                    color: context.color.text.secondary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
