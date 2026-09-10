part of '../view/add_additional_income_page.dart';

class _IncomeTypeSection extends ConsumerWidget {
  const _IncomeTypeSection({required this.hasError, required this.onSelected});

  final bool hasError;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incomeTypesAsync = ref.watch(incomeTypeOptionsProvider);
    final incomeType = ref.watch(selectedIncomeTypeProvider);

    return _MasterDataOptionSelector(
      options: incomeTypesAsync.valueOrNull ?? const <MasterDataItemEntity>[],
      selected: incomeType,
      hasError: hasError,
      onChanged: (selected) {
        ref.read(selectedIncomeTypeProvider.notifier).select(selected);
        onSelected();
      },
    );
  }
}
