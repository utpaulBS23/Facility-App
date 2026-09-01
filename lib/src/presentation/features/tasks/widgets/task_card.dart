part of '../view/task_page.dart';

class _TaskCard extends StatelessWidget {
  const _TaskCard({
    required this.task,
    required this.onTap,
    required this.onStartTap,
    required this.onCompleteTap,
  });

  final TaskEntity task;
  final VoidCallback onTap;
  final VoidCallback onStartTap;
  final VoidCallback onCompleteTap;

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
                                decoration: _isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                decorationColor: context.color.text.secondary,
                              ),
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
                        icon: Icons.location_on_outlined,
                        label: task.location,
                        muted: _isCompleted,
                      ),
                      Gap(spacing.s4),
                      _InfoRow(
                        icon: Icons.access_time_outlined,
                        label: '${context.locale.due}: ${task.dueTime}',
                        muted: _isCompleted,
                      ),
                      if (_canStart || _canComplete) ...[
                        Gap(spacing.s16),
                        Wrap(
                          spacing: spacing.s8,
                          runSpacing: spacing.s8,
                          children: [
                            if (_canStart)
                              OutlinedButton.icon(
                                onPressed: onStartTap,
                                icon: const Icon(
                                  Icons.play_arrow_rounded,
                                  size: 16,
                                ),
                                label: Text(context.locale.start),
                              ),
                            if (_canComplete)
                              PermissionGate(
                                permissions: [UserPermission.issueResolve],
                                child: OutlinedButton.icon(
                                  onPressed: onCompleteTap,
                                  icon: const Icon(
                                    Icons.check_rounded,
                                    size: 16,
                                  ),
                                  label: Text(context.locale.completeTask),
                                ),
                              ),
                          ],
                        ),
                      ],
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
