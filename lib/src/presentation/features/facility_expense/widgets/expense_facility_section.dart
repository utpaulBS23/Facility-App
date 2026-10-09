part of '../view/add_facility_expense_page.dart';

class _FacilitySection extends ConsumerWidget {
  const _FacilitySection({
    required this.enabled,
    required this.hasError,
    required this.onSelected,
  });

  final bool enabled;
  final bool hasError;
  final VoidCallback onSelected;

  Future<void> _onPickFacility(
    BuildContext context,
    WidgetRef ref,
    List<AccessibleFacilityEntity> facilities,
  ) async {
    final result = await showModalBottomSheet<int?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _FacilityListSheet(
        facilities: facilities,
        selectedFacilityId: ref.read(selectedExpenseFacilityProvider),
      ),
    );
    if (result == null) return;
    ref.read(selectedExpenseFacilityProvider.notifier).select(result);
    onSelected();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final facilities =
        ref.watch(userSessionProvider)?.accessibleFacilities ??
        const <AccessibleFacilityEntity>[];
    final facilityId = ref.watch(selectedExpenseFacilityProvider);
    final facilityName = facilities
        .cast<AccessibleFacilityEntity?>()
        .firstWhere((f) => f?.id == facilityId, orElse: () => null)
        ?.localizedName(context.languageCode);

    return FormSelectorCard.text(
      title: context.locale.selectFacility,
      icon: Icons.location_on_outlined,
      value: facilityName,
      placeholder: context.locale.selectFacility,
      errorText: hasError ? context.locale.fieldRequired : null,
      onTap: enabled && facilities.length > 1
          ? () => _onPickFacility(context, ref, facilities)
          : null,
    );
  }
}
