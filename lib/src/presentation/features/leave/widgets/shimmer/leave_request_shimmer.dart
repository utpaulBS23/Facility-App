part of '../../view/leave_requests_page.dart';

/// Shimmer skeleton matching [_LeaveRequestActionCard].
class _LeaveRequestCardShimmer extends StatelessWidget {
  const _LeaveRequestCardShimmer({this.showActionButtons = true});

  final bool showActionButtons;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final radius = context.dimensions.radius;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        borderRadius: BorderRadius.circular(radius.r12),
        border: Border.all(color: color.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const ShimmerBox(width: 140, height: 20),
              ShimmerBox(
                width: 76,
                height: 22,
                borderRadius: BorderRadius.circular(radius.r20),
              ),
            ],
          ),
          Gap(spacing.s8),
          const ShimmerBox(width: 200, height: 18),
          if (showActionButtons) ...[
            Gap(spacing.s12),
            Divider(color: color.borderSubtle, height: 1),
            Gap(spacing.s12),
            Row(
              children: [
                Expanded(
                  child: ShimmerBox(
                    width: double.infinity,
                    height: 44,
                    borderRadius: BorderRadius.circular(radius.r10),
                  ),
                ),
                Gap(spacing.s12),
                Expanded(
                  child: ShimmerBox(
                    width: double.infinity,
                    height: 44,
                    borderRadius: BorderRadius.circular(radius.r10),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// List of shimmer skeletons matching [_LeaveRequestActionCard].
class _LeaveRequestListShimmer extends StatelessWidget {
  const _LeaveRequestListShimmer({this.showActionButtons = true});

  final bool showActionButtons;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Shimmer.fromColors(
      baseColor: context.color.borderSubtle,
      highlightColor: context.color.scaffoldBackground,
      child: ListView.separated(
        padding: EdgeInsets.all(spacing.s16),
        itemCount: 5,
        separatorBuilder: (_, _) => Gap(spacing.s12),
        itemBuilder: (_, _) =>
            _LeaveRequestCardShimmer(showActionButtons: showActionButtons),
      ),
    );
  }
}
