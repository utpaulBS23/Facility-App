import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';
import 'dashboard_icons.dart';
import 'dashboard_meter.dart';
import 'dashboard_stat_tile.dart';
import 'dashboard_tone.dart';

/// Everything one facility card shows. Texts are already formatted and
/// localised; counts are raw so the card can compute the visitor split.
class FacilityCardData {
  const FacilityCardData({
    required this.name,
    required this.percent,
    required this.pctText,
    required this.achievedText,
    required this.targetText,
    required this.expenseText,
    required this.maleCount,
    required this.femaleCount,
    required this.maleText,
    required this.femaleText,
    required this.totalVisitorsText,
    required this.inProgressText,
    required this.completedText,
    required this.pendingText,
    this.aqiText,
    this.aqiLabel,
    this.aqiTone,
  });

  final String name;
  final num percent;
  final String pctText;
  final String achievedText;
  final String targetText;
  final String expenseText;
  final int maleCount;
  final int femaleCount;

  /// e.g. "142 (60%)".
  final String maleText;
  final String femaleText;

  /// e.g. "238 total".
  final String totalVisitorsText;
  final String inProgressText;
  final String completedText;
  final String pendingText;

  /// Air quality is optional: the API sends only a placeholder for now, so a
  /// null [aqiText] hides the box and the expense box takes the full row.
  final String? aqiText;
  final String? aqiLabel;
  final DashboardTone? aqiTone;
}

/// Full facility card: target meter, expense, air quality, visitor split and
/// issue counts.
class FacilityCard extends StatelessWidget {
  const FacilityCard({super.key, required this.data, this.onTap});

  final FacilityCardData data;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.color;
    final spacing = context.dimensions.spacing;
    final locale = context.locale;
    final total = data.maleCount + data.femaleCount;
    final malePct = total == 0 ? 0 : (data.maleCount / total * 100).round();
    final aqTone = data.aqiTone ?? DashboardTone.neutral;
    final aqText = data.aqiText;

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
          InkWell(
            onTap: onTap,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 44),
              child: Row(
                children: [
                  DashboardIcon(
                    DashboardIconPaths.pin,
                    color: c.primary,
                    size: 18,
                  ),
                  SizedBox(width: spacing.s8),
                  Expanded(
                    child: Text(
                      data.name,
                      style: context.textStyle.labelLarge.copyWith(
                        color: c.text.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  DashboardIcon(
                    DashboardIconPaths.chevronRight,
                    color: c.text.secondary,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: spacing.s14),
          DashboardMeter(
            label: locale.targetVsAchievement,
            valueText: data.pctText,
            percent: data.percent,
            tone: DashboardMeter.toneForPercent(data.percent),
            footLeft: data.achievedText,
            footRight: data.targetText,
          ),
          SizedBox(height: spacing.s14),
          Row(
            children: [
              Expanded(
                child: _InfoBox(
                  label: locale.facilityExpense,
                  background: c.subtle,
                  foreground: c.text.primary,
                  labelColor: c.text.secondary,
                  value: data.expenseText,
                ),
              ),
              if (aqText != null) ...[
                SizedBox(width: spacing.s10),
                Expanded(
                  child: _InfoBox(
                    label: locale.airQuality,
                    background: aqTone.background(context),
                    foreground: aqTone.foreground(context),
                    labelColor: aqTone.foreground(context),
                    value: aqText,
                    suffix: data.aqiLabel,
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: spacing.s14),
          _VisitorSplit(
            totalText: data.totalVisitorsText,
            malePct: malePct,
            maleText: data.maleText,
            femaleText: data.femaleText,
          ),
          SizedBox(height: spacing.s14),
          Text(
            locale.issueSummary,
            style: context.textStyle.bodySmall.copyWith(
              color: c.text.secondary,
            ),
          ),
          SizedBox(height: spacing.s8),
          Row(
            children: [
              Expanded(
                child: DashboardStatTile(
                  value: data.inProgressText,
                  label: locale.inProgress,
                  tone: DashboardTone.orange,
                  compact: true,
                ),
              ),
              SizedBox(width: spacing.s8),
              Expanded(
                child: DashboardStatTile(
                  value: data.completedText,
                  label: locale.completed,
                  tone: DashboardTone.green,
                  compact: true,
                ),
              ),
              SizedBox(width: spacing.s8),
              Expanded(
                child: DashboardStatTile(
                  value: data.pendingText,
                  label: locale.pending,
                  tone: DashboardTone.red,
                  compact: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  const _InfoBox({
    required this.label,
    required this.value,
    required this.background,
    required this.foreground,
    required this.labelColor,
    this.suffix,
  });

  final String label;
  final String value;
  final String? suffix;
  final Color background;
  final Color foreground;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Container(
      padding: EdgeInsets.all(spacing.s12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.textStyle.bodySmall.copyWith(color: labelColor),
          ),
          SizedBox(height: spacing.s4),
          Text.rich(
            TextSpan(
              text: value,
              children: [
                if (suffix != null)
                  TextSpan(
                    text: ' $suffix',
                    style: context.textStyle.labelMedium12.copyWith(
                      color: foreground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
            style: context.textStyle.labelXl.copyWith(
              color: foreground,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _VisitorSplit extends StatelessWidget {
  const _VisitorSplit({
    required this.totalText,
    required this.malePct,
    required this.maleText,
    required this.femaleText,
  });

  final String totalText;
  final int malePct;
  final String maleText;
  final String femaleText;

  @override
  Widget build(BuildContext context) {
    final c = context.color;
    final spacing = context.dimensions.spacing;
    final locale = context.locale;
    final small = context.textStyle.bodySmall.copyWith(color: c.text.secondary);
    final legend = context.textStyle.bodySmall.copyWith(color: c.text.primary);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(locale.visitorsPerDay, style: small),
            Text(
              totalText,
              style: small.copyWith(
                color: c.text.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        SizedBox(height: spacing.s8),
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: SizedBox(
            height: 10,
            child: Row(
              children: [
                Expanded(
                  flex: malePct,
                  child: Container(color: c.info),
                ),
                SizedBox(width: malePct == 0 || malePct == 100 ? 0 : 2),
                Expanded(
                  flex: 100 - malePct,
                  child: Container(color: c.primary),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: spacing.s8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: _LegendDot(
                color: c.info,
                text: '${locale.male} $maleText',
                style: legend,
              ),
            ),
            SizedBox(width: spacing.s8),
            Flexible(
              child: _LegendDot(
                color: c.primary,
                text: '${locale.female} $femaleText',
                style: legend,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({
    required this.color,
    required this.text,
    required this.style,
  });

  final Color color;
  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: context.dimensions.spacing.s6),
        Flexible(child: Text(text, style: style)),
      ],
    );
  }
}
