part of '../view/supply_requests_page.dart';

class _SupplyRequestsBody extends StatelessWidget {
  const _SupplyRequestsBody({
    required this.summaryAsync,
    required this.selectedFilter,
    required this.filteredRequestsAsync,
    required this.onFilterSelected,
    required this.onRequestTap,
    required this.onRetry,
  });

  final AsyncValue<SupplyRequestSummaryEntity> summaryAsync;
  final SupplyFilter selectedFilter;
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
              CategoryFilterChips<SupplyFilter>(
                categories: SupplyFilter.values,
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
    return switch (filter) {
      SupplyFilter.all => context.locale.all,
      SupplyFilter.pendingSupervisor => context.locale.pendingSupervisor,
      SupplyFilter.pendingOperationManager =>
        context.locale.pendingOperationManager,
      SupplyFilter.operationManagerApproved =>
        context.locale.operationManagerApproved,
      SupplyFilter.inDelivery => context.locale.inDelivery,
      SupplyFilter.delivered => context.locale.delivered,
      SupplyFilter.rejected => context.locale.rejected,
      SupplyFilter.completed => context.locale.completed,
    };
  }
}
