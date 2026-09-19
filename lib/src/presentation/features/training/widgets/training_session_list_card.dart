part of '../view/training_sessions_page.dart';

class _TrainingSessionListCard extends StatelessWidget {
  const _TrainingSessionListCard({
    required this.session,
    required this.onTap,
  });

  final TrainingSessionEntity session;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(spacing.s16),
        decoration: BoxDecoration(
          color: context.color.onPrimary,
          border: Border.all(color: context.color.borderSubtle),
          borderRadius: BorderRadius.circular(radius.r12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(spacing.s12),
              decoration: BoxDecoration(
                color: context.color.brandSubtle,
                borderRadius: BorderRadius.circular(radius.r12),
              ),
              child: Icon(
                Icons.school_outlined,
                color: context.color.primary,
                size: spacing.s24,
              ),
            ),
            Gap(spacing.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      StatusDotTag(
                        dotColor: session.status.statusColor(context),
                        label: session.status.localizedName(context),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: context.color.text.secondary,
                      ),
                    ],
                  ),
                  Gap(spacing.s6),
                  Text(
                    session.title,
                    style: context.textStyle.titleMedium.copyWith(
                      color: context.color.text.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gap(spacing.s4),
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline_rounded,
                        size: spacing.s14,
                        color: context.color.text.secondary,
                      ),
                      Gap(spacing.s4),
                      Text(
                        session.facilitatorName,
                        style: context.textStyle.bodySmall.copyWith(
                          color: context.color.text.secondary,
                        ),
                      ),
                    ],
                  ),
                  if (session.facilityName.isNotEmpty) ...[
                    Gap(spacing.s4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: spacing.s14,
                          color: context.color.text.secondary,
                        ),
                        Gap(spacing.s4),
                        Expanded(
                          child: Text(
                            session.facilityName,
                            style: context.textStyle.bodySmall.copyWith(
                              color: context.color.text.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  Gap(spacing.s4),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: spacing.s14,
                        color: context.color.text.secondary,
                      ),
                      Gap(spacing.s4),
                      Text(
                        DateFormatter.shortDate(session.scheduledAt),
                        style: context.textStyle.bodySmall.copyWith(
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
      ),
    );
  }
}
