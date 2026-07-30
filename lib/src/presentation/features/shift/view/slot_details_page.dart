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

  void _onCheckOut(BuildContext context) {
    // WHY: the check-out endpoint takes the attendance id (the check-in
    // record), not the slot id. Only shown when `me.action == checkOut`,
    // which implies `me.attendance` (set by check-in) is present.
    final attendanceId = slot.me?.attendance?.id;
    if (attendanceId == null) return;
    context.pushNamed(Routes.shiftCheckOut, extra: attendanceId);
  }

  void _onAssignStaff(BuildContext context) {
    context.pushNamed(Routes.assignStaff, extra: slot);
  }

  Future<void> _onUnassignStaff(
    BuildContext context,
    WidgetRef ref,
    ShiftSlotEntity currentSlot,
    SlotAttendantEntity attendant,
  ) async {
    final rosterId = currentSlot.weeklyRosterId;
    final facilityId = ref.read(shiftSlotsProvider).valueOrNull?.facility?.id;
    if (rosterId == null || facilityId == null) {
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
          shiftSlotId: currentSlot.shiftSlotId,
          attendantId: attendant.userId,
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
    if (rosterId == null || facilityId == null) {
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
          shiftSlotId: currentSlot.shiftSlotId,
          attendantId: attendant.userId,
        );
  }

  // WHY: unassigning changes assigned_count/attendants on this day's slots,
  // so the list backing shift_slots_page must be refetched — its cached
  // state would otherwise still show the removed attendant.
  void _refreshShiftSlots(WidgetRef ref) {
    final current = ref.read(shiftSlotsProvider).valueOrNull;
    if (current == null) return;
    ref
        .read(shiftSlotsProvider.notifier)
        .fetch(date: current.date, facilityId: current.facility?.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(unassignShiftSlotProvider, (_, next) {
      if (next is AsyncData && next.hasValue) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.locale.staffUnassignedSuccessfully)),
        );
        _refreshShiftSlots(ref);
      } else if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.localizedMessage(context))),
        );
      }
    });

    ref.listen(makeSlotLeadProvider, (_, next) {
      if (next is AsyncData && next.hasValue) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.locale.slotLeadUpdatedSuccessfully)),
        );
        _refreshShiftSlots(ref);
      } else if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.localizedMessage(context))),
        );
      }
    });

    final spacing = context.dimensions.spacing;
    final padding = context.dimensions.padding;
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

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: context.pop,
          child: Row(
            children: [
              Icon(
                Icons.chevron_left_rounded,
                color: context.color.primary,
                size: 28,
              ),
              Text(
                context.locale.back,
                style: context.textStyle.labelXl.copyWith(
                  color: context.color.primary,
                ),
              ),
            ],
          ),
        ),
        leadingWidth: 100,
        title: Headline2xlTinyText(context.locale.shiftDetails),
        centerTitle: true,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(spacing.s16),
              child: Column(
                children: [
                  _SlotDetailContractCard(
                    slot: currentSlot,
                    facility: facility,
                  ),
                  if (me?.attendance != null) ...[
                    Gap(spacing.s8),
                    _SlotDetailCheckInCard(attendance: me!.attendance!),
                  ],
                  // WHY the gap is inside the gate: without the card there is
                  // nothing to space away from.
                  PermissionGate(
                    permissions: [UserPermission.shiftAssignAttendant],
                    child: Column(
                      children: [
                        Gap(spacing.s8),
                        _SlotDetailStaffingCard(
                          slot: currentSlot,
                          onAssignStaff: () => _onAssignStaff(context),
                          onUnassignStaff: (attendant) => _onUnassignStaff(
                            context,
                            ref,
                            currentSlot,
                            attendant,
                          ),
                          onMakeLead: (attendant) =>
                              _onMakeLead(context, ref, currentSlot, attendant),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (showCheckOut)
            PermissionGate(
              permissions: [UserPermission.attendanceCheckOut],
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    padding.p16,
                    spacing.s16,
                    padding.p16,
                    spacing.s16,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: spacing.s44,
                    child: FilledButton.icon(
                      onPressed: () => _onCheckOut(context),
                      icon: const Icon(Icons.logout_rounded),
                      label: Text(context.locale.checkOut),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
