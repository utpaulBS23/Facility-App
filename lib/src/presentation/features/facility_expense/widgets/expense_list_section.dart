part of '../view/facility_expense_page.dart';

class _ExpenseListSection extends StatelessWidget {
  const _ExpenseListSection({required this.listAsync, required this.onRetry});

  final AsyncValue<FacilityExpenseListResultEntity> listAsync;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return listAsync.when(
      data: (result) {
        final items = result.list.items;
        if (items.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: spacing.s32),
              child: BodySmallText(
                context.locale.noExpensesFound,
                color: context.color.text.secondary,
              ),
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (_, _) => Gap(spacing.s12),
          itemBuilder: (context, index) =>
              _ExpenseListCard(expense: items[index]),
        );
      },
      loading: () => const _ExpenseListShimmer(),
      error: (err, _) => AppErrorWidget(
        message: err.localizedMessage(context),
        onRetry: onRetry,
      ),
    );
  }
}
