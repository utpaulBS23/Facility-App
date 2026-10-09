import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import 'dashboard_icons.dart';
import 'dashboard_meter.dart';

/// A facility name (tappable) over its target meter. Used inside
/// [ExecutiveCard]; for the full card see FacilityCard.
class FacilityRow extends StatelessWidget {
  const FacilityRow({
    super.key,
    required this.name,
    required this.meterLabel,
    required this.percent,
    required this.pctText,
    required this.footLeft,
    required this.footRight,
    this.onTap,
  });

  final String name;
  final String meterLabel;
  final num percent;
  final String pctText;
  final String footLeft;
  final String footRight;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.color;
    final spacing = context.dimensions.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 44),
            child: Row(
              children: [
                DashboardIcon(
                  DashboardIconPaths.pin,
                  color: c.primary,
                  size: 16,
                ),
                SizedBox(width: spacing.s8),
                Expanded(
                  child: Text(
                    name,
                    style: context.textStyle.labelMedium.copyWith(
                      color: c.text.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                DashboardIcon(
                  DashboardIconPaths.chevronRight,
                  color: c.text.secondary,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: spacing.s10),
        DashboardMeter(
          label: meterLabel,
          valueText: pctText,
          percent: percent,
          tone: DashboardMeter.toneForPercent(percent),
          footLeft: footLeft,
          footRight: footRight,
        ),
      ],
    );
  }
}
