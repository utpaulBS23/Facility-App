import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';

/// A bordered box with a small caption over its value, the look of every
/// selector on the report.
class _SelectShell extends StatelessWidget {
  const _SelectShell({required this.caption, required this.child});

  final String caption;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.color;
    final spacing = context.dimensions.spacing;
    final radius = BorderRadius.circular(context.dimensions.radius.r12);

    return Material(
      color: c.onPrimary,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        child: Container(
          constraints: const BoxConstraints(minHeight: 56),
          padding: EdgeInsets.symmetric(
            horizontal: spacing.s12,
            vertical: spacing.s8,
          ),
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: c.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                caption,
                style: context.textStyle.bodySmall.copyWith(
                  color: c.text.secondary,
                ),
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

/// The toilet being reported, shown with a building icon and a chevron.
class ReportToiletSelector extends StatelessWidget {
  const ReportToiletSelector({
    super.key,
    required this.caption,
    required this.name,
    this.onTap,
  });

  final String caption;
  final String name;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.color;
    final spacing = context.dimensions.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          caption,
          style: context.textStyle.bodySmall.copyWith(color: c.text.secondary),
        ),
        SizedBox(height: spacing.s8),
        Material(
          color: c.onPrimary,
          borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
            child: Container(
              constraints: const BoxConstraints(minHeight: 48),
              padding: EdgeInsets.symmetric(horizontal: spacing.s12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  context.dimensions.radius.r12,
                ),
                border: Border.all(color: c.border),
              ),
              child: Row(
                children: [
                  Icon(Icons.domain_rounded, size: 20, color: c.primary),
                  SizedBox(width: spacing.s8),
                  Expanded(
                    child: Text(
                      name,
                      style: context.textStyle.labelLarge.copyWith(
                        color: c.text.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: c.text.secondary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// A captioned dropdown, for the month and the year.
class ReportDropdown<T> extends StatelessWidget {
  const ReportDropdown({
    super.key,
    required this.caption,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String caption;
  final T value;

  /// Value to its display label.
  final Map<T, String> items;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.color;

    return _SelectShell(
      caption: caption,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          isDense: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: c.text.primary),
          style: context.textStyle.labelLarge.copyWith(
            color: c.text.primary,
            fontWeight: FontWeight.w700,
          ),
          items: [
            for (final e in items.entries)
              DropdownMenuItem<T>(value: e.key, child: Text(e.value)),
          ],
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}

/// The white card that holds the toilet selector and the month and year.
class ReportFilterCard extends StatelessWidget {
  const ReportFilterCard({
    super.key,
    required this.toilet,
    required this.month,
    required this.year,
  });

  final Widget toilet;
  final Widget month;
  final Widget year;

  @override
  Widget build(BuildContext context) {
    final c = context.color;
    final spacing = context.dimensions.spacing;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: c.onPrimary,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r16),
        border: Border.all(color: c.borderSubtle),
      ),
      child: Column(
        children: [
          toilet,
          SizedBox(height: spacing.s12),
          Row(
            children: [
              Expanded(child: month),
              SizedBox(width: spacing.s12),
              Expanded(child: year),
            ],
          ),
        ],
      ),
    );
  }
}
