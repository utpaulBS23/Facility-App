import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';
import 'dashboard_chart_common.dart';
import 'dashboard_tone.dart';

enum ColumnChartMode { stacked, grouped }

/// Column chart over named days: series stacked into one bar per day, or
/// side by side. Tap a day to read its values; other days are dimmed.
class ColumnChart extends StatefulWidget {
  const ColumnChart({
    super.key,
    required this.title,
    required this.labels,
    required this.series,
    this.subtitle,
    this.mode = ColumnChartMode.stacked,
    this.valuePrefix = '',
  });

  final String title;
  final String? subtitle;
  final List<String> labels;
  final List<ChartSeries> series;
  final ColumnChartMode mode;
  final String valuePrefix;

  @override
  State<ColumnChart> createState() => _ColumnChartState();
}

class _ColumnChartState extends State<ColumnChart> {
  static const _frame = ChartFrame();
  int? _selected;

  @override
  Widget build(BuildContext context) {
    final c = context.color;
    final spacing = context.dimensions.spacing;
    final labels = widget.labels;
    if (labels.isEmpty || widget.series.isEmpty) {
      return ChartCard(
        title: widget.title,
        subtitle: widget.subtitle,
        child: const SizedBox.shrink(),
      );
    }
    final stacked = widget.mode == ColumnChartMode.stacked;
    final sel = math.min(_selected ?? labels.length - 1, labels.length - 1);
    final totals = [
      for (var i = 0; i < labels.length; i++)
        widget.series.fold<num>(0, (a, s) => a + s.values[i]),
    ];
    var max = 0.0;
    if (stacked) {
      for (final t in totals) {
        if (t > max) max = t.toDouble();
      }
    } else {
      for (final s in widget.series) {
        for (final v in s.values) {
          if (v > max) max = v.toDouble();
        }
      }
    }
    final scale = ChartScale(max);
    final numbers = context.numbers;
    String fmt(num v) => '${widget.valuePrefix}${numbers.integer(v)}';

    return ChartCard(
      title: widget.title,
      subtitle: widget.subtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChartReadout(
            label: labels[sel],
            entries: [
              for (final s in widget.series)
                ReadoutEntry(
                  name: s.name,
                  valueText: fmt(s.values[sel]),
                  color: s.tone.accent(context),
                ),
              if (stacked)
                ReadoutEntry(
                  name: context.locale.total,
                  valueText: fmt(totals[sel]),
                  color: c.text.primary,
                ),
            ],
          ),
          SizedBox(height: spacing.s12),
          LayoutBuilder(
            builder: (context, constraints) => CustomPaint(
              size: Size(constraints.maxWidth, _frame.height),
              painter: _ColumnPainter(
                frame: _frame,
                scale: scale,
                series: widget.series,
                colors: [for (final s in widget.series) s.tone.accent(context)],
                labelCount: labels.length,
                stacked: stacked,
                selected: sel,
                gridColor: c.borderSubtle,
                labelColor: c.text.secondary,
                labelStyle: context.textStyle.labelSmall,
                formatLabel: (v) => ChartScale.axisLabel(v, context.numbers),
              ),
            ),
          ),
          SizedBox(height: spacing.s4),
          ChartDayButtons(
            labels: labels,
            selected: sel,
            frame: _frame,
            onSelected: (i) => setState(() => _selected = i),
          ),
          SizedBox(height: spacing.s12),
          Wrap(
            spacing: spacing.s16,
            runSpacing: spacing.s6,
            children: [
              for (final s in widget.series)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: s.tone.accent(context),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    SizedBox(width: spacing.s6),
                    Text(
                      s.name,
                      style: context.textStyle.bodySmall.copyWith(
                        color: c.text.primary,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ColumnPainter extends CustomPainter {
  _ColumnPainter({
    required this.frame,
    required this.scale,
    required this.series,
    required this.colors,
    required this.labelCount,
    required this.stacked,
    required this.selected,
    required this.gridColor,
    required this.labelColor,
    required this.labelStyle,
    required this.formatLabel,
  });

  final ChartFrame frame;
  final ChartScale scale;
  final List<ChartSeries> series;
  final List<Color> colors;
  final int labelCount;
  final bool stacked;
  final int selected;
  final Color gridColor;
  final Color labelColor;
  final TextStyle labelStyle;
  final String Function(double) formatLabel;

  @override
  void paint(Canvas canvas, Size size) {
    paintChartGrid(
      canvas,
      size,
      frame,
      scale,
      lineColor: gridColor,
      labelColor: labelColor,
      labelStyle: labelStyle,
      formatLabel: formatLabel,
    );

    final pw = frame.plotWidth(size.width);
    final group = pw / labelCount;
    final base = frame.y(0, scale.top);
    double y(num v) => frame.y(v.toDouble(), scale.top);

    for (var i = 0; i < labelCount; i++) {
      final opacity = i == selected ? 1.0 : 0.45;
      final cx = frame.left + (i + 0.5) * group;

      if (stacked) {
        final width = math.min(22.0, group * 0.55);
        num acc = 0;
        for (var s = 0; s < series.length; s++) {
          final v = series[s].values[i];
          final top = y(acc + v);
          final bottom = y(acc);
          _bar(
            canvas,
            cx - width / 2,
            top,
            width,
            bottom - top - 2,
            colors[s],
            opacity,
          );
          acc += v;
        }
      } else {
        final k = series.length;
        final width = math.min(14.0, (group * 0.8 - (k - 1) * 2) / k);
        final total = k * width + (k - 1) * 2;
        for (var s = 0; s < k; s++) {
          final top = y(series[s].values[i]);
          _bar(
            canvas,
            cx - total / 2 + s * (width + 2),
            top,
            width,
            base - top,
            colors[s],
            opacity,
          );
        }
      }
    }
  }

  void _bar(
    Canvas canvas,
    double x,
    double y,
    double w,
    double h,
    Color color,
    double opacity,
  ) {
    if (h <= 0) return;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, w, h),
        const Radius.circular(3),
      ),
      Paint()..color = color.withValues(alpha: opacity),
    );
  }

  @override
  bool shouldRepaint(_ColumnPainter old) =>
      old.selected != selected ||
      old.series != series ||
      old.colors != colors ||
      old.stacked != stacked ||
      old.gridColor != gridColor;
}
