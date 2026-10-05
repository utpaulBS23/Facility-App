import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/facility_map_entity.dart';
import '../../../core/theme/theme.dart';
import 'tracking_status_style.dart';

/// Collapsible legend card laid over the map.
class TrackingLegend extends StatefulWidget {
  const TrackingLegend({super.key});

  @override
  State<TrackingLegend> createState() => _TrackingLegendState();
}

class _TrackingLegendState extends State<TrackingLegend> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final decoration = BoxDecoration(
      color: context.color.onPrimary,
      borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
      border: Border.all(color: context.color.borderSubtle),
    );

    if (!_expanded) {
      return GestureDetector(
        onTap: () => setState(() => _expanded = true),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.s12,
            vertical: spacing.s8,
          ),
          decoration: decoration,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 16,
                color: context.color.text.secondary,
              ),
              SizedBox(width: spacing.s4),
              Text(
                context.locale.mapLegend,
                style: context.textStyle.labelMedium,
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(spacing.s12),
      decoration: decoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => setState(() => _expanded = false),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.locale.mapLegend,
                  style: context.textStyle.labelLarge,
                ),
                SizedBox(width: spacing.s8),
                const Icon(Icons.close_rounded, size: 16),
              ],
            ),
          ),
          SizedBox(height: spacing.s8),
          Text(
            context.locale.facilities,
            style: context.textStyle.labelMedium.copyWith(
              color: context.color.text.secondary,
            ),
          ),
          _LegendRow(
            color: context.color.primary,
            label: context.locale.active,
          ),
          SizedBox(height: spacing.s8),
          Text(
            context.locale.attendant,
            style: context.textStyle.labelMedium.copyWith(
              color: context.color.text.secondary,
            ),
          ),
          for (final status in StaffPinStatus.values)
            _LegendRow(
              color: status.color(context),
              label: status.label(context),
            ),
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: context.dimensions.spacing.s4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: context.dimensions.spacing.s8),
          Text(label, style: context.textStyle.bodySmall),
        ],
      ),
    );
  }
}
