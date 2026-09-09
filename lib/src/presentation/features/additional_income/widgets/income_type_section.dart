part of '../view/add_additional_income_page.dart';

class _IncomeTypeSection extends ConsumerWidget {
  const _IncomeTypeSection({required this.hasError, required this.onSelected});

  final bool hasError;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incomeTypesAsync = ref.watch(incomeTypeOptionsProvider);
    final incomeType = ref.watch(selectedIncomeTypeProvider);

    return incomeTypesAsync.when(
      loading: () => const LinearProgressIndicator(),
      error: (_, _) => BodySmallText(
        context.locale.selectIncomeType,
        color: context.color.error,
      ),
      data: (incomeTypes) => _MasterDataOptionSelector(
        options: incomeTypes,
        selected: incomeType,
        hasError: hasError,
        onChanged: (selected) {
          ref.read(selectedIncomeTypeProvider.notifier).select(selected);
          onSelected();
        },
      ),
    );
  }
}
