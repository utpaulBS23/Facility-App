part of '../view/occurrence_page.dart';

class _OccurrenceFacilityPickerSheet extends StatelessWidget {
  const _OccurrenceFacilityPickerSheet({
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
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.75),
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
            child: LabelLargeText(context.locale.facilityName),
          ),
          Gap(spacing.s8),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.fromLTRB(spacing.s16, 0, spacing.s16, spacing.s16),
              itemCount: facilities.length,
              separatorBuilder: (_, _) => Gap(spacing.s8),
              itemBuilder: (context, index) {
                final facility = facilities[index];
                final isSelected = facility.id == selectedFacilityId;
                return ListTile(
                  onTap: () => Navigator.of(context).pop(facility.id),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radius.r10),
                    side: BorderSide(
                      color: isSelected ? context.color.primary : context.color.borderSubtle,
                    ),
                  ),
                  title: Text(facility.name),
                  trailing: isSelected
                      ? Icon(Icons.check_circle_rounded, color: context.color.primary)
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
