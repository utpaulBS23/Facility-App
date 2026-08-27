part of '../view/occurrence_page.dart';

String _occurrenceStatusLabel(BuildContext context, TaskOccurrenceStatus status) =>
    switch (status) {
      TaskOccurrenceStatus.pending => context.locale.occurrenceStatusPending,
      TaskOccurrenceStatus.onTime => context.locale.occurrenceStatusOnTime,
      TaskOccurrenceStatus.late => context.locale.occurrenceStatusLate,
      TaskOccurrenceStatus.missed => context.locale.occurrenceStatusMissed,
    };

Color _occurrenceStatusForeground(BuildContext context, TaskOccurrenceStatus status) =>
    switch (status) {
      TaskOccurrenceStatus.pending => context.color.primary,
      TaskOccurrenceStatus.onTime => context.color.success,
      TaskOccurrenceStatus.late => context.color.warning,
      TaskOccurrenceStatus.missed => context.color.error,
    };

Color _occurrenceStatusBackground(BuildContext context, TaskOccurrenceStatus status) =>
    switch (status) {
      TaskOccurrenceStatus.pending => context.color.brandSubtle,
      TaskOccurrenceStatus.onTime => context.color.successAlt,
      TaskOccurrenceStatus.late => context.color.warningAlt,
      TaskOccurrenceStatus.missed => context.color.errorAlt,
    };

IconData _occurrenceStatusIcon(TaskOccurrenceStatus status) => switch (status) {
  TaskOccurrenceStatus.pending => Icons.hourglass_top_rounded,
  TaskOccurrenceStatus.onTime => Icons.check_circle_rounded,
  TaskOccurrenceStatus.late => Icons.schedule_rounded,
  TaskOccurrenceStatus.missed => Icons.cancel_rounded,
};

class _OccurrenceStatusChip extends StatelessWidget {
  const _OccurrenceStatusChip({required this.status});

  final TaskOccurrenceStatus status;

  @override
  Widget build(BuildContext context) {
    return StatusPill(
      label: _occurrenceStatusLabel(context, status),
      icon: _occurrenceStatusIcon(status),
      background: _occurrenceStatusBackground(context, status),
      foreground: _occurrenceStatusForeground(context, status),
    );
  }
}
