part of '../view/profit_report_page.dart';

class _IncentiveCalculationCard extends StatelessWidget {
  const _IncentiveCalculationCard({
    required this.subtitle,
    required this.tiers,
    required this.totalIncentiveText,
    this.notApplicableNote,
    this.fineAlertnessMessage,
    this.fineAlertnessAmountNote,
  });

  final String subtitle;
  final List<IncentiveTierEntity> tiers;
  final String totalIncentiveText;
  final String? notApplicableNote;
  final String? fineAlertnessMessage;
  final String? fineAlertnessAmountNote;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        border: Border.all(color: color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(spacing.s8),
                decoration: BoxDecoration(
                  color: color.brandSubtle,
                  borderRadius: BorderRadius.circular(radius.r10),
                ),
                child: Icon(
                  Icons.military_tech_outlined,
                  color: color.primary,
                  size: spacing.s20,
                ),
              ),
              Gap(spacing.s10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.locale.incentiveCalculation,
                      style: context.textStyle.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: context.textStyle.bodySmall.copyWith(
                        color: color.text.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(spacing.s16),
          for (final tier in tiers) ...[
            _IncentiveTierRow(tier: tier),
            Gap(spacing.s10),
          ],
          if (notApplicableNote != null) ...[
            _IncentiveNotApplicableRow(subtitle: notApplicableNote!),
            Gap(spacing.s10),
          ],
          if (fineAlertnessMessage != null &&
              fineAlertnessAmountNote != null) ...[
            _FineAlertnessCard(
              message: fineAlertnessMessage!,
              amountNote: fineAlertnessAmountNote!,
            ),
            Gap(spacing.s10),
          ],
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.s16,
              vertical: spacing.s14,
            ),
            decoration: BoxDecoration(
              // WHY gray, not brand: a ৳0 total means no tier was met —
              // the bar should read as inactive, not as an achieved amount.
              color: totalIncentiveText == '৳0'
                  ? color.backgroundMuted
                  : color.primary,
              borderRadius: BorderRadius.circular(radius.r12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.military_tech_outlined,
                      color: color.onPrimary,
                      size: spacing.s20,
                    ),
                    Gap(spacing.s8),
                    Text(
                      context.locale.totalIncentive,
                      style: context.textStyle.bodyMedium.copyWith(
                        color: color.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  totalIncentiveText,
                  style: context.textStyle.titleMedium.copyWith(
                    color: color.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IncentiveTierRow extends StatelessWidget {
  const _IncentiveTierRow({required this.tier});

  final IncentiveTierEntity tier;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;
    // WHY two active styles: a tier with a bonus breakdown (100%+) reads as
    // "achieved, see math below" — green. A flat-rate active tier just
    // states its amount inline — highlighted in brand red instead.
    final hasBreakdown = tier.breakdown.isNotEmpty;
    final isFlatActive = tier.isActive && !hasBreakdown;

    final backgroundColor = hasBreakdown
        ? color.successAlt
        : isFlatActive
        ? color.brandSubtle
        : color.scaffoldBackground;
    final borderColor = hasBreakdown
        ? color.success
        : isFlatActive
        ? color.primary
        : null;

    return Container(
      padding: EdgeInsets.all(spacing.s12),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: borderColor != null ? Border.all(color: borderColor) : null,
        borderRadius: BorderRadius.circular(radius.r10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                hasBreakdown
                    ? Icons.check_circle
                    : isFlatActive
                    ? Icons.circle
                    : Icons.remove_circle_outline,
                color: hasBreakdown
                    ? color.success
                    : isFlatActive
                    ? color.primary
                    : color.text.muted,
                size: spacing.s16,
              ),
              Gap(spacing.s8),
              Expanded(
                child: Text(
                  tier.title,
                  style: context.textStyle.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (tier.activeAmountText != null)
                Text(
                  tier.activeAmountText!,
                  style: context.textStyle.bodyLarge.copyWith(
                    color: color.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          Gap(spacing.s4),
          Padding(
            padding: EdgeInsets.only(left: spacing.s24),
            child: Text(
              tier.subtitle,
              style: context.textStyle.bodySmall.copyWith(
                color: color.text.secondary,
              ),
            ),
          ),
          if (tier.breakdown.isNotEmpty) ...[
            Gap(spacing.s10),
            Container(
              padding: EdgeInsets.all(spacing.s12),
              decoration: BoxDecoration(
                color: color.onPrimary,
                borderRadius: BorderRadius.circular(radius.r10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < tier.breakdown.length; i++) ...[
                    if (tier.breakdown[i].isTotal) ...[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: spacing.s8),
                        child: Divider(color: color.borderSubtle, height: 1),
                      ),
                    ] else if (i > 0)
                      Gap(spacing.s8),
                    _IncentiveBreakdownRow(row: tier.breakdown[i]),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _IncentiveBreakdownRow extends StatelessWidget {
  const _IncentiveBreakdownRow({required this.row});

  final IncentiveBreakdownRowEntity row;

  @override
  Widget build(BuildContext context) {
    final color = context.color;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          row.label,
          style: row.isTotal
              ? context.textStyle.labelLarge.copyWith(
                  fontWeight: FontWeight.bold,
                )
              : context.textStyle.bodySmall.copyWith(
                  color: color.text.secondary,
                ),
        ),
        Text(
          row.valueText,
          style: row.isTotal
              ? context.textStyle.labelLarge.copyWith(
                  fontWeight: FontWeight.bold,
                )
              : context.textStyle.bodyMedium.copyWith(
                  color: row.valueText.startsWith('+')
                      ? color.success
                      : color.text.primary,
                ),
        ),
      ],
    );
  }
}

class _IncentiveNotApplicableRow extends StatelessWidget {
  const _IncentiveNotApplicableRow({required this.subtitle});

  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    return Container(
      padding: EdgeInsets.all(spacing.s12),
      decoration: BoxDecoration(
        color: color.brandSubtle,
        border: Border.all(color: color.primary),
        borderRadius: BorderRadius.circular(radius.r10),
      ),
      child: Row(
        children: [
          Icon(Icons.cancel, color: color.primary, size: spacing.s16),
          Gap(spacing.s8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.locale.incentivesNotApplicable,
                  style: context.textStyle.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: context.textStyle.bodySmall.copyWith(
                    color: color.text.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FineAlertnessCard extends StatelessWidget {
  const _FineAlertnessCard({required this.message, required this.amountNote});

  final String message;
  final String amountNote;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    return Container(
      padding: EdgeInsets.all(spacing.s12),
      decoration: BoxDecoration(
        color: color.brandSubtle,
        borderRadius: BorderRadius.circular(radius.r10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: color.warning,
                size: spacing.s16,
              ),
              Gap(spacing.s8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.locale.fineAlertness,
                      style: context.textStyle.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Gap(spacing.s4),
                    Text(
                      message,
                      style: context.textStyle.bodySmall.copyWith(
                        color: color.text.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(spacing.s10),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: spacing.s12,
              vertical: spacing.s10,
            ),
            decoration: BoxDecoration(
              color: color.onPrimary,
              border: Border.all(color: color.primary),
              borderRadius: BorderRadius.circular(radius.r10),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: color.primary, size: spacing.s16),
                Gap(spacing.s8),
                Expanded(
                  child: Text(
                    amountNote,
                    style: context.textStyle.bodySmall.copyWith(
                      color: color.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
