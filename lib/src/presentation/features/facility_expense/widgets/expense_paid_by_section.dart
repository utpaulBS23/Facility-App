part of '../view/add_facility_expense_page.dart';

class _PaidBySection extends ConsumerWidget {
  const _PaidBySection({
    required this.amountController,
    required this.hasError,
    required this.onSelected,
  });

  final TextEditingController amountController;
  final bool hasError;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paidByOptionsAsync = ref.watch(paidByOptionsProvider);
    final paidBy = ref.watch(selectedExpensePaidByProvider);

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: amountController,
      builder: (context, amountValue, _) {
        final paidByEnabled =
            (double.tryParse(amountValue.text.trim()) ?? 0) > 0;

        return paidByOptionsAsync.when(
          loading: () => const LinearProgressIndicator(),
          error: (_, _) => BodySmallText(
            context.locale.paidBy,
            color: context.color.error,
          ),
          data: (options) => _MasterDataOptionSelector(
            options: options,
            selected: paidBy,
            hasError: hasError,
            enabled: paidByEnabled && options.isNotEmpty,
            onChanged: (selected) {
              ref.read(selectedExpensePaidByProvider.notifier).select(selected);
              onSelected();
            },
          ),
        );
      },
    );
  }
}
