import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/router/routes.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/shift_entity.dart';
import '../../../../domain/entities/shift_template_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/assign_staff_button.dart';
import '../../../core/widgets/assigned_staff_tile.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/slot_status_chip.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/create_shift_provider.dart';
import '../riverpod/roster_shifts_provider.dart';
import '../riverpod/shift_template_list_provider.dart';

part '../widgets/create_shift_dialog.dart';
part '../widgets/roster_shift_card.dart';

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

  @override
  Widget build(BuildContext context) {
    final shiftsState = ref.watch(rosterShiftsProvider);

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        title: DisplaySmallText(context.locale.rosterShifts),
        titleSpacing: context.dimensions.spacing.s16,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      floatingActionButton: PermissionGate(
        permission: AppPermission.shiftCreate,
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
            err.toString(),
            style: context.textStyle.bodyMedium.copyWith(
              color: context.color.text.secondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        data: (data) =>
            _RosterShiftsBody(shifts: data, onAssign: _onAssignShift),
      ),
    );
  }
}

class _RosterShiftsBody extends StatelessWidget {
  const _RosterShiftsBody({required this.shifts, required this.onAssign});

  final RosterShiftsEntity? shifts;
  final ValueChanged<ShiftEntity> onAssign;

  @override
  Widget build(BuildContext context) {
    final entries = shifts?.shifts ?? const <ShiftEntity>[];
    final spacing = context.dimensions.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (shifts != null)
          Padding(
            padding: EdgeInsets.fromLTRB(
              spacing.s16,
              spacing.s12,
              spacing.s16,
              spacing.s4,
            ),
            child: _RosterShiftStatsHeader(stats: shifts!.stats),
          ),
        Expanded(
          child: entries.isEmpty
              ? Center(
                  child: Text(
                    context.locale.noShiftsInRoster,
                    style: context.textStyle.bodyMedium.copyWith(
                      color: context.color.text.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.separated(
                  padding: EdgeInsets.fromLTRB(
                    spacing.s16,
                    spacing.s12,
                    spacing.s16,
                    spacing.s24,
                  ),
                  itemCount: entries.length,
                  separatorBuilder: (context, index) => Gap(spacing.s12),
                  itemBuilder: (context, index) => _RosterShiftCard(
                    shift: entries[index],
                    onAssign: () => onAssign(entries[index]),
                  ),
                ),
        ),
      ],
    );
  }
}

class _RosterShiftStatsHeader extends StatelessWidget {
  const _RosterShiftStatsHeader({required this.stats});

  final RosterShiftStatsEntity stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatTile(label: context.locale.totalShifts, value: stats.totalShifts),
        Gap(context.dimensions.spacing.s12),
        _StatTile(label: context.locale.assigned, value: stats.assignedShifts),
        Gap(context.dimensions.spacing.s12),
        _StatTile(
          label: context.locale.unassigned,
          value: stats.unassignedShifts,
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: spacing.s12),
        decoration: BoxDecoration(
          color: context.color.onPrimary,
          border: Border.all(color: context.color.borderSubtle),
          borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        ),
        child: Column(
          children: [
            Text(
              '$value',
              style: context.textStyle.titleMedium.copyWith(
                color: context.color.text.primary,
              ),
            ),
            Gap(spacing.s4),
            Text(
              label,
              style: context.textStyle.labelSmall.copyWith(
                color: context.color.text.secondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
