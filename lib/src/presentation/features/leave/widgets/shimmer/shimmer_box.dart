part of '../../view/apply_leave_page.dart';

/// Base shimmer container wrapper using design system tokens.
class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({
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
