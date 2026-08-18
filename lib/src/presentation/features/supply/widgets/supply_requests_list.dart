part of '../view/supply_requests_page.dart';

class _SupplyRequestsListSection extends StatelessWidget {
  const _SupplyRequestsListSection({
    required this.requestsAsync,
    required this.onRequestTap,
    required this.onRetry,
  });

  final AsyncValue<PaginatedListEntity<SupplyRequestEntity>> requestsAsync;
  final ValueChanged<SupplyRequestEntity> onRequestTap;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return requestsAsync.when(
      data: (paginated) {
        final requests = paginated.items;
        if (requests.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: spacing.s32),
              child: Text(
                context.locale.noSupplyRequestsFound,
                style: context.textStyle.bodyMedium.copyWith(
                  color: context.color.text.secondary,
                ),
              ),
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: requests.length,
          separatorBuilder: (context, index) => Gap(spacing.s12),
          itemBuilder: (context, index) {
            final req = requests[index];

            return _SupplyRequestListCard(
              request: req,
              onTap: () => onRequestTap(req),
            );
          },
        );
      },
      loading: () => const _SupplyRequestListShimmer(),
      error: (err, _) => AppErrorWidget(
        message: err.localizedMessage(context),
        onRetry: onRetry,
      ),
    );
  }
}
