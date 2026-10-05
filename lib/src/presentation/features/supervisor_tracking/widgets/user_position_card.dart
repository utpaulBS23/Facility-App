import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/user_tracking_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/status_dot_tag.dart';
import '../../../core/widgets/text/typography.dart';
import 'user_tracking_style.dart';

/// One user in the list under the map.
class UserPositionCard extends StatelessWidget {
  const UserPositionCard({
    super.key,
    required this.position,
    required this.selected,
    required this.onTap,
  });

  final UserPositionEntity position;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = BorderRadius.circular(context.dimensions.radius.r12);
    final accuracy = position.accuracyText(context);
    final battery = position.batteryText(context);

    return InkWell(
      onTap: onTap,
      borderRadius: radius,
      child: Container(
        padding: EdgeInsets.all(spacing.s12),
        decoration: BoxDecoration(
          color: context.color.onPrimary,
          borderRadius: radius,
          border: Border.all(
            color: selected
                ? context.color.primary
                : context.color.borderSubtle,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: LabelLargeText(position.name)),
                StatusDotTag(
                  label: position.statusLabel(context),
                  dotColor: position.statusColor(context),
                ),
              ],
            ),
            SizedBox(height: spacing.s4),
            Text(
              position.facilityLabel(context),
              style: context.textStyle.bodySmall.copyWith(
                color: context.color.text.secondary,
              ),
            ),
            SizedBox(height: spacing.s8),
            Wrap(
              spacing: spacing.s16,
              runSpacing: spacing.s8,
              children: [
                _Field(
                  label: context.locale.activityLabel,
                  value: position.activityLabel(context),
                ),
                _Field(
                  label: context.locale.geofenceLabel,
                  value: position.geofenceLabel(context),
                  valueColor: position.geofenceColor(context),
                ),
                if (accuracy != null)
                  _Field(label: context.locale.gpsLabel, value: accuracy),
                if (battery != null)
                  _Field(
                    label: context.locale.batteryLabel,
                    value: battery,
                    valueColor: position.isBatteryLow
                        ? context.color.error
                        : null,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: context.textStyle.bodySmall.copyWith(
            color: context.color.text.secondary,
          ),
        ),
        Text(
          value,
          style: context.textStyle.labelMedium.copyWith(
            color: valueColor ?? context.color.text.primary,
          ),
        ),
      ],
    );
  }
}
