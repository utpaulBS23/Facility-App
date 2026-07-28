part of '../../view/select_attendant_page.dart';

/// Shimmer skeleton matching [_SelectableAttendantCard].
class _AttendantCardShimmer extends StatelessWidget {
  const _AttendantCardShimmer();

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final radius = context.dimensions.radius;

    return Container(
      padding: EdgeInsets.all(spacing.s12),
      decoration: BoxDecoration(
        color: color.onPrimary,
        borderRadius: BorderRadius.circular(radius.r12),
        border: Border.all(color: color.borderSubtle),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(
            width: 40,
            height: 40,
            borderRadius: BorderRadius.circular(20),
          ),
          Gap(spacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerBox(width: 120, height: 16),
                Gap(spacing.s6),
                const ShimmerBox(width: 80, height: 14),
                Gap(spacing.s6),
                const ShimmerBox(width: 140, height: 14),
              ],
            ),
          ),
          ShimmerBox(
            width: 90,
            height: 24,
            borderRadius: BorderRadius.circular(radius.r20),
          ),
        ],
      ),
    );
  }
}

/// List of shimmer skeletons matching [_SelectableAttendantCard].
class _AttendantListShimmer extends StatelessWidget {
  const _AttendantListShimmer();

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
        itemBuilder: (_, _) => const _AttendantCardShimmer(),
      ),
    );
  }
}
