part of '../view/leave_requests_page.dart';

class _LeaveRequestsBody extends StatelessWidget {
  const _LeaveRequestsBody({
    required this.padding,
    required this.searchController,
    required this.selectedFilter,
    required this.onFilterSelected,
    required this.onSearchChanged,
    required this.approvalsState,
    required this.onRetry,
  });

  final EdgeInsetsGeometry padding;
  final TextEditingController searchController;
  final LeaveFilter selectedFilter;
  final ValueChanged<LeaveFilter> onFilterSelected;
  final VoidCallback onSearchChanged;
  final AsyncValue<List<LeaveRequestEntity>> approvalsState;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: padding,
          child: approvalsState.when(
            data: (requests) => _LeaveSupervisorSummaryCard(
              pendingCount: requests
                  .where((r) => r.status == LeaveStatus.pendingSupervisor)
                  .length,
              managerCount: requests
                  .where((r) => r.status == LeaveStatus.pendingManager)
                  .length,
            ),
            loading: () => const LeaveSupervisorSummaryCardShimmer(),
            error: (err, stack) => const SizedBox.shrink(),
          ),
        ),
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
            labelBuilder: (context, filter) => filter.localizedName(context),
          ),
        ),
        Expanded(
          child: approvalsState.when(
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
