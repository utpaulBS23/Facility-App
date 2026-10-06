import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';
import 'dashboard_chart_common.dart';
import 'dashboard_tone.dart';

/// Line chart over named days, with an optional area fill and a dashed
/// target line. Tap a day to read its values.
class TrendChart extends StatefulWidget {
  const TrendChart({
    super.key,
    required this.title,
    required this.labels,
    required this.series,
    this.subtitle,
    this.valuePrefix = '',
  });

  final String title;
  final String? subtitle;

  /// One label per point, e.g. Mon..Sun.
  final List<String> labels;
  final List<ChartSeries> series;

  /// Put before each value in the readout, e.g. "৳ ".
  final String valuePrefix;

  @override
  State<TrendChart> createState() => _TrendChartState();
}

class _TrendChartState extends State<TrendChart> {
  static const _frame = ChartFrame();
  int? _selected;

  int get _sel {
    final last = widget.labels.length - 1;
    final s = _selected ?? last;
    return s > last ? last : s;
  }

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
    final sel = _sel;
    var max = 0.0;
    for (final s in widget.series) {
      for (final v in s.values) {
        if (v > max) max = v.toDouble();
      }
    }
    final scale = ChartScale(max);

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
                  valueText:
                      '${widget.valuePrefix}${context.numbers.integer(s.values[sel])}',
                  color: s.tone.accent(context),
                ),
            ],
          ),
          SizedBox(height: spacing.s12),
          LayoutBuilder(
            builder: (context, constraints) {
              return CustomPaint(
                size: Size(constraints.maxWidth, _frame.height),
                painter: _TrendPainter(
                  frame: _frame,
                  scale: scale,
                  series: widget.series,
                  colors: [
                    for (final s in widget.series) s.tone.accent(context),
                  ],
                  selected: sel,
                  gridColor: c.borderSubtle,
                  labelColor: c.text.secondary,
                  crosshair: c.border,
                  surface: c.onPrimary,
                  labelStyle: context.textStyle.labelSmall,
                  formatLabel: (v) => ChartScale.axisLabel(v, context.numbers),
                ),
              );
            },
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
                _LegendLine(
                  name: s.name,
                  color: s.tone.accent(context),
                  dashed: s.dashed,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendLine extends StatelessWidget {
  const _LegendLine({
    required this.name,
    required this.color,
    required this.dashed,
  });

  final String name;
  final Color color;
  final bool dashed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomPaint(
          size: const Size(16, 2),
          painter: _DashPainter(color: color, dashed: dashed),
        ),
        SizedBox(width: context.dimensions.spacing.s6),
        Text(
          name,
          style: context.textStyle.bodySmall.copyWith(
            color: context.color.text.primary,
          ),
        ),
      ],
    );
  }
}

class _DashPainter extends CustomPainter {
  _DashPainter({required this.color, required this.dashed});

  final Color color;
  final bool dashed;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;
    if (!dashed) {
      canvas.drawLine(
        Offset(0, size.height / 2),
        Offset(size.width, size.height / 2),
        paint,
      );
      return;
    }
    for (var x = 0.0; x < size.width; x += 5) {
      canvas.drawLine(
        Offset(x, size.height / 2),
        Offset((x + 3).clamp(0, size.width), size.height / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_DashPainter old) =>
      old.color != color || old.dashed != dashed;
}

class _TrendPainter extends CustomPainter {
  _TrendPainter({
    required this.frame,
    required this.scale,
    required this.series,
    required this.colors,
    required this.selected,
    required this.gridColor,
    required this.labelColor,
    required this.crosshair,
    required this.surface,
    required this.labelStyle,
    required this.formatLabel,
  });

  final ChartFrame frame;
  final ChartScale scale;
  final List<ChartSeries> series;
  final List<Color> colors;
  final int selected;
  final Color gridColor;
  final Color labelColor;
  final Color crosshair;
  final Color surface;
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

    final n = series.first.values.length;
    final pw = frame.plotWidth(size.width);
    double x(int i) => frame.left + (i + 0.5) * (pw / n);
    double y(num v) => frame.y(v.toDouble(), scale.top);

    canvas.drawLine(
      Offset(x(selected), frame.top),
      Offset(x(selected), y(0)),
      Paint()
        ..color = crosshair
        ..strokeWidth = 1,
    );

    for (var s = 0; s < series.length; s++) {
      final item = series[s];
      final color = colors[s];
      final path = Path();
      for (var i = 0; i < item.values.length; i++) {
        final p = Offset(x(i), y(item.values[i]));
        i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
      }
      if (item.area) {
        final fill = Path.from(path)
          ..lineTo(x(item.values.length - 1), y(0))
          ..lineTo(x(0), y(0))
          ..close();
        canvas.drawPath(fill, Paint()..color = color.withValues(alpha: 0.1));
      }
      final line = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      if (item.dashed) {
        for (final metric in path.computeMetrics()) {
          var d = 0.0;
          while (d < metric.length) {
            canvas.drawPath(metric.extractPath(d, d + 5), line);
            d += 9;
          }
        }
      } else {
        canvas.drawPath(path, line);
      }
    }

    for (var s = 0; s < series.length; s++) {
      final center = Offset(x(selected), y(series[s].values[selected]));
      canvas.drawCircle(center, 6, Paint()..color = surface);
      canvas.drawCircle(center, 4, Paint()..color = colors[s]);
    }
  }

  @override
  bool shouldRepaint(_TrendPainter old) =>
      old.selected != selected ||
      old.series != series ||
      old.colors != colors ||
      old.gridColor != gridColor;
}
