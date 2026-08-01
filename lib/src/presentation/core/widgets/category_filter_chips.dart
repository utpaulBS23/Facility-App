import 'package:flutter/material.dart';

import '../theme/theme.dart';

class CategoryFilterChips<T extends Enum> extends StatelessWidget {
  const CategoryFilterChips({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });

  final List<T> categories;
  final T selectedCategory;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    return Container(
      height: spacing.s40,
      padding: EdgeInsets.all(spacing.s4),
      decoration: BoxDecoration(
        color: color.borderSubtle,
        borderRadius: BorderRadius.circular(radius.r20),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories.map((category) {
            final isSelected = category == selectedCategory;
            final label = category.toString();

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
        ),
      ),
    );
  }
}
