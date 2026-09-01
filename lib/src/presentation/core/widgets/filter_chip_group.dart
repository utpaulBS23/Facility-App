import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../theme/theme.dart';
import 'text/typography.dart';

/// One labeled row of selectable chips — [T] is typically a nullable id,
/// with `null` reserved for an "All" option.
///
/// WHY shared: the same label-then-`Wrap`-of-`ChoiceChip` layout is used by
/// every filter/picker bottom sheet (attendance's facility+attendant filter,
/// the issue category picker) — keeping one definition means they stay
/// visually identical instead of drifting per feature.
class FilterChipGroup<T> extends StatelessWidget {
  const FilterChipGroup({
    required this.label,
    required this.selected,
    required this.options,
    required this.onSelected,
    super.key,
  });

  final String label;
  final T selected;
  final List<({T value, String label})> options;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelRegularText(label, color: context.color.text.secondary),
        Gap(spacing.s8),
        Wrap(
          spacing: spacing.s8,
          runSpacing: spacing.s8,
          children: [
            for (final option in options)
              ChoiceChip(
                label: Text(option.label),
                selected: option.value == selected,
                onSelected: (_) => onSelected(option.value),
              ),
          ],
        ),
      ],
    );
  }
}
