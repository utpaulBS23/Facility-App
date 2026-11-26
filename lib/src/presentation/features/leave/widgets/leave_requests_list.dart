part of '../view/leave_requests_page.dart';

class _LeaveRequestsList extends StatelessWidget {
  const _LeaveRequestsList({
    required this.requests,
    required this.scrollController,
    required this.hasMore,
    required this.searchQuery,
  });

  final List<LeaveRequestEntity> requests;
  final ScrollController scrollController;
  final bool hasMore;
  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    final filtered = requests.where((r) {
      final name = (r.applicant?.name ?? r.leavePolicy.name).toLowerCase();
      // WHY no status check here: the server already filtered by status and
      // waiting_for, and a request waiting on e.g. HR has no status of its own.
      return searchQuery.isEmpty || name.contains(searchQuery);
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
      controller: scrollController,
      padding: EdgeInsets.all(context.dimensions.spacing.s16),
      itemCount: filtered.length + (hasMore ? 1 : 0),
      separatorBuilder: (context, index) => Gap(context.dimensions.spacing.s12),
      itemBuilder: (context, index) {
        if (index >= filtered.length) {
          return Padding(
            padding: EdgeInsets.symmetric(
              vertical: context.dimensions.spacing.s16,
            ),
            child: const Center(child: CircularProgressIndicator()),
          );
        }
        final request = filtered[index];

        return _LeaveRequestActionCard(
          leaveRequest: request,
          onTap: () => context.pushNamed(
            Routes.leaveDetails,
            pathParameters: {'id': request.id.toString()},
          ),
        );
      },
    );
  }
}
