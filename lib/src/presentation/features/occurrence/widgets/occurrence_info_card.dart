part of '../view/occurrence_checklist_page.dart';

class _OccurrenceInfoCard extends StatelessWidget {
  const _OccurrenceInfoCard({required this.occurrence});

  final TaskOccurrenceEntity occurrence;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        borderRadius: BorderRadius.circular(radius.r6),
        border: Border.all(color: context.color.borderSubtle),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: context.color.brandAccent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(radius.r6),
            ),
            child: Icon(
              Icons.business_rounded,
              color: context.color.brandAccent,
              size: 24,
            ),
          ),
          SizedBox(width: spacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabelLargeText(
                  occurrence.scheduleTitle,
                  color: context.color.text.primary,
                ),
                SizedBox(height: spacing.s4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_outlined,
                      size: 14,
                      color: context.color.text.secondary,
                    ),
                    SizedBox(width: spacing.s4),
                    Expanded(
                      child: BodySmallText(
                        DateFormatter.formatTimeRange(
                          occurrence.timeRange,
                        ),
                        color: context.color.text.secondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
