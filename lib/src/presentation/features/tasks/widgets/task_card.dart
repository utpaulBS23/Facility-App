part of '../view/task_page.dart';

class _TaskCard extends StatelessWidget {
  const _TaskCard({
    required this.task,
    required this.onTap,
    required this.onStartTap,
  });

  final TaskEntity task;
  final VoidCallback onTap;
  final VoidCallback onStartTap;

  bool get _isCompleted => task.status == TaskStatus.completed;

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

  Color _statusBorderColor(BuildContext context) => switch (task.status) {
    TaskStatus.today => context.color.primary,
    TaskStatus.pending => context.color.warning,
    TaskStatus.completed => context.color.success,
  };

  Color _statusChipBg(BuildContext context) => switch (task.status) {
    TaskStatus.today => context.color.brandSubtle,
    TaskStatus.pending => context.color.warningAlt,
    TaskStatus.completed => context.color.successAlt,
  };

  Color _statusChipText(BuildContext context) => switch (task.status) {
    TaskStatus.today => context.color.primary,
    TaskStatus.pending => context.color.warning,
    TaskStatus.completed => context.color.success,
  };

  String _statusLabel(BuildContext context) => switch (task.status) {
    TaskStatus.today => context.locale.today,
    TaskStatus.pending => context.locale.pending,
    TaskStatus.completed => context.locale.completed,
  };

  Color _startButtonColor(BuildContext context) => switch (task.status) {
    TaskStatus.pending => context.color.warning,
    _ => context.color.primary,
  };

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final titleColor = _isCompleted
        ? context.color.text.secondary
        : context.color.text.primary;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: context.color.onPrimary,
          border: Border.all(color: _statusBorderColor(context)),
          borderRadius: .circular(context.dimensions.radius.r12),
        ),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            // status accent strip
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: _statusBorderColor(context),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(spacing.s16),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: _priorityColor(context),
                          shape: .circle,
                        ),
                      ),
                      const Gap(6),
                      Text(
                        _priorityLabel(context),
                        style: context.textStyle.bodySmall.copyWith(
                          color: context.color.text.secondary,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: spacing.s8,
                          vertical: spacing.s4,
                        ),
                        decoration: BoxDecoration(
                          color: _statusChipBg(context),
                          borderRadius:
                              .circular(context.dimensions.radius.r6),
                        ),
                        child: Row(
                          mainAxisSize: .min,
                          children: [
                            if (_isCompleted) ...[
                              Icon(
                                Icons.check_circle_outline,
                                size: 12,
                                color: _statusChipText(context),
                              ),
                              const Gap(4),
                            ],
                            Text(
                              _statusLabel(context),
                              style: context.textStyle.bodySmall.copyWith(
                                color: _statusChipText(context),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Gap(spacing.s8),
                  Text(
                    task.title,
                    style: context.textStyle.labelLarge.copyWith(
                      color: titleColor,
                      decoration: _isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      decorationColor: context.color.text.secondary,
                    ),
                  ),
                  Gap(spacing.s6),
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
                  if (!_isCompleted) ...[
                    Gap(spacing.s12),
                    FilledButton(
                      onPressed: onStartTap,
                      style: FilledButton.styleFrom(
                        backgroundColor: _startButtonColor(context),
                      ),
                      child: Text(context.locale.start),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    this.muted = false,
  });

  final IconData icon;
  final String label;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final color =
        muted ? context.color.text.muted : context.color.text.secondary;

    return Row(
      children: [
        Icon(icon, size: 16, color: muted ? context.color.inactive : context.color.icon),
        const Gap(4),
        Expanded(
          child: Text(
            label,
            style: context.textStyle.bodySmall.copyWith(color: color),
            maxLines: 1,
            overflow: .ellipsis,
          ),
        ),
      ],
    );
  }
}
