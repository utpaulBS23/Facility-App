part of '../view/new_request_page.dart';

// WHY FacilityPickerSheet, not a native DropdownButton: the shared
// modal-bottom-sheet picker used for every facility select across the app
// (claim_expense, shift/occurrence/task/roster filters).
class _FacilityDropdownCard extends StatelessWidget {
  const _FacilityDropdownCard({
    required this.selectedFacilityId,
    required this.facilities,
    required this.onChanged,
  });

  final int? selectedFacilityId;
  final List<AccessibleFacilityEntity> facilities;
  final ValueChanged<int> onChanged;

  Future<void> _onTap(BuildContext context) async {
    final result = await showModalBottomSheet<({int? facilityId})>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FacilityPickerSheet(
        facilities: facilities,
        selectedFacilityId: selectedFacilityId,
      ),
    );
    if (result == null || result.facilityId == null) return;
    onChanged(result.facilityId!);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;
    final selectedName = facilities
        .where((f) => f.id == selectedFacilityId)
        .firstOrNull
        ?.name;

    return GestureDetector(
      onTap: () => _onTap(context),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.s16,
          vertical: spacing.s12,
        ),
        decoration: BoxDecoration(
          color: color.onPrimary,
          border: Border.all(color: color.borderSubtle),
          borderRadius: BorderRadius.circular(radius.r12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              color: color.text.secondary,
              size: spacing.s20,
            ),
            Gap(spacing.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.locale.facility,
                    style: context.textStyle.bodySmall.copyWith(
                      color: color.text.secondary,
                    ),
                  ),
                  Gap(spacing.s2),
                  Text(
                    selectedName ?? context.locale.selectFacility,
                    overflow: TextOverflow.ellipsis,
                    style: context.textStyle.labelLarge.copyWith(
                      color: color.text.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: color.text.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
