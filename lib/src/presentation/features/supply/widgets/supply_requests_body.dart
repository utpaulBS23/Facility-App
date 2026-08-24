part of '../view/supply_requests_page.dart';

class _SupplyRequestsBody extends StatelessWidget {
  const _SupplyRequestsBody({
    required this.summaryAsync,
    required this.selectedFilter,
    required this.filteredRequestsAsync,
    required this.onFilterSelected,
    required this.onNewRequest,
    required this.onRequestTap,
    required this.onRetry,
  });

  final AsyncValue<SupplyRequestSummaryEntity> summaryAsync;
  final SupplyFilter selectedFilter;
  final AsyncValue<PaginatedListEntity<SupplyRequestEntity>> filteredRequestsAsync;
  final ValueChanged<SupplyFilter> onFilterSelected;
  final VoidCallback onNewRequest;
  final ValueChanged<SupplyRequestEntity> onRequestTap;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final approvedCount = int.tryParse(summaryAsync.valueOrNull?.approved ?? '') ?? 0;

    return RefreshIndicator(
      onRefresh: () async => onRetry(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(spacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            switch (summaryAsync) {
              AsyncData(:final value) => _SupplySummaryRow(summary: value),
              _ => const _SupplySummaryRowShimmer(),
            },
            Gap(spacing.s16),
            if (approvedCount > 0) ...[
              PendingDeliveryAlert(
                count: approvedCount,
                onTap: () =>
                    onFilterSelected(SupplyFilter.operationManagerApproved),
              ),
              Gap(spacing.s16),
            ],
            PermissionGate(
              permissions: const [UserPermission.supplyRequestCreate],
              child: Padding(
                padding: EdgeInsets.only(bottom: spacing.s16),
                child: SizedBox(
                  width: double.infinity,
                  height: spacing.s44,
                  child: FilledButton.icon(
                    onPressed: onNewRequest,
                    icon: const Icon(Icons.add_rounded),
                    label: Text(context.locale.newRequest),
                  ),
                ),
              ),
            ),
            CategoryFilterChips<SupplyFilter>(
              categories: SupplyFilter.values,
              selectedCategory: selectedFilter,
              onSelected: onFilterSelected,
              labelBuilder: (context, filter) => _getFilterLabel(context, filter),
            ),
            Gap(spacing.s16),
            _SupplyRequestsListSection(
              requestsAsync: filteredRequestsAsync,
              onRequestTap: onRequestTap,
              onRetry: onRetry,
            ),
          ],
        ),
      ),
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
    };
  }
}
