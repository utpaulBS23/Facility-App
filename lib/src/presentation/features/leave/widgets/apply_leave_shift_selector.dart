import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/form_selector_card.dart';
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

    return FormSelectorCard(
      title: context.locale.selectShift,
      icon: Icons.location_city_outlined,
      enabled: enabled,
      onTap: onTap,
      content: selectedShift == null
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
                  selectedShift.facility.name,
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
                        DateTime.parse(selectedShift.shiftDate),
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
                      '${DateFormatter.shiftTime(selectedShift.startTime)} – ${DateFormatter.shiftTime(selectedShift.endTime)}',
                      style: context.textStyle.bodySmall.copyWith(
                        color: context.color.text.secondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
