part of '../view/attendance_page.dart';

// WHY: unlike roster/occurrence, this filter is optional and clearable —
// a supervisor may cover several facilities/staff and want to see all of
// them, so both dropdowns need an explicit "All" entry (null) alongside the
// shared FacilityDropdown's always-one-selected contract.
class _AttendanceFilterBar extends StatelessWidget {
  const _AttendanceFilterBar({
    required this.facilities,
    required this.selectedFacilityId,
    required this.onFacilityChanged,
    required this.staffAsync,
    required this.selectedUserId,
    required this.onUserChanged,
  });

  final List<AccessibleFacilityEntity> facilities;
  final int? selectedFacilityId;
  final ValueChanged<int?> onFacilityChanged;
  final AsyncValue<List<PartnerStaffEntity>> staffAsync;
  final int? selectedUserId;
  final ValueChanged<int?> onUserChanged;

  @override
  Widget build(BuildContext context) {
    final showFacility = facilities.length > 1;
    final staffList = staffAsync.valueOrNull;
    // WHY: keep the slot reserved while staff is still loading (avoids a
    // layout jump once it resolves), but collapse it away on error/empty so
    // the facility dropdown doesn't get stuck at half-width next to blank
    // space.
    final showStaff = staffAsync.isLoading || (staffList?.isNotEmpty ?? false);
    if (!showFacility && !showStaff) return const SizedBox.shrink();

    final spacing = context.dimensions.spacing;
    final children = <Widget>[];
    if (showFacility) {
      children.add(
        Expanded(
          child: FilterDropdown(
            label: context.locale.facilityName,
            value: selectedFacilityId,
            items: [
              for (final facility in facilities)
                DropdownMenuItem(value: facility.id, child: Text(facility.name)),
            ],
            onChanged: onFacilityChanged,
          ),
        ),
      );
    }
    if (showStaff) {
      if (children.isNotEmpty) children.add(Gap(spacing.s12));
      children.add(
        Expanded(
          child: staffAsync.when(
            data: (staff) => FilterDropdown(
              label: context.locale.attendant,
              value: selectedUserId,
              items: [
                for (final member in staff)
                  DropdownMenuItem(value: member.id, child: Text(member.name)),
              ],
              onChanged: onUserChanged,
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(spacing.s16, spacing.s12, spacing.s16, 0),
      child: Row(children: children),
    );
  }
}
