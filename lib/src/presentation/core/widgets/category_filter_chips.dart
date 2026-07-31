import 'package:flutter/material.dart';

import '../theme/theme.dart';

class CategoryFilterChips<T> extends StatefulWidget {
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
  State<CategoryFilterChips<T>> createState() =>
      _CategoryFilterChipsState<T>();
}

class _CategoryFilterChipsState<T> extends State<CategoryFilterChips<T>> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
  }

  @override
  void didUpdateWidget(CategoryFilterChips<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedCategory != widget.selectedCategory) {
      _scrollToSelected();
    }
  }

  void _scrollToSelected() {
    if (!_scrollController.hasClients) return;
    final index = widget.categories.indexOf(widget.selectedCategory);
    if (index == -1) return;

    final targetOffset = (index * 85.0).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: widget.categories.map((category) {
            final isSelected = category == widget.selectedCategory;
            final label = widget.labelBuilder != null
                ? widget.labelBuilder!(category)
                : category.toString();

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
              onTap: () => widget.onSelected(category),
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
