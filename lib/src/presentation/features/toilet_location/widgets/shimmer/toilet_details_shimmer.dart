part of '../../view/toilet_details_page.dart';

/// Shimmer skeleton matching [_ToiletStatusBanner].
class _ToiletStatusBannerShimmer extends StatelessWidget {
  const _ToiletStatusBannerShimmer();

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final radius = context.dimensions.radius;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.s16,
        vertical: spacing.s10,
      ),
      decoration: BoxDecoration(
        color: color.borderSubtle,
        borderRadius: BorderRadius.circular(radius.r10),
      ),
      child: Shimmer.fromColors(
        baseColor: color.borderSubtle,
        highlightColor: color.scaffoldBackground,
        child: ShimmerBox(width: spacing.s66, height: spacing.s14),
      ),
    );
  }
}

/// Shimmer skeleton matching [_ToiletDetailHeaderCard].
class _ToiletDetailHeaderCardShimmer extends StatelessWidget {
  const _ToiletDetailHeaderCardShimmer();

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
      child: Shimmer.fromColors(
        baseColor: color.borderSubtle,
        highlightColor: color.scaffoldBackground,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerBox(
              width: spacing.s40,
              height: spacing.s40,
              borderRadius: BorderRadius.circular(radius.r10),
            ),
            Gap(spacing.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(width: spacing.s180, height: spacing.s20),
                  Gap(spacing.s6),
                  ShimmerBox(width: spacing.s66, height: spacing.s14),
                  Gap(spacing.s6),
                  ShimmerBox(width: spacing.s200, height: spacing.s14),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer skeleton matching [_ToiletDetailStatsCard] / [_StatBox].
class _ToiletDetailStatsCardShimmer extends StatelessWidget {
  const _ToiletDetailStatsCardShimmer();

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: _StatBoxShimmer()),
            Gap(spacing.s12),
            const Expanded(child: _StatBoxShimmer()),
          ],
        ),
        Gap(spacing.s12),
        Row(
          children: [
            const Expanded(child: _StatBoxShimmer()),
            Gap(spacing.s12),
            const Expanded(child: _StatBoxShimmer()),
            Gap(spacing.s12),
            const Expanded(child: _StatBoxShimmer()),
          ],
        ),
      ],
    );
  }
}

class _StatBoxShimmer extends StatelessWidget {
  const _StatBoxShimmer();

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final radius = context.dimensions.radius;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacing.s12),
      decoration: BoxDecoration(
        color: color.onPrimary,
        border: Border.all(color: color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r10),
      ),
      child: Shimmer.fromColors(
        baseColor: color.borderSubtle,
        highlightColor: color.scaffoldBackground,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ShimmerBox(width: spacing.s66, height: spacing.s20),
            Gap(spacing.s2),
            ShimmerBox(width: spacing.s80, height: spacing.s14),
          ],
        ),
      ),
    );
  }
}

/// Shimmer skeleton matching [_ToiletTargetCard].
class _ToiletTargetCardShimmer extends StatelessWidget {
  const _ToiletTargetCardShimmer();

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final radius = context.dimensions.radius;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        border: Border.all(color: color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Shimmer.fromColors(
        baseColor: color.borderSubtle,
        highlightColor: color.scaffoldBackground,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerBox(width: spacing.s120, height: spacing.s20),
            Gap(spacing.s12),
            ShimmerBox(width: spacing.s100, height: spacing.s20),
            Gap(spacing.s8),
            ShimmerBox(
              width: double.infinity,
              height: spacing.s8,
              borderRadius: BorderRadius.circular(radius.r4),
            ),
            Gap(spacing.s6),
            ShimmerBox(width: spacing.s100, height: spacing.s14),
          ],
        ),
      ),
    );
  }
}

/// Shimmer skeleton matching [_ToiletSupervisorCard].
class _ToiletSupervisorCardShimmer extends StatelessWidget {
  const _ToiletSupervisorCardShimmer();

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final radius = context.dimensions.radius;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        border: Border.all(color: color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Shimmer.fromColors(
        baseColor: color.borderSubtle,
        highlightColor: color.scaffoldBackground,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerBox(width: spacing.s120, height: spacing.s20),
            Gap(spacing.s12),
            Divider(color: color.borderSubtle, height: 1),
            Gap(spacing.s12),
            Row(
              children: [
                ShimmerBox(
                  width: spacing.s40,
                  height: spacing.s40,
                  borderRadius: BorderRadius.circular(radius.r10),
                ),
                Gap(spacing.s12),
                ShimmerBox(width: spacing.s100, height: spacing.s14),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Full-page shimmer composed of each card's own skeleton.
class _ToiletDetailsShimmer extends StatelessWidget {
  const _ToiletDetailsShimmer();

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return SingleChildScrollView(
      padding: EdgeInsets.all(spacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _ToiletStatusBannerShimmer(),
          Gap(spacing.s12),
          const _ToiletDetailHeaderCardShimmer(),
          Gap(spacing.s12),
          const _ToiletDetailStatsCardShimmer(),
          Gap(spacing.s12),
          const _ToiletTargetCardShimmer(),
          Gap(spacing.s12),
          const _ToiletSupervisorCardShimmer(),
        ],
      ),
    );
  }
}
