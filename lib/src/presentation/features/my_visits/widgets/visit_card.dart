part of '../view/my_visits_page.dart';

class _VisitCard extends ConsumerWidget {
  const _VisitCard({required this.visit, required this.onTap});

  final VisitSummaryEntity visit;
  final VoidCallback onTap;

  Color _statusColor(BuildContext context) => switch (visit.status) {
    VisitStatus.scheduled => context.color.info,
    VisitStatus.inProgress => context.color.warning,
    VisitStatus.completed => context.color.success,
    VisitStatus.resolved => context.color.success,
    VisitStatus.pending => context.color.warning,
  };

  String _statusLabel(BuildContext context) => switch (visit.status) {
    VisitStatus.scheduled => context.locale.scheduled,
    VisitStatus.inProgress => context.locale.inProgress,
    VisitStatus.completed => context.locale.completed,
    VisitStatus.resolved => context.locale.resolved,
    VisitStatus.pending => context.locale.pending,
  };

  String _getVisitTypeLabel(
    List<MasterDataItemEntity> taskTypes,
  ) {
    if (visit.visitType != null && visit.visitType!.isNotEmpty) {
      try {
        final match = taskTypes.firstWhere(
          (item) => item.value == visit.visitType,
        );
        return match.label;
      } catch (_) {
        return visit.visitType!;
      }
    }
    return switch (visit.type) {
      VisitType.routineInspection => 'Routine Inspection',
      VisitType.followUp => 'Follow-up',
    };
  }

  String _locationTypeLabel(BuildContext context) =>
      visit.locationType == 'external' ? 'External' : 'Facility';

  String? _priorityLabel(BuildContext context) => switch (visit.priority) {
    'high' => context.locale.priorityHigh,
    'medium' => context.locale.priorityMedium,
    'normal' => context.locale.priorityNormal,
    'low' => context.locale.priorityLow,
    _ => null,
  };

  Color _priorityColor(BuildContext context) => switch (visit.priority) {
    'high' => context.color.error,
    'medium' => context.color.warning,
    _ => context.color.text.secondary,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.dimensions.spacing;
    final dateTime = DateFormat('EEE, MMM d').format(DateTime.parse(visit.date));
    final taskTypesState = ref.watch(visitTaskTypeOptionsProvider);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(spacing.s16),
        decoration: BoxDecoration(
          color: context.color.onPrimary,
          border: Border.all(color: context.color.borderSubtle),
          borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _StatusChip(
                    color: _statusColor(context),
                    label: _statusLabel(context),
                  ),
                  Gap(spacing.s8),
                  _StatusChip(
                    color: visit.locationType == 'external'
                        ? context.color.warning
                        : context.color.success,
                    label: _locationTypeLabel(context),
                  ),
                  if (_priorityLabel(context) != null) ...[
                    Gap(spacing.s8),
                    _StatusChip(
                      color: _priorityColor(context),
                      label: _priorityLabel(context)!,
                    ),
                  ],
                  Gap(spacing.s8),
                  _StatusChip(
                    color: context.color.icon,
                    label: taskTypesState.maybeWhen(
                      data: (taskTypes) => _getVisitTypeLabel(taskTypes),
                      orElse: () => visit.visitType ?? 'Task',
                    ),
                  ),
                ],
              ),
            ),
            Gap(spacing.s12),
            if (visit.title?.isNotEmpty == true)
              Text(
                visit.title!,
                style: context.textStyle.titleMedium.copyWith(
                  color: context.color.text.primary,
                ),
              ),
            Gap(spacing.s8),
            _InfoRow(
              icon: Icons.apartment_outlined,
              label: visit.locationType == 'external'
                  ? (visit.officeName ?? '')
                  : (visit.facilityName ?? ''),
            ),
            Gap(spacing.s6),
            _InfoRow(
              icon: Icons.calendar_today_outlined,
              label: dateTime,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const Gap(4),
        Text(
          label,
          style: context.textStyle.bodySmall.copyWith(
            color: context.color.text.secondary,
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: context.color.icon),
        const Gap(4),
        Expanded(
          child: Text(
            label,
            style: context.textStyle.bodySmall.copyWith(
              color: context.color.text.secondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
