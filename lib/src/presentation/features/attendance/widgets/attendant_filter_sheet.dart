part of '../view/attendance_page.dart';

/// Attendant filter — mirrors [FacilityPickerSheet]'s tap-to-select-and-close
/// interaction (via [SelectionPickerSheet]) instead of the app bar's old
/// combined chip-and-Apply sheet, so every filter modal in the app behaves
/// the same way.
class _AttendantFilterSheet extends ConsumerWidget {
  const _AttendantFilterSheet({
    required this.facilityId,
    required this.selectedUserId,
  });

  final int? facilityId;
  final int? selectedUserId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staffAsync = ref.watch(
      attendanceStaffOptionsProvider(facilityId: facilityId),
    );

    return staffAsync.when(
      loading: () => const PickerSheetLoading(),
      error: (err, _) => PickerSheetError(message: err.toString()),
      data: (staff) => SelectionPickerSheet<int?>(
        title: context.locale.attendant,
        options: [
          (value: null, label: context.locale.all),
          for (final member in staff) (value: member.id, label: member.name),
        ],
        isSelected: (value) => value == selectedUserId,
      ),
    );
  }
}
