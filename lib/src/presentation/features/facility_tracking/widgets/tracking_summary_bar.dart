import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/facility_tracking_entity.dart';
import '../../../core/theme/theme.dart';
import 'tracking_status_style.dart';

/// Attendant counts by status, shown under the map.
class TrackingSummaryBar extends StatelessWidget {
  const TrackingSummaryBar({super.key, required this.staff});

  final List<StaffPinEntity> staff;

  int _count(StaffPinStatus status) =>
      staff.where((s) => s.status == status).length;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Container(
      width: double.infinity,
      color: context.color.onPrimary,
      padding: EdgeInsets.symmetric(
        horizontal: spacing.s16,
        vertical: spacing.s12,
      ),
      child: SafeArea(
        top: false,
        child: Wrap(
          spacing: spacing.s8,
          runSpacing: spacing.s8,
          children: [
            _SummaryChip(
              status: StaffPinStatus.working,
              count: _count(StaffPinStatus.working),
              label: context.locale.attendantsWorking,
            ),
            _SummaryChip(
              status: StaffPinStatus.free,
              count: _count(StaffPinStatus.free),
              label: context.locale.attendantsFree,
            ),
            _SummaryChip(
              status: StaffPinStatus.contractEnded,
              count: _count(StaffPinStatus.contractEnded),
              label: context.locale.attendantContractEnded,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.status,
    required this.count,
    required this.label,
  });

  final StaffPinStatus status;
  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.s12,
        vertical: spacing.s6,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: context.color.borderSubtle),
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.numbers.integer(count),
            style: context.textStyle.labelLarge.copyWith(
              color: status.color(context),
            ),
          ),
          SizedBox(width: spacing.s4),
          Text(
            label,
            style: context.textStyle.bodySmall.copyWith(
              color: context.color.text.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
