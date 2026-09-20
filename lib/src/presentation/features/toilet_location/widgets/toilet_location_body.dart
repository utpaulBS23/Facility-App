part of '../view/toilet_location_page.dart';

class _ToiletLocationBody extends StatelessWidget {
  const _ToiletLocationBody({
    required this.toiletsAsync,
    required this.selectedFilter,
    required this.onFilterSelected,
    required this.searchQuery,
    required this.searchController,
    required this.onSearchChanged,
    required this.onToiletTap,
    required this.onRetry,
  });

  final AsyncValue<ToiletListPageEntity> toiletsAsync;
  final ToiletListFilter selectedFilter;
  final ValueChanged<ToiletListFilter> onFilterSelected;
  final String searchQuery;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<ToiletEntity> onToiletTap;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final padding = EdgeInsets.symmetric(
      horizontal: spacing.s16,
      vertical: spacing.s8,
    );

    return Column(
      children: [
        Padding(
          padding: padding,
          child: toiletsAsync.when(
            data: (page) => _ToiletSummaryRow(summary: page.summary),
            loading: () => const _ToiletSummaryRowShimmer(),
            error: (err, stack) => const SizedBox.shrink(),
          ),
        ),
        Padding(
          padding: padding,
          child: _ToiletSearchField(
            controller: searchController,
            onChanged: onSearchChanged,
          ),
        ),
        Padding(
          padding: padding,
          child: CategoryFilterChips<ToiletListFilter>(
            categories: ToiletListFilter.values,
            selectedCategory: selectedFilter,
            onSelected: onFilterSelected,
            labelBuilder: (context, filter) => switch (filter) {
              ToiletListFilter.all => context.locale.all,
              ToiletListFilter.active =>
                '${context.locale.open} (${toiletsAsync.valueOrNull?.summary.active ?? 0})',
              ToiletListFilter.inactive => context.locale.close,
              ToiletListFilter.maintenance =>
                context.locale.underConstruction,
            },
          ),
        ),
        Expanded(
          child: toiletsAsync.when(
            loading: () => const _ToiletListShimmer(),
            error: (err, _) => AppErrorWidget(
              message: err.localizedMessage(context),
              onRetry: onRetry,
            ),
            data: (page) {
              final query = searchQuery.trim().toLowerCase();
              final toilets = query.isEmpty
                  ? page.list.items
                  : page.list.items
                      .where((f) => f.name.toLowerCase().contains(query))
                      .toList();

              if (toilets.isEmpty) {
                return Center(
                  child: Text(
                    context.locale.noToiletsFound,
                    style: context.textStyle.bodyMedium.copyWith(
                      color: context.color.text.secondary,
                    ),
                  ),
                );
              }

              return ListView.separated(
                padding: EdgeInsets.all(spacing.s16),
                itemCount: toilets.length,
                separatorBuilder: (context, index) => Gap(spacing.s12),
                itemBuilder: (context, index) {
                  final toilet = toilets[index];

                  return _ToiletCard(
                    toilet: toilet,
                    onTap: () => onToiletTap(toilet),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
