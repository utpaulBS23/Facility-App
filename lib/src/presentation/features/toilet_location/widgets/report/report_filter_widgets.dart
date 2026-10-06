import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';

/// A bordered dropdown whose whole box opens the menu.
///
/// WHY the box is the dropdown: a [DropdownButton] only reacts to taps on its
/// own content, so the border and padding sit inside it, via
/// [selectedBuilder], and a tap anywhere on the box opens the list.
class _BoxDropdown<T> extends StatelessWidget {
  const _BoxDropdown({
    required this.value,
    required this.items,
    required this.selectedBuilder,
    required this.onChanged,
    required this.minHeight,
  });

  final T value;

  /// Value to its menu label.
  final Map<T, String> items;
  final Widget Function(BuildContext context, T value) selectedBuilder;
  final ValueChanged<T>? onChanged;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    final c = context.color;
    final spacing = context.dimensions.spacing;
    final radius = BorderRadius.circular(context.dimensions.radius.r12);

    return Container(
      constraints: BoxConstraints(minHeight: minHeight),
      decoration: BoxDecoration(
        color: c.onPrimary,
        borderRadius: radius,
        border: Border.all(color: c.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          itemHeight: minHeight,
          borderRadius: radius,
          padding: EdgeInsets.symmetric(horizontal: spacing.s12),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: onChanged == null ? Colors.transparent : c.text.primary,
          ),
          style: context.textStyle.labelLarge.copyWith(
            color: c.text.primary,
            fontWeight: FontWeight.w700,
          ),
          selectedItemBuilder: (context) => [
            for (final key in items.keys) selectedBuilder(context, key),
          ],
          items: [
            for (final e in items.entries)
              DropdownMenuItem<T>(value: e.key, child: Text(e.value)),
          ],
          onChanged: onChanged == null
              ? null
              : (v) {
                  if (v != null) onChanged!(v);
                },
        ),
      ),
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

    return _BoxDropdown<T>(
      value: value,
      items: items,
      minHeight: 56,
      onChanged: onChanged,
      selectedBuilder: (context, key) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            caption,
            style: context.textStyle.bodySmall.copyWith(
              color: c.text.secondary,
            ),
          ),
          Text(
            items[key] ?? '',
            overflow: TextOverflow.ellipsis,
            style: context.textStyle.labelLarge.copyWith(
              color: c.text.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// The white card that holds the month and year pickers.
class ReportFilterCard extends StatelessWidget {
  const ReportFilterCard({
    super.key,
    required this.title,
    required this.month,
    required this.year,
  });

  final String title;
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.textStyle.labelLarge.copyWith(
              color: c.text.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
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
