import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/partner_staff_entity.dart';
import '../../../../domain/entities/shift_slot_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/slot_lead_confirm_dialog.dart';
import '../../../core/widgets/staff_tile.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/assign_shift_slot_provider.dart';
import '../riverpod/partner_staff_provider.dart';
import '../riverpod/shift_slots_provider.dart';

class AssignStaffPage extends ConsumerStatefulWidget {
  const AssignStaffPage({super.key, required this.slot});

  final ShiftSlotEntity slot;

  @override
  ConsumerState<AssignStaffPage> createState() => _AssignStaffPageState();
}

class _AssignStaffPageState extends ConsumerState<AssignStaffPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(partnerStaffProvider.notifier).fetch(),
    );
  }

  Future<void> _onStaffTap(PartnerStaffEntity person) async {
    // WHY: facility lives on the day payload, not the slot, so it is read
    // back from the same provider rather than threaded through navigation
    // (same pattern as SlotDetailsPage).
    final facilityId = ref.read(shiftSlotsProvider).valueOrNull?.facility?.id;
    final rosterId = widget.slot.weeklyRosterId;
    if (facilityId == null || rosterId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.locale.assignmentUnavailable)),
      );
      return;
    }

    final isSlotLead = await showDialog<bool>(
      context: context,
      builder: (_) => SlotLeadConfirmDialog(staffName: person.name),
    );
    if (isSlotLead == null || !mounted) return;

    ref
        .read(assignShiftSlotProvider.notifier)
        .assign(
          facilityId: facilityId,
          rosterId: rosterId,
          shiftSlotId: widget.slot.shiftSlotId,
          attendantId: person.id,
          isSlotLead: isSlotLead,
        );
  }

  // WHY: assigning changes assigned_count/attendants on this day's slots, so
  // the list backing shift_slots_page must be refetched, not just popped
  // back to — its cached state would otherwise show the pre-assign roster.
  void _refreshShiftSlots() {
    final current = ref.read(shiftSlotsProvider).valueOrNull;
    if (current == null) return;
    ref
        .read(shiftSlotsProvider.notifier)
        .fetch(date: current.date, facilityId: current.facility?.id);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(assignShiftSlotProvider, (_, next) {
      if (next is AsyncData && next.hasValue) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.locale.staffAssignedSuccessfully)),
        );
        _refreshShiftSlots();
        context.pop();
      } else if (next is AsyncError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error.localizedMessage(context))));
      }
    });

    final spacing = context.dimensions.spacing;
    final staffState = ref.watch(partnerStaffProvider);
    final isAssigning = ref.watch(assignShiftSlotProvider).isLoading;
    final assignedIds = widget.slot.activeAttendants
        .map((attendant) => attendant.userId)
        .toSet();

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
        title: LabelLargeText(context.locale.assignStaff),
        centerTitle: true,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        top: false,
        child: staffState.when(
          loading: () =>
              const Center(child: CircularProgressIndicator.adaptive()),
          error: (err, _) => Center(
            child: Text(
              err.localizedMessage(context),
              style: context.textStyle.bodyMedium.copyWith(
                color: context.color.text.secondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          data: (staff) {
            if (staff.isEmpty) {
              return Center(
                child: Text(
                  context.locale.noAttendantsFound,
                  style: context.textStyle.bodyMedium.copyWith(
                    color: context.color.text.secondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }
            return ListView.separated(
              padding: EdgeInsets.all(spacing.s16),
              itemCount: staff.length,
              separatorBuilder: (context, index) => Gap(spacing.s12),
              itemBuilder: (context, index) {
                final person = staff[index];
                final isSelected = assignedIds.contains(person.id);
                return StaffTile(
                  staff: person,
                  isSelected: isSelected,
                  onAssign: isAssigning || isSelected
                      ? null
                      : () {
                          _onStaffTap(person);
                        },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
