part of '../view/select_attendant_page.dart';

class _SelectableAttendantCard extends StatelessWidget {
  const _SelectableAttendantCard({
    required this.attendant,
    required this.index,
    required this.onTap,
  });

  final LeaveAttendantEntity attendant;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;

    final location = attendant.facilityName;
    final shiftName =
        attendant.shift?.shiftName ?? context.locale.morningShift;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
      child: Container(
        padding: EdgeInsets.all(spacing.s12),
        decoration: BoxDecoration(
          color: color.onPrimary,
          borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
          border: Border.all(color: color.borderSubtle),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: spacing.s20,
              backgroundColor: color.primary.withValues(alpha: 0.1),
              child: Icon(
                Icons.person,
                color: color.primary,
              ),
            ),
            Gap(spacing.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    attendant.name,
                    style: textStyle.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color.text.primary,
                    ),
                  ),
                  if (attendant.uid.isNotEmpty) ...[
                    Gap(spacing.s4),
                    Text(
                      'ID: ${attendant.uid}',
                      style: textStyle.bodyMedium.copyWith(
                        color: color.text.secondary,
                      ),
                    ),
                  ],
                  Gap(spacing.s4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: spacing.s14,
                        color: color.text.secondary,
                      ),
                      Gap(spacing.s4),
                      Expanded(
                        child: Text(
                          location,
                          style: textStyle.bodyMedium.copyWith(
                            color: color.text.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: spacing.s8,
                vertical: spacing.s4,
              ),
              decoration: BoxDecoration(
                color: color.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(
                  context.dimensions.radius.r20,
                ),
              ),
              child: Text(
                shiftName.toUpperCase(),
                style: textStyle.labelSmall.copyWith(
                  color: color.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
