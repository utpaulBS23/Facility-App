import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/theme.dart';
import 'shimmer_box.dart';

/// Reusable stat tile shimmer preserving background colors.
class StatTileShimmer extends StatelessWidget {
  const StatTileShimmer({
    super.key,
    required this.backgroundColor,
    required this.valueWidth,
    required this.labelWidth,
  });

  final Color backgroundColor;
  final double valueWidth;
  final double labelWidth;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;

    return Container(
      padding: EdgeInsets.all(spacing.s12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r10),
      ),
      child: Shimmer.fromColors(
        baseColor: color.borderSubtle,
        highlightColor: color.scaffoldBackground,
        child: Column(
          children: [
            ShimmerBox(width: valueWidth, height: 16),
            Gap(spacing.s4),
            ShimmerBox(width: labelWidth, height: 16),
          ],
        ),
      ),
    );
  }
}

/// Shimmer skeleton matching [_LeaveSummaryCard] (Leave Balance & Pending tiles).
class LeaveSummaryCardShimmer extends StatelessWidget {
  const LeaveSummaryCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;

    return Container(
      padding: EdgeInsets.all(spacing.s8),
      decoration: BoxDecoration(
        color: color.onPrimary,
        border: Border.all(color: color.borderSubtle),
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
      ),
      child: Row(
        children: [
          Expanded(
            child: StatTileShimmer(
              backgroundColor: color.successAlt,
              valueWidth: 36,
              labelWidth: 80,
            ),
          ),
          Gap(spacing.s6),
          Expanded(
            child: StatTileShimmer(
              backgroundColor: color.warningAlt,
              valueWidth: 36,
              labelWidth: 60,
            ),
          ),
        ],
      ),
    );
  }
}

/// Shimmer skeleton matching [_LeaveSupervisorSummaryCard] (Pending & Manager Approval tiles).
class LeaveSupervisorSummaryCardShimmer extends StatelessWidget {
  const LeaveSupervisorSummaryCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;

    return Container(
      padding: EdgeInsets.all(spacing.s8),
      decoration: BoxDecoration(
        color: color.onPrimary,
        border: Border.all(color: color.borderSubtle),
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
      ),
      child: Row(
        children: [
          Expanded(
            child: StatTileShimmer(
              backgroundColor: color.warningAlt,
              valueWidth: 28,
              labelWidth: 60,
            ),
          ),
          Gap(spacing.s6),
          Expanded(
            child: StatTileShimmer(
              backgroundColor: color.info.withValues(alpha: 0.1),
              valueWidth: 28,
              labelWidth: 100,
            ),
          ),
        ],
      ),
    );
  }
}
