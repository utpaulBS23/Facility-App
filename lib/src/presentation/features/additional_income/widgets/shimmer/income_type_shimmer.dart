part of '../../view/add_additional_income_page.dart';

/// Shimmer skeleton matching [_MasterDataOptionSelector]'s chip row.
class _IncomeTypeShimmer extends StatelessWidget {
  const _IncomeTypeShimmer();

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Shimmer.fromColors(
      baseColor: context.color.borderSubtle,
      highlightColor: context.color.scaffoldBackground,
      child: Wrap(
        spacing: spacing.s12,
        runSpacing: spacing.s12,
        children: [
          for (var i = 0; i < 4; i++)
            ShimmerBox(
              width: (MediaQuery.sizeOf(context).width - spacing.s16 * 2 - spacing.s12) / 2,
              height: spacing.s44,
              borderRadius: BorderRadius.circular(radius.r12),
            ),
        ],
      ),
    );
  }
}
