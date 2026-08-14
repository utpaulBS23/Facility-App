part of '../view/stock_averaging_page.dart';

class _MonthlyDemandCard extends StatelessWidget {
  const _MonthlyDemandCard({required this.stats});

  final List<MonthlyDemandStat> stats;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        border: Border.all(color: color.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Monthly total demand for all facilities',
            style: textStyle.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: color.text.secondary,
            ),
          ),
          Gap(spacing.s12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: stats.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.45,
            ),
            itemBuilder: (context, index) {
              return _DemandStatTile(stat: stats[index]);
            },
          ),
        ],
      ),
    );
  }
}

class _DemandStatTile extends StatelessWidget {
  const _DemandStatTile({required this.stat});

  final MonthlyDemandStat stat;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;

    return Container(
      padding: EdgeInsets.all(spacing.s12),
      decoration: BoxDecoration(
        color: color.onPrimary,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r10),
        border: Border.all(color: color.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(stat.icon, size: 16, color: color.primary),
              Gap(spacing.s4),
              Expanded(
                child: Text(
                  stat.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textStyle.bodySmall.copyWith(
                    color: color.text.secondary,
                  ),
                ),
              ),
            ],
          ),
          Gap(spacing.s6),
          Text(
            stat.totalValue.toString(),
            style: textStyle.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: color.text.primary,
            ),
          ),
          Text(
            stat.unit,
            style: textStyle.bodySmall.copyWith(
              color: color.text.secondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
