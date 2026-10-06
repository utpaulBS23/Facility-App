import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

enum DashboardFilterStyle { chips, segmented }

/// A single-choice row: scrolling pill chips, or an even segmented control.
class DashboardFilterChips extends StatelessWidget {
  const DashboardFilterChips({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
    this.style = DashboardFilterStyle.chips,
  });

  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelected;
  final DashboardFilterStyle style;

  @override
  Widget build(BuildContext context) {
    final c = context.color;
    final spacing = context.dimensions.spacing;

    if (style == DashboardFilterStyle.segmented) {
      return Container(
        padding: EdgeInsets.all(spacing.s4),
        decoration: BoxDecoration(
          color: c.subtle,
          borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        ),
        child: Row(
          children: [
            for (final option in options)
              Expanded(
                child: _Segment(
                  label: option,
                  selected: option == selected,
                  onTap: () => onSelected(option),
                ),
              ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(vertical: spacing.s2),
      child: Row(
        children: [
          for (var i = 0; i < options.length; i++) ...[
            if (i > 0) SizedBox(width: spacing.s8),
            _Chip(
              label: options[i],
              selected: options[i] == selected,
              onTap: () => onSelected(options[i]),
            ),
          ],
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.color;

    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          constraints: const BoxConstraints(minHeight: 44),
          padding: EdgeInsets.symmetric(
            horizontal: context.dimensions.spacing.s16,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? c.primary : c.onPrimary,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: selected ? c.primary : c.border),
          ),
          child: Text(
            label,
            style: context.textStyle.labelMedium12.copyWith(
              color: selected ? c.onPrimary : c.text.primary,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.color;
    final radius = BorderRadius.circular(context.dimensions.radius.r10);

    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          constraints: const BoxConstraints(minHeight: 40),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? c.onPrimary : Colors.transparent,
            borderRadius: radius,
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: c.shadow,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: context.textStyle.labelMedium.copyWith(
              color: selected ? c.text.brand : c.text.secondary,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
