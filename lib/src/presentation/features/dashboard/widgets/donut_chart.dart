import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';
import 'dashboard_chart_common.dart';
import 'dashboard_tone.dart';

/// One slice of the donut.
class DonutSlice {
  const DonutSlice({
    required this.label,
    required this.value,
    required this.tone,
  });

  final String label;
  final int value;
  final DashboardTone tone;
}

/// Donut with the total in the middle and a legend of value and share.
class DonutChart extends StatelessWidget {
  const DonutChart({
    super.key,
    required this.title,
    required this.slices,
    required this.centerLabel,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final List<DonutSlice> slices;

  /// Small text under the total, e.g. "issues".
  final String centerLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.color;
    final spacing = context.dimensions.spacing;
    final numbers = context.numbers;
    final total = slices.fold<int>(0, (a, s) => a + s.value);
    final divisor = total == 0 ? 1 : total;

    return ChartCard(
      title: title,
      subtitle: subtitle,
      child: Row(
        children: [
          SizedBox(
            width: 132,
            height: 132,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(132, 132),
                  painter: _DonutPainter(
                    values: [for (final s in slices) s.value],
                    colors: [for (final s in slices) s.tone.accent(context)],
                    gap: c.onPrimary,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      numbers.integer(total),
                      style: context.textStyle.headlineSmall.copyWith(
                        color: c.text.primary,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      centerLabel,
                      style: context.textStyle.labelSmall.copyWith(
                        color: c.text.secondary,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: spacing.s16),
          Expanded(
            child: Column(
              children: [
                for (var i = 0; i < slices.length; i++) ...[
                  if (i > 0) SizedBox(height: spacing.s8),
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: slices[i].tone.accent(context),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      SizedBox(width: spacing.s8),
                      Expanded(
                        child: Text(
                          slices[i].label,
                          style: context.textStyle.bodySmall.copyWith(
                            color: c.text.primary,
                          ),
                        ),
                      ),
                      Text(
                        numbers.integer(slices[i].value),
                        style: context.textStyle.bodySmall.copyWith(
                          color: c.text.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        width: 38,
                        child: Text(
                          numbers.percent(
                            (slices[i].value / divisor * 100).round(),
                          ),
                          textAlign: TextAlign.end,
                          style: context.textStyle.bodySmall.copyWith(
                            color: c.text.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter({
    required this.values,
    required this.colors,
    required this.gap,
  });

  final List<int> values;
  final List<Color> colors;

  /// The surface colour, drawn as a thin gap between slices.
  final Color gap;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    const outer = 62.0;
    const inner = 38.0;
    final total = values.fold<int>(0, (a, v) => a + v);
    if (total == 0) return;

    var start = -math.pi / 2;
    for (var i = 0; i < values.length; i++) {
      if (values[i] <= 0) continue;
      final sweep = values[i] / total * 2 * math.pi;
      final path = Path()
        ..arcTo(
          Rect.fromCircle(center: center, radius: outer),
          start,
          sweep,
          true,
        )
        ..arcTo(
          Rect.fromCircle(center: center, radius: inner),
          start + sweep,
          -sweep,
          false,
        )
        ..close();
      canvas.drawPath(path, Paint()..color = colors[i]);
      canvas.drawPath(
        path,
        Paint()
          ..color = gap
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeJoin = StrokeJoin.round,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(_DonutPainter old) =>
      old.values != values || old.colors != colors || old.gap != gap;
}
