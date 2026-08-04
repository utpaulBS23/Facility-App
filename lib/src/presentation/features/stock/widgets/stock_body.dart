part of '../view/stock_page.dart';

class _StockBody extends ConsumerWidget {
  const _StockBody({required this.facilityId});

  final int facilityId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.dimensions.spacing;
    final targetsAsync = ref.watch(facilityStockTargetsProvider(facilityId));

    return targetsAsync.when(
      loading: () => const _StockListShimmer(),
      error: (err, _) => AppErrorWidget(
        message: err.toString(),
        onRetry: () => ref.invalidate(facilityStockTargetsProvider(facilityId)),
      ),
      data: (targets) => targets.isEmpty
          ? Center(child: Text(context.locale.noStockTargetsFound))
          : ListView.separated(
              padding: EdgeInsets.all(spacing.s16),
              itemCount: targets.length,
              separatorBuilder: (context, index) => Gap(spacing.s12),
              itemBuilder: (context, index) =>
                  _StockItemCard(target: targets[index]),
            ),
    );
  }
}
