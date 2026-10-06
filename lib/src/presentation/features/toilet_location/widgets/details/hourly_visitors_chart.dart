import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';

/// One hour of the day with its visitor count.
class HourlyVisit {
  const HourlyVisit({
    required this.hour,
    required this.count,
    this.peak = false,
  });

  /// 0-23.
  final int hour;
  final int count;
  final bool peak;
}

/// Bars of visitors per hour, peak hours in the brand colour, with a few hour
/// labels under the bars.
class HourlyVisitorsChart extends StatelessWidget {
  const HourlyVisitorsChart({
    super.key,
    required this.title,
    required this.peakLabel,
    required this.visits,
    this.labelHours = const [6, 10, 14, 18, 22],
    this.height = 56,
  });

  final String title;

  /// Legend text for the coloured bars, e.g. "Peak".
  final String peakLabel;
  final List<HourlyVisit> visits;

  /// Hours that get a label under their bar.
  final List<int> labelHours;
  final double height;

  /// "6a", "10a", "12p", "2p": the short hour label.
  static String hourLabel(int hour) {
    final suffix = hour < 12 ? 'a' : 'p';
    final h = hour % 12 == 0 ? 12 : hour % 12;
    return '$h$suffix';
  }

  @override
  Widget build(BuildContext context) {
    final c = context.color;
    final spacing = context.dimensions.spacing;
    final small = context.textStyle.bodySmall.copyWith(color: c.text.secondary);
    final max = visits.fold<int>(1, (a, v) => v.count > a ? v.count : a);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(title, style: small)),
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: c.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(width: spacing.s6),
            Text(peakLabel, style: small),
          ],
        ),
        SizedBox(height: spacing.s12),
        SizedBox(
          height: height,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final v in visits)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Container(
                      height: (height * v.count / max).clamp(4, height),
                      decoration: BoxDecoration(
                        color: v.peak ? c.primary : c.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: spacing.s6),
        SizedBox(
          height: 16,
          child: Row(
            children: [
              for (final v in visits)
                Expanded(
                  child: labelHours.contains(v.hour)
                      ? OverflowBox(
                          maxWidth: 40,
                          maxHeight: 16,
                          child: Text(
                            hourLabel(v.hour),
                            textAlign: TextAlign.center,
                            style: small,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
