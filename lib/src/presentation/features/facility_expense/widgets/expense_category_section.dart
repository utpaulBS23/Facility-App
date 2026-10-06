part of '../view/add_facility_expense_page.dart';

class _CategorySection extends ConsumerWidget {
  const _CategorySection({
    required this.enabled,
    required this.hasError,
    required this.onSelected,
  });

  final bool enabled;
  final bool hasError;
  final VoidCallback onSelected;

  Future<void> _onPickCategory(
    BuildContext context,
    WidgetRef ref,
    List<MasterDataItemEntity> categories,
  ) async {
    final result = await showModalBottomSheet<MasterDataItemEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CategoryListSheet(
        categories: categories,
        selectedCategoryId: ref.read(selectedExpenseCategoryProvider)?.id,
      ),
    );
    if (result == null) return;
    ref.read(selectedExpenseCategoryProvider.notifier).select(result);
    onSelected();
  }

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
      data: (categories) => FormSelectorCard.text(
      title: context.locale.selectTypeOfExpense,
      icon: Icons.category_outlined,
        value: category?.localizedLabel(context.languageCode),
        placeholder: context.locale.selectExpenseCategory,
        errorText: hasError ? context.locale.fieldRequired : null,
        onTap: enabled
            ? () => _onPickCategory(context, ref, categories)
            : null,
      ),
    );
  }
}
