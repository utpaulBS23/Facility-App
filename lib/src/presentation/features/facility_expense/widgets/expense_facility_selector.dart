part of '../view/facility_expense_page.dart';

class _ExpenseFacilitySelector extends StatelessWidget {
  const _ExpenseFacilitySelector({required this.facilityName, this.onTap});

  final String? facilityName;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = context.dimensions.radius;
    final spacing = context.dimensions.spacing;
    final isDisabled = onTap == null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: context.color.onPrimary,
          border: Border.all(color: context.color.borderSubtle),
          borderRadius: BorderRadius.circular(radius.r12),
        ),
        padding: EdgeInsets.symmetric(horizontal: spacing.s16),
        child: Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 18,
              color: context.color.text.secondary,
            ),
            Gap(spacing.s8),
            Expanded(
              child: Text(
                facilityName ?? context.locale.selectFacility,
                overflow: TextOverflow.ellipsis,
                style: facilityName == null
                    ? context.textStyle.bodyMedium.copyWith(
                        color: context.color.text.secondary,
                      )
                    : context.textStyle.bodyMedium,
              ),
            ),
            if (!isDisabled)
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: context.color.text.secondary,
              ),
          ],
        ),
      ),
    );
  }
}

// WHY tap-to-select-and-pop, not a native dropdown: mirrors
// FacilityPickerSheet's interaction so every filter/picker sheet in the app
// behaves the same way.
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
            width: 40,
            height: 4,
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
                  onTap: () => Navigator.of(
                    context,
                  ).pop((facilityId: facility.id)),
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
                            size: 20,
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
