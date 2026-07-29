part of '../view/supply_requests_page.dart';

class _SupplyFilterBar extends StatelessWidget {
  const _SupplyFilterBar({
    required this.selectedFilter,
    required this.onFilterSelected,
    required this.filters,
  });

  final String selectedFilter;
  final ValueChanged<String> onFilterSelected;
  final List<String> filters;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      height: spacing.s36,
      padding: EdgeInsets.all(spacing.s4),
      decoration: BoxDecoration(
        color: context.color.borderSubtle,
        borderRadius: BorderRadius.circular(radius.r20),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = filter == selectedFilter;
          final displayLabel = supplyFilterLabel(context, filter);

          return GestureDetector(
            onTap: () => onFilterSelected(filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: spacing.s16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? context.color.onPrimary : Colors.transparent,
                borderRadius: BorderRadius.circular(radius.r20),
              ),
              child: Text(
                displayLabel,
                style: context.textStyle.bodyMedium.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? context.color.primary
                      : context.color.text.secondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
