part of '../view/attendance_page.dart';

/// Combined facility + attendant filter, opened from the AppBar filter
/// icon — mirrors the task tab's modal-sheet filter pattern instead of the
/// inline dropdown row this replaced.
///
/// WHY one sheet for both fields, not two (unlike the single-field sheets in
/// occurrence): a user picking facility then attendant would otherwise
/// re-open the sheet twice for one filter action. Selections are held
/// locally and only committed via Apply, so a dismiss (tap outside/back)
/// discards them instead of applying half-finished state.
class _AttendanceFilterSheet extends ConsumerStatefulWidget {
  const _AttendanceFilterSheet({
    required this.facilities,
    required this.selectedFacilityId,
    required this.selectedUserId,
  });

  final List<AccessibleFacilityEntity> facilities;
  final int? selectedFacilityId;
  final int? selectedUserId;

  @override
  ConsumerState<_AttendanceFilterSheet> createState() =>
      _AttendanceFilterSheetState();
}

class _AttendanceFilterSheetState
    extends ConsumerState<_AttendanceFilterSheet> {
  late int? _facilityId = widget.selectedFacilityId;
  late int? _userId = widget.selectedUserId;

  void _onApply() {
    Navigator.of(context).pop((facilityId: _facilityId, userId: _userId));
  }

  // WHY: refetch attendant options for the newly picked facility instead of
  // keeping the list scoped to whatever facility was selected when the sheet
  // opened — the API filters attendants by facility_id, so a stale list here
  // means the sheet offers attendants outside the just-picked facility.
  void _onFacilitySelected(int? value) {
    setState(() {
      _facilityId = value;
      _userId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final staff =
        ref
            .watch(attendanceStaffOptionsProvider(facilityId: _facilityId))
            .valueOrNull ??
        const <PartnerStaffEntity>[];

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
            child: LabelLargeText(context.locale.filters),
          ),
          Gap(spacing.s16),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: spacing.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.facilities.length > 1) ...[
                    _FilterChipGroup<int?>(
                      label: context.locale.facilityName,
                      selected: _facilityId,
                      options: [
                        (value: null, label: context.locale.all),
                        for (final facility in widget.facilities)
                          (value: facility.id, label: facility.name),
                      ],
                      onSelected: _onFacilitySelected,
                    ),
                    Gap(spacing.s20),
                  ],
                  if (staff.isNotEmpty)
                    _FilterChipGroup<int?>(
                      label: context.locale.attendant,
                      selected: _userId,
                      options: [
                        (value: null, label: context.locale.all),
                        for (final member in staff)
                          (value: member.id, label: member.name),
                      ],
                      onSelected: (value) => setState(() => _userId = value),
                    ),
                  Gap(spacing.s16),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              spacing.s16,
              0,
              spacing.s16,
              spacing.s16,
            ),
            child: SizedBox(
              width: double.infinity,
              height: spacing.s44,
              child: FilledButton(
                onPressed: _onApply,
                child: Text(context.locale.applyFilters),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// One labeled row of selectable chips — [T] is typically a nullable id,
/// with `null` reserved for the "All" option.
class _FilterChipGroup<T> extends StatelessWidget {
  const _FilterChipGroup({
    required this.label,
    required this.selected,
    required this.options,
    required this.onSelected,
    super.key,
  });

  final String label;
  final T selected;
  final List<({T value, String label})> options;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelRegularText(label, color: context.color.text.secondary),
        Gap(spacing.s8),
        Wrap(
          spacing: spacing.s8,
          runSpacing: spacing.s8,
          children: [
            for (final option in options)
              ChoiceChip(
                label: Text(option.label),
                selected: option.value == selected,
                onSelected: (_) => onSelected(option.value),
              ),
          ],
        ),
      ],
    );
  }
}
