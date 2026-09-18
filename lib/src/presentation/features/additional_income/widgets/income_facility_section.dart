part of '../view/add_additional_income_page.dart';

class _IncomeFacilitySection extends ConsumerWidget {
  const _IncomeFacilitySection({
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
      builder: (_) => _IncomeFacilityListSheet(
        facilities: facilities,
        selectedFacilityId: ref.read(selectedIncomeFacilityProvider),
      ),
    );
    if (result == null) return;
    ref.read(selectedIncomeFacilityProvider.notifier).select(result);
    onSelected();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final facilities =
        ref.watch(userSessionProvider)?.accessibleFacilities ??
        const <AccessibleFacilityEntity>[];
    final facilityId = ref.watch(selectedIncomeFacilityProvider);
    final facilityName = facilities
        .cast<AccessibleFacilityEntity?>()
        .firstWhere((f) => f?.id == facilityId, orElse: () => null)
        ?.name;

    return _DropdownField(
      value: facilityName,
      hint: context.locale.selectFacility,
      hasError: hasError,
      onTap: enabled && facilities.length > 1
          ? () => _onPickFacility(context, ref, facilities)
          : null,
    );
  }
}
