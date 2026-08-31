part of '../view/task_page.dart';

/// WHY an explicit "All" row, unlike shift/occurrence's facility sheets:
/// those endpoints always resolve to one facility. The issues list already
/// supported an unscoped view (facilityId: null) via the FilterDropdown
/// this replaces, and that capability is kept here.
class _TaskFacilityPickerSheet extends StatelessWidget {
  const _TaskFacilityPickerSheet({
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
      // WHY Material: ListTile paints its background/ink splashes on the
      // nearest Material ancestor. Without this, the outer Container's own
      // BoxDecoration color sits on top and hides them (Flutter's own
      // "ListTile background color or ink splashes may be invisible"
      // assertion).
      child: Material(
        type: MaterialType.transparency,
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
              child: LabelLargeText(context.locale.facilityName),
            ),
            Gap(spacing.s8),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.fromLTRB(
                  spacing.s16,
                  0,
                  spacing.s16,
                  spacing.s16,
                ),
                itemCount: facilities.length + 1,
                separatorBuilder: (_, _) => Gap(spacing.s8),
                itemBuilder: (context, index) {
                  final facilityId = index == 0
                      ? null
                      : facilities[index - 1].id;
                  final label = index == 0
                      ? context.locale.all
                      : facilities[index - 1].name;
                  final isSelected = facilityId == selectedFacilityId;
                  return ListTile(
                    onTap: () =>
                        Navigator.of(context).pop((facilityId: facilityId)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(radius.r10),
                      side: BorderSide(
                        color: isSelected
                            ? context.color.primary
                            : context.color.borderSubtle,
                      ),
                    ),
                    title: Text(label),
                    trailing: isSelected
                        ? Icon(
                            Icons.check_circle_rounded,
                            color: context.color.primary,
                          )
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
