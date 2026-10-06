import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';

/// A white card with a bold title, an optional subtitle and an optional
/// trailing text (for example the month), around [child].
class ToiletSectionCard extends StatelessWidget {
  const ToiletSectionCard({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final String? trailing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.color;
    final spacing = context.dimensions.spacing;
    final subtitle = this.subtitle;
    final trailing = this.trailing;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: c.onPrimary,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r16),
        border: Border.all(color: c.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: context.textStyle.labelXl.copyWith(
                    color: c.text.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (trailing != null)
                Text(
                  trailing,
                  style: context.textStyle.bodySmall.copyWith(
                    color: c.text.secondary,
                  ),
                ),
            ],
          ),
          if (subtitle != null)
            Padding(
              padding: EdgeInsets.only(top: spacing.s2),
              child: Text(
                subtitle,
                style: context.textStyle.bodySmall.copyWith(
                  color: c.text.secondary,
                ),
              ),
            ),
          SizedBox(height: spacing.s12),
          child,
        ],
      ),
    );
  }
}

/// Children side by side in equal columns, as tall as the tallest.
class ToiletTileRow extends StatelessWidget {
  const ToiletTileRow({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final gap = context.dimensions.spacing.s10;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(width: gap),
            Expanded(child: children[i]),
          ],
        ],
      ),
    );
  }
}
