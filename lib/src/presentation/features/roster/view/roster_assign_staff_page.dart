import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/partner_staff_entity.dart';
import '../../../../domain/entities/shift_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../../../core/widgets/slot_lead_confirm_dialog.dart';
import '../../../core/widgets/staff_tile.dart';
import '../riverpod/assign_roster_shift_provider.dart';
import '../riverpod/roster_staff_provider.dart';

class RosterAssignStaffPage extends ConsumerStatefulWidget {
  const RosterAssignStaffPage({
    super.key,
    required this.roster,
    required this.shift,
  });

  final RosterEntity roster;
  final ShiftEntity shift;

  @override
  ConsumerState<RosterAssignStaffPage> createState() =>
      _RosterAssignStaffPageState();
}

class _RosterAssignStaffPageState extends ConsumerState<RosterAssignStaffPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(rosterStaffProvider.notifier).fetch(),
    );
  }

  Future<void> _onStaffTap(PartnerStaffEntity person) async {
    final isSlotLead = await showDialog<bool>(
      context: context,
      builder: (_) => SlotLeadConfirmDialog(staffName: person.name),
    );
    if (isSlotLead == null || !mounted) return;

    ref
        .read(assignRosterShiftProvider.notifier)
        .assign(
          facilityId: widget.roster.facilityId,
          rosterId: widget.roster.id,
          shiftSlotId: widget.shift.id,
          attendantId: person.id,
          isSlotLead: isSlotLead,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(assignRosterShiftProvider, (_, next) {
      if (next is AsyncData && next.hasValue) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.locale.staffAssignedSuccessfully)),
        );
        context.pop(true);
      } else if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.localizedMessage(context))),
        );
      }
    });

    final spacing = context.dimensions.spacing;
    final staffState = ref.watch(rosterStaffProvider);
    final isAssigning = ref.watch(assignRosterShiftProvider).isLoading;
    final assignedIds = widget.shift.assignedAttendants
        .map((attendant) => attendant.id)
        .toSet();

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(
        title: context.locale.assignStaff,
        onBack: () => context.pop(false),
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
                  onAssign: isAssigning ? null : () => _onStaffTap(person),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
