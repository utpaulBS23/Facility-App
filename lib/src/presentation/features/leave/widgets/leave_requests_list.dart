part of '../view/leave_requests_page.dart';

class _LeaveRequestsList extends StatelessWidget {
  const _LeaveRequestsList({
    required this.requests,
    required this.selectedFilter,
    required this.searchQuery,
  });

  final List<LeaveRequestEntity> requests;
  final LeaveFilter selectedFilter;
  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    final filtered = requests.where((r) {
      final name = r.applicant?.name.toLowerCase() ?? '';
      final matchesSearch = searchQuery.isEmpty || name.contains(searchQuery);
      if (!matchesSearch) {
        return false;
      }

      return selectedFilter.matches(r.status);
    }).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Text(
          context.locale.noRequestsFound,
          style: context.textStyle.bodyMedium.copyWith(
            color: context.color.text.secondary,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(context.dimensions.spacing.s16),
      itemCount: filtered.length,
      separatorBuilder: (context, index) => Gap(context.dimensions.spacing.s12),
      itemBuilder: (context, index) {
        final request = filtered[index];

        return _LeaveRequestActionCard(
          request: request,
          onTap: () => context.pushNamed(Routes.leaveDetails, extra: request),
        );
      },
    );
  }
}
