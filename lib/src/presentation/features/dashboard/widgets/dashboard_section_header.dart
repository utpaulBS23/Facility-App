import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

/// Section title with an optional subtitle and a "See all" style link.
class DashboardSectionHeader extends StatelessWidget {
  const DashboardSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final c = context.color;
    final spacing = context.dimensions.spacing;
    final subtitle = this.subtitle;
    final actionLabel = this.actionLabel;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.textStyle.labelXl.copyWith(
                  color: c.text.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (subtitle != null && subtitle.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: spacing.s2),
                  child: Text(
                    subtitle,
                    style: context.textStyle.bodySmall.copyWith(
                      color: c.text.secondary,
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (actionLabel != null)
          InkWell(
            onTap: onAction,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 44),
              child: Center(
                child: Text(
                  '$actionLabel ›',
                  style: context.textStyle.labelMedium12.copyWith(
                    color: c.text.brand,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
