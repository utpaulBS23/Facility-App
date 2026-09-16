part of '../view/additional_income_page.dart';

class _IncomeStatsRow extends StatelessWidget {
  const _IncomeStatsRow({required this.summary});

  final AdditionalIncomeSummaryEntity summary;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: context.locale.approvedTotal,
            value: '৳${NumberFormatter.format(summary.approvedTotal)}',
            emphasize: true,
          ),
        ),
        Gap(spacing.s8),
        Expanded(
          child: _StatCard(
            label: context.locale.pending,
            value: '${summary.pendingCount}',
            emphasize: false,
          ),
        ),
        Gap(spacing.s8),
        Expanded(
          child: _StatCard(
            label: context.locale.totalSubmissions,
            value: '${summary.totalSubmissions}',
            emphasize: false,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.emphasize,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      padding: EdgeInsets.all(spacing.s12),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        border: Border.all(color: context.color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: context.textStyle.labelLarge.copyWith(
              color: emphasize ? context.color.primary : context.color.text.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Gap(spacing.s4),
          BodySmallText(label, color: context.color.text.secondary),
        ],
      ),
    );
  }
}
