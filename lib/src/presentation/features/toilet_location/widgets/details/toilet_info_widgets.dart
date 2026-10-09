import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../dashboard/widgets/dashboard_tone.dart';

/// A one-line note in a tinted box with a leading icon: grey for plain
/// information, or a tone such as green for a good state.
class ToiletInfoNote extends StatelessWidget {
  const ToiletInfoNote({
    super.key,
    required this.icon,
    required this.child,
    this.tone = DashboardTone.neutral,
  });

  final IconData icon;
  final Widget child;
  final DashboardTone tone;

  /// Convenience: a bold [label] followed by a value.
  static Widget labelled(BuildContext context, String label, String value) {
    final c = context.color;
    return Text.rich(
      TextSpan(
        text: '$label  ',
        style: context.textStyle.bodyMedium.copyWith(color: c.text.secondary),
        children: [
          TextSpan(
            text: value,
            style: context.textStyle.labelLarge.copyWith(
              color: c.text.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final fg = tone == DashboardTone.neutral
        ? context.color.text.secondary
        : tone.foreground(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: spacing.s12,
        vertical: spacing.s10,
      ),
      decoration: BoxDecoration(
        color: tone.background(context),
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: fg),
          SizedBox(width: spacing.s10),
          Expanded(child: child),
        ],
      ),
    );
  }
}

/// Two-number tile: a small caption, a large value and a footnote, tinted by
/// [tone]. Used for the income target and monthly goal.
class ToiletGoalBox extends StatelessWidget {
  const ToiletGoalBox({
    super.key,
    required this.label,
    required this.value,
    required this.footnote,
    required this.tone,
  });

  final String label;
  final String value;
  final String footnote;
  final DashboardTone tone;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final fg = tone.foreground(context);

    return Container(
      padding: EdgeInsets.all(spacing.s12),
      decoration: BoxDecoration(
        color: tone.background(context),
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        border: Border.all(color: tone.accent(context).withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.textStyle.labelMedium12.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: spacing.s8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
          SizedBox(height: spacing.s8),
          Text(
            footnote,
            style: context.textStyle.bodySmall.copyWith(color: fg),
          ),
        ],
      ),
    );
  }
}

/// A management fact: tinted icon, a label and its value on the right, with
/// an optional coloured dot before the value.
class ToiletInfoRow extends StatelessWidget {
  const ToiletInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.valueTone,
  });

  final IconData icon;
  final String label;
  final String value;

  /// Colours the value and puts a dot before it.
  final DashboardTone? valueTone;

  @override
  Widget build(BuildContext context) {
    final c = context.color;
    final spacing = context.dimensions.spacing;
    final tone = valueTone;
    final valueColor = tone == null ? c.text.primary : tone.foreground(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.s12,
        vertical: spacing.s12,
      ),
      decoration: BoxDecoration(
        color: c.subtle,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: c.brandAccent,
              borderRadius: BorderRadius.circular(
                context.dimensions.radius.r10,
              ),
            ),
            child: Icon(icon, size: 18, color: c.primary),
          ),
          SizedBox(width: spacing.s12),
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: context.textStyle.bodyMedium.copyWith(
                color: c.text.secondary,
              ),
            ),
          ),
          if (tone != null) ...[
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: tone.accent(context),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: spacing.s6),
          ],
          // WHY a share and right-aligned: a long value (opening hours, open
          // days) wraps instead of overflowing the row.
          Expanded(
            flex: 2,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: context.textStyle.labelLarge.copyWith(
                color: valueColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
