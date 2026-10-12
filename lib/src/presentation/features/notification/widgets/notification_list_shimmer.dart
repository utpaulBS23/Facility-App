import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/theme/theme.dart';
import '../../supply/widgets/shimmer/shimmer_box.dart';

/// Skeleton of the inbox rows, shown while the list loads. Only the cards
/// shimmer; the filter chips above them stay put.
class NotificationListShimmer extends StatelessWidget {
  const NotificationListShimmer({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Shimmer.fromColors(
      baseColor: context.color.borderSubtle,
      highlightColor: context.color.scaffoldBackground,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          spacing.s16,
          spacing.s4,
          spacing.s16,
          spacing.s16,
        ),
        itemCount: itemCount,
        separatorBuilder: (_, _) => Gap(spacing.s12),
        itemBuilder: (_, _) => const _NotificationCardShimmer(),
      ),
    );
  }
}

/// Matches the size of one inbox card: icon tile, title with time, two lines
/// of body.
class _NotificationCardShimmer extends StatelessWidget {
  const _NotificationCardShimmer();

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;

    return Container(
      padding: EdgeInsets.all(spacing.s12),
      decoration: BoxDecoration(
        color: color.onPrimary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.borderSubtle),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(
            width: 36,
            height: 36,
            borderRadius: BorderRadius.circular(context.dimensions.radius.r10),
          ),
          Gap(spacing.s10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: ShimmerBox(width: double.infinity, height: 14),
                    ),
                    Gap(spacing.s8),
                    ShimmerBox(width: spacing.s40, height: 12),
                  ],
                ),
                Gap(spacing.s8),
                const ShimmerBox(width: double.infinity, height: 12),
                Gap(spacing.s6),
                ShimmerBox(width: spacing.s120, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
