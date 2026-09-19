part of '../view/update_stock_page.dart';

class _UpdateStockBody extends ConsumerWidget {
  const _UpdateStockBody({required this.getOrCreateFormEntry});

  final ShiftStockCountItemFormEntry Function(
    StockItemEntity item,
    double previousQty,
  ) getOrCreateFormEntry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = context.color;
    final spacing = context.dimensions.spacing;
    final catalogAsync = ref.watch(itemCatalogProvider(true));
    final countsAsync = ref.watch(shiftStockCountsProvider);

    return catalogAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => AppErrorWidget(
        message: err.localizedMessage(context),
        onRetry: () => ref.invalidate(itemCatalogProvider(true)),
      ),
      data: (catalog) => countsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => AppErrorWidget(
          message: err.localizedMessage(context),
          onRetry: () => ref.invalidate(shiftStockCountsProvider),
        ),
        data: (history) {
          final items = [...catalog.items]
            ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

          if (items.isEmpty) {
            return Center(
              child: Text(
                context.locale.notAvailable,
                style: context.textStyle.bodyMedium.copyWith(
                  color: color.text.secondary,
                ),
              ),
            );
          }

          final latestByItem = {
            for (final count in latestStockCountPerItem(history))
              count.stockItemId: count.qtyOnHand,
          };

          return SingleChildScrollView(
            padding: EdgeInsets.all(spacing.s16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _InstructionAlertBanner(),
                Gap(spacing.s16),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  separatorBuilder: (context, index) => Gap(spacing.s12),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final entry = getOrCreateFormEntry(
                      item,
                      latestByItem[item.id] ?? 0,
                    );

                    return _UpdateStockFormCard(item: item, entry: entry);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

