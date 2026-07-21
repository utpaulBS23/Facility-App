part of 'shift_tab.dart';

/// Slot-based details, shown to every role.
///
/// WHY a second details page: the slots payload has no shift-template name,
/// facility address, per-slot supervisor or notes, so [ShiftDetailsPage] (fed
/// by the older, now-unreachable endpoints) cannot be reused without
/// rendering empty rows. Card styling matches [ShiftDetailsPage] — same
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.locale.assignStaffUnavailable)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.dimensions.spacing;
    final padding = context.dimensions.padding;
    final me = slot.me;
    // WHY: facility lives on the day payload, not the slot, so it is read back
    // from the same provider rather than threaded through navigation.
    final facilityName = ref.watch(
      shiftSlotsProvider.select(
        (state) => state.valueOrNull?.facility?.name ?? '',
      ),
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
                    slot: slot,
                    facilityName: facilityName,
                  ),
                  if (me?.attendance != null) ...[
                    Gap(spacing.s8),
                    _SlotDetailCheckInCard(attendance: me!.attendance!),
                  ],
                  Gap(spacing.s8),
                  _SlotDetailStaffingCard(
                    slot: slot,
                    onAssignStaff: () => _onAssignStaff(context),
                  ),
                ],
              ),
            ),
          ),
          if (showCheckOut)
            PermissionGate(
              permission: AppPermission.attendanceCheckOut,
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
