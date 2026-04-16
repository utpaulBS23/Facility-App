import 'package:flutter/material.dart';

import '../../theme/theme.dart';

part 'parts/typography_display.dart';
part 'parts/typography_headline.dart';
part 'parts/typography_title.dart';
part 'parts/typography_title_small.dart';
part 'parts/typography_body.dart';
part 'parts/typography_label.dart';
part 'parts/typography_label_small.dart';

// WHY: One widget class per Figma type token so call sites self-document
// the intended semantic role without consulting the design spec.
// Naming mirrors the Figma token names (node 13021:15735) in PascalCase.
// Uppercase variants call .toUpperCase() internally so callers don't need to.
abstract class _Typography extends StatelessWidget {
  const _Typography(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.textDirection,
    this.semanticsLabel,
  });

  final String text;

  // WHY: optional color override — defaults to context.color.text.primary
  // inside each subclass, avoiding a hard dependency in the base.
  final Color? color;

  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final TextDirection? textDirection;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context);
}
