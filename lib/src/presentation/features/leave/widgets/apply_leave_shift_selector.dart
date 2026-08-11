import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/shift_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/date_formatter.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../riverpod/apply_leave_provider/selected_shift_provider.dart';

class SelectShiftCard extends ConsumerWidget {
  const SelectShiftCard({
    super.key,
    required this.onTap,
    this.enabled = true,
  });

  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedShift = ref.watch(selectedShiftProvider);
    final spacing = context.dimensions.spacing;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: enabled
            ? context.color.onPrimary
            : context.color.borderSubtle.withValues(alpha: 0.1),
        border: Border.all(color: context.color.borderSubtle),
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.locale.selectShift,
            style: context.textStyle.titleSmall.copyWith(
              color: context.color.text.secondary,
            ),
          ),
          Gap(spacing.s12),
          _SelectedShiftRow(
            selectedShift: selectedShift,
            onTap: enabled ? onTap : null,
          ),
        ],
      ),
    );
  }
}

class _SelectedShiftRow extends StatelessWidget {
  const _SelectedShiftRow({required this.selectedShift, required this.onTap});

  final ShiftEntity? selectedShift;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final shift = selectedShift;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Icon(
            Icons.location_city_outlined,
            size: spacing.s30,
            color: context.color.icon,
          ),
          Gap(spacing.s8),
          Expanded(
            child: shift == null
                ? Text(
                    context.locale.selectShift,
                    style: context.textStyle.titleSmall.copyWith(
                      color: context.color.backgroundMuted,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shift.facility.name,
                        style: context.textStyle.titleSmall.copyWith(
                          color: context.color.text.secondary,
                        ),
                      ),
                      Gap(spacing.s4),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: spacing.s12,
                            color: context.color.text.secondary,
                          ),
                          Gap(spacing.s4),
                          Text(
                            DateFormatter.shiftDate(
                              DateTime.parse(shift.shiftDate),
                            ),
                            style: context.textStyle.bodySmall.copyWith(
                              color: context.color.text.secondary,
                            ),
                          ),
                          Gap(spacing.s8),
                          Icon(
                            Icons.access_time_outlined,
                            size: spacing.s12,
                            color: context.color.text.secondary,
                          ),
                          Gap(spacing.s4),
                          Text(
                            '${DateFormatter.shiftTime(shift.startTime)} – ${DateFormatter.shiftTime(shift.endTime)}',
                            style: context.textStyle.bodySmall.copyWith(
                              color: context.color.text.secondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            size: spacing.s30,
            color: context.color.primary,
          ),
        ],
      ),
    );
  }
}
