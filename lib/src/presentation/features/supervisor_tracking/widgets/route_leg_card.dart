import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/user_route_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/text/typography.dart';

/// Colours cycled through for the legs of a route.
const _legColors = [
  Color(0xFF1E88E5),
  Color(0xFF8E24AA),
  Color(0xFFFB8C00),
  Color(0xFF00897B),
  Color(0xFFD81B60),
];

Color routeLegColor(int index) => _legColors[index % _legColors.length];

/// One journey between two visits, in the list under the route map.
class RouteLegCard extends StatelessWidget {
  const RouteLegCard({
    super.key,
    required this.index,
    required this.leg,
    required this.selected,
    required this.onTap,
  });

  final int index;
  final RouteLegEntity leg;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = BorderRadius.circular(context.dimensions.radius.r12);
    final locale = context.locale;
    final from = leg.fromName.isEmpty ? locale.unassigned : leg.fromName;
    final to = leg.toName.isEmpty ? locale.unassigned : leg.toName;
    final fromTime = leg.fromTime;
    final toTime = leg.toTime;
    final times = [
      if (fromTime != null) DateFormatter.timeOnly(fromTime),
      if (toTime != null) DateFormatter.timeOnly(toTime),
    ].join(' → ');

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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: routeLegColor(index),
                shape: BoxShape.circle,
              ),
              child: Text(
                context.numbers.integer(index + 1),
                style: context.textStyle.labelSmall.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: spacing.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabelLargeText('$from → $to'),
                  if (times.isNotEmpty) ...[
                    SizedBox(height: spacing.s4),
                    Text(
                      times,
                      style: context.textStyle.bodySmall.copyWith(
                        color: context.color.text.secondary,
                      ),
                    ),
                  ],
                  SizedBox(height: spacing.s4),
                  Text(
                    leg.trail.isEmpty
                        ? locale.noGpsTrail
                        : locale.gpsPointsCount(
                            context.numbers.integer(leg.trail.length),
                          ),
                    style: context.textStyle.bodySmall.copyWith(
                      color: context.color.text.secondary,
                    ),
                  ),
                  if (leg.hasTravelExpense) ...[
                    SizedBox(height: spacing.s4),
                    Text(
                      locale.travelClaimFiled,
                      style: context.textStyle.labelMedium.copyWith(
                        color: context.color.success,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
