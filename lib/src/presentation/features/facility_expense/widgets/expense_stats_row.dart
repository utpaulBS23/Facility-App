part of '../view/facility_expense_page.dart';

class _ExpenseStatsRow extends StatelessWidget {
  const _ExpenseStatsRow({required this.summary});

  final FacilityExpenseSummaryEntity summary;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: context.locale.total,
            amount: summary.totalExpenses,
            emphasize: true,
          ),
        ),
        Gap(spacing.s8),
        Expanded(
          child: _StatCard(
            label: context.locale.cashPaid,
            amount: summary.cashPaid,
            emphasize: false,
          ),
        ),
        Gap(spacing.s8),
        Expanded(
          child: _StatCard(
            label: context.locale.accountsPaid,
            amount: summary.accountsPaid,
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
    required this.amount,
    required this.emphasize,
  });

  final String label;
  final double amount;
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
            '৳${NumberFormatter.format(amount)}',
            style: context.textStyle.labelLarge.copyWith(
              color: emphasize ? context.color.error : context.color.text.primary,
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
