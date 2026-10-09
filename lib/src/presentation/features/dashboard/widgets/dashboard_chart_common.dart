import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/extensions/app_numbers.dart';
import '../../../core/theme/theme.dart';
import 'dashboard_tone.dart';

/// One data series of a chart.
class ChartSeries {
  const ChartSeries({
    required this.name,
    required this.tone,
    required this.values,
    this.area = false,
    this.dashed = false,
  });

  final String name;
  final DashboardTone tone;
  final List<num> values;

  /// Trend chart: fill under the line.
  final bool area;

  /// Trend chart: dashed line, for a target.
  final bool dashed;
}

/// Y axis of a chart: a round top value, with grid lines at 0, half and top.
class ChartScale {
  ChartScale(num maxValue) : top = _roundTop(maxValue.toDouble());

  final double top;

  List<double> get ticks => [0, top / 2, top];

  static double _roundTop(double value) {
    // WHY: an all-zero chart still needs a non-zero axis to draw on.
    final max = value <= 0 ? 1.0 : value;
    final pow = math.pow(
      10,
      (math.log(max <= 0 ? 1 : max) / math.ln10).floor(),
    );
    final half = pow / 2;
    var steps = (max * 1.05 / half).ceil();
    if (steps.isOdd) steps += 1;
    return steps * half;
  }

  /// "2k", "1.5k", "800": short labels for the axis, in the app's digits.
  static String axisLabel(double v, AppNumbers numbers) {
    if (v < 1000) return numbers.integer(v.round());
    final thousands = (v / 1000 * 10).round() / 10;
    return '${numbers.number(thousands)}k';
  }
}

/// Plot-area geometry shared by the line and column charts, in the design's
/// 326x150 coordinate space.
class ChartFrame {
  const ChartFrame({
    this.height = 150,
    this.left = 36,
    this.right = 6,
    this.top = 10,
    this.bottom = 6,
  });

  final double height;
  final double left;
  final double right;
  final double top;
  final double bottom;

  double plotWidth(double width) => width - left - right;
  double get plotHeight => height - top - bottom;

  double y(double value, double scaleTop) =>
      top + plotHeight * (1 - value / scaleTop);
}

/// Draws the grid lines and Y labels of a chart.
void paintChartGrid(
  Canvas canvas,
  Size size,
  ChartFrame frame,
  ChartScale scale, {
  required Color lineColor,
  required Color labelColor,
  required TextStyle labelStyle,
  required String Function(double) formatLabel,
}) {
  final paint = Paint()
    ..color = lineColor
    ..strokeWidth = 1;
  for (final tick in scale.ticks) {
    final y = frame.y(tick, scale.top);
    canvas.drawLine(
      Offset(frame.left, y),
      Offset(size.width - frame.right, y),
      paint,
    );
    final tp = TextPainter(
      text: TextSpan(
        text: formatLabel(tick),
        style: labelStyle.copyWith(color: labelColor, fontSize: 10),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(frame.left - 6 - tp.width, y - tp.height / 2));
  }
}

/// Card shell shared by the three charts: title, subtitle and content.
class ChartCard extends StatelessWidget {
  const ChartCard({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.color;
    final spacing = context.dimensions.spacing;
    final subtitle = this.subtitle;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: c.onPrimary,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r16),
        border: Border.all(color: c.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.textStyle.labelLarge.copyWith(
              color: c.text.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (subtitle != null && subtitle.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: spacing.s2),
              child: Text(
                subtitle,
                style: context.textStyle.bodySmall.copyWith(
                  color: c.text.secondary,
                ),
              ),
            ),
          SizedBox(height: spacing.s12),
          child,
        ],
      ),
    );
  }
}

/// A value line of the readout box: coloured square, name and value.
class ReadoutEntry {
  const ReadoutEntry({
    required this.name,
    required this.valueText,
    required this.color,
  });

  final String name;
  final String valueText;
  final Color color;
}

/// The grey box above a chart that names the selected day and its values.
class ChartReadout extends StatelessWidget {
  const ChartReadout({super.key, required this.label, required this.entries});

  final String label;
  final List<ReadoutEntry> entries;

  @override
  Widget build(BuildContext context) {
    final c = context.color;
    final spacing = context.dimensions.spacing;
    final text = context.textStyle.bodySmall.copyWith(color: c.text.primary);

    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: spacing.s12,
          vertical: spacing.s10,
        ),
        decoration: BoxDecoration(
          color: c.subtle,
          borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: context.textStyle.labelMedium12.copyWith(
                color: c.text.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: spacing.s6),
            Wrap(
              spacing: spacing.s16,
              runSpacing: spacing.s4,
              children: [
                for (final e in entries)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: e.color,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      SizedBox(width: spacing.s6),
                      Text('${e.name} ', style: text),
                      Text(
                        e.valueText,
                        style: text.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// The row of tappable day labels under a chart, one per column.
class ChartDayButtons extends StatelessWidget {
  const ChartDayButtons({
    super.key,
    required this.labels,
    required this.selected,
    required this.onSelected,
    required this.frame,
  });

  final List<String> labels;
  final int selected;
  final ValueChanged<int> onSelected;
  final ChartFrame frame;

  @override
  Widget build(BuildContext context) {
    final c = context.color;

    return Padding(
      padding: EdgeInsets.only(left: frame.left, right: frame.right),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: Semantics(
                button: true,
                selected: i == selected,
                child: InkWell(
                  onTap: () => onSelected(i),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 44),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: i == selected ? c.brandAccent : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      labels[i],
                      style: context.textStyle.labelSmall.copyWith(
                        letterSpacing: 0,
                        color: i == selected ? c.text.brand : c.text.secondary,
                        fontWeight: i == selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
