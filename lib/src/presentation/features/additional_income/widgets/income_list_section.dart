part of '../view/additional_income_page.dart';

class _IncomeListSection extends StatelessWidget {
  const _IncomeListSection({required this.listAsync, required this.onRetry});

  final AsyncValue<AdditionalIncomeListResultEntity> listAsync;
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
                context.locale.noIncomeFound,
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
              _IncomeListCard(income: items[index]),
        );
      },
      loading: () => const _IncomeListShimmer(),
      error: (err, _) => AppErrorWidget(
        message: err.localizedMessage(context),
        onRetry: onRetry,
      ),
    );
  }
}
