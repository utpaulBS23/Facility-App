import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/shift_entity.dart';
import '../../../../domain/entities/shift_template_entity.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../../../core/widgets/app_dropdown_button_form_field.dart';
import '../../../core/widgets/assign_staff_button.dart';
import '../../../core/widgets/form_dialog_shell.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/slot_status_chip.dart';
import '../../../core/widgets/unassign_staff_confirm_dialog.dart';
import '../riverpod/create_shift_provider.dart';
import '../riverpod/make_roster_slot_lead_provider.dart';
import '../riverpod/roster_shifts_provider.dart';
import '../riverpod/shift_template_list_provider.dart';
import '../riverpod/unassign_roster_shift_provider.dart';

part '../widgets/create_shift_dialog.dart';
part '../widgets/create_shift_dialog_attendant_count_field.dart';
part '../widgets/create_shift_dialog_date_field.dart';
part '../widgets/create_shift_dialog_field_label.dart';
part '../widgets/create_shift_dialog_notes_field.dart';
part '../widgets/create_shift_dialog_template_field.dart';
part '../widgets/roster_assigned_staff_table.dart';
part '../widgets/roster_shift_card.dart';
part '../widgets/roster_shift_info_row.dart';
part '../widgets/roster_shift_marker.dart';
part '../widgets/roster_shift_metrics.dart';
part '../widgets/roster_shift_notes.dart';
part '../widgets/roster_shifts_body.dart';
part '../widgets/roster_staff_row_actions.dart';
part '../widgets/roster_table_cell.dart';

class RosterShiftsPage extends ConsumerStatefulWidget {
  const RosterShiftsPage({super.key, required this.roster});

  final RosterEntity roster;

  @override
  ConsumerState<RosterShiftsPage> createState() => _RosterShiftsPageState();
}

class _RosterShiftsPageState extends ConsumerState<RosterShiftsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchShifts());
  }

  void _fetchShifts() {
    ref
        .read(rosterShiftsProvider.notifier)
        .fetch(
          facilityId: widget.roster.facilityId,
          rosterId: widget.roster.id,
        );
  }

  Future<void> _onCreateShift() async {
    final created = await showDialog<bool>(
      context: context,
      builder: (_) => CreateShiftDialog(roster: widget.roster),
    );
    if (created != true || !mounted) return;
    _fetchShifts();
  }

  Future<void> _onAssignShift(ShiftEntity shift) async {
    final assigned = await context.pushNamed<bool>(
      Routes.rosterAssignStaff,
      extra: (roster: widget.roster, shift: shift),
    );
    if (assigned != true || !mounted) return;
    _fetchShifts();
  }

  Future<void> _onUnassignStaff(ShiftAssignmentEntity assignment) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) =>
          UnassignStaffConfirmDialog(staffName: assignment.attendant.fullName),
    );
    if (confirmed != true || !mounted) return;

    await ref
        .read(unassignRosterShiftProvider.notifier)
        .unassign(
          facilityId: widget.roster.facilityId,
          rosterId: widget.roster.id,
          assignmentId: assignment.id,
        );
  }

  Future<void> _onMakeSlotLead(ShiftAssignmentEntity assignment) async {
    await ref
        .read(makeRosterSlotLeadProvider.notifier)
        .makeLead(
          facilityId: widget.roster.facilityId,
          rosterId: widget.roster.id,
          assignmentId: assignment.id,
        );
  }

  @override
  Widget build(BuildContext context) {
    final shiftsState = ref.watch(rosterShiftsProvider);

    ref.listen(unassignRosterShiftProvider, (previous, next) {
      if (next is AsyncData && previous is AsyncLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.locale.staffUnassignedSuccessfully)),
        );
        _fetchShifts();
      } else if (next case AsyncError(:final error)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.localizedMessage(context))),
        );
      }
    });

    ref.listen(makeRosterSlotLeadProvider, (previous, next) {
      if (next is AsyncData && previous is AsyncLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.locale.slotLeadUpdatedSuccessfully)),
        );
        _fetchShifts();
      } else if (next case AsyncError(:final error)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.localizedMessage(context))),
        );
      }
    });

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(title: context.locale.rosterShifts),
      floatingActionButton: PermissionGate(
        permissions: [UserPermission.shiftCreate],
        child: FloatingActionButton(
          onPressed: _onCreateShift,
          child: const Icon(Icons.add_rounded),
        ),
      ),
      body: shiftsState.when(
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
        data: (data) => _RosterShiftsBody(
          shifts: data,
          onAssign: _onAssignShift,
          onUnassignStaff: _onUnassignStaff,
          onMakeSlotLead: _onMakeSlotLead,
        ),
      ),
    );
  }
}
