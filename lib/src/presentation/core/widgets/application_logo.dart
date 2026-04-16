import 'package:flutter/material.dart';

import '../gen/assets.gen.dart';

/// App logo image widget.
///
/// Renders `bhumijoLogo` at the given [height] (defaults to 160 px).
/// Pass [semanticLabel] to make the logo visible to screen readers.
class ApplicationLogo extends StatelessWidget {
  const ApplicationLogo({
    super.key,
    this.height = 160,
    this.width,
    this.fit = BoxFit.contain,
    this.color,
    this.semanticLabel,
  });

  final double height;
  final double? width;
  final BoxFit fit;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Image(
      excludeFromSemantics: semanticLabel == null,
      image: Assets.images.bhumijoLogo.provider(),
      height: height,
      width: width,
      fit: fit,
      color: color,
      semanticLabel: semanticLabel,
      filterQuality: FilterQuality.high,
    );
  }
}
