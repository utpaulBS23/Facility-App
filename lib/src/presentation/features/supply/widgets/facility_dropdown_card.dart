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
    final selectedName = facilities
        .where((f) => f.id == selectedFacilityId)
        .firstOrNull
        ?.localizedName(context.languageCode);

    return FormSelectorCard.text(
      title: context.locale.facility,
      icon: Icons.location_on_outlined,
      value: selectedName,
      placeholder: context.locale.selectFacility,
      onTap: () => _onTap(context),
    );
  }
}
