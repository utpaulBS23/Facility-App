import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../dashboard/widgets/dashboard_tone.dart';

/// A label on the left and an amount on the right, with a hairline under it.
class ReportLineRow extends StatelessWidget {
  const ReportLineRow({
    super.key,
    required this.label,
    required this.value,
    this.showDivider = true,
    this.compact = false,
  });

  final String label;
  final String value;
  final bool showDivider;

  /// Smaller text, for the two narrow side-by-side cards.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final c = context.color;
    final spacing = context.dimensions.spacing;
    final labelStyle = (compact
        ? context.textStyle.bodySmall
        : context.textStyle.bodyMedium);

    return Container(
      padding: EdgeInsets.symmetric(vertical: spacing.s12),
      decoration: BoxDecoration(
        border: showDivider
            ? Border(bottom: BorderSide(color: c.borderSubtle))
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: labelStyle.copyWith(color: c.text.primary),
            ),
          ),
          SizedBox(width: spacing.s8),
          Text(
            value,
            style:
                (compact
                        ? context.textStyle.labelMedium12
                        : context.textStyle.labelLarge)
                    .copyWith(
                      color: c.text.primary,
                      fontWeight: FontWeight.w700,
                    ),
          ),
        ],
      ),
    );
  }
}

/// The closing line of a table: a small capital label and the total, both in
/// [tone] (the brand colour when null).
class ReportTotalRow extends StatelessWidget {
  const ReportTotalRow({
    super.key,
    required this.label,
    required this.value,
    this.tone,
    this.compact = false,
  });

  final String label;
  final String value;
  final DashboardTone? tone;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final c = context.color;
    final spacing = context.dimensions.spacing;
    final tone = this.tone;
    final labelColor = tone == null ? c.text.brand : tone.foreground(context);
    final valueColor = tone == null ? c.text.primary : labelColor;

    return Padding(
      padding: EdgeInsets.only(top: spacing.s12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: context.textStyle.labelMedium12.copyWith(
                color: labelColor,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
          ),
          SizedBox(width: spacing.s8),
          Text(
            value,
            style:
                (compact
                        ? context.textStyle.labelMedium12
                        : context.textStyle.labelLarge)
                    .copyWith(color: valueColor, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

/// One half of a [ReportStatPairRow].
class ReportStat {
  const ReportStat({
    required this.label,
    required this.value,
    this.strong = true,
  });

  final String label;
  final String value;

  /// Bold label for a main figure; plain for a "including women" line.
  final bool strong;
}

/// Two figures side by side, each a label and a number, as in the
/// subscribers table.
class ReportStatPairRow extends StatelessWidget {
  const ReportStatPairRow({
    super.key,
    required this.left,
    required this.right,
    this.showDivider = true,
  });

  final ReportStat left;
  final ReportStat right;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final c = context.color;
    final spacing = context.dimensions.spacing;

    Widget half(ReportStat s) => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            s.label,
            style:
                (s.strong
                        ? context.textStyle.labelLarge
                        : context.textStyle.bodySmall)
                    .copyWith(
                      color: s.strong ? c.text.primary : c.text.secondary,
                      fontWeight: s.strong ? FontWeight.w700 : FontWeight.w400,
                    ),
          ),
        ),
        SizedBox(width: spacing.s4),
        Text(
          s.value,
          style: context.textStyle.labelLarge.copyWith(
            color: c.text.primary,
            fontWeight: s.strong ? FontWeight.w400 : FontWeight.w700,
          ),
        ),
      ],
    );

    return Container(
      padding: EdgeInsets.symmetric(vertical: spacing.s10),
      decoration: BoxDecoration(
        border: showDivider
            ? Border(bottom: BorderSide(color: c.borderSubtle))
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: half(left)),
          SizedBox(width: spacing.s16),
          Expanded(child: half(right)),
        ],
      ),
    );
  }
}
