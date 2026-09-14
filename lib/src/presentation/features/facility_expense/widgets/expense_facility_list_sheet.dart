part of '../view/add_facility_expense_page.dart';

class _ExpenseCategoryPickerSheet extends StatelessWidget {
  const _ExpenseCategoryPickerSheet({
    required this.categories,
    required this.onSelected,
  });

  final List<MasterDataItemEntity> categories;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.75,
      ),
      decoration: BoxDecoration(
        color: context.color.scaffoldBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(radius.r12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Gap(spacing.s12),
          Container(
            width: spacing.s40,
            height: spacing.s4,
            decoration: BoxDecoration(
              color: context.color.borderSubtle,
              borderRadius: BorderRadius.circular(radius.r4),
            ),
          ),
          Gap(spacing.s16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing.s16),
            child: LabelLargeText(context.locale.selectTypeOfExpense),
          ),
          Gap(spacing.s16),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.fromLTRB(
                spacing.s16,
                0,
                spacing.s16,
                spacing.s16,
              ),
              itemCount: categories.length,
              separatorBuilder: (_, _) => Gap(spacing.s12),
              itemBuilder: (context, index) {
                final category = categories[index];
                return Consumer(
                  builder: (context, ref, _) {
                    final selected =
                        ref.watch(selectedExpenseCategoryProvider);
                    final isSelected = category.value == selected?.value;
                    return GestureDetector(
                      onTap: () {
                        ref
                            .read(
                                selectedExpenseCategoryProvider.notifier)
                            .state = category;
                        onSelected();
                      },
                      child: Container(
                        padding: EdgeInsets.all(spacing.s16),
                        decoration: BoxDecoration(
                          color: context.color.onPrimary,
                          border: Border.all(
                            color: isSelected
                                ? context.color.primary
                                : context.color.borderSubtle,
                          ),
                          borderRadius: BorderRadius.circular(radius.r12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: LabelLargeText(
                                category.label,
                                color: isSelected
                                    ? context.color.primary
                                    : context.color.text.primary,
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle_rounded,
                                color: context.color.primary,
                                size: spacing.s20,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpenseFacilityPickerSheet extends StatelessWidget {
  const _ExpenseFacilityPickerSheet({
    required this.facilities,
    required this.selectedFacilityId,
  });

  final List<AccessibleFacilityEntity> facilities;
  final int? selectedFacilityId;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.75,
      ),
      decoration: BoxDecoration(
        color: context.color.scaffoldBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(radius.r12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Gap(spacing.s12),
          Container(
            width: spacing.s40,
            height: spacing.s4,
            decoration: BoxDecoration(
              color: context.color.borderSubtle,
              borderRadius: BorderRadius.circular(radius.r4),
            ),
          ),
          Gap(spacing.s16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing.s16),
            child: LabelLargeText(context.locale.selectFacility),
          ),
          Gap(spacing.s16),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.fromLTRB(
                spacing.s16,
                0,
                spacing.s16,
                spacing.s16,
              ),
              itemCount: facilities.length,
              separatorBuilder: (_, _) => Gap(spacing.s12),
              itemBuilder: (context, index) {
                final facility = facilities[index];
                final isSelected = facility.id == selectedFacilityId;
                return GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pop((facilityId: facility.id)),
                  child: Container(
                    padding: EdgeInsets.all(spacing.s16),
                    decoration: BoxDecoration(
                      color: context.color.onPrimary,
                      border: Border.all(
                        color: isSelected
                            ? context.color.primary
                            : context.color.borderSubtle,
                      ),
                      borderRadius: BorderRadius.circular(radius.r12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: LabelLargeText(
                            facility.name,
                            color: isSelected
                                ? context.color.primary
                                : context.color.text.primary,
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle_rounded,
                            color: context.color.primary,
                            size: spacing.s20,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
