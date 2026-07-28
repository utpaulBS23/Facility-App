import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

/// Base shimmer container wrapper using design system tokens.
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  final double width;
  final double height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: context.color.borderSubtle,
        borderRadius: borderRadius ??
            BorderRadius.circular(context.dimensions.radius.r4),
      ),
    );
  }
}
