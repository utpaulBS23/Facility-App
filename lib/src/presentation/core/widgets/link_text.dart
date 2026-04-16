import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Inline text with a tappable link segment.
///
/// Renders [text] in secondary color followed by [linkText] in primary text
/// color. The entire row is wrapped in a [TextButton] so [onTap] fires on
/// any tap within the widget bounds.
class LinkText extends StatelessWidget {
  const LinkText({
    super.key,
    required this.text,
    required this.linkText,
    required this.onTap,
  });

  final VoidCallback? onTap;
  final String text;
  final String linkText;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: TextButton(
        onPressed: onTap,
        child: Text.rich(
          TextSpan(
            text: text,
            style: context.textStyle.labelMedium.copyWith(
              color: context.color.text.secondary,
            ),
            children: [
              TextSpan(
                text: linkText,
                style: context.textStyle.labelMedium.copyWith(
                  color: context.color.text.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
