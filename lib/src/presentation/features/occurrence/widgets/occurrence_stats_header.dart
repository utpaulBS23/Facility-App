part of '../view/occurrence_page.dart';

class _OccurrenceStatsHeader extends StatelessWidget {
  const _OccurrenceStatsHeader({
    required this.stats,
    required this.selectedTab,
    required this.onTabChanged,
  });

  final TaskOccurrenceStatsEntity stats;
  final _OccurrenceTab selectedTab;
  final void Function(_OccurrenceTab) onTabChanged;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Container(
      color: context.color.onPrimary,
      padding: EdgeInsets.symmetric(horizontal: spacing.s16, vertical: spacing.s8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: context.color.borderSubtle),
          borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        ),
        child: Row(
          children: [
            _OccurrenceStatTab(
              count: stats.totalSlots,
              label: context.locale.all,
              isSelected: selectedTab == _OccurrenceTab.all,
              onTap: () => onTabChanged(_OccurrenceTab.all),
            ),
            _OccurrenceStatDivider(),
            _OccurrenceStatTab(
              count: stats.pending,
              label: context.locale.occurrenceStatsPending,
              isSelected: selectedTab == _OccurrenceTab.pending,
              activeBackground: context.color.brandSubtle,
              activeColor: context.color.primary,
              onTap: () => onTabChanged(_OccurrenceTab.pending),
            ),
            _OccurrenceStatDivider(),
            _OccurrenceStatTab(
              count: stats.onTime,
              label: context.locale.occurrenceStatsOnTime,
              isSelected: selectedTab == _OccurrenceTab.onTime,
              activeBackground: context.color.successAlt,
              activeColor: context.color.success,
              onTap: () => onTabChanged(_OccurrenceTab.onTime),
            ),
            _OccurrenceStatDivider(),
            _OccurrenceStatTab(
              count: stats.late,
              label: context.locale.occurrenceStatsLate,
              isSelected: selectedTab == _OccurrenceTab.late,
              activeBackground: context.color.warningAlt,
              activeColor: context.color.warning,
              onTap: () => onTabChanged(_OccurrenceTab.late),
            ),
            _OccurrenceStatDivider(),
            _OccurrenceStatTab(
              count: stats.missed,
              label: context.locale.occurrenceStatsMissed,
              isSelected: selectedTab == _OccurrenceTab.missed,
              activeBackground: context.color.errorAlt,
              activeColor: context.color.error,
              onTap: () => onTabChanged(_OccurrenceTab.missed),
            ),
          ],
        ),
      ),
    );
  }
}

class _OccurrenceStatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 56, color: context.color.borderSubtle);
  }
}

class _OccurrenceStatTab extends StatelessWidget {
  const _OccurrenceStatTab({
    required this.count,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.activeBackground,
    this.activeColor,
  });

  final int count;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? activeBackground;
  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final backgroundColor = isSelected
        ? (activeBackground ?? context.color.subtle)
        : Colors.transparent;
    final countColor = isSelected
        ? (activeColor ?? context.color.text.primary)
        : context.color.text.primary;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
          ),
          padding: EdgeInsets.symmetric(vertical: spacing.s8),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$count', style: context.textStyle.titleMedium.copyWith(color: countColor)),
              Gap(spacing.s4),
              Text(
                label,
                style: context.textStyle.bodySmall.copyWith(
                  color: context.color.text.secondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
