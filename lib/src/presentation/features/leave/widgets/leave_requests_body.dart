part of '../view/leave_requests_page.dart';

class _LeaveRequestsBody extends StatelessWidget {
  const _LeaveRequestsBody({
    required this.padding,
    required this.searchController,
    required this.selectedFilter,
    required this.currentTab,
    required this.onFilterSelected,
    required this.onSearchChanged,
    required this.leaveRequestsState,
    required this.onRetry,
  });

  final EdgeInsetsGeometry padding;
  final TextEditingController searchController;
  final LeaveFilter selectedFilter;
  final LeaveTab currentTab;
  final ValueChanged<LeaveFilter> onFilterSelected;
  final VoidCallback onSearchChanged;
  final AsyncValue<List<LeaveRequestEntity>> leaveRequestsState;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (currentTab == LeaveTab.leaveApprovals)
          Padding(
            padding: padding,
            child: leaveRequestsState.when(
              data: (requests) => _LeaveSupervisorSummaryCard(
                pendingCount: requests
                    .where((request) => request.status == LeaveStatus.pendingSupervisor)
                    .length,
                managerCount: requests
                    .where((request) => request.status == LeaveStatus.pendingManager)
                    .length,
              ),
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
          child: CategoryFilterChips<LeaveFilter>(
            categories: LeaveFilter.values,
            selectedCategory: selectedFilter,
            onSelected: onFilterSelected,
            labelBuilder: (context, filter) => switch (filter) {
              LeaveFilter.all => context.locale.all,
              LeaveFilter.pendingSupervisor => context.locale.pending,
              LeaveFilter.pendingManager => context.locale.managerApproval,
              LeaveFilter.approved => context.locale.approved,
              LeaveFilter.rejected => context.locale.rejected,
            },
          ),
        ),
        Expanded(
          child: leaveRequestsState.when(
            loading: () => _LeaveRequestListShimmer(
              showActionButtons: selectedFilter != LeaveFilter.approved &&
                  selectedFilter != LeaveFilter.rejected,
            ),
            error: (err, _) => AppErrorWidget(
              message: err.localizedMessage(context),
              onRetry: onRetry,
            ),
            data: (requests) => _LeaveRequestsList(
              requests: requests,
              selectedFilter: selectedFilter,
              searchQuery: searchController.text.trim().toLowerCase(),
            ),
          ),
        ),
      ],
    );
  }
}
