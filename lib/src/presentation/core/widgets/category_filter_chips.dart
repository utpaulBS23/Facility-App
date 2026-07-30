import 'package:flutter/material.dart';

import '../theme/theme.dart';

class CategoryFilterChips<T> extends StatelessWidget {
  const CategoryFilterChips({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
    this.labelBuilder,
  });

  final List<T> categories;
  final T selectedCategory;
  final ValueChanged<T> onSelected;
  final String Function(T category)? labelBuilder;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    return Container(
      height: 40,
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
            final label = labelBuilder != null
                ? labelBuilder!(category)
                : category.toString();

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
                  color: isSelected ? color.onPrimary : Colors.transparent,
                  borderRadius: BorderRadius.circular(radius.r20),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  label,
                  style: context.textStyle.labelLarge.copyWith(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? color.primary : color.text.secondary,
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
