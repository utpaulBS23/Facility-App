import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/extensions/app_localization.dart';
import '../../../domain/entities/partner_staff_entity.dart';
import '../theme/theme.dart';
import 'staff_tile.dart';

/// Reusable app bar action that opens a supervisor picker sheet and reports
/// the selection. Callers own the fetch (e.g. via `supervisorOptionsProvider`)
/// and pass the result in as [supervisorsAsync], mirroring [MonthFilterButton]'s
/// dumbness — this widget only renders the trigger and the picker sheet.
class SupervisorFilterButton extends StatelessWidget {
  const SupervisorFilterButton({
    super.key,
    required this.supervisorsAsync,
    required this.selected,
    required this.onChanged,
  });

  final AsyncValue<List<PartnerStaffEntity>> supervisorsAsync;
  final PartnerStaffEntity? selected;
  final ValueChanged<PartnerStaffEntity> onChanged;

  Future<void> _pick(BuildContext context) async {
    final supervisor = await showModalBottomSheet<PartnerStaffEntity>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _SupervisorPickerSheet(
        supervisorsAsync: supervisorsAsync,
        selected: selected,
      ),
    );
    if (supervisor != null) onChanged(supervisor);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    return IconButton(
      onPressed: () => _pick(context),
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(Icons.supervisor_account_outlined, size: 18),
          if (selected != null)
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                width: spacing.s8,
                height: spacing.s8,
                decoration: BoxDecoration(
                  color: context.color.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SupervisorPickerSheet extends StatelessWidget {
  const _SupervisorPickerSheet({
    required this.supervisorsAsync,
    required this.selected,
  });

  final AsyncValue<List<PartnerStaffEntity>> supervisorsAsync;
  final PartnerStaffEntity? selected;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.75,
      ),
      decoration: BoxDecoration(
        color: context.color.scaffoldBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(radius.r12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Gap(spacing.s12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: context.color.borderSubtle,
              borderRadius: BorderRadius.circular(radius.r4),
            ),
          ),
          Gap(spacing.s16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing.s16),
            child: Text(
              context.locale.selectSupervisor,
              style: context.textStyle.labelLarge,
            ),
          ),
          Gap(spacing.s16),
          Flexible(
            child: switch (supervisorsAsync) {
              AsyncData(:final value) => value.isEmpty
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.all(spacing.s16),
                        child: Text(
                          context.locale.noSupervisorsFound,
                          style: context.textStyle.bodySmall.copyWith(
                            color: context.color.text.secondary,
                          ),
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.fromLTRB(
                        spacing.s16,
                        0,
                        spacing.s16,
                        spacing.s16,
                      ),
                      itemCount: value.length,
                      separatorBuilder: (_, _) => Gap(spacing.s12),
                      itemBuilder: (context, index) {
                        final supervisor = value[index];
                        return StaffTile(
                          staff: supervisor,
                          isSelected: supervisor.id == selected?.id,
                          onAssign: () =>
                              Navigator.of(context).pop(supervisor),
                        );
                      },
                    ),
              AsyncError(:final error) => Center(
                  child: Padding(
                    padding: EdgeInsets.all(spacing.s16),
                    child: Text(
                      error.toString(),
                      style: context.textStyle.bodySmall.copyWith(
                        color: context.color.primary,
                      ),
                    ),
                  ),
                ),
              _ => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator.adaptive(),
                  ),
                ),
            },
          ),
        ],
      ),
    );
  }
}
