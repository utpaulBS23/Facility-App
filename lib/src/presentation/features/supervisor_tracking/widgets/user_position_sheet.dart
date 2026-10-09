import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/user_tracking_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/status_dot_tag.dart';
import '../../../core/widgets/text/typography.dart';
import 'user_tracking_style.dart';

/// Details for a tapped user, shown as a bottom sheet.
class UserPositionSheet extends StatelessWidget {
  const UserPositionSheet({super.key, required this.position});

  final UserPositionEntity position;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final accuracy = position.accuracyText(context);
    final battery = position.batteryText(context);

    return Container(
      decoration: BoxDecoration(
        color: context.color.scaffoldBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(radius.r12)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.all(spacing.s16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.color.borderSubtle,
                    borderRadius: BorderRadius.circular(radius.r4),
                  ),
                ),
              ),
              Gap(spacing.s16),
              Row(
                children: [
                  Expanded(child: LabelLargeText(position.name)),
                  StatusDotTag(
                    label: position.statusLabel(context),
                    dotColor: position.statusColor(context),
                  ),
                ],
              ),
              Gap(spacing.s12),
              Divider(color: context.color.borderSubtle, height: 1),
              Gap(spacing.s12),
              _Row(
                label: context.locale.facility,
                value: position.facilityLabel(context),
              ),
              _Row(
                label: context.locale.activityLabel,
                value: position.activityLabel(context),
              ),
              _Row(
                label: context.locale.geofenceLabel,
                value: position.geofenceLabel(context),
              ),
              if (accuracy != null)
                _Row(label: context.locale.gpsLabel, value: accuracy),
              if (battery != null)
                _Row(
                  label: context.locale.batteryLabel,
                  value: battery,
                  valueColor: position.isBatteryLow
                      ? context.color.error
                      : null,
                ),
              _Row(
                label: context.locale.lastSeenLabel,
                value: DateFormatter.timestamp(position.recordedAt),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.dimensions.spacing.s12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 104,
            child: Text(
              label,
              style: context.textStyle.bodySmall.copyWith(
                color: context.color.text.secondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: context.textStyle.bodyMedium.copyWith(
                color: valueColor ?? context.color.text.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
