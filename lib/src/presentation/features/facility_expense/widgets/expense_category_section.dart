part of '../view/add_facility_expense_page.dart';

class _CategorySection extends ConsumerWidget {
  const _CategorySection({required this.hasError, required this.onSelected});

  final bool hasError;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(expenseCategoryOptionsProvider);
    final category = ref.watch(selectedExpenseCategoryProvider);

    return categoriesAsync.when(
      loading: () => const LinearProgressIndicator(),
      error: (_, _) => BodySmallText(
        context.locale.selectExpenseCategory,
        color: context.color.error,
      ),
      data: (categories) => _MasterDataOptionSelector(
        options: categories,
        selected: category,
        hasError: hasError,
        onChanged: (selected) {
          ref.read(selectedExpenseCategoryProvider.notifier).select(selected);
          onSelected();
        },
      ),
    );
  }
}
