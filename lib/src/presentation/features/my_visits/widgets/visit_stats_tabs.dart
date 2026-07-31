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
          borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        ),
        child: Row(
          children: [
            _StatTab(
              count: stats.total,
              label: context.locale.all,
              isSelected: selectedTab == _VisitTab.all,
              onTap: () => onTabChanged(_VisitTab.all),
            ),
            _Divider(),
            _StatTab(
              count: stats.pending,
              label: context.locale.pending,
              isSelected: selectedTab == _VisitTab.pending,
              onTap: () => onTabChanged(_VisitTab.pending),
            ),
            _Divider(),
            _StatTab(
              count: stats.inProgress,
              label: context.locale.inProgress,
              isSelected: selectedTab == _VisitTab.inProgress,
              onTap: () => onTabChanged(_VisitTab.inProgress),
            ),
            _Divider(),
            _StatTab(
              count: stats.completed,
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

    final bgColor = isActive
        ? context.color.successAlt
        : context.color.subtle.withValues(alpha: 0);
    final countColor = isActive
        ? context.color.success
        : context.color.text.primary;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
          ),
          padding: EdgeInsets.symmetric(vertical: spacing.s8),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
