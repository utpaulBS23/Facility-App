part of '../view/apply_leave_page.dart';

class _LeaveFilterBar extends StatelessWidget {
  const _LeaveFilterBar({
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
      height: 36,
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
          final displayLabel = switch (filter) {
            'All' => context.locale.all,
            'Pending' => context.locale.pending,
            'Manager Approval' => context.locale.managerApproval,
            'Approved' => context.locale.approved,
            _ => filter,
          };

          return GestureDetector(
            onTap: () => onFilterSelected(filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(
                horizontal: spacing.s16,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? context.color.onPrimary : Colors.transparent,
                borderRadius: BorderRadius.circular(radius.r20),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : null,
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
