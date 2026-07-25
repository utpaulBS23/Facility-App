part of '../../view/apply_leave_page.dart';

/// Reusable stat tile shimmer preserving background colors.
class _StatTileShimmer extends StatelessWidget {
  const _StatTileShimmer({
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
            _ShimmerBox(width: valueWidth, height: 16),
            Gap(spacing.s4),
            _ShimmerBox(width: labelWidth, height: 16),
          ],
        ),
      ),
    );
  }
}

/// Shimmer skeleton matching [_LeaveSummaryCard] (Leave Balance & Pending tiles).
class _LeaveSummaryCardShimmer extends StatelessWidget {
  const _LeaveSummaryCardShimmer();

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
            child: _StatTileShimmer(
              backgroundColor: color.successAlt,
              valueWidth: 36,
              labelWidth: 80,
            ),
          ),
          Gap(spacing.s6),
          Expanded(
            child: _StatTileShimmer(
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
class _LeaveSupervisorSummaryCardShimmer extends StatelessWidget {
  const _LeaveSupervisorSummaryCardShimmer();

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
            child: _StatTileShimmer(
              backgroundColor: color.warningAlt,
              valueWidth: 28,
              labelWidth: 60,
            ),
          ),
          Gap(spacing.s6),
          Expanded(
            child: _StatTileShimmer(
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
