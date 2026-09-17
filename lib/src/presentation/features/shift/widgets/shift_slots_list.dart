part of '../view/shift_tab.dart';

class _ShiftSlotsList extends StatelessWidget {
  const _ShiftSlotsList({
    required this.data,
    required this.facility,
    required this.canApplyLeave,
    required this.onApplyLeave,
    required this.onSlotTap,
    required this.onAssignStaff,
  });

  final ShiftSlotsEntity? data;
  final SlotFacilityEntity? facility;
  final bool canApplyLeave;
  final VoidCallback onApplyLeave;
  final ValueChanged<ShiftSlotEntity> onSlotTap;
  final ValueChanged<ShiftSlotEntity> onAssignStaff;

  @override
  Widget build(BuildContext context) {
    final facilities = data?.facilities ?? const <SlotsFacilityEntity>[];
    final slots = data?.slots ?? const <ShiftSlotEntity>[];
    final activeSlot = data?.activeSlot;

    final hasMultipleFacilities = facilities.isNotEmpty;
    final hasSlots = slots.isNotEmpty || hasMultipleFacilities;

    if (!hasSlots && activeSlot == null) {
      return _ShiftSlotsMessage(message: context.locale.noShiftsFound);
    }

    final spacing = context.dimensions.spacing;
    final items = <Widget>[];

    if (canApplyLeave) {
      items.add(_ApplyLeaveButton(onTap: onApplyLeave));
    }

    items.add(Gap(spacing.s12));

    if (activeSlot != null) {
      items.add(_ActiveSlotBanner(activeSlot: activeSlot));
    }

    if (hasMultipleFacilities) {
      for (var fIdx = 0; fIdx < facilities.length; fIdx++) {
        final fac = facilities[fIdx];
        if (fIdx > 0 || canApplyLeave || activeSlot != null) {
          items.add(Gap(spacing.s16));
        }
        items.add(
          Padding(
            padding: EdgeInsets.only(top: spacing.s8, bottom: spacing.s8),
            child: Text(fac.facilityName, style: context.textStyle.titleSmall),
          ),
        );
        for (var i = 0; i < fac.slots.length; i++) {
          if (i > 0) items.add(Gap(spacing.s12));
          final slot = fac.slots[i];
          items.add(
            _SlotCard(
              slot: slot,
              facility: SlotFacilityEntity(id: fac.facilityId, name: fac.facilityName, address: ''),
              onTap: () => onSlotTap(slot),
              onAssignStaff: () => onAssignStaff(slot),
            ),
          );
        }
      }
    } else {
      for (var i = 0; i < slots.length; i++) {
        if (i > 0) items.add(Gap(spacing.s12));
        final slot = slots[i];
        items.add(
          _SlotCard(
            slot: slot,
            facility: facility,
            onTap: () => onSlotTap(slot),
            onAssignStaff: () => onAssignStaff(slot),
          ),
        );
      }
    }

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(spacing.s16, spacing.s12, spacing.s16, spacing.s16),
      itemCount: items.length,
      itemBuilder: (context, index) => items[index],
    );
  }
}
