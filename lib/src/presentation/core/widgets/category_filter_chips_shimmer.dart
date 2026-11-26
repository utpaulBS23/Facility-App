import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../theme/theme.dart';

/// Skeleton of [CategoryFilterChips], shown while the chips' labels are still
/// loading. Same track height and shape, so the row does not jump on load.
class CategoryFilterChipsShimmer extends StatelessWidget {
  const CategoryFilterChipsShimmer({super.key, this.chipCount = 4});

  final int chipCount;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    return Container(
      height: spacing.s40,
      padding: EdgeInsets.all(spacing.s4),
      decoration: BoxDecoration(
        color: color.borderSubtle,
        borderRadius: BorderRadius.circular(radius.r20),
      ),
      child: Shimmer.fromColors(
        baseColor: color.scaffoldBackground,
        highlightColor: color.onPrimary,
        child: Row(
          children: [
            for (var i = 0; i < chipCount; i++) ...[
              if (i > 0) SizedBox(width: spacing.s8),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: color.scaffoldBackground,
                    borderRadius: BorderRadius.circular(radius.r20),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
