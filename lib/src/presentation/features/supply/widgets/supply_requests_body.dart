part of '../view/supply_requests_page.dart';

class _SupplyRequestsBody extends StatelessWidget {
  const _SupplyRequestsBody({
    required this.summaryAsync,
    required this.selectedFilter,
    required this.filters,
    required this.filtersLoading,
    required this.filteredRequestsAsync,
    required this.onFilterSelected,
    required this.onRequestTap,
    required this.onRetry,
  });

  final AsyncValue<SupplyRequestSummaryEntity> summaryAsync;
  final SupplyFilter selectedFilter;
  final List<SupplyFilter> filters;

  /// True while the approver groups the chips depend on are still loading.
  final bool filtersLoading;
  final AsyncValue<PaginatedListEntity<SupplyRequestEntity>> filteredRequestsAsync;
  final ValueChanged<SupplyFilter> onFilterSelected;
  final ValueChanged<SupplyRequestEntity> onRequestTap;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final approvedCount = summaryAsync.valueOrNull?.approved ?? 0;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            spacing.s16,
            spacing.s16,
            spacing.s16,
            spacing.s16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              switch (summaryAsync) {
                AsyncData(:final value) => _SupplySummaryRow(summary: value),
                _ => const _SupplySummaryRowShimmer(),
              },
              Gap(spacing.s16),
              if (filtersLoading)
                const CategoryFilterChipsShimmer()
              else
                CategoryFilterChips<SupplyFilter>(
                  categories: filters,
                  selectedCategory: selectedFilter,
                  onSelected: onFilterSelected,
                  labelBuilder: (context, filter) =>
                      _getFilterLabel(context, filter),
                ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async => onRetry(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                spacing.s16,
                0,
                spacing.s16,
                spacing.s16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (approvedCount > 0) ...[
                    PendingDeliveryAlert(
                      count: approvedCount,
                      onTap: () => onFilterSelected(
                        SupplyFilter.operationManagerApproved,
                      ),
                    ),
                    Gap(spacing.s16),
                  ],
                  _SupplyRequestsListSection(
                    requestsAsync: filteredRequestsAsync,
                    onRequestTap: onRequestTap,
                    onRetry: onRetry,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getFilterLabel(BuildContext context, SupplyFilter filter) {
    final group = filter.label;
    if (group != null) return '${context.locale.pending} · $group';

    return switch (filter.status) {
      'pending' => context.locale.pending,
      'operation_manager_approved' => context.locale.operationManagerApproved,
      'in_delivery' => context.locale.inDelivery,
      'delivered' => context.locale.delivered,
      'rejected' => context.locale.rejected,
      'completed' => context.locale.completed,
      _ => context.locale.all,
    };
  }
}
