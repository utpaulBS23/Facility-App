part of '../view/occurrence_page.dart';

class _OccurrenceFacilityDropdown extends StatelessWidget {
  const _OccurrenceFacilityDropdown({
    required this.facilities,
    required this.selectedFacilityId,
    required this.onChanged,
  });

  final List<AccessibleFacilityEntity> facilities;
  final int? selectedFacilityId;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    // WHY: a single accessible facility has nothing to filter — hide the
    // picker rather than show a dropdown with one disabled-feeling option.
    if (facilities.length <= 1) return const SizedBox.shrink();

    final spacing = context.dimensions.spacing;

    return Padding(
      padding: EdgeInsets.fromLTRB(spacing.s16, spacing.s12, spacing.s16, 0),
      child: AppDropdownButtonFormField<int>(
        initialValue: selectedFacilityId,
        decoration: InputDecoration(
          labelText: context.locale.facilityName,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(context.dimensions.radius.r6),
          ),
        ),
        items: [
          for (final facility in facilities)
            DropdownMenuItem(value: facility.id, child: Text(facility.name)),
        ],
        onChanged: (value) {
          if (value != null) onChanged(value);
        },
      ),
    );
  }
}
