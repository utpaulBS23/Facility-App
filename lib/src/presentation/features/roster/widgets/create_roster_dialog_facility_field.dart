part of '../view/roster_list_page.dart';

class _FacilityField extends StatelessWidget {
  const _FacilityField({
    required this.facilitiesState,
    required this.selectedFacilityId,
    required this.onChanged,
  });

  final AsyncValue<List<FacilityEntity>> facilitiesState;
  final int? selectedFacilityId;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(context.locale.facilityName, required: true),
        Gap(context.dimensions.spacing.s8),
        facilitiesState.when(
          loading: () => const LinearProgressIndicator(),
          error: (err, _) => Text(
            err.localizedMessage(context),
            style: context.textStyle.bodySmall.copyWith(
              color: context.color.error,
            ),
          ),
          data: (facilities) => AppDropdownButtonFormField<int>(
            initialValue: selectedFacilityId,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  context.dimensions.radius.r6,
                ),
              ),
            ),
            items: [
              for (final facility in facilities)
                DropdownMenuItem(
                  value: facility.id,
                  child: Text(facility.name),
                ),
            ],
            onChanged: (value) {
              if (value != null) onChanged(value);
            },
          ),
        ),
      ],
    );
  }
}
