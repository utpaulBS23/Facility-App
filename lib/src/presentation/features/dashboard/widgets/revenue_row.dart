import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';
import 'dashboard_tone.dart';

/// A ranked facility revenue line: rank badge, name, amount, a progress bar
/// toward target and the change since last month.
class RevenueRow extends StatelessWidget {
  const RevenueRow({
    super.key,
    required this.rank,
    required this.name,
    required this.amountText,
    required this.percent,
    required this.percentText,
    required this.deltaText,
    required this.deltaPositive,
    this.tone,
    this.onTap,
  });

  final String rank;
  final String name;
  final String amountText;
  final num percent;

  /// The percent of target, formatted, e.g. "83%".
  final String percentText;

  /// e.g. "▲ 6% vs last month".
  final String deltaText;
  final bool deltaPositive;

  /// Colour of the rank badge and the bar. Defaults to green when
  /// [deltaPositive], else red.
  final DashboardTone? tone;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.color;
    final spacing = context.dimensions.spacing;
    final radius = BorderRadius.circular(context.dimensions.radius.r12);
    final tone =
        this.tone ?? (deltaPositive ? DashboardTone.green : DashboardTone.red);
    final deltaTone = deltaPositive ? DashboardTone.green : DashboardTone.red;
    final small = context.textStyle.labelSmall.copyWith(
      color: c.text.secondary,
      letterSpacing: 0,
    );

    return Material(
      color: c.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: c.borderSubtle),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          constraints: const BoxConstraints(minHeight: 44),
          padding: EdgeInsets.all(spacing.s12),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: tone.background(context),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  rank,
                  style: context.textStyle.labelMedium.copyWith(
                    color: tone.foreground(context),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: spacing.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: context.textStyle.labelMedium.copyWith(
                              color: c.text.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(width: spacing.s8),
                        Text(
                          amountText,
                          style: context.textStyle.labelMedium.copyWith(
                            color: c.text.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: spacing.s6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: Container(
                        height: 6,
                        color: c.subtle,
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: (percent.clamp(0, 100) / 100).toDouble(),
                          child: Container(color: tone.accent(context)),
                        ),
                      ),
                    ),
                    SizedBox(height: spacing.s6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            context.locale.percentOfTarget(percentText),
                            style: small,
                          ),
                        ),
                        SizedBox(width: spacing.s8),
                        Flexible(
                          child: Text(
                            deltaText,
                            textAlign: TextAlign.end,
                            style: small.copyWith(
                              color: deltaTone.foreground(context),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
