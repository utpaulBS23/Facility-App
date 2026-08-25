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
    final items = occurrence.checklistItems;
    final answered = items?.where((i) => i.isAnswered).length ?? 0;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        border: Border.all(color: context.color.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelLargeText(occurrence.scheduleTitle),
                    Gap(spacing.s4),
                    BodySmallText(
                      occurrence.timeRange,
                      color: context.color.text.secondary,
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
              Icon(Icons.person_outline, size: 16, color: context.color.icon),
              Gap(spacing.s4),
              Expanded(
                child: BodySmallText(
                  occurrence.assignedToName ?? context.locale.unassigned,
                  color: context.color.text.secondary,
                ),
              ),
            ],
          ),
          if (items != null) ...[
            Gap(spacing.s8),
            BodySmallText(
              context.locale.occurrenceChecklistItemsCompleted(answered, items.length),
              color: context.color.text.secondary,
            ),
          ],
          Gap(spacing.s16),
          Wrap(
            spacing: spacing.s8,
            runSpacing: spacing.s8,
            children: [
              PermissionGate(
                permissions: const [UserPermission.taskOccurrenceAssign],
                child: OutlinedButton(
                  onPressed: onReassign,
                  child: Text(context.locale.occurrenceReassign),
                ),
              ),
              if (items != null)
                PermissionGate(
                  permissions: const [UserPermission.checklistResponseSubmit],
                  child: OutlinedButton(
                    onPressed: onChecklist,
                    child: Text(context.locale.occurrenceChecklist),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
