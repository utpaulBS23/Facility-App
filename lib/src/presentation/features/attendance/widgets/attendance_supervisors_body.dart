part of '../view/attendance_page.dart';

class _AttendanceSupervisorsBody extends StatelessWidget {
  const _AttendanceSupervisorsBody({
    required this.overview,
    required this.singleDay,
    required this.scrollController,
    required this.onItemTap,
    required this.onRefresh,
  });

  final MyAttendanceOverviewEntity overview;

  /// True when the range is one day, which the stats tile depends on.
  final bool singleDay;
  final ScrollController scrollController;
  final ValueChanged<MyAttendanceItemEntity> onItemTap;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            spacing.s16,
            spacing.s16,
            spacing.s16,
            spacing.s12,
          ),
          child: _SupervisorStatsCard(
            stats: overview.stats,
            singleDay: singleDay,
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: overview.items.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: spacing.s96),
                        child: Center(
                          child: Text(
                            context.locale.noAttendanceFound,
                            style: context.textStyle.bodyMedium.copyWith(
                              color: context.color.text.secondary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : ListView.separated(
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      spacing.s16,
                      spacing.s4,
                      spacing.s16,
                      spacing.s16,
                    ),
                    itemCount: overview.items.length + (overview.hasMore ? 1 : 0),
                    separatorBuilder: (_, _) => Gap(spacing.s12),
                    itemBuilder: (context, index) {
                      if (index >= overview.items.length) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: spacing.s16),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      final item = overview.items[index];
                      return MyAttendanceItem(
                        item: item,
                        onTap: () => onItemTap(item),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}

class _SupervisorStatsCard extends StatelessWidget {
  const _SupervisorStatsCard({required this.stats, required this.singleDay});

  final MyAttendanceStatsEntity stats;
  final bool singleDay;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final neutral = context.color.borderSubtle.withValues(alpha: 0.2);

    return Container(
      padding: EdgeInsets.all(spacing.s8),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        border: Border.all(color: context.color.borderSubtle),
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
      ),
      child: Row(
        children: [
          _StatItem(
            count: stats.records,
            label: context.locale.attendanceRecords,
            background: neutral,
            textColor: context.color.text.primary,
          ),
          Gap(spacing.s6),
          _StatItem(
            count: stats.supervisors,
            label: context.locale.supervisors,
            background: neutral,
            textColor: context.color.text.primary,
          ),
          Gap(spacing.s6),
          _StatItem(
            count: stats.stillOnRound,
            label: context.locale.stillOnRound,
            background: context.color.successAlt,
            textColor: context.color.success,
          ),
          Gap(spacing.s6),
          // WHY one or the other: the server returns facilities for a single
          // day and days covered for a longer range, never both.
          _StatItem(
            count: singleDay ? stats.facilities : stats.daysCovered,
            label: singleDay
                ? context.locale.facilities
                : context.locale.daysCovered,
            background: neutral,
            textColor: context.color.text.primary,
          ),
        ],
      ),
    );
  }
}
