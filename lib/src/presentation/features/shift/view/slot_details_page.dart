part of 'shift_tab.dart';

/// Slot-based details, shown to every role.
///
/// WHY a second details page: the slots payload has no shift-template name or
/// notes, so [ShiftDetailsPage] (fed by the older, now-unreachable endpoints)
/// cannot be reused without rendering empty rows. Card styling matches
/// [ShiftDetailsPage] — same
/// [_ShiftDetailContractCard]/[_ShiftDetailCheckInCard] look, rebuilt from
/// only the fields a slot actually carries.
class SlotDetailsPage extends ConsumerWidget {
  const SlotDetailsPage({super.key, required this.slot});

  final ShiftSlotEntity slot;

  void _onCheckOut(BuildContext context, ShiftSlotEntity currentSlot) {
    // WHY: the check-out endpoint takes the attendance id (the check-in
    // record), not the slot id. Only shown when `me.action == checkOut`,
    // which implies `me.attendance` (set by check-in) is present.
    final attendanceId = currentSlot.me?.attendance?.id;
    if (attendanceId == null) return;
    context.pushNamed(Routes.shiftCheckOut, extra: attendanceId);
  }

  void _onAssignStaff(BuildContext context, ShiftSlotEntity currentSlot) {
    context.pushNamed(Routes.assignStaff, extra: currentSlot);
  }

  Future<void> _onUnassignStaff(
    BuildContext context,
    WidgetRef ref,
    ShiftSlotEntity currentSlot,
    SlotAttendantEntity attendant,
  ) async {
    final rosterId = currentSlot.weeklyRosterId;
    final facilityId = ref.read(shiftSlotsProvider).valueOrNull?.facility?.id;
    final assignmentId = attendant.assignmentId;
    if (rosterId == null || facilityId == null || assignmentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.locale.assignmentUnavailable)),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => UnassignStaffConfirmDialog(staffName: attendant.name),
    );
    if (confirmed != true || !context.mounted) return;

    await ref
        .read(unassignShiftSlotProvider.notifier)
        .unassign(
          facilityId: facilityId,
          rosterId: rosterId,
          assignmentId: assignmentId,
        );
  }

  Future<void> _onMakeLead(
    BuildContext context,
    WidgetRef ref,
    ShiftSlotEntity currentSlot,
    SlotAttendantEntity attendant,
  ) async {
    final rosterId = currentSlot.weeklyRosterId;
    final facilityId = ref.read(shiftSlotsProvider).valueOrNull?.facility?.id;
    final assignmentId = attendant.assignmentId;
    if (rosterId == null || facilityId == null || assignmentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.locale.assignmentUnavailable)),
      );
      return;
    }

    await ref
        .read(makeSlotLeadProvider.notifier)
        .makeLead(
          facilityId: facilityId,
          rosterId: rosterId,
          assignmentId: assignmentId,
        );
  }

  void _onUpdateStock(BuildContext context, int facilityId, int shiftAssignmentId) {
    context.pushNamed(
      Routes.updateStock,
      extra: (facilityId, shiftAssignmentId),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // WHY re-derived from the live list rather than the static route arg: an
    // unassign changes this slot's roster, and the page must reflect that
    // without the caller navigating back and re-opening it. Falls back to the
    // route arg before the list has (re)loaded.
    final currentSlot =
        ref.watch(
          shiftSlotsProvider.select((state) {
            for (final s in state.valueOrNull?.slots ?? const []) {
              if (s.shiftSlotId == slot.shiftSlotId) return s;
            }
            return null;
          }),
        ) ??
        slot;
    final me = currentSlot.me;
    // WHY: facility lives on the day payload, not the slot, so it is read back
    // from the same provider rather than threaded through navigation.
    final facility = ref.watch(
      shiftSlotsProvider.select((state) => state.valueOrNull?.facility),
    );
    final showCheckOut = me?.action == SlotAction.checkOut;
    final facilityId = facility?.id;
    final shiftAssignmentId = me?.assignmentId;

    return _SlotDetailsActionListener(
      child: Scaffold(
        backgroundColor: context.color.scaffoldBackground,
        appBar: const _SlotDetailsAppBar(),
        body: Column(
          children: [
            Expanded(
              child: _SlotDetailsContent(
                currentSlot: currentSlot,
                facility: facility,
                onAssignStaff: () => _onAssignStaff(context, currentSlot),
                onUnassignStaff: (attendant) =>
                    _onUnassignStaff(context, ref, currentSlot, attendant),
                onMakeLead: (attendant) =>
                    _onMakeLead(context, ref, currentSlot, attendant),
              ),
            ),
            if (facilityId != null && shiftAssignmentId != null)
              PermissionGate(
                permissions: const [UserPermission.shiftStockCountCreate],
                child: SafeArea(
                  top: false,
                  bottom: !showCheckOut,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      context.dimensions.padding.p16,
                      context.dimensions.spacing.s16,
                      context.dimensions.padding.p16,
                      showCheckOut
                          ? 0
                          : context.dimensions.spacing.s16,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: context.dimensions.spacing.s44,
                      child: OutlinedButton.icon(
                        onPressed: () => _onUpdateStock(
                          context,
                          facilityId,
                          shiftAssignmentId,
                        ),
                        icon: const Icon(Icons.inventory_2_outlined),
                        label: Text(context.locale.updateStock),
                      ),
                    ),
                  ),
                ),
              ),
            if (showCheckOut)
              _SlotDetailsCheckOutBar(
                onCheckOut: () => _onCheckOut(context, currentSlot),
              ),
          ],
        ),
      ),
    );
  }
}
