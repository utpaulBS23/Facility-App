part of '../view/add_additional_income_page.dart';

// WHY always appended client-side: kept out of the master-data list so it's
// pickable even while that list is loading or failed to load.
MasterDataItemEntity productSellIncomeTypeOption(BuildContext context) {
  return MasterDataItemEntity(
    id: -1,
    value: productSellIncomeTypeValue,
    label: context.locale.productSell,
    isActive: true,
    sortOrder: 999,
  );
}

class _IncomeTypeSection extends ConsumerWidget {
  const _IncomeTypeSection({required this.hasError, required this.onSelected});

  final bool hasError;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incomeTypesAsync = ref.watch(incomeTypeOptionsProvider);
    final incomeType = ref.watch(selectedIncomeTypeProvider);
    final options = <MasterDataItemEntity>[
      ...incomeTypesAsync.valueOrNull ?? const <MasterDataItemEntity>[],
      productSellIncomeTypeOption(context),
    ];

    return _MasterDataOptionSelector(
      options: options,
      selected: incomeType,
      hasError: hasError,
      onChanged: (selected) {
        ref.read(selectedIncomeTypeProvider.notifier).select(selected);
        onSelected();
      },
    );
  }
}
