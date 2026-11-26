part of '../view/leave_requests_page.dart';

class _LeaveRequestsBody extends StatelessWidget {
  const _LeaveRequestsBody({
    required this.padding,
    required this.searchController,
    required this.selectedFilter,
    required this.filters,
    required this.filtersLoading,
    required this.currentTab,
    required this.onFilterSelected,
    required this.onSearchChanged,
    required this.leaveRequestsState,
    required this.scrollController,
    required this.hasMore,
    required this.summaryState,
    required this.onRetry,
  });

  final EdgeInsetsGeometry padding;
  final TextEditingController searchController;
  final LeaveFilter selectedFilter;
  final List<LeaveFilter> filters;

  /// True while the approver groups the chips depend on are still loading.
  final bool filtersLoading;
  final LeaveTab currentTab;
  final ValueChanged<LeaveFilter> onFilterSelected;
  final VoidCallback onSearchChanged;
  final AsyncValue<List<LeaveRequestEntity>> leaveRequestsState;
  final ScrollController scrollController;
  final bool hasMore;

  /// Null outside the approvals tab, where the summary is not fetched.
  final AsyncValue<LeaveSummaryEntity>? summaryState;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (currentTab == LeaveTab.leaveApprovals)
          Padding(
            padding: padding,
            child: (summaryState ?? const AsyncValue<LeaveSummaryEntity>.loading()).when(
              data: (summary) => _LeaveSupervisorSummaryCard(summary: summary),
              loading: () => const LeaveSupervisorSummaryCardShimmer(),
              error: (err, stack) => const SizedBox.shrink(),
            ),
          ),
        if (currentTab == LeaveTab.leaveApprovals)
          Padding(
            padding: padding,
            child: AppTextField.search(
              controller: searchController,
              hint: context.locale.search,
              onChanged: (_) => onSearchChanged(),
            ),
          ),
        Padding(
          padding: padding,
          child: filtersLoading
              ? const CategoryFilterChipsShimmer()
              : CategoryFilterChips<LeaveFilter>(
                  categories: filters,
                  selectedCategory: selectedFilter,
                  onSelected: onFilterSelected,
                  labelBuilder: (context, filter) {
                    final group = filter.label;
                    if (group != null) {
                      return '${context.locale.pending} · $group';
                    }

                    return switch (filter.status) {
                      'pending' ||
                      'pending_supervisor' => context.locale.pending,
                      'pending_manager' => context.locale.managerApproval,
                      'approved' => context.locale.approved,
                      'rejected' => context.locale.rejected,
                      'cancelled' => context.locale.cancelled,
                      _ => context.locale.all,
                    };
                  },
                ),
        ),
        Expanded(
          child: leaveRequestsState.when(
            loading: () => _LeaveRequestListShimmer(
              showActionButtons: !selectedFilter.isFinal,
            ),
            error: (err, _) => AppErrorWidget(
              message: err.localizedMessage(context),
              onRetry: onRetry,
            ),
            data: (requests) => _LeaveRequestsList(
              requests: requests,
              scrollController: scrollController,
              hasMore: hasMore,
              searchQuery: searchController.text.trim().toLowerCase(),
            ),
          ),
        ),
      ],
    );
  }
}
