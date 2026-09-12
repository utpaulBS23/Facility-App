part of '../view/travel_expenses_page.dart';

class _TravelExpenseStats {
  const _TravelExpenseStats({
    required this.totalCost,
    required this.averageCost,
    required this.waitingCount,
    required this.approvedCount,
  });

  factory _TravelExpenseStats.from(List<TravelExpenseEntity> expenses) {
    final total = expenses.fold<double>(
      0,
      (sum, e) => sum + e.claimedAmount,
    );

    return _TravelExpenseStats(
      totalCost: total,
      averageCost: expenses.isEmpty ? 0 : total / expenses.length,
      waitingCount: expenses
          .where((e) => e.status == TravelExpenseStatus.waiting)
          .length,
      approvedCount: expenses
          .where((e) => e.status == TravelExpenseStatus.allowed)
          .length,
    );
  }

  final double totalCost;
  final double averageCost;
  final int waitingCount;
  final int approvedCount;
}

class _TravelExpenseStatsRow extends StatelessWidget {
  const _TravelExpenseStatsRow({required this.stats});

  final _TravelExpenseStats stats;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: context.locale.totalLabel,
                value: '৳${stats.totalCost.toStringAsFixed(0)}',
              ),
            ),
            Gap(spacing.s12),
            Expanded(
              child: _StatCard(
                label: context.locale.averageCost,
                value: '৳${stats.averageCost.toStringAsFixed(0)}',
              ),
            ),
          ],
        ),
        Gap(spacing.s12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: context.locale.pending,
                value: '${stats.waitingCount}',
              ),
            ),
            Gap(spacing.s12),
            Expanded(
              child: _StatCard(
                label: context.locale.approved,
                value: '${stats.approvedCount}',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    return Container(
      padding: EdgeInsets.all(spacing.s12),
      decoration: BoxDecoration(
        color: color.primary,
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: context.textStyle.titleLarge.copyWith(
              color: color.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Gap(spacing.s2),
          Text(
            label,
            style: context.textStyle.bodySmall.copyWith(
              color: color.onPrimary.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
