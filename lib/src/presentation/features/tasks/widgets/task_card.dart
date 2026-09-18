part of '../view/task_page.dart';

class _TaskCard extends StatelessWidget {
  const _TaskCard({
    required this.task,
    required this.onTap,
    required this.onStartTap,
    required this.onCompleteTap,
    this.onAssignTap,
  });

  final TaskEntity task;
  final VoidCallback onTap;
  final VoidCallback onStartTap;
  final VoidCallback onCompleteTap;
  final ValueChanged<TaskEntity>? onAssignTap;

  bool get _isCompleted =>
      task.status == TaskStatus.resolved || task.status == TaskStatus.closed;
  bool get _canStart => task.status == TaskStatus.open;
  bool get _canComplete => task.status == TaskStatus.inProgress;

  Color _priorityColor(BuildContext context) => switch (task.priority) {
    TaskPriority.high => context.color.primary,
    TaskPriority.medium => context.color.warning,
    TaskPriority.low => context.color.inactive,
  };

  String _priorityLabel(BuildContext context) => switch (task.priority) {
    TaskPriority.high => context.locale.high,
    TaskPriority.medium => context.locale.medium,
    TaskPriority.low => context.locale.low,
  };

  Color _statusAccent(BuildContext context) => switch (task.status) {
    TaskStatus.open => context.color.warning,
    TaskStatus.inProgress => context.color.primary,
    TaskStatus.resolved => context.color.success,
    TaskStatus.closed => context.color.success,
  };

  Color _statusChipBg(BuildContext context) => switch (task.status) {
    TaskStatus.open => context.color.warningAlt,
    TaskStatus.inProgress => context.color.brandSubtle,
    TaskStatus.resolved => context.color.successAlt,
    TaskStatus.closed => context.color.successAlt,
  };

  String _statusLabel(BuildContext context) => switch (task.status) {
    TaskStatus.open => context.locale.open,
    TaskStatus.inProgress => context.locale.inProgress,
    TaskStatus.resolved => context.locale.resolved,
    TaskStatus.closed => context.locale.closed,
  };

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final accent = _statusAccent(context);
    final titleColor = _isCompleted
        ? context.color.text.secondary
        : context.color.text.primary;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: context.color.onPrimary,
          borderRadius: BorderRadius.circular(radius.r12),
          border: Border.all(color: context.color.borderSubtle),
          boxShadow: [
            BoxShadow(
              color: context.color.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 4, color: accent),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(spacing.s16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              task.title,
                              style: context.textStyle.labelLarge.copyWith(
                                color: titleColor,
                                fontWeight: FontWeight.bold,
                                decoration: _isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                decorationColor: context.color.text.secondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Gap(spacing.s8),
                          StatusPill(
                            label: _statusLabel(context),
                            background: _statusChipBg(context),
                            foreground: accent,
                            icon: _isCompleted
                                ? Icons.check_circle_outline
                                : null,
                          ),
                        ],
                      ),
                      Gap(spacing.s8),
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: _priorityColor(context),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Gap(spacing.s6),
                          BodySmallText(
                            _priorityLabel(context),
                            color: context.color.text.secondary,
                          ),
                        ],
                      ),
                      Gap(spacing.s12),
                      _InfoRow(
                        icon: Icons.business_rounded,
                        label: task.location,
                        muted: _isCompleted,
                      ),
                      Gap(spacing.s4),
                      _InfoRow(
                        icon: Icons.location_on_outlined,
                        label: task.facilityAddress,
                        muted: _isCompleted,
                      ),
                      Gap(spacing.s4),
                      _InfoRow(
                        icon: Icons.access_time_outlined,
                        label:
                            '${context.locale.due}: ${DateFormatter.formatDateOnly(task.dueTime)}',
                        muted: _isCompleted,
                      ),
                      Gap(spacing.s12),
                      if (task.assignedToName.isNotEmpty)
                        Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: context.color.primary.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.person_rounded,
                                  size: 12,
                                  color: context.color.primary,
                                ),
                              ),
                            ),
                            Gap(spacing.s8),
                            Expanded(
                              child: Text(
                                task.assignedToName,
                                style: context.textStyle.bodySmall.copyWith(
                                  color: _isCompleted
                                      ? context.color.text.muted
                                      : context.color.text.secondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      Gap(spacing.s16),
                      PermissionGate(
                        permissions: [UserPermission.issueUpdate],
                        child: OutlinedButton.icon(
                          onPressed: onAssignTap != null ? () => onAssignTap!(task) : null,
                          icon: const Icon(
                            Icons.person_add_outlined,
                            size: 16,
                          ),
                          label: Text(context.locale.assignStaff),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, this.muted = false});

  final IconData icon;
  final String label;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final color = muted
        ? context.color.text.muted
        : context.color.text.secondary;

    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: muted ? context.color.inactive : context.color.icon,
        ),
        const Gap(4),
        Expanded(
          child: Text(
            label,
            style: context.textStyle.bodySmall.copyWith(color: color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
