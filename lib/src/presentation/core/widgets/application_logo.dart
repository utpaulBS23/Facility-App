import 'package:flutter/material.dart';

import '../gen/assets.gen.dart';

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
    return Image.asset(Assets.icons.call.path);
  }
}
