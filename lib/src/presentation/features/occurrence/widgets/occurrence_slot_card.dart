part of '../view/occurrence_page.dart';

class _OccurrenceSlotCard extends StatelessWidget {
  const _OccurrenceSlotCard({
    required this.occurrence,
    required this.onReassign,
    required this.onChecklist,
  });

  final TaskOccurrenceEntity occurrence;
  final VoidCallback onReassign;
  final VoidCallback onChecklist;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final items = occurrence.checklistItems;
    final answered = items?.where((i) => i.isAnswered).length ?? 0;
    final progress = items == null || items.isEmpty ? 0.0 : answered / items.length;
    final accent = _occurrenceStatusForeground(context, occurrence.status);

    return Container(
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        borderRadius: .circular(radius.r12),
        border: Border.all(color: context.color.borderSubtle),
        boxShadow: [
          BoxShadow(
            color: context.color.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: .antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: .stretch,
          children: [
            Container(width: 4, color: accent),
            Expanded(
              child: Padding(
                padding: .all(spacing.s16),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Row(
                      crossAxisAlignment: .start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: .start,
                            children: [
                              LabelLargeText(occurrence.scheduleTitle),
                              Gap(spacing.s4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time_rounded,
                                    size: 14,
                                    color: context.color.text.secondary,
                                  ),
                                  Gap(spacing.s4),
                                  BodySmallText(
                                    DateFormatter.formatTimeRange(
                                      occurrence.timeRange,
                                    ),
                                    color: context.color.text.secondary,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        _OccurrenceStatusChip(status: occurrence.status),
                      ],
                    ),
                    Gap(spacing.s12),
                    Row(
                      children: [
                        _OccurrenceAssigneeAvatar(name: occurrence.assignedToName),
                        Gap(spacing.s8),
                        Expanded(
                          child: BodySmallText(
                            occurrence.assignedToName ?? context.locale.unassigned,
                            color: context.color.text.secondary,
                          ),
                        ),
                      ],
                    ),
                    if (items != null) ...[
                      Gap(spacing.s12),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: .circular(radius.r4),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: spacing.s6,
                                backgroundColor: context.color.borderSubtle,
                                color: accent,
                              ),
                            ),
                          ),
                          Gap(spacing.s8),
                          BodySmallText(
                            context.locale.occurrenceChecklistItemsCompleted(
                              answered,
                              items.length,
                            ),
                            color: context.color.text.secondary,
                          ),
                        ],
                      ),
                    ],
                    Gap(spacing.s16),
                    Wrap(
                      spacing: spacing.s8,
                      runSpacing: spacing.s8,
                      children: [
                        PermissionGate(
                          permissions: const [UserPermission.taskOccurrenceAssign],
                          child: OutlinedButton.icon(
                            onPressed: onReassign,
                            icon: const Icon(Icons.swap_horiz_rounded, size: 16),
                            label: Text(context.locale.occurrenceReassign),
                          ),
                        ),
                        if (items != null)
                          PermissionGate(
                            permissions: const [UserPermission.taskOccurrenceSubmit],
                            child: OutlinedButton.icon(
                              onPressed: onChecklist,
                              icon: const Icon(Icons.checklist_rounded, size: 16),
                              label: Text(context.locale.occurrenceChecklist),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OccurrenceAssigneeAvatar extends StatelessWidget {
  const _OccurrenceAssigneeAvatar({required this.name});

  final String? name;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final initial = name?.trim().isNotEmpty == true ? name!.trim()[0].toUpperCase() : null;

    return Container(
      width: spacing.s24,
      height: spacing.s24,
      decoration: BoxDecoration(
        color: initial != null ? context.color.brandSubtle : context.color.subtle,
        shape: BoxShape.circle,
      ),
      alignment: .center,
      child: initial != null
          ? Text(
              initial,
              style: context.textStyle.bodySmall.copyWith(color: context.color.primary),
            )
          : Icon(Icons.person_outline, size: 14, color: context.color.icon),
    );
  }
}
