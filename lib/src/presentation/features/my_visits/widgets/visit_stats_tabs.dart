part of '../view/my_visits_page.dart';

class _VisitStatsTabs extends StatelessWidget {
  const _VisitStatsTabs({
    required this.stats,
    required this.selectedTab,
    required this.onTabChanged,
  });

  final VisitStatsSummaryEntity stats;
  final _VisitTab selectedTab;
  final void Function(_VisitTab) onTabChanged;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Container(
      color: context.color.onPrimary,
      padding: EdgeInsets.symmetric(
        horizontal: spacing.s16,
        vertical: spacing.s8,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: context.color.borderSubtle),
          borderRadius: .circular(context.dimensions.radius.r12),
        ),
        child: Row(
          children: [
            _StatTab(
              count: stats.todayCount,
              label: context.locale.today,
              isSelected: selectedTab == _VisitTab.today,
              onTap: () => onTabChanged(_VisitTab.today),
            ),
            _Divider(),
            _StatTab(
              count: stats.weekCount,
              label: context.locale.thisWeek,
              isSelected: selectedTab == _VisitTab.week,
              onTap: () => onTabChanged(_VisitTab.week),
            ),
            _Divider(),
            _StatTab(
              count: stats.completedCount,
              label: context.locale.completed,
              isSelected: selectedTab == _VisitTab.completed,
              isCompleted: true,
              onTap: () => onTabChanged(_VisitTab.completed),
            ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 56, color: context.color.borderSubtle);
  }
}

class _StatTab extends StatelessWidget {
  const _StatTab({
    required this.count,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isCompleted = false,
  });

  final int count;
  final String label;
  final bool isSelected;
  final bool isCompleted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final isActive = isSelected && isCompleted;

    final bgColor = isActive ? context.color.successAlt : context.color.subtle.withValues(alpha: 0);
    final countColor = isActive ? context.color.success : context.color.text.primary;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: .circular(context.dimensions.radius.r12),
          ),
          padding: EdgeInsets.symmetric(vertical: spacing.s8),
          alignment: .center,
          child: Column(
            mainAxisSize: .min,
            children: [
              Text(
                '$count',
                style: context.textStyle.titleMedium.copyWith(
                  color: countColor,
                ),
              ),
              Gap(spacing.s4),
              Text(
                label,
                style: context.textStyle.bodySmall.copyWith(
                  color: context.color.text.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
