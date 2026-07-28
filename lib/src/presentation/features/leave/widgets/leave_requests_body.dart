part of '../view/leave_requests_page.dart';

class _LeaveRequestsBody extends StatelessWidget {
  const _LeaveRequestsBody({
    required this.padding,
    required this.searchController,
    required this.selectedFilter,
    required this.onFilterSelected,
    required this.summary,
    required this.list,
  });

  final EdgeInsetsGeometry padding;
  final TextEditingController searchController;
  final String selectedFilter;
  final ValueChanged<String> onFilterSelected;
  final Widget summary;
  final Widget list;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(padding: padding, child: summary),
        Padding(
          padding: padding,
          child: AppTextField.search(
            controller: searchController,
            hint: context.locale.search,
          ),
        ),
        Padding(
          padding: padding,
          child: _LeaveFilterBar(
            filters: _kLeaveFilters,
            selectedFilter: selectedFilter,
            onFilterSelected: onFilterSelected,
          ),
        ),
        Expanded(child: list),
      ],
    );
  }
}
