import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// A pill-segmented single choice. [T] is usually an enum; any type works when
/// [labelBuilder] is given, or when it is a String.
class CategoryFilterChips<T> extends StatelessWidget {
  const CategoryFilterChips({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
    this.labelBuilder,
    this.fitContent = false,
  });

  final List<T> categories;
  final T selectedCategory;
  final ValueChanged<T> onSelected;
  final String Function(BuildContext context, T category)? labelBuilder;

  /// Hug the chips instead of spanning the width. The row no longer scrolls,
  /// so use it only for a short set that fits, or inside a `FittedBox`.
  final bool fitContent;

  String _getLabel(BuildContext context, T category) {
    if (labelBuilder != null) {
      return labelBuilder!(context, category);
    }
    return category is Enum ? category.name : category.toString();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    final row = Row(
      mainAxisSize: fitContent ? MainAxisSize.min : MainAxisSize.max,
      children: categories.map((category) {
        final isSelected = category == selectedCategory;
        final label = _getLabel(context, category);

        final backgroundColor = switch (isSelected) {
          true => color.onPrimary,
          false => Colors.transparent,
        };
        final boxShadow = switch (isSelected) {
          true => [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          false => null,
        };
        final fontWeight = switch (isSelected) {
          true => FontWeight.bold,
          false => FontWeight.normal,
        };
        final textColor = switch (isSelected) {
          true => color.primary,
          false => color.text.secondary,
        };

        return GestureDetector(
          onTap: () => onSelected(category),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              horizontal: spacing.s16,
              vertical: spacing.s4,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(radius.r20),
              boxShadow: boxShadow,
            ),
            child: Text(
              label,
              style: context.textStyle.labelLarge.copyWith(
                fontWeight: fontWeight,
                color: textColor,
              ),
            ),
          ),
        );
      }).toList(),
    );

    return Container(
      height: spacing.s40,
      padding: EdgeInsets.all(spacing.s4),
      decoration: BoxDecoration(
        color: color.borderSubtle,
        borderRadius: BorderRadius.circular(radius.r20),
      ),
      child: fitContent
          ? row
          : SingleChildScrollView(scrollDirection: Axis.horizontal, child: row),
    );
  }
}
